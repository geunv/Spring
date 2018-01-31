<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8"> 
	<title>Line Chart</title>
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

        /* $('#dateRangePicker').datepicker({
        	
        }); */
       
       
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
        
		/* $("#txtFromDate").val(fn_getday('2017-05-29'));
		$("#txtToDate").val(fn_getday('2017-05-30')); */
		
		$("#txtFromDate").val(fn_getday());
		$("#txtToDate").val(fn_getday());
		
		
		init();
		
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
    
    //function myFunction(){
    //	document.getElementById("load-image").style.display = 'none';
    //}
    
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
     	
    	var oldData = "";
    	if ( $('#chkSelOldData').is(":checked") == true)
    		oldData = 'Y';
		else
			oldData = 'N';
    	
    	var params = "?plant_cd="+$.trim($('#ddlPlant').val())+
    				 "&from_dt="+$.trim($('#txtFromDate').val()+":"+ $("#txtFromTime").val())+
    				 "&to_dt="+$.trim($('#txtToDate').val() + ":"+ $("#txtToTime").val())+
    				 "&display_type="+$.trim($('#ddldisplayType').val())+
    				 "&tool="+$.trim($('#ddlTool').val())+
    				 "&old_data="+oldData;
    	
    	
    	var body_no = ['x'];
		var tor_value = ['TORQUE'];
		var tor_high = [];
		var tor_ok = [];
		var tor_low = [];
		
		var ang_value = ['ANGLE'];
		var ang_high = [];
		var ang_ok = [];
		var ang_low = [];
		
		
		var tmp_tor_arr = [];
		var maxTor = "";
		var centerTor = "";
    	var minTor = "";
    	
		//$.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
		
		var torCnt;
		$.ajax({
			type : "GET",
			url : '/api/chart/getchartline'+params,
			beforeSend : function(){
				$('#load-image').show();
			}
		}).success(function(data) {
			if(data.result == 200){
	    		
    			torCnt = data.valuelist.length;
    			data.valuelist.forEach(function(item){
    				body_no.push(item.body_no);
    				tor_value.push(item.tor);
    				ang_value.push(item.ang)
    				tmp_tor_arr.push(Number(item.tor));
    			});
    			
    			tor_high.push(data.standardlist.torque_high);
    			tor_ok.push(data.standardlist.torque_ok);
    			tor_low.push(data.standardlist.torque_low);
    			
    			ang_high.push(data.standardlist.angle_high);
    			ang_ok.push(data.standardlist.angle_ok);
    			ang_low.push(data.standardlist.angle_low);
    			
    			maxTor = data.standardlist.torque_high;
    			centerTor = data.standardlist.torque_ok;
    			minTor = data.standardlist.torque_low;
    		}
			
		}).error(function(data) {
			$('#load-image').hide();
			console.log("Error-"+data);
			//alert(data);
		}).complete(function(data){
			$('#load-image').hide();
			
			if ( tmp_tor_arr.length > 0 ){
		    	var valuemax = tmp_tor_arr.reduce(function(a, b) {
		    	    return Math.max(a, b);
		    	});
		    	
		    	var valuemin = tmp_tor_arr.reduce(function(a, b) {
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
				transition: {
					  duration: 100
				},
				padding: {
			        right: 100
				},
			    data: {
			        x : 'x',
			        columns: [
						body_no,
						tor_value
			        ],
			        type: 'line',
			        labels: true,
			    },
			    legend: {
			        position: 'right'
			    },
			    axis: {
			        x: {
			            type: 'category' // this needed to load string x value
			        }
			    	,
			    	y:{
			    		//center : Number(centerTor)
			    		max:chart1Max,
			    		min:chart1Min
			    	}
			    },
			    /* color: {
			        //pattern: [ '#d62728','#1f77b4', '#2ca02c', '#98df8a', '#d62728', '#ff9896', '#9467bd', '#c5b0d5', '#8c564b', '#c49c94', '#e377c2', '#f7b6d2', '#7f7f7f', '#c7c7c7', '#bcbd22', '#dbdb8d', '#17becf', '#9edae5']
			    	pattern: [ '#336699']
			    }, */
			    grid: {
			    	  y: {
			    	    lines: [{value: tor_high,class:'standHigh' , text: 'H='+tor_high}
			    	    		,{value: tor_ok,class:'standOk' , text: 'OK='+tor_ok}
			    	    		,{value: tor_low,class:'standLow' , text: 'L='+tor_low}]

			    	  }
			    }

			}); // chart1
	    	
	    	var barchart2 = c3.generate({
				bindto: '#linechart2',
				padding: {
			        right: 100
				},
			    data: {
			        x : 'x',
			        columns: [
						body_no,
						ang_value
			        ],
			        type: 'line',
			        labels: true,
			    },
			    legend: {
			        position: 'right'
			    },
			    axis: {
			        x: {
			            type: 'category' // this needed to load string x value
			        }
				    ,
			    	y:{
			    		max:400
			    	}
			    },
			    color: {
			        //pattern: [ '#d62728','#1f77b4', '#2ca02c', '#98df8a', '#d62728', '#ff9896', '#9467bd', '#c5b0d5', '#8c564b', '#c49c94', '#e377c2', '#f7b6d2', '#7f7f7f', '#c7c7c7', '#bcbd22', '#dbdb8d', '#17becf', '#9edae5']
			    	pattern: [ '#003399']
			    },
			    grid: {
			    	  y: {
			    	    lines:  [{value: ang_high,class:'standHigh' , text: 'H='+ang_high}
			    	    		,{value: ang_ok,class:'standOk' , text: 'OK='+ang_ok}
			    	    		,{value: ang_low,class:'standLow' , text: 'L='+ang_low}]

			    	  }
			    }
			});	//char2;
		
		});	//ajax complete end;
    	
    	
    	
    }
   
</script>
<div class="container">
	<div id="C_Body">       
        		<div id="C_Title">
            <div id="content-title">
                <i class="fa fa-line-chart"></i><spring:message code="SCREEN.CT01" /> 
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
                                <td width="25%" class="left_5"><select id="ddlPlant"></select>
                                </td>
                                <td width="5%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Date" />
                                </td>
                                <td width="50%" class="left_5" colspan="3">
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
                                <td height="30"></td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Type" />
                                </td>
                                <td class="left_5"><select id="ddldisplayType">
                                					<option value="V">Value</option>
                                					<option value="A">Average</option>
                                					</select>
                                </td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Tool" />
                                </td>
                                <td class="left_5" colspan="2"><select id="ddlTool"></select>
								</select>
                                 </td>
                            </tr>
                        </tbody></table>
                    </td>
                </tr>
            </tbody></table>
        </div>
        <input type="hidden" id="T_HIGH">
        <input type="hidden" id="T_OK">
        <input type="hidden" id="T_LOW">
        <input type="hidden" id="A_HIGH">
        <input type="hidden" id="A_OK">
        <input type="hidden" id="A_LOW">
        
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
