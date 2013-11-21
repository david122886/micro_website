#encoding: utf-8
class PagesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:submit_queries, :static]
  layout 'sites'
  before_filter :get_site
  PUBLIC_PATH =  Rails.root.to_s + "/public/allsites"
  #主页 index
  def index
    @page = @site.pages.main.first
    if @page
      index_html = File.new((PUBLIC_PATH + @page.path_name), 'r')
      @index = index_html.read
      index_html.close
      render :edit
    else
      @page = Page.new
      render :new
    end
  end

  #新建page
  def create
    content = params[:page][:content]
    params[:page].delete(params[:page][:content]) if params[:page][:content]
    params[:page][:element_relation] = form_ele_hash(params[:form]) if params[:form]
    Page.transaction do
      @page = @site.pages.create(params[:page])
      if @page.save
        unless @page.main?
          content = modifyContent(@page, content, @site.id)
        end
        save_into_file(content, @page) if content
        @notice = "新建成功!"
        @path = redirect_path(@page, @site)
        render :success
      else
        @notice="新建失败！ #{@page.errors.messages.values.flatten.join("\\n")}"
        render :fail
      end
    end
  end

  #更新page
  def update
    content = params[:page][:content]
    params[:page].delete(params[:page][:content]) if params[:page][:content]
    params[:page][:element_relation] = form_ele_hash(params[:form]) if params[:form]
    @page = Page.find_by_id params[:id]
    if @page && @page.update_attributes(params[:page])
      unless @page.main?
        content = modifyContent(@page, content, @site.id) if content
      end
      save_into_file(content, @page) if content
      @notice = "更新成功!"
      @path = redirect_path(@page, @site)
      render :success
    else
      @notice="更新失败！ #{@page.errors.messages.values.flatten.join("\\n")}"
      render :fail
    end
  end

  #删除页面，表单或者子页
  def destroy
    Page.transaction do
      @page = Page.find_by_id params[:id]
      if @page.destroy
        File.delete PUBLIC_PATH + @page.path_name if File.exists?(PUBLIC_PATH + @page.path_name)
        redirect_to redirect_path(@page, @site)
      else
        
      end
    end
  end

  #子页 index
  def sub
    @sub_pages = @site.pages.sub.paginate(:page=>params[:page],:per_page=>10)
    render "/pages/sub/sub"
  end

  #子页 new
  def sub_new
    @page = Page.new
    render "/pages/sub/sub_new"
  end

  #子页 edit
  def sub_edit
    @page = Page.find_by_id params[:id]
    index_html = File.new((PUBLIC_PATH + @page.path_name), 'r')
    @index = index_html.read
    index_html.close
    render "/pages/sub/sub_edit"
  end

  #样式index
  def style
    @page = @site.pages.style.first
    if @page
      index_html = File.new((PUBLIC_PATH + @page.path_name), 'r')
      @index = index_html.read
      index_html.close
      render :edit
    else
      @page = Page.new
      render "/pages/style/style_new"
    end
  end

  #表单 index
  def form
    @forms = @site.pages.form.includes(:form_datas).paginate(:page=>params[:page],:per_page=>1)
    render "/pages/form/form"
  end

  #子页 new
  def form_new
    @page = Page.new
    render "/pages/form/form_new"
  end

  #子页 edit
  def form_edit
    @page = Page.find_by_id params[:id]
    index_html = File.new((PUBLIC_PATH + @page.path_name), 'r')
    @index = index_html.read
    index_html.close
    render "/pages/form/form_edit"
  end

  #子页、表单的访问控制
  def if_authenticate
    @page = Page.find_by_id params[:id]
  end

  #页面编辑时预览
  def preview
    @content = params[:page][:content]
    render :layout => false
  end

  #表单预览
  def form_preview
    @content = params[:page][:content]
    @title = params[:page][:title]
    render "/pages/form/preview", :layout => false
  end

  #通用表单提交
  def submit_queries
    page = Page.find_by_id params[:id]
    FormData.transaction do
      if current_user
        page.form_datas.create(:data_hash => params[:form], :user_id => current_user.id)
        redirect_to "/#{@site.root_path}/index.html"
      else
        if page.authenticate?
          flash[:notice] = "请先登陆！"
          redirect_to '/signin'
        else
          page.form_datas.create(:data_hash => params[:form], :user_id =>nil )
          redirect_to "/#{@site.root_path}/index.html"
        end
      end
    end
  end

  #访问静态页面
  def static
    path_name = params[:path_name]
    page = Page.find_by_path_name("/"+path_name)
    if page
      site = page.site
      #if site.status == Site::STATUS_NAME[:pass_verified]
        if page.authenticate? && page.sub? && !user_signed_in?
          redirect_to '/signin'
        else
          render PUBLIC_PATH + "/"+ path_name, :layout => false
        end
      #else
       # redirect_to '/303.html', :layout => false
      #end
    else
      render Rails.root.to_s + '/public/404.html', :layout => false
    end
  end


  #get form authenticity_token  hack of CSRF
  def get_token
    render :text => form_authenticity_token
  end

  protected
  
  def redirect_path(page, site)
    if page.main?
      site_pages_path(site)
    elsif page.sub?
      sub_site_pages_path(@site)
    elsif page.form?
      form_site_pages_path(@site)
    end
  end
end