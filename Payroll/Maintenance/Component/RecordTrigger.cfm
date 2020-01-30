
<cfquery name="get"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *, R.Description as TriggerDescription
	FROM     Ref_PayrollComponent C, 
	         Ref_PayrollTrigger R, 
			 Ref_PayrollItem I
	WHERE    R.SalaryTrigger = C.SalaryTrigger
	AND      C.PayrollItem = I.PayrollItem
	AND      C.Code = '#URL.ID1#'
	ORDER BY R.TriggerGroup,R.SalaryTrigger, ListingOrder DESC
</cfquery>

<cfquery name="SalaryTrigger"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_PayrollTrigger
	WHERE  SalaryTrigger = '#url.id#'
</cfquery>

<!---
<cfif SalaryTrigger.entitlementClass eq "Rate">
--->

   <table cellspacing="0" cellpadding="0">

   <tr>
   
	   <td><INPUT class="radiol" type="radio" name="Period" onclick="apply('rate')" value="YEAR"    <cfif "YEAR" eq get.Period>checked</cfif>></td>
	   <td class="labelit" style="padding-left:5px">YEAR</td>   
	   
	   <td style="padding-left:5px"><INPUT class="radiol" onclick="apply('rate')" type="radio" name="Period" value="MONTH"   <cfif "MONTH" eq get.Period or get.Period eq "">checked</cfif>></td>
	   <td class="labelit" style="padding-left:5px">MONTH</td>
	   
	   <td style="padding-left:5px"><INPUT class="radiol" onclick="apply('rate')" type="radio" name="Period" value="DAY"     <cfif "DAY" eq get.Period>checked</cfif>></td> 
	   <td class="labelit" style="padding-left:5px">DAY</td>
	
	   <td style="padding-left:8px"><INPUT class="radiol" onclick="apply('rate')" type="radio" name="Period" value="HOUR"    <cfif "HOUR" eq get.Period>checked</cfif>> </td>
	   <td class="labelit" style="padding-left:5px">HOUR</td>
	   
	     <td style="padding-left:8px"><INPUT class="radiol" onclick="apply('percent')" type="radio" name="Period" value="PERCENT"  <cfif "PERCENT" eq get.Period>checked</cfif>> </td>
	   <td class="labelit" style="padding-left:5px">PERCENTAGE</td>
   
   </tr>
      
	</table>

<!---     
<cfelse>

	<table><tr class="labelmedium"><td>
      
   <INPUT type="hidden" name="Period" value="PERCENT"> PERCENT
   
   </td></tr></table>
 
</cfif>   
--->

	