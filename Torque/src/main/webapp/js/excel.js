function Export(htmltable) {
    var excelFile = "<html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:x='urn:schemas-microsoft-com:office:excel' xmlns='http://www.w3.org/TR/REC-html40'>";
    excelFile += "<head>";
    excelFile += '<meta http-equiv="Content-type" content="text/html;charset=utf-8" />';
    excelFile += "<!--[if gte mso 9]>";
    excelFile += "<xml>";
    excelFile += "<x:ExcelWorkbook>";
    excelFile += "<x:ExcelWorksheets>";
    excelFile += "<x:ExcelWorksheet>";
    excelFile += "<x:Name>";
    excelFile += "{worksheet}";
    excelFile += "</x:Name>";
    excelFile += "<x:WorksheetOptions>";
    excelFile += "<x:DisplayGridlines/>";
    excelFile += "</x:WorksheetOptions>";
    excelFile += "</x:ExcelWorksheet>";
    excelFile += "</x:ExcelWorksheets>";
    excelFile += "</x:ExcelWorkbook>";
    excelFile += "</xml>";
    excelFile += "<![endif]-->";
    excelFile += "</head>";
    excelFile += "<body>";
    excelFile += htmltable.replace(/"/g, '\'');
    excelFile += "</body>";
    excelFile += "</html>";

    var uri = "data:application/vnd.ms-excel;base64,";
    var ctx = { worksheet: 'test', table: htmltable };

    return (uri + base64(format(excelFile, ctx)));
}
function base64(s) {
    return window.btoa(unescape(encodeURIComponent(s)));
}
function format(s, c) {
    return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; });
}
