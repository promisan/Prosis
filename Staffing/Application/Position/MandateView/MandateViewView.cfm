
<html>
<head>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Listing</title>

<!--- prevent caching --->
<meta http-equiv="Pragma" content="no-cache"> 
<script language="JavaScript">
javascript:window.history.forward(1);
</script> 

</head>

<cfoutput>

<cfparam name="URL.ID1" default="Locate">

<table width="99%" height="100%" cellspacing="0" cellpadding="0">
    <cfif url.id1 eq "Locate">
	<tr><td height="10">
		<cfinclude template="MandateViewLocate.cfm">
	</td></tr>
	<tr><td height="98%">
		<iframe name="detail" id="detail" width="100%" height="100%" frameborder="0"></iframe>
	</td></tr>
	<cfelse>
	<tr><td height="100%">
	    <iframe name="detail" id="detail" width="100%" height="100%" frameborder="0"></iframe>		
		</td>
	</tr>	
	</cfif>
</table>
	
</cfoutput>

</html>