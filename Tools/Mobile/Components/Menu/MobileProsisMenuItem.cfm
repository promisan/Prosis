<cfparam name="attributes.appId"				default="">
<cfparam name="attributes.mission"				default="">
<cfparam name="attributes.functionId"			default="">

<cfquery name="getElement" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		SELECT  M.*,
				ISNULL((
					SELECT 	COUNT(*)
					FROM	Ref_ModuleControlSection
					WHERE	SystemFunctionId = M.SystemFunctionId
				), 0) as HasSections
		FROM    #client.lanPrefix#Ref_ModuleControl M 
		WHERE	M.SystemFunctionId = '#attributes.functionId#'
</cfquery>

<cfoutput query="getElement">

	<cfset vParams= "">
	<cfif trim(functionCondition) neq "">
		<cfset vParams= "&#functionCondition#">
	</cfif>
	
	<cfset vBaseURL = "#session.root#/#functionDirectory##functionPath#">
	<cfif HasSections gt 0>
		<cfset vBaseURL = "#session.root#/Portal/Mobile/Dashboard/Dashboard.cfm">
	</cfif>

	<cfinvoke component="Service.Access"  
		method="function"  
		SystemFunctionId="#attributes.functionId#" 
		Mission="#attributes.mission#"
		returnvariable="access">

	<cfset vURL = "#session.root#/portal/mobile/noaccess.cfm">
	<cfif access eq "GRANTED">
		<cfset vURL = "#vBaseURL#?mission=#attributes.mission#&appId=#attributes.appId#&systemfunctionId=#attributes.functionId##vParams#">
	</cfif>
	
	<cf_mobileMenuItem 
		description="#FunctionMemo#"
		reference="javascript:ptoken.navigate('#vURL#','mainContainer');">
	</cf_mobileMenuItem>

</cfoutput>