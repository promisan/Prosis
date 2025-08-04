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

<cfparam name="url.trigger" default="">

<table width="96%" align="center" class="navigation_table">

<cfquery name="SearchResult"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *,  
	        R.Description as TriggerDescription
	FROM    Ref_PayrollComponent C,
	        Ref_PayrollTrigger R, 
			Ref_PayrollItem I
	WHERE   R.SalaryTrigger = C.SalaryTrigger
	AND     C.PayrollItem = I.PayrollItem
	<cfif url.trigger neq "">
	AND     R.SalaryTrigger = '#url.trigger#'
	</cfif>
	ORDER BY R.TriggerGroup,R.SalaryTrigger, C.EntitlementPointer, ListingOrder DESC
</cfquery>

<tr class="labelmedium2 fixrow fixlengthlist">
    <td></td>
	<td><cf_tl id="Description"></td>
	<td><cf_tl id="M"></td>
	<td><cf_tl id="Rate"></td>
	<td><cf_tl id="Trigger Group"></td>
	<td><cf_tl id="P"></td>
	<td><cf_tl id="R"></td>
	<td><cf_tl id="Period"></td>
	<td><cf_tl id="Settlement Presentation"></td>		  
</tr>

<cfoutput query="SearchResult" group="TriggerGroup">

	<tr class="fixrow2 labelmedium2 fixlengthlist">
	<td colspan="9" style="height:45px;font-size:30px;padding-left:10px">#TriggerGroup#</td></tr>
	
	<cfoutput group="SalaryTrigger">
	
	<tr class="line fixrow3 labelmedium2 fixlengthlist">
	    <td colspan="9" style="font-size:18px;padding-left:30px;height:30px;top:65px;">#TriggerDescription#</td></tr>
		
		<cfoutput group="EntitlementPointer">  
		
		<cfoutput>     
						
			<cfif operational eq "0">
				<tr bgcolor="f2f2f2" class="navigation_row labelmedium2 fixlengthlist"> 
			<cfelse>
				<tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('ffffff'))#" class="navigation_row labelmedium2 fixlengthlist"> 
			</cfif> 
		    
				<td align="center" style="padding-left:10px;padding-top:1px;">
				<cf_img icon="open" navigation="yes" onclick="recordedit('#Code#')">
				</td>	
				<td>#Description#</td>
				<td><cfif triggergroup neq "Personal">#SalaryMultiplier#</cfif></td>
				<td><cfif triggergroup neq "Personal">#Period#</cfif></td>
				<td>#EntitlementGroup#</td>
				<td><cfif period eq "Percent">#triggerconditionpointer#<cfelse>#EntitlementPointer#</cfif></td>
				<td><cfif period neq "Percent" and triggergroup neq "Personal">
				<cfif RateStep eq "9">FL<cfelseif RateStep eq "1">GR<cfelse>ST</cfif>
				
				</cfif></td>
				<td><cfif SalaryDays eq "1">All<cfelse>SLWOP</cfif></td>
				<td>#PayrollItemName#</td>
				
			</tr>	
			
			<cfquery name="Usage"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  DISTINCT SalarySchedule
			FROM    SalaryScheduleComponent
			WHERE   ComponentName = '#Code#'
			ORDER BY SalarySchedule
			</cfquery>
			
			<cfif Usage.recordcount gte "1">
			
			    <tr style="height:20px">
			    <td></td>
			    <td style="border-top:1px solid dadada" colspan="9"><cfloop query="Usage">
				<font color="008000">				
				#SalarySchedule#&nbsp;|&nbsp;</font></cfloop></td>
				</tr>
			
			</cfif>
			
			<tr><td class="line" colspan="10"></td></tr>
						
		</CFOUTPUT>		
							
		</CFOUTPUT>	
				
	
	</CFOUTPUT>
	
</CFOUTPUT>

</table>

<cfset ajaxonload("doHighlight")>