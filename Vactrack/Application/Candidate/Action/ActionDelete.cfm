
<!--- save action
      save and submit the eMail
	  and refresh listing --->
			
<cfquery name="UpdateCandidate" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE DocumentCandidateReviewAction			
	WHERE ActionId = '#url.actionid#'				
</cfquery>	
	 	  
<cfoutput>  
	<script>   		
		_cf_loadingtexthtml='';	
		ptoken.navigate('#session.root#/Vactrack/Application/Candidate/Action/ActionListing.cfm?documentNo=#url.documentno#&PersonNo=#url.PersonNo#&actioncode=#url.actioncode#','boxaction#url.PersonNo#')
	</script>	
</cfoutput>	  