<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8"> 
	<title>programandprocess</title>
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
    	getStnType('A');
    	getProcState('A');
    	getPgmList('A');
    	getProcList('A');
    	
		$.ajaxSetup({async:true});	//비동기 켜기
		
		getList();
		
		$("#btnSearch").on('click', function(e){
			getList();
		});
		
		$('#ddlStnType').on('change', function(){
			getPgmList('A');
	    	getProcList('A');
			getList();
    	});
		
		$('#ddlProgram').on('change', function(){
			getProcList('A');
			getList();
    	});
		
		$('#ddlProcState').on('change', function(){
			$('#btnSearch').click()
    	});
		
		$('#ddlProcess').on('change', function(){
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
    var show_count = 20;

    function getList(){
    	
    	var params = "?plant_cd="+$('#ddlPlant').val().trim() +
    				 "&stn_gub="+$('#ddlStnType').val() +
    				 "&pgm_id="+$('#ddlProgram').val() +
    				 "&proc_id="+$('#ddlProcess').val() +
    				 "&proc_state="+$('#ddlProcState').val() +
    				 "&page="+now_page+
    				 "&show_count="+show_count;
    	
    	$.get('/api/system/getprogramprocess'+params,function(data){
    		if(data.result == 200){
    			
    			$('#select_page_count').empty();
    			$('#list_total').text(data.total_count); 	// 총갯수
    			
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
							+ ' <td>'+ item.rnum +'</td>'
							+ ' <td>'+ item.stn_gub +'</td>'
							//+ ' <td>'+ item.pgm_id +'</td>'
							+ '<td><a href=\'#\' onClick="OpenRegistration(\'' + item.pgm_id.trim() +'\',\''+item.proc_id.trim() +'\');">' + item.pgm_id              + '</a></td>'
							+ ' <td>'+ item.pgm_nm +'</td>'
							+ ' <td>'+ item.proc_id +'</td>'
							+ ' <td>'+ item.proc_nm +'</td>'
							+ ' <td>'+ item.tightening_proc_status +'</td>'
							+ ' <td>'+ item.device_id +'</td>'
							+ ' <td>'+ item.reconnect_waiting_sec +'</td>'
							+ ' <td>'+ item.trk_stn_cnt +'</td>'
							+ ' <td>'+ item.trk_stn_nm +'</td>'
							+ ' <td>'+ item.logical_trk_flg +'</td>'
							+ ' <td>'+ item.interlock_use_flg +'</td>'
							+ ' <td>'+ item.interlock_ng_point +'</td>'
							+ ' <td>'+ item.interlock_ng_cnt +'</td>'
							+ ' <td>'+ item.interlock_noscan_point +'</td>'
							+ ' <td>'+ item.interlock_noscan_cnt +'</td>'
							+ ' <td>'+ item.trk_plc_type +'</td>'
							+ ' <td>'+ item.trk_plc_ip +'</td>'
							+ ' <td>'+ item.trk_plc_port +'</td>'
							+ ' <td>'+ item.trk_plc_start_add +'</td>'
							+ ' <td>'+ item.interlock_plc_type +'</td>'
							+ ' <td>'+ item.interlock_plc_ip +'</td>'
							+ ' <td>'+ item.interlock_plc_port +'</td>'
							+ ' <td>'+ item.interlock_plc_start_add +'</td>'
							+ ' <td>'+ item.mes_stn_cd +'</td>'
							+ ' <td>'+ item.trk_point +'</td>'
							+ ' <td>'+ item.ng_mes_stn_cd +'</td>'
							+ ' <td>'+ item.ng_trk_point +'</td>'
							+ ' <td>'+ item.ng_trk_view_cnt +'</td>'
							+ ' <td>'+ item.ng_trk_alram_point +'</td>'
							+ ' <td>'+ item.scanning_use_flg +'</td>'
							+ ' <td>'+ item.cycle_test_time +'</td>'
							+ ' <td>'+ ChangeDateFormat(item.tightening_proc_dt) +'</td>'
							+ ' <td>'+ ChangeDateFormat(item.regdt) +'</td>'
							+ ' <td>'+ item.reg_user_id +'</td>'
    					+ '</tr>'
    				);
    			});
    			
    		}
    	});
    }

	function OpenRegistration(PgmID, ProcID) {
        //var title = fn_DisplayDictionary("SCREEN.SM01", "R");
        var title= '<spring:message code="SCREEN.SM01" />';
        fn_ShowDialog('/view/system/programandprocessP01?PgmID=' + PgmID + '&ProcID=' + ProcID, title, '950', '660', true);
    }

    function CloseDialog(flg) {
    	$('#btnSearch').click()
        fn_CloseDialog('', flg);
    }   
    
    function getExcelData(){
    	    	var params = "?plant_cd="+$('#ddlPlant').val().trim() +
    				 "&stn_gub="+$('#ddlStnType').val() +
    				 "&pgm_id="+$('#ddlProgram').val() +
    				 "&proc_id="+$('#ddlProcess').val() +
    				 "&proc_state="+$('#ddlProcState').val() +
    				 "&page="+now_page+
    				 "&show_count="+show_count+
    				 "&excel_down=Y";
    	
    	$.ajax({
    			url:'/api/system/getprogramprocess'+params,
    			type:'GET',
    			async:false,
    			success: function(data) {
    				if(data.result == 200){
    					$("#list_excel").empty();
    					$("#list_excel").append("<thead>");
    					
						$("#list_excel").append("<th><spring:message code='COMMON.Num'/></th>");
						$("#list_excel").append("<th><spring:message code='COMMON.StnType'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.Program'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.PgmName'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.Process'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.ProcName'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.ProcState'/></th>");
						$("#list_excel").append("<th><spring:message code='COMMON.Tool'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.ReconnTime'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.TrkDispCount'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.TrkTitle'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.LogicalTrkFlag'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.InterlockFlag'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.InterlockNGPoint'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.InterlockNGCount'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.InterlockNoScanPoint'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.InterlockNoScanCount'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.TrkPLCType'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.TrkPLCIP'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.TrkPLCPort'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.TrkPLCStartAddr'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.InterlockPLCType'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.InterlockPLCIP'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.InterlockPLCPort'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.InterlockPLCStartAddr'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.MESStnCD'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.TrkStartPos'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.NGMESStnCD'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.NGTrkStartPos'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.NGTrkDispCount'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.NGTrkAlarmPos'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.ScannerFlag'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.CycleTestInterval'/></th>");
						$("#list_excel").append("<th><spring:message code='SM01.ProcChkTime'/></th>");
						$("#list_excel").append("<th><spring:message code='COMMON.RegisterDate'/></th>");
						$("#list_excel").append("<th><spring:message code='COMMON.Register'/></th>");
						
    					$("#list_excel").append("</thead>");
    					
    					$("#list_excel").append("<tbody>");
    					
    					data.list.forEach(function(item){
    						
    						$('#list_excel').append(
    								'<tr>' 
    								+ ' <td>'+ item.rnum +'</td>'
    								+ ' <td>'+ item.stn_gub +'</td>'
    								+ ' <td>'+ item.pgm_id +'</td>'
    								+ ' <td>'+ item.pgm_nm +'</td>'
    								+ ' <td>'+ item.proc_id +'</td>'
    								+ ' <td>'+ item.proc_nm +'</td>'
    								+ ' <td>'+ item.tightening_proc_status +'</td>'
    								+ ' <td>'+ item.device_id +'</td>'
    								+ ' <td>'+ item.reconnect_waiting_sec +'</td>'
    								+ ' <td>'+ item.trk_stn_cnt +'</td>'
    								+ ' <td>'+ item.trk_stn_nm +'</td>'
    								+ ' <td>'+ item.logical_trk_flg +'</td>'
    								+ ' <td>'+ item.interlock_use_flg +'</td>'
    								+ ' <td>'+ item.interlock_ng_point +'</td>'
    								+ ' <td>'+ item.interlock_ng_cnt +'</td>'
    								+ ' <td>'+ item.interlock_noscan_point +'</td>'
    								+ ' <td>'+ item.interlock_noscan_cnt +'</td>'
    								+ ' <td>'+ item.trk_plc_type +'</td>'
    								+ ' <td>'+ item.trk_plc_ip +'</td>'
    								+ ' <td>'+ item.trk_plc_port +'</td>'
    								+ ' <td>'+ item.trk_plc_start_add +'</td>'
    								+ ' <td>'+ item.interlock_plc_type +'</td>'
    								+ ' <td>'+ item.interlock_plc_ip +'</td>'
    								+ ' <td>'+ item.interlock_plc_port +'</td>'
    								+ ' <td>'+ item.interlock_plc_start_add +'</td>'
    								+ ' <td>'+ item.mes_stn_cd +'</td>'
    								+ ' <td>'+ item.trk_point +'</td>'
    								+ ' <td>'+ item.ng_mes_stn_cd +'</td>'
    								+ ' <td>'+ item.ng_trk_point +'</td>'
    								+ ' <td>'+ item.ng_trk_view_cnt +'</td>'
    								+ ' <td>'+ item.ng_trk_alram_point +'</td>'
    								+ ' <td>'+ item.scanning_use_flg +'</td>'
    								+ ' <td>'+ item.cycle_test_time +'</td>'
    								+ ' <td>'+ ChangeDateFormat(item.tightening_proc_dt) +'</td>'
    								+ ' <td>'+ ChangeDateFormat(item.regdt) +'</td>'
    								+ ' <td>'+ item.reg_user_id +'</td>'
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
                <i class="fa fa-list-ul"></i> <spring:message code="SCREEN.SM01" />
            </div>
            <div id="content-title-nav">
                <i class="fa fa-angle-double-right"></i> <spring:message code="MENU.SYSTEM" />
            </div>
            <div id="content-title-bar">
            </div>  
        </div> 
        <div id="C_Search">
            <table cellpadding="1" cellspacing="1" border="1" align="center" class="search_table">
                <tbody>
                <tr>
                <td height="70" >
                        <table width="100%">
                            <tr>
                                <td width="1%"></td>
                                <td width="10%" height="30" bgcolor="#FFFFFF" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Plant" />
                                </td>
                                <td width="25%" class="left_5">
                                	<select id="ddlPlant"></select>
                                    <!-- <asp:DropDownList ID="ddlPlant" runat="server"></asp:DropDownList> -->
                                </td>
                                <td  width="10%" bgcolor="#FFFFFF" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.StnType" />
                                </td>
                                <td width="15%" class="left_5">
                                	<select id="ddlStnType"></select>
                                    <!-- <asp:DropDownList ID="ddlStnType" runat="server" AutoPostBack="true" 
                                        onselectedindexchanged="ddlStnType_SelectedIndexChanged"></asp:DropDownList> -->
                                </td>
                                <td width="9%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="SM01.ProcState" /><!-- <asp:Label ID="lblProcState" runat="server" Text="SM01.ProcState"></asp:Label> -->
                                </td>
                                <td width="10%" class="left_5" >
                                	<select id="ddlProcState"></select>
                                    <!-- <asp:DropDownList ID="ddlProcState" runat="server" AutoPostBack="true"
                                        onselectedindexchanged="ddlProcState_SelectedIndexChanged">
                                    </asp:DropDownList> -->
                                </td>
                                 <td rowspan="2"  class="content-button">
                                 	<c:set var="btnSearch"><spring:message code="BUTTON.Search"/></c:set>
                                	<input type="button" id="btnSearch" value="${btnSearch}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                    	<!-- <asp:Button ID="btnSearch" runat="server" Text="BUTTON.Search"  OnClick="btnSearch_Click" /> -->
                                    <c:set var="btnExcel"><spring:message code="BUTTON.Excel"/></c:set>
                                	<input type="button" id="btnExcel" value="${btnExcel}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                    	<!-- <asp:Button ID="btnExcel" runat="server" Text="BUTTON.Excel" OnClick="btnExcel_Click" /> -->
                                    <div style="padding-top:3px;">
                                    	<c:set var="btnReg"><spring:message code="BUTTON.Registration"/></c:set>
                                		<input type="button" id="btnReg" value="${btnReg}" class="ui-button ui-widget ui-state-default ui-corner-all" onclick="OpenRegistration('', '')" role="button">
                                    	<!-- <asp:Button ID="btnReg" runat="server" Text="BUTTON.Registration" OnClientClick="OpenRegistration('', '')" /> -->
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td bgcolor="#FFFFFF" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="SM01.Program" /><!-- <asp:Label ID="lblProgram" runat="server" Text="SM01.Program"></asp:Label> -->
                                </td>
                                <td class="left_5">
                                	<select id="ddlProgram"></select>
                                    <!-- <asp:DropDownList ID="ddlProgram" runat="server" AutoPostBack="true" onselectedindexchanged="ddlProgram_SelectedIndexChanged"></asp:DropDownList> -->
                                 </td>
                                <td bgcolor="#FFFFFF" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="SM01.Process" /><!-- <asp:Label ID="lblProcess" runat="server" Text="SM01.Process"></asp:Label> -->
                                </td>
                                <td class="left_5" colspan="4" >
                                	<select id="ddlProcess"></select>
                                    <!-- <asp:DropDownList ID="ddlProcess" runat="server" AutoPostBack="true"
                                        onselectedindexchanged="ddlProcess_SelectedIndexChanged"></asp:DropDownList> -->
                                 </td>                
                            </tr>
                        </table>
                    </td>
                </tr>
            	</tbody>
            </table>
        </div>
        <div id="C_Result" style="overflow:auto;">
           <div class="total_count">
                [ <spring:message code="COMMON.TotalCont" /> : <div style='display:inline;' id="list_total"></div> ]
            </div>
	        <div style="position: relative;width:500;overflow:auto;" >
	        	<table class="gridview" cellspacing="0" border="0" style="width:5500px;border-collapse:collapse;" id="list_table">
	            	<thead>
						<tr>
							<th><spring:message code="COMMON.Num"/></th>
							<th><spring:message code="COMMON.StnType"/></th>
							<th><spring:message code="SM01.Program"/></th>
							<th><spring:message code="SM01.PgmName"/></th>
							<th><spring:message code="SM01.Process"/></th>
							<th><spring:message code="SM01.ProcName"/></th>
							<th><spring:message code="SM01.ProcState"/></th>
							<th><spring:message code="COMMON.Tool"/></th>
							<th><spring:message code="SM01.ReconnTime"/></th>
							<th><spring:message code="SM01.TrkDispCount"/></th>
							<th><spring:message code="SM01.TrkTitle"/></th>
							<th><spring:message code="SM01.LogicalTrkFlag"/></th>
							<th><spring:message code="SM01.InterlockFlag"/></th>
							<th><spring:message code="SM01.InterlockNGPoint"/></th>
							<th><spring:message code="SM01.InterlockNGCount"/></th>
							<th><spring:message code="SM01.InterlockNoScanPoint"/></th>
							<th><spring:message code="SM01.InterlockNoScanCount"/></th>
							<th><spring:message code="SM01.TrkPLCType"/></th>
							<th><spring:message code="SM01.TrkPLCIP"/></th>
							<th><spring:message code="SM01.TrkPLCPort"/></th>
							<th><spring:message code="SM01.TrkPLCStartAddr"/></th>
							<th><spring:message code="SM01.InterlockPLCType"/></th>
							<th><spring:message code="SM01.InterlockPLCIP"/></th>
							<th><spring:message code="SM01.InterlockPLCPort"/></th>
							<th><spring:message code="SM01.InterlockPLCStartAddr"/></th>
							<th><spring:message code="SM01.MESStnCD"/></th>
							<th><spring:message code="SM01.TrkStartPos"/></th>
							<th><spring:message code="SM01.NGMESStnCD"/></th>
							<th><spring:message code="SM01.NGTrkStartPos"/></th>
							<th><spring:message code="SM01.NGTrkDispCount"/></th>
							<th><spring:message code="SM01.NGTrkAlarmPos"/></th>
							<th><spring:message code="SM01.ScannerFlag"/></th>
							<th><spring:message code="SM01.CycleTestInterval"/></th>
							<th><spring:message code="SM01.ProcChkTime"/></th>
							<th><spring:message code="COMMON.RegisterDate"/></th>
							<th><spring:message code="COMMON.Register"/></th>
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
				  			<option value="10" >10</option>
				  			<option value="20" selected>20</option>
				  			<option value="30" >30</option>
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
