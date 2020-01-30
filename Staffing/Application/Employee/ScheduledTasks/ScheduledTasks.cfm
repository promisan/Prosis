
<cf_screentop height="100%" html="No" scroll="Yes" menuaccess="context" actionobject="Person"
		actionobjectkeyvalue1="#url.id1#">

<cf_ListingScript>

<cfoutput>
	
	<cfparam name="URL.Mode" default="records">
	
	<link rel="stylesheet" type="text/css" href="#SESSION.root#/<cfoutput>#client.style#</cfoutput>">
	
	<table width="100%" height="100%" align="center" cellspacing="0" cellpadding="0">
	
		<tr>
			<td height="10" style="padding-left:7px">	
				  <cfset ctr      = "0">		
			      <cfset openmode = "open"> 
				  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
			</td>
		</tr>	
		
		<tr>
			<td height="100%" width="100%" align="center">
				<table width="100%" height="100%" cellspacing="0" cellpadding="0">
					<tr>
						<td style="padding-left:10px;padding-right:15px">
							<cfinclude template="ScheduledTasksListingContent.cfm">
						</td>
					</tr>
				</table>	
			</td>
		</tr>
	</table>

</cfoutput>
