
<cfparam name="url.isPortal" default="0">

<cfquery name="delete" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 DELETE 
	 FROM 		Ref_ModuleControl	 
	 WHERE		SystemFunctionId 	= '#url.id#'
</cfquery>

<cfif url.isPortal eq 0>

	<cfoutput>
		<script>
			ColdFusion.navigate("RecordListingClass.cfm?name=#url.name#&class=#url.class#&systemmodule=#url.systemmodule#&functionclass=#url.functionclass#","div#url.class#");
		</script>
	</cfoutput>

<cfelse>

	<cfquery name="deleteDetail" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">		 
		 DELETE 
		 FROM 		Ref_ModuleControl	 
		 WHERE		FunctionClass = '#url.name#'
		 AND		SystemModule = '#url.systemmodule#'
	</cfquery>
	
	<script>
		try {			
			opener.document.getElementById('listing_refresh').click();
		} catch(e) {}	
		window.close();
	</script>

</cfif>
