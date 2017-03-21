<@ms.html5>
	<@ms.panel>
		<@ms.nav title="公众号列表"></@ms.nav>
		<!--使用bootstrap-table的toolbar添加按钮-->
		<div id="toolbar">
			<!--列表操作按钮，添加和删除 开始 -->
			<@ms.panelNavBtnGroup>
				<@ms.panelNavBtnAdd id="addButton" value="" /><!-- 新增按钮 -->
				<@ms.panelNavBtnDel id="delButton" value="" /><!-- 删除按钮 -->
			</@ms.panelNavBtnGroup>		
			<!--列表操作按钮，添加和删除结束 -->
		</div>
		<!--微信列表-->
		<table id="weixinListTable"
			data-show-refresh="true"
	        data-show-columns="true"
	        data-show-export="true"
			data-method="post" 
			data-detail-formatter="detailFormatter" 
			data-pagination="true"
			data-page-size="1"
			data-side-pagination="server">
		</table>	
	</@ms.panel>
</@ms.html5>
<@ms.modal  modalName="delWeixinModal" title="删除微信" >
	<@ms.modalBody>
		删除微信
	</@ms.modalBody>
	<@ms.modalButton>
		<!--模态框按钮组-->
		<@ms.button  value="确认删除？"  id="deleteWeixin"  />
	</@ms.modalButton>
</@ms.modal>
<script>
	$(function(){
		$("#weixinListTable").bootstrapTable({
        	url:"${managerPath}/weixin/list.do",
        	contentType : "application/x-www-form-urlencoded",
        	queryParamsType : "undefined",
        	toolbar:"#toolbar",
        	queryParams:function(params) {
				return  $.param(params)+"&pageNo="+params.pageNumber+"&pageSize="+params.pageSize;
			},
			columns: [{checkbox:'true'},
			{
				align:'center',
			   	field: 'weixinId',
			    title: '编号'
			}, {
			    align:'center',
			    field: 'weixinNo',
			    title: '微信号'
			},{
			    align:'center',
			    field: 'weixinName',
			    title: '公众号名称',
			    formatter:function(value,row,index){return"	<a class='btn btn-xs red tooltips editWeixin' data-id=" + row.weixinId + ">" + row.weixinName + "</a>"}
			}, {
			    align:'center',
			    field: 'weixinType',
			    title: '公众号类型',
			    formatter:function(value,row,index){
			    	if(row.weixinType == 0){
			    		return "服务号";
			    	}
			    	else if(row.weixinType == 1){
			    		return "订阅号";
			    	}
			   }
			},{
			    align:'center',
			    field: 'weixinToken',
			    title: '微信token'
			},{
				align:'center',
				field: 'weixinOauthUrl',
			    title: '网页2.0授权地址'
			}]
        });
    })
	//新增微信
	$("#addButton").click(function(){
		location.href = "${managerPath}/weixin/add.do"; 	
	})
	//判断打开删除模态框条件
	$("#delButton").click(function(){
		//获取checkbox选中的数据
		var rows = $("#weixinListTable").bootstrapTable("getSelections");
		//没有选中checkbox
		if(rows.length <= 0){
			 $('.ms-notifications').offset({top:43}).notify({
    		    type:'warning',
			    message: { text:'请选择删除的微信'}
			 }).show();
		//点击全选，但是列表为空
		}else if(rows.length == 0){
			$('.ms-notifications').offset({top:43}).notify({
    		    type:'warning',
			    message: { text:'没有可删除的微信'}
			 }).show();
		}else{
			$(".delWeixinModal").modal();
		}
	});
	//批量删除
	$("#deleteWeixin").click(function(){
		var weixinIds = [];
		var rows = $("#weixinListTable").bootstrapTable("getSelections");
		for(var i = 0;i<rows.length;i++){
			weixinIds[i] = rows[i].weixinId;
		}
		$(this).text("努力删除中...")
		$(this).attr("disabled","true");
		$.ajax({		
		    type:"GET",
			url:"${managerPath}/weixin/delete.do",
		    data:"weixinIds="+weixinIds,
		    success:function(msg) { 
				if(msg.result == true) {
					$('.ms-notifications').offset({top:43}).notify({
		    		    type:'success',
					    message: { text:'删除成功'}
					 }).show();
				}else{
					$('.ms-notifications').offset({top:43}).notify({
		    		    type:'fail',
					    message: { text:'删除失败'}
					 }).show();
				}
				location.reload();
			}
		});	
	})
    $("body").delegate(".editWeixin","click",function(){
    	var weixinId = $(this).attr("data-id");
    	location.href="${managerPath}/weixin/"+weixinId+"/function.do";
    })
</script>