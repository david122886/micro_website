/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
$(function() {
    $("#form_view_btn").click(function(){
        $("#form_view").hide();
    });

});

function tishi_alert(message){
    $(".alert_h").html(message);
    var scolltop = document.body.scrollTop|document.documentElement.scrollTop;
    var win_height = document.documentElement.clientHeight;//jQuery(document).height();
    var z_layer_height = $(".tab_alert").height();
    $(".tab_alert").css('top',(win_height-z_layer_height)/2 + scolltop);
    var doc_width = $(document).width();
    var layer_width = $(".tab_alert").width();
    $(".tab_alert").css('left',(doc_width-layer_width)/2);
    $(".tab_alert").css('display','block');
    jQuery('.tab_alert').fadeTo("slow",1);
    $(".tab_alert .close").click(function(){
        $(".tab_alert").css('display','none');
    })
    setTimeout(function(){
        jQuery('.tab_alert').fadeTo("slow",0);
    }, 4000);
    setTimeout(function(){
        $(".tab_alert").css('display','none');
    }, 4000);

}

function submit_form(obj,action_url){
    var flag = true;
    var token = $('.authenticity_token').val();
    $(obj).parents(".submit_form_static").find('.questionTitle').each(function(){
        var title = $(this).text();
        var insert = $(this).parents(".insertBox");
        var type = insert.find("input.newNameClass");

        if(type.attr('type')=="text"){
            if($.trim(type.val()) == ""){
                alert(title + "不能为空")
                flag = false;
            }else{
                flag = true;
            }
        }else{
            if(insert.find("input:checked").length == 0){
                alert(title + "不能为空")
                flag = false;
            }else{
                flag = true;
            }
        }
    });
    if(flag){
        //$(obj).parents(".submit_form_static").submit();

        $.ajax({
            url: action_url,
            type: "POST",
            dataType: "script",

            data:{authenticity_token: token},
            success:function(data){   
                 $("#the_content").html("提交成功！");
                 $("#form_view").show();
            },
            error:function(data){
            //alert("error")
            }
        })
        
    }
}
