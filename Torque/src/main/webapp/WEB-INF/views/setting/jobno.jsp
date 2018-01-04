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

</head>
<body>
<jsp:include page="../menu.jsp" flush="false" />
<script type="text/javascript">
    $(document).ready(function() {
        $("#btnSearch").button();
        $("#btnExcel").button();
        $("#btnReg").button();

        $.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
    	
    	getPlant();
		getCarType();
		getJobNoTool();
		
		$.ajaxSetup({async:true});	//비동기 켜기
		
		//getList();
		
		$("#btnSearch").on('click', function(e){
			getList();
		});
		
		
       /*  $("#btnReg").click(function(e) {
            e.preventDefault();
            OpenRegistration(CarType, ToolID, ToolSerial, JobNo, CondGrpNo);
        }); */
        
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
    	
    	$('#btnExcel').on('click', function(){
            var postfix = fn_Excelpostfix() //"-"+year + month + day + "_" + hour + mins;
            var fileName = $('#content-title').text().trim()+ postfix + ".xls";
            getExcelData();
            fn_ExcelReport('list_excel', fileName);
    	});
        
    });

    
    
    //function OpenRegistration(CarType, ToolID, ToolSerial, JobNo, CondGrpNo) {
    function OpenRegistration(CarType, ToolID, ToolSerial, JobNo) {
        //var title = fn_DisplayDictionary("SCREEN.ST02", "R");
        var title= '<spring:message code="SCREEN.ST02" />';
        fn_ShowDialog('/view/setting/jobnoP01?CarType=' + CarType + '&ToolID=' + ToolID + '&ToolSerial=' + ToolSerial + '&JobNo=' + JobNo, title, '750', '600', true);
        //fn_ShowDialog('/SETTING/ST02P01.aspx?CarType=' + CarType + '&ToolID=' + ToolID + '&ToolSerial=' + ToolSerial + '&JobNo=' + JobNo, title, '750', '600', true);
    }

    function CloseDialog(flg) {
        $('#btnSearch').click()
        fn_CloseDialog('', flg);
    }
    
    var now_page = 1;
    var show_count = 20;

    function getList(){
    	var vplant_cd = $('#ddlPlant').val()
    	var vcar_type = $('#ddlCarType').val();
    	var vtool_id = $('#ddlTool').val();
    	
    	var params = "plant_cd="+vplant_cd+
		"&car_type="+vcar_type+
		"&tool_id="+vtool_id+
		"&page="+now_page+
		"&show_count="+show_count;
		
    	$.get('/api/setting/getjobnolist?'+params,function(data){
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
    				//+ '	<td><a href=\'#\' onClick="OpenRegistration(\'' + item.device_id.trim() +'\',\''+item.device_serial+ '\');">' + item.device_id +'</a></td>'
    				//OpenRegistration(CarType, ToolID, ToolSerial, JobNo)
    				$('#list_data').append(
    				'<tr>' 
    					+ '<td>' + item.rnum				+ '</td>'
						+ '<td>' + item.car_type_grp        + '</td>'
						+ '<td><a href=\'#\' onClick="OpenRegistration(\'' + item.car_type_grp.trim() +'\',\''+item.device_id.trim() +'\',\''+item.device_serial.trim()+'\',\''+item.job_num.trim() +'\');">' + item.device              + '</a></td>'
						+ '<td>' + item.job_num             + '</td>'
						+ '<td>' + item.repair_job_num      + '</td>'
						+ '<td>' + item.tot_batch_num       + '</td>'
						+ '<td>' + item.cond_grp_num        + '</td>'
						+ '<td>' + item.cond_seq            + '</td>'
						+ '<td>' + item.cond_gub            + '</td>'
						+ '<td>' + item.spec219_num         + '</td>'
						+ '<td>' + item.equal_operator_flg  + '</td>'
						+ '<td>' + item.spec219_value       + '</td>'
						+ '<td>' + item.torque_low          + '</td>'
						+ '<td>' + item.torque_ok           + '</td>'
						+ '<td>' + item.torque_high         + '</td>'
						+ '<td>' + item.angle_low           + '</td>'
						+ '<td>' + item.angle_ok            + '</td>'
						+ '<td>' + item.angle_high          + '</td>'
						+ '<td>' + ChangeDateFormat(item.regdt)               + '</td>'
						+ '<td>' + item.reg_user_id         + '</td>'
					+'</tr>'
    				);
    			});
    			
    		}
    	});
    }

    
    function getExcelData(){
    	//$.get('/api/setting/gettoollist?'+params,function(data){

    	var vplant_cd = $('#ddlPlant').val()
    	var vcar_type = $('#ddlCarType').val();
    	var vtool_id = $('#ddlTool').val();
    	
    	var params = "plant_cd="+vplant_cd+
		"&car_type="+vcar_type+
		"&tool_id="+vtool_id+
		"&page="+now_page+
		"&show_count="+show_count+
		"&excel_down=Y";
    	
    	$.ajax({
    			url:'/api/setting/getjobnolist?'+params,
    			type:'GET',
    			async:false,
    			success: function(data) {
    				if(data.result == 200){
    					$("#list_excel").empty();
    					$("#list_excel").append("<thead>");
    					
    					$('#list_excel').append("<th><spring:message code='COMMON.Num'/></th>");
    					$('#list_excel').append("<th><spring:message code='COMMON.CarType'/></th>");
    					$('#list_excel').append("<th><spring:message code='COMMON.Tool'/></th>");
    					$('#list_excel').append("<th><spring:message code='ST02.JobNo'/></th>");
    					$('#list_excel').append("<th><spring:message code='ST02.RepairJobNo'/></th>");
    					$('#list_excel').append("<th><spring:message code='ST02.TotBatchNo'/></th>");
    					$('#list_excel').append("<th><spring:message code='ST02.CondGrpNo'/></th>");
    					$('#list_excel').append("<th><spring:message code='ST02.CondSeq'/></th>");
    					$('#list_excel').append("<th><spring:message code='ST02.CondGub'/></th>");
    					$('#list_excel').append("<th><spring:message code='ST02.CondNo'/></th>");
    					$('#list_excel').append("<th><spring:message code='ST02.CondOperator'/></th>");
    					$('#list_excel').append("<th><spring:message code='ST02.OptVal'/></th>");
    					$('#list_excel').append("<th><spring:message code='ST01.TorqLowVal'/></th>");
    					$('#list_excel').append("<th><spring:message code='ST01.TorqOkVal'/></th>");
    					$('#list_excel').append("<th><spring:message code='ST01.TorqHighVal'/></th>");
    					$('#list_excel').append("<th><spring:message code='ST01.AnglLowVal'/></th>");
    					$('#list_excel').append("<th><spring:message code='ST01.AnglOkVal'/></th>");
    					$('#list_excel').append("<th><spring:message code='ST01.AnglHighVal'/></th>");
    					$('#list_excel').append("<th><spring:message code='COMMON.RegisterDate'/></th>");
    					$('#list_excel').append("<th><spring:message code='COMMON.Register'/></th>");
    					$("#list_excel").append("</thead>");
    					
    					$("#list_excel").append("<tbody>");
    					
    					data.list.forEach(function(item){
    						
    						$('#list_excel').append(
    							  '<tr>' 
    							+ '<td>' + item.rnum				+ '</td>'
								+ '<td>' + item.car_type_grp        + '</td>'
								+ '<td>' + item.device              + '</td>'
								+ '<td>' + item.job_num             + '</td>'
								+ '<td>' + item.repair_job_num      + '</td>'
								+ '<td>' + item.tot_batch_num       + '</td>'
								+ '<td>' + item.cond_grp_num        + '</td>'
								+ '<td>' + item.cond_seq            + '</td>'
								+ '<td>' + item.cond_gub            + '</td>'
								+ '<td>' + item.spec219_num         + '</td>'
								+ '<td>' + item.equal_operator_flg  + '</td>'
								+ '<td>' + item.spec219_value       + '</td>'
								+ '<td>' + item.torque_low          + '</td>'
								+ '<td>' + item.torque_ok           + '</td>'
								+ '<td>' + item.torque_high         + '</td>'
								+ '<td>' + item.angle_low           + '</td>'
								+ '<td>' + item.angle_ok            + '</td>'
								+ '<td>' + item.angle_high          + '</td>'
								+ '<td style=mso-number-format:"\@";>' + ChangeDateFormat(item.regdt)               + '</td>'
								+ '<td>' + item.reg_user_id         + '</td>'
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
                <i class="fa fa-pencil-square-o "></i><spring:message code="SCREEN.ST02"/>
            </div>
            <div id="content-title-nav">
                <i class="fa fa-angle-double-right"></i><spring:message code="MENU.SETTING"/>
            </div>
            <div id="content-title-bar">
            </div>  
        </div> 
        <div id="C_Search">
            <table cellpadding="1" cellspacing="1" border="0" align="center" class="search_table">
                <tr>
                    <td height="50">
                        <table width="100%">
                            <tr>
                                <td width="1%"></td>
                                <td width="5%" height="30" class="left_5" >
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Plant"/></td>
                                <td width="15%" class="left_5" >
                                	<select id="ddlPlant"></select>
                                    <!-- <asp:DropDownList ID="ddlPlant" runat="server"></asp:DropDownList> -->
                                </td>
                                <td  width="7%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.CarType"/>
                                </td>
                                <td width="15%" class="left_5" >
                                	<select id="ddlCarType"></select>
                                    <!-- <asp:DropDownList ID="ddlCarType" runat="server" AutoPostBack="true"
                                        onselectedindexchanged="ddlCarType_SelectedIndexChanged"></asp:DropDownList> -->
                                </td>
                                <td width="7%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Tool"/>
                                </td>
                                <td width="15%" class="left_5">
                                	<select id="ddlTool"></select>
                                	<!-- <asp:DropDownList ID="ddlTool" runat="server" AutoPostBack="true" onselectedindexchanged="ddlTool_SelectedIndexChanged" ></asp:DropDownList> -->
                                </td>
                                <td rowspan="3"  class="content-button">
                                	<c:set var="btnSearch"><spring:message code="BUTTON.Search"/></c:set>
                                	<input type="button" id="btnSearch" value="${btnSearch}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                	<c:set var="btnExcel"><spring:message code="BUTTON.Excel"/></c:set>
                                	<input type="button" id="btnExcel" value="${btnExcel}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                	<c:set var="btnReg"><spring:message code="BUTTON.Registration"/></c:set>
                                	<input type="button" id="btnReg" value="${btnReg}" class="ui-button ui-widget ui-state-default ui-corner-all" onclick="OpenRegistration('', '', '', '')" role="button">
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
	            <!-- <table class="type08" style="width:3000px;" id="list_table"> -->
	            <table class="gridview" cellspacing="0" border="0" style="width:3000px;border-collapse:collapse;" id="list_table">
					<thead>
						<tr>
							<th><spring:message code="COMMON.Num"/></th>
							<th><spring:message code="COMMON.CarType"/></th>
							<th><spring:message code="COMMON.Tool"/></th>
							<th><spring:message code="ST02.JobNo"/></th>
							<th><spring:message code="ST02.RepairJobNo"/></th>
							<th><spring:message code="ST02.TotBatchNo"/></th>
							<th><spring:message code="ST02.CondGrpNo"/></th>
							<th><spring:message code="ST02.CondSeq"/></th>
							<th><spring:message code="ST02.CondGub"/></th>
							<th><spring:message code="ST02.CondNo"/></th>
							<th><spring:message code="ST02.CondOperator"/></th>
							<th><spring:message code="ST02.OptVal"/></th>
							<th><spring:message code="ST01.TorqLowVal"/></th>
							<th><spring:message code="ST01.TorqOkVal"/></th>
							<th><spring:message code="ST01.TorqHighVal"/></th>
							<th><spring:message code="ST01.AnglLowVal"/></th>
							<th><spring:message code="ST01.AnglOkVal"/></th>
							<th><spring:message code="ST01.AnglHighVal"/></th>
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
        	
        	<div id="wrapper" style="visibility:hidden;overflow:hidden;height:0px;">
	            <table class="type08" border="1" id="list_excel"></table>
            </div>
        </div>  
    </div>      
</div>
<jsp:include page="../bottom.jsp" flush="false" />
</body>
</html>
