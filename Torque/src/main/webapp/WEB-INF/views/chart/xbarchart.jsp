<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8"> 
	<title>X Bar-R Chart</title>
	<jsp:include page="../head.jsp" flush="false" />
	<script src="/WebCommon/scripts/mask.js" type="text/javascript"></script>
	<style type="text/css">

/* ,'#00008B', '#006400', '#8B0000' */
	.c3-ygrid-line.standHigh line {
	    stroke: #00008B;
	}
	.c3-ygrid-line.standHigh text {
	    fill: #00008B;
	}
	.c3-ygrid-line.standOk line {
	    stroke: #006400;
	}
	.c3-ygrid-line.standOk text {
	    fill: #006400;
	}
	.c3-ygrid-line.standLow line {
	    stroke: #8B0000;
	}
	.c3-ygrid-line.standLow text {
	    fill: #8B0000;
	}
	
	</style>
	
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
            altField: '#hdToDate.ClientID',
            onClose: function(selectedDate) {
                $("#txtFromDate").datepicker("option", "maxDate", selectedDate);
            }
        });
        
        if ($("#hdFromDate").val().length > 0) {
            $("#txtFromDate").datepicker("setDate", new Date($("#hdFromDate").attr("Value")));
        } 
        if ($("#hdToDate").val().length > 0) {
            $("#txtToDate").datepicker("setDate", new Date($("#hdToDate").attr("Value")));
        }
		
		$('#txtFromTime').mask("99:99:99");
		$('#txtToTime').mask("99:99:99");
        
		/* $("#txtFromDate").val(fn_getday('2017-07-04'));
		$("#txtToDate").val(fn_getday('2017-07-04')); */
		
		$("#txtFromDate").val(fn_getday());
		$("#txtToDate").val(fn_getday());
		
		init();
		//getChart();
		
		$("#btnSearch").on('click', function(e){
			getChart();
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
    });
	
    $( window ).on( "load", function() {
    	getChart();
    });
    
    function init(){
		$.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
		getTime();
    	getPlant();
    	ddlTool();
		$.ajaxSetup({async:true});	//비동기 켜기
    }

    function getTime(){
    	var str = '1';
    	
    	var params = "?code="+str;
    	$.get('/api/common/getshifttime'+params,function(data){
    		var startTime = data;
    		var hour = data.substr(0,2);
    		var min = data.substr(2,2);
    		var sec = data.substr(4,2);
    		
    		$('#txtFromTime').val(pad(hour,2) + ":" + pad(min,2) + ":" + pad(sec,2));
    		//console.log(pad(hour,2) + ":" + pad(min,2) + ":" + pad(sec,2));
    	});
    	
    	$('#txtToTime').val(fn_nowtime());
    	//return shiftStartTime;
    }
    
    function ddlTool(){
    	getToolId('',$('#ddlPlant').val(),'-1','N','-1','W');
    }
    
    
    function getChart(){
    	
     	var plant_cd = $('#ddlPlant').val();
    	var from_dt = $('#txtFromDate').val()+":"+ $("#txtFromTime").val();
    	var to_dt = $('#txtToDate').val() + ":"+ $("#txtToTime").val();
    	var tool = $('#ddlTool').val();
    	var grp_size = $('#ddlGrpSize').val();
    	var data_gbn = $('#ddlType').val();
    	
    	var oldData = "";
    	if ( $('#chkSelOldData').is(":checked") == true)
    		oldData = 'Y';
		else
			oldData = 'N';
    	
    	
    	var params = "?plant_cd="+ $.trim(plant_cd)+
    				 "&from_dt="+ $.trim(from_dt)+
    				 "&to_dt="+ $.trim(to_dt)+
    				 "&tool="+$.trim(tool)+
    				 "&grp_size="+$.trim(grp_size)+
    				 "&data_gbn="+$.trim(data_gbn)+		 
    				 "&old_data="+oldData;
    	
    	var var_x_chart = ['X-Bar Chart'];
    	var var_r_chart = ['R Chart']
		var tor_value = ['TOR'];
		var tor_high = [];
		var tor_ok = [];
		var tor_low = [];
		
		var ang_value = ['ANG'];
		var ang_high = [];
		var ang_ok = [];
		var ang_low = [];
		
		var maxTor = "";
		var centerTor = "";
    	var minTor = "";
    	
		var tmp_x_arr= [];
    	
    	
    	
		//$.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
		
		var torCnt;
		
/*     	
		$.get('/api/chart/getchartxbarr'+params,function(data){
    		if(data.result == 200){
    		
    			var xindex = data.xchart.length;
    			$.each(data.xchart,function(xindex,item){
    				var_x_chart.push(item);
    				tmp_x_arr.push(Number(item));
    			}); 
    			
    			var rindex = data.rchart.length;
    			$.each(data.rchart,function(rindex,item){
    				var_r_chart.push(item);
    			});
    			
    			tor_high.push(data.standardvalue.torque_high);
    			tor_ok.push(data.standardvalue.torque_ok);
    			tor_low.push(data.standardvalue.torque_low);
    			
    			ang_high.push(data.standardvalue.angle_high);
    			ang_ok.push(data.standardvalue.angle_ok);
    			ang_low.push(data.standardvalue.angle_low);
    			
    			maxTor = data.standardvalue.torque_high;
    			centerTor = data.standardvalue.torque_ok;
    			minTor = data.standardvalue.torque_low;
    		}
    	});
 */	
 
		$.ajax({
			type : "GET",
			url : '/api/chart/getchartxbarr'+params,
			beforeSend : function(){
				$('#load-image').show();
			}
		}).success(function(data) {
			if(data.result == 200){
	    		
    			var xindex = data.xchart.length;
    			$.each(data.xchart,function(xindex,item){
    				var_x_chart.push(item);
    				tmp_x_arr.push(Number(item));
    			}); 
    			
    			var rindex = data.rchart.length;
    			$.each(data.rchart,function(rindex,item){
    				var_r_chart.push(item);
    			});
    			
    			tor_high.push(data.standardvalue.torque_high);
    			tor_ok.push(data.standardvalue.torque_ok);
    			tor_low.push(data.standardvalue.torque_low);
    			
    			ang_high.push(data.standardvalue.angle_high);
    			ang_ok.push(data.standardvalue.angle_ok);
    			ang_low.push(data.standardvalue.angle_low);
    			
    			maxTor = data.standardvalue.torque_high;
    			centerTor = data.standardvalue.torque_ok;
    			minTor = data.standardvalue.torque_low;
    		}
				
		}).error(function(data) {
			$('#load-image').hide();
			console.log("Error-"+data);
				//alert(data);
		}).complete(function(data){
			$('#load-image').hide();
			
			if (tmp_x_arr.length > 0){
		    	var valuemax = tmp_x_arr.reduce(function(a, b) {
		    	    return Math.max(a, b);
		    	});
		    	
		    	var valuemin = tmp_x_arr.reduce(function(a, b) {
		    	    return Math.min(a, b);
		    	});
	    	}
	    	
	    	var chart1Max = "";
	    	var chart1Min = "";
	    	
	    	if ( valuemax > maxTor )
	    		chart1Max = Number(valuemax);
	    	else
	    		chart1Max = Number(maxTor) + Number(10);
	    	
	    	if ( valuemin < minTor )
	    		chart1Min = Number(valuemin);
	    	else
	    		chart1Min = Number(minTor) - Number(10);
	    	
	    	var barchart1 = c3.generate({
				bindto: '#linechart1',
				padding: {
				        right: 100
				},
			    data: {
			        columns: [
						var_x_chart,
			        ],
			        type: 'line',
			        labels: true,
			    },
			    axis: {
			    	y:{
			    		//center : Number(centerTor)
			    		max:chart1Max,
			    		min:chart1Min
			    	}
			    },
			    legend: {
			        position: 'right'
			    },
			    color: {
			        //pattern: [ '#d62728','#1f77b4', '#2ca02c', '#98df8a', '#d62728', '#ff9896', '#9467bd', '#c5b0d5', '#8c564b', '#c49c94', '#e377c2', '#f7b6d2', '#7f7f7f', '#c7c7c7', '#bcbd22', '#dbdb8d', '#17becf', '#9edae5']
			    	pattern: [ '#336699']
			    },
			    grid: {
			    	  y: {
			    	    lines: [{value: tor_high,class:'standHigh' , text: 'H='+tor_high}
			    	    		,{value: tor_ok,class:'standOk' , text: 'OK='+tor_ok}
			    	    		,{value: tor_low,class:'standLow' , text: 'L='+tor_low}]

			    	  }
			    }

			}); 
	    	
	    	var barchart2 = c3.generate({
				bindto: '#linechart2',
				padding: {
			        right: 100
				},
			    data: {
			        columns: [
						var_r_chart,
			        ],
			        type: 'line',
			        labels: true,
			    },
			    axis: {
			        
			    	y:{
			    		center: 1,
			    	}
			    },
			    legend: {
			        position: 'right'
			    },
			    color: {
			        //pattern: [ '#d62728','#1f77b4', '#2ca02c', '#98df8a', '#d62728', '#ff9896', '#9467bd', '#c5b0d5', '#8c564b', '#c49c94', '#e377c2', '#f7b6d2', '#7f7f7f', '#c7c7c7', '#bcbd22', '#dbdb8d', '#17becf', '#9edae5']
			    	pattern: [ '#003399']
			    } ,
			    grid: {
			    	  y: {
			    	    lines:  [{value: 1,class:'standHigh' , text: ''}]

			    	  }
			    }
			}); 
		});
	
    	
    }
     
   
</script>
<div class="container">
	<div id="C_Body">       
        		<div id="C_Title">
            <div id="content-title">
                <i class="fa fa-line-chart"></i><spring:message code="SCREEN.CT03" /> 
            </div>
            <div id="content-title-nav">
                <i class="fa fa-angle-double-right"></i><spring:message code="MENU.CHART" /> 
            </div>
            <div id="content-title-bar">
            </div>  
        </div>
        <div id="C_Search">
            <table cellpadding="1" cellspacing="1" border="0" class="search_table">
                <tbody><tr>
                    <td height="70">
                        <table width="100%">
                            <tbody><tr>
                                <td width="1%" height="30"></td>
                                <td width="5%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Plant" />
                                </td>
                                <td width="20%" class="left_5"><select id="ddlPlant"></select>
                                </td>
                                <td width="8%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Date" />
                                </td>
                                <td width="40%" class="left_5" colspan="3">
                                    <input type="text" id="txtFromDate" readonly="true" style="width:85px;" >
                                    <input type="text" id="txtFromTime" style="width:65px;" maxlength="8" autocomplete="off">
                                     ~
                                    <input type="text" id="txtToDate" readonly="true" style="width:85px;" >
                                    <input type="text" id="txtToTime" style="width:65px;" maxlength="8" autocomplete="off">
                                    <input type="hidden" id="hdFromDate" />
                                    <input type="hidden" id="hdToDate"  />
                                    <input type="hidden" id="shiftTime" />
                                    &nbsp;
                                    <input id="chkSelOldData" type="checkbox" name="chkSelOldData"><spring:message code="CT01.SearchOldData"/>
                                </td>
                                <td rowspan="2" class="content-button">
                                	<img src="/images/ajax-loader.gif" style="display:none;" id="load-image"/>
                                    <input type="button" name="btnSearch" value="Search" id="btnSearch" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                </td>
                            </tr>
                            <tr>
                                <td height="30" ></td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Tool"/><!-- <asp:Label ID="lblTool" runat="server" Text="COMMON.Tool"></asp:Label> -->
                                </td>
                                <td class="left_5" >
                                	<select id="ddlTool"></select>
                                    <!-- <asp:DropDownList ID="ddlTool" runat="server" AutoPostBack="true"
                                        onselectedindexchanged="ddlTool_SelectedIndexChanged" ></asp:DropDownList> -->
                                 </td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.GrpSize"/><!-- <asp:Label ID="lblType" runat="server" Text="COMMON.GrpSize"></asp:Label> -->
                                </td>
                                <td class="left_5" colspan="2">
                                	<select id="ddlGrpSize">
                                		<option value="5">5</option>
                                		<option value="10">10</option>
                                		<option value="50">50</option>
                                		<option value="100">100</option>
                                		<option value="500">500</option>
                                		<option value="1000">1000</option>
                                	</select>
                                	<select id="ddlType">
                                		<option value="T">Torque</option>
                                		<option value="A">Angle</option>
                                	</select>
                                    <!-- <asp:DropDownList ID="ddlGrpSize" runat="server" AutoPostBack="true"
                                        onselectedindexchanged="ddlGrpSize_SelectedIndexChanged"  ></asp:DropDownList> -->
                                    <!-- <asp:DropDownList ID="ddlType" runat="server" AutoPostBack="true" 
                                        onselectedindexchanged="ddlType_SelectedIndexChanged">
                                        <asp:ListItem Text="Torque" Value="T" ></asp:ListItem>
                                        <asp:ListItem Text="Angle" Value="A" ></asp:ListItem>
                                    </asp:DropDownList> -->
                                </td>
                            </tr>
                        </tbody></table>
                    </td>
                </tr>
            </tbody></table>
        </div>
        
        
        <div id="C_Result" style="overflow:auto;">
			<div class="main_panel">
				<div id="linechart1"></div>
				<!-- <div style="padding-bottom:20px;height:0px;"></div> -->
				<div id="linechart2"></div>
			</div>
        </div><!-- C_Result -->  
	</div><!-- C_Body -->
</div>
<jsp:include page="../bottom.jsp" flush="false" />
</body>
</html>
