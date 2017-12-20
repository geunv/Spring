<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8"> 
	<title>detail</title>
	<jsp:include page="../head.jsp" flush="false" />
</head>
<body>
<jsp:include page="../menu.jsp" flush="false" />

<script type="text/javascript">
    $(document).ready(function() {
        $("#btnSearch").button();
        $("#btnExcel").button();
        //$("#btnReg").button();

        /* $('#dateRangePicker').datepicker({
        	
        }); */

        $("#txtDate").datepicker({
            changeMonth: true,
            dateFormat: 'yy-mm-dd',
        });
        
        $.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
    	
    	getPlant();
    	getLine('A');
    	getShift('A');
    	ddlTool();
    	
    	$("#txtDate").val(fn_getday());
		$.ajaxSetup({async:true});	//비동기 켜기
		
		getList();
		
		$("#btnSearch").on('click', function(e){
			getList();
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
		
		$('#btnExcel').on('click', function(){

	        var postfix = fn_Excelpostfix() //"-"+year + month + day + "_" + hour + mins;
	        var fileName = $('#content-title').text().trim()+ postfix + ".xls";
	        getExcelData();
	        fn_ExcelReport('list_excel', fileName);
			
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
    	
    	$.get('/api/result/getresultsummary'+params,function(data){
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
							+ ' <td>' + item.rnum +'</td>'
							+ ' <td>' + item.device +'</td>'
							+ ' <td>' + item.line_cd +'</td>'
							+ ' <td>' + item.total +'</td>'
							+ ' <td>' + item.ok +'</td>'
							+ ' <td>' + item.ng +'</td>'
							+ ' <td>' + item.noscan +'</td>'
							+ ' <td>' + item.pass +'</td>'
							+ ' <td>' + item.repair +'</td>'
							+ ' <td>' + item.tot_ok +'</td>'
							+ ' <td>' + item.tot_ng +'</td>'
							+ ' <td>' + item.pass_ratio +'</td>'
    					+ '</tr>'
    				);
    			});
    			
    		}
    	});
    }

    function getExcelData(){
    	//$.get('/api/setting/gettoollist?'+params,function(data){

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
    				 "&show_count="+show_count+
    				 "&excel_down=Y";
    	
    	$.ajax({
    			url:'/api/result/getresultsummary'+params,
    			type:'GET',
    			async:false,
    			success: function(data) {
    				if(data.result == 200){
    					$("#list_excel").empty();
    					$("#list_excel").append("<thead>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Num'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Tool'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Line'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Total'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.OK'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.NG'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.NoScan'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Pass'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Repair'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.TotalOK'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.TotalNG'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.PassRatio'/></th>");
    					$("#list_excel").append("</thead>");
    					
    					$("#list_excel").append("<tbody>");
    					
    					data.list.forEach(function(item){
    						
    						$('#list_excel').append(
    							  '<tr>' 
	    							+ ' <td>' + item.rnum +'</td>'
									+ ' <td>' + item.device +'</td>'
									+ ' <td>' + item.line_cd +'</td>'
									+ ' <td>' + item.total +'</td>'
									+ ' <td>' + item.ok +'</td>'
									+ ' <td>' + item.ng +'</td>'
									+ ' <td>' + item.noscan +'</td>'
									+ ' <td>' + item.pass +'</td>'
									+ ' <td>' + item.repair +'</td>'
									+ ' <td>' + item.tot_ok +'</td>'
									+ ' <td>' + item.tot_ng +'</td>'
									+ ' <td>' + item.pass_ratio +'</td>'
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
</script>
<div class="container">
	<div id="C_Body">       
        <div id="C_Title">
            <div id="content-title">
                <i class="fa fa-list-ul"></i> <spring:message code="SCREEN.RS01" />
            </div>
            <div id="content-title-nav">
                <i class="fa fa-angle-double-right"></i> <spring:message code="MENU.RESULT" />
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
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp;  <spring:message code="COMMON.Plant" />
                                </td>
                                <td width="15%" class="left_5">
                                    <select id="ddlPlant"></select>
                                </td>
                                <td width="7%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Date" />
                                    <div class="input-group input-append date" id="dateRangePicker"> </div>
                                </td>
                                <td width="20%" class="left_5">
                                    <input name="txtDate" type="text" id="txtDate" readonly="true" style="width:100px;" class="input-group input-append date"">
                                    <input type="hidden" name="hdDate" id="hdDate">
                                </td>
                                <td width="5%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Line" />
                                </td>
                                <td width="13%" class="left_5">
                                	<select id="ddlLine"></select>
                                    
                                </td>
                                <td rowspan="2" class="content-button">
                                    <input type="submit" value="Search" id="btnSearch" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                    <input type="submit" value="Excel" id="btnExcel" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Shift" />
                                </td>
                                <td class="left_5">
                                	<select id="ddlShift"></select>
                                    <!-- <select name="ctl00$ContentPlaceHolder1$ddlShift" onchange="javascript:setTimeout('__doPostBack(\'ctl00$ContentPlaceHolder1$ddlShift\',\'\')', 0)" id="ctl00_ContentPlaceHolder1_ddlShift">
									</select> -->
                                 </td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Tool" />
                                </td>
                                <td class="left_5" colspan="3">
                                    <select id="ddlTool" style="width:320px;"></select>
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
	        <div >
	        	<table class="gridview" cellspacing="0" border="0" style="width:100%;border-collapse:collapse;" id="list_table">
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
            
            <!-- <div class="well">
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
			</div> -->
        	
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
				  			<option value="10" selected>10</option>
				  			<option value="20">20</option>
				  			<option value="30">30</option>
				  	</select>
			        <span>&nbsp;Records per Page</span>
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
