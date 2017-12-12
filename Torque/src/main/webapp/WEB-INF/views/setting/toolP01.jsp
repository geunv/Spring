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
	//parent.location.reload();
	location.href = '/';
}
//console.log('<%=user_id%>');

<%
	String tool = request.getParameter("ToolID");
%>


$(document).ready(function(){
	
	var toolid = getQuerystring('ToolID')
	var toolserial = getQuerystring('ToolSerial');
	<%-- var toolid = <% request.getParameter("ToolID"); %>
	var toolserial = <% request.getParameter("ToolSerial"); %> --%>
	//console.log(toolid +'^'+ toolserial);
	
	$("#btnSave").button();
	$("#btnModify").button();
	$("#btnDelete").button();
	$("#btnReset").button();
	$("#btnClose").button();
            
	Init();
	
	if ( toolid.length > 0 ){
		$('#txtToolID').val(toolid);
		$('#txtToolID').attr("disabled",true);
		$('#txtToolSerial').val(toolserial);
		//$('#txtToolSerial').attr("readonly",true);
		$('#txtToolSerial').attr("disabled",true);
		$('#ddlPlant').attr("disabled",true);
		
		LoadInfo(toolid,toolserial);
		
		$("#btnSave").hide();
		$("#btnModify").show();
		$("#btnDelete").show();
	}
	
	$("#btnSave").click(function(e) {  
        if ($("#ddlStnType").val() == "") {
            e.preventDefault();
            var retVal = '<spring:message code="COMMON.SelectStnType"/>';
            $("#divMessage").text(retVal);
            $("#ddlStnType").focus();
        } else if ($("#txtToolID").val() == "") {
            e.preventDefault();
            var retVal = '<spring:message code="ST01.EnterToolID"/>';
            $("#divMessage").text(retVal);
            $("#txtToolID").focus();
        } else if ($("#txtToolSerial").val() == "") {
            e.preventDefault();
            var retVal = '<spring:message code="ST01.EnterToolSerial"/>';
            $("#divMessage").text(retVal);
            $("#txtToolSerial").focus();
        } else {
            //e.preventDefault();
            var msg = '<spring:message code="COMMON.ConfirmInsert"/>';
            if (confirm(msg)){
            	
            	//$.post('/api/setting/inserttoolid',$('#form1').serialize(),function(data){
            	/* $.post('/api/login',$('#form1').serialize(),function(data){
            		if(data.result == 200){
            			alert("sussces");
            		}else{
            			alert("fail");
            		}
            	}); */
            	
            	var body = {
            			plant_cd 			: $('#ddlPlant').val(),
            			stn_gub				: $('#ddlStnType').val(),
            			device_id			: $('#txtToolID').val(),
            			device_serial		: $('#txtToolSerial').val(),
            			device_grp_cd		: $('#txtToolGrp').val(),
            			line_cd				: $('#ddlLine').val(),
            			device_nm			: $('#txtToolName').val(),
            			device_alias		: $('#txtToolAlias').val(),
            			device_type			: $('#ddlToolType').val(),
            			serial_parallel_flg	: $('#ddlSerialParallelFlag').val(),
            			device_ip			: $('#txtToolIP').val(),
            			device_port			: $('#txtToolPort').val(),
            			completed_device_flg: $('#ddlCompToolFlag').val(),
            			jobno_send_flg		: $('#ddlSendJobNo').val(),
            			torque_low			: $('#txtTorqLowVal').val(),
            			angle_low			: $('#txtAnglLowVal').val(),
            			torque_ok			: $('#txtTorqOkVal').val(),
            			angle_ok			: $('#txtAnglOkVal').val(),
            			torque_high			: $('#txtTorqHighVal').val(),
            			angle_high			: $('#txtAnglHighVal').val(),
            			web_display_flg		: $('#ddlWebDispFlag').val(),
            			scan_jobreset_flg	: $('#ddlResetJobNo').val(),
            			reg_user_id 		: '' ,
            			show_value_type		: $('#ddlShowValueType').val()
            	}
            	
            	$.ajax({
        			type : "POST",
        			url : '/api/setting/inserttoolid',
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
        
        	var params = "?plant_cd="+$('#ddlPlant').val()+
        		"&tool_id="+toolid+
        		"&tool_serial="+toolserial;
        	
        	
        	var body = {
        			//plant_cd 			: $('#ddlPlant').val(),
        			stn_gub				: $('#ddlStnType').val(),
        			//device_id			: $('#txtToolID').val(),
        			//device_serial		: $('#txtToolSerial').val(),
        			device_grp_cd		: $('#txtToolGrp').val(),
        			line_cd				: $('#ddlLine').val(),
        			device_nm			: $('#txtToolName').val(),
        			device_alias		: $('#txtToolAlias').val(),
        			device_type			: $('#ddlToolType').val(),
        			serial_parallel_flg	: $('#ddlSerialParallelFlag').val(),
        			device_ip			: $('#txtToolIP').val(),
        			device_port			: $('#txtToolPort').val(),
        			completed_device_flg: $('#ddlCompToolFlag').val(),
        			jobno_send_flg		: $('#ddlSendJobNo').val(),
        			torque_low			: $('#txtTorqLowVal').val(),
        			angle_low			: $('#txtAnglLowVal').val(),
        			torque_ok			: $('#txtTorqOkVal').val(),
        			angle_ok			: $('#txtAnglOkVal').val(),
        			torque_high			: $('#txtTorqHighVal').val(),
        			angle_high			: $('#txtAnglHighVal').val(),
        			web_display_flg		: $('#ddlWebDispFlag').val(),
        			scan_jobreset_flg	: $('#ddlResetJobNo').val(),
        			reg_user_id 		: '' ,
        			show_value_type		: $('#ddlShowValueType').val()
        			}
        	
        	$.ajax({
    			type : "PUT",
    			url : '/api/setting/updatetoolid'+params,
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
    				var retVal = '<spring:message code="COMMON.OccurredError"/>';
    	            $("#divMessage").text(retVal);
    			}
    			
    		}).fail(function(data) {
    			var retVal = '<spring:message code="COMMON.OccurredError"/>';
                $("#divMessage").text(retVal);
    		});        
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
	
	//$.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
	getPlant();
	getStnType('S');
	getLine('S');
	getToolType('S');
	getToolP01();
	//getUseFlag('S');
	//$.ajaxSetup({async:true});	//비동기 켜기
	
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


function getToolP01(){
	
	$.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
	
	getUseFlag('ddlCompToolFlag','S');
	
	getUseFlag('ddlWebDispFlag','S');
	$('#ddlWebDispFlag').val('N');
	
	getUseFlag('ddlSendJobNo','S');
	$('#ddlSendJobNo').val('N');
	
	getUseFlag('ddlResetJobNo','S');
	$('#ddlResetJobNo').val('N');
	
	getUseFlag('ddlShowValueType','S');
	$.ajaxSetup({async:true});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
	
}
</script>
</head>
<body>
    <form id="form1">
    <div class="panel">
        <div>
            <table width="100%" align="center" class="table table-bordered">
                    <tr>
                        <td width="20%" class="td-title"><spring:message code="COMMON.Plant"/></td>
                        <td width="30%"><select id="ddlPlant"></select></td>
                        <td width="20%" class="td-title"><spring:message code="COMMON.StnType"/></td>
                        <td width="30%"><select id="ddlStnType"></select></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="ST01.Tool"/></td>
                        <td ><input name="txtToolID" type="text" id="txtToolID" Width="90%" MaxLength="10"></td>
                        <td  class="td-title"><spring:message code="ST01.ToolSerial"/></td>
                        <td ><input name="txtToolSerial" type="text" id="txtToolSerial" Width="40" MaxLength="1"></td>                        
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="ST01.ToolGrp"/></td>
                        <td ><input id="txtToolGrp" type="text" Width="38%" MaxLength="4"><!-- <asp:TextBox ID="txtToolGrp" runat="server" Width="38%" MaxLength="4"></asp:TextBox> --></td>
                        <td  class="td-title"><spring:message code="COMMON.Line"/><!-- <asp:Label ID="lblLine" runat="server" Text="COMMON.Line"></asp:Label> --></td>
                        <td ><select id="ddlLine" Width="90%"></select>
                            <!-- <asp:DropDownList ID="ddlLine" runat="server" Width="90%"></asp:DropDownList> -->
                        </td>
                     </tr>
                     <tr>
                        <td  class="td-title"><spring:message code="ST01.ToolName"/><!-- <asp:Label ID="lblToolName" runat="server" Text="ST01.ToolName"></asp:Label> --></td>
                        <td ><input id="txtToolName" type="text" Width="90%"><!-- <asp:TextBox ID="txtToolName" runat="server" Width="90%"></asp:TextBox> --></td>
                        <td  class="td-title"><spring:message code="ST01.ToolAlias"/><!-- <asp:Label ID="lblToolAlias" runat="server" Text="ST01.ToolAlias"></asp:Label> --></td>
                        <td ><input id="txtToolAlias" type="text" Width="90%"><!-- <asp:TextBox ID="txtToolAlias" runat="server" Width="90%"></asp:TextBox> --></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="ST01.ToolType"/><!-- <asp:Label ID="lblToolType" runat="server" Text="ST01.ToolType"></asp:Label> --></td>
                        <td ><select id="ddlToolType" Width="90%"></select>
                            <!-- <asp:DropDownList ID="ddlToolType" runat="server" Width="90%"></asp:DropDownList> -->
                        </td>
                        <td  class="td-title"><spring:message code="ST01.SerialParallelFlag"/><!-- <asp:Label ID="lblSerialParallelFlag" runat="server" Text="ST01.SerialParallelFlag"></asp:Label> --></td>
                        <td >
                        	<select id="ddlSerialParallelFlag" Width="90%">
                        		<option value="">Select</option>
                        		<option value="S">S:Serial</option>
                        		<option value="P">P:Parallel</option>	
                        	</select>
                            <!-- <asp:DropDownList ID="ddlSerialParallelFlag" runat="server" Width="90%">
                                <asp:ListItem Text="Select" Value="-1"></asp:ListItem>
                                <asp:ListItem Text="S:Serial" Value="S"></asp:ListItem>
                                <asp:ListItem Text="P:Parallel" Value="P"></asp:ListItem>
                            </asp:DropDownList> -->
                        </td>
                    </tr>
                    <img src="/images/ajax-loader.gif" style="display:none;" id="load-image"/>
                    <tr>
                        <td  class="td-title"><spring:message code="ST01.ToolIP"/><!-- <asp:Label ID="lblToolIP" runat="server" Text="ST01.ToolIP"></asp:Label> --></td>
                        <td ><input id="txtToolIP" type="text" Width="90%"><!-- <asp:TextBox ID="txtToolIP" runat="server" Width="90%"></asp:TextBox> --></td>
                        <td class="td-title"><spring:message code="ST01.ToolPort"/><!-- <asp:Label ID="lblToolPort" runat="server" Text="ST01.ToolPort"></asp:Label> --></td>
                        <td><input id="txtToolPort" type="text" Width="90%" MaxLength="4" onkeypress="fn_NumKey()"><!-- <asp:TextBox ID="txtToolPort" runat="server" Width="90%" MaxLength="4" onkeypress="fn_NumKey()"></asp:TextBox> --></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="ST01.CompToolFlag"/><!-- <asp:Label ID="lblCompToolFlag" runat="server" Text="ST01.CompToolFlag"></asp:Label> --></td>
                        <td ><select id="ddlCompToolFlag"></select><!-- <asp:DropDownList ID="ddlCompToolFlag" runat="server"></asp:DropDownList> --></td>
                        <td  class="td-title"><spring:message code="ST01.SendJobNoFlag"/><!-- <asp:Label ID="lblSenJobNoFlag" runat="server" Text="ST01.SendJobNoFlag"></asp:Label> --></td>
                        <td ><select id="ddlSendJobNo"></select><!-- <asp:DropDownList ID="ddlSendJobNo" runat="server"></asp:DropDownList> --></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="ST01.TorqLowVal"/><!-- <asp:Label ID="lblTorqLowVal" runat="server" Text="ST01.TorqLowVal"></asp:Label> --></td>
                        <td ><input id="txtTorqLowVal" type="text" Width="38%" onkeypress="fn_NumKey()"><!-- <asp:TextBox ID="txtTorqLowVal" runat="server" Width="38%" onkeypress="fn_NumKey()"></asp:TextBox> --></td>
                        <td class="td-title"><spring:message code="ST01.AnglLowVal"/><!-- <asp:Label ID="lblAnglLowVal" runat="server" Text="ST01.AnglLowVal"></asp:Label> --></td>
                        <td><input id="txtAnglLowVal" type="text" Width="38%" onkeypress="fn_NumKey()"><!-- <asp:TextBox ID="txtAnglLowVal" runat="server" Width="38%" onkeypress="fn_NumKey()"></asp:TextBox> --></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="ST01.TorqOkVal"/><!-- <asp:Label ID="lblTorqOkVal" runat="server" Text="ST01.TorqOkVal"></asp:Label> --></td>
                        <td ><input id="txtTorqOkVal" type="text" Width="38%" onkeypress="fn_NumKey()"><!-- <asp:TextBox ID="txtTorqOkVal" runat="server" Width="38%" onkeypress="fn_NumKey()"></asp:TextBox> --></td>
                        <td class="td-title"><spring:message code="ST01.AnglOkVal"/><!-- <asp:Label ID="lblAnglOkVal" runat="server" Text="ST01.AnglOkVal"></asp:Label> --></td>
                        <td><input id="txtAnglOkVal" type="text" Width="38%" onkeypress="fn_NumKey()"><!-- <asp:TextBox ID="txtAnglOkVal" runat="server" Width="38%" onkeypress="fn_NumKey()"></asp:TextBox> --></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="ST01.TorqHighVal"/><!-- <asp:Label ID="lblTorqHighVal" runat="server" Text="ST01.TorqHighVal"></asp:Label> --></td>
                        <td ><input id="txtTorqHighVal" type="text"  Width="38%" onkeypress="fn_NumKey()"><!-- <asp:TextBox ID="txtTorqHighVal" runat="server" Width="38%" onkeypress="fn_NumKey()"></asp:TextBox> --></td>
                        <td class="td-title"><spring:message code="ST01.AnglHighVal"/><!-- <asp:Label ID="lblAnglHighVal" runat="server" Text="ST01.AnglHighVal"></asp:Label> --></td>
                        <td><input id="txtAnglHighVal" type="text" Width="38%" onkeypress="fn_NumKey()"><!-- <asp:TextBox ID="txtAnglHighVal" runat="server" Width="38%" onkeypress="fn_NumKey()"></asp:TextBox> --></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="ST01.WebDispFlag"/><!-- <asp:Label ID="lblWebDispFlag" runat="server" Text="ST01.WebDispFlag"></asp:Label> --></td>
                        <td><select id="ddlWebDispFlag"></select><!-- <asp:DropDownList ID="ddlWebDispFlag" runat="server"></asp:DropDownList> --></td>
                        <td class="td-title"><spring:message code="ST01.ResetJobNo"/><!-- <asp:Label ID="lblResetJobNo" runat="server" Text="ST01.ResetJobNo"></asp:Label> --></td>
                        <td><select id="ddlResetJobNo"></select><!-- <asp:DropDownList ID="ddlResetJobNo" runat="server"></asp:DropDownList> --></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="ST01.ShowValueType"/><!-- <asp:Label ID="lblShowValueType" runat="server" Text="ST01.ShowValueType"></asp:Label> --></td>
                        <td><select id="ddlShowValueType"></select><!-- <asp:DropDownList ID="ddlShowValueType" runat="server"></asp:DropDownList> --></td>
                        <td class="td-title"></td>
                        <td></td>
                    </tr>
            </table>
        </div>
        <div align="center">
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
            <!-- <asp:Button ID="btnSave" runat="server" Text="BUTTON.Save" onclick="btnSave_Click"  />
            <asp:Button ID="btnModify" runat="server" Text="BUTTON.Modify" onclick="btnModify_Click"  />
            <asp:Button ID="btnDelete" runat="server" Text="BUTTON.Delete" onclick="btnDelete_Click" />
            <asp:Button ID="btnReset" runat="server" Text="BUTTON.Reset"  />
            <asp:Button ID="btnClose" runat="server" Text="BUTTON.Close" /> -->
        </div>
        <div>
            <div style='display:inline;' id="divMessage" class="font-red"></div>
            <!-- <asp:Label ID="lblMessage" runat="server" CssClass="font-red"></asp:Label> -->
        </div>
    </div>
    </form>
    
</body>
</html>