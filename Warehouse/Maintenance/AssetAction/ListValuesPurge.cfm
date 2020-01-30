
<cfquery name="Delete" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     DELETE FROM Ref_AssetActionList
			 WHERE Code = '#URL.Code#'
			 AND ListCode = '#URL.id2#'
</cfquery>

<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                 action="Delete" 
					 contenttype = "scalar"
					 content="Code: #url.code#, ListCode:#url.id2#">

<cfoutput>
  <script>
	#ajaxlink('ListValuesListing.cfm?idmenu=#url.idmenu#&code=#url.code#&id2=')#
  </script>	
</cfoutput>