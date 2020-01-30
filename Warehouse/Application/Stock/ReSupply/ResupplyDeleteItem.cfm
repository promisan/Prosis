
<cfquery name="Item" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Item
	WHERE ItemNo = '#url.itemno#'
</cfquery>	


<cfoutput>
<table><tr><td bgcolor="FF0000" style="width:8px;height:12px;border:1px solid gray"></td></tr></table>
</cfoutput>