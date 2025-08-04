<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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

