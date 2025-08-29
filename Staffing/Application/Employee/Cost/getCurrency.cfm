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
<cfoutput>

<cfparam name="url.currency" default="">

<cfquery name="Currency" 
datasource="AppsLedger"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Currency
</cfquery>

<cfif url.currency eq "">
	
	<cfquery name="SalarySchedule" 
	datasource="AppsPayroll"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  SalarySchedule
		WHERE SalarySchedule IN (SELECT   TOP 1 SalarySchedule 
							     FROM     Employee.dbo.PersonContract
								 WHERE    ActionStatus = '1'
								 AND      PersonNo = '#URL.ID#'
								 ORDER BY Created DESC)
	</cfquery>
	
	<cfif salaryschedule.paymentCurrency neq "">
	       <cfset cur = salaryschedule.paymentCurrency>
	<cfelse>
	       <cfset cur = APPLICATION.BaseCurrency>
	</cfif>
	
	<select name="Currency" size="1" class="regularxxl enterastab" style="border:0px;width:100%">
		<option value=""></option>
		<cfloop query="Currency">
		<option value="#Currency#" <cfif cur eq Currency>selected</cfif>>#Currency#</option>
		</cfloop>
	</select>
	
<cfelse>
	
	#url.currency#
	<input type="hidden" name="Currency" value="#url.currency#" style="border:0px;width:100%">
	
</cfif>	

</cfoutput>