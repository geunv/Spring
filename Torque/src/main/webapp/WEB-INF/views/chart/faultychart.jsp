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
	<script src="/WebCommon/scripts/mask.js" type="text/javascript"></script>

</head>
<body>
<jsp:include page="../menu.jsp" flush="false" />

<script type="text/javascript">
    $(document).ready(function() {
        $("#btnSearch").button();
       
	    
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
    
    function init(){
		$.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
		getPlant();
    	getTime();
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
    	var displayType = $('#ddlType').val();
    	
    	var oldData = "";
    	if ( $('#chkSelOldData').is(":checked") == true)
    		oldData = 'Y';
		else
			oldData = 'N';
    	
    	
    	var params = "?plant_cd="+ $.trim(plant_cd) +
    				 "&from_dt="+ $.trim(from_dt) +
    				 "&to_dt="+ $.trim(to_dt) +
    				 "&display_type="+$.trim(displayType) +
    				 "&tool="+tool+
    				 "&old_data="+oldData;
		
		//$.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
		
		
		var xvalue = ['x'];
		var yvalue = ['Faulty'];
		
//    	$.get('/api/chart/getchartfaulty'+params,function(data){
//    		if(data.result == 200){
//    			data.list.forEach(function(item){
//    				xvalue.push(item.res_col);
//    				yvalue.push(item.per);
//    			});    			
//    		}
//    	});
		
    	
    	$.ajax({
			type : "GET",
			url : '/api/chart/getchartfaulty'+params,
			beforeSend : function(){
				$('#load-image').show();
			}
		}).success(function(data) {
			if(data.result == 200){
    			data.list.forEach(function(item){
    				xvalue.push(item.res_col);
    				yvalue.push(item.per);
    			});
    		}
			
		}).error(function(data) {
			$('#load-image').hide();
			console.log("Error-"+data);
			//alert(data);
		}).complete(function(data){
			$('#load-image').hide();
			
			var chart = c3.generate({
	    		bindto: '#linechart1',
	    		padding: {
			        right: 100
				},
	    	    data: {
	    	    	x : 'x',
	    	        columns: [
	    	            xvalue,
	    	            yvalue
	    	        ],
	    	        labels: true
	    	    },
			    axis: {
			        x: {
			            type: 'category' // this needed to load string x value
		            	/* type: 'timeseries',
		                tick: {
		                    format: '%Y-%m-%d'
		                } */
			        }
			    	,
			    	y:{
			    		
			            label: 'Faulty(%)',
			    		max:100
			    	}
			    },
			    legend: {
			        position: 'right'
			    },
			    color: {
			        //pattern: [ '#d62728','#1f77b4', '#2ca02c', '#98df8a', '#d62728', '#ff9896', '#9467bd', '#c5b0d5', '#8c564b', '#c49c94', '#e377c2', '#f7b6d2', '#7f7f7f', '#c7c7c7', '#bcbd22', '#dbdb8d', '#17becf', '#9edae5']
			    	pattern: [ '#1f77b4']
			    },
			    grid: {
			        x: {
			            show: true
			        },
			        y: {
			            show: true
			        }
			    }
	    	}); // chart end
			
		});//ajax end
    	
    }

   
</script>
<div class="container">
	<div id="C_Body">       
        <div id="C_Title">
            <div id="content-title">
                <i class="fa fa-line-chart"></i> <spring:message code="SCREEN.CT02"/><!-- <asp:Label ID="lblTitle" runat="server" Text="SCREEN.CT02"></asp:Label> -->
            </div>
            <div id="content-title-nav">
                <i class="fa fa-angle-double-right"></i> <spring:message code="MENU.CHART"/><!-- <asp:Label ID="lblMenuSystem" runat="server" Text="MENU.CHART"></asp:Label> -->
            </div>
            <div id="content-title-bar">
            </div>  
        </div> 
        <div id="C_Search">
            <table cellpadding="1" cellspacing="1" border="0" align="center" class="search_table">
                <tr>
                    <td height="70">
                        <table width="100%">
                            <tr>
                                <td width="1%" height="30" ></td>
                                <td width="5%" class="left_5" >
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Plant"/><!-- <asp:Label ID="lblPlant" runat="server" Text="COMMON.Plant"></asp:Label> -->
                                </td>
                                <td width="25%" class="left_5" >
                                	<select id="ddlPlant"></select>
                                </td>
                                <td width="5%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Date"/><!-- <asp:Label ID="lblDate" runat="server" Text="COMMON.Date"></asp:Label> -->
                                </td>
                                <td width="50%" class="left_5" colspan="3">
                                    <input type="text" id="txtFromDate" readonly="true" style="width:85px;" >
                                    <input type="text" id="txtFromTime" style="width:65px;" maxlength="8" autocomplete="off">
                                     ~
                                    <input type="text" id="txtToDate" readonly="true" style="width:85px;" >
                                    <input type="text" id="txtToTime" style="width:65px;" maxlength="8" autocomplete="off">
                                    <input type="hidden" id="hdFromDate" />
                                    <input type="hidden" id="hdToDate"  />
                                    &nbsp;
                                    <input id="chkSelOldData" type="checkbox" name="chkSelOldData" ><spring:message code="CT02.SearchOldData"/>
                                </td>
                                <td rowspan="2"  class="content-button">
                                	<img src="/images/ajax-loader.gif" style="display:none;" id="load-image"/>
                                    <input type="button" name="btnSearch" value="Search" id="btnSearch" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                </td>
                            </tr>
                            <tr>
                                <td height="30" ></td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Type"/><!-- <asp:Label ID="lblType" runat="server" Text="COMMON.Type"></asp:Label> -->
                                </td>
                                <td class="left_5">
                                	<select id="ddlType">
                                		<option value="M">Month</option>
                                		<option value="D">Day</option>
                                		<option value="H">Hour</option>
                                		<option value="C">CarType</option>
                                	</select>
                                    <!-- <asp:DropDownList ID="ddlType" runat="server" AutoPostBack="true"
                                        onselectedindexchanged="ddlType_SelectedIndexChanged"  ></asp:DropDownList> -->
                                </td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Tool"/><!-- <asp:Label ID="lblTool" runat="server" Text="COMMON.Tool"></asp:Label> -->
                                </td>
                                <td class="left_5" colspan="2">
                                	<select id="ddlTool"></select>
                                    <!-- <asp:DropDownList ID="ddlTool" runat="server" AutoPostBack="true"
                                        onselectedindexchanged="ddlTool_SelectedIndexChanged" ></asp:DropDownList> -->
                                 </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        
        <div id="C_Result" style="overflow:auto;">
			<div class="main_panel">
				<div id="linechart1"></div>
				<!-- <div style="padding-bottom:20px;height:0px;"></div> -->
				<!-- <div id="linechart2"></div> -->
			</div>
        </div><!-- C_Result -->  
	</div><!-- C_Body -->
</div>
<jsp:include page="../bottom.jsp" flush="false" />
</body>
</html>
