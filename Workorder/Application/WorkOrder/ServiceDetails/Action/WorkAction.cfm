
<cfparam name="url.header" default="Yes">
<cfparam name="url.embed"  default="No">

<cfoutput>

<table width="100%" height="100%">
	
	<cfif url.header eq "Yes">
	
		<tr class="line"><td height="20" style="padding-bottom:5px;padding-top:4px;padding-left:10px">
			
			<table cellspacing="0" cellpadding="0">
			
				<tr>
				
					<td><input type="radio" name="actionselect" value="Manual" checked 
					    onclick="ColdFusion.navigate('#session.root#/WorkOrder/Application/Workorder/ServiceDetails/Action/WorkActionListing.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#','actioncontent')"></td>
					<td style="padding-left:4px" class="labelmedium"><cf_tl id="Manually recorded"></td>
					
					<td style="padding-left:10px">
					   <input type="radio" name="actionselect" value="All"
						onclick="ColdFusion.navigate('#session.root#/WorkOrder/Application/Workorder/ServiceDetails/Action/WorkActionContent.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#','actioncontent')"></td>
					<td style="padding-left:4px" class="labelmedium"><cf_tl id="Scheduled and manually recorded"></td>
					
				</tr>
			
			</table>	
			
			</td>
			
		</tr>	
					
	</cfif>
	
	<tr>	
	
	    <cfif url.embed eq "no">
		<td width="100%" height="100%" valign="top">
	    <cf_divscroll id="actioncontent">			
			<cfinclude template="WorkActionListing.cfm">
		</cf_divscroll>
		</td>
		<cfelse>
		<td width="100%" height="100%" valign="top" id="actioncontent">				
		    <cfinclude template="WorkActionListing.cfm">
		</td>	
		</cfif>
		
	</tr>

</table>

</cfoutput>