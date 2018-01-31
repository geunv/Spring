<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8"> 
	<title>Line Stop History</title>
	<jsp:include page="../head.jsp" flush="false" />
</head>
<body>
<jsp:include page="../menu.jsp" flush="false" />

<script type="text/javascript">
    $(document).ready(function() {
        $("#btnSearch").button();
        $("#btnExcel").button();
        
        $("#txtDate").datepicker({
        	changeMonth: true,
            dateFormat: 'yy-mm-dd',
        });
       
        $.ajaxSetup({async:false});	//비동기 끄기	- dropdownlist 가 순차적으로 불러져야 다음 ddl이 불러진다.
    	
        init();
    	
    	$("#txtDate").val(fn_getday());
    	
		$.ajaxSetup({async:true});	//비동기 켜기
		
		getList();
		
		$("#btnSearch").on('click', function(e){
			now_page = 1;
    		show_count  = $('#select_show_count').val();
			getList();
		});
		
		$('#ddlTool').on('change', function(){
			$('#btnSearch').click()
    	});
		
		$('#ddlInterlockType').on('change', function(){
			$('#btnSearch').click()
    	});
		
		$("#txtBodyNo").keydown(function (key) {
	        if(key.keyCode == 13){//키가 13이면 실행 (엔터는 13)
	        	$('#btnSearch').click()
	        }
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
	
    function init(){
		getPlant();
		ddlTool();
		//ddlInterlockType('A');
    }
    
    
    function ddlTool(){
    	getToolId('A',$('#ddlPlant').val(),'-1','N','-1','W');
    }
    
    var now_page = 1;
    var show_count = 20;

    function getList(){
        
    	var params ="?plant_cd="+$('#ddlPlant').val()+
		 			"&work_dt="+$('#txtDate').val()+
		 			"&tool="+$('#ddlTool').val() +
		 			"&interlock_type="+$('#ddlInterlockType').val()+
		 			"&txt_car_type="+$('#txtCarType').val()+
		 			"&txt_body_no="+$('#txtBodyNo').val()+
		 			"&page="+now_page+
    				"&show_count="+show_count;
    	
    	$.ajax({
			type : "GET",
			url : '/api/result/getlinestophistory'+params,
			beforeSend : function(){
				$('#load-image').show();
			}
		}).done(function(data) {
			//console.log(result);
			$('#load-image').hide();
			if(data.result == 200){
    			
    			$('#select_page_count').empty();
    			$('#list_total').text(data.total_count); 	// 총갯수
    			//this.custPager.TotalPages = num % this.gridView1.PageSize == 0 ? num / this.gridView1.PageSize : num / this.gridView1.PageSize + 1;
    			
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
    				var var_interlock_flg = "";
    				if ( item.interlock_flg == "Y" )
    					var_interlock_flg ="Set interlock";
    				else
    					var_interlock_flg ="Clear interlock";

    				$('#list_data').append(
    					  '<tr>' 
							+ ' <td>' + item.rnum +'</td>'
							+ ' <td class="left_5">' + item.device +'</td>'
							+ ' <td>' + ChangeDateFormatSimple(item.interlock_dt) +'</td>'
							+ ' <td>' + item.interlock_seq +'</td>'
							+ ' <td>' + var_interlock_flg +'</td>'
							+ ' <td>' + item.body_no +'</td>'
							+ ' <td class="left_5">' + item.interlock_reason  +'</td>'
							+ ' <td>' + ChangeDateFormat(item.regdt) +'</td>'
							+ ' <td>' + item.reg_user_id  +'</td>'
    					+ '</tr>'
    				);
    			});
    			
    		}
			
		}).fail(function(data) {
			$('#load-image').hide();
			alert(data);
		});
    	/* $.get('/api/result/getlinestophistory'+params,function(data){
    		if(data.result == 200){
    			
    			$('#select_page_count').empty();
    			$('#list_total').text(data.total_count); 	// 총갯수
    			//this.custPager.TotalPages = num % this.gridView1.PageSize == 0 ? num / this.gridView1.PageSize : num / this.gridView1.PageSize + 1;
    			
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
    				var var_interlock_flg = "";
    				if ( item.interlock_flg == "Y" )
    					var_interlock_flg ="Set interlock";
    				else
    					var_interlock_flg ="Clear interlock";

    				$('#list_data').append(
    					  '<tr>' 
							+ ' <td>' + item.rnum +'</td>'
							+ ' <td class="left_5">' + item.device +'</td>'
							+ ' <td>' + ChangeDateFormatSimple(item.interlock_dt) +'</td>'
							+ ' <td>' + item.interlock_seq +'</td>'
							+ ' <td>' + var_interlock_flg +'</td>'
							+ ' <td>' + item.body_no +'</td>'
							+ ' <td class="left_5">' + item.interlock_reason  +'</td>'
							+ ' <td>' + ChangeDateFormat(item.regdt) +'</td>'
							+ ' <td>' + item.reg_user_id  +'</td>'
    					+ '</tr>'
    				);
    			});
    			
    		}
    	}); */
    }

    function getExcelData(){
    	//$.get('/api/setting/gettoollist?'+params,function(data){

    	var params ="?plant_cd="+$('#ddlPlant').val()+
		 			"&work_dt="+$('#txtDate').val()+
		 			"&tool="+$('#ddlTool').val() +
		 			"&interlock_type="+$('#ddlInterlockType').val()+
		 			"&txt_car_type="+$('#txtCarType').val()+
		 			"&txt_body_no="+$('#txtBodyNo').val()+
		 			"&page="+now_page+
    				"&show_count="+show_count+
    				"&excel_down=Y";
    	
    	$.ajax({
    			url:'/api/result/getlinestophistory'+params,
    			type:'GET',
    			async:false,
    			success: function(data) {
    				if(data.result == 200){
    					$("#list_excel").empty();
    					$("#list_excel").append("<thead>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Num'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Tool'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Date'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Seq'/></th>");
    					$("#list_excel").append("<th><spring:message code='COMMON.Type'/></th>");
    					$("#list_excel").append("<th><spring:message code='RS02.BodyNo'/></th>");
						$("#list_excel").append("<th><spring:message code='RS05.Reason'/></th>");
						$("#list_excel").append("<th><spring:message code='COMMON.RegisterDate'/></th>");
						$("#list_excel").append("<th><spring:message code='COMMON.Register'/></th>");
						$("#list_excel").append("</thead>");
    					$("#list_excel").append("<tbody>");
    					
    					data.list.forEach(function(item){
    						var var_interlock_flg = "";
    	    				if ( item.interlock_flg == "Y" )
    	    					var_interlock_flg ="Set interlock";
    	    				else
    	    					var_interlock_flg ="Clear interlock";
    	    				
    						$('#list_excel').append(
    							  '<tr>' 
	    							+ ' <td>' + item.rnum +'</td>'
	    							+ ' <td class="left_5">' + item.device +'</td>'
	    							+ ' <td>' + ChangeDateFormatSimple(item.interlock_dt) +'</td>'
	    							+ '	<td style=mso-number-format:"\@";>' + item.interlock_seq +'</td>'
	    							+ ' <td>' + var_interlock_flg +'</td>'
	    							+ ' <td>' + item.body_no +'</td>'
	    							+ ' <td class="left_5">' + item.interlock_reason  +'</td>'
	    							+ ' <td>' + ChangeDateFormat(item.regdt) +'</td>'
	    							+ ' <td>' + item.reg_user_id  +'</td>'
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
                <i class="fa fa-list-ul"></i> <spring:message code="SCREEN.RS05" />
            </div>
            <div id="content-title-nav">
                <i class="fa fa-angle-double-right"></i> <spring:message code="MENU.RESULT" />
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
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Plant" />
                                </td>
                                <td width="20%" class="left_5" >
                                	<select id="ddlPlant"></select>
                                </td>
                                <td width="7%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Date" />
                                </td>
                                <td width="35%" class="left_5" colspan="3">
                                	<input name="txtDate" type="text" id="txtDate" readonly="true" style="width:100px;">
                                    <input type="hidden" name="hdDate" id="hdDate">
                                </td>
                                <td rowspan="3"  class="content-button">
                                	<img src="/images/ajax-loader.gif" style="display:none;" id="load-image"/>
                                	<c:set var="btnSearch"><spring:message code="BUTTON.Search"/></c:set>
                                	<input type="button" id="btnSearch" value="${btnSearch}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">
                                    <c:set var="btnExcel"><spring:message code="BUTTON.Excel"/></c:set>
                                	<input type="button" id="btnExcel" value="${btnExcel}" class="ui-button ui-widget ui-state-default ui-corner-all" role="button">

                                </td>
                            </tr>
                            <tr>
                                <td height="30" ></td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Tool" />
                                </td>
                                <td class="left_5">
                                	<select id="ddlTool"></select>
                                    <!-- <asp:DropDownList ID="ddlTool" runat="server" AutoPostBack="true"
                                        onselectedindexchanged="ddlTool_SelectedIndexChanged" ></asp:DropDownList> -->
                                </td>
                                <td class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="RS02.BodyNo" />
                                </td>
                                <td class="left_5" >
                                	<input type="text" id="txtCarType" MaxLength="4" style="width:50px" style="ime-mode:disabled;text-transform:uppercase;" onKeyUp="fn_ToUpperCase(this);">
                                	<input ypte="text" id="txtBodyNo"  MaxLength="6" style="width:70px"  onkeypress="fn_NumKey()">
                                </td> 
                                <td width="5%" class="left_5">
                                    <i class="fa fa-chevron-circle-right"></i>&nbsp; <spring:message code="COMMON.Type" /><!-- <asp:Label ID="lblInterFlg" runat="server" Text="COMMON.Type"></asp:Label> -->
                                </td>
                                <td class="left_5">
                                	<select id="ddlInterlockType">
                                		<option value="-1">All</option>
                                		<option value="Y">Set interlock</option>
                                		<option value="N">Clear interlock</option>
                                	</select>
                                    <!-- <asp:DropDownList ID="ddlInterlockType" runat="server" AutoPostBack="true"
                                        onselectedindexchanged="ddlInterlockType_SelectedIndexChanged" ></asp:DropDownList> -->
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div id="C_Result" style="overflow:auto;">
           <div class="total_count">
                [ <spring:message code="COMMON.TotalCont" /> : <div style='display:inline;' id="list_total"></div> ]
            </div>
	        <div >
	        	<table class="gridview" cellspacing="0" border="0" style="width:100%;border-collapse:collapse;" id="list_table">
	            	<thead>
						<tr>
							<th style="width:2%"><div align="center"><spring:message code="COMMON.Num"/></div></th>
							<th style="width:30%"><div align="center"><spring:message code="COMMON.Tool"/></div></th>
							<th style="width:8%"><div align="center"><spring:message code="COMMON.Date"/></div></th>
							<th style="width:5%"><div align="center"><spring:message code="COMMON.Seq"/></div></th>
							<th style="width:10%"><div align="center"><spring:message code="COMMON.Type"/></div></th>
							<th style="width:9%"><div align="center"><spring:message code="RS02.BodyNo"/></div></th>
							<th style="width:10%"><div align="center"><spring:message code="RS05.Reason"/></div></th>
							<th style="width:12%"><div align="center"><spring:message code="COMMON.RegisterDate"/></div></th>
							<th style="width:10%"><div align="center"><spring:message code="COMMON.Register"/></div></th>
						</tr>
					</thead>
					<tbody id="list_data">
					</tbody>
				</table>
            </div>
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
				  			<option value="10">10</option>
				  			<option value="20" selected>20</option>
				  			<option value="30">30</option>
				  	</select>
			        <span>&nbsp;Records per Page</span>
			    </div>
			</div>

        	<div id="wrapper" style="visibility:hidden;overflow:hidden;height:0px;">
	            <table border="1" id="list_excel"></table>
            </div>
        
        </div><!-- C_Result -->  
	</div><!-- C_Body -->
</div>
<jsp:include page="../bottom.jsp" flush="false" />
</body>
</html>
