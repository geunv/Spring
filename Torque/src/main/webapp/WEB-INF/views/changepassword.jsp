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
<jsp:include page="head.jsp" flush="false" />
<script src="/WebCommon/scripts/aes.js" type="text/javascript"></script>
<script src="/WebCommon/scripts/AesUtil.js" type="text/javascript"></script>
<script src="/WebCommon/scripts/pbkdf2.js" type="text/javascript"></script>
    

<script type="text/javascript">
if('null' == '<%=login_user_id%>'){
	alert('LOGIN!!');
	parent.CloseDialog(0);	//세션 끊겼을때 로그인 을 모달 창에서 해서.. 세션 끊기면 로그인전 모달창 닫게함
	location.href = '/';
}
//console.log('<%=login_user_id%>');

$(document).ready(function(){
	
	//var login_user_id = getQuerystring('user_id')
	
	$("#btnSave").button();
    $("#btnReset").button();
	$("#txtPassword").focus();
    $("#btnClose").button();
	
    $('#txtUserID').val('<%=login_user_id%>');
	$('#txtUserID').attr("disabled",true);
	
	
    $("#btnSave").click(function(e) {
        if ($("#txtPassword").val() == "") {
            e.preventDefault();
            var retVal = '<spring:message code="COMMON.EnterPassword"/>';
            $("#divMessage").text(retVal);
            $("#txtPassword").focus();
        } else if ($("#txtPassword1").val() == "") {
            e.preventDefault();
            var retVal = '<spring:message code="CHGPWD.EnterNewPassword"/>';
            $("#divMessage").text(retVal);
            $("#txtPassword1").focus();
        } else if ($("#txtPassword2").val() == "") {
            e.preventDefault();
            var retVal = '<spring:message code="CHGPWD.EnterNewPasswordAgain"/>';
            $("#divMessage").text(retVal);
            $("#txtPassword2").focus();
        } else if ($("#txtPassword1").val() != $("#txtPassword2").val()) {
            e.preventDefault();
            var retVal = '<spring:message code="CHGPWD.NotMatchPassword"/>';
            $("#divMessage").text(retVal);
            $("#txtPassword2").focus();
        }else{

            
        	 var keySize = 128;
             var iterations = iterationCount = 100;
              
             var iv = "F27D5C9927726BCEFE7510B1BDD3D137";
             var salt = "3FF2EC019C627B945225DEBAD71A01B6985FE84C95A70EB132882F88C0A59A55";
             var passPhrase = "KMM987654321";
              
             var plainText = "AES ENCODING ALGORITHM PLAIN TEXT";
             
          
             var aesUtil = new AesUtil(keySize, iterationCount)
             var encrypt = aesUtil.encrypt(salt, iv, passPhrase, plainText);
             
             /* aesUtil = new AesUtil(keySize, iterationCount)
             var decrypt = aesUtil.decrypt(salt, iv, passPhrase, encrypt); */
             
	        
	        
	        var body = {
	    			user_id				: '<%=login_user_id%>',
	    			current_password	: aesUtil.encrypt(salt, iv, passPhrase, $('#txtPassword').val()),
	    			password1			: aesUtil.encrypt(salt, iv, passPhrase, $('#txtPassword1').val()),
	    			password2			: aesUtil.encrypt(salt, iv, passPhrase, $('#txtPassword2').val()),
	    	}
        
	    
	        
	        $.ajax({
	    		type : "POST",
	    		url : '/api/changepassword',
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
	            }else if (result.result == 300){
	            	var retVal = '<spring:message code="COMMON.OccurredError"/>';
		            $("#divMessage").text(retVal);
	    		}else if( result.result == 400){
	    			var retVal = '<spring:message code="COMMON.IncorrectPassword"/>';
	                $("#divMessage").text(retVal);
	    		}else if( result.result == 500){
	    			var retVal = '<spring:message code="COMMON.NotRegisteredUser"/>';
	                $("#divMessage").text(retVal);
	    		}
	    		
	    	}).fail(function(data) {
	    		var retVal = '<spring:message code="COMMON.OccurredError"/>';
	            $("#divMessage").text(retVal);
	    	});
        }
    });

    $("#btnReset").click(function(e) {
        e.preventDefault();
        form1.reset();
        $('#txtUserID').val('<%=login_user_id%>');
    });

    $("#btnClose").click(function(e) {
        e.preventDefault();
        parent.CloseDialog(0);
    });
})	
</script>
</head>
<body>
    <form id="form1">
    <div class="panel">
        <div>
            <table width="100%" align="center" class="table table-bordered">
                    <tr>
                        <td width="35%" class="td-title"><spring:message code="COMMON.UserID"/><!-- <asp:Label ID="lblUserID" runat="server" Text="COMMON.UserID" Font-Bold="true"></asp:Label> --></td>
                        <td width="65%"><input id="txtUserID" type="text" ><!-- <asp:Label ID="lblSUserID" runat="server" Font-Bold="true"></asp:Label> --></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="COMMON.Password"/><!-- <asp:Label ID="lblPassword" runat="server" Text="COMMON.Password" Font-Bold="true"></asp:Label> --></td>
                        <td ><input id="txtPassword" type="password" Width="90%" MaxLength="20"><!-- <asp:TextBox TextMode="Password" ID="txtPassword" runat="server"  Width="90%" MaxLength="20"></asp:TextBox> --></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="CHGPWD.NewPassword"/><!-- <asp:Label ID="lblPassword1" runat="server" Text="CHGPWD.NewPassword" Font-Bold="true"></asp:Label> --></td>
                        <td ><input id="txtPassword1" type="password" Width="90%" MaxLength="20"><!-- <asp:TextBox TextMode="Password" ID="txtPassword1" runat="server"  Width="90%" MaxLength="20"></asp:TextBox> --></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="CHGPWD.ConfirmPassword"/><!-- <asp:Label ID="lblPassword2" runat="server" Text="CHGPWD.ConfirmPassword" Font-Bold="true"></asp:Label> --></td>
                        <td ><input id="txtPassword2" type="password" Width="90%" MaxLength="20"><!-- <asp:TextBox TextMode="Password" ID="txtPassword2" runat="server"  Width="90%" MaxLength="20"></asp:TextBox> --></td>
                    </tr>
            </table>
        </div>
        <div align="center">
            <c:set var="btnSave"><spring:message code="BUTTON.Save"/></c:set>
			<input type="button" id="btnSave" value="${btnSave}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button" >
			
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