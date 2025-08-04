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

<cfparam name="url.selected" default="">
<cfparam name="url.dob"      default="">

<cfif url.dob neq "">
	<cftry>
	    <CF_DateConvert Value="#url.dob#">
		<cfset dob = dateValue>
		<cfset age = dateDiff("yyyy",dob,now())>	
	<cfcatch>
		<cfset age = "0">
	</cfcatch>
	</cftry>
<cfelse>
	<cfset age = 0>   
</cfif>

<cfquery name="getTrigger" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Payroll.dbo.Ref_PayrollTrigger 
		WHERE	SalaryTrigger = '#url.SalaryTrigger#'
	</cfquery>

<cfquery name="GroupList" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	  SELECT    *
	  FROM      Ref_PayrollTriggerGroup G
	  WHERE     SalaryTrigger = '#url.SalaryTrigger#'	
	  <!--- has indeed occurences relevant for this person --->
							
	  AND       EXISTS (SELECT    'X'
						FROM      SalaryScheduleComponent SL INNER JOIN Ref_PayrollComponent C ON SL.ComponentName = C.Code
					    WHERE     C.SalaryTrigger    = G.SalaryTrigger	
						AND       C.EntitlementGroup = G.EntitlementGroup											
						AND       SL.SalarySchedule IN (SELECT  SalarySchedule
					                                    FROM    Employee.dbo.PersonContract
						                                WHERE   PersonNo        = '#url.id#' 
											    		AND     SalarySchedule  = SL.SalarySchedule
													    AND     ActionStatus IN ('0','1')
													 
													    UNION 													 
													 
													    SELECT  PostSalarySchedule
					                                    FROM    Employee.dbo.PersonContractAdjustment
						                                WHERE   PersonNo            = '#url.id#' 
													    AND     PostSalarySchedule  = SL.SalarySchedule
													    AND     ActionStatus IN ('0','1')
	 											       )												
						)
						
												
	  ORDER BY  ListingOrder	 			
	  
</cfquery>	  

<!--- we might want to filter this for components that are enabled for the triggergroups, there could be groups that are not carried by
a component anymore, but this is more relevant in the schedule is selected, but we could --->

<cfoutput>

	<cfif GroupList.recordcount gte "1">
								
	<select name="EntitlementGroup#url.tag#" size="1"  class="regularxl" style="width:200px">
		
		<cfloop query="GroupList">			
		    <cfif url.selected eq EntitlementGroup>
			    <!--- if a value was selected in the past we always show it !! ---> 
			    <option value="#EntitlementGroup#" selected><cfif entitlementName neq "">#EntitlementName#<cfelse>#EntitlementGroup#</cfif></option>
			<cfelseif applyMode eq "DOB">		
			    <cfif age eq "0">
				    <!--- we show all --->
				    <option value="#EntitlementGroup#"><cfif entitlementName neq "">#EntitlementName#<cfelse>#EntitlementGroup#</cfif></option>
				<cfelse>
				    <cfif age gte ApplyRangeFrom and age lte applyRangeTo>
						<option value="#EntitlementGroup#"><cfif entitlementName neq "">#EntitlementName#<cfelse>#EntitlementGroup#</cfif></option>
					</cfif>				
				</cfif>	
			<cfelse>
			   <option value="#EntitlementGroup#">
			   		<cfif entitlementName neq "">#EntitlementName#<cfelse>#EntitlementGroup#</cfif></option>
			</cfif>			
		</cfloop>
		
	</select>
	
	<cfelseif GroupList.recordcount eq 1> 
		<input type="hidden" name="EntitlementGroup#url.tag#" value="#GroupList.EntitlementGroup#" style="width:200px"> 
	<cfelse> 
		<input type="hidden" name="EntitlementGroup#url.tag#" value="Standard" style="width:200px"> 
	</cfif>
 
</cfoutput> 			
		