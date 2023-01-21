
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

<cfoutput>
<script>
   Prosis.busy('no')
   alert('#session.root#/tools/entityaction/details/actor/setResult.cfm?objectid=#url.objectid#&actioncode=#url.actioncode#')
   ptoken.navigate('#session.root#/tools/entityaction/details/actor/setResult.cfm?objectid=#url.objectid#&actioncode=#url.actioncode#','resultuser')
   
</script>
</cfoutput>
	
