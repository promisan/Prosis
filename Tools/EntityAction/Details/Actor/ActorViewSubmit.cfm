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
<cfset dec = evaluate("Form.#url.userAccount#_Decision")>
<cfset mem = evaluate("Form.#url.userAccount#_DecisionMemo")>

<cf_assignId>

<cfif dec neq "">
	
	<cfquery name="Insert" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		INSERT INTO OrganizationObjectActionAccessProcess
		(ObjectActorId,ObjectId, ActionCode, UserAccount, Decision, DecisionMemo, OfficerUserId, OfficerLastName, OfficerFirstName)
		VALUES
		('#rowguid#','#url.objectid#','#url.actioncode#','#url.useraccount#','#dec#','#mem#','#session.acc#','#session.last#','#session.first#')
		
	</cfquery>

</cfif>

<script>
	Prosis.busy('no')
</script>

<table width="100%"><tr><td>

<cfinclude template="ActorViewContent.cfm">

</td></tr>

<cfoutput>
<tr class="labelmedium">
     <td style="font-size:22px;font-weight:bold;padding-top:15px" align="center">Thank you for your submission #session.first#, you may close this screen now.</td>
</tr>
</cfoutput>
</table>



<!---

<cfoutput>
<script>
   Prosis.busy('no')  
   ptoken.navigate('#session.root#/tools/entityaction/details/actor/ActorView.cfm?objectid=#url.objectid#&actioncode=#url.actioncode#','resultuser')   
</script>
</cfoutput>

--->
	
