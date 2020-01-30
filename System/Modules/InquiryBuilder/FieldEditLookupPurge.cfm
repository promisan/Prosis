<cfquery name="Insert" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	
			DELETE FROM Ref_ModuleControlDetailFieldList
			WHERE  SystemFunctionId 	= '#URL.FunctionId#'
				   AND FunctionSerialNo = '#URL.SerialNo#'
				   AND FieldId		    = '#URL.FieldId#'
				   AND ListType		    = '#URL.Type#'
				   AND ListValue		= '#URL.ListValue#'
	
</cfquery>

<cfoutput>

<script language = "JavaScript">
	 window.location = "FieldEditLookup.cfm?FunctionId=#URL.FunctionId#&SerialNo=#URL.SerialNo#&FieldId=#URL.FieldId#&Type=#URL.Type#" 
</script>	

</cfoutput>