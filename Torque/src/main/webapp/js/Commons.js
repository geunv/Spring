function fn_WebCommonPath()
{
	var WebCommonPath = "http://" + location.host + document.all.WebCommonPath.value;
	if ( WebCommonPath.length > 0 ) 
		return WebCommonPath;
	else 
		return "";
}

function fn_WindowOnLoad()
{
    $('li.dropdown').hover(function() {
        $(this).find('.dropdown-menu').stop(true, true).delay(200).slideDown("fast"); // .fadeIn(0);
    }, function() {
        $(this).find('.dropdown-menu').stop(true, true).delay(200).fadeOut(0); //.slideUp();
    });
}

function fn_PreventRightMouse()
{
	window.event.returnValue = false;
}

function fn_ToUpperCase(obj)
{
	try {
	    // 소문자이면 대문자로 변경한다. ( 97(122) -> 65(90) )
	    //if (window.event.keyCode >= 97 && window.event.keyCode <= 122)
	        //window.event.keyCode = window.event.keyCode - 32;

	    if (window.event.keyCode == 40 || window.event.keyCode == 41) {
	        event.returnValue = false;
	        fn_DisplayMessage("ST02.CheckSymbols", "A");
	    }
	    else {
	        obj.value = obj.value.toUpperCase();
	    }       
	}
	catch (exception) { }
}

function fn_ToLowerCase()
{
	try
	{
		// 소문자이면 대문자로 변경한다. ( 97(122) <- 65(90) )
		if ( window.event.keyCode >= 65 && window.event.keyCode <= 90 )
			window.event.keyCode = window.event.keyCode + 32;
	}
	catch (exception) { }		
}

function fn_NumKey() 
{
	if(event.keyCode < 48 || event.keyCode > 57) event.returnValue = false;
}

function fn_ToggleAllCheckBox(checkboxName,isChecked)
{
	var oRGroup = document.all[checkboxName];
	if(oRGroup != null)
	{
		if(oRGroup.length != null)
		{
			for ( var i = 0 ; i < oRGroup.length ; i++ )
			{
			if(!oRGroup[i].disabled)
			{
				oRGroup[i].checked = isChecked;
			}
			}
		}
		else
		{
			oRGroup.checked = isChecked;
		}
	}
}

function fn_GetCheckedItems(id)
{
	var oRGroup = document.all[id];
	var arrReturn = new Array();
	for ( var i = 0 ; i < oRGroup.length ; i++ )
	{
		if (oRGroup[i].checked) arrReturn.push(i);
	}
	return arrReturn;
}

function fn_OpenWindow(surl, stitle, sw, sh, sopt) 
{
    cw = screen.availWidth;    
    ch = screen.availHeight;

    ml = (cw - sw) / 2;
    mt = (ch - sh) / 2;

    window.open(surl, stitle, 'width=' + sw + ',height=' + sh + ',top=' + mt + ',left=' + ml + ',' + sopt +'');
}

function fn_ShowDialog(surl, stitle, sw, sh, mflag) {
    var page = surl;

    var $dialog = $('<div id="dialog"></div>')
               .html('<iframe style="border: 0px; " src="' + page + '" width="100%" height="100%"></iframe>')
               .dialog({
                   autoOpen: false,
                   modal: mflag,
                   height: sh,
                   width: sw,
                   title: stitle,
                   close: function (e) {
                    $('#dialog').remove();
                    }
               });
               $dialog.dialog('open');
}

function fn_CloseDialog(obj, flg) {
    if (flg == "1") {
        document.getElementById(obj).click();
    } else {
        $("#dialog").dialog('close');
    }

    return false;
}

function fn_DisplayDictionary(msgID, RetType) {
    var arrMsgInfo = fn_XmlDicSTR(msgID);
    var strMsg = "";
    var strMsgLocal = "";
    var strMsgText = "";
    var strMsgType = "";
    var strMsgKey = "DIC_NM_" + document.all.DeLanguageType.value;

    for (var i = 0; i < arrMsgInfo.length; i++) {
        if (arrMsgInfo[i].key == strMsgKey)
            strMsg = arrMsgInfo[i].value;
    }

    // RetType : A - Alert, R - Return String
    if (RetType == "A") {
        alert(strMsg);
    } else if (RetType == "R") {
        return strMsg;
    }
}

function fn_DisplayMessage(msgID, RetType) {
    var arrMsgInfo = fn_XmlMsgSTR(msgID);
	var strMsg = "";
	var strMsgLocal = "";
	var strMsgText = "";
	var strMsgType = "";
	var strMsgKey = "MSG_TEXT_" + document.all.DeLanguageType.value;

	for(var i=0; i< arrMsgInfo.length ; i++)
	{
		if( arrMsgInfo[i].key == strMsgKey )
			strMsg = arrMsgInfo[i].value;
	}

	// RetType : A - Alert, R - Return String
	if (RetType == "A") {
	    alert(strMsg);
	} else if (RetType == "R") {
	    return strMsg;
	}
}

function fn_DisplayError(msg, param1, param2)
{
	var vMsg = fn_XmlMsgT(msg);
	
	if (param1 != null) vMsg = vMsg.replace("{0}", param1);
	if (param2 != null) vMsg = vMsg.replace("{1}", param2);
	
	alert(vMsg);
}

 function fn_DisplayException(msg) {
     var vMsg = "[Exception] \n" + msg + "\n\nPlease contact administrator.";
	         

	alert(vMsg);
}

var XML_DOC;
function fn_XmlMsgSTR(messageID)
{
	var regBool = false;
	var xmlMsgInfo= new Array();//
	var sKeyIndex = 0;//"MSG_ID";

	try
	{
	    var re = new RegExp(document.all.MessageCodeRegEx.value);

		if (!(re.test(messageID)))
		{
			regBool = false;
		}
		else
		{
			regBool = true;
		}

		if (regBool)
		{
			if( !XML_DOC )
			{
				var XmlUrl = fn_WebCommonPath() + "/xml/Message.xml";

				if (window.XMLHttpRequest) {
				    xhttp = new XMLHttpRequest();
				}
				else // code for IE5 and IE6
				{
				    xhttp = new ActiveXObject("Microsoft.XMLHTTP");
				}
			
				xmlhttp = new XMLHttpRequest();
				xmlhttp.open("GET", XmlUrl, false);
				xmlhttp.send();

				XML_DOC = xmlhttp.responseXML;

				if (xmlhttp.readyState != 4 && !xmlhttp.parseError) {
				    alert("Some error Occurred. Please Contact the Administrator.");
				    xmlMsgInfo[0] = new fn_CollectionSchema(messageID, "");
				    return xmlMsgInfo;
				}
			}

			var oElemLists = XML_DOC.getElementsByTagName("Table");

			for(var i=0; i < oElemLists.length; i++) {
			    var sMsgID = oElemLists[i].getElementsByTagName("MSG_ID")[sKeyIndex].childNodes[0].nodeValue;

				if(messageID == sMsgID)
				{
				    var childElement = ["MSG_ID", "MSG_TEXT_EN_US", "MSG_TEXT_KO_KR", "MSG_TEXT_LO_LN"];
				    
				    for (var j = 0; j < childElement.length; j++)
					{
						xmlMsgInfo[j] = new fn_CollectionSchema(
										childElement[j]
										, oElemLists[i].getElementsByTagName(childElement[j])[0].childNodes[0].nodeValue.replace("\\r\\n", "<br>"));
					}

				}
				if(!xmlMsgInfo)
				{
					xmlMsgInfo[0] = new fn_CollectionSchema(messageID, "");
				}
			}
		}

		return xmlMsgInfo;
	}
	catch (exception) 
	{
		alert(exception.description);
	}
}

function fn_XmlDicSTR(messageID) {
    var regBool = false;
    var xmlMsgInfo = new Array(); //
    var sKeyIndex = 0; //"DIC_ID";

    try {
        var re = new RegExp(document.all.MessageCodeRegEx.value);

        if (!(re.test(messageID))) {
            regBool = false;
        }
        else {
            regBool = true;
        }

        if (regBool) {
            if (!XML_DOC) {
                var XmlUrl = fn_WebCommonPath() + "/xml/Dictionary.xml";

                if (window.XMLHttpRequest) {
                    xhttp = new XMLHttpRequest();
                }
                else // code for IE5 and IE6
                {
                    xhttp = new ActiveXObject("Microsoft.XMLHTTP");
                }

                xmlhttp = new XMLHttpRequest();
                xmlhttp.open("GET", XmlUrl, false);
                xmlhttp.send();

                XML_DOC = xmlhttp.responseXML;

                if (xmlhttp.readyState != 4 && !xmlhttp.parseError) {
                    alert("Some error Occurred. Please Contact the Administrator.");
                    xmlMsgInfo[0] = new fn_CollectionSchema(messageID, "");
                    return xmlMsgInfo;
                }
            }

            var oElemLists = XML_DOC.getElementsByTagName("Table");

            for (var i = 0; i < oElemLists.length; i++) {
                var sMsgID = oElemLists[i].getElementsByTagName("DIC_ID")[sKeyIndex].childNodes[0].nodeValue;

                if (messageID == sMsgID) {
                    var childElement = ["DIC_ID", "DIC_NM_EN_US", "DIC_NM_KO_KR", "DIC_NM_LO_LN"];

                    for (var j = 0; j < childElement.length; j++) {
                        xmlMsgInfo[j] = new fn_CollectionSchema(
										childElement[j]
										, oElemLists[i].getElementsByTagName(childElement[j])[0].childNodes[0].nodeValue.replace("\\r\\n", "<br>"));
                    }

                }
                if (!xmlMsgInfo) {
                    xmlMsgInfo[0] = new fn_CollectionSchema(messageID, "");
                }
            }
        }

        return xmlMsgInfo;
    }
    catch (exception) {
        alert(exception.description);
    }
}

function fn_CollectionSchema(key, value)
{
	if(key)	this.key = key;
	else this.key = ""

	if(value) this.value = value
	else this.value = "";
}

function fn_ExcelReport(id, name) {
    var tab_text = '<html xmlns:x="urn:schemas-microsoft-com:office:excel">';
    tab_text = tab_text + '<head><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>';
    tab_text = tab_text + '<x:Name>Sheet</x:Name>';
    tab_text = tab_text + '<x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet>';
    tab_text = tab_text + '</x:ExcelWorksheets></x:ExcelWorkbook></xml></head><body>';
    tab_text = tab_text + "<table border='1px'>";
    var exportTable = $('#' + id).clone();
    exportTable.find('input').each(function (index, elem) { $(elem).remove(); });
    tab_text = tab_text + exportTable.html();
    tab_text = tab_text + '</table></body></html>';
    var data_type = 'data:application/vnd.ms-excel';
    var ua = window.navigator.userAgent;
    var msie = ua.indexOf("MSIE ");

    //var fileName = name + '_' + parseInt(Math.random() * 10000000000) + '.xls';
    var fileName = name;
    if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
        if (window.navigator.msSaveBlob) {
            var blob = new Blob([tab_text], {
                type: "application/csv;charset=utf-8;"
            });
            navigator.msSaveBlob(blob, fileName);
        }
    } else {
        var blob2 =  new Blob([tab_text], {
            type: "application/csv;charset=utf-8;"
        });
        var filename = fileName;
            var elem = window.document.createElement('a');
            elem.href = window.URL.createObjectURL(blob2);
            elem.download = filename;
            document.body.appendChild(elem);
            elem.click();
            document.body.removeChild(elem);
    }
}

function itoStr($num)
{
    $num < 10 ? $num = '0'+$num : $num;
    return $num.toString();
}

function fn_Excelpostfix(){
	var dt = new Date();
    var year =  itoStr( dt.getFullYear() );
    var month = itoStr( dt.getMonth() + 1 );
    var day =   itoStr( dt.getDate() );
    var hour =  itoStr( dt.getHours() );
    var mins =  itoStr( dt.getMinutes() );

    var postfix = "-"+year + month + day + "_" + hour + mins;
    
    return postfix;
}

String.prototype.trim = function() {
    return this.replace(/(^\s*)|(\s*$)/gi, "");
}

function ChangeDateFormat(DB_Date){
	var dt = $.trim(DB_Date);
	var datetime = ""; 
	if ( dt.length > 0 )
		datetime = DB_Date.substr(0,4) +'-' +DB_Date.substr(4,2) +"-" + DB_Date.substr(6,2) +" " +DB_Date.substr(8,2)+":"+ DB_Date.substr(10,2)+":"+DB_Date.substr(12,2)
	else
		datetime = "";
	
    return datetime;
}

function ChangeDateFormatSimple(DB_Date){
	var datetime = "";
	var dt = $.trim(DB_Date);
	if ( dt.length > 0 )
		datetime = DB_Date.substr(0,4) +'-' +DB_Date.substr(4,2) +"-" + DB_Date.substr(6,2)
    return datetime;
}

function fn_getday(str){
	
	var d;
	if ( str == '' || str == undefined)
		d = new Date(); 
	else
		d = new Date(str);
	
	var year = d.getFullYear(); 
	var month = new String(d.getMonth()+1); 
	var day = new String(d.getDate()); 

	// 한자리수일 경우 0을 채워준다. 
	if(month.length == 1){ 
	  month = "0" + month; 
	} 
	if(day.length == 1){ 
	  day = "0" + day; 
	} 

	return year + "-" + month + "-" + day;
	
}

function fn_nowtime(){
	var date = new Date;
	var hour = date.getHours();
	var min = date.getMinutes();
	var sec = date.getSeconds();
	
	/*if(hour.length == 1)
		hour = "0" + hour;
	
	if(min.length == 1)
		min = "0" + min
	
	if( sec.length == 1)
		sec = "0" + sec
		*/
	return pad(hour,2) + ":" + pad(min,2) + ":" + pad(sec,2);
}

function pad (str, max) {
	  str = str.toString();
	  return str.length < max ? pad("0" + str, max) : str;
}

function getHour(str){
	if( str == 'S')
		$('#ddlHour').append('<option value="">Select</option>');
	else
		$('#ddlHour').append('<option value="-1">ALL</option>');
	
	for ( i = 0 ;i < 24; i++){
		$('#ddlHour').append('<option value="' + pad(i,2) + '">' + pad(i,2) + '</option>');
	}
}


/* */

function getQuerystring(paramName){ 
	var _tempUrl = window.location.search.substring(1); //url에서 처음부터 '?'까지 삭제 
	var _tempArray = _tempUrl.split('&'); // '&'을 기준으로 분리하기 
	for(var i = 0; _tempArray.length; i++) 
	{ 
		var _keyValuePair = _tempArray[i].split('='); // '=' 을 기준으로 분리하기 
		if(_keyValuePair[0] == paramName){ // _keyValuePair[0] : 파라미터 명 
			// _keyValuePair[1] : 파라미터 값 
			return _keyValuePair[1]; 
		} 
	} 
}

function fn_enter(txtid){
	var ID = txtid; 
	
	$("#"+ID).keydown(function (key) {
    	if(key.keyCode == 13){//키가 13이면 실행 (엔터는 13)
        	$('#btnSearch').click()
        }
    });
}


	
	
function getPlant(){
	$.get('/api/common/getplant',function(data){
		if(data.result == 200){
			data.list.forEach(function(item){
				$('#ddlPlant').append('<option value="'+item.code+ '" selected>' + item.code_nm+'</option>');
			});
		}
	});
}

function getLine(str){
	$.get('/api/common/getline',function(data){
		if(data.result == 200){
			$('#ddlLine').empty();
			
			if( str == 'S')
				$('#ddlLine').append('<option value="">Select</option>');
			else
				$('#ddlLine').append('<option value="-1">ALL</option>');
			
			/*$('#ddlLine').append('<option value="'+item.code+ '" selected>' + item.code_nm+'</option>');*/
			data.list.forEach(function(item){
				$('#ddlLine').append('<option value="'+item.code+ '">' + item.code_nm+'</option>');
				
			});
		}
	});
}

function getCarType(str){
	$.get('/api/common/getcartype',function(data){
		if(data.result == 200){
			$('#ddlCarType').empty();
			
			if( str == 'S')
				$('#ddlCarType').append('<option value="">Select</option>');
			else
				$('#ddlCarType').append('<option value="-1">ALL</option>');
			
			data.list.forEach(function(item){
				$('#ddlCarType').append('<option value="'+item.code+'">' + item.code_nm +'</option>'); 
			});
		}
	});
}

function getStnType(str){
	$.get('/api/common/getstntype', function(data){
		
		if(data.result == 200){
			$('#ddlStnType').empty();
		
			if( str == 'S')
				$('#ddlStnType').append('<option value="">Select</option>');
			else
				$('#ddlStnType').append('<option value="-1">ALL</option>');
			
			/* for(var i=0 ; i <= data.list.length; i++){
				$('#ddlStnType').append('<option value="'+data.list[i].code+ '">' + data.list[i].code_nm+'</option>');
			} */
			
			data.list.forEach(function(item){
				$('#ddlStnType').append('<option value="'+item.code+ '">' + item.code_nm+'</option>');
			});
		}
	});
}

function getShift(str){
	$.get('/api/common/getshift', function(data){
		
		if(data.result == 200){
			$('#ddlShift').empty();
		
			if( str == 'S')
				$('#ddlShift').append('<option value="">Select</option>');
			else
				$('#ddlShift').append('<option value="-1">ALL</option>');
			
			/* for(var i=0 ; i <= data.list.length; i++){
				$('#ddlStnType').append('<option value="'+data.list[i].code+ '">' + data.list[i].code_nm+'</option>');
			} */
			
			data.list.forEach(function(item){
				$('#ddlShift').append('<option value="'+item.code+ '">' + item.code_nm+'</option>');
			});
		}
	});
}

function getToolGroup(str){
	var vPlant_cd = $('#ddlPlant').val()
	if (vPlant_cd == null)  
		vPlant_cd = '1';
		
	$.get('/api/common/gettoolgroup?plant_cd='+vPlant_cd, function(data){
		if(data.result == 200){
			$('#ddlToolGrp').empty();
			
			if ( str == 'S')
				$('#ddlToolGrp').append('<option value="">Select</option>');
			else
				$('#ddlToolGrp').append('<option value="-1">ALL</option>');
			
			data.list.forEach(function(item){
				$('#ddlToolGrp').append('<option value="'+item.device_grp_cd+ '">' + item.device_grp_nm+'</option>');
			});
		}
	});
}

function getJobNoTool(str){
	var vplant_cd = $('#ddlPlant').val()
	var vcar_type = $('#ddlCarType').val();
	
	var params = "?plant_cd=" + vplant_cd +
				 "&car_type=" + vcar_type;
	
	$.get('/api/common/getjobnotool'+ params,function(data){
		if(data.result == 200){
			$('#ddlTool').empty();
			
			if ( str == 'S')
				$('#ddlTool').append('<option value="">Select</option>');
			else
				$('#ddlTool').append('<option value="-1">ALL</option>');
			
			data.list.forEach(function(item){
				$('#ddlTool').append('<option value="'+item.device_id+ '">' + item.device_nm+'</option>');
			});
		}
	});
}

function getJobNoToolP01(str){
	var vplant_cd = $('#ddlPlant').val()
	var vcar_type = $('#ddlCarType').val();
	
	var params = "?plant_cd=" + vplant_cd +
				 "&car_type=-1";
	
	$.get('/api/common/getjobnotool'+ params,function(data){
		if(data.result == 200){
			$('#ddlTool').empty();
			
			if ( str == 'S')
				$('#ddlTool').append('<option value="">Select</option>');
			else
				$('#ddlTool').append('<option value="-1">ALL</option>');
			
			data.list.forEach(function(item){
				$('#ddlTool').append('<option value="'+item.device_id+ '">' + item.device_nm+'</option>');
			});
		}
	});
}


function getToolId(str,vplant_cd,vdevice_grp_cd,vstn_gub,vline_cd,vweb_display_flg){
	
	if ( vstn_gub == "")
		vstn_gub = '-1';
	
	var params = "?plant_cd="+vplant_cd+
				 "&device_grp_cd=" + vdevice_grp_cd + 
				 "&stn_gub=" + vstn_gub + 
				 "&line_cd=" + vline_cd + 
				 "&web_display_flg=" + vweb_display_flg;
	
	$.get('/api/common/gettoolid' + params,function(data){
		if(data.result == 200){
			$('#ddlTool').empty();
			
			if ( str == 'S')
				$('#ddlTool').append('<option value="">Select</option>');
			else if ( str == 'A')
				$('#ddlTool').append('<option value="-1">ALL</option>');
			
			data.list.forEach(function(item){
				$('#ddlTool').append('<option value="'+item.device_id+ '">' + item.device_nm+'</option>');
			});
		}
	});
}


function getToolType(str){

	$.get('/api/common/gettooltype',function(data){
		if(data.result == 200){
			
			$('#ddlToolType').empty();
			if ( str == 'S' )
				$('#ddlToolType').append('<option value="">Select</option>');
			else
				$('#ddlToolType').append('<option value="-1">ALL</option>');
			
			data.list.forEach(function(item){
				$('#ddlToolType').append('<option value="'+item.code+ '" >' + item.code_nm+'</option>');
			});
		}
	});
}

function getToolState(str){

	$.get('/api/common/gettoolstate',function(data){
		if(data.result == 200){
			
			$('#ddlToolState').empty();
			if(str == 'S')
				$('#ddlToolState').append('<option value="">Select</option>');
			else
				$('#ddlToolState').append('<option value="-1">ALL</option>');
			
			data.list.forEach(function(item){
				$('#ddlToolState').append('<option value="'+item.code+ '" >' + item.code_nm+'</option>');
			});
		}
	});
}

function getProcState(str){
	$.get('/api/common/getprocstate',function(data){
		if(data.result == 200){
			
			$('#ddlProcState').empty();
			if(str == 'S')
				$('#ddlProcState').append('<option value="">Select</option>');
			else
				$('#ddlProcState').append('<option value="-1">ALL</option>');
			
			data.list.forEach(function(item){
				$('#ddlProcState').append('<option value="'+item.code+ '" >' + item.code_nm+'</option>');
			});
		}
	});
}

function getPgmList(str){
	var params = "?plant_cd="+$('#ddlPlant').val()+
	 "&stn_gub=" + $('#ddlStnType').val(); 

	$.get('/api/common/getpgmlist' + params,function(data){
		//if(data.result == 200){
			$('#ddlProgram').empty();
			
			if ( str == 'S')
				$('#ddlProgram').append('<option value="">Select</option>');
			else if ( str == 'A')
				$('#ddlProgram').append('<option value="-1">ALL</option>');
			
			data.forEach(function(item){
				$('#ddlProgram').append('<option value="'+item.pgm_id+ '">' + item.pgm_nm+'</option>');
			});
		//}
	});
}

function getProcList(str){
	var params = "?plant_cd="+$('#ddlPlant').val()+
	 "&stn_gub=" + $('#ddlStnType').val()+
	 "&pgm_id="+$('#ddlProgram').val();
	
	$.get('/api/common/getproclist' + params,function(data){
		//if(data.result == 200){
			$('#ddlProcess').empty();
			
			if ( str == 'S')
				$('#ddlProcess').append('<option value="">Select</option>');
			else if ( str == 'A')
				$('#ddlProcess').append('<option value="-1">ALL</option>');
			
			data.forEach(function(item){
				$('#ddlProcess').append('<option value="'+item.proc_id+ '">' + item.proc_nm+'</option>');
			});
		//}
	});
}

function getUseFlag(txtid,gbn){
	var ID = txtid; 
	$.get('/api/common/getuseflag',function(data){
		if(data.result == 200){
			$('#'+ID).empty();
			
			if ( gbn == 'S' )
				$('#'+ID).append('<option value="">Select</option>');
			else if ( gbn == 'A')
				$('#'+ID).append('<option value="-1">ALL</option>');
				
			data.list.forEach(function(item){
				$('#'+ID).append('<option value="'+item.code+ '" >' + item.code_nm+'</option>');
			});
		}
	});
}

function getTighteningResult(str){
	$.get('/api/common/gettighteningresult',function(data){
		//if(data.result == 200){
			$('#ddlTighteningResult').empty();
			
			if ( str == 'S')
				$('#ddlTighteningResult').append('<option value="">Select</option>');
			else if ( str == 'A')
				$('#ddlTighteningResult').append('<option value="-1">ALL</option>');
			
			data.forEach(function(item){
				$('#ddlTighteningResult').append('<option value="'+item.code+ '">' + item.code_nm+'</option>');
			});
		//}
	});
}

function getTighteningResultSimple(str){
	$.get('/api/common/gettighteningresultsimple',function(data){
		//if(data.result == 200){
			$('#ddlTighteningResult').empty();
			
			if ( str == 'S')
				$('#ddlTighteningResult').append('<option value="">Select</option>');
			else if ( str == 'A')
				$('#ddlTighteningResult').append('<option value="-1">ALL</option>');
			
			data.forEach(function(item){
				$('#ddlTighteningResult').append('<option value="'+item.code+ '">' + item.code_nm+'</option>');
			});
		//}
	});
}

function getUserAuthority(user_grade){
	
	$.get('/api/common/getuserauthority?user_grade='+user_grade,function(data){
		if(data.result == 200){
			$('#ddlUserAuthority').empty();
			
			$('#ddlUserAuthority').append('<option value="-1">ALL</option>');
			
			data.list.forEach(function(item){
				$('#ddlUserAuthority').append('<option value="'+item.code+ '">' + item.code_nm+'</option>');
			});
		}
	});
	
}

function getUserGroup(str,user_grade){
	$.get('/api/common/getusergroup?user_grade='+user_grade,function(data){
		if(data.result == 200){
			$('#ddlUserGrp').empty();
			
			if ( str == 'S')
				$('#ddlUserGrp').append('<option value="">Select</option>');
			else if ( str == 'A')
				$('#ddlUserGrp').append('<option value="-1">ALL</option>');
			
			data.list.forEach(function(item){
				$('#ddlUserGrp').append('<option value="'+item.code+ '">' + item.code_nm+'</option>');
			});
		}
	});
}

function getSystemArea(str){
	$.get('/api/common/getsystemarea',function(data){
		//if(data.result == 200){
			$('#ddlSystemArea').empty();
			
			if ( str == 'S')
				$('#ddlSystemArea').append('<option value="">Select</option>');
			else if ( str == 'A')
				$('#ddlSystemArea').append('<option value="-1">ALL</option>');
			
			data.list.forEach(function(item){
				$('#ddlSystemArea').append('<option value="'+item.code+ '">' + item.code_nm+'</option>');
			});
		//}
	});
}

function getLangType(str){
	$.get('/api/common/getlangtype',function(data){
		//if(data.result == 200){
			$('#ddlLangType').empty();
			
			if ( str == 'S')
				$('#ddlLangType').append('<option value="">Select</option>');
			else if ( str == 'A')
				$('#ddlLangType').append('<option value="-1">ALL</option>');
			
			data.list.forEach(function(item){
				$('#ddlLangType').append('<option value="'+item.code+ '">' + item.code_nm+'</option>');
			});
		//}
	});
}

function getCommonCodeGroup(str){
	$.get('/api/common/getcommoncodegroup',function(data){
		//if(data.result == 200){
			$('#ddlCodeGrp').empty();
			
			if ( str == 'S')
				$('#ddlCodeGrp').append('<option value="">Select</option>');
			else 
				$('#ddlCodeGrp').append('<option value="-1">ALL</option>');
			
			data.list.forEach(function(item){
				$('#ddlCodeGrp').append('<option value="'+item.code+ '">' + item.code_nm+'</option>');
			});
		//}
	});
}

function ddlInterlockType(str){
	$.get('/api/common/getinterlocktype',function(data){
		//if(data.result == 200){
			$('#ddlInterlockType').empty();
			
			if ( str == 'S')
				$('#ddlInterlockType').append('<option value="">Select</option>');
			else 
				$('#ddlInterlockType').append('<option value="-1">ALL</option>');
			
			data.list.forEach(function(item){
				$('#ddlInterlockType').append('<option value="'+item.code+ '">' + item.code_nm+'</option>');
			});
		//}
	});
}
/* */