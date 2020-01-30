<cfquery name="Line" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 ApplicantNo 
	FROM ApplicantSubmission
	WHERE PersonNo = '#Object.ObjectKeyValue1#' 
</cfquery>

<cfquery name="Review" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM ApplicantReview
	WHERE ReviewId = '#Object.ObjectKeyValue4#' 
</cfquery>

<cf_ComparisonView applicantno="#Line.ApplicantNo#" 
			HidePerson      = "Yes" 
			HideLanguage    = "Yes" 
			HideEducation   = "Yes" 
			HideTitle       = "Yes" 
			HideDetails     = "Yes"
			HideTopics      = "No"
			attachment      = "No" 
			Owner           = "#Review.Owner#"
			ExperienceStatus   = "'0','1'"
			ExperienceReviewed = "Yes"
			Layout          = "Vertical">	
			
<input name="savecustom" type="hidden"  value="">				