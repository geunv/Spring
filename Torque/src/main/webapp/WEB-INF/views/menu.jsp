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
<div class="container">
	<h3><a href="/">KIA</a></h3>
</div>

<nav class="navbar navbar-default">
  <div class="container">
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav" id="myMenu">
      
        <li><a href="/index"><spring:message code="menu.Main" /></a></li>
      
      </ul>
      <ul class="nav navbar-nav" style="float:right;">
      	 <li class="dropdown">
			<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><%=user_nm%><span class="caret"></span></a>
			<ul class="dropdown-menu" role="menu">
				<li><a href="">Change Password</a></li>
	      		<li><a href="/view/logout">Log out</a></li>
			</ul>
		</li>
	 </ul>
     </div>
  </div>
</nav>
<script src="/js/menu.js"></script>
