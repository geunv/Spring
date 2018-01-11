<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	HttpSession my_session = request.getSession();
	String login_user_id = (String)my_session.getAttribute("USER_ID");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>KMM TMS</title>
<jsp:include page="../head.jsp" flush="false" />
<script type="text/javascript">
if('null' == '<%=login_user_id%>'){
	alert('LOGIN!!');
	parent.CloseDialog(0);	//세션 끊겼을때 로그인 을 모달 창에서 해서.. 세션 끊기면 로그인전 모달창 닫게함
	location.href = '/';
}

$(document).ready(function(){
	
	var cartype = getQuerystring('CarType')
	var toolid = getQuerystring('ToolID');
	var toolserial = getQuerystring('ToolSerial');
	var job_num = getQuerystring('JobNo');
	
	$("#btnSave").button();
	$("#btnModify").button();
	$("#btnDelete").button();
	$("#btnReset").button();
	$("#btnClose").button();
	$("#divCondition").hide();
	
	Init();
	
	if ( toolid.length > 0 ){
		$('#ddlCarType').val(cartype);
		$('#ddlCarType').attr("disabled",true);
		
		$('#ddlTool').val(toolid+'-'+toolserial);
		$('#ddlTool').attr("disabled",true);
		
		$('#txtJobNo').val(job_num);
		$('#txtJobNo').attr("disabled",true);
		
		
		LoadInfo(cartype,toolid,toolserial,job_num);
	
		$("#btnSave").hide();
		$("#btnModify").show();
		$("#btnDelete").show();

	}
	
	$('#ddlCondFlag').on('change', function(){
		//$("#divCondition").toggle();
		if ($('#ddlCondFlag').val() == "Y" )
			$("#divCondition").show();
		else
			$("#divCondition").hide();
	});
	
	$("#btnSave").click(function(e) {
		var confirm = ValidationCheck(e, "I");
		if ( confirm == true)
			fn_save();
    });
	
    $("#btnModify").click(function(e) {
		var confirm = ValidationCheck(e, "U");
		
		if ( confirm == true) 
        	fn_modify();
    });

    $("#btnDelete").click(function(e) {
    	var msg = '<spring:message code="COMMON.ConfirmDelete"/>';
        if ( confirm(msg) )
        	fn_delete();
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

function ValidationCheck(e, flag) {
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
    } 
    else {
    	var msg = "";
    	if ( flag = "I" ){
    		msg = '<spring:message code="COMMON.ConfirmInsert"/>';
    	}else{
    		msg = '<spring:message code="COMMON.ConfirmUpdate"/>';
    	}
    	
        var ConfirmVal = confirm(msg);

        return ConfirmVal;
        
    }
}

function ddlTool(){
	getToolId('S',$('#ddlPlant').val(),'-1','N','-1','W');
}

function Init(){
	
	$.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
	getPlant();
	getCarType('S');
	ddlTool();
	//getJobNoToolP01('S');
	
	getUseFlag('ddlCondFlag','');
	
	
	$.ajaxSetup({async:true});	//비동기 켜기
	
    $("#btnSave").show();
	$("#btnModify").hide();
	$("#btnDelete").hide();
} 

function fn_save(){
	
	var body = {
			
			plant_cd 			: $('#ddlPlant').val(),
			car_type			: $('#ddlCarType').val(),
			tool				: $('#ddlTool').val(),
			
			job_num				: $('#txtJobNo').val(),
			repair_job_num		: $('#txtRepairJobNo').val(),
			total_batch_num		: $('#txtTotBatchNo').val(),
			
			torque_low			: $('#txtTorqLowVal').val(),
			torque_ok			: $('#txtTorqOkVal').val(),
			torque_high			: $('#txtTorqHighVal').val(),
			angle_low			: $('#txtAnglLowVal').val(),
			angle_ok			: $('#txtAnglOkVal').val(),
			angle_high			: $('#txtAnglHighVal').val(),
			reg_user_id 		: '' ,
			repair_batch_num	: $('#txtRepBatchNo').val(),
			
			cond_use_flg		: $('#ddlCondFlag').val(),
			condition_exp		: $('#txtCondExpression').val(),
			
			cond_seq1 			: $('#txtCondSeq1').val(),
			cond_type1 			: $('#ddlCondType1').val(),
			cond_no1 			: $('#txtCondNo1').val(),
			cond_operator1 		: $('#ddlCondOperator1').val(),
			cond_optval1 		: $('#txtOptVal1').val(),

			cond_seq2 			: $('#txtCondSeq2').val(),
			cond_type2 			: $('#ddlCondType2').val(),
			cond_no2 			: $('#txtCondNo2').val(),
			cond_operator2 		: $('#ddlCondOperator2').val(),
			cond_optval2 		: $('#txtOptVal2').val(),

			cond_seq3 			: $('#txtCondSeq3').val(),
			cond_type3 			: $('#ddlCondType3').val(),
			cond_no3 			: $('#txtCondNo3').val(),
			cond_operator3 		: $('#ddlCondOperator3').val(),
			cond_optval3 		: $('#txtOptVal3').val(),

			cond_seq4 			: $('#txtCondSeq4').val(),
			cond_type4 			: $('#ddlCondType4').val(),
			cond_no4 			: $('#txtCondNo4').val(),
			cond_operator4 		: $('#ddlCondOperator4').val(),
			cond_optval4 		: $('#txtOptVal4').val()

	}
	
	$.ajax({
		type : "POST",
		url : '/api/setting/jobno_insert',
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
		}else if( result.result == 400){
			var retVal = '<spring:message code="COMMON.OccurredError"/>';
            $("#divMessage").text(retVal);
		}
		
	}).fail(function(data) {
		var retVal = '<spring:message code="COMMON.OccurredError"/>';
        $("#divMessage").text(retVal);
	});
}

function fn_modify(){
var body = {
			
			plant_cd 			: $('#ddlPlant').val(),
			car_type			: $('#ddlCarType').val(),
			tool				: $('#ddlTool').val(),
			
			job_num				: $('#txtJobNo').val(),
			repair_job_num		: $('#txtRepairJobNo').val(),
			total_batch_num		: $('#txtTotBatchNo').val(),
			
			torque_low			: $('#txtTorqLowVal').val(),
			torque_ok			: $('#txtTorqOkVal').val(),
			torque_high			: $('#txtTorqHighVal').val(),
			angle_low			: $('#txtAnglLowVal').val(),
			angle_ok			: $('#txtAnglOkVal').val(),
			angle_high			: $('#txtAnglHighVal').val(),
			reg_user_id 		: '' ,
			repair_batch_num	: $('#txtRepBatchNo').val(),
			
			cond_use_flg		: $('#ddlCondFlag').val(),
			condition_exp		: $('#txtCondExpression').val(),
			
			cond_seq1 			: $('#txtCondSeq1').val(),
			cond_type1 			: $('#ddlCondType1').val(),
			cond_no1 			: $('#txtCondNo1').val(),
			cond_operator1 		: $('#ddlCondOperator1').val(),
			cond_optval1 		: $('#txtOptVal1').val(),

			cond_seq2 			: $('#txtCondSeq2').val(),
			cond_type2 			: $('#ddlCondType2').val(),
			cond_no2 			: $('#txtCondNo2').val(),
			cond_operator2 		: $('#ddlCondOperator2').val(),
			cond_optval2 		: $('#txtOptVal2').val(),

			cond_seq3 			: $('#txtCondSeq3').val(),
			cond_type3 			: $('#ddlCondType3').val(),
			cond_no3 			: $('#txtCondNo3').val(),
			cond_operator3 		: $('#ddlCondOperator3').val(),
			cond_optval3 		: $('#txtOptVal3').val(),

			cond_seq4 			: $('#txtCondSeq4').val(),
			cond_type4 			: $('#ddlCondType4').val(),
			cond_no4 			: $('#txtCondNo4').val(),
			cond_operator4 		: $('#ddlCondOperator4').val(),
			cond_optval4 		: $('#txtOptVal4').val()

	}
	
	$.ajax({
		type : "PUT",
		url : '/api/setting/jobno_update',
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

function fn_delete(){
	
	var params = "?plant_cd="+$('#ddlPlant').val()+
				 "&car_type="+$('#ddlCarType').val()+ 
				 "&tool="+$('#ddlTool').val()+
				 "&job_num="+$('#txtJobNo').val();

	$.ajax({
		type : "DELETE",
		url : '/api/setting/jobno_delete'+params,
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

function LoadInfo(cartype,toolid,toolserial,job_num){
	
	var params = "plant_cd="+$('#ddlPlant').val()+
				 "&car_type="+cartype+ 
				 "&tool_id="+toolid+
				 "&tool_serial="+toolserial+
				 "&job_num="+job_num;

	$.get('/api/setting/jobno_info?'+params,function(data){
		//console.log(data);
		data.infolist.forEach(function(item){
			$('#ddlPlant').val($.trim(item.plant_cd));
			$('#txtRepairJobNo').val(item.repair_job_num);
			$('#txtTotBatchNo').val(item.tot_batch_num);
			$('#txtTorqLowVal').val(item.torque_low);
			$('#txtTorqOkVal').val(item.torque_ok);
			$('#txtTorqHighVal').val(item.torque_high);
			$('#txtAnglLowVal').val(item.angle_low);
			$('#txtAnglOkVal').val(item.angle_ok);
			$('#txtAnglHighVal').val(item.angle_high);
			$('#txtRepBatchNo').val(item.repair_batch_num);
			$('#ddlCondFlag').val(item.cond_use_flg);
			
		});
			
		if ($('#ddlCondFlag').val() == "Y" ){
			$("#divCondition").show();
			
			$('#txtCondExpression').val(data.cond_expr);
			
			data.condlist.forEach(function(item){
				if ( item.cond_seq == "A"){
					$('#txtCondSeq1').val(item.cond_seq);
					$('#ddlCondType1').val(item.cond_type);
					$('#txtCondNo1').val(item.cond_no);
					$('#ddlCondOperator1').val(item.cond_operator);
					$('#txtOptVal1').val(item.cond_optval);
				}else if ( item.cond_seq == "B"){
					$('#txtCondSeq2').val(item.cond_seq);
					$('#ddlCondType2').val(item.cond_type);
					$('#txtCondNo2').val(item.cond_no);
					$('#ddlCondOperator2').val(item.cond_operator);
					$('#txtOptVal2').val(item.cond_optval);
				}else if ( item.cond_seq == "C"){
					$('#txtCondSeq3').val(item.cond_seq);
					$('#ddlCondType3').val(item.cond_type);
					$('#txtCondNo3').val(item.cond_no);
					$('#ddlCondOperator3').val(item.cond_operator);
					$('#txtOptVal3').val(item.cond_optval);
				}else if ( item.cond_seq == "D"){
					$('#txtCondSeq4').val(item.cond_seq);
					$('#ddlCondType4').val(item.cond_type);
					$('#txtCondNo4').val(item.cond_no);
					$('#ddlCondOperator4').val(item.cond_operator);
					$('#txtOptVal4').val(item.cond_optval);
				}
				
				
			});
			
		}else{
			$("#divCondition").hide();
		}
		
		/* if(data.length > 0){
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
		} */
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
                        <td width="30%" class="td-title"><spring:message code="COMMON.Plant"/></td>
                        <td width="15%"><select id="ddlPlant"></select></td>
                        <td width="32%" class="td-title"><spring:message code="COMMON.Tool"/></td>
                        <td width="33%"><select id="ddlTool"></select></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="COMMON.CarType"/></td>
                        <td ><select id="ddlCarType"></select></td>
                        <td class="td-title"><spring:message code="ST02.JobNo"/></td>
                        <td ><input id="txtJobNo" type="text"  MaxLength="5"></td>                     
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="ST02.RepairJobNo"/></td>
                        <td ><input id="txtRepairJobNo" style="width:50%" type="text" MaxLength="5"></td>
                        <td  class="td-title"><spring:message code="ST02.TotBatchNo"/></td>
                        <td ><input id="txtTotBatchNo" type="text"  MaxLength="2"></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="ST01.TorqLowVal"/></td>
                        <td ><input id="txtTorqLowVal" style="width:50%" type="text"  onkeypress="fn_NumKey()"></td>
                        <td class="td-title"><spring:message code="ST01.AnglLowVal"/></td>
                        <td><input id="txtAnglLowVal" type="text" onkeypress="fn_NumKey()"></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="ST01.TorqOkVal"/></td>
                        <td ><input id="txtTorqOkVal" style="width:50%"  type="text"  onkeypress="fn_NumKey()"></td>
                        <td class="td-title"><spring:message code="ST01.AnglOkVal"/></td>
                        <td><input id="txtAnglOkVal" type="text"  onkeypress="fn_NumKey()"></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="ST01.TorqHighVal"/></td>
                        <td ><input id="txtTorqHighVal" style="width:50%" type="text"  onkeypress="fn_NumKey()"></td>
                        <td class="td-title"><spring:message code="ST01.AnglHighVal"/></td>
                        <td><input id="txtAnglHighVal" type="text"  onkeypress="fn_NumKey()"></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="ST01.CondFlag"/></td>
                        <td><select id="ddlCondFlag"></select></td>
                        <td  class="td-title"><spring:message code="ST02.RepBatchNo"/></td>
                        <td ><input id="txtRepBatchNo" type="text"   MaxLength="2"></td>
                     </tr>
            </table>
            <div id="divCondition" runat="server" visible="false">
                <div>
                    <table width="100%" align="center" style="border:1px solid #ddd;">
                        <tr>
                            <td width="21%" height="30" class="td-title"><spring:message code="ST02.CondExpression"/><!-- <asp:Label ID="lblCondExpression" runat="server" Text="ST02.CondExpression" Font-Bold="true"></asp:Label> --></td>
                            <td class="left_5">
                            	<input type="text" ID="txtCondExpression" style="width:50%" style="ime-mode:disabled;text-transform:uppercase;" onKeyPress="fn_ToUpperCase(this);">
                                <!-- <asp:TextBox ID="txtCondExpression" runat="server" Width="50%" style="ime-mode:disabled;text-transform:uppercase;" onKeyPress="fn_ToUpperCase(this);"></asp:TextBox> --> &nbsp;
                                ex) & : AND, | : OR, A, A&B, A|B, A&B|A&C
                            </td>
                        </tr>
                    </table>
                    <table width="100%" align="center">
                        <tr>
                            <td height="30" class="td-title  font-white" style="background-color:#D9418C;">
                            	<spring:message code="ST02.ConditionList"/>
                                <!-- <asp:Label ID="lblOptHeader" runat="server" Text="ST02.ConditionList"></asp:Label> -->
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="height:165px;overflow-x:auto;position: relative;">
                    <table width="100%" align="center" class="table table-bordered">
	                    <tr>
	                        <td width="20%" class="td-title">SEQ_CHAR</td>
	                        <td width="20%" class="td-title">COND_GUB</td>
	                        <td width="20%" class="td-title">SPEC219_NUM</td>
	                        <td width="20%" class="td-title">EQUAL_OPERATOR_FLG</td>
	                        <td width="20%" class="td-title">SPEC219_VALUE</td>
	                    </tr>
	                    <tr>
	                        <td ><input type="text" style="width:40%" id="txtCondSeq1"></td>
	                        <td ><select id="ddlCondType1"><option value="Select"></option><option value="O">O:219</option><option value="C">C:Color</option></select></td>
	                        <td ><input type="text" style="width:40%" id="txtCondNo1"></td>
	                        <td ><select id="ddlCondOperator1"><option value="Select"></option><option value="T">=</option><option value="F">!=</option></select></td>
	                        <td ><input type="text" style="width:40%" id="txtOptVal1"></td>
	                    </tr>
	                    <tr>
	                        <td ><input type="text" style="width:40%" id="txtCondSeq2"></td>
	                        <td ><select id="ddlCondType2"><option value="Select"></option><option value="O">O:219</option><option value="C">C:Color</option></select></td>
	                        <td ><input type="text" style="width:40%" id="txtCondNo2"></td>
	                        <td ><select id="ddlCondOperator2"><option value="Select"></option><option value="T">=</option><option value="F">!=</option></select></td>
	                        <td ><input type="text" style="width:40%" id="txtOptVal2"></td>
	                    </tr>
	                    <tr>
	                        <td ><input type="text" style="width:40%" id="txtCondSeq3"></td>
	                        <td ><select id="ddlCondType3"><option value="Select"></option><option value="O">O:219</option><option value="C">C:Color</option></select></td>
	                        <td ><input type="text" style="width:40%" id="txtCondNo3"></td>
	                        <td ><select id="ddlCondOperator3"><option value="Select"></option><option value="T">=</option><option value="F">!=</option></select></td>
	                        <td ><input type="text" style="width:40%" id="txtOptVal3"></td>
	                    </tr>
	                    <tr>
	                        <td ><input type="text" style="width:40%" id="txtCondSeq4"></td>
	                        <td ><select id="ddlCondType4"><option value="Select"></option><option value="O">O:219</option><option value="C">C:Color</option></select></td>
	                        <td ><input type="text" style="width:40%" id="txtCondNo4"></td>
	                        <td ><select id="ddlCondOperator4"><option value="Select"></option><option value="T">=</option><option value="F">!=</option></select></td>
	                        <td ><input type="text" style="width:40%" id="txtOptVal4"></td>
	                    </tr>
	                    <!-- <tr>
	                        <td ><input type="text" style="width:40%" id="txtCondSeq5"></td>
	                        <td ><select id="ddlCondType5"><option value="Select"></option><option value="O">O:219</option><option value="C">C:Color</option></select></td>
	                        <td ><input type="text" style="width:40%" id="txtCondNo5"></td>
	                        <td ><select id="ddlCondOperator5"><option value="Select"></option><option value="T">=</option><option value="F">!=</option></select></td>
	                        <td ><input type="text" style="width:40%" id="txtOptVal5"></td>
	                    </tr> -->
                    </table>
                </div>
            </div>
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