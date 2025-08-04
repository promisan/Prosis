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

<cfif URL.View eq "All">	
	 	<cfset rows = "999">
<cfelse>
		<cfset rows = "1">
</cfif>

<cfquery name="Total" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT    <cfloop query="resource">
				  sum(Ceiling_#currentrow#) as Ceiling_#currentrow#,
		          sum(Resource_#currentRow#) as Resource_#currentRow#, 
		          </cfloop>Sum(Total) as Total		
		FROM      dbo.tmp#SESSION.acc#Allotment#FileNo#		
		
</cfquery>	
	
<cfquery name="SearchResult"
        datasource="AppsOrganization"
		maxrows="#rows#"
		username="#SESSION.login#"
        password="#SESSION.dbpw#">
	    	SELECT   *
		    FROM     userquery.dbo.tmp#SESSION.acc#Allotment#FileNo# V 		
		    ORDER BY V.ReferenceBudget1,
			         V.ReferenceBudget2,
					 V.ReferenceBudget3,
					 V.ReferenceBudget4,
					 V.ReferenceBudget5,
					 V.ReferenceBudget6
</cfquery>

<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table">

<TR>
 <td width="7%" height="18"></td>
 <TD class="labelit"><cf_space class="labelit" spaces="40" label="Code"></TD>
 <td class="labelit" colspan="3" width="70%" style="border-right: 1px solid Silver;"><cf_tl id="Program Name"></td>
 <cfloop query="Resource">
	<cfoutput>	    
	    <td class="labelit" align="right" style="cursor:pointer;border-right: 1px solid Silver;">
		<cf_space spaces="20" class="labelit" label="#Name#" align="right">		
	</cfoutput>
 </cfloop>
 <td class="labelit" align="right" width="80" style="border-right: 1px solid Silver;">
 <cf_space spaces="20" class="labelit" align="right" label="Total">
 </td>
</TR>

<tr><td class="labelit" colspan="<cfoutput>#resource.recordcount+6#</cfoutput>"></td></tr>

<cfoutput query="Total">

	    <tr><td class="labelit" colspan="5">&nbsp;	<cf_tl id="Total"></td>
		
		<cfloop index="item" from="1" to="#Resource.RecordCount#" step="1">
				
					<cfset cei = Evaluate("Ceiling_" & Item)>
					<cfset amt = Evaluate("Resource_" & Item)>
						
					<cfif cei gt "0" and cei lt amt and amt neq "">
					    <td align="right" class="highlight5" style="border-right: 1px solid silver;">						
					<cfelse>
						<td align="right" class="labelit" style="border-right: 1px solid silver;">
					</cfif>	
					
						<cfif Parameter.BudgetAmountMode eq "0">
							<cf_numbertoformat amount="#amt#" present="1" format="number0">
						<cfelse>
							<cf_numbertoformat amount="#amt#" present="1000" format="number1">
						</cfif> 	
						#val#
					</td>
		    						
				</cfloop>
											
				<td align="right" class="labelit" style="border-right: 1px solid Silver;">
				
				<cfif Parameter.BudgetAmountMode eq "0">
					<cf_numbertoformat amount="#total#" present="1" format="number0">
				<cfelse>
					<cf_numbertoformat amount="#total#" present="1000" format="number1">
				</cfif> 	
				#val#
								
			  </td>

		  </tr>
			  
</cfoutput>

<cfoutput query="SearchResult">
   
   <cfset color = "f1f1f1">
  
   <cfif searchresult.total gte "">
   			
	    <cfif Parameter.EnableGlobalProgram>
		
			<cfquery name="Children" 
	        datasource="AppsQuery" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
		    SELECT *
		    FROM   tmp#SESSION.acc#Allotment#FileNo# 
		    WHERE  ProgramHierarchy LIKE '#ProgramHierarchy#%' 
		    AND    ProgramScope = 'Unit'
			AND    OrgUnit = '#OrgUnit#' 
		    </cfquery>
		
		<cfelse>
		    <cfset Children.recordcount = "1">
		</cfif>
	
		<cfif Children.recordcount gte "1">				
		    <cfinclude template="AllotmentViewListingDetail.cfm"> 
		</cfif>	 	
			 
	</cfif>	 

</CFOUTPUT>

<cfoutput>
	<tr><td colspan="#Resource.RecordCount+6#" class="line"></td></tr> 
</cfoutput>

</table>
