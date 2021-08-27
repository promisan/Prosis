
<cfoutput>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	
	<tr class="hide"><td id="boxsend"></td></tr>
	
	<tr><td height="100%" style="border:0px solid silver">
		<cf_getMId>
		<iframe src="BroadCastBody.cfm?id=#url.id#&mode=#url.mode#&readonly=#url.readonly#&sourcepath=#URL.sourcepath#&ts=#now()#&mid=#mid#"
		   id="savebody"
		   name="savebody" 
		   width="100%" 
		   height="100%" 
		   marginwidth="0" 
		   marginheight="0"
		   frameborder="0"></iframe>
		   
	</td></tr>
	
</table>
</cfoutput>