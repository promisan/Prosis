
<cfquery name="Review" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      ProgramPeriodReview
	WHERE     ReviewId = '#url.reviewid#'			
</cfquery>	
		
<cfset url.ProgramCode = review.ProgramCode>
<cfset url.Period      = review.Period>

<cfquery name="getTopics"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_ReviewCycleProfile
		WHERE   CycleId = '#Review.ReviewCycleid#'
</cfquery>		

<cfloop query="getTopics">

	<cfif valueObligatory eq "1">
	
		<cfparam name="Form.f#TextAreaCode#" default="">
		<cfset text  =   Evaluate("Form.f#TextAreaCode#")>
				
		<cfquery name="get"
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_TextArea
			WHERE   Code = '#TextAreaCode#'
		</cfquery>	
		
		<cfif len(text) lte 3>
		
		    <cfoutput>
				<script>
				   alert("Please provide input for element #get.Description# before you proceed") 	
				   Prosis.busy('no');
				 </script>			 
			 </cfoutput>
		 
		 </cfif>

	</cfif>

</cfloop>
					
<cf_ProgramTextArea
	Table           = "ProgramPeriodReviewProfile" 
	Domain          = "Review"
	TextAreaCode    = "#QuotedValueList(getTopics.TextAreaCode)#"
	FieldOutput     = "ProfileNotes"
	Mode            = "Save"
	Key01           = "ReviewId"
	Key01Value      = "#URL.ReviewId#">

<cfoutput>
<script>
   Prosis.busy('no');
   ptoken.location('ReviewCycleView.cfm?header=#url.header#&reviewid=#url.reviewid#&CycleId=#url.cycleid#')
</script>
</cfoutput>	
