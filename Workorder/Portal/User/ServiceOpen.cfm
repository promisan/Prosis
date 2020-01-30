
<cfparam name="url.template" default="usage/menuServiceLayout.cfm">
<cfparam name="url.id"       default="muc">
<cfparam name="url.width"    default="#client.width#">
<cfparam name="url.height"   default="#client.height#">

<table cellpadding="0" cellspacing="0" border="0" style="width:100%;min-height:100%;height:100%">

	<tr>

		<td style="width:100%;min-height:100%;height:100%" valign="top">
						
		<cfoutput>
		    <iframe id   = "ServiceViewOpen" 
			        name = "ServiceViewOpen" 
					src  = "#SESSION.root#/workorder/portal/user/#url.template#?mission=#url.mission#&scope=portal&webapp=#url.webapp#&id=#url.id#&width=#url.width#&height=#url.height#" 
			        style="width:100%;height:100%"
					marginwidth="0" 
					marginheight="0" 
					scrolling="no" 
					frameborder="0">
			 </iframe>
			 
		</cfoutput>	
			
		</td>
	</tr>
</table>