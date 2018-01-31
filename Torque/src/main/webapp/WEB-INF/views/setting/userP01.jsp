<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	HttpSession my_session = request.getSession();
	String login_user_id = (String)my_session.getAttribute("USER_ID");
	String user_grade = (String)my_session.getAttribute("USER_GRADE");
	
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
//console.log('<%=login_user_id%>');

$(document).ready(function(){
	
	var user_id = getQuerystring('user_id')
	
	$("#btnSave").button();
	$("#btnModify").button();
	$("#btnDelete").button();
	$("#btnReset").button();
	$("#btnClose").button();
	
	Init();
	
	if ( user_id.length > 0 ){
		$('#txtUserID').val(user_id);
		$('#txtUserID').attr("disabled",true);
		
		LoadInfo(user_id);
	
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
            if ($("#txtUserID").val() == "") {
                e.preventDefault();
                var retVal = '<spring:message code="COMMON.EnterUserID"/>';
                $("#divMessage").text(retVal);
                $("#txtUserID").focus();
            } else if ($("#txtPassword").val() == "") {
                e.preventDefault();
                var retVal = '<spring:message code="COMMON.EnterPassword"/>';
                $("#divMessage").text(retVal);
                $("#txtPassword").focus();
            } else if ($("#txtUserName").val() == "") {
                e.preventDefault();
                var retVal = '<spring:message code="ST07.UserName"/>';
                $("#divMessage").text(retVal);
                $("#txtUserName").focus();
            } else if ($("#ddlUserGrp").val() == "-1" || $("#ddlUserGrp").val() == "") {
                e.preventDefault();
                var retVal = '<spring:message code="ST07.UserGrp"/>';
                $("#divMessage").text(retVal);
                $("#ddlUserGrp").focus();
            } else if ($("#ddlUserAuthority").val() == "-1") {
                e.preventDefault();
                var retVal = '<spring:message code="ST07.Authority"/>';
                $("#divMessage").text(retVal);
                $("#ddlUserAuthority").focus();
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
	getUserAuthority('<%=user_grade%>');
	getUserGroup('S','<%=user_grade%>');
	
	$.ajaxSetup({async:true});	//비동기 켜기
	
    $("#btnSave").show();
	$("#btnModify").hide();
	$("#btnDelete").hide();
} 

function fn_save(){
	var body = {
			plant_cd 		: $('#ddlPlant').val(),
			user_id			: $('#txtUserID').val(),
			user_pw			: $('#txtPassword').val(),
			user_nm			: $('#txtUserName').val(),
			user_grp		: $('#ddlUserGrp').val(),
			user_authority	: $('#ddlUserAuthority').val(),
			login_user_id   : '<%=login_user_id%>'
	}
	
	$.ajax({
		type : "POST",
		url : '/api/setting/insertuser',
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
	var body = {
			plant_cd 		: $('#ddlPlant').val(),
			user_id			: $('#txtUserID').val(),
			user_pw			: $('#txtPassword').val(),
			user_nm			: $('#txtUserName').val(),
			user_grp		: $('#ddlUserGrp').val(),
			user_authority	: $('#ddlUserAuthority').val(),
			login_user_id   : '<%=login_user_id%>'
	}
	
	$.ajax({
		type : "PUT",
		url : '/api/setting/updatetuser',
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
	"&user_id="+$('#txtUserID').val();

	$.ajax({
		type : "DELETE",
		url : '/api/setting/deleteuser'+params,
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

function LoadInfo(user_id){
	
	//$('#ddlStnType').val("N");
	
	var params = "user_id="+user_id;
	
	$.get('/api/setting/getuserinfo?'+params,function(data){
		
		if(data.length > 0){
			$('#ddlPlant').val(data[0].plant_cd.trim());
			$('#txtPassword').val(data[0].user_pwd.trim());
			$('#txtUserName').val(data[0].user_nm.trim());
			
			$('#ddlUserGrp').val(data[0].user_grp.trim());
			$('#ddlUserAuthority').val(data[0].web_user_permit.trim());
			
			
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
                        <td width="35%" class="td-title"><spring:message code="COMMON.Plant"/></td>
                        <td width="65%"><select id="ddlPlant"></select></td>
                    </tr>
                    <tr>
                        <td width="35%" class="td-title"><spring:message code="COMMON.UserID"/></td>
                        <td width="65%"><input id="txtUserID" type="text" Width="90%" style="ime-mode:disabled;text-transform:uppercase;" onKeyUp="fn_ToUpperCase(this);"></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="COMMON.Password"/></td>
                        <td ><input id="txtPassword" type="text" Width="90%" MaxLength="20"></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="ST07.UserName"/></td>
                        <td ><input id="txtUserName" type="text" Width="90%"></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="ST07.UserGrp"/></td>
                        <td ><select id="ddlUserGrp"></select></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="ST07.Authority"/></td>
                        <td><select id="ddlUserAuthority"></select></td>
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