


<cfquery name="Check" 
 datasource="AppsSystem">
	 SELECT * 
	 FROM   UserReport	
	 WHERE  ReportId = '#replace(URL.id,' ','','ALL')#'	 
</cfquery>		

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>

<cfoutput>
<head>
	<title>Report: #Check.DistributionSubject#</title>
</head>
</cfoutput>

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">

<cfset rt = "">

<cfif Check.recordcount eq "1">
	 
	<cfoutput>	
		<cfset rt = replaceNoCase(CGI.SCRIPT_NAME,"/Report.cfm","")>		
	</cfoutput>

</cfif>

<cfoutput>

<table width="100%" height="100%" cellspacing="0" cellpadding="1">
	
	<tr><td height="100%" colspan="2">
		
	<cfif CGI.HTTPS eq "off">
		<cfset tpe = "http">
	<cfelse>	
		<cfset tpe = "https">
	</cfif>
	
	<iframe src="#tpe#://#CGI.HTTP_HOST#/#rt#/Tools/CFReport/ReportLinkOpen.cfm?refer=hyperlink&reportId=#urlencodedformat(URL.Id)#&mode=link"
        width="100%"
        height="100%"
		scroll="No"
        frameborder="0">
	</iframe>
	
	</td></tr>

</table>
</cfoutput>

</body>
	
