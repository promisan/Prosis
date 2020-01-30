
<!--- container --->
<cf_screentop height="100%" html="no" layout="webapp" banner="gray" scroll="no" label="Register Invoice">
	
<cfoutput>
<cf_divscroll>
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr><td valign="top">
    <!--- passthru --->
	<iframe src="InvoiceEntry.cfm?#CGI.QUERY_STRING#" 
	   name="base" id="base" 
	   width="100%" height="99%" 
	   marginwidth="0" 
	   marginheight="0" 
	   scrolling="no" 
	   frameborder="0"></iframe>
</td></tr>
</table>
</cf_divscroll>
</cfoutput>