
<cfoutput>
<cfquery name="Delete" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_FunctionClassification
		 WHERE ParentCode = '#URL.ParentCode#'
		 AND   Code       = '#URL.code#'
		
</cfquery>

<cfset url.id2 = "">
<cfinclude template="List.cfm">

<script>
   ColdFusion.navigate('RecordListingDelete.cfm?Code=#URL.ParentCode#','del_#url.parentcode#')	
</script>
</cfoutput>
