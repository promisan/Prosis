
<cfparam name="Form.Code"                default="">
<cfparam name="Form.element"             default="">

 <cfquery name="Update" 
	  datasource="AppsCaseFile" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  UPDATE Ref_TopicElementClass
	  SET    ListingOrder         = '#FORM.ListingOrder#',
	  		 PresentationMode	  = '#FORM.PresentationMode#',
			 ElementSection		  = '#Form.ElementSection#'
	  WHERE  Code                = '#URL.Code#'		 	   
	  AND    ElementClass          = '#URL.element#' 
</cfquery>
	
<cfset url.code = "">
				
		
			   	
<cfoutput>
  <script>
   <!---  ColdFusion.navigate('RecordListingDelete.cfm?Code=#URL.ClaimType#','del_#url.claimtype#')	 --->
    ColdFusion.navigate('List.cfm?element=#URL.element#&code=#url.code#','#url.element#_list')	
  </script>	
</cfoutput>


