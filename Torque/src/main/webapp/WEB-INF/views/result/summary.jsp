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
	
	
	/* Define the hover highlight color for the table row */
    .type08 tr:hover {
          /* background-color: #ffff99; */
          background-color: #E0E0E0;
    }
    
	</style>
</head>
<body>
<jsp:include page="../menu.jsp" flush="false" />
<!-- // jQuery UI CSS파일 --> 
<!-- <link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" /> -->  
<!-- // jQuery 기본 js파일 -->
<!-- <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>   -->
<!-- // jQuery UI 라이브러리 js파일 -->
<!-- <script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>    -->

<script type="text/javascript">
    $(document).ready(function() {
        $("#btnSearch").button();
        $("#btnExcel").button();
        $("#btnReg").button();

        /* $('#dateRangePicker').datepicker({
        	
        }); */
       
        $('#txtDate').datepicker({
        	 autoclose : true,
        	 todayHighlight : true,
        	 format: "yyyy-mm-dd",
        	 language: "kr"
        	 });
        
        $.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
    	
    	getPlant();
    	getLine('A');
    	getShift('A');
    	ddlTool();
    	
    	$("#txtDate").val(fn_today());
		$.ajaxSetup({async:true});	//비동기 켜기
		
		//getList();
		
		$("#btnSearch").on('click', function(e){
			//getList();
		});
		
		$('#ddlLine').on('change', function(){
			ddlTool();
			$('#btnSearch').click()
    	});
		
		$('#ddlShift').on('change', function(){
			$('#btnSearch').click()
    	});
		
		$('#ddlTool').on('change', function(){
			$('#btnSearch').click()
    	});
		
		
		$('#select_page_count').on('change', function(){
	    		now_page = $('#select_page_count').val();
	    		show_count = $('#select_show_count').val();
	    		getList();
	    		
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
	
    function ddlTool(){
    	getToolId('A',$('#ddlPlant').val(),'-1','N',$('#ddlLine').val(),'W');
    }
    
    var now_page = 1;
    var show_count = 10;

    function getList(){
          
    	getPlant();
    	getLine('A');
    	getShift('A');
    	ddlTool();
    	
    	var vplant_cd = $('#ddlPlant').val()
    	var vwork_dt = $('#txtDate').val();
    	var vline = $('#ddlLine').val();
    	var vshift = $('#ddlShift').val();
    	var vtool = $('#ddlTool').val();
    	
    	var params = "?plant_cd="+vplant_cd.trim()+
    				 "&work_dt="+vwork_dt.trim()+
    				 "&line="+vline.trim() +
    				 "&shift="+vshift.trim() +
    				 "&tool="+vtool.trim() +
    				 "&page="+now_page+
    				 "&show_count="+show_count;
    	
    	$.get('/api/setting/getresultsummary'+params,function(data){
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
    
</script>
<div class="container">
	<div id="C_Body">       
        <div id="C_Title">
            <div id="content-title">
                <i class="fa fa-list-ul"></i> <span id="ctl00_ContentPlaceHolder1_lblTitle">Tool Result Summary</span>
            </div>
            <div id="content-title-nav">
                <i class="fa fa-angle-double-right"></i> <span id="ctl00_ContentPlaceHolder1_lblMenuSystem">RESULT</span>
            </div>
            <div id="content-title-bar">
            </div>  
        </div> 
        <div id="C_Search">
            <table cellpadding="1" cellspacing="1" border="1" align="center" class="search_table">
                <tbody><tr>
                    <td height="70">
                        <table width="100%">
                            <tbody><tr>
                                <td width="1%"></td>
                                <td width="6%" height="30" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <span id="ctl00_ContentPlaceHolder1_lblPlant">Plant</span>
                                </td>
                                <td width="15%" class="left_5">
                                    <select id="ddlPlant"></select>
                                </td>
                                <td width="7%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <span id="ctl00_ContentPlaceHolder1_lblDate">Date</span>
                                    <div class="input-group input-append date" id="dateRangePicker"> </div>
                                </td>
                                <td width="20%" class="left_5">
                                    <input name="txtDate" type="text" id="txtDate" readonly="true" style="width:100px;" class="input-group input-append date"">
                                    <input type="hidden" name="hdDate" id="hdDate">
                                </td>
                                <td width="5%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <span id="ctl00_ContentPlaceHolder1_lblLine">Line</span>
                                </td>
                                <td width="13%" class="left_5">
                                	<select id="ddlLine"></select>
                                    
                                </td>
                                <td rowspan="2" class="content-button">
                                    <input type="submit" name="ctl00$ContentPlaceHolder1$btnSearch" value="Search" id="ctl00_ContentPlaceHolder1_btnSearch" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                    <input type="submit" name="ctl00$ContentPlaceHolder1$btnExcel" value="Excel" id="ctl00_ContentPlaceHolder1_btnExcel" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <span id="ctl00_ContentPlaceHolder1_lblShift">Shift</span>
                                </td>
                                <td class="left_5">
                                	<select id="ddlShift"></select>
                                    <!-- <select name="ctl00$ContentPlaceHolder1$ddlShift" onchange="javascript:setTimeout('__doPostBack(\'ctl00$ContentPlaceHolder1$ddlShift\',\'\')', 0)" id="ctl00_ContentPlaceHolder1_ddlShift">
									</select> -->
                                 </td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <span id="ctl00_ContentPlaceHolder1_lblTool">Tool</span>
                                </td>
                                <td class="left_5" colspan="3">
                                    <select id="ddlTool"></select>
                                 </td>
                            </tr>
                        </tbody></table>
                    </td>
                </tr>
            </tbody></table>
        </div>
        <div id="C_Result" style="overflow:auto;">
           <div class="total_count">
                [ <spring:message code="COMMON.TotalCont" /> : <div style='display:inline;' id="list_total"></div> ]
            </div>
	        <div style="position: relative;width:500;overflow:auto;background-color:#F5F5F5" >
	            <table class="type08" style="width:auto;" id="list_table">
					<thead>
						<tr>
							<th><spring:message code="COMMON.Num"/></th>
							<th><spring:message code="COMMON.Tool"/></th>
							<th><spring:message code="COMMON.Line"/></th>
							<th><spring:message code="COMMON.Total"/></th>
							<th><spring:message code="COMMON.OK"/></th>
							<th><spring:message code="COMMON.NG"/></th>
							<th><spring:message code="COMMON.NoScan"/></th>
							<th><spring:message code="COMMON.Pass"/></th>
							<th><spring:message code="COMMON.Repair"/></th>
							<th><spring:message code="COMMON.TotalOK"/></th>
							<th><spring:message code="COMMON.TotalNG"/></th>
							<th><spring:message code="COMMON.PassRatio"/></th>
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
				  			<option value="10" selected>10</option>
				  			<option value="20">20</option>
				  			<option value="30">30</option>
				  		</select>
				  	</div>
				  </div>
				</div>
			</div>
        	
        	<div id="wrapper" style="visibility:hidden">
	            <table class="type08" border="1" id="list_excel"></table>
            </div>
        
        </div><!-- C_Result -->  
	</div><!-- C_Body -->
</div>
</body>
</html>
