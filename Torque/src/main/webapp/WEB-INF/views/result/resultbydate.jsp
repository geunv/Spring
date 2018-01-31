<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8"> 
	<title>Result By Date</title>
	<jsp:include page="../head.jsp" flush="false" />
</head>
<body>
<jsp:include page="../menu.jsp" flush="false" />

<script type="text/javascript">
    $(document).ready(function() {
        $("#btnSearch").button();
        $("#btnExcel").button();
        
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
    	
    	getPlant();
    	ddlTool();
    	
    	$("#txtFromDate").val(fn_getFirstday());
    	$("#txtToDate").val(fn_getday());
    	
		$.ajaxSetup({async:true});	//비동기 켜기
		
		getList();
		
		$("#btnSearch").on('click', function(e){
			now_page = 1;
    		show_count  = $('#select_show_count').val();
			getList();
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
    	getToolId('A',$('#ddlPlant').val(),'-1','N','-1','W');
    }
    
    var now_page = 1;
    var show_count = 20;

    function getList(){
        
    	var params ="?plant_cd="+$('#ddlPlant').val()+
		 			"&from_dt="+$('#txtFromDate').val()+
		 			"&to_dt="+$('#txtToDate').val()+
		 			"&tool="+$('#ddlTool').val() +
    				"&page="+now_page+
    				"&show_count="+show_count;
    	
	    	$.ajax({
	    		type : "GET",
				url : '/api/result/getresultbydate'+params,
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
	    			

	    				$('#list_data').append(
	    					  '<tr>' 
								+ ' <td class="text-center">' + item.rnum +'</td>'
								+ ' <td class="left_5">' + item.device +'</td>'
								+ ' <td class="text-center">' + ChangeDateFormatSimple(item.work_dt) +'</td>'
								+ ' <td class="right_5">' + numberComma(item.total_cnt) +'</td>'
								+ ' <td class="right_5">' + numberComma(item.ok_cnt) +'</td>'
								+ ' <td class="right_5">' + numberComma(item.ng_cnt) +'</td>'
								+ ' <td class="right_5">' + numberComma(item.noscan_cnt) +'</td>'
								+ ' <td class="right_5">' + numberComma(item.pass_cnt) +'</td>'
								+ ' <td class="right_5">' + numberComma(item.repair_cnt) +'</td>'
								+ ' <td class="right_5">' + numberComma(item.interlock_cnt) +'</td>'
								+ ' <td class="right_5">' + numberComma(item.total_ok) +'</td>'
								+ ' <td class="right_5">' + numberComma(item.total_ng) +'</td>'
								+ ' <td class="right_5">' + numberComma(item.total_ok_ratio) +'</td>'
								+ ' <td class="right_5">' + item.ng_ratio +'</td>'
								+ ' <td class="right_5">' + item.noscan_ratio +'</td>'
	    					+ '</tr>'
	    				);
	    			});
	    			
	    		}
				
			}).fail(function(data) {
				$('#load-image').hide();
				alert(data);
			});
    	
    	/* $.get('/api/result/getresultbydate'+params,function(data){
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
							+ ' <td class="text-center">' + item.rnum +'</td>'
							+ ' <td class="left_5">' + item.device +'</td>'
							+ ' <td class="text-center">' + ChangeDateFormatSimple(item.work_dt) +'</td>'
							+ ' <td class="right_5">' + numberComma(item.total_cnt) +'</td>'
							+ ' <td class="right_5">' + numberComma(item.ok_cnt) +'</td>'
							+ ' <td class="right_5">' + numberComma(item.ng_cnt) +'</td>'
							+ ' <td class="right_5">' + numberComma(item.noscan_cnt) +'</td>'
							+ ' <td class="right_5">' + numberComma(item.pass_cnt) +'</td>'
							+ ' <td class="right_5">' + numberComma(item.repair_cnt) +'</td>'
							+ ' <td class="right_5">' + numberComma(item.interlock_cnt) +'</td>'
							+ ' <td class="right_5">' + numberComma(item.total_ok) +'</td>'
							+ ' <td class="right_5">' + numberComma(item.total_ng) +'</td>'
							+ ' <td class="right_5">' + numberComma(item.total_ok_ratio) +'</td>'
							+ ' <td class="right_5">' + item.ng_ratio +'</td>'
							+ ' <td class="right_5">' + item.noscan_ratio +'</td>'
    					+ '</tr>'
    				);
    			});
    			
    		}
    	}); */
    }

    function getExcelData(){
    	//$.get('/api/setting/gettoollist?'+params,function(data){

    	var params ="?plant_cd="+$('#ddlPlant').val()+
		 			"&from_dt="+$('#txtFromDate').val()+
		 			"&to_dt="+$('#txtToDate').val()+
		 			"&tool="+$('#ddlTool').val() +
    				"&page="+now_page+
    				"&show_count="+show_count+
    				 "&excel_down=Y";
    	
    	$.ajax({
    			url:'/api/result/getresultbydate'+params,
    			type:'GET',
    			async:false,
    			success: function(data) {
    				if(data.result == 200){
    					$("#list_excel").empty();
    					$("#list_excel").append("<thead>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Num'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Tool'/></th>");
    					$("#list_excel").append("<th><spring:message code='RS06.WorkDate'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Total'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.OK'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.NG'/></th>");
						$("#list_excel").append("<th><spring:message code='COMMON.NoScan'/></th>");
						$("#list_excel").append("<th><spring:message code='COMMON.Pass'/></th>");
						$("#list_excel").append("<th><spring:message code='COMMON.Repair'/></th>");
						$("#list_excel").append("<th><spring:message code='RS06.Interlock'/></th>");
						$("#list_excel").append("<th><spring:message code='COMMON.TotalOK'/></th>");
						$("#list_excel").append("<th><spring:message code='COMMON.TotalNG'/></th>");
						$("#list_excel").append("<th><spring:message code='RS06.OKRatio'/></th>");
						$("#list_excel").append("<th><spring:message code='RS06.NGRatio'/></th>");
						$("#list_excel").append("<th><spring:message code='RS06.NoScanRatio'/></th>");
						$("#list_excel").append("</thead>");
    					$("#list_excel").append("<tbody>");
    					
    					data.list.forEach(function(item){
    						
    						$('#list_excel').append(
    							  '<tr>' 
	    							+ ' <td class="text-center">' + item.rnum +'</td>'
									+ ' <td class="left_5">' + item.device +'</td>'
									+ ' <td class="text-center">' + ChangeDateFormatSimple(item.work_dt) +'</td>'
									+ ' <td class="right_5">' + numberComma(item.total_cnt) +'</td>'
									+ ' <td class="right_5">' + numberComma(item.ok_cnt) +'</td>'
									+ ' <td class="right_5">' + numberComma(item.ng_cnt) +'</td>'
									+ ' <td class="right_5">' + numberComma(item.noscan_cnt) +'</td>'
									+ ' <td class="right_5">' + numberComma(item.pass_cnt) +'</td>'
									+ ' <td class="right_5">' + numberComma(item.repair_cnt) +'</td>'
									+ ' <td class="right_5">' + numberComma(item.interlock_cnt) +'</td>'
									+ ' <td class="right_5">' + numberComma(item.total_ok) +'</td>'
									+ ' <td class="right_5">' + numberComma(item.total_ng) +'</td>'
									+ ' <td class="right_5">' + numberComma(item.total_ok_ratio) +'</td>'
									+ ' <td class="right_5">' + item.ng_ratio +'</td>'
									+ ' <td class="right_5">' + item.noscan_ratio +'</td>'
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
                <i class="fa fa-list-ul"></i> <spring:message code="SCREEN.RS06"/><!-- <asp:Label ID="lblTitle" runat="server" Text="SCREEN.RS06"></asp:Label> -->
            </div>
            <div id="content-title-nav">
                <i class="fa fa-angle-double-right"></i> <spring:message code="MENU.RESULT"/><!-- <asp:Label ID="lblMenuSystem" runat="server" Text="MENU.RESULT"></asp:Label> -->
            </div>
            <div id="content-title-bar">
            </div>  
        </div> 
        <div id="C_Search">
            <table cellpadding="1" cellspacing="1" border="1" align="center" class="search_table" >
                <tr>
                    <td height="70">
                        <table width="100%">
                            <tr>
                                <td width="1%"></td>
                                <td width="6%" height="30" class="left_5" >
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Plant"/><!-- <asp:Label ID="lblPlant" runat="server" Text="COMMON.Plant"></asp:Label> -->
                                </td>
                                <td width="10%" class="left_5" >
                                	<select id="ddlPlant"></select>
                                    <!-- <asp:DropDownList ID="ddlPlant" runat="server"></asp:DropDownList> -->
                                </td>
                                <td width="6%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp;<spring:message code="COMMON.Date"/> <!-- <asp:Label ID="lblDate" runat="server" Text="COMMON.Date"></asp:Label> -->
                                </td>
                                <td width="25%" class="left_5">
                                	<input type="text" id="txtFromDate" readonly="true" style="width:100px;" > ~
                                    <input type="text" id="txtToDate" readonly="true" style="width:100px;" >
                                    <input type="hidden" id="hdFromDate" />
                                    <input type="hidden" id="hdToDate" />
                                    <!-- <asp:TextBox ID="txtFromDate" runat="server" Width="100"></asp:TextBox> ~
                                    <asp:TextBox ID="txtToDate" runat="server" Width="100"></asp:TextBox>
                                    <asp:HiddenField id="hdFromDate" runat="server" />
                                    <asp:HiddenField id="hdToDate" runat="server" /> -->
                                </td>
                                <td width="6%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Tool"/><!-- <asp:Label ID="lblTool" runat="server" Text="COMMON.Tool"></asp:Label> -->
                                </td>
                                <td width="25%" class="left_5">
									<select id="ddlTool" style="width:320px;"></select>
                                </td>
                                <td class="content-button">
                                	<img src="/images/ajax-loader.gif" style="display:none;" id="load-image"/>
                                    <c:set var="btnSearch"><spring:message code="BUTTON.Search"/></c:set>
                                	<input type="button" id="btnSearch" value="${btnSearch}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                    <c:set var="btnExcel"><spring:message code="BUTTON.Excel"/></c:set>
                                	<input type="button" id="btnExcel" value="${btnExcel}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
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
	        <div style="position: relative;width:500;overflow:auto;">
	        	<table class="gridview" cellspacing="0" border="0" style="width:100%;border-collapse:collapse;" id="list_table">
	            	<thead>
						<tr>
							<th style="width:2%"><div align="center"><spring:message code="COMMON.Num"/></div></th>
							<th style="width:25%"><div align="center"><spring:message code="COMMON.Tool"/></div></th>
							<th style="width:7%"><div align="center"><spring:message code="RS06.WorkDate"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="COMMON.Total"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="COMMON.OK"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="COMMON.NG"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="COMMON.NoScan"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="COMMON.Pass"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="COMMON.Repair"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="RS06.Interlock"/></div></th>
							<th style="width:6%"><div align="center"><spring:message code="COMMON.TotalOK"/></div></th>
							<th style="width:6%"><div align="center"><spring:message code="COMMON.TotalNG"/></div></th>
							<th style="width:7%"><div align="center"><spring:message code="RS06.OKRatio"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="RS06.NGRatio"/></div></th>
							<th style="width:7%"><div align="center"><spring:message code="RS06.NoScanRatio"/></div></th>
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
				  			<option value="20" selected>20</option>
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
