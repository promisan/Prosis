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
<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="gray" 
			  title="Contract" 			  
			  label="Contract" 
			  line="no"
			  html="No"
			  jquery="yes" user="no">

<cfquery name="get"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT      R.SalaryTrigger, R.ContractType, C.ContractType as Code, C.Description, R.Operational, R.OfficerUserId, R.OfficerLastName, R.OfficerFirstName, R.Created
  FROM        Ref_PayrollTriggerContractType AS R RIGHT OUTER JOIN
              Employee.dbo.Ref_ContractType AS C ON R.ContractType = C.ContractType AND SalaryTrigger = '#URL.SalaryTrigger#'	
  	
</cfquery>

<table class="hide">
	<tr><td><iframe name="frmContractSubmit" id="frmContractSubmit"></iframe></td></tr>
</table>

<cfform name="frmTriggerGroup" action="#session.root#/payroll/maintenance/trigger/Contract/RecordSubmit.cfm?SalaryTrigger=#url.SalaryTrigger#" target="frmContractSubmit">
	
		<table style="width:96%" align="center" class="formpadding navigation_table">
		
		<tr class="labelmedium2 line">
				<td><cf_tl id="Type">:</td>
				<td><cf_tl id="Description">:</td>
				<td align="right" style="padding-right:4px"><cf_tl id="Select">:</td>
		</tr>		
		
		   <cfoutput query="get">
		    
			<tr class="labelmedium2 line navigation_row" style="height:20px">
				<td>#Code#</td>
				<td>#Description#</td>
				<td align="right" style="padding-right:4px"><input type="checkbox" class="radiol" name="Contract" value="#Code#" <cfif code eq contracttype>checked</cfif>></td>
			</tr>
			</cfoutput>
						
			<tr>
				<td colspan="3" align="center">
					<cf_tl id="Save" var="1">
					<cfoutput>
						<input type="submit" name="btnSubmit" id="btnSubmit" value="#lt_text#" class="button10g">
					</cfoutput>
				</td>
			</tr>
		</table>
	
</cfform>