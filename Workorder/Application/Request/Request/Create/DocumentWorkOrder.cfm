
<cfinvoke component = "Service.Access"  
   method           = "WorkOrderProcessor" 
   mission          = "#url.mission#"  
   returnvariable   = "access">
   
       
<cfif access eq "NONE">

    <!--- --------------------------------------------------------------------------------------- --->
    <!--- grant only access to services for the unit the request has access for the selected unit --->
	<!--- -------------- this will apply to regular users requesting for a change --------------- --->

	<cfset link = "getWorkOrderLine.cfm?requestid=#url.requestid#&serviceitem=#url.serviceitem#&accessmode=#url.accessmode#&workorderid=#url.workorderid#&workorderline=#url.workorderline#">	
		
	<table cellspacing="0" cellpadding="0" width="96%">
		<tr>
		
		<!--- if the line is defined do not allow to select it again --->
				
		<cfif url.workorderline eq "" and url.scope neq "portal">
		
		<td width="20">
								
		   <cf_selectlookup
			    box          = "orderline"
				link         = "#link#"
				button       = "Yes"
				title        = "Locate a service line"
				close        = "Yes"		
				filter1      = "orgunit"
				filter1value = "{orgunit}"		
				filter2      = "ServiceItem"
				filter2value = "#url.serviceitem#"	
				filter3      = "W.Mission"
				filter3value = "#url.mission#"						
				icon         = "contract.gif"
				class        = "workorderline"
				des1         = "workorderlineid">
									
		</td>	
		<td width="2"></td>				
		
		</cfif>
		
		<td width="99%"><cfdiv bind="url:#link#" id="orderline"/></td>
		</tr>
	</table>
	
<cfelse>
	
	<cfset link = "getWorkOrderLine.cfm?requestid=#url.requestid#&serviceitem=#url.serviceitem#&accessmode=#url.accessmode#&workorderid=#url.workorderid#&workorderline=#url.workorderline#">	
		
	<table cellspacing="0" cellpadding="0" width="96%">
		<tr>
		
		  <cfif url.scope neq "portal">	
	
			<td width="20">		 	
						
			   <cf_selectlookup
				    box          = "orderline"
					link         = "#link#"
					button       = "Yes"
					title        = "Locate a Service Line"
					close        = "Yes"		
					filter1      = "orgunit"
					filter1value = ""		<!--- {orgunit} --->
					filter2      = "ServiceItem"
					filter2value = "#url.serviceitem#"	
					filter3      = "W.Mission"
					filter3value = "#url.mission#"								
					icon         = "contract.gif"
					class        = "workorderline"
					des1         = "workorderlineid">
					
		    </td>	
		    <td width="2"></td>				
		
		  </cfif>
		 	
		<td width="99%"><cfdiv bind="url:#link#" id="orderline"/></td>
		</tr>
	</table>

</cfif>

<script>	 	  
  document.getElementById('workorderlineid').value = ''	  	
</script>

