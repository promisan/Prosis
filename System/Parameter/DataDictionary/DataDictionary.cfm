
<cf_screenTop height="100%" 
    title="#SESSION.welcome# Data dictionary of CF datasources" 
    label="#SESSION.welcome# <b>Data dictionary</b> of CF datasources" 
	option="#SESSION.welcome# datasources" 
	html="Yes" 
	band="No" 
	scroll="no" 	
	MenuAccess="Yes" 
	layout="webapp" 
	banner="gray">

<cfoutput>	

<table width="98%" height="100%" align="center">

<cfif CGI.HTTPS eq "off">
     <cfset protocol = "http">
<cfelse> 
  	<cfset protocol = "https">
</cfif>

<cfset protocol = "http">

<tr class="hide"><td height="0">
  <iframe name="flex2gateway" src="#protocol#://#CGI.HTTP_HOST#/flex2gateway"
   frameborder="0" scrolling="no" width="22" height="0">
   </iframe> 
</td></tr>

<tr><td align="center" width="100%" style="padding-top:10px">

		<iframe src="DataDictionaryContent.cfm" name="invokedetail" id="invokedetail" width="100%" height="100%" scrolling="no" frameborder="0">				
		</iframe>	
			
								
</td></tr>
</table>	
</cfoutput>


