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
<cfparam name="url.scope" default="Backoffice">

<cfif url.scope neq "Backoffice">
	 <cfset url.id = CLIENT.personno>
</cfif>

<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="RevertPayroll" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
      UPDATE Payroll.dbo.PersonDependentEntitlement 
	  SET  	 Status      = '9'						   
	  WHERE  PersonNo    = '#PersonNo#'
	  AND    DependentId IN (SELECT DependentId 
	                         FROM   PersonDependent 
							 WHERE  PersonNo     = '#URL.ID#' 
							 AND    ActionStatus = '9')					    
</cfquery>			

<cfparam name="url.action" default="Person">
<cfparam name="url.status" default="Valid">
<cfparam name="url.webapp" default="">

<cfif url.action eq "claim">
<cf_screentop html="no" scroll="yes" jquery="Yes" menuaccess="context"  actionobject="Person"
		actionobjectkeyvalue1="#url.id#">
<cfelse>
<cf_screentop html="no" scroll="yes" jquery="Yes" menuaccess="context"  actionobject="Person"
		actionobjectkeyvalue1="#url.id#">
</cfif>

<table width="96%" align="center">
<tr>		
<td>
	
	<cfif url.action eq "Person">
				
		<cf_actionListingScript>
		<cf_FileLibraryScript>
		<cf_dialogPosition>
		<cfinclude template="EmployeeDependentScript.cfm">	
		<cfset ctr = "1">
		<cfset openmode = "show">
		<cfinclude template="../PersonViewHeaderToggle.cfm">
		<table><tr><td height="1"></td></tr></table>
		
	<cfelseif url.action eq "Claim">	
	
		<cf_actionListingScript>
		<cf_FileLibraryScript>
		<cfinclude template="EmployeeDependentScript.cfm">
			
	</cfif>
	
	<table style="min-width:800px" width="98%" align="center">
	<tr>		
		<td colspan="14" id="contentdependent" style="padding-left:1px;padding-right:1px">
		<cfinclude template="../Dependents/EmployeeDependentDetail.cfm">
		</td>
	</tr>
	</table>	

</td>
</tr>
</table>

