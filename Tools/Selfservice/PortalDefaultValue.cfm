<cfparam name="Attributes.PortalId"         	default="">
<cfparam name="Attributes.Systemfunctionid" 	default="">
<cfparam name="Attributes.Key" 		        	default="">
<cfparam name="Attributes.ResultVar" 	        default="resultkey">

<cfif attributes.SystemFunctionId eq "">
	
	<cfquery name="getPortal" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM   	Ref_ModuleControl
			WHERE  	SystemModule  = 'SelfService'
			AND		FunctionClass = 'SelfService'
			AND		FunctionName  = '#Attributes.PortalId#'
	</cfquery>
	
	<cfquery name="def" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM   	UserModuleCondition
			WHERE  	Account = '#session.acc#'
			AND		SystemFunctionId = '#getPortal.systemFunctionId#'
			AND		ConditionClass = 'Default'
			AND		ConditionField = '#Attributes.Key#'
	</cfquery>

<cfelse>
	
	<cfquery name="def" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM   	UserModuleCondition
			WHERE  	Account = '#session.acc#'
			AND		SystemFunctionId = '#attributes.systemFunctionId#'
			AND		ConditionClass = 'Default'
			AND		ConditionField = '#Attributes.Key#'
	</cfquery>

</cfif>

<cfset vResult = def.ConditionValue>

<cfif lcase(Attributes.Key) eq "date">
	<cfif def.ConditionValue eq 1>
		<cfset vResult = now()>
	</cfif>
	<cfif def.ConditionValue eq 2>
		<cfset vResult = dateAdd('d',1,now())>
	</cfif>
	<cfif def.ConditionValue eq 3>
		<cfset vResult = dateAdd('d',-1,now())>
	</cfif>
	<cfif def.ConditionValue eq 4>
		<cfset vResult = dateAdd('d',0,def.ConditionValue)>
	</cfif>
</cfif>

<cfset "Caller.#Attributes.ResultVar#" = vResult>