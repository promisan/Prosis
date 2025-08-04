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
<cfparam name="url.mission"  default="">


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

<table><tr class="labelmedium2">

<cfoutput>

	<cfif Param.OvertimePayroll eq "0">
	
	    <cfparam name="url.selected" default="0">
	
		<td><INPUT type="radio" onclick="salarytrigger()" class="radiol enterastab" name="OvertimePayment" value="0" checked></td>
		<td style="padding-left:6px;padding-top:3px">#vCompensation#</td>
		<td style="padding-left:7px"><INPUT id="payment" onclick="salarytrigger()" type="radio" class="radiol" name="OvertimePayment" value="1" disabled></td>
		<td style="padding-left:6px;padding-top:3px">#vPayroll#</td>
	
	<cfelse>
	
		<cfparam name="url.selected" default="1">

		<td style="padding-left:7px"><INPUT id="payment" onclick="salarytrigger();document.getElementById('currencydate').className = 'regular'" type="radio" class="radiol enterastab" name="OvertimePayment" value="1" <cfif url.selected neq "0">checked</cfif>></td>
		<td style="padding-left:6px;padding-top:3px">#vPayroll#</td>
		<td><INPUT type="radio" onclick="salarytrigger(); document.getElementById('currencydate').className = 'regular'" class="radiol enterastab" name="OvertimePayment" value="0" <cfif url.selected eq "0">checked</cfif>></td>	
		<td style="padding-left:6px;padding-top:3px">#vCompensation#</td>
	
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
