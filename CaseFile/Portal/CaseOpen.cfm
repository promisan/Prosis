
<cfparam name="url.template" default="Listing/CaseListing.cfm">
<cfparam name="url.mission"  default="OHRM">
<cfparam name="url.scope"    default="Portal">

<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">

	<tr>
		<td width="100%" height="100%" valign="top" style="padding:8px">			
		
		<cfoutput>
		
		    <iframe src="#Client.VirtualDir#/CaseFile/Portal/#url.template#?mission=#url.mission#&webapp=#url.webapp#&scope=#url.scope#" 
			   width="100%" 
			   height="100%" 
			   marginwidth="4" marginheight="4" scrolling="no" frameborder="0">
			 </iframe>
			 
		</cfoutput>	
			
		</td>
	</tr>
</table>