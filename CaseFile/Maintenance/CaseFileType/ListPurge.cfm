
<cfoutput>

<cfquery name="Delete" 
     datasource="AppsCaseFile" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     DELETE FROM Ref_ClaimTypeClass
		 WHERE  ClaimType = '#URL.ClaimType#'
		 AND    Code       = '#URL.code#'		
</cfquery>

<cfset url.id2 = "">
<cfinclude template="List.cfm">

<script>
   ColdFusion.navigate('RecordListingDelete.cfm?Code=#URL.ClaimType#','del_#url.claimtype#')	
</script>

</cfoutput>
