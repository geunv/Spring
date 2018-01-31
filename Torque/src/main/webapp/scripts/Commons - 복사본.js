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

				XML_DOC = new ActiveXObject("Microsoft.XMLDOM");
				XML_DOC.async = "false";
				XML_DOC.load(XmlUrl);

				if (XML_DOC.readyState != 4 && !XML_DOC.parseError) 
				{
					alert("Some error Occurred. Please Contact the Administrator.");
					xmlMsgInfo[0] = new fn_CollectionSchema(messageID, "");
					return xmlMsgInfo;
				}
			}

			var oElemLists = XML_DOC.getElementsByTagName("Table");
			//alert("fn_XmlMsgSTR oElemLists:"+oElemLists);

			for(var i=0; i < oElemLists.length; i++)
			{
				var sMsgID = oElemLists.item(i).childNodes(sKeyIndex).text;

				if(messageID == sMsgID)
				{
					var iInfoCount = oElemLists.item(i).childNodes.length;
					for(var j=0; j < iInfoCount; j++)
					{
						xmlMsgInfo[j] = new fn_CollectionSchema(
										oElemLists.item(i).childNodes(j).nodeName
										, oElemLists.item(i).childNodes(j).text.replace("\\r\\n", "<br>"));
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
                XML_DOC = new ActiveXObject("Microsoft.XMLDOM");
                XML_DOC.async = "false";
                XML_DOC.load(XmlUrl);

                if (XML_DOC.readyState != 4 && !XML_DOC.parseError) {
                    alert("Some error Occurred. Please Contact the Administrator.");
                    xmlMsgInfo[0] = new fn_CollectionSchema(messageID, "");
                    return xmlMsgInfo;
                }
            }

            var oElemLists = XML_DOC.getElementsByTagName("Table");
            //alert("fn_XmlMsgSTR oElemLists:"+oElemLists);

            for (var i = 0; i < oElemLists.length; i++) {
                var sMsgID = oElemLists.item(i).childNodes(sKeyIndex).text;

                if (messageID == sMsgID) {
                    var iInfoCount = oElemLists.item(i).childNodes.length;
                    for (var j = 0; j < iInfoCount; j++) {
                        xmlMsgInfo[j] = new fn_CollectionSchema(
										oElemLists.item(i).childNodes(j).nodeName
										, oElemLists.item(i).childNodes(j).text.replace("\\r\\n", "<br>"));
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
