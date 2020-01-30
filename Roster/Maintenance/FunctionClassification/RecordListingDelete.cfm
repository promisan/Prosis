
<cfoutput>

   <cfquery name="Check" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT TOP 1 *
					    FROM  Ref_FunctionClassification
						WHERE ParentCode = '#Code#'						
				   </cfquery>
				   	
				  <cfif check.recordcount eq "0">
				  	  <cf_img icon="delete" onclick="ColdFusion.navigate('RecordListingPurge.cfm?Code=#code#','listing')">
				  </cfif>	   
  
</cfoutput>  