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
	
	var lang_id = getQuerystring('lang_id');
	var lang_type = getQuerystring('lang_type');
	
	$("#btnSave").button();
	$("#btnModify").button();
	$("#btnDelete").button();
	$("#btnReset").button();
	$("#btnClose").button();
	
	Init();
	
	if ( lang_id.trim().length > 0 ){
		
		$('#ddlPlant').attr("disabled",true);
		
		$('#txtLangID').val(lang_id);
		$('#txtLangID').attr("disabled",true);
		
		$('#ddlLangType').val(lang_type);
		$('#ddlLangType').attr("disabled",true);
		
		LoadInfo(lang_id,lang_type);
	
		$("#btnSave").hide();
		$("#btnModify").show();
		$("#btnDelete").show();

	}
	
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
    
})

		function ValidationCheck(e, flag) {
	
			 if ($("#txtLangID").val() == "") {
		         e.preventDefault();
		         var retVal = '<spring:message code="SM03.SelectLangID"/>';
		         $("#divMessage").text(retVal);
		         $("#txtLangID").focus();
		     } else if ($("#ddlSystemArea").val() == "-1" || $("#ddlSystemArea").val() == "" ) {
		         e.preventDefault();
		         var retVal = '<spring:message code="SM03.SelectSystemArea"/>';
		         $("#divMessage").text(retVal);
		         $("#ddlSystemArea").focus();
		     } else if ($("#ddlLangType").val() == "-1" || $("#ddlLangType").val() == "-1") {
		         e.preventDefault();
		         var retVal = '<spring:message code="SM03.SelectLangType"/>';
		         $("#divMessage").text(retVal);
		         $("#ddlLangType").focus();
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
        

		
function Init(){
	
	$.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
	getPlant();
	getSystemArea('S');
	getLangType('S');
	
	$.ajaxSetup({async:true});	//비동기 켜기
	
    $("#btnSave").show();
	$("#btnModify").hide();
	$("#btnDelete").hide();
} 

function fn_save(){
	
	var body = {
			plant_cd 		: $('#ddlPlant').val(),
			lang_id			: $('#txtLangID').val(),
			sys_area		: $('#ddlSystemArea').val(),
			lang_type		: $('#ddlLangType').val(),
			msg_type		: $('#ddlMsgType').val(),
			lang_kor		: $('#txtLangKor').val(),
			lang_eng		: $('#txtLangEng').val(),
			lang_lon		: $('#txtLangLon').val(),
			login_user_id   : '<%=login_user_id%>'
	}
	
	$.ajax({
		type : "POST",
		url : '/api/system/language_insert',
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

function fn_modify(){
	
	
	var v_msg_type = "";
	
	if ( $('#ddlMsgType').val() == "" || $('#ddlMsgType').val() == null)
		v_msg_type = '';
	
	var body = {
			plant_cd 		: $('#ddlPlant').val(),
			lang_id			: $('#txtLangID').val(),
			sys_area		: $('#ddlSystemArea').val(),
			lang_type		: $('#ddlLangType').val(),
			msg_type		: v_msg_type,
			lang_kor		: $('#txtLangKor').val(),
			lang_eng		: $('#txtLangEng').val(),
			lang_lon		: $('#txtLangLon').val(),
			login_user_id   : '<%=login_user_id%>'
	}
	
	$.ajax({
		type : "PUT",
		url : '/api/system/language_update',
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

function fn_delete(){
	
	var params = "?plant_cd="+$('#ddlPlant').val()+
	"&lang_id="+$('#txtLangID').val()+
	"&lang_type="+$('#ddlLangType').val();
	

	$.ajax({
		type : "DELETE",
		url : '/api/system/language_delete'+params,
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

function LoadInfo(lang_id,lang_type){
	
	var params = "?plant_cd="+$('#ddlPlant').val()+"&lang_id="+lang_id+"&lang_type="+lang_type;
	
	$.get('/api/setting/getlanguage_info'+params,function(data){
		
		if(data.length > 0){
			$('#ddlPlant').val($.trim(data[0].plant_cd));
			$('#ddlSystemArea').val($.trim(data[0].sys_area));
			$('#ddlMsgType').val($.trim(data[0].msg_type));
			
			$('#txtLangKor').val($.trim(data[0].msg_text_ko_kr));
			$('#txtLangEng').val($.trim(data[0].msg_text_en_us));
			$('#txtLangLon').val($.trim(data[0].msg_text_lo_ln));
			
			if ( data[0].msg_type.trim().length == 0 )
				$('#ddlMsgType').attr("disabled",true);
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
                        <td width="35%" class="td-title"><spring:message code="COMMON.Plant"/><!-- <asp:Label ID="lblPlant" runat="server" Text="COMMON.Plant" Font-Bold="true"></asp:Label> --></td>
                        <td width="65%"><select id="ddlPlant"></td>
                    </tr>
                    <tr>
                        <td width="35%" class="td-title"><spring:message code="SM03.LangID"/><!-- <asp:Label ID="lblLangID" runat="server" Text="SM03.LangID" Font-Bold="true"></asp:Label> --></td>
                        <td width="65%"><input type="text" id="txtLangID" Width="90%" MaxLength="30"></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="SM03.SysArea"/><!-- <asp:Label ID="lblSysArea" runat="server" Text="SM03.SysArea" Font-Bold="true"></asp:Label> --></td>
                        <td><select id="ddlSystemArea"></select><!-- <asp:DropDownList ID="ddlSystemArea" runat="server"></asp:DropDownList> --></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="SM03.LangType"/><!-- <asp:Label ID="lblLangType" runat="server" Text="SM03.LangType" Font-Bold="true"></asp:Label> --></td>
                        <td ><select id="ddlLangType"></select><!-- <asp:DropDownList ID="ddlLangType" runat="server" 
                                onselectedindexchanged="ddlLangType_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList> --></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="SM03.MsgType"/><!-- <asp:Label ID="Label1" runat="server" Text="SM03.MsgType" Font-Bold="true"></asp:Label> --></td>
                        <td ><select id="ddlMsgType">
                        		<option value="-1">Select</option>
                        		<option value="I">Information</option>
                        		<option value="W">Warning</option>
                        		<option value="E">Error</option>
                        		
                        	</select>
                            <!-- <asp:DropDownList ID="ddlMsgType" runat="server" >
                                <asp:ListItem Text="SELECT" Value="-1"></asp:ListItem>
                                <asp:ListItem Text="Information" Value="I"></asp:ListItem>
                                <asp:ListItem Text="Warning" Value="W"></asp:ListItem>
                                <asp:ListItem Text="Error" Value="E"></asp:ListItem>
                            </asp:DropDownList> -->
                        </td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="SM03.LangKor"/><!-- <asp:Label ID="lblLangKor" runat="server" Text="SM03.LangKor" Font-Bold="true"></asp:Label> --></td>
                        <td ><input type="text" id="txtLangKor" Width="90%" ><!-- <asp:TextBox ID="txtLangKor" runat="server"  Width="90%" ></asp:TextBox> --></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="SM03.LangEng"/><!-- <asp:Label ID="lblLangEn" runat="server" Text="SM03.LangEng" Font-Bold="true"></asp:Label> --></td>
                        <td ><input type="text" id="txtLangEng" Width="90%" ><!-- <asp:TextBox ID="txtLangEng" runat="server"  Width="90%" ></asp:TextBox> --></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="SM03.LangLon"/><!-- <asp:Label ID="lblLangLo" runat="server" Text="SM03.LangLon" Font-Bold="true"></asp:Label> --></td>
                        <td ><input type="text" id="txtLangLon" Width="90%" ><!-- <asp:TextBox ID="txtLangLon" runat="server"  Width="90%" ></asp:TextBox> --></td>
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
        </div>
        <div>
            <hr />
           <div style='display:inline;' id="divMessage" class="font-red"></div>
        </div>
    </div>
    </form>
    
</body>
</html>