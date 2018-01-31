<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	HttpSession my_session = request.getSession();
	String user_grade = (String)my_session.getAttribute("USER_GRADE");
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8"> 
	<title>User</title>
	<jsp:include page="../head.jsp" flush="false" />
</head>
<body>
<jsp:include page="../menu.jsp" flush="false" />
<script type="text/javascript">
if('U' == '<%=user_grade%>'){
	location.href = '/index';
}

    $(document).ready(function() {
        $("#btnSearch").button();
        $("#btnExcel").button();
        $("#btnReg").button();
        
        $.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
    	
        
        init();
    	
    	
		$.ajaxSetup({async:true});	//비동기 켜기
		
		getList();
		
		$("#btnSearch").on('click', function(e){
			getList();
		});
		
		$("#btnReg").click(function(e) {
            e.preventDefault();
            OpenRegistration(' ');
        });
		
		$('#btnExcel').on('click', function(){

	        var postfix = fn_Excelpostfix() //"-"+year + month + day + "_" + hour + mins;
	        var fileName = $('#content-title').text().trim()+ postfix + ".xls";
	        getExcelData();
	        fn_ExcelReport('list_excel', fileName);
			
		});
		
		
		$('#ddlUserAuthority').on('change', function(){
    		$('#btnSearch').click()
    	});
		
		$('#ddlUserGrp').on('change', function(){
    		$('#btnSearch').click()
    	});

		
		$('#select_page_count').on('change', function(){
	    		now_page = $('#select_page_count').val();
	    		show_count = $('#select_show_count').val();
	    		getList();
	    });
    	 
    	$('#select_show_count').on('change', function(){
    		now_page = $('#select_page_count').val();
    		show_count = $('#select_show_count').val();
    		getList();
    		
    	});
    	
    });
	
    function init(){
		getPlant();
    	getUserAuthority('<%=user_grade%>');
    	getUserGroup('A','<%=user_grade%>');
    	
    }
    
    var now_page = 1;
    var show_count = 20;

    function getList(){
        
    	var params = "?plant_cd="+$('#ddlPlant').val()+
    				 "&user_authority="+$('#ddlUserAuthority').val()+
    				 "&user_grp="+$('#ddlUserGrp').val()+
    				 "&user_id="+$('#txtUserID').val() +
    				 "&user_nm="+$('#txtUserName').val() +
    				 "&user_grade=" +'<%=user_grade%>'+
    				 "&page="+now_page+
    				 "&show_count="+show_count;
    	
    	$.get('/api/setting/getuserlist'+params,function(data){
    		if(data.result == 200){
    			
    			$('#select_page_count').empty();
    			$('#list_total').text(data.total_count); 	// 총갯수
    			//this.custPager.TotalPages = num % this.gridView1.PageSize == 0 ? num / this.gridView1.PageSize : num / this.gridView1.PageSize + 1;
    			
    			var pageTotalCount = 0;
    			
    			if ( data.total_count % show_count == 0  )
    				pageTotalCount = data.total_count / show_count;
    			else
    				pageTotalCount = Math.floor(data.total_count / show_count) + 1;
    			
    			//var total_page = data.total % $('#select_page_count').val() == 0 
    			$('#page_total').text(pageTotalCount);
    			
    			for(var i = 1 ; i <= pageTotalCount; i++){			
    				if(now_page == i){
    					$('#select_page_count').append('<option value="' + i + '" selected>' + i + '</option>');
    				}else{
    					$('#select_page_count').append('<option value="' + i + '">' + i + '</option>');
    				}
    			}
    			
    			// list setting
    			$('#list_data').empty();
    				
    			data.list.forEach(function(item){
    					
    				$('#list_data').append(
    						
    					   '<tr>'
							+ ' <td>' + item.rnum +'</td>'
							+ ' <td class="left_5"><a href=\'#\' onClick="OpenRegistration(\'' + item.user_id +'\');">' + item.user_id+ '</a></td>'
							+ ' <td class="left_5">' + item.user_nm +'</td>'
							+ ' <td>' + item.user_grp +'</td>'
							+ ' <td>' + item.web_user_permit +'</td>'
							+ ' <td>' + ChangeDateFormat(item.last_login_dt) +'</td>'
							+ ' <td>' + ChangeDateFormat(item.regdt) +'</td>'
							+ ' <td>' + item.reg_user_id +'</td>'
    					+ '</tr>'
    				);
    			});
    			
    		}
    	});
    }
    
    function getExcelData(){
    	//$.get('/api/setting/gettoollist?'+params,function(data){
    	
    	var params = "?plant_cd="+$('#ddlPlant').val()+
					 "&user_authority="+$('#ddlUserAuthority').val()+
					 "&user_grp="+$('#ddlUserGrp').val()+
					 "&user_id="+$('#txtUserID').val() +
					 "&user_nm="+$('#txtUserName').val() +
					 "&user_grade=" +'<%=user_grade%>'+
					 "&page="+now_page+
					 "&show_count="+show_count+
    				 "&excel_down=Y";
    	
    	$.ajax({
    			url:'/api/setting/getuserlist'+params,
    			type:'GET',
    			async:false,
    			success: function(data) {
    				if(data.result == 200){
    					$("#list_excel").empty();
    					$("#list_excel").append("<thead>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Num'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.UserID'/></th>");
						$("#list_excel").append("<th><spring:message code='ST07.UserName'/></th>");
						$("#list_excel").append("<th><spring:message code='ST07.UserGrp'/></th>");
    					$("#list_excel").append("<th><spring:message code='ST07.Authority'/></th>");
    					$("#list_excel").append("<th><spring:message code='ST07.LastLoginDT'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.RegisterDate'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Register'/></th>");
    					$("#list_excel").append("</thead>");
    					
    					$("#list_excel").append("<tbody>");
    					
    					data.list.forEach(function(item){
    	    				//console.log(item);
    	    				
    	    				$('#list_excel').append(
    	    						
    	    						'<tr>'
    								+ ' <td>' + item.rnum +'</td>'
    								+ ' <td>' + item.user_id +'</td>'
    								+ ' <td>' + item.user_nm +'</td>'
    								+ ' <td>' + item.user_grp +'</td>'
    								+ ' <td>' + item.web_user_permit +'</td>'
    								+ ' <td>' + ChangeDateFormat(item.last_login_dt) +'</td>'
    								+ ' <td>' + ChangeDateFormat(item.regdt) +'</td>'
    								+ ' <td>' + item.reg_user_id +'</td>'
    	    					+ '</tr>'
    	    				);
    	    			});
    					
    					$("#list_excel").append("</tbody>");
    				}	
    			},
    			error:function(e){  
    				alert(e.responseText);
    	        }  
    			
    		});
    }

    function CloseDialog(flg) {
        $('#btnSearch').click()
        fn_CloseDialog('', flg);
    }
    
    function OpenRegistration(UserID) {
        var title = '<spring:message code="SCREEN.ST07" />';
        fn_ShowDialog('/view/setting/userP01.aspx?user_id=' + UserID, title, '500', '370', true);
    }
    
    
</script>
<div class="container">
	<div id="C_Body">       
        <div id="C_Title">
            <div id="content-title">
                <i class="fa fa-pencil-square-o "></i> <spring:message code="SCREEN.ST07" /><!-- <asp:Label ID="lblTitle" runat="server" Text="SCREEN.ST07"></asp:Label> -->
            </div>
            <div id="content-title-nav">
                <i class="fa fa-angle-double-right"></i> <spring:message code="MENU.SETTING" /> <!-- <asp:Label ID="lblMenuSystem" runat="server" Text="MENU.SETTING"></asp:Label> -->
            </div>
            <div id="content-title-bar">
            </div>  
        </div> 
        <div id="C_Search">
            <table cellpadding="1" cellspacing="1" border="0" align="center" class="search_table">
                <tr>
                    <td height="70">
                        <table width="100%">
                            <tr>
                                <td width="1%"></td>
                                <td width="9%" height="30" bgcolor="#FFFFFF" class="left_5" >
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Plant" /> <!-- <asp:Label ID="lblPlant" runat="server" Text="COMMON.Plant"></asp:Label> -->
                                </td>
                                <td width="18%" class="left_5" >
                                	<select id="ddlPlant"></select>
                                    <!-- <asp:DropDownList ID="ddlPlant" runat="server"></asp:DropDownList> -->
                                </td>
                                <td  width="7%" bgcolor="#FFFFFF" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="ST07.Authority" /> <!-- <asp:Label ID="lblAuthority" runat="server" Text="ST07.Authority"></asp:Label> -->
                                </td>
                                <td width="18%" class="left_5">
                                	<select id="ddlUserAuthority"></select>
                                    <!-- <asp:DropDownList ID="ddlUserAuthority" runat="server" AutoPostBack="true"
                                        onselectedindexchanged="ddlUserAuthority_SelectedIndexChanged"></asp:DropDownList> -->
                                </td>
                                <td  width="6%" bgcolor="#FFFFFF" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="ST07.UserGrp" /> <!-- <asp:Label ID="lblUserGrp" runat="server" Text="ST07.UserGrp" ></asp:Label> -->
                                </td>
                                <td width="18%" class="left_5">
                                	<select id="ddlUserGrp"></select>
                                    <!-- <asp:DropDownList ID="ddlUserGrp" runat="server" AutoPostBack="true"
                                        onselectedindexchanged="ddlUserGrp_SelectedIndexChanged"></asp:DropDownList> -->
                                </td>
                                <td rowspan="2"  class="content-button">
                                	<c:set var="btnSearch"><spring:message code="BUTTON.Search"/></c:set>
                                	<input type="button" id="btnSearch" value="${btnSearch}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                	<c:set var="btnExcel"><spring:message code="BUTTON.Excel"/></c:set>
                                	<input type="button" id="btnExcel" value="${btnExcel}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                	<c:set var="btnReg"><spring:message code="BUTTON.Registration"/></c:set>
                                	<input type="button" id="btnReg" value="${btnReg}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                    <!-- <asp:Button ID="btnSearch" runat="server" Text="BUTTON.Search"  OnClick="btnSearch_Click" />
                                    <asp:Button ID="btnExcel" runat="server" Text="BUTTON.Excel" OnClick="btnExcel_Click" />
                                    <asp:Button ID="btnReg" runat="server" Text="BUTTON.Registration" /> -->
                                </td>
                            </tr>
                            <tr>
                                <td ></td>
                                <td bgcolor="#FFFFFF" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.UserID" /> <!-- <asp:Label ID="lblUserID" runat="server" Text="COMMON.UserID"></asp:Label> -->
                                </td>
                                <td class="left_5">
                                	<input type="text" id="txtUserID" style="ime-mode:disabled;text-transform:uppercase;" onKeyUp="fn_ToUpperCase(this);">
                                    <!-- <asp:TextBox ID="txtUserID" runat="server" style="ime-mode:disabled;text-transform:uppercase;" onKeyUp="fn_ToUpperCase(this);"></asp:TextBox> -->
                                 </td>
                                 <td bgcolor="#FFFFFF" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="ST07.UserName" /> <!-- <asp:Label ID="lblUserName" runat="server" Text="ST07.UserName"></asp:Label> -->
                                </td>
                                <td class="left_5">
                                	<input type="text" ID="txtUserName" >
                                    <!-- <asp:TextBox ID="txtUserName" runat="server" ></asp:TextBox> -->
                                 </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div id="C_Result" style="overflow:auto;">
           <div class="total_count">
                [ <spring:message code="COMMON.TotalCont" /> : <div style='display:inline;' id="list_total"></div> ]
            </div>
	        <div >
	        	<table class="gridview" cellspacing="0" border="0" style="width:100%;border-collapse:collapse;" id="list_table">
	            	<thead>
						<tr>
							<th style="width:5%"><div align="center"><spring:message code="COMMON.Num"/></div></th>
							<th style="width:15%"><div align="center"><spring:message code="COMMON.UserID"/></div></th>
							<th style="width:20%"><div align="center"><spring:message code="ST07.UserName"/></div></th>
							<th style="width:10%"><div align="center"><spring:message code="ST07.UserGrp"/></div></th>
							<th style="width:10%"><div align="center"><spring:message code="ST07.Authority"/></div></th>
							<th style="width:15%"><div align="center"><spring:message code="ST07.LastLoginDT"/></div></th>
							<th style="width:15%"><div align="center"><spring:message code="COMMON.RegisterDate"/></div></th>
							<th style="width:10%"><div align="center"><spring:message code="COMMON.Register"/></div></th>
						</tr>
					</thead>
					<tbody id="list_data">
					</tbody>
				</table>
            </div>
                	
        	<div style="margin-top:5px;border:double 1px #A6A6A6;height:35px;border-radius:5px;background-color:#EEEEEE;">
			    <div style="float:left;text-align:left;padding-left:5px;padding-top:5px;">
			        <span>Show Page&nbsp;</span>
			        <select id="select_page_count"></select>
			        <span>&nbsp;of</span>
			        <div style='display:inline;' id="page_total"></div> pages
			    </div>
			    <div style="text-align:right;padding-right:5px;padding-top:5px;">
			        <span>Display&nbsp;</span>
			        <select id="select_show_count">
				  			<option value="10">10</option>
				  			<option value="20"  selected>20</option>
				  			<option value="30">30</option>
				  	</select>
			        <span>&nbsp;Records per Page</span>
			    </div>
			</div>

        	<div id="wrapper" style="visibility:hidden;overflow:hidden;height:0px;">
	            <table class="type08" border="1" id="list_excel"></table>
            </div>
        
        </div><!-- C_Result -->  
	</div><!-- C_Body -->
</div>
<jsp:include page="../bottom.jsp" flush="false" />
</body>
</html>
