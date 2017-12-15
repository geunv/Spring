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

<!-- <div class="T_Body">
	<div style="float:left;padding-top:5px;">
    	<a href="/"><img src="/WebCommon/images/logo.png" alt="logo"></a>
        <span class="font-red h3" style="vertical-align:middle;text-align:center;">Torque Management System</span>
	</div>
	<div style="float:right;">
    Ie11용 Timer 주석처리 
        <div style="float:right;text-align:right;padding-top:35px;font-size:80%;">
			<input type="button" id="btnManual" value="Manual" onclick="javascript:Filedownload();" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
		</div>
	</div>
</div>
			<div id="header">
                <div class="T_Body">
                    <div style="float:left;">
                        <ul class="nav-top">
                            <li>
                            <a href="/Main.ASPX"><span class="font-white"><span id="ctl00_lblMenuMain">MAIN</span> </span></a>
                            </li>
                            <li class="dropdown">
                                | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <a class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown" href="#">
                                    <span class="font-white"><span id="ctl00_lblMenuResult">RESULT</span>  <i class="fa fa-chevron-down "></i></span>
                                </a>
                                <ul class="dropdown-menu dropdown-submenu1">
                                    <li><a href="/RESULT/RS01.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuRS01">Tool Result Summary</span> </span></a></li>
                                    <li class="divider"></li>
                                    <li><a href="/RESULT/RS02.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuRS02">Tool Result Detail</span> </span></a></li>
                                    <li class="divider"></li>
                                    <li><a href="/RESULT/RS03.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuRS03">Tool Result History</span> </span></a></li>
                                    <li class="divider"></li>
                                    <li><a href="/RESULT/RS06.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuRS06">Tool Result By Date</span> </span></a></li>
                                    <li class="divider"></li>
                                    <li><a href="/RESULT/RS04.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuRS04">Cycle Test Result</span> </span></a></li>
                                    <li class="divider"></li>
                                    <li><a href="/RESULT/RS05.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuRS05">Line Stop History</span> </span></a></li>
                                </ul>
                            </li>
                            <li class="dropdown">
                                 | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                 <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                                    <span class="font-white"><span id="ctl00_lblMenuChart">CHART</span>  <i class="fa fa-chevron-down "></i></span>
                                 </a>
                                 <ul class="dropdown-menu dropdown-submenu2">
                                    <li><a href="/CHART/CT01.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuCT01">Line Chart</span> </span></a></li>
                                    <li class="divider"></li>
                                    <li><a href="/CHART/CT02.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_Label1">Faulty Chart</span> </span></a></li>
                                    <li class="divider"></li>
                                    <li><a href="/CHART/CT03.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_Label2">X Bar-R Chart</span> </span></a></li>
                                </ul>
                            </li>
                            <li>
                             | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <span id="ctl00_lblMenuToolsNet">ToolsNet</span> 
                            </li>
                            <li id="ctl00_m_Setting" class="dropdown">
                                 | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                                    <span class="font-white"><span id="ctl00_lblMenuSetting">SETTING</span>  <i class="fa fa-chevron-down "></i></span>
                                </a>
                                <ul class="dropdown-menu dropdown-submenu3">
                                    <li><a href="/SETTING/ST01.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuST01">Tool</span> </span></a></li>
                                    <li class="divider"></li>
                                    <li><a href="/SETTING/ST02.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuST02">Job No.</span> </span></a></li>
                                    <li class="divider"></li>
                                    <li><a href="/SETTING/ST03.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuST03">Car Type</span> </span></a></li>
                                    <li class="divider"></li>
                                    <li><a href="/SETTING/ST04.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuST04">Line</span> </span></a></li>
                                    <li class="divider"></li>
                                    <li><a href="/SETTING/ST05.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuST05">Shift</span> </span></a></li>
                                    <li class="divider"></li>
                                    <li><a href="/SETTING/ST06.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuST06">Cycle Test Item</span> </span></a></li>
                                    <li class="divider"></li>
                                    <li><a href="/SETTING/ST07.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuST07">User</span> </span></a></li>
                                </ul>
                            </li>
                            
                            <li id="ctl00_m_System" class="dropdown">
                                 | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                                    <span class="font-white"><span id="ctl00_lblMenuSystem">SYSTEM</span>  <i class="fa fa-chevron-down "></i></span>
                                </a>
                                <ul class="dropdown-menu dropdown-submenu4">
                                    <li><a href="/SYSTEM/SM01.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuSM01">Program &amp; Process</span></span></a></li>
                                    <li class="divider"></li>
                                    <li><a href="/SYSTEM/SM02.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuSM02">Common Code</span></span></a></li>
                                    <li class="divider"></li>
                                    <li><a href="/SYSTEM/SM03.ASPX"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;<span id="ctl00_lblMenuSM03">Language</span> </span></a></li>
                                </ul>
                            </li>
                        </ul>           
                    </div>
                    <div style="float:right;">
                        <ul class="nav-top">
                        <li class="dropdown user-info">
                            <i class="fa fa-user"></i> 
                            <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                                <span class="font-white">
                                    <span id="ctl00_lblUserName">Administrator                                     </span>
                                    <i class="fa fa-chevron-down "></i>
                                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-user">
                                <li><a href="#" onclick="javascript:OpenChangePassword();"><span class="font-red"><i class="fa fa-cog"></i> <span id="ctl00_lblMenuChangePassword">Change Password</span></span></a>
                                </li><li class="divider"></li>
                                <li><a id="ctl00_lbtnLogout" href="javascript:__doPostBack('ctl00$lbtnLogout','')"><span class="font-red"><i class="fa fa-sign-out"></i> <span id="ctl00_lblMenuLogout">Logout</span></span></a> 
                                </li>
                            </ul>
                        </li>
                        </ul>
                    </div>         
                </div>
            </div> -->
            <!--/header-->
            