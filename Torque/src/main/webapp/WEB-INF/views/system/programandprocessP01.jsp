<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	HttpSession my_session = request.getSession();
	String user_id = (String)my_session.getAttribute("USER_ID");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>KMM TMS</title>
	<jsp:include page="../head.jsp" flush="false" />
    <script type="text/javascript">
    if('null' == '<%=user_id%>'){
    	alert('LOGIN!!');
    	parent.location.reload();
    	parent.CloseDialog(0);	//세션 끊겼을때 로그인 을 모달 창에서 해서.. 세션 끊기면 로그인전 모달창 닫게함
    	location.href = '/';
    }
    
        $(document).ready(function() {
        	
        	var pgm_id = getQuerystring('PgmID')
        	var proc_id = getQuerystring('ProcID');
        	
            $("#btnSave").button();
            $("#btnModify").button();
            $("#btnDelete").button();
            $("#btnReset").button();
            $("#btnClose").button();

            Init();
            
            if ( pgm_id.length > 0 ){
        		$('#txtPgmID').val(pgm_id);
        		$('#txtPgmID').attr("disabled",true);
        		
        		$('#txtProcID').val(proc_id);
        		$('#txtProcID').attr("disabled",true);
        		//$('#ddlPlant').attr("disabled",true);
        		
        		LoadInfo(pgm_id,proc_id);
        		
        		$("#btnSave").hide();
        		$("#btnModify").show();
        		$("#btnDelete").show();
        	}
            
            $("#btnSave").click(function(e) {
                if ($("#ddlStnType").val() == "-1" || $("#ddlStnType").val() == "") {
                    e.preventDefault();
                    var retVal = '<spring:message code="COMMON.SelectStnType"/>';
                    $("#divMessage").text(retVal);
                    $("#ddlStnType").focus();
                } else if ($("#txtPgmID").val() == "") {
                    e.preventDefault();
                    var retVal = '<spring:message code="SM01.EnterProgram"/>';
                    $("#divMessage").text(retVal);
                    $("#txtPgmID").focus();
                } else if ($("#txtProcID").val() == "") {
                    e.preventDefault();
                    var retVal = '<spring:message code="SM01.EnterProcess"/>';
                    $("#divMessage").text(retVal);
                    $("#txtProcID").focus();
                } else if($('#ddlTool').val() == "" || $('#ddlTool').val() == "-1") {
	    	        var retVal = '<spring:message code="ST02.SelectToolID"/>';
	    	        $("#divMessage").text(retVal);
                    $("#ddlTool").focus();        
                } else {
                    //e.preventDefault();
                    var msg = '<spring:message code="COMMON.ConfirmInsert"/>';
                    
                    if (confirm(msg)){
                    	
                    	var body = {
                    			plant_cd 				: $('#ddlPlant').val(),
	                   			pgm_id					: $('#txtPgmID').val(),
                    			proc_id					: $('#txtProcID').val(),
                    			pgm_nm					: $('#txtPgmName').val(),
                    			proc_nm					: $('#txtProcName').val(),
                    			stn_gub					: $('#ddlStnType').val(),
                    			tool					: $('#ddlTool').val(),
                    			reconnect_waiting_sec	: $('#txtReconnTime').val(),
                    			
                    			interlock_use_flg		: $('#ddlInterlockFlag').val(),
                    			interlock_ng_point		: $('#txtInterlockNGPoint').val(),
                    			interlock_ng_cnt		: $('#txtInterlockNGCount').val(),
                    			interlock_noscan_point	: $('#txtInterlockNoScanPoint').val(),
                    			interlock_noscan_cnt	: $('#txtInterlockNoScanCount').val(),
                    			
                    			trk_plc_type 			: '-1',
                    			trk_plc_ip				: '',
                    			trk_plc_port			: '',
                    			trk_plc_start_add		: '',
                    			
                    			interlock_plc_type		: '-1',
                    			interlock_plc_ip		: '',
                    			interlock_plc_port		: '',
                    			interlock_plc_start_add : '',
                    			
                    			logical_trk_flg			: $('#ddlLogicalTrkFlag').val(),
                    			mes_stn_cd				: $('#txtMESStnCD').val(),
                    			trk_point				: $('#txtTrkStartPos').val(),
                    			trk_stn_cnt 			: $('#txtTrkDispCount').val(),
                    			trk_stn_nm				: $('#txtTrkTitle').val(),
 
                    			ng_trk_alarm_point		: $('#txtNGTrkAlarmPos').val(),
                    			ng_mes_stn_cd			: $('#txtNGMESStnCD').val(),
                    			ng_trk_point			: $('#txtNGTrkStartPos').val(),
                    			ng_trk_view_cnt			: $('#txtNGTrkDispCount').val(),
                    			
                    			scanning_use_flg		: $('#ddlScannerFlag').val(),
                    			cycle_test_time			: $('#txtCycleTestInterval').val(),
                    			reg_user_id 			: '' 
                    			
                    	}
                    	
                    	$.ajax({
                			type : "POST",
                			url : '/api/system/programprocess_insert',
                			data : JSON.stringify(body),
                			headers: { 
                				'Accept': 'application/json',
                				'Content-Type': 'application/json' 
                			}
                		}).done(function(result) {
                			//console.log(result);
                			if(result.result == 200){
                				var retVal = '<spring:message code="COMMON.Success"/>';
                	            $("#divMessage").text(retVal);
                			}else if( result.result == 300){
                				var retVal = '<spring:message code="COMMON.RegisteredID"/>';
                	            $("#divMessage").text(retVal);
                			}
                			
                		}).fail(function(data) {
                			var retVal = '<spring:message code="COMMON.OccurredError"/>';
                            $("#divMessage").text(retVal);
                		});
                    }
                }
            });
            

            $("#btnModify").click(function(e) {
            	 var msg = '<spring:message code="COMMON.ConfirmUpdate"/>';
                
                if ( confirm(msg)){
                    
                	var params = "?plant_cd="+$('#ddlPlant').val()+
            		"&pgm_id="+pgm_id+
            		"&proc_id="+proc_id;
                	
                	var body = {
                			//plant_cd 				: $('#ddlPlant').val(),
                   			//pgm_id					: $('#txtPgmID').val(),
                			//proc_id					: $('#txtProcID').val(),
                			pgm_nm					: $('#txtPgmName').val(),
                			proc_nm					: $('#txtProcName').val(),
                			stn_gub					: $('#ddlStnType').val(),
                			tool					: $('#ddlTool').val(),
                			reconnect_waiting_sec	: $('#txtReconnTime').val(),
                			
                			interlock_use_flg		: $('#ddlInterlockFlag').val(),
                			interlock_ng_point		: $('#txtInterlockNGPoint').val(),
                			interlock_ng_cnt		: $('#txtInterlockNGCount').val(),
                			interlock_noscan_point	: $('#txtInterlockNoScanPoint').val(),
                			interlock_noscan_cnt	: $('#txtInterlockNoScanCount').val(),
                			
                			trk_plc_type 			: '-1',
                			trk_plc_ip				: '',
                			trk_plc_port			: '',
                			trk_plc_start_add		: '',
                			
                			interlock_plc_type		: '-1',
                			interlock_plc_ip		: '',
                			interlock_plc_port		: '',
                			interlock_plc_start_add : '',
                			
                			logical_trk_flg			: $('#ddlLogicalTrkFlag').val(),
                			mes_stn_cd				: $('#txtMESStnCD').val(),
                			trk_point				: $('#txtTrkStartPos').val(),
                			trk_stn_cnt 			: $('#txtTrkDispCount').val(),
                			trk_stn_nm				: $('#txtTrkTitle').val(),

                			ng_trk_alarm_point		: $('#txtNGTrkAlarmPos').val(),
                			ng_mes_stn_cd			: $('#txtNGMESStnCD').val(),
                			ng_trk_point			: $('#txtNGTrkStartPos').val(),
                			ng_trk_view_cnt			: $('#txtNGTrkDispCount').val(),
                			
                			scanning_use_flg		: $('#ddlScannerFlag').val(),
                			cycle_test_time			: $('#txtCycleTestInterval').val(),
                			reg_user_id 			: '' 
                			
                	}
                	
                	
                	$.ajax({
            			type : "PUT",
            			url : '/api/system/programprocess_update'+params,
            			data : JSON.stringify(body),
            			headers: { 
            				'Accept': 'application/json',
            				'Content-Type': 'application/json' 
            			}
            		}).done(function(result) {
            			//console.log(result);
            			if(result.result == 200){
            				var retVal = '<spring:message code="COMMON.Success"/>';
            	            $("#divMessage").text(retVal);
            			}else if( result.result == 300){
            				var retVal = '<spring:message code="COMMON.OccurredError"/>';
            	            $("#divMessage").text(retVal);
            			}
            			
            		}).fail(function(data) {
            			var retVal = '<spring:message code="COMMON.OccurredError"/>';
                        $("#divMessage").text(retVal);
            		});      
                	
                }
            });

            $("#btnDelete").click(function(e) {
                //var msg = fn_DisplayMessage("COMMON.ConfirmDelete", "R");
                var msg = '<spring:message code="COMMON.ConfirmDelete"/>';
                if ( confirm(msg)){
                
                	var params = "?plant_cd="+$('#ddlPlant').val()+
            		"&pgm_id="+pgm_id+
            		"&proc_id="+proc_id;
                
                	$.ajax({
            			type : "DELETE",
            			url : '/api/system/programprocess_delete'+params,
            		}).done(function(result) {
            			//console.log(result);
            			if(result.result == 200){
            				var retVal = '<spring:message code="COMMON.Success"/>';
            	            $("#divMessage").text(retVal);
            			}else if( result.result == 300){
            				var retVal = '<spring:message code="COMMON.OccurredError"/>';
            	            $("#divMessage").text(retVal);
            			}
            			
            		}).fail(function(data) {
            			var retVal = '<spring:message code="COMMON.OccurredError"/>';
                        $("#divMessage").text(retVal);
            		});
                }
            });

            $("#btnReset").click(function(e) {
                form1.reset();
                $("#divMessage").text('');
                e.preventDefault();
            });

            $("#btnClose").click(function(e) {
                e.preventDefault();
                parent.CloseDialog(0);
            });
        })
        
        function Init(){
        	$.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
        	getPlant();
            getStnType('S');
            
            getUseFlag('ddlInterlockFlag','S');
            getUseFlag('ddlLogicalTrkFlag','S');
            getUseFlag('ddlScannerFlag','S');
            
            //getToolList();
            getToolId('S',$('#ddlPlant').val(),'-1',$('#ddlStnType').val(),'-1','-1')
            //getPLCType();
            
            $.ajaxSetup({async:true});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
            
            $("#btnSave").show();
        	$("#btnModify").hide();
        	$("#btnDelete").hide();
        }
        
        function LoadInfo(pgm_id,proc_id){
        	var params = "?pgm_id="+pgm_id.trim() +
        	"&proc_id="+proc_id.trim();
        	
        	$.get('/api/system/programprocess_info'+params,function(data){
        		//console.log(data);
        		if(data.length > 0){
        			
        			$('#ddlPlant').val(data[0].plant_cd.trim());
        			$('#ddlStnType').val(data[0].stn_gub.trim());	
        			
        			
           			$('#txtPgmID').val(data[0].pgm_id.trim());
        			$('#txtProcID').val(data[0].proc_id.trim());
					$('#txtPgmName').val(data[0].pgm_nm.trim());
        			$('#txtProcName').val(data[0].proc_nm.trim());
        			
        			$('#ddlTool').val(data[0].device_id.trim()+'-'+data[0].device_serial.trim());
        			$('#txtReconnTime').val(data[0].reconnect_waiting_sec.trim());
        			
        			$('#ddlInterlockFlag').val(data[0].interlock_use_flg.trim());
        			$('#txtInterlockNGPoint').val(data[0].interlock_ng_point.trim());
        			$('#txtInterlockNGCount').val(data[0].interlock_ng_cnt.trim());
        			$('#txtInterlockNoScanPoint').val(data[0].interlock_noscan_point.trim());
        			$('#txtInterlockNoScanCount').val(data[0].interlock_noscan_cnt.trim());
        			
        			/* 
        			trk_plc_type 			: '-1',
        			trk_plc_ip				: '',
        			trk_plc_port			: '',
        			trk_plc_start_add		: '',
        			
        			interlock_plc_type		: '-1',
        			interlock_plc_ip		: '',
        			interlock_plc_port		: '',
        			interlock_plc_start_add : '',
        			*/
        			
        			logical_trk_flg			: $('#ddlLogicalTrkFlag').val(data[0].logical_trk_flg.trim());
        			mes_stn_cd				: $('#txtMESStnCD').val(data[0].mes_stn_cd.trim());
        			trk_point				: $('#txtTrkStartPos').val(data[0].trk_point.trim());
        			trk_stn_cnt 			: $('#txtTrkDispCount').val(data[0].trk_stn_cnt.trim());
        			trk_stn_nm				: $('#txtTrkTitle').val(data[0].trk_stn_nm.trim());
        			
        			ng_trk_alarm_point		: $('#txtNGTrkAlarmPos').val(data[0].ng_trk_alarm_point.trim());
        			ng_mes_stn_cd			: $('#txtNGMESStnCD').val(data[0].ng_mes_stn_cd.trim());
        			ng_trk_point			: $('#txtNGTrkStartPos').val(data[0].ng_trk_point.trim());
        			ng_trk_view_cnt			: $('#txtNGTrkDispCount').val(data[0].ng_trk_view_cnt.trim());
        			
        			scanning_use_flg		: $('#ddlScannerFlag').val(data[0].scanning_use_flg.trim());
        			cycle_test_time			: $('#txtCycleTestInterval').val(data[0].cycle_test_time.trim());
        		}
        	})
        }
        
    </script>
</head>
<body>
    <form id="form1">
    <div class="panel">
        <div>
            <table width="100%" align="center" class="table table-bordered">
                    <tr>
                        <td width="20%" class="td-title"><spring:message code="COMMON.Plant"/></td>
                        <td width="30%"><select id="ddlPlant"></select></td>
                        <td width="20%" class="td-title"><spring:message code="COMMON.StnType"/></td>
                        <td width="30%"><select id="ddlStnType"></select></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="SM01.Program"/></td>
                        <td ><input type="text" id="txtPgmID" Width="90%" /></td>
                        <td  class="td-title"><spring:message code="SM01.PgmName"/></td>
                        <td ><input type="text" id="txtPgmName" Width="90%" /></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="SM01.Process"/></td>
                        <td ><input type="text" id="txtProcID" Width="90%" /></td>
                        <td  class="td-title"><spring:message code="SM01.ProcName"/></td>
                        <td ><input type="text" id="txtProcName" Width="90%" /></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="ST01.Tool"/></td>
                        <td ><select id="ddlTool"></select>
                        </td>
                        <td  class="td-title"><spring:message code="SM01.ReconnTime"/></td>
                        <td ><input type="text" id="txtReconnTime" Width="30%" onkeypress="fn_NumKey()"/></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="SM01.InterlockFlag"/></td>
                        <td ><select id="ddlInterlockFlag"></select></td>
                        <td class="td-title"><spring:message code="SM01.LogicalTrkFlag"/></td>
                        <td><select id="ddlLogicalTrkFlag"></select></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="SM01.InterlockNGPoint"/></td>
                        <td ><input type="text" id="txtInterlockNGPoint" Width="30%" onkeypress="fn_NumKey()" /></td>
                        <td  class="td-title"><spring:message code="SM01.InterlockNGCount"/></td>
                        <td ><input type="text" id="txtInterlockNGCount" Width="30%" onkeypress="fn_NumKey()" /></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="SM01.InterlockNoScanPoint"/></td>
                        <td ><input type="text" id="txtInterlockNoScanPoint" Width="30%" onkeypress="fn_NumKey()" /></td>
                        <td  class="td-title"><spring:message code="SM01.InterlockNoScanCount"/></td>
                        <td ><input type="text" id="txtInterlockNoScanCount" Width="30%" onkeypress="fn_NumKey()" /></td>
                    </tr>
                    <%--<tr>
                        <td  class="td-title font-white" colspan="2" style="background-color:#D9418C;"><asp:Label ID="lblSetTrkSet" runat="server" Text="SM01.SetTrkPLC"></asp:Label></td>
                        <td  class="td-title font-white" colspan="2" style="background-color:#D9418C;"><asp:Label ID="Label1" runat="server" Text="SM01.SetInterlockPLC"></asp:Label></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><asp:Label ID="lblTrkPLCType" runat="server" Text="SM01.TrkPLCType"></asp:Label></td>
                        <td ><asp:DropDownList ID="ddlTrkPLCType" runat="server"></asp:DropDownList></td>
                        <td  class="td-title"><asp:Label ID="lblInterlockPLCType" runat="server" Text="SM01.InterlockPLCType"></asp:Label></td>
                        <td ><asp:DropDownList ID="ddlInterlockPLCType" runat="server"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><asp:Label ID="lblTrkPLCIP" runat="server" Text="SM01.TrkPLCIP"></asp:Label></td>
                        <td ><asp:TextBox ID="txtTrkPLCIP" runat="server" Width="90%"></asp:TextBox></td>
                        <td  class="td-title"><asp:Label ID="lblInterlockPLCIP" runat="server" Text="SM01.InterlockPLCIP"></asp:Label></td>
                        <td ><asp:TextBox ID="txtInterlockPLCIP" runat="server" Width="90%"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><asp:Label ID="lblTrkPLCPort" runat="server" Text="SM01.TrkPLCPort"></asp:Label></td>
                        <td ><asp:TextBox ID="txtTrkPLCPort" runat="server" Width="90%" MaxLength="4" onkeypress="fn_NumKey()"></asp:TextBox></td>
                        <td  class="td-title"><asp:Label ID="lblInterlockPLCPort" runat="server" Text="SM01.InterlockPLCPort"></asp:Label></td>
                        <td ><asp:TextBox ID="txtInterlockPLCPort" runat="server" Width="90%" MaxLength="4" onkeypress="fn_NumKey()"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="td-title"><asp:Label ID="lblTrkPLCStartAddr" runat="server" Text="SM01.TrkPLCStartAddr"></asp:Label></td>
                        <td ><asp:TextBox ID="txtTrkPLCStartAddr" runat="server" Width="90%"></asp:TextBox></td>
                        <td class="td-title"><asp:Label ID="lblInterlockPLCStartAddr" runat="server" Text="SM01.InterlockPLCStartAddr"></asp:Label></td>
                        <td ><asp:TextBox ID="txtInterlockPLCStartAddr" runat="server" Width="90%"></asp:TextBox></td>
                    </tr>--%>
                    <tr>
                        <td class="td-title  font-white" colspan="4" style="background-color:#D9418C;"><spring:message code="SM01.SetLogicalTracking"/></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="SM01.MESStnCD"/></td>
                        <td ><input type="text" id="txtMESStnCD" Width="90%"  Width="90%" MaxLength="4" /></td>
                        <td class="td-title"><spring:message code="SM01.TrkStartPos"/></td>
                        <td ><input type="text" id="txtTrkStartPos" Width="30%" onkeypress="fn_NumKey()" /></td>
                    </tr>
                    <tr>
                        <td class="td-title font-white" colspan="4" style="background-color:#D9418C;"><spring:message code="SM01.SetRepair"/></td>
                    </tr>
                    <tr>
                        <td  class="td-title"><spring:message code="SM01.TrkTitle"/></td>
                        <td ><input type="text" id="txtTrkTitle" Width="90%" /></td>
                        <td  class="td-title"><spring:message code="SM01.TrkDispCount"/></td>
                        <td ><input type="text" id="txtTrkDispCount" Width="30%" onkeypress="fn_NumKey()" /></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="SM01.NGMESStnCD"/></td>
                        <td ><input type="text" ID="txtNGMESStnCD" runat="server" Width="90%" MaxLength="4"/></td>
                        <td class="td-title"><spring:message code="SM01.ScannerFlag"/></td>
                        <td ><select id="ddlScannerFlag"></select></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="SM01.NGTrkDispCount"/></td>
                        <td ><input type="text" id="txtNGTrkDispCount" Width="30%" onkeypress="fn_NumKey()" /></td>
                        <td class="td-title"><spring:message code="SM01.CycleTestInterval"/></td>
                        <td ><input type="text" id="txtCycleTestInterval" Width="30%" MaxLength="2"  onkeypress="fn_NumKey()" /></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="SM01.NGTrkStartPos"/></td>
                        <td ><input type="text" id="txtNGTrkStartPos" Width="30%" onkeypress="fn_NumKey()" /></td>
                        <td class="td-title"></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td class="td-title"><spring:message code="SM01.NGTrkAlarmPos"/></td>
                        <td ><input type="text" id="txtNGTrkAlarmPos" Width="30%" onkeypress="fn_NumKey()" /></td>
                        <td class="td-title"></td>
                        <td></td>
                    </tr>
            </table>
        </div>
        <div align="center">
        	<c:set var="btnSave"><spring:message code="BUTTON.Save"/></c:set>
			<input type="button" id="btnSave" value="${btnSave}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button" >
			
			<c:set var="btnModify"><spring:message code="BUTTON.Modify"/></c:set>
			<input type="button" id="btnModify" value="${btnModify}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button" >
			
			<c:set var="btnDelete"><spring:message code="BUTTON.Delete"/></c:set>
			<input type="button" id="btnDelete" value="${btnDelete}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button" >
			
			<c:set var="btnReset"><spring:message code="BUTTON.Reset"/></c:set>
			<input type="button" id="btnReset" value="${btnReset}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button" >
			
			<c:set var="btnClose"><spring:message code="BUTTON.Close"/></c:set>
			<input type="button" id="btnClose" value="${btnClose}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button" >
        </div>
        <div>
            <div style='display:inline;' id="divMessage" class="font-red"></div>
        </div>
    </div>
    </form>
</body>
</html>
