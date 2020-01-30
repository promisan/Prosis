<cfparam name="url.mission"  default="">
<cfparam name="url.selected" default="0">

<cfquery name="Param" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   * 
    FROM     Ref_ParameterMission
	WHERE    Mission = '#url.mission#'	
</cfquery>

<cf_tl id="Compensatory Time Off" var="vCompensation">
<cf_tl id="Overtime Payment" var="vPayroll">

<table><tr class="labelmedium">

<cfoutput>

	<cfif Param.OvertimePayroll eq "0">
	
		<td><INPUT type="radio" onclick="salarytrigger()" class="radiol enterastab" name="OvertimePayment" value="0" checked></td>
		<td style="padding-left:6px">#vCompensation#</td>
		<td style="padding-left:7px"><INPUT id="payment" onclick="salarytrigger()" type="radio" class="radiol" name="OvertimePayment" value="1" disabled></td>
		<td style="padding-left:6px">#vPayroll#</td>
	
	<cfelse>
	
		<td><INPUT type="radio" onclick="salarytrigger(); document.getElementById('currencydate').className = 'regular'" class="radiol enterastab" name="OvertimePayment" value="0" <cfif url.selected neq "1">checked</cfif>></td>	
		<td style="padding-left:6px">#vCompensation#</td>
		<td style="padding-left:7px"><INPUT id="payment" onclick="salarytrigger();document.getElementById('currencydate').className = 'regular'" type="radio" class="radiol enterastab" name="OvertimePayment" value="1" <cfif url.selected eq "1">checked</cfif>></td>
		<td style="padding-left:6px">#vPayroll#</td>
	
	</cfif>

</cfoutput>

<cfif url.selected eq "1">

	<script>
	     try {
		 document.getElementById('currencydate').className = "regular" } catch(e) {}
	</script>

<cfelse>

	<script>
	     try {
		 document.getElementById('currencydate').className = "regular" } catch(e) {}
	</script>


</cfif>

</td></tr></table>
