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

	<cfparam name="client.Edition" default="">	
	<cfparam name="URL.Edition" default="#CLIENT.Edition#">	
	
	<!--- 25/6/2014 check if this person is potentially a budget manager for any of the edition
	if not we strop access to editions that require just plain data entry
	as these are better from the other screens --->
	
	<cfinvoke component="Service.Access"  
		Method         = "budget"
		ProgramCode    = "#URL.ProgramCode#"
		Period         = "#URL.Period#"			
		Role           = "'BudgetManager'"
		ReturnVariable = "BudgetManager">	
  
	<cfquery name="Edition" 
	datasource="AppsProgram">
	    SELECT   E.*, 
		         R.Description as VersionName
		FROM     Ref_AllotmentEdition E, Ref_AllotmentVersion R
		WHERE    R.Code        = E.Version
		AND      E.Mission     = '#URL.Mission#'
		AND      (
		           Period IN (SELECT Period 
				              FROM   Organization.dbo.Ref_MissionPeriod
							  WHERE  PlanningPeriod = '#url.period#') 
				   OR Period is NULL
				 )
		AND      EditionClass  = 'Budget'	
		
		<cfif BudgetManager eq "NONE">
		AND      BudgetEntryMode = '1'	
		</cfif>		
		ORDER BY E.ListingOrder, R.ListingOrder		
	</cfquery>	 
	
	
	<cfparam name="URL.Version" default="#Edition.Version#">	
	<cfparam name="URL.Edition" default="#CLIENT.Edition#">	

	<cfquery name="Check" 
	datasource="AppsProgram">
    	SELECT *
		FROM   Ref_AllotmentEdition
		WHERE  EditionId = '#URL.Edition#' 
	</cfquery>	 

	<cfif Check.recordCount eq "0">
	   <cfset CLIENT.Edition = Edition.EditionId>
	   <cfset URL.version    = Edition.Version>   
	<cfelse>  
	   <cfset CLIENT.Edition = URL.Edition> 
	   <cfset URL.Version    = Check.Version>
	</cfif> 		
	    
<table cellspacing="0" cellpadding="0" class="formpadding">
	  		
  <cfset ver = "">
  
   <tr>
   <td style="padding-left:10px;padding-right:10px">|</td>
   
	  <cfset st  = "0">
	  <cfset initedition = "">
	   	
	  <cfoutput query="Edition">	
	  
	  		<cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
				Method         = "budget"
				ProgramCode    = "#URL.ProgramCode#"
				Period         = "#URL.Period#"	
				EditionId      = "'#editionID#'"  
				Role           = "'BudgetManager','BudgetOfficer'"
				ReturnVariable = "ListingAccess">	  			  
	       					
			<cfif ListingAccess eq "READ" or ListingAccess eq "EDIT" or ListingAccess eq "ALL">
			
				<cfset st = "1">
				
																				
				<td id="viewmode#currentrow#" class="labelmedium"
				    style="padding-left:7px;cursor: pointer;<cfif client.Edition eq EditionId or initedition eq "">font-weight: bold;</cfif>"
					onclick="document.getElementById('edition').value='#EditionId#';editionselect('#currentrow#');loadform()">					
					<font color="0080C0">#Description#</font> 
				</td>	
				
				<cfif initedition eq "">
					<cfset initedition = editionid>				
					<input type="hidden" name="edition" id="edition" value="#EditionId#">				
				</cfif>
							
				<td style="padding-left:10px;padding-right:10px">|</td>			
									
				<cfset ver = version>		
			
			</cfif>
					
	  </cfoutput>	
  
  <cfif st eq "0">
  	<td class="labelit" style="padding-left:4px"><font color="FF0000">No access granted to any edition for planning period <cfoutput>#URL.Period#</cfoutput></td>
  </cfif> 
  				
   <tr>
	  
</table>	
	