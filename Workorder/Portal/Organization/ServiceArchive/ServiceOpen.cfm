
<table cellpadding="0" cellspacing="0" border="0" align="center" width="100%" height="100%">

	<tr>
		<td width="100%" height="100%" style="padding-left:8px;padding-right:8px;padding-bottom:5px;padding-top:5px">	
								
		<!--- open the app in its own iframe --->
		
		<cfoutput>
		
		<iframe src="#SESSION.root#/WorkOrder/Portal/Organization/ServiceArchive/ServiceListing.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
        	width="100%"
	        height="100%"
    	    scrolling="no"
        	frameborder="0"/>		
			
		</cfoutput>	
							
		</td>
	</tr>
	
</table>