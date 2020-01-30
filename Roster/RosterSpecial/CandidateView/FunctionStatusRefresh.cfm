
<cfparam name="url.idfunction" default="">
<cfparam name="url.owner"      default="">

<cfif url.idfunction neq "">
	
	 <cfquery name="getStatus"
		   datasource="AppsSelection"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
			SELECT		*, 
			            (SELECT count(*) 
						 FROM ApplicantFunction
						 WHERE FunctionId = '#url.idfunction#'
						 AND   Status = R.Status) as Counted 
			FROM		Ref_StatusCode R 
			WHERE   	R.Id     = 'FUN' 			
			AND         R.Owner  = '#url.owner#'		
			ORDER BY 	R.Status
	</cfquery>
	
	<cfoutput query="getStatus">
		
		<script>
		   try {		  
		 	document.getElementById('count_#status#').innerHTML = '<B>[#counted#]</B>'
			} catch(e) {}
		</script>
	
	</cfoutput>

</cfif>