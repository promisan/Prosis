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
 <cfquery name="Result" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT TOP 10 *
	  FROM Job
	  WHERE 1=1 <!--- ActionStatus = '0' --->
	  AND   Mission = '#URL.Mission#'
	  <cfif getAdministrator(url.mission) eq "1">
			<!--- no filtering --->
	  <cfelse>
	  AND  JobNo IN (SELECT JobNo FROM JobActor WHERE ActorUserId = '#SESSION.acc#')
	  </cfif>
	  AND (
	  JobNo LIKE '%#url.val#%'
	  OR 
	  CaseNo LIKE '%#url.val#%'
	   OR 
	  Description LIKE '%#url.val#%'
	  OR
	  JobNo IN (SELECT  JobNo 
	            FROM    RequisitionLineQuote 
				WHERE   OrgUnitVendor IN (SELECT OrgUnit
	                                      FROM Organization.dbo.Organization 
										  WHERE OrgUnitName LIKE '%#url.val#%'
										 )
				)						  
	  )	  
</cfquery>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/> 

<table width="96%" align="right" class="formpadding">
	<cfoutput query="result">
	<tr class="labelmedium2 linedotted">
	   <td>#currentrow#.</td>
	   <td><a href="RequisitionViewBuyerOpen.cfm?ID=JOB&ID1=#JobNo#&mid=#mid#" target="right" title="#Description#">#CaseNo# (#jobNo#)</a></td>
	</tr>
</cfoutput>
</table>