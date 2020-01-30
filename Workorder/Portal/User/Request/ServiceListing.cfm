
<table width="100%" height="100%" cellpadding="0" cellspacing="0">

	<tr><td height="20" style="padding-top:4px;padding-left:20px">
		<cfoutput>
		<table cellspacing="0" cellpadding="0">
		<tr><td style="padding:2px" height="20px">
		
		<input type="radio" 
		       name="servicemenu" 
			   id="servicesummary"
			   value="Requests" 
			   checked
			   onclick="ColdFusion.navigate('Request/ServiceSummary.cfm?mission=#url.mission#&webapp=#url.id#','servicecontent')">	
			   
			   </td><td>Service Summary</td>
		
		
			   
		<td style="padding:2px 2px 2px 10px">	   
		
		<input type="radio" 
		       name="servicemenu" 
			   id="servicerequest"
			   value="Summary" 
			   onclick="ColdFusion.navigate('Request/RequestListing.cfm?mission=#url.mission#&webapp=#url.id#','servicecontent')">
			   
			   </td><td>Show Requests</td>
		
		</tr>
		</table>
		</cfoutput>
		   
	</td></tr>
	
	<tr><td height="1px" class="line"></td></tr>
	
	<tr><td id="servicecontent" height="99%">	
		<cfinclude template="ServiceSummary.cfm">
	</td></tr>

</table>