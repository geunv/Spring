<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
		<div style="float:left;width:59%;height:400px;">
			<h4 class="text-left"><i class="fa fa-check-square"></i> <span id="ctl00_ContentPlaceHolder1_lblToolConnection">Tool  Connection</span></h4>
			<div class="main_panel">
            <div style="height:350px;">
                <div style="float:left;padding-top:15px;padding-left: 10px;padding-bottom:10px;width:60%;height:350px;border:1px;">
                	<div id="chart"></div>
                </div>
                <div style="float:left;padding-top:10px;padding-left:20px;padding-right:20px;padding-bottom:10px;width:40%;">
                    <div class="total_count">
                        [ <span id="ctl00_ContentPlaceHolder1_lblDisconnToolList">Disconnected Tool List</span> :
                        <div style='display:inline;' id="conn_ng"></div>/<div style='display:inline;' id="status_total"></div></span>
                         ]
                    </div>
                    <div style="width:100%;height:300px;overflow:auto">
                        <div>
							<table class="gridview" cellspacing="0" border="0" id="ctl00_ContentPlaceHolder1_gridView1" style="border-collapse:collapse;">
								<thead>
								<tr>
									<th scope="col" style="width:25%;"><div align="center">Tool</div></th><th class="left_5" scope="col" style="width:75%;"><div align="center">Tool Name</div></th>
								</tr>
								<!-- <tr>
									<td>QTT001</td><td class="left_5">T110 TM MTG BRKT-RH</td>
								</tr>
								<tr class="even">
									<td>QBP001</td><td class="left_5">T133 Brake Pedal-LH</td>
								</tr> -->
								
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
	</div>
</div>
<script>
 
var okCnt = ['Connection'];
var ngCnt = ['Disconnection'];


$(document).ready(function(){

	getDisconnectedToolList();
	
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


	setTimeout(function () {
		chart.load({
			columns: [
		  		okCnt,
		  	    ngCnt
			]
		});
	},0);

	
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
		//okCnt.push(1);
		//ngCnt.push(9);
		
		
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
	

	/* chart.load({
		columns: [
	  		okCnt,
	  	    ngCnt
		]
	}); */
}
</script>
</body>
</html>

