
<cfquery name="Delete" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 DELETE FROM Ref_Scale
	 WHERE Code = '#URL.Code#'
</cfquery>

<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Delete" 
						 content="#Form#">

<cfinclude template="RecordListingDetail.cfm">
