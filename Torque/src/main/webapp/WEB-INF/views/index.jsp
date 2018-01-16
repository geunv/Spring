<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8"> 
	<title>index</title>
	<jsp:include page="head.jsp" flush="false" />
	<style type="text/css">
	.main_panel {
	    border: 1.5px dashed #BDBDBD;
	    border-radius: 10px;
	}
	</style>
</head>
<body>
<jsp:include page="menu.jsp" flush="false" />
<div class="container">
	<div id="M_Body">
		<!-- LEFT -->
		<div style="float:left;width:59%;height:400px;">
			<h4 class="text-left"><i class="fa fa-check-square"></i> <spring:message code="MAIN.ToolConnection"/><!-- <span id="ctl00_ContentPlaceHolder1_lblToolConnection">Tool  Connection</span> --></h4>
			<div class="main_panel">
            <div style="height:350px;">
                <div style="float:left;padding-top:15px;padding-left: 10px;padding-bottom:10px;width:60%;height:350px;border:1px;">
                	<div id="chart"></div>
                </div>
                <div style="float:left;padding-top:10px;padding-left:20px;padding-right:20px;padding-bottom:10px;width:40%;">
                    <div class="total_count">
                        [ <spring:message code="MAIN.DisconnToolList"/> :
                        <div style='display:inline;' id="conn_ng"></div>/<div style='display:inline;' id="status_total"></div></span>
                         ]
                    </div>
                    <div style="width:100%;height:300px;overflow:auto">
                        <div>
							<table class="gridview" cellspacing="0" border="0" id="ctl00_ContentPlaceHolder1_gridView1" style="border-collapse:collapse;">
								<thead>
									<tr>
										<th scope="col" style="width:25%;"><div align="center"><spring:message code="COMMON.Tool"/></div></th><th class="left_5" scope="col" style="width:75%;"><div align="center"><spring:message code="ST01.ToolName"/></div></th>
									</tr>
								</thead>
								<tbody id="disconnected_toollist">
								</tbody>
							</table>
						</div>
                    </div>
                </div>
           	</div>
           	</div>		
		</div>
		<!-- &nbsp -->
		<div style="float:left;width:2%;">&nbsp;</div>
		<!-- RIGHT -->
		<div style="float:left;width:39%;">
	        <h4 class="text-left"><i class="fa fa-check-square"></i> <spring:message code="MAIN.RepairConnection"/><!-- <span id="ctl00_ContentPlaceHolder1_lblRepairConnection">Repair Connection</span> --></h4>
	        <div class="main_panel">
	            <div style="float:right;padding-right:20px;height:30px;padding-top:10px;">
	                <img src="./images/conn_ok.png">
	                <spring:message code="COMMON.Connected"/>
	                <!-- <span id="ctl00_ContentPlaceHolder1_lblConnected" style="vertical-align:middle;">Connected</span> --> &nbsp;
	                <img src="./images/conn_ng.png">
	                <spring:message code="COMMON.Disconnected"/>
	                <!-- <span id="ctl00_ContentPlaceHolder1_lblDisconnected" style="vertical-align:middle;">Disconnected</span> -->
	            </div>
	            <div style="width:100%;height:350px;text-align:center;padding-left:15px;padding-right:15px;padding-bottom:10px;">
	                <table width="100%" style="border:1px solid steelblue;">
	                    <tbody><tr>
	                        <td width="40%" height="30" style="text-align:center;font-weight:bold;color:White;background-image:url('/images/bg_gridheader_3.png');">
	                        	<spring:message code="COMMON.Line"/>
	                            <!-- <span id="ctl00_ContentPlaceHolder1_lblLine">Line</span> -->
	                        </td>
	                        <td width="30%" style="text-align:center;font-weight:bold;color:White;background-image:url('/images/bg_gridheader_3.png');">
	                        	<spring:message code="COMMON.Program"/>
	                            <!-- <span id="ctl00_ContentPlaceHolder1_lblProgram">Program</span> -->
	                        </td>
	                        <td width="30%" style="text-align:center;font-weight:bold;color:White;background-image:url('/images/bg_gridheader_3.png');">
	                        	<spring:message code="COMMON.Tool"/>
	                            <!-- <span id="ctl00_ContentPlaceHolder1_lblTool">Tool</span> -->
	                        </td>
	                    </tr>
	                </tbody></table>
	                <div style="width:100%;height:280px;overflow:auto" id="repairList">
	                </div>
	            </div>
					        
	        </div>
	    </div>
		<!-- bottom graph  -->	
		<div style="float:left;width:100%;height:400px;">
	        <h4 class="text-left"><i class="fa fa-check-square"></i> <spring:message code="COMMON.TighteningResult"/></h4>
	        <div class="main_panel">
	            <div style="padding-top:20px;padding-bottom:10px;height:350px;">
	            	<div style="float:left;width:49%;/* border:1px solid red; */">
	            		<div id="barchart1"></div>
					</div>
	            	<div style="float:left;width:2%;">&nbsp;</div>
	            	<div style="float:left;width:49%;">
	            		<div id="barchart2"></div>
	            	</div>
	            </div>
	        </div>
	    </div>
	</div>
</div>
<jsp:include page="bottom.jsp" flush="false" />

<script>
 
var okCnt = ['Connection'];
var ngCnt = ['Disconnection'];

$(document).ready(function(){

	$.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
	getDisconnectedToolList();
	
	$.ajaxSetup({async:true});	//비동기 켜기
	
	var chart = c3.generate({
		bindto: '#chart',
		data: {
	        // iris data from R
	        columns: [
	            ['Connection', 0],
	            ['Disconnection', 0],
	        ],
	        /* type : 'pie', */
	        type : 'donut',
	        onclick: function (d, i) { console.log("onclick", d, i); },
	        onmouseover: function (d, i) { console.log("onmouseover", d, i); },
	        onmouseout: function (d, i) { console.log("onmouseout", d, i); }
	    }
		,color: {
	        pattern: ['#1f77b4', '#d62728', '#2ca02c', '#98df8a', '#d62728', '#ff9896', '#9467bd', '#c5b0d5', '#8c564b', '#c49c94', '#e377c2', '#f7b6d2', '#7f7f7f', '#c7c7c7', '#bcbd22', '#dbdb8d', '#17becf', '#9edae5']
	    }
	});

	
	
	
	//setTimeout(function () {
		chart.load({
			columns: [
		  		okCnt,
		  	    ngCnt
			]
		});

	//},100);
	
	
	getRepairToolConnStatus()
	
	barchart()
});

/* function loadChart1(){
	chart.load({
		columns: [
	  		okCnt,
	  	    ngCnt
		]
	});
} */

function getDisconnectedToolList(){
	$.get('/api/getdisconnectedtoollist', function(data){
		$('#disconnected_toollist').empty();
		
		/* 
		data.statuslist.forEach(function(em){
			alert(em.TOTAL_TOOL_CNT);
			//console.log(em.TOTAL_TOOL_CNT +'/' + em.CONN_OK + '/' + em.CONN_NG);
		}); */
		$('#status_total').text(data.statuslist.total_TOOL_CNT);
		$('#conn_ng').text(data.statuslist.conn_NG);		
		
		okCnt.push(data.statuslist.conn_OK);
		ngCnt.push(data.statuslist.conn_NG);
		
		data.list.forEach(function(item){
			//console.log(item);
			$('#disconnected_toollist').append(
					'<tr>'
					+' <td> ' + item.device_id + '</td>'
					+' <td class="left_5"> ' + item.dev_nm + '</td>'
					+'</tr>'
			);
		});
	});
}

function getRepairToolConnStatus(){
	$.get('/api/getrepairtoolconnstatus', function(data){
		$('#repairList').empty();
		
		/* 
		<table width="100%" style="background-color:white;border-spacing: 1px;border-collapse: separate;border:1px solid #6799FF;">
        <tbody><tr>
            <td width="40%" height="30" style="text-align:center;background-color:#A7C4E4;color:#2C5481;font-weight:bold">T119 KEEPER T1-1                                  </td>
            <td width="30%" style="text-align:center;background-color:#F6F7F9;"><img src="/WebCommon/Images/conn_ng.png"></td>
            <td width="30%" style="text-align:center;background-color:#F6F7F9;"><img src="/WebCommon/Images/conn_ng.png"></td>
        </tr>
    	</tbody>
    	</table> 
    	*/
    	
    	data.list.forEach(function(item){
    		var imgok = '<img src="/images/conn_ok.png">';
    		var imgng = '<img src="/images/conn_ng.png">';
    		
    		if (item.pgm_STATUS == '1')
    			item.pgm_STATUS = imgok;
    		else (item.pgm_STATUS == '0')
    			item.pgm_STATUS = imgng;
    		
    		if (item.tool_STATUS == 'Y')
    			item.tool_STATUS = imgok;
    		else if (item.tool_STATUS == 'N')
    			item.tool_STATUS = imgng;
    			
    		$('#repairList').append(
    				'<table width="100%" style="background-color:white;border-spacing: 1px;border-collapse: separate;border:1px solid #6799FF;">'
    				+ '<td width="40%" height="30" style="text-align:center;background-color:#A7C4E4;color:#2C5481;font-weight:bold">'+item.device_NM+'</td>'
    				
    				+ '<td width="30%" style="text-align:center;background-color:#F6F7F9;">'+ item.pgm_STATUS +'</td>'
    	            + '<td width="30%" style="text-align:center;background-color:#F6F7F9;">'+ item.tool_STATUS +'</td>'
    				)
    	});
	});
}

function barchart(){
	
	$.get('/api/getThighteningResult', function(data){
		if(data.result == 200){
			
			var barchart1 = c3.generate({
				bindto: '#barchart1',
			    data: {
			        x : 'x',
			        columns: [
			            ['x', 'yesterday'],
			            ['OK', data.list[0].ok],
			            ['NG', data.list[0].ng],
			            ['NOSCAN', data.list[0].noscan],
			            ['REPAIR', data.list[0].repair],
			            ['INTERLOCK', data.list[0].interlock],
			        ],
			        type: 'bar',
			        labels: true,
			        order: null
			    },
				/* onrendered: function() {
			    	setTimeout(function() {
			        	[0].forEach(function(e) {
			        		barchart1.tooltip.show({
			              		x: e
			            	})
			            	var tooltip = $(".c3-tooltip-container").clone(true).removeClass("c3-tooltip-container").addClass("c3-tooltip-tmp");
			            	var tooltip = $(".c3-tooltip-container").clone(true).removeClass("c3-tooltip-container");
			            	tooltip.appendTo("#barchart1")
			          	})
						$(".c3-tooltip-tmp").show()
					}, 0);
				}, */
				onmouseover: function() {
					setTimeout(function() {
						barchart1.tooltip.hide();
					},0);
				},
			    axis: {
			        x: {
			            type: 'category' // this needed to load string x value
			        }
			    },
			    color: {
			        pattern: ['#1f77b4', '#d62728', '#2ca02c', '#98df8a', '#d62728', '#ff9896', '#9467bd', '#c5b0d5', '#8c564b', '#c49c94', '#e377c2', '#f7b6d2', '#7f7f7f', '#c7c7c7', '#bcbd22', '#dbdb8d', '#17becf', '#9edae5']
			    },
			     grid:{
			        focus:{
			        show:false
			      }
			    }
			    
			});
			
			/* t_day = data.list[1].day
			t_TotalCnt = data.list[1].total
			t_OkCnt = data.list[1].ok
			t_NgCnt = data.list[1].ng
			t_NoScanCnt = data.list[1].noscan
			t_RepairCnt = data.list[1].repair
			t_InterlockCnt = data.list[1].interlock */
			
			
			var barchart2 = c3.generate({
				bindto: '#barchart2',
				data: {
			        x : 'x',
			        columns: [
			            ['x', 'today'],
			            ['OK', data.list[1].ok],
			            ['NG', data.list[1].ng],
			            ['NOSCAN', data.list[1].noscan],
			            ['REPAIR', data.list[1].repair],
			            ['INTERLOCK', data.list[1].interlock],
			        ],
			        type: 'bar',
			        labels: true,
			        order: null
			    },
				/* onrendered: function() {
			    	setTimeout(function() {
			        	[0].forEach(function(e) {
			        		barchart2.tooltip.show({
			              		x: e
			            	})
			            	var tooltip = $(".c3-tooltip-container").clone(true).removeClass("c3-tooltip-container").addClass("c3-tooltip-tmp");
			            	var tooltip = $(".c3-tooltip-container").clone(true).removeClass("c3-tooltip-container");
			            	tooltip.appendTo("#barchart2")
			          	})
						$(".c3-tooltip-tmp").show()
					}, 0);
				}, */
			    axis: {
			        x: {
			            type: 'category' // this needed to load string x value
			        }
			    },
			    color: {
			        pattern: ['#1f77b4', '#d62728', '#2ca02c', '#98df8a', '#d62728', '#ff9896', '#9467bd', '#c5b0d5', '#8c564b', '#c49c94', '#e377c2', '#f7b6d2', '#7f7f7f', '#c7c7c7', '#bcbd22', '#dbdb8d', '#17becf', '#9edae5']
			    },
			    grid:{
			        focus:{
			        show:false
			      }
			    }
			    
			});
			
		}
	});
	
	
}


</script>
</body>
</html>

