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
<cfquery name="Prior" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT   OA.*, A.ActionDescription
	   FROM     OrganizationObjectAction OA, Ref_EntityAction A
	   WHERE    OA.ActionId      = '#memoactionid#'
	   AND      OA.ActionStatus >= '2'
	   AND      A.ActionCode = OA.ActionCode
	   ORDER BY OA.CREATED DESC 
	</cfquery>

<cfoutput>

 <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding"  style="height:100%">
					        
   		    <tr><td height="19" align="center" bgcolor="0D86FF" class="labelmedium"><font color="FFFFFF">Prepared Documents under step <b>#Prior.ActionDescription#</b> (#Prior.OfficerFirstName# #Prior.OfficerLastName#)</td></tr>				  
										
			<tr><td>
												
				<cfinclude template="ProcessActionPriorDocument.cfm">
					
			</td></tr>								
			
	</table>	
	
</cfoutput>	