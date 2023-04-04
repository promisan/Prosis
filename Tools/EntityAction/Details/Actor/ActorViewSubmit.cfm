
<!--- actors we obtain the enabled fly-actors for this action and allow them to record inputs (descision and comment --->

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
	
