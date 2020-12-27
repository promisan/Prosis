
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