#encoding: utf-8
class UsersController < ApplicationController
   # before_action :set_user ,only: [:disable,:delete]

  def index
    puts 'index..................................................................'
    puts params
    
     case params[:type]
     when '1' then @type=1; @users=User.paginate(:page=>params[:page],:per_page=>1);
     when '2' then @type=2; @sites=Site.paginate(:page=>params[:page],:per_page=>1,:conditions => "status=3") #待审核
     when '3' then @type=3; @sites=Site.paginate(:page=>params[:page],:per_page=>1,:conditions => "status=4")  #审核通过 
     when '4' then @type=4; @sites=Site.paginate(:page=>params[:page],:per_page=>1,:conditions => "status=5") #审核不通过
     end 
    
    
    
    render 'index'
  end
  
  
  
  def disable
    # puts 'disable.....................................'
    set_user
    
    if @user.update_attribute(:name,'modify') 
       
       flash[:msg]='success!'      
    else      
       flash[:msg]='error!'    
    end
       redirect_to '/user/manage/1'
  end
  
  
  
  
  def delete
    # puts 'delete........................................'
    set_user
    if @user.destroy
      flash[:msg]='success!'
    else
      flash[:msg]='error!'
      
    end
    redirect_to '/user/manage/1'
    
  end
  
  
  
  def set_user  
     @user=User.find(params[:uid])
  end
  
  
  
end