<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	HttpSession my_session = request.getSession();
	String user_id = (String)my_session.getAttribute("USER_ID");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>KMM TMS</title>
<jsp:include page="../head.jsp" flush="false" />
<script type="text/javascript">
if('null' == '<%=user_id%>'){
	alert('LOGIN!!');
	parent.CloseDialog(0);	//세션 끊겼을때 로그인 을 모달 창에서 해서.. 세션 끊기면 로그인전 모달창 닫게함
	location.href = '/';
}
//console.log('<%=user_id%>');

$(document).ready(function(){
	
	var cartype = getQuerystring('CarType')
	var toolid = getQuerystring('ToolID');
	var toolserial = getQuerystring('ToolSerial');
	var jobno = getQuerystring('JobNo');
	
	$("#btnSave").button();
	$("#btnModify").button();
	$("#btnDelete").button();
	$("#btnReset").button();
	$("#btnClose").button();
            
	Init();
	
	$("#btnSave").click(function(e) {
        if ($("#ddlTool").val() == "-1" || $("#ddlTool").val() == "" ) {
            e.preventDefault();
            //var retVal = fn_DisplayMessage("ST02.SelectToolID", "R");
            var retVal = '<spring:message code="ST02.SelectToolID"/>';
            $("#divMessage").text(retVal);
            $("#ddlTool").focus();
        } else if ($("#ddlCarType").val() == "-1" || $("#ddlCarType").val() == "" ) {
            e.preventDefault();
            //var retVal = fn_DisplayMessage("ST02.SelectCarType", "R");
            var retVal = '<spring:message code="ST02.SelectCarType"/>';
            $("#divMessage").text(retVal);
            $("#ddlCarType").focus();
        } else if ($("#txtJobNo").val() == "") {
            e.preventDefault();
            //var retVal = fn_DisplayMessage("ST02.EnterJobNo", "R");
            var retVal = '<spring:message code="ST02.EnterJobNo"/>';
            $("#divMessage").text(retVal);
            $("#txtJobNo").focus();
        } else if ($("#ddlCondFlag").val() == "Y" && $("#txtCondExpression").val() == "") {
            e.preventDefault();
            //var retVal = fn_DisplayMessage("ST02.EnterCondExpression", "R");
            var retVal = '<spring:message code="ST02.EnterCondExpression"/>';
            $("#divMessage").text(retVal);
            $("#txtCondExpression").focus();
        } else {
            //e.preventDefault();
            //var msg = fn_DisplayMessage("COMMON.ConfirmInsert", "R");
            var msg = '<spring:message code="COMMON.ConfirmInsert"/>';
            if(confirm(msg)){
            	
            	var body = {
            			
            			plant_cd 			: $('#ddlPlant').val(),
            			car_type			: $('#ddlCarType').val(),
            			device				: $('#ddlTool').val(),
            			device_id			: '',
            			device_serial		: '',
            			job_num				: $('#txtJobNo').val(),
            			cond_use_flg		: $('#ddlCondFlag').val(),
            			repair_job_num		: $('#txtRepairJobNo').val(),
            			total_batch_num		: $('#txtTotBatchNo').val(),
            			torque_low			: $('#txtTorqLowVal').val(),
            			torque_ok			: $('#txtTorqOkVal').val(),
            			torque_high			: $('#txtTorqHighVal').val(),
            			angle_low			: $('#txtAnglLowVal').val(),
            			angle_ok			: $('#txtAnglOkVal').val(),
            			angle_high			: $('#txtAnglHighVal').val(),
            			reg_user_id 		: '' ,
            			condition_exp		: $('#this.txtCondExpression').val(),
            			repair_batch_num	: $('#txtRepBatchNo').val()
            	}
            	
            	$.ajax({
        			type : "POST",
        			url : '/api/setting/insertjobno',
        			data : JSON.stringify(body),
        			headers: { 
        				'Accept': 'application/json',
        				'Content-Type': 'application/json' 
        			}
        		}).done(function(result) {
        			//console.log(result);
        			if(result.result == 200){
        				var retVal = '<spring:message code="COMMON.Success"/>';
        	            $("#divMessage").text(retVal);
        			}else if( result.result == 300){
        				var retVal = '<spring:message code="COMMON.RegisteredID"/>';
        	            $("#divMessage").text(retVal);
        			}
        			
        		}).fail(function(data) {
        			var retVal = '<spring:message code="COMMON.OccurredError"/>';
                    $("#divMessage").text(retVal);
        		});
            }
        }
    });
	
    $("#btnModify").click(function(e) {
        //var msg = fn_DisplayMessage("COMMON.ConfirmUpdate", "R");
        var msg = '<spring:message code="COMMON.ConfirmUpdate"/>';
        if ( confirm(msg)){
        }
    });

    $("#btnDelete").click(function(e) {
        //var msg = fn_DisplayMessage("COMMON.ConfirmDelete", "R");
        var msg = '<spring:message code="COMMON.ConfirmDelete"/>';
        if ( confirm(msg)){
        
        	var params = "?plant_cd="+$('#ddlPlant').val()+
    		"&tool_id="+toolid+
    		"&tool_serial="+toolserial;
        
        	$.ajax({
    			type : "DELETE",
    			url : '/api/setting/deletetoolid'+params,
    		}).done(function(result) {
    			//console.log(result);
    			if(result.result == 200){
    				var retVal = '<spring:message code="COMMON.Success"/>';
    	            $("#divMessage").text(retVal);
    			}else if( result.result == 300){
    				var retVal = '<spring:message code="COMMON.OccurredError"/>';
    	            $("#divMessage").text(retVal);
    			}
    			
    		}).fail(function(data) {
    			var retVal = '<spring:message code="COMMON.OccurredError"/>';
                $("#divMessage").text(retVal);
    		});
        }
    });

    $("#btnReset").click(function(e) {
        form1.reset();
        $("#divMessage").text('');
        e.preventDefault();
    });

    $("#btnClose").click(function(e) {
        e.preventDefault();
        parent.CloseDialog(0);
    });
    
});

		
function Init(){
	
	$.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
	getPlant();
	getCarType('S');
	getJobNoToolP01('S');
	
	getUseFlag('ddlCondFlag','');
	
	
	$.ajaxSetup({async:true});	//비동기 켜기
	
    $("#btnSave").show();
	$("#btnModify").hide();
	$("#btnDelete").hide();
} 

function LoadInfo(toolid,toolserial){
	
	//$('#ddlStnType').val("N");
	
	var params = "tool_id="+toolid+
	"&tool_serial="+toolserial;
	
	/*
	$.ajax({
		url:'/api/setting/gettoolinfo?'+params,
		type:'GET',
		async:false,
		success: function(data) {
			if(data.length > 0){
				$('#ddlPlant').val(data[0].plant_cd);
				//$('#ddlStnType').val(data[0].stn_gub);	
				$('#ddlStnType').val("N");
			}
		},
		error:function(e){  
			alert(e.responseText);
        }  
		
	});
		*/
	
	$.get('/api/setting/gettoolinfo?'+params,function(data){
		console.log(data);
		if(data.length > 0){
			$('#ddlPlant').val(data[0].plant_cd.trim());
			$('#ddlStnType').val(data[0].stn_gub.trim());	
			$('#txtToolGrp').val(data[0].device_grp_cd.trim());
			$('#ddlLine').val(data[0].line_cd.trim());
			
			$('#txtToolName').val(data[0].device_nm.trim());
			$('#txtToolAlias').val(data[0].device_alias.trim());
			
			$('#ddlToolType').val(data[0].device_type.trim());
			$('#ddlSerialParallelFlag').val(data[0].serial_parallel_flg.trim());
			
			$('#txtToolIP').val(data[0].device_ip.trim());
			$('#txtToolPort').val(data[0].device_port.trim());
			
			$('#ddlCompToolFlag').val(data[0].completed_device_flg.trim());
			$('#ddlSendJobNo').val(data[0].jobno_send_flg.trim());
			 
			$('#txtTorqLowVal').val(data[0].torque_low.trim());
			$('#txtAnglLowVal').val(data[0].angle_low.trim());
			
			$('#txtTorqOkVal').val(data[0].torque_ok.trim());
			$('#txtAnglOkVal').val(data[0].angle_ok.trim());
			$('#txtTorqHighVal').val(data[0].torque_high.trim()); 
			$('#txtAnglHighVal').val(data[0].angle_high.trim());
			
			$('#ddlWebDispFlag').val(data[0].web_display_flg.trim());
			$('#ddlResetJobNo').val(data[0].scan_jobreset_flg.trim());
			$('#ddlShowValueType').val(data[0].show_value_type.trim());
		}
	})
	
}
</script>
</head>
<body>
    <form id="form1">
    <div class="panel">
        <div>
            <table width="100%" align="center" class="table table-bordered">
                    <tr>
                        <td width="25%" class="td-title"><spring:message code="COMMON.Plant"/></td>
                        <td width="25%"><select id="ddlPlant"></select></td>
                        <td width="20%" class="td-title"><spring:message code="COMMON.Tool"/></td>
                        <td width="35%"><select id="ddlTool"></select></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="COMMON.CarType"/></td>
                        <td ><select id="ddlCarType"></select></td>
                        <td class="td-title"><spring:message code="ST02.JobNo"/></td>
                        <td ><input id="txtJobNo" type="text" Width="40%" MaxLength="5"></td>                     
                    </tr>
                     <tr>
                        <td  class="td-title"><spring:message code="ST02.RepairJobNo"/><!-- <asp:Label ID="lblRepairJobNo" runat="server" Text="ST02.RepairJobNo"></asp:Label> --></td>
                        <td ><input id="txtRepairJobNo" type="text" Width="40%" MaxLength="5"></td>
                        <td  class="td-title"><spring:message code="ST02.TotBatchNo"/><!-- <asp:Label ID="lblTotBatchNo" runat="server" Text="ST02.TotBatchNo"></asp:Label> --></td>
                        <td ><input id="txtTotBatchNo" type="text" Width="40%" MaxLength="2"><!-- <asp:TextBox ID="txtTotBatchNo" runat="server" Width="40%" MaxLength="2"></asp:TextBox> --></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="ST01.TorqLowVal"/><!-- <asp:Label ID="lblTorqLowVal" runat="server" Text="ST01.TorqLowVal"></asp:Label> --></td>
                        <td ><input id="txtTorqLowVal" type="text" Width="40%" onkeypress="fn_NumKey()"><!-- <asp:TextBox ID="txtTorqLowVal" runat="server" Width="40%" onkeypress="fn_NumKey()"></asp:TextBox> --></td>
                        <td class="td-title"><spring:message code="ST01.AnglLowVal"/><!-- <asp:Label ID="lblAnglLowVal" runat="server" Text="ST01.AnglLowVal"></asp:Label> --></td>
                        <td><input id="txtAnglLowVal" type="text" Width="40%"onkeypress="fn_NumKey()"><!-- <asp:TextBox ID="txtAnglLowVal" runat="server" Width="40%" onkeypress="fn_NumKey()"></asp:TextBox> --></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="ST01.TorqOkVal"/><!-- <asp:Label ID="lblTorqOkVal" runat="server" Text="ST01.TorqOkVal"></asp:Label> --></td>
                        <td ><input id="txtTorqOkVal" type="text" Width="40%" onkeypress="fn_NumKey()"><!-- <asp:TextBox ID="txtTorqOkVal" runat="server" Width="40%" onkeypress="fn_NumKey()"></asp:TextBox> --></td>
                        <td class="td-title"><spring:message code="ST01.AnglOkVal"/><!-- <asp:Label ID="lblAnglOkVal" runat="server" Text="ST01.AnglOkVal"></asp:Label> --></td>
                        <td><input id="txtAnglOkVal" type="text" Width="40%" onkeypress="fn_NumKey()"><!-- <asp:TextBox ID="txtAnglOkVal" runat="server" Width="40%" onkeypress="fn_NumKey()"></asp:TextBox> --></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="ST01.TorqHighVal"/><!-- <asp:Label ID="lblTorqHighVal" runat="server" Text="ST01.TorqHighVal"></asp:Label> --></td>
                        <td ><input id="txtTorqHighVal" type="text" Width="40%" onkeypress="fn_NumKey()"><!-- <asp:TextBox ID="txtTorqHighVal" runat="server" Width="40%" onkeypress="fn_NumKey()"></asp:TextBox> --></td>
                        <td class="td-title"><spring:message code="ST01.AnglHighVal"/><!-- <asp:Label ID="lblAnglHighVal" runat="server" Text="ST01.AnglHighVal"></asp:Label> --></td>
                        <td><input id="txtAnglHighVal" type="text" Width="40%" onkeypress="fn_NumKey()"><!-- <asp:TextBox ID="txtAnglHighVal" runat="server" Width="40%" onkeypress="fn_NumKey()"></asp:TextBox> --></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="ST01.CondFlag"/><!-- <asp:Label ID="lblCondFlag" runat="server" Text="ST01.CondFlag"></asp:Label> --></td>
                        <td><select id="ddlCondFlag"></select><!-- <asp:DropDownList ID="ddlCondFlag" runat="server" AutoPostBack="true"
                                onselectedindexchanged="ddlCondFlag_SelectedIndexChanged"></asp:DropDownList> --></td>
                        <td  class="td-title"><spring:message code="ST02.RepBatchNo"/><!-- <asp:Label ID="lblRepBatchNo" runat="server" Text="ST02.RepBatchNo"></asp:Label> --></td>
                        <td ><input id="txtAnglHighVal" type="text" Width="40%"  MaxLength="2"><!-- <asp:TextBox ID="txtRepBatchNo" runat="server" Width="40%" MaxLength="2"></asp:TextBox> --></td>
                     </tr>
            </table>
            <div align="center" style="margin-top:10px;">
            <c:set var="btnSave"><spring:message code="BUTTON.Save"/></c:set>
			<input type="button" id="btnSave" value="${btnSave}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button" >
			
			<c:set var="btnModify"><spring:message code="BUTTON.Modify"/></c:set>
			<input type="button" id="btnModify" value="${btnModify}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button" >
			
			<c:set var="btnDelete"><spring:message code="BUTTON.Delete"/></c:set>
			<input type="button" id="btnDelete" value="${btnDelete}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button" >
			
			<c:set var="btnReset"><spring:message code="BUTTON.Reset"/></c:set>
			<input type="button" id="btnReset" value="${btnReset}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button" >
			
			<c:set var="btnClose"><spring:message code="BUTTON.Close"/></c:set>
			<input type="button" id="btnClose" value="${btnClose}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button" >
            </div>
            <hr style="margin-top:10px;margin-bottom:10px;"  />
            <div>
            	<div style='display:inline;' id="divMessage" class="font-red"></div>
            </div>
            <hr style="margin-top:5px;margin-bottom:10px;" />
        </div>
    </div>
    </form>
    
</body>
</html>