<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8"> 
	<title>chart-1</title>
	<jsp:include page="../head.jsp" flush="false" />
</head>
<body>
<jsp:include page="../menu.jsp" flush="false" />
<div class="container">
	<div id="chart"></div>
</div>
<script>
$(document).ready(function(){
	var chart = c3.generate({
		bindto: '#chart',
	    data: {
	        columns: [
	            ['data1', 0, 0, 0, 0, 0, 0],
	            ['data2', 0, 0, 0, 0, 0, 0]
	        ],
	        type: 'bar'
	    },
	    bar: {
	        width: {
	            ratio: 0.5 // this makes bar width 50% of length between ticks
	        }
	        // or
	        //width: 100 // this makes bar width 100px
	    }
	});
	
	$.get("/api/chart/chart-1", function(data){
		
		if(data.result == 200){
	
			var data1 = ['data1'];
			var data2 = ['data2'];
			
			data.list.forEach(function(item){
				
				data1.push(item.data1);
				data2.push(item.data2);
			});
			
			chart.load({
		        columns: [
		            data1,
		            data2
		        ]
		    });
			
		}
	
	});

});
</script>
</body>
</html>
