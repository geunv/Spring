<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%
	HttpSession my_session = request.getSession();
	String user_id = (String)my_session.getAttribute("USER_ID");
	String user_nm = (String)my_session.getAttribute("USER_NM");
%>
<script>
if('null' == '<%=user_id%>'){
	alert('LOGIN!!');
	location.href = '/';
}
</script>
<script type="text/javascript">
	function OpenChangePassword() {
        var title = $("#lblMenuChangePassword").text();
        fn_ShowDialog('/view/changepassword', title, '500', '280', true);
    }

	function CloseDialog(flg) {
        //$('#btnSearch').click()
        fn_CloseDialog('', flg);
    }
	
	/* function OpenRegistration(user_id) {
    	var title= '<spring:message code="SCREEN.ST07" />';
        fn_ShowDialog('/view/setting/userP01.aspx?user_id=' + user_id, title, '500', '370', true);
    } */
</script>

<div class="container">
	<!-- <h3><a href="/">KIA</a></h3> -->
	<div style="float:left;padding-top:5px;">
		<a href="/index"><img src="/WebCommon/images/logo.png" alt="logo"></a>
		<span class="font-red h3" style="vertical-align:middle;text-align:center;">Torque Management System</span>
	</div>
	<div style="float:right;">
	<!-- Ie11용 Timer 주석처리  -->

		<div style="float:right;text-align:right;padding-top:35px;font-size:80%;">

			<!-- <input type="button" id="btnManual" value="Manual" onclick="javascript:Filedownload();" class="ui-button ui-widget ui-state-default ui-corner-all" role="button"> -->
      	</div>
    </div>
</div>

<!-- <div class="T_Body">
	<div style="float:left;padding-top:5px;">
		<a href="/MAIN.ASPX"><img src="/WebCommon/images/logo.png" alt="logo"></a>
		<span class="font-red h3" style="vertical-align:middle;text-align:center;">Torque Management System</span>
	</div>
	<div style="float:right;">
	Ie11용 Timer 주석처리 

		<div style="float:right;text-align:right;padding-top:35px;font-size:80%;">

			<input type="button" id="btnManual" value="Manual" onclick="javascript:Filedownload();" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
      	</div>
    </div>
</div> -->
            
<nav class="navbar navbar-default">
  <div class="container">
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav" id="myMenu">
      
        <li><a href="/index"><spring:message code="MENU.MAIN" /></a></li>
      
      </ul>
      <ul class="nav navbar-nav" style="float:right;">
      	 <li class="dropdown">
			<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><%=user_nm%><span class="caret"></span></a>
			<ul class="dropdown-menu" role="menu">
				<li><a href="#" onclick="javascript:OpenChangePassword();"><span class="font-red"><i class="fa fa-cog"></i>&nbsp;Change Password</span></a></li>
				<li class="divider"></li>
	      		<li><a href="/view/logout"><span class="font-red"><i class="fa fa-sign-out"></i>&nbsp;Log out</span></a></li>
			</ul>
		</li>
	 </ul>
     </div>
  </div>
</nav>
<script src="/js/menu.js"></script>


            