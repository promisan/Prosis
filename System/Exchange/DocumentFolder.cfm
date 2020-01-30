
<cfset Page         = "0">
<cfset add          = "0">
<cfinclude template="../Parameter/HeaderParameter.cfm"> 	
	
<cf_screentop height="100%" scroll="Yes" html="No" label="Exchange Attachments" layout="innerbox">

<cfajaximport tags="cfdiv,cfwindow">

<table width="97%" height="100%" align="center">
<tr><td style="padding-top:20px" valign="top">
	<cf_filelibraryN
			DocumentPath="Exchange"
			SubDirectory="" 
			Filter=""
			Insert="yes"
			Remove="yes"
			width="99%"		
			AttachDialog="yes"
			align="left"
			border="1">	
</td></tr></table>	
			
<cf_screenbottom layout="innerbox">			
	