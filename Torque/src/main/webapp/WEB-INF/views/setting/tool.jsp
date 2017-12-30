<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8"> 
	<title>index</title>
	<jsp:include page="../head.jsp" flush="false" />
	<style type="text/css">
	table.type08 {
		font-size:12px;
		font-weight: bold;
	    border-collapse: collapse;
	    text-align: left;
	    line-height: 1.5;
	    border-left: 1px solid #ccc;
	    margin: 20px 10px;
	}
	
	table.type08 thead th {
	    padding: 10px;
	    font-weight: bold;
	    border-top: 1px solid #ccc;
	    border-right: 1px solid #ccc;
	    border-bottom: 2px solid #c00;
	    background: #dcdcd1;
	}
	table.type08 tbody th {
	    padding: 10px;
	    font-weight: bold;
	    vertical-align: top;
	    border-right: 1px solid #ccc;
	    border-bottom: 1px solid #ccc;
	    background: #ececec;
	}
	table.type08 td {
	    padding: 10px;
	    vertical-align: top;
	    border-right: 1px solid #ccc;
	    border-bottom: 1px solid #ccc;
	}
	</style>
</head>
<body>
<jsp:include page="../menu.jsp" flush="false" />
<div class="container">
	<%-- <div class="form-inline">
		<div class="form-group">
		    <select>
		    	<option><spring:message code="search.all" /></option>
		    	<c:forEach var="item" items="${searchCondition}">
		    		<option value="${item.code}">${item.name}</option>
		    	</c:forEach>
		    </select> : 
		    <input type="text" class="form-control" id="searchText" placeholder="검색어를 입력하세요">
		    <button id="searchBtn" class="btn btn-default">Search</button>
		    <button id="excelBtn" class="btn btn-default">Excel</button>
		</div>
		<hr/>
	</div>
	<table class="table" id="list_table">
		<thead>
			<tr>
				<td>No.</td>
				<td>Title</td>
				<td>Content</td>
				<td>Item-1</td>
				<td>Item-2</td>
				<td>date</td>
			</tr>
		</thead>
		<tbody id="list_data">
		</tbody>
	</table> --%>
	<div id="C_Body">       
        <div id="C_Title">
            <div id="content-title">
                <i class="fa fa-pencil-square-o "></i><spring:message code="SCREEN.ST01" /> <!-- <asp:Label ID="lblTitle" runat="server" Text="SCREEN.ST01"> --></asp:Label>
            </div>
            <div id="content-title-nav">
                <i class="fa fa-angle-double-right"></i><spring:message code="MENU.SETTING" /> <!-- <asp:Label ID="lblMenuSystem" runat="server" Text="MENU.SETTING"> --></asp:Label>
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
                                <td width="8%" height="30" class="left_5" >
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp;<spring:message code="COMMON.Plant" /></td>
                                <td width="25%" class="left_5" ><select id="ddlPlant"></select></td>
                                <td  width="9%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp;<spring:message code="COMMON.StnType" /> <!-- <asp:Label ID="lblStnType" runat="server" Text="COMMON.StnType"></asp:Label> -->
                                </td>
                                <td width="13%" class="left_5">
	                                <select id="ddlStnType">
		  							</select>
                                    <!-- <asp:DropDownList ID="ddlStnType" runat="server" AutoPostBack="true"
                                        onselectedindexchanged="ddlStnType_SelectedIndexChanged" ></asp:DropDownList> -->
                                </td>
                                <td width="9%" class="left_5" >
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="ST01.ToolGrp" /><!-- <asp:Label ID="lblToolGrp" runat="server" Text="ST01.ToolGrp"></asp:Label> -->
                                </td>
                                <td  width="10%" class="left_5">
                                	<select id="ddlToolGrp"></select>
                                	<!-- <asp:DropDownList ID="ddlToolGrp" runat="server" AutoPostBack="true" onselectedindexchanged="ddlToolGrp_SelectedIndexChanged" ></asp:DropDownList> -->
                                </td>
                                <td rowspan="3"  class="content-button">
                                	
                                	<c:set var="btnSearch"><spring:message code="BUTTON.Search"/></c:set>
                                	<input type="button" id="btnSearch" value="${btnSearch}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                	<c:set var="btnExcel"><spring:message code="BUTTON.Excel"/></c:set>
                                	<input type="button" id="btnExcel" value="${btnExcel}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                    <!-- <asp:Button ID="btnSearch" runat="server" Text="BUTTON.Search"  OnClick="btnSearch_Click" />-->
                                    <!-- <asp:Button ID="btnExcel" runat="server" Text="BUTTON.Excel" OnClick="btnExcel_Click" /> --> 
                                    <div style="padding-top:3px;">
                                    <c:set var="btnReg"><spring:message code="BUTTON.Registration"/></c:set>
                                	<input type="button" id="btnReg" value="${btnReg}" class="ui-button ui-widget ui-state-default ui-corner-all" onclick="OpenRegistration('', '')" role="button">
                                    	<!-- <asp:Button ID="btnReg" runat="server" Text="BUTTON.Registration" OnClientClick="OpenRegistration('', '')" /> -->
                                    </div> 
                                </td>
                            </tr>
                            <tr>
                                <td height="30" ></td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="ST01.Tool" /><!-- <asp:Label ID="lblTool" runat="server" Text="ST01.Tool"></asp:Label> -->
                                </td>
                                <td class="left_5">
                                	<select id="ddlTool"></select>
                                	<!-- <asp:DropDownList ID="ddlTool" runat="server" AutoPostBack="true" onselectedindexchanged="ddlTool_SelectedIndexChanged" ></asp:DropDownList> -->
                                </td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="ST01.ToolType" /><!-- <asp:Label ID="lblToolType" runat="server" Text="ST01.ToolType"></asp:Label> -->
                                </td>
                                <td class="left_5">
                                	<select id="ddlToolType"></select>
                                	<!-- <asp:DropDownList ID="ddlToolType" runat="server" AutoPostBack="true" onselectedindexchanged="ddlToolType_SelectedIndexChanged"></asp:DropDownList> -->
                                </td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="ST01.ToolState" /><!-- <asp:Label ID="lblToolState" runat="server" Text="ST01.ToolState"></asp:Label> -->
                                </td>
                                <td class="left_5" colspan="4">
                                	<select id="ddlToolState"></select>
                                	<!-- <asp:DropDownList ID="ddlToolState" runat="server" AutoPostBack="true" onselectedindexchanged="ddlToolState_SelectedIndexChanged"></asp:DropDownList> -->
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div id="C_Result">
            <div class="total_count">
                [ <spring:message code="COMMON.TotalCont" /> : <div style='display:inline;' id="list_total"></div> ]
            </div>
            <div style="position: relative;width:500;overflow:auto;background-color:#F5F5F5" >
	            <!-- <table class="table" id="list_table"> -->
	            <!-- <table style="width:3700px;" id="list_table"> -->
	            <!-- <table class="type08" style="width:3700px;" id="list_table"> -->
	            <table class="gridview" cellspacing="0" border="0" style="width:3700px;border-collapse:collapse;" id="list_table">
					<thead>
						<tr>
							<th><spring:message code="COMMON.Num"/></th>
							<th><spring:message code="COMMON.StnType"/></th>
							<th><spring:message code="ST01.ToolGrp"/></th>
							<th><spring:message code="ST01.Tool"/></th>
							<th><spring:message code="ST01.ToolSerial"/></th>
							<th><spring:message code="ST01.ToolName"/></th>
							<th><spring:message code="ST01.ToolAlias"/></th>
							<th><spring:message code="ST01.ToolState"/></th>
							<th><spring:message code="ST04.Code"/></th>
							<th><spring:message code="ST01.SerialParallelFlag"/></th>
							<th><spring:message code="ST01.ToolType"/></th>
							<th><spring:message code="ST01.ToolIP"/></th>
							<th><spring:message code="ST01.ToolPort"/></th>
							<th><spring:message code="ST01.CompToolFlag"/></th>
							<th><spring:message code="ST01.TorqLowVal"/></th>
							<th><spring:message code="ST01.TorqOkVal"/></th>
							<th><spring:message code="ST01.TorqHighVal"/></th>
							<th><spring:message code="ST01.AnglLowVal"/></th>
							<th><spring:message code="ST01.AnglOkVal"/></th>
							<th><spring:message code="ST01.AnglHighVal"/></th>
							<th><spring:message code="ST01.WebDispFlag"/></th>
							<th><spring:message code="ST01.SendJobNoFlag"/></th>
							<th><spring:message code="ST01.ResetJobNo"/></th>
							<th><spring:message code="ST01.CurrBodyNo"/></th>
							<th><spring:message code="ST01.LastBodyNo"/></th>
							<th><spring:message code="ST01.LastWorkingDate"/></th>
							<th><spring:message code="ST01.CheckStatusDT"/></th>
							<th><spring:message code="COMMON.RegisterDate"/></th>
							<th><spring:message code="COMMON.Register"/></th>
						</tr>
					</thead>
					<tbody id="list_data">
					</tbody>
				</table>
            </div>
            
            <div class="well">
				<div class="row">
				  <div class="col-md-6">
				  	<div class="pull-left">
				  		PAGE 
				  		<select id="select_page_count">
			  			</select>
			  			of <div style='display:inline;' id="page_total"></div> pages
			  		</div>
				  </div>
				  <div class="col-md-6">
				  	<div class="pull-right">
				  		SHOW 
				  		<select id="select_show_count">
				  			<option value="10">10</option>
				  			<option value="20" selected>20</option>
				  			<option value="30">30</option>
				  		</select>
				  	</div>
				  </div>
				</div>
			</div>
        	
        	<div id="wrapper" style="visibility:hidden">
	            <table class="type08" border="1" id="list_excel"></table>
            </div>
        </div>  
    </div>
	
</div>
<script>
$(document).ready(function(){
	$.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
	
	getPlant();
	getStnType('A');
	getToolGroup('A');
	//getToolId( All or Select ,plant, device_grp, station_gub, line_cd, display('w') )
	ddlTool();
				 
	getToolType('A');
	getToolState('A');
	
	$.ajaxSetup({async:true});	//비동기 켜기
	
	getToolList();
	/* 
	$("#searchText").on('keydown', function(e){
		if(e.keyCode == 13){
			getList();
		}
	});
	
	$("#searchBtn").on('click', function(e){
		getList();
	});
	 */
	
/* 	$("a[name='device']").on("click", function(e){ //제목 
		e.preventDefault();
		fn_openDetail($(this));
	}); */
	 
	$("#btnSearch").on('click', function(e){
		getToolList();
	});
	
	$('#select_page_count').on('change', function(){
		now_page = $('#select_page_count').val();
		show_count = $('#select_show_count').val();
		getToolList();
		
	});
	 
	$('#select_show_count').on('change', function(){
		now_page = $('#select_page_count').val();
		show_count = $('#select_show_count').val();
		getToolList();
		
	});
	 

	$('#btnExcel').on('click', function(){

        var postfix = fn_Excelpostfix() //"-"+year + month + day + "_" + hour + mins;
        var fileName = $('#content-title').text().trim()+ postfix + ".xls";
        
        getExcelData();
        
        fn_ExcelReport('list_excel', fileName);
		
	});

	$('#ddlStnType').on('change', function(){
		now_page = 1;
		getToolGroup();
		ddlTool();
		getToolList();
	});
	
	$('#ddlToolGrp').on('change', function(){
		now_page = 1;
		ddlTool();
		getToolList();
	});
	
	$('#ddlTool').on('change', function(){
		getToolList();
	});
	
	$('#ddlToolType').on('change', function(){
		getToolList();
	});
	
	$('#ddlToolState').on('change', function(){
		//getSearch();
	});
	 
});


function ddlTool(){
	getToolId('A',$('#ddlPlant').val(),$('#ddlToolGrp').val(),$('#ddlStnType').val(),'-1','-1');
}

var now_page = 1;
var show_count = 20;

function getToolList(){
      
	var vplant_cd = $('#ddlPlant').val()
	var vstn_type = $('#ddlStnType').val();
	var vdevice_grp_cd = $('#ddlToolGrp').val();
	var vdevice = $('#ddlTool').val();
	var vdevice_type = $('#ddlToolType').val();
	var vdevice_state = $('#ddlToolState').val();
	
	var params = "plant_cd="+vplant_cd+
				"&stn_type="+vstn_type+
				"&device_grp_cd="+vdevice_grp_cd +
				"&device="+vdevice +
				"&device_type="+vdevice_type +
				"&device_status="+vdevice_state+
				"&page="+now_page+
				"&show_count="+show_count;
	
	$.get('/api/setting/gettoollist?'+params,function(data){
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
				//console.log(item);
			
				$('#list_data').append(
					  '<tr>' 
					+ '	<td>' + item.rnum +'</td>'
					+ '	<td>' + item.stn_gub +'</td>'
					+ '	<td>' + item.device_grp_cd +'</td>'
					+ '	<td><a href=\'#\' onClick="OpenRegistration(\'' + item.device_id.trim() +'\',\''+item.device_serial+ '\');">' + item.device_id +'</a></td>'
					+ '	<td>' + item.device_serial +'</td>'
					+ '	<td>' + item.device_nm +'</td>'
					+ '	<td>' + item.device_alias +'</td>'
					+ '	<td>' + item.device_status +'</td>'
					+ '	<td>' + item.line_cd +'</td>'
					+ '	<td>' + item.serial_parallel_flg +'</td>'
					+ '	<td>' + item.device_type +'</td>'
					+ '	<td>' + item.device_ip +'</td>'
					+ '	<td>' + item.device_port  +'</td>'
					+ '	<td>' + item.completed_device_flg  +'</td>'
					+ '	<td>' + item.torque_low +'</td>'
					+ '	<td>' + item.torque_ok  +'</td>'
					+ '	<td>' + item.torque_high  +'</td>'
					+ '	<td>' + item.angle_low +'</td>'
					+ '	<td>' + item.angle_ok  +'</td>'
					+ '	<td>' + item.angle_high  +'</td>'
					+ '	<td>' + item.web_display_flg  +'</td>'
					+ '	<td>' + item.jobno_send_flg  +'</td>'
					+ '	<td>' + item.scan_jobreset_flg  +'</td>'
					+ '	<td>' + item.curr_body_no +'</td>'
					+ '	<td>' + item.last_body_no  +'</td>'
					+ '	<td>' + ChangeDateFormat(item.last_work_dt)  +'</td>'
					+ '	<td>' + ChangeDateFormat(item.device_status_dt)  +'</td>'
					+ '	<td>' + ChangeDateFormat(item.regdt) +'</td>'
					+ '	<td>' + item.reg_user_id +'</td>'
					+ '</tr>'
				);
			});
			
		}
	});
}


function getExcelData(){
	//$.get('/api/setting/gettoollist?'+params,function(data){

	var vplant_cd = $('#ddlPlant').val()
	var vstn_type = $('#ddlStnType').val();
	var vdevice_grp_cd = $('#ddlToolGrp').val();
	var vdevice = $('#ddlTool').val();
	var vdevice_type = $('#ddlToolType').val();
	var vdevice_state = $('#ddlToolState').val();
	
	var params = "plant_cd="+vplant_cd+
				"&stn_type="+vstn_type+
				"&device_grp_cd="+vdevice_grp_cd +
				"&device="+vdevice +
				"&device_type="+vdevice_type +
				"&device_status="+vdevice_state+
				"&page="+now_page+
				"&show_count="+show_count+
				"&excel_down=Y";
	
	$.ajax({
			url:'/api/setting/gettoollist?'+params,
			type:'GET',
			async:false,
			success: function(data) {
				if(data.result == 200){
					$("#list_excel").empty();
					$("#list_excel").append("<thead>");
					$("#list_excel").append("<th><spring:message code='COMMON.Num'/></th>");
					$("#list_excel").append("<th><spring:message code='COMMON.StnType'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.ToolGrp'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.Tool'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.ToolSerial'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.ToolName'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.ToolAlias'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.ToolState'/></th>");
					$("#list_excel").append("<th><spring:message code='ST04.Code'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.SerialParallelFlag'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.ToolType'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.ToolIP'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.ToolPort'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.CompToolFlag'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.TorqLowVal'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.TorqOkVal'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.TorqHighVal'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.AnglLowVal'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.AnglOkVal'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.AnglHighVal'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.WebDispFlag'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.SendJobNoFlag'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.ResetJobNo'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.CurrBodyNo'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.LastBodyNo'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.LastWorkingDate'/></th>");
					$("#list_excel").append("<th><spring:message code='ST01.CheckStatusDT'/></th>");
					$("#list_excel").append("<th><spring:message code='COMMON.RegisterDate'/></th>");
					$("#list_excel").append("<th><spring:message code='COMMON.Register'/></th>");
					$("#list_excel").append("</thead>");
					
					$("#list_excel").append("<tbody>");
					
					data.list.forEach(function(item){
						
						$('#list_excel').append(
							  '<tr>' 
							+ '	<td>' + item.rnum +'</td>'
							+ '	<td>' + item.stn_gub +'</td>'
							+ '	<td>' + item.device_grp_cd +'</td>'
							+ '	<td>' + item.device_id +'</td>'
							+ '	<td>' + item.device_serial +'</td>'
							+ '	<td>' + item.device_nm +'</td>'
							+ '	<td>' + item.device_alias +'</td>'
							+ '	<td>' + item.device_status +'</td>'
							+ '	<td>' + item.line_cd +'</td>'
							+ '	<td>' + item.serial_parallel_flg +'</td>'
							+ '	<td>' + item.device_type +'</td>'
							+ '	<td>' + item.device_ip +'</td>'
							+ '	<td>' + item.device_port  +'</td>'
							+ '	<td>' + item.completed_device_flg  +'</td>'
							+ '	<td>' + item.torque_low +'</td>'
							+ '	<td>' + item.torque_ok  +'</td>'
							+ '	<td>' + item.torque_high  +'</td>'
							+ '	<td>' + item.angle_low +'</td>'
							+ '	<td>' + item.angle_ok  +'</td>'
							+ '	<td>' + item.angle_high  +'</td>'
							+ '	<td>' + item.web_display_flg  +'</td>'
							+ '	<td>' + item.jobno_send_flg  +'</td>'
							+ '	<td>' + item.scan_jobreset_flg  +'</td>'
							+ '	<td>' + item.curr_body_no +'</td>'
							+ '	<td>' + item.last_body_no  +'</td>'
							+ '	<td style=mso-number-format:"\@";>' + ChangeDateFormat(item.last_work_dt)  +'</td>'
							+ '	<td style=mso-number-format:"\@";>' + ChangeDateFormat(item.device_status_dt)  +'</td>'
							+ '	<td style=mso-number-format:"\@";>' + ChangeDateFormat(item.regdt) +'</td>'
							+ '	<td>' + item.reg_user_id +'</td>'
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

function OpenRegistration(ToolID, ToolSerial) {
	//var title = fn_DisplayDictionary("SCREEN.ST01", "R");
    var title= '<spring:message code="SCREEN.ST01" />';
    fn_ShowDialog('/view/setting/toolP01?ToolID=' + ToolID + '&ToolSerial=' + ToolSerial, title, '750', '540', true);
}

function CloseDialog(flg) {
    $('#btnSearch').click()
    fn_CloseDialog('', flg);
}



/* function OpenRegistration(ToolID, ToolSerial) {
    //var title = fn_DisplayDictionary("SCREEN.ST01", "R");
    var title= 'Tool'
    fn_ShowDialog('/SETTING/ST01P01.aspx?ToolID=' + ToolID + '&ToolSerial=' + ToolSerial, title, '750', '520', true);//view/setting/tool''//view/setting/tool'
}
 */
</script>
<!-- 파일 생성중 보여질 진행막대를 포함하고 있는 다이얼로그 입니다. -->
<div title="Data Download" id="preparing-file-modal" style="display: none;">
    <div id="progressbar" style="width: 100%; height: 22px; margin-top: 20px;"></div>
</div>

<!-- 에러발생시 보여질 메세지 다이얼로그 입니다. -->
<div title="Error" id="error-modal" style="display: none;">
    <p>생성실패.</p>
</div>
<jsp:include page="../bottom.jsp" flush="false" />
</body>
</html>
