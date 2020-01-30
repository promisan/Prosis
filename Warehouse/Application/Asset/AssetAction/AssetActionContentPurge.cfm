
<cfquery name="Delete" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE AssetItemAction
	SET ActionStatus = '9'
	 WHERE AssetActionId = '#URL.AssetActionId#'
</cfquery>

<cfinclude template="AssetActionContent.cfm">
