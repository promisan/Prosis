
<cfif action eq "purge">

    <cftransaction>

	<cfquery name="ClearAssociation" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   DELETE  FROM ClaimElement
	   WHERE   ElementId  = '#url.elementid#'	
	</cfquery>
	
	<cfquery name="ClearAssociation" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   DELETE  FROM ElementRelation
	   WHERE   ElementId  = '#url.elementid#' OR ElementIdChild = '#url.elementid#'
	</cfquery>
	
	<cfquery name="ClearAssociation" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   DELETE  FROM ElementRelationLog
	   WHERE   ElementId  = '#url.elementid#' OR ElementIdChild = '#url.elementid#'
	</cfquery>
	
	<cfquery name="ClearAssociation" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 DELETE FROM Element
			 WHERE  ElementId  = '#url.elementid#'	
	</cfquery>
	
	</cftransaction>
			
	<cfoutput>
	
		<script>		  
		    try {				
			opener.applyfilter('1','','content') 
			} catch(e) {}    	
			window.close()
			
	     </script>	
		
	</cfoutput>
	
<cfelse>

	<cfquery name="ClearAssociation" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   DELETE  FROM ClaimElement
	   WHERE   CaseElementId  = '#url.caseelementid#'	
	</cfquery>	
		
	<cfoutput>
	
		<script>		  
		    try {				
			opener.applyfilter('1','','#url.caseelementid#') 
			} catch(e) {}    	
			window.close()
			
	     </script>	
		
	</cfoutput>
	
</cfif>

