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
			now_page = 1;
    		show_count  = $('#select_show_count').val();
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
    	getTighteningResultSimple('A');
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
    	
    	var params = "?plant_cd="+$('#ddlPlant').val()+
    				 "&from_dt="+$('#txtFromDate').val()+
    				 "&to_dt="+$('#txtToDate').val()+
    				 "&tool="+$('#ddlTool').val() +
    				 "&tightening_result=" +$('#ddlTighteningResult').val()+
    				 "&seq=" + $('#txtSeq').val()+
    				 "&car_type=" + $('#txtCarType').val() +
    				 "&body_no=" + $('#txtBodyNo').val() +
    				 "&old_data=" + oldData + 
    				 "&page="+now_page+
    				 "&show_count="+show_count;
    	
    	$.ajax({
    		type : "GET",
			url : '/api/result/getresulthistory'+params,
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
    			
    				var tdred = "";
    				var var_tor_state =  "";
    				var var_ang_state = "";
    				
    				if (  item.batch_tightening_result == "0" )
    					tdred = ' <td style="color:red;">NG</td>';
    				else
    					tdred = ' <td>OK</td>'
    				
    				if (item.tor_state == "0")
    					var_tor_state = "Low";
    				if (item.tor_state == "1")
    					var_tor_state = "OK";
    				if (item.tor_state == "2")
    					var_tor_state = "High";
    				
    				if (item.ang_state == "0")
    					var_ang_state = "Low";
    				if (item.ang_state == "1")
    					var_ang_state = "OK";
    				if (item.ang_state == "2")
    					var_ang_state = "High";
    				
    				$('#list_data').append(
    						
    						'<tr>'
							+ ' <td>' + item.rnum +'</td>'
							+ ' <td class="left_5">' + item.device +'</td>'
							+ ' <td>' + item.body_no +'</td>'
							+ ' <td>' + item.tot_batch_num +'</td>'
							+ ' <td>' + item.batch_num +'</td>'
							+ ' <td>' + item.tighten_id +'</td>'
							+ ' <td>' + item.mes_pbsout_seq +'</td>'
							+ tdred
							+ ' <td>'+var_tor_state+'</td>'
							+ ' <td>' + item.tor_value +'</td>'
							+ ' <td>' + var_ang_state +'</td>'
							+ ' <td>' + item.ang_value +'</td>'
							+ ' <td>' + item.tightening_dt +'</td>'
							+ ' <td>' + ChangeDateFormat(item.regdt) +'</td>'
							+ ' <td>' + item.reg_user_id +'</td>'
    					+ '</tr>'
    				);
    				
    				//console.log($('#list_data').val());
    			});
    			
    		}
			
		}).fail(function(data) {
			$('#load-image').hide();
			alert(data);
		});
    	
    	/* $.get('/api/result/getresulthistory'+params,function(data){
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
    			
    				var tdred = "";
    				var var_tor_state =  "";
    				var var_ang_state = "";
    				
    				if (  item.batch_tightening_result == "0" )
    					tdred = ' <td style="color:red;">NG</td>';
    				else
    					tdred = ' <td>OK</td>'
    				
    				if (item.tor_state == "0")
    					var_tor_state = "Low";
    				if (item.tor_state == "1")
    					var_tor_state = "OK";
    				if (item.tor_state == "2")
    					var_tor_state = "High";
    				
    				if (item.ang_state == "0")
    					var_ang_state = "Low";
    				if (item.ang_state == "1")
    					var_ang_state = "OK";
    				if (item.ang_state == "2")
    					var_ang_state = "High";
    				
    				$('#list_data').append(
    						
    						'<tr>'
							+ ' <td>' + item.rnum +'</td>'
							+ ' <td class="left_5">' + item.device +'</td>'
							+ ' <td>' + item.body_no +'</td>'
							+ ' <td>' + item.tot_batch_num +'</td>'
							+ ' <td>' + item.batch_num +'</td>'
							+ ' <td>' + item.tighten_id +'</td>'
							+ ' <td>' + item.mes_pbsout_seq +'</td>'
							+ tdred
							+ ' <td>'+var_tor_state+'</td>'
							+ ' <td>' + item.tor_value +'</td>'
							+ ' <td>' + var_ang_state +'</td>'
							+ ' <td>' + item.ang_value +'</td>'
							+ ' <td>' + item.tightening_dt +'</td>'
							+ ' <td>' + ChangeDateFormat(item.regdt) +'</td>'
							+ ' <td>' + item.reg_user_id +'</td>'
    					+ '</tr>'
    				);
    				
    				//console.log($('#list_data').val());
    			});
    			
    		}
    	}); */
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
					 "&tool="+$('#ddlTool').val() +
					 "&tightening_result=" +$('#ddlTighteningResult').val()+
					 "&seq=" + $('#txtSeq').val()+
					 "&car_type=" + $('#txtCarType').val() +
					 "&body_no=" + $('#txtBodyNo').val() +
					 "&old_data=" + oldData + 
					 "&page="+now_page+
					 "&show_count="+show_count+
    				 "&excel_down=Y";
    	
    	$.ajax({
    			url:'/api/result/getresulthistory'+params,
    			type:'GET',
    			async:false,
    			success: function(data) {
    				if(data.result == 200){
    					$("#list_excel").empty();
    					$("#list_excel").append("<thead>");
    					$("#list_excel").append("<th><spring:message code="COMMON.Num"/></th>");
				        $("#list_excel").append("<th><spring:message code='COMMON.Tool'/></th>");
				        $("#list_excel").append("<th><spring:message code='RS02.BodyNo'/></th>");
				        $("#list_excel").append("<th><spring:message code='ST02.TotBatchNo'/></th>");
				        $("#list_excel").append("<th><spring:message code='RS03.BatchNum'/></th>");
				        $("#list_excel").append("<th><spring:message code='RS03.TighteningID'/></th>");
				        $("#list_excel").append("<th><spring:message code='RS02.MESSeq'/></th>");
				        $("#list_excel").append("<th><spring:message code='COMMON.TighteningResult'/></th>");
				        $("#list_excel").append("<th><spring:message code='RS03.TorqueState'/></th>");
				        $("#list_excel").append("<th><spring:message code='RS03.TorqueValue'/></th>");
				        $("#list_excel").append("<th><spring:message code='RS03.AngleState'/></th>");
				        $("#list_excel").append("<th><spring:message code='RS03.AngleValue'/></th>");
				        $("#list_excel").append("<th><spring:message code='RS03.TighteningDate'/></th>");
				        $("#list_excel").append("<th><spring:message code='COMMON.RegisterDate'/></th>");
				        $("#list_excel").append("<th><spring:message code='COMMON.Register'/></th>");
    					$("#list_excel").append("</thead>");
    					
    					$("#list_excel").append("<tbody>");
    					
    					data.list.forEach(function(item){
    		    			
    	    				var tdred = "";
    	    				var var_tor_state =  "";
    	    				var var_ang_state = "";
    	    				
    	    				if (  item.batch_tightening_result == "0" )
    	    					tdred = ' <td style="color:red;">NG</td>';
    	    				else
    	    					tdred = ' <td>OK</td>'
    	    				
    	    				if (item.tor_state == "0")
    	    					var_tor_state = "Low";
    	    				if (item.tor_state == "1")
    	    					var_tor_state = "OK";
    	    				if (item.tor_state == "2")
    	    					var_tor_state = "High";
    	    				
    	    				if (item.ang_state == "0")
    	    					var_ang_state = "Low";
    	    				if (item.ang_state == "1")
    	    					var_ang_state = "OK";
    	    				if (item.ang_state == "2")
    	    					var_ang_state = "High";
    	    				
    	    				$('#list_excel').append(
    	    						
    	    						'<tr>'
    								+ ' <td>' + item.rnum +'</td>'
    								+ ' <td class="left_5">' + item.device +'</td>'
    								+ ' <td>' + item.body_no +'</td>'
    								+ ' <td>' + item.tot_batch_num +'</td>'
    								+ ' <td>' + item.batch_num +'</td>'
    								+ ' <td>' + item.tighten_id +'</td>'
    								+ ' <td>' + item.mes_pbsout_seq +'</td>'
    								+ tdred
    								+ ' <td>'+var_tor_state+'</td>'
    								+ ' <td>' + item.tor_value +'</td>'
    								+ ' <td>' + var_ang_state +'</td>'
    								+ ' <td>' + item.ang_value +'</td>'
    								+ ' <td>' + item.tightening_dt +'</td>'
    								+ ' <td>' + ChangeDateFormat(item.regdt) +'</td>'
    								+ ' <td>' + item.reg_user_id +'</td>'
    	    					+ '</tr>'
    	    				);
    	    				
    	    				//console.log($('#list_data').val());
    	    			});
    					
    					$("#list_excel").append("</tbody>");
    				}	
    			},
    		 	error:function(e){  
    				alert(e.responseText);
    	        }  
    			/* error:function(request,status,error){
    		    	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				} */

    		
    			
    		});
    }
</script>
<div class="container">
	<div id="C_Body">       
        <div id="C_Title">
            <div id="content-title">
                <i class="fa fa-list-ul"></i> <spring:message code="SCREEN.RS03" />
            </div>
            <div id="content-title-nav">
                <i class="fa fa-angle-double-right"></i> <spring:message code="MENU.RESULT" />
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
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Plant" />
                                </td>
                                <td width="25%" class="left_5" >
                                	<select id="ddlPlant"></select>
                                    <!-- <asp:DropDownList ID="ddlPlant" runat="server"></asp:DropDownList> -->
                                </td>
                                <td width="12%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Date" /><!-- <asp:Label ID="lblDate" runat="server" Text="COMMON.Date"></asp:Label> -->
                                </td>
                                <td width="35%" class="left_5">
                                    <input type="text" id="txtFromDate" readonly="true" style="width:100px;" >
                                    <!-- <asp:TextBox ID="txtFromDate" runat="server" Width="100"></asp:TextBox> --> ~
                                    <input type="text" id="txtToDate" readonly="true" style="width:100px;" >
                                    <!-- <asp:TextBox ID="txtToDate" runat="server" Width="100"></asp:TextBox> -->
                                    <input type="hidden" id="hdFromDate" />
                                    <input type="hidden" id="hdToDate" />
                                    &nbsp;
                                    <input id="chkSelOldData" type="checkbox" name="chkSelOldData"><spring:message code="RS02.SearchOldData"/>
                                </td>
                                <td rowspan="3"  class="content-button">
                                	<img src="/images/ajax-loader.gif" style="display:none;" id="load-image"/>
                                    <c:set var="btnSearch"><spring:message code="BUTTON.Search"/></c:set>
                                	<input type="button" id="btnSearch" value="${btnSearch}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                    <c:set var="btnExcel"><spring:message code="BUTTON.Excel"/></c:set>
                                	<input type="button" id="btnExcel" value="${btnExcel}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                </td>
                            </tr>
                            <tr>
                                <td height="30" ></td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Tool"/><!-- <asp:Label ID="lblTool" runat="server" Text="COMMON.Tool"></asp:Label> -->
                                </td>
                                <td class="left_5">
                                	<select id="ddlTool"></select>
                                    <!-- <asp:DropDownList ID="ddlTool" runat="server"  AutoPostBack="true" 
                                        onselectedindexchanged="ddlTool_SelectedIndexChanged" ></asp:DropDownList> -->
                                 </td>
                                 <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.TighteningResult"/><!-- <asp:Label ID="lblTighteningResult" runat="server" Text="COMMON.TighteningResult"></asp:Label> -->
                                </td>
                                <td class="left_5">
                                	<select id="ddlTighteningResult"></select>
                                    <!-- <asp:DropDownList ID="ddlTighteningResult" runat="server"  AutoPostBack="true" 
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
	        	<table class="gridview" cellspacing="0" border="0" style="width:2000px;border-collapse:collapse;" id="list_table">
	            	<thead>
						<tr>
							<th style="width:1%"><div align="center"><spring:message code="COMMON.Num"/></div></th>
					        <th style="width:5%"><div align="center"><spring:message code="COMMON.Tool"/></div></th>
					        <th style="width:2%"><div align="center"><spring:message code="RS02.BodyNo"/></div></th>
					        <th style="width:3%"><div align="center"><spring:message code="ST02.TotBatchNo"/></div></th>
					        <th style="width:2%"><div align="center"><spring:message code="RS03.BatchNum"/></div></th>
					        <th style="width:2%"><div align="center"><spring:message code="RS03.TighteningID"/></div></th>
					        <th style="width:2%"><div align="center"><spring:message code="RS02.MESSeq"/></div></th>
					        <th style="width:3%"><div align="center"><spring:message code="COMMON.TighteningResult"/></div></th>
					        <th style="width:2%"><div align="center"><spring:message code="RS03.TorqueState"/></div></th>
					        <th style="width:2%"><div align="center"><spring:message code="RS03.TorqueValue"/></div></th>
					        <th style="width:2%"><div align="center"><spring:message code="RS03.AngleState"/></div></th>
					        <th style="width:2%"><div align="center"><spring:message code="RS03.AngleValue"/></div></th>
					        <th style="width:3%"><div align="center"><spring:message code="RS03.TighteningDate"/></div></th>
					        <th style="width:3%"><div align="center"><spring:message code="COMMON.RegisterDate"/></div></th>
					        <th style="width:3%"><div align="center"><spring:message code="COMMON.Register"/></div></th>
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
