<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%
	HttpSession my_session = request.getSession();
	String selected_lang = (String)my_session.getAttribute("LANG");
%>
<%=selected_lang.trim()%>
<footer>
	<div>       Copyright 2015 KIA KMM. All right reserved. &nbsp;
    <select id="ddlLanguage">
		<option value="lo">Spanish</option>
		<option value="en">English</option>
		<option value="ko">Korean</option>
	</select>
	</div>
<script>

	$(document).ready(function(){

		$('#ddlLanguage').val('<%=selected_lang%>');
		
		 $('#ddlLanguage').on('change', function(){
			
			 changLang();
	 		
	 	});
	});

function changLang(){ 
	var body = {   
			lang: $('#ddlLanguage').val() 
	}

	
 	$.ajax({
		type : "POST",
		url : '/api/changeLanguage',
		data : JSON.stringify(body),
		headers: { 
			'Accept': 'application/json',
			'Content-Type': 'application/json' 
		},
		beforeSend : function(){
			$('#load-image').show();
		}
	}).done(function(result) {
		console.log(result);
		
		if ( result.result == 200)
			location.reload();
		//console.log(result);
		//$('#load-image').hide();
		//if(result.result == 300){
			//alert('아이디 또는 패스워드를 확인하세요');
		//}else{
			//location.href="/index";
		//}
		
	}).fail(function(data) {
		//$('#load-image').hide();
		alert(data);
	}); 
}
</script>
</footer>