
<cfquery name="Delete" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_ScaleDetail
		 WHERE Code = '#URL.Code#'
		 AND AgeYear = '#URL.id2#'
</cfquery>

<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Delete" 
						 contenttype="scalar"
						 content="Code:#url.code#,AgeYear:#url.id2#">

<cfset url.id2 = "">
<cfinclude template="List.cfm">
