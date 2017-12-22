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
	<!-- <style type="text/css">
	.left_5 input[type=checkbox] + span{
	  font-weight:normal;
	  color: gray;
	}
	
	.left_5 input[type=checkbox]:checked + span{
	  font-weight:bold;
	  color:black;
	}
	</style> -->
</head>
<body>
<jsp:include page="../menu.jsp" flush="false" />

<script type="text/javascript">
    $(document).ready(function() {
        $("#btnSearch").button();
        $("#btnExcel").button();
        //$("#btnReg").button();

        $("#txtFromDate").datepicker({
            defaultDate: "+1w",
            changeMonth: true,
            numberOfMonths: 1,
            dateFormat: 'yy-mm-dd',
            altField: '#hdFromDate',
            onClose: function(selectedDate) {
                $("#txtToDate").datepicker("option", "minDate", selectedDate);
            }
        });
        $("#txtToDate").datepicker({
            defaultDate: "+1w",
            changeMonth: true,
            numberOfMonths: 1,
            dateFormat: 'yy-mm-dd',
            altField: '#hdToDate',
            onClose: function(selectedDate) {
                $("#txtFromDate").datepicker("option", "maxDate", selectedDate);
            }
        });
        
        if ($("#hdFromDate").val().length > 0) {
            $("#txtFromDate").val($("#hdFromDate").attr("Value"));
        }
        if ($("#hdToDate").val().length > 0) {
            $("#txtToDate").val($("#hdToDate").attr("Value"));
        }
        
        
        $.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
    	
        
        init();
    	
    	
    	$("#txtFromDate").val(fn_getday());
    	$("#txtToDate").val(fn_getday());
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
	
    function init(){
		getPlant();
    	getShift('A');
    	getTighteningResult('A');
    	ddlTool();
    }
    
    function ddlTool(){
    	getToolId('A',$('#ddlPlant').val(),'-1','N','-1','W');
    }
    
    
    var now_page = 1;
    var show_count = 20;

    function getList(){
        
    	var oldData = "";
    	if ( $('#chkSelOldData').is(":checked") == true)
    		oldData = 'Y';
		else
			oldData = 'N';
    	
    	var allBatch = "";
    	if ($('#chkShowAllBatchInfo').is(":checked") == true)
    		allBatch = "Y";
    	else
    		allBatch = "N";
    	
    	var params = "?plant_cd="+$('#ddlPlant').val()+
    				 "&from_dt="+$('#txtFromDate').val()+
    				 "&to_dt="+$('#txtToDate').val()+
    				 "&shift="+$('#ddlShift').val() +
    				 "&tool="+$('#ddlTool').val() +
    				 "&tightening_result=" +$('#ddlTighteningResult').val()+
    				 "&seq=" + $('#txtSeq').val()+
    				 "&car_type=" + $('#txtCarType').val() +
    				 "&body_no=" + $('#txtBodyNo').val() +
    				 "&old_data=" + oldData + 
    				 "&all_batch=" + allBatch + 
    				 "&page="+now_page+
    				 "&show_count="+show_count;
    	
    	$.get('/api/result/getresultdetail'+params,function(data){
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
    			$("#list_head").empty();
    			
    			getHead();
					
    			data.list.forEach(function(item){
    				//console.log(item);
    				var tr = '';	
    				var trcolor= "";
    				var var_tightening_result = "";
    				var var_repair_result = "";
    				var var_mes_trans_flg = "";
    				
    				/* if (e.Row.Cells[8].Text == "N" && e.Row.Cells[7].Text == "N")
    			        e.Row.ForeColor = Color.Red;
    			      else if (e.Row.Cells[9].Text != "1" && e.Row.Cells[10].Text != "1")
    			        e.Row.ForeColor = Color.Red; */
    				
    				if(item.pass_flg == "N" && item.scan_flg == "N" ){
    					trcolor = '<tr style="color:red;">'
    				}else if (item.tightening_result != "1" && item.repair_result != "1"){
    					trcolor = '<tr style="color:red;">'
    				}else{
    					trcolor = '<tr>'
    				}
    			    
    			    if (item.tightening_result == "0")
    			    	var_tightening_result = "NG";
    			    
    			    if (item.tightening_result == "1")
    			    	var_tightening_result = "OK";
    			    
					if ( item.repair_result == "0")
						var_repair_result = "NG";
    				
					if ( item.repair_result == "1")
						var_repair_result = "OK";
					
					if ( item.mes_trans_flg == "0")
						var_mes_trans_flg = "Ready"
					
					if ( item.mes_trans_flg == "1")
						var_mes_trans_flg = "Finished"
						
    				$('#list_data').append(
    						
    						trcolor
							+ ' <td>' + item.rnum +'</td>'
							+ ' <td class="left_5">[' + item.device_id +'-' +item.device_serial  +']' + item.device_nm +'</td>'
							+ ' <td>' + ChangeDateFormat(item.last_update_dt) +'</td>'
							+ ' <td>' + item.shift +'</td>'
							+ ' <td>' + item.body_no +'</td>'
							+ ' <td>' + ChangeDateFormatSimple(item.mes_pbsout_prod_dt) +'</td>'
							+ ' <td>' + item.mes_pbsout_seq +'</td>'
							+ ' <td>' + item.pass_flg +'</td>'
							+ ' <td>' + item.scan_flg +'</td>'
							+ ' <td>' + var_tightening_result +'</td>'
							+ ' <td>' + var_repair_result +'</td>'
							+ ' <td>' + item.tot_batch_num +'</td>'
							
							+ ' <td>' + item.tor_value_1 +'</td>'
							+ ' <td>' + item.ang_value_1 +'</td>'
							+ ' <td>' + item.tor_value_2 +'</td>'
							+ ' <td>' + item.ang_value_2 +'</td>'
							+ ' <td>' + item.tor_value_3 +'</td>'
							+ ' <td>' + item.ang_value_3 +'</td>'
							+ ' <td>' + item.tor_value_4 +'</td>'
							+ ' <td>' + item.ang_value_4 +'</td>'
							+ ' <td>' + item.tor_value_5 +'</td>'
							+ ' <td>' + item.ang_value_5 +'</td>'
							+ ' <td>' + item.tor_value_6 +'</td>'
							+ ' <td>' + item.ang_value_6 +'</td>'
							+ ' <td>' + item.tor_value_7 +'</td>'
							+ ' <td>' + item.ang_value_7 +'</td>'
							+ ' <td>' + item.tor_value_8 +'</td>'
							+ ' <td>' + item.ang_value_8 +'</td>'
							+ ' <td>' + item.tor_value_9 +'</td>'
							+ ' <td>' + item.ang_value_9 +'</td>'
							+ ' <td>' + item.tor_value_10 +'</td>'
							+ ' <td>' + item.ang_value_10 +'</td>'
							+ ' <td>' + item.tor_value_11 +'</td>'
							+ ' <td>' + item.ang_value_11 +'</td>'
							+ ' <td>' + item.tor_value_12 +'</td>'
							+ ' <td>' + item.ang_value_12 +'</td>'
								
							+ ' <td>' + item.ten_value +'</td>'
							+ ' <td>' + var_mes_trans_flg +'</td>'
							+ ' <td>' + ChangeDateFormat(item.mes_trans_dt) +'</td>'
							+ ' <td>' + ChangeDateFormat(item.regdt) +'</td>'
							+ ' <td>' + item.reg_user_id +'</td>'
    					+ '</tr>'
    				);
    			});
    			
    		}
    	});
    }

    function getHead(){
    	$("#list_head").append("<th><spring:message code='COMMON.Num'/></th>");
		$("#list_head").append("<th><spring:message code='COMMON.Tool'/></th>");
		$("#list_head").append("<th><spring:message code='ST01.LastWorkingDate'/></th>");
		$("#list_head").append("<th><spring:message code='COMMON.Shift'/></th>");
		$("#list_head").append("<th><spring:message code='RS02.BodyNo'/></th>");
		$("#list_head").append("<th><spring:message code='RS02.MESProdDate'/></th>");
		$("#list_head").append("<th><spring:message code='RS02.MESSeq'/></th>");
		$("#list_head").append("<th><spring:message code='COMMON.Pass'/></th>");
		$("#list_head").append("<th><spring:message code='RS02.Scan'/></th>");
		$("#list_head").append("<th><spring:message code='COMMON.TighteningResult'/></th>");
		$("#list_head").append("<th><spring:message code='RS02.RepairResult'/></th>");
		$("#list_head").append("<th><spring:message code='ST02.TotBatchNo'/></th>");
		
		$("#list_head").append("<th>TOR_VALUE_1</th>");
		$("#list_head").append("<th>ANG_VALUE_1</th>");
		$("#list_head").append("<th>TOR_VALUE_2</th>");
		$("#list_head").append("<th>ANG_VALUE_2</th>");
		$("#list_head").append("<th>TOR_VALUE_3</th>");
		$("#list_head").append("<th>ANG_VALUE_3</th>");
		$("#list_head").append("<th>TOR_VALUE_4</th>");
		$("#list_head").append("<th>ANG_VALUE_4</th>");
		
		$("#list_head").append("<th>TOR_VALUE_5</th>");
		$("#list_head").append("<th>ANG_VALUE_5</th>");
		$("#list_head").append("<th>TOR_VALUE_6</th>");
		$("#list_head").append("<th>ANG_VALUE_6</th>");
		$("#list_head").append("<th>TOR_VALUE_7</th>");
		$("#list_head").append("<th>ANG_VALUE_7</th>");
		$("#list_head").append("<th>TOR_VALUE_8</th>");
		$("#list_head").append("<th>ANG_VALUE_8</th>");
		
		$("#list_head").append("<th>TOR_VALUE_9</th>");
		$("#list_head").append("<th>ANG_VALUE_9</th>");
		$("#list_head").append("<th>TOR_VALUE_10</th>");
		$("#list_head").append("<th>ANG_VALUE_10</th>");
		$("#list_head").append("<th>TOR_VALUE_11</th>");
		$("#list_head").append("<th>ANG_VALUE_11</th>");
		$("#list_head").append("<th>TOR_VALUE_12</th>");
		$("#list_head").append("<th>ANG_VALUE_12</th>");
		
		$("#list_head").append("<th><spring:message code='RS02.TenValue'/></th>");
		$("#list_head").append("<th><spring:message code='RS02.MesTransFlg'/></th>");
		$("#list_head").append("<th><spring:message code='RS02.MESTransDate'/></th>");
		$("#list_head").append("<th><spring:message code='COMMON.RegisterDate'/></th>");
		$("#list_head").append("<th><spring:message code='COMMON.Register'/></th>");
    }
    
    function getExcelData(){
    	//$.get('/api/setting/gettoollist?'+params,function(data){

    	var oldData = "";
    	if ( $('#chkSelOldData').is(":checked") == true)
    		oldData = 'Y';
		else
			oldData = 'N';
    	
    	var allBatch = "";
    	if ($('#chkShowAllBatchInfo').is(":checked") == true)
    		allBatch = "Y";
    	else
    		allBatch = "N";
    	
    	var params = "?plant_cd="+$('#ddlPlant').val()+
    				 "&from_dt="+$('#txtFromDate').val()+
    				 "&to_dt="+$('#txtToDate').val()+
    				 "&shift="+$('#ddlShift').val() +
    				 "&tool="+$('#ddlTool').val() +
    				 "&tightening_result=" +$('#ddlTighteningResult').val()+
    				 "&seq=" + $('#txtSeq').val()+
    				 "&car_type=" + $('#txtCarType').val() +
    				 "&body_no=" + $('#txtBodyNo').val() +
    				 "&old_data=" + oldData + 
    				 "&all_batch=" + allBatch + 
    				 "&page="+now_page+
    				 "&show_count="+show_count+
    				 "&excel_down=Y";
    	
    	$.ajax({
    			url:'/api/result/getresultdetail'+params,
    			type:'GET',
    			async:false,
    			success: function(data) {
    				if(data.result == 200){
    					$("#list_excel").empty();
    					$("#list_excel").append("<thead>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Num'/></th>");
    					
    					$("#list_excel").append("<th><spring:message code='COMMON.Tool'/></th>");
    					$("#list_excel").append("<th><spring:message code='ST01.LastWorkingDate'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Shift'/></th>");
    					$("#list_excel").append("<th><spring:message code='RS02.BodyNo'/></th>");
    					$("#list_excel").append("<th><spring:message code='RS02.MESProdDate'/></th>");
    					$("#list_excel").append("<th><spring:message code='RS02.MESSeq'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Pass'/></th>");
    					$("#list_excel").append("<th><spring:message code='RS02.Scan'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.TighteningResult'/></th>");
    					$("#list_excel").append("<th><spring:message code='RS02.RepairResult'/></th>");
    					$("#list_excel").append("<th><spring:message code='ST02.TotBatchNo'/></th>");
    					
    					$("#list_excel").append("<th>TOR_VALUE_1</th>");
    					$("#list_excel").append("<th>ANG_VALUE_1</th>");
    					$("#list_excel").append("<th>TOR_VALUE_2</th>");
    					$("#list_excel").append("<th>ANG_VALUE_2</th>");
    					$("#list_excel").append("<th>TOR_VALUE_3</th>");
    					$("#list_excel").append("<th>ANG_VALUE_3</th>");
    					$("#list_excel").append("<th>TOR_VALUE_4</th>");
    					$("#list_excel").append("<th>ANG_VALUE_4</th>");
    					
    					$("#list_excel").append("<th>TOR_VALUE_5</th>");
    					$("#list_excel").append("<th>ANG_VALUE_5</th>");
    					$("#list_excel").append("<th>TOR_VALUE_6</th>");
    					$("#list_excel").append("<th>ANG_VALUE_6</th>");
    					$("#list_excel").append("<th>TOR_VALUE_7</th>");
    					$("#list_excel").append("<th>ANG_VALUE_7</th>");
    					$("#list_excel").append("<th>TOR_VALUE_8</th>");
    					$("#list_excel").append("<th>ANG_VALUE_8</th>");
    					
    					$("#list_excel").append("<th>TOR_VALUE_9</th>");
    					$("#list_excel").append("<th>ANG_VALUE_9</th>");
    					$("#list_excel").append("<th>TOR_VALUE_10</th>");
    					$("#list_excel").append("<th>ANG_VALUE_10</th>");
    					$("#list_excel").append("<th>TOR_VALUE_11</th>");
    					$("#list_excel").append("<th>ANG_VALUE_11</th>");
    					$("#list_excel").append("<th>TOR_VALUE_12</th>");
    					$("#list_excel").append("<th>ANG_VALUE_12</th>");
    					
    					$("#list_excel").append("<th><spring:message code='RS02.TenValue'/></th>");
    					$("#list_excel").append("<th><spring:message code='RS02.MesTransFlg'/></th>");
    					$("#list_excel").append("<th><spring:message code='RS02.MESTransDate'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.RegisterDate'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Register'/></th>");
    					
    					$("#list_excel").append("</thead>");
    					
    					$("#list_excel").append("<tbody>");
    					
    					data.list.forEach(function(item){
    	    				//console.log(item);
    	    				var tr = '';	
    	    				var trcolor= "";
    	    				var var_tightening_result = "";
    	    				var var_repair_result = "";
    	    				var var_mes_trans_flg = "";
    	    				
    	    				/* if (e.Row.Cells[8].Text == "N" && e.Row.Cells[7].Text == "N")
    	    			        e.Row.ForeColor = Color.Red;
    	    			      else if (e.Row.Cells[9].Text != "1" && e.Row.Cells[10].Text != "1")
    	    			        e.Row.ForeColor = Color.Red; */
    	    				
    	    				if(item.pass_flg == "N" && item.scan_flg == "N" ){
    	    					trcolor = '<tr style="color:red;">'
    	    				}else if (item.tightening_result != "1" && item.repair_result != "1"){
    	    					trcolor = '<tr style="color:red;">'
    	    				}else{
    	    					trcolor = '<tr>'
    	    				}
    	    			    
    	    			    if (item.tightening_result == "0")
    	    			    	var_tightening_result = "NG";
    	    			    
    	    			    if (item.tightening_result == "1")
    	    			    	var_tightening_result = "OK";
    	    			    
    						if ( item.repair_result == "0")
    							var_repair_result = "NG";
    	    				
    						if ( item.repair_result == "1")
    							var_repair_result = "OK";
    						
    						if ( item.mes_trans_flg == "0")
    							var_mes_trans_flg = "Ready"
    						
    						if ( item.mes_trans_flg == "1")
    							var_mes_trans_flg = "Finished"
    							
    	    				$('#list_excel').append(
    	    						
    	    						trcolor
    								+ ' <td>' + item.rnum +'</td>'
    								+ ' <td class="left_5">[' + item.device_id +'-' +item.device_serial  +']' + item.device_nm +'</td>'
    								+ ' <td>' + ChangeDateFormat(item.last_update_dt) +'</td>'
    								+ ' <td>' + item.shift +'</td>'
    								+ ' <td>' + item.body_no +'</td>'
    								+ ' <td>' + ChangeDateFormatSimple(item.mes_pbsout_prod_dt) +'</td>'
    								+ ' <td>' + item.mes_pbsout_seq +'</td>'
    								+ ' <td>' + item.pass_flg +'</td>'
    								+ ' <td>' + item.scan_flg +'</td>'
    								+ ' <td>' + var_tightening_result +'</td>'
    								+ ' <td>' + var_repair_result +'</td>'
    								+ ' <td>' + item.tot_batch_num +'</td>'
    								
    								+ ' <td>' + item.tor_value_1 +'</td>'
    								+ ' <td>' + item.ang_value_1 +'</td>'
    								+ ' <td>' + item.tor_value_2 +'</td>'
    								+ ' <td>' + item.ang_value_2 +'</td>'
    								+ ' <td>' + item.tor_value_3 +'</td>'
    								+ ' <td>' + item.ang_value_3 +'</td>'
    								+ ' <td>' + item.tor_value_4 +'</td>'
    								+ ' <td>' + item.ang_value_4 +'</td>'
    								+ ' <td>' + item.tor_value_5 +'</td>'
    								+ ' <td>' + item.ang_value_5 +'</td>'
    								+ ' <td>' + item.tor_value_6 +'</td>'
    								+ ' <td>' + item.ang_value_6 +'</td>'
    								+ ' <td>' + item.tor_value_7 +'</td>'
    								+ ' <td>' + item.ang_value_7 +'</td>'
    								+ ' <td>' + item.tor_value_8 +'</td>'
    								+ ' <td>' + item.ang_value_8 +'</td>'
    								+ ' <td>' + item.tor_value_9 +'</td>'
    								+ ' <td>' + item.ang_value_9 +'</td>'
    								+ ' <td>' + item.tor_value_10 +'</td>'
    								+ ' <td>' + item.ang_value_10 +'</td>'
    								+ ' <td>' + item.tor_value_11 +'</td>'
    								+ ' <td>' + item.ang_value_11 +'</td>'
    								+ ' <td>' + item.tor_value_12 +'</td>'
    								+ ' <td>' + item.ang_value_12 +'</td>'
    									
    								+ ' <td>' + item.ten_value +'</td>'
    								+ ' <td>' + var_mes_trans_flg +'</td>'
    								+ ' <td>' + ChangeDateFormat(item.mes_trans_dt) +'</td>'
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
                <i class="fa fa-list-ul"></i> <spring:message code="SCREEN.RS02" /><!-- <asp:Label ID="lblTitle" runat="server" Text="SCREEN.RS02"></asp:Label> -->
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
                                <td width="6%" class="left_5" >
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Plant" /><!-- <asp:Label ID="lblPlant" runat="server" Text="COMMON.Plant"></asp:Label> -->
                                </td>
                                <td width="15%" class="left_5" >
                                	<select id="ddlPlant"></select>
                                    <!-- <asp:DropDownList ID="ddlPlant" runat="server"></asp:DropDownList> -->
                                </td>
                                <td width="7%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Date" /><!-- <asp:Label ID="lblDate" runat="server" Text="COMMON.Date"></asp:Label> -->
                                </td>
                                <td width="25%" class="left_5" >
                                	<input type="text" id="txtFromDate" readonly="true" style="width:100px;" >
                                    <!-- <asp:TextBox ID="txtFromDate" runat="server" Width="100"></asp:TextBox> --> ~
                                    <input type="text" id="txtToDate" readonly="true" style="width:100px;" >
                                    <!-- <asp:TextBox ID="txtToDate" runat="server" Width="100"></asp:TextBox> -->
                                    <input type="hidden" id="hdFromDate" />
                                    <input type="hidden" id="hdToDate" />
                                </td>
                                <td class="left_5" colspan="2" >
                                	<input id="chkSelOldData" type="checkbox" name="chkSelOldData"><spring:message code="RS02.SearchOldData"/>
                                    <!-- <asp:CheckBox ID="chkSelOldData" runat="server" Text="RS02.SearchOldData" Checked="false" /> -->
                                </td>
                                <td rowspan="3"  class="content-button">
                                    <c:set var="btnSearch"><spring:message code="BUTTON.Search"/></c:set>
                                	<input type="button" id="btnSearch" value="${btnSearch}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                    <c:set var="btnExcel"><spring:message code="BUTTON.Excel"/></c:set>
                                	<input type="button" id="btnExcel" value="${btnExcel}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                </td>
                            </tr>
                            <tr>
                                <td height="30" ></td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Shift"/><!-- <asp:Label ID="lblShift" runat="server" Text="COMMON.Shift"></asp:Label> -->
                                </td>
                                <td class="left_5" >
                                	<select id="ddlShift"></select>
                                    <!-- <asp:DropDownList ID="ddlShift" runat="server" AutoPostBack="true" 
                                        onselectedindexchanged="ddlShift_SelectedIndexChanged" ></asp:DropDownList> -->
                                </td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Tool"/><!-- <asp:Label ID="lblTool" runat="server" Text="COMMON.Tool"></asp:Label> -->
                                </td>
                                <td width="25%" class="left_5">
                                	<select id="ddlTool"></select>
                                    <!-- <asp:DropDownList ID="ddlTool" runat="server" AutoPostBack="true" 
                                        onselectedindexchanged="ddlTool_SelectedIndexChanged" ></asp:DropDownList> -->
                                 </td>
                                 <td width="12%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.TighteningResult"/><!-- <asp:Label ID="lblTighteningResult" runat="server" Text="COMMON.TighteningResult"></asp:Label> -->
                                </td>
                                <td width="5%" class="left_5">
                                	<select id="ddlTighteningResult"></select>
                                    <!-- <asp:DropDownList ID="ddlTighteningResult" runat="server" AutoPostBack="true" 
                                        onselectedindexchanged="ddlTighteningResult_SelectedIndexChanged" ></asp:DropDownList> -->
                                </td>
                            </tr>
                            <tr>
                                <td height="30" ></td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="RS02.Seq"/><!-- <asp:Label ID="lblSeq" runat="server" Text="RS02.Seq"></asp:Label> -->
                                </td>
                                <td class="left_5" >
                                	<input type="text" id="txtSeq" MaxLength="4" onkeypress="fn_NumKey()" Width="70px">
                                    <!-- <asp:TextBox ID="txtSeq" runat="server" MaxLength="4" onkeypress="fn_NumKey()" Width="70px"></asp:TextBox> -->
                                </td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="RS02.BodyNo"/><!-- <asp:Label ID="lblBodyNo" runat="server" Text="RS02.BodyNo"></asp:Label> -->
                                </td>
                                <td class="left_5" >
                                	<input type="text" id="txtCarType" MaxLength="4" style="width:50px" style="ime-mode:disabled;text-transform:uppercase;" onKeyUp="fn_ToUpperCase(this);"/>
                                	<input type="text" id="txtBodyNo" MaxLength="6" style="width:70px"  onkeypress="fn_NumKey()"/>
                                	<!-- <asp:TextBox ID="txtCarType" runat="server" MaxLength="4" Width="50px" style="ime-mode:disabled;text-transform:uppercase;" onKeyUp="fn_ToUpperCase(this);"></asp:TextBox>
                                    <asp:TextBox ID="txtBodyNo" runat="server" MaxLength="6" Width="70px"  onkeypress="fn_NumKey()"></asp:TextBox> -->
                                </td>
                                <td class="left_5" colspan="3">
                                	<input id="chkShowAllBatchInfo" type="checkbox" name="chkShowAllBatchInfo" checked="true" style="font-weight:bold;"><spring:message code="RS02.ShowAllBatchInfo"/>
                                    <!-- <asp:CheckBox ID="chkShowAllBatchInfo" runat="server" 
                                        Text="RS02.ShowAllBatchInfo" Checked="true" AutoPostBack="true"
                                        oncheckedchanged="chkShowAllBatchInfo_CheckedChanged" /> -->
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
	        	<table class="gridview" cellspacing="0" border="0" style="width:5500px;border-collapse:collapse;" id="list_table">
	            	<thead id="list_head">
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

        	<div id="wrapper" style="visibility:hidden">
	            <table class="type08" border="1" id="list_excel"></table>
            </div>
        
        </div><!-- C_Result -->  
	</div><!-- C_Body -->
</div>
<jsp:include page="../bottom.jsp" flush="false" />
</body>
</html>
