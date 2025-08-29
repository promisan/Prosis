<!--
    Copyright © 2025 Promisan B.V.

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
<cfquery name="Person" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    *
    FROM      Employee.dbo.Person
	WHERE     PersonNo = '#url.personno#'	
</cfquery>

<cfif person.birthdate gte "01/01/1900">
     <CF_DateConvert Value="#dateformat(person.birthdate,client.dateformatshow)#">
	 <cfset dob = datevalue>
	<cfset age = dateDiff("yyyy",dob,now())>
<cfelse>
	<cfset age = 0>
</cfif>	

<cfquery name="getTrigger" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    *
    FROM      Ref_PayrollTrigger
	WHERE     SalaryTrigger  =  '#url.trigger#'
</cfquery>

<cfif getTrigger.EnableAmount eq "0">
		
		<cfquery name="Group" 
		datasource="AppsPayroll"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		   SELECT    DISTINCT S.EntitlementGroup,
		             G.EntitlementName,
					 ApplyMode, 
					 ApplyRangeFrom, 
					 ApplyRangeTo, 
					 G.ListingOrder
		   FROM      SalaryScheduleComponent S, 
			         Ref_PayrollComponent C,
					 Ref_PayrollTriggerGroup G
		   WHERE     C.Code              =  S.ComponentName
		   AND       G.EntitlementGroup  =  C.EntitlementGroup
		   AND       G.SalaryTrigger     =  C.SalaryTrigger
		   AND       S.SalarySchedule    =  '#url.schedule#'
		   AND       C.SalaryTrigger     =  '#url.trigger#'	
		   ORDER BY  G.ListingOrder 
		
		</cfquery>
		
<cfelse>
	
	<cfquery name="Group" 
	datasource="AppsPayroll"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    *
	    FROM      Ref_PayrollTriggerGroup
		WHERE     SalaryTrigger     =  '#url.trigger#'	
		ORDER BY  ListingOrder 
	</cfquery>

</cfif>

<cfif group.recordcount eq "1">

    <cfoutput>
	<input type="hidden" name="EntitlementGroup" id="EntitlementGroup" value="#group.EntitlementGroup#">
	</cfoutput>
	
<cfelse>
	
	<select name="EntitlementGroup" id="EntitlementGroup" class="enterastab regularxl" style="width:180px">
	    <cfoutput query="Group">							
			<cfif applyMode eq "DOB">		
			    <cfif age gte ApplyRangeFrom and age lte applyRangeTo>
					<option value="#EntitlementGroup#"><cfif EntitlementName neq "">#EntitlementName#<cfelse>#EntitlementGroup#</cfif></option>
				</cfif>				
			<cfelse>
			    <option value="#EntitlementGroup#"><cfif EntitlementName neq "">#EntitlementName#<cfelse>#EntitlementGroup#</cfif></option>
			</cfif>	
		</cfoutput>
	</select>

</cfif>

<cfoutput>

<cfif getTrigger.triggerdependent eq gettrigger.salarytrigger 
	and getTrigger.TriggerCondition eq "Dependent">

	<script>
		document.getElementById("dependentbox").className = "regular"
		ptoken.navigate('getEntitlementDependent.cfm?id=#url.personno#&salarytrigger=#url.trigger#','dependentcontent')
	</script>
	
<cfelse>	

	<script>
		document.getElementById("dependentbox").className = "hide"
	</script>

</cfif>

</cfoutput>