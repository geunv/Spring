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
</head>
<body>
<jsp:include page="../menu.jsp" flush="false" />
<div class="container">
	<div class="form-inline">
		<div class="form-group">
		    <select>
		    	<option><spring:message code="search.all" /></option>
		    	<c:forEach var="item" items="${searchCondition}">
		    		<option value="${item.code}">${item.name}</option>
		    	</c:forEach>
		    </select> : 
		    <input type="text" class="form-control" id="searchText" placeholder="검색어를 입력하세요">
		    <button id="searchBtn" class="btn btn-default">Search</button>
		    <button id="excelBtn" class="btn btn-default">Excel</button>
		</div>
		<hr/>
	</div>
	<table class="table" id="list_table">
		<thead>
			<tr>
				<td>No.</td>
				<td>Title</td>
				<td>Content</td>
				<td>Item-1</td>
				<td>Item-2</td>
				<td>date</td>
			</tr>
		</thead>
		<tbody id="list_data">
		</tbody>
	</table>
	<div class="well">
		<div class="row">
		  <div class="col-md-6">
		  	PAGE 
		  	<select id="select_page_count">
	  		</select>
		  </div>
		  <div class="col-md-6">
		  	<div class="pull-right">
		  		SHOW 
		  		<select id="select_show_count">
		  			<option value="2">2</option>
		  			<option value="3" selected>3</option>
		  			<option value="5">5</option>
		  		</select>
		  	</div>
		  </div>
		</div>
	</div>
</div>
<script>
$(document).ready(function(){
	
	getList();
	
	$("#searchText").on('keydown', function(e){
		if(e.keyCode == 13){
			getList();
		}
	});
	
	$("#searchBtn").on('click', function(e){
		getList();
	});
	
	
	$('#excelBtn').on('click', function(){
		var link = document.createElement('a');
		link.download = '리스트.xls';
		link.href = Export(document.getElementById('list_table').outerHTML);
		link.click();
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

var now_page = 1;
var show_count = 3;

function getList(){
	
	var params = "&page=" + now_page + "&show_count=" + show_count;
	
	
	$.get('/api/result/list-1?search=' + $("#searchText").val() + params, function(data){
		//console.log(data);
		
		//page setting 
		$('#select_page_count').empty();
		
		for(var i = 1 ; i <= data.totalPage; i++){			
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
				+ '	<td>' + item.num +'</td>'
				+ '	<td>' + item.title +'</td>'
				+ '	<td>' + item.content +'</td>'
				+ '	<td>' + item.item1 +'</td>'
				+ '	<td>' + item.item2 +'</td>'
				+ '	<td>' + item.insert_dt +'</td>'
				+ '</tr>'
			);
		});
	});
}


</script>
</body>
</html>
