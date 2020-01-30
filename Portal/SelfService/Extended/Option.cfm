
<cfoutput>

<cfquery name="Open"
	datasource="AppsSystem"
	username="#SESSION.login#"
	Password="#SESSION.dbpw#">
	SELECT	*
	FROM	#CLIENT.LanPrefix#Ref_ModuleControl
	WHERE	SystemModule	= 'SelfService'	
	AND		MenuClass		= 'Menu'
	AND		Functionclass	= '#URL.ID#'
	AND		Operational    	= 1
	Order BY MenuOrder
</cfquery>	



	<cfparam name="url.link"      default="">
	<cfparam name="url.menu"      default="">
	
	<cfif url.link eq "" and url.menu eq "">
		<cfif FileExists ("#SESSION.rootpath##Open.FunctionDirectory##Open.FunctionPath#") AND Open.FunctionDirectory neq "" and Open.FunctionPath neq "">
			<cfset url.link = "../../../#Open.FunctionDirectory##Open.FunctionPath#">
		<cfelse>
			<cfset url.link = "Content/Example.cfm">
		</cfif>
	</cfif>	

</cfoutput>

<cfif url.link neq "">
	<cfinclude template="#url.link#">
<cfelse>
	Menu Link not properly defined.
</cfif>