
<cf_compression>

<cfoutput>

   <cfquery name="Check" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    	SELECT TOP 1 *
			    FROM   Ref_ClaimTypeClass
				WHERE  ClaimType = '#Code#'						
  </cfquery>
				   	
  <cfif check.recordcount eq "0">
			  <cf_img icon="delete" onclick="ColdFusion.navigate('RecordListingPurge.cfm?Code=#code#','listing')">
  </cfif>	   
  
</cfoutput>  