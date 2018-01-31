<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8"> 
	<title>Cycle Test Result</title>
	<jsp:include page="../head.jsp" flush="false" />
</head>
<body>
<jsp:include page="../menu.jsp" flush="false" />

<script type="text/javascript">
	$(document).ready(function() {
    	$("#btnSearch").button();
        $("#btnExcel").button();
        //$("#btnReg").button();

		$("#txtDate").datepicker({
        	changeMonth: true,
            dateFormat: 'yy-mm-dd',
        });
        
        
        $.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
    	
        
        init();
    	        
        $("#txtDate").val(fn_getday());					/////날짜
		$.ajaxSetup({async:true});	//비동기 켜기
		
		getList();
		
		$("#btnSearch").on('click', function(e){
			now_page = 1;
    		show_count  = $('#select_show_count').val();
			getList();
		});
		
		$("#txtBodyNo").keydown(function (key) {
	        if(key.keyCode == 13){//키가 13이면 실행 (엔터는 13)
	        	$('#btnSearch').click()
	        }
	    });
		
		$('#ddlProgram').on('change', function(){
			getProcList('A');
			$('#btnSearch').click()
    	});
		
		$('#ddlProcess').on('change', function(){
			$('#btnSearch').click()
    	});
		
		$('#ddlCarType').on('change', function(){
			$('#btnSearch').click()
    	});
		
		$('#ddlCycleTestItem').on('change', function(){
			$('#btnSearch').click()
    	});
		
		$('#ddlHour').on('change', function(){
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
	
    function init(){
		getPlant();
		getCarType('A');
    	getHour('A');
    	getPgmList('A');
    	getProcList('A');
    	ddlTool();
    }
    
    function ddlTool(){
    	getToolId('A',$('#ddlPlant').val(),'-1','N','-1','W');
    }
    
    
    var now_page = 1;
    var show_count = 20;

    function getList(){
      
    	var params = "?plant_cd="+$('#ddlPlant').val()+
    				 "&work_dt="+$('#txtDate').val()+
    				 "&hh="+$('#ddlHour').val()+
    				 "&pgm_id="+$('#ddlProgram').val() +
    				 "&proc_id="+$('#ddlProcess').val() +
    				 "&car_type=" + $('#ddlCarType').val() +
    				 "&tool=" + $('#ddlTool').val() +
    				 "&txt_car_type=" + $('#txtCarType').val() +
    				 "&txt_body_no=" + $('#txtBodyNo').val() +
    				 "&page="+now_page+
    				 "&show_count="+show_count;
    	$.ajax({
			type : "GET",
			url : '/api/result/getcycletestresult'+params,
			beforeSend : function(){
				$('#load-image').show();
			}
		}).done(function(data) {
			//console.log(result);
			$('#load-image').hide();
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
    				
    			    var var_tightening_result = "";
    			    var var_tor_state = "";
    			    var var_ang_state = "";
    			    
    			    if ( item.batch_tightening_result == "0" )
    			    	var_tightening_result = "<font color='red'>NG</font>";
    			    
    			    if (item.batch_tightening_result == "1")
    			    	var_tightening_result = "OK";
    			    
					if (item.tor_state == "0")
						var_tor_state = "Low";
					else if (item.tor_state == "1")
						var_tor_state = "OK";
					else if (item.tor_state == "2")
						var_tor_state = "High";
					
					if (item.ang_state == "0")
						var_ang_state = "var_ang_state";
					else if (item.ang_state == "1")
						var_ang_state = "OK";
					else if (item.ang_state == "2")
						var_ang_state = "High";
						
    				$('#list_data').append(
    					'<tr>'
    					+ ' <td>' + item.rnum +'</td>'
    					+ ' <td class="left_5">' + item.program +'</td>'
    					+ ' <td class="left_5">' + item.process +'</td>'
    					+ ' <td>' + ChangeDateFormatSimple(item.cycle_test_dt) +'</td>'
    					+ ' <td>' + item.cycle_test_hour +'</td>'
    					+ ' <td>' + item.shift +'</td>'
    					+ ' <td>' + item.car_type_grp +'</td>'
    					+ ' <td class="left_5">' + item.device_id   +'</td>'
    					+ ' <td>' + item.body_no +'</td>'
    					+ ' <td>' + item.mes_pbsout_seq +'</td>'
    					+ ' <td>' + item.repair_job_num +'</td>'
    					+ ' <td>' + item.tot_batch_num +'</td>'
    					+ ' <td>' + item.batch_num +'</td>'
    					+ ' <td>' + item.tighten_id +'</td>'
    					+ ' <td>' + var_tightening_result +'</td>'
    					+ ' <td>' + var_tor_state +'</td>'
    					+ ' <td>' + item.tor_value +'</td>'
    					+ ' <td>' + var_ang_state +'</td>'
    					+ ' <td>' + item.ang_value +'</td>'
    					+ ' <td>' + ChangeDateFormat(item.regdt) +'</td>'
    					+ ' <td>' + item.reg_user_id +'</td>'
    					+ '</tr>'
    				);
    			});
    			
    		}
			
		}).fail(function(data) {
			$('#load-image').hide();
			alert(data);
		});
    	
    	/* $.get('/api/result/getcycletestresult'+params,function(data){
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
    				
    			    var var_tightening_result = "";
    			    var var_tor_state = "";
    			    var var_ang_state = "";
    			    
    			    if ( item.batch_tightening_result == "0" )
    			    	var_tightening_result = "<font color='red'>NG</font>";
    			    
    			    if (item.batch_tightening_result == "1")
    			    	var_tightening_result = "OK";
    			    
					if (item.tor_state == "0")
						var_tor_state = "Low";
					else if (item.tor_state == "1")
						var_tor_state = "OK";
					else if (item.tor_state == "2")
						var_tor_state = "High";
					
					if (item.ang_state == "0")
						var_ang_state = "var_ang_state";
					else if (item.ang_state == "1")
						var_ang_state = "OK";
					else if (item.ang_state == "2")
						var_ang_state = "High";
						
    				$('#list_data').append(
    					'<tr>'
    					+ ' <td>' + item.rnum +'</td>'
    					+ ' <td class="left_5">' + item.program +'</td>'
    					+ ' <td class="left_5">' + item.process +'</td>'
    					+ ' <td>' + ChangeDateFormatSimple(item.cycle_test_dt) +'</td>'
    					+ ' <td>' + item.cycle_test_hour +'</td>'
    					+ ' <td>' + item.shift +'</td>'
    					+ ' <td>' + item.car_type_grp +'</td>'
    					+ ' <td class="left_5">' + item.device_id   +'</td>'
    					+ ' <td>' + item.body_no +'</td>'
    					+ ' <td>' + item.mes_pbsout_seq +'</td>'
    					+ ' <td>' + item.repair_job_num +'</td>'
    					+ ' <td>' + item.tot_batch_num +'</td>'
    					+ ' <td>' + item.batch_num +'</td>'
    					+ ' <td>' + item.tighten_id +'</td>'
    					+ ' <td>' + var_tightening_result +'</td>'
    					+ ' <td>' + var_tor_state +'</td>'
    					+ ' <td>' + item.tor_value +'</td>'
    					+ ' <td>' + var_ang_state +'</td>'
    					+ ' <td>' + item.ang_value +'</td>'
    					+ ' <td>' + ChangeDateFormat(item.regdt) +'</td>'
    					+ ' <td>' + item.reg_user_id +'</td>'
    					+ '</tr>'
    				);
    			});
    			
    		}
    	}); */
    }
    
    function getExcelData(){
    	//$.get('/api/setting/gettoollist?'+params,function(data){
var params = "?plant_cd="+$('#ddlPlant').val()+
    				 "&work_dt="+$('#txtDate').val()+
    				 "&hh="+$('#ddlHour').val()+
    				 "&pgm_id="+$('#ddlProgram').val() +
    				 "&proc_id="+$('#ddlProcess').val() +
    				 "&car_type=" + $('#ddlCarType').val() +
    				 "&tool=" + $('#ddlTool').val() +
    				 "&txt_car_type=" + $('#txtCarType').val() +
    				 "&txt_body_no=" + $('#txtBodyNo').val() +
    				 "&page="+now_page+
    				 "&show_count="+show_count+
    				 "&excel_down=Y";
    	
    	$.ajax({
    			url:'/api/result/getcycletestresult'+params,
    			type:'GET',
    			async:false,
    			success: function(data) {
    				if(data.result == 200){
    					$("#list_excel").empty();
    					
    					
    					
						
    					$("#list_excel").append("<thead>");
    					
    					$("#list_excel").append("<th style='width:2%'><div align='center'><spring:message code='COMMON.Num'/></div></th>");
    					$("#list_excel").append("<th style='width:5%'><div align='center'><spring:message code='COMMON.Program'/></div></th>");
    					$("#list_excel").append("<th style='width:5%'><div align='center'><spring:message code='SM01.Process'/></div></th>");
    					$("#list_excel").append("<th style='width:4%'><div align='center'><spring:message code='RS04.TestDate'/></div></th>");
    					$("#list_excel").append("<th style='width:3%'><div align='center'><spring:message code='RS04.TestHour'/></div></th>");
    					$("#list_excel").append("<th style='width:3%'><div align='center'><spring:message code='COMMON.Shift'/></div></th>");
    					$("#list_excel").append("<th style='width:5%'><div align='center'><spring:message code='RS04.CarTypeGrp'/></div></th>");
    					$("#list_excel").append("<th style='width:12%'><div align='center'><spring:message code='COMMON.Tool'/></div></th>");
    					$("#list_excel").append("<th style='width:5%'><div align='center'><spring:message code='RS02.BodyNo'/></div></th>");
    					$("#list_excel").append("<th style='width:5%'><div align='center'><spring:message code='RS02.MESSeq'/></div></th>");
    					$("#list_excel").append("<th style='width:5%'><div align='center'><spring:message code='ST02.RepairJobNo'/></div></th>");
    					$("#list_excel").append("<th style='width:7%'><div align='center'><spring:message code='ST02.TotBatchNo'/></div></th>");
    					$("#list_excel").append("<th style='width:4%'><div align='center'><spring:message code='RS03.BatchNum'/></div></th>");
    					$("#list_excel").append("<th style='width:5%'><div align='center'><spring:message code='RS03.TighteningID'/></div></th>");
    					$("#list_excel").append("<th style='width:5%'><div align='center'><spring:message code='COMMON.TighteningResult'/></div></th>");
    					$("#list_excel").append("<th style='width:6%'><div align='center'><spring:message code='RS03.TorqueState'/></div></th>");
    					$("#list_excel").append("<th style='width:4%'><div align='center'><spring:message code='RS03.TorqueValue'/></div></th>");
    					$("#list_excel").append("<th style='width:5%'><div align='center'><spring:message code='RS03.AngleState'/></div></th>");
    					$("#list_excel").append("<th style='width:5%'><div align='center'><spring:message code='RS03.AngleValue'/></div></th>");
    					$("#list_excel").append("<th style='width:7%'><div align='center'><spring:message code='COMMON.RegisterDate'/></div></th>");
    					$("#list_excel").append("<th style='width:5%'><div align='center'><spring:message code='COMMON.Register'/></div></th>");
    					
    					
    					$("#list_excel").append("</thead>");
    					
    					$("#list_excel").append("<tbody>");
    					
    					data.list.forEach(function(item){
    						var var_tightening_result = "";
    	    			    var var_tor_state = "";
    	    			    var var_ang_state = "";
    	    			    
    	    			    if ( item.batch_tightening_result == "0" )
    	    			    	var_tightening_result = "<font color='red'>NG</font>";
    	    			    
    	    			    if (item.batch_tightening_result == "1")
    	    			    	var_tightening_result = "OK";
    	    			    
    						if (item.tor_state == "0")
    							var_tor_state = "Low";
    						else if (item.tor_state == "1")
    							var_tor_state = "OK";
    						else if (item.tor_state == "2")
    							var_tor_state = "High";
    						
    						if (item.ang_state == "0")
    							var_ang_state = "var_ang_state";
    						else if (item.ang_state == "1")
    							var_ang_state = "OK";
    						else if (item.ang_state == "2")
    							var_ang_state = "High";
    							
    	    				$('#list_excel').append(
    	    					'<tr>'
    	    					+ ' <td>' + item.rnum +'</td>'
		    					+ ' <td class="left_5">' + item.program +'</td>'
		    					+ ' <td class="left_5">' + item.process +'</td>'
		    					+ ' <td>' + ChangeDateFormatSimple(item.cycle_test_dt) +'</td>'
		    					+ ' <td>' + item.cycle_test_hour +'</td>'
		    					+ ' <td>' + item.shift +'</td>'
		    					+ ' <td>' + item.car_type_grp +'</td>'
		    					+ ' <td class="left_5">' + item.device_id   +'</td>'
		    					+ ' <td>' + item.body_no +'</td>'
		    					+ ' <td>' + item.mes_pbsout_seq +'</td>'
		    					+ ' <td>' + item.repair_job_num +'</td>'
		    					+ ' <td>' + item.tot_batch_num +'</td>'
		    					+ ' <td>' + item.batch_num +'</td>'
		    					+ ' <td>' + item.tighten_id +'</td>'
		    					+ ' <td>' + var_tightening_result +'</td>'
		    					+ ' <td>' + var_tor_state +'</td>'
		    					+ ' <td>' + item.tor_value +'</td>'
		    					+ ' <td>' + var_ang_state +'</td>'
		    					+ ' <td>' + item.ang_value +'</td>'
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
</script>
<div class="container">
	<div id="C_Body">       
        <div id="C_Title">
            <div id="content-title">
                <i class="fa fa-list-ul"></i> <spring:message code="SCREEN.RS04" /><!-- <asp:Label ID="lblTitle" runat="server" Text="SCREEN.RS04"></asp:Label> -->
            </div>
            <div id="content-title-nav">
                <i class="fa fa-angle-double-right"></i> <spring:message code="MENU.RESULT" /><!-- <asp:Label ID="lblMenuSystem" runat="server" Text="MENU.RESULT"></asp:Label> -->
            </div>
            <div id="content-title-bar">
            </div>  
        </div> 
        <div id="C_Search">
            <table cellpadding="1" cellspacing="1" border="0" align="center" class="search_table">
                <tr>
                    <td height="100">
                        <table width="100%">
                            <tr>
                                <td width="1%" height="30" ></td>
                                <td width="12%" class="left_5" >
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Plant" /><!-- <asp:Label ID="lblPlant" runat="server" Text="COMMON.Plant"></asp:Label> -->
                                </td>
                                <td width="20%" class="left_5" >
                                	<select id="ddlPlant"></select>
                                </td>
                                <td width="10%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Date" /><!-- <asp:Label ID="lblDate" runat="server" Text="COMMON.Date"></asp:Label> -->
                                </td>
                                <td width="25%" class="left_5" colspan="3">
                                	<input name="txtDate" type="text" id="txtDate" readonly="true" style="width:100px;">
                                    <input type="hidden" name="hdDate" id="hdDate">
                                	<select id="ddlHour" style="width:50px;"></select>
                                    <!-- <asp:TextBox ID="txtDate" runat="server" Width="100"></asp:TextBox>
                                    <asp:HiddenField id="hdDate" runat="server" />
                                    <asp:DropDownList ID="ddlHour" runat="server" Width="50" AutoPostBack="true" 
                                        onselectedindexchanged="ddlHour_SelectedIndexChanged" ></asp:DropDownList> -->
                                </td>
                                <td rowspan="3"  class="content-button">
                                	<img src="/images/ajax-loader.gif" style="display:none;" id="load-image"/>
                                	<c:set var="btnSearch"><spring:message code="BUTTON.Search"/></c:set>
                                	<input type="button" id="btnSearch" value="${btnSearch}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                    <c:set var="btnExcel"><spring:message code="BUTTON.Excel"/></c:set>
                                	<input type="button" id="btnExcel" value="${btnExcel}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                    <!-- <asp:Button ID="btnSearch" runat="server" Text="BUTTON.Search"  OnClick="btnSearch_Click" />
                                    <asp:Button ID="btnExcel" runat="server" Text="BUTTON.Excel" OnClick="btnExcel_Click" /> -->
                                </td>
                            </tr>
                            <tr>
                                <td height="30" ></td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="SM01.Program" /><!-- <asp:Label ID="lblProgram" runat="server" Text="SM01.Program"></asp:Label> -->
                                </td>
                                <td class="left_5">
                                	<select id="ddlProgram"></select>
                                 </td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="SM01.Process" /><!-- <asp:Label ID="lblProcess" runat="server" Text="SM01.Process"></asp:Label> -->
                                </td>
                                <td class="left_5" colspan="4">
                                	<select id="ddlProcess"></select>
                                 </td>  
                            </tr>
                            <tr>
                                <td height="30" ></td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="RS04.CarTypeGrp" /><!-- <asp:Label ID="lblCarType" runat="server" Text="RS04.CarTypeGrp"></asp:Label> -->
                                </td>
                                <td class="left_5" >
                                	<select id=ddlCarType></select>
                                </td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="RS02.BodyNo" /><!-- <asp:Label ID="lblBodyNo" runat="server" Text="RS02.BodyNo"></asp:Label> -->
                                </td>
                                <td width="20%" class="left_5" >
                                	<input type="text" id="txtCarType" MaxLength="4" style="width:50px" style="ime-mode:disabled;text-transform:uppercase;" onKeyUp="fn_ToUpperCase(this);">
                                	<input ypte="text" id="txtBodyNo"  MaxLength="6" style="width:70px"  onkeypress="fn_NumKey()">
                                </td>
                                <td width="5%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Tool" /><!-- <asp:Label ID="lblTool" runat="server" Text="COMMON.Tool"></asp:Label> -->
                                </td>
                                <td class="left_5" >
                                	<select id="ddlTool" style="width:200px;"></select>
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
	        <div style="position: relative;width:500;overflow:auto;" >
	        	<table class="gridview" cellspacing="0" border="0" style="width:2500px;border-collapse:collapse;" id="list_table">
	            	<thead>
						<tr>
							<th style="width:2%"><div align="center"><spring:message code="COMMON.Num"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="COMMON.Program"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="SM01.Process"/></div></th>
							<th style="width:4%"><div align="center"><spring:message code="RS04.TestDate"/></div></th>
							<th style="width:3%"><div align="center"><spring:message code="RS04.TestHour"/></div></th>
							<th style="width:2%"><div align="center"><spring:message code="COMMON.Shift"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="RS04.CarTypeGrp"/></div></th>
							<th style="width:13%"><div align="center"><spring:message code="COMMON.Tool"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="RS02.BodyNo"/></div></th>
							<th style="width:4%"><div align="center"><spring:message code="RS02.MESSeq"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="ST02.RepairJobNo"/></div></th>
							<th style="width:7%"><div align="center"><spring:message code="ST02.TotBatchNo"/></div></th>
							<th style="width:4%"><div align="center"><spring:message code="RS03.BatchNum"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="RS03.TighteningID"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="COMMON.TighteningResult"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="RS03.TorqueState"/></div></th>
							<th style="width:4%"><div align="center"><spring:message code="RS03.TorqueValue"/></div></th>
							<th style="width:4%"><div align="center"><spring:message code="RS03.AngleState"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="RS03.AngleValue"/></div></th>
							<th style="width:9%"><div align="center"><spring:message code="COMMON.RegisterDate"/></div></th>
							<th style="width:6%"><div align="center"><spring:message code="COMMON.Register"/></div></th>
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
        		<input type="hidden" id="ddlStnType" value="R">
	            <table class="type08" border="1" id="list_excel"></table>
            </div>
        
        </div><!-- C_Result -->  
	</div><!-- C_Body -->
</div>
<jsp:include page="../bottom.jsp" flush="false" />
</body>
</html>
