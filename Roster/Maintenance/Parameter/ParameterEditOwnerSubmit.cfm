
<cfquery name="Own" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterOwner
	WHERE Owner= '#URL.Owner#'
</cfquery>
	
<cfloop query="own">

	<cfset FldOperational              = evaluate("Form.Operational_" & #Owner#)>
	<cfset FldEnableRosterTransfer     = evaluate("Form.EnableRosterTransfer_" & #Owner#)>
	<cfset FldDefaultEmailAddress      = evaluate("Form.DefaultEmailAddress_" & #Owner#)>
	<cfset FldSelectiondays            = evaluate("Form.SelectionDays_" & #Owner#)>
	<cfset FldSelectionFilterScript    = evaluate("Form.SelectionFilterScript_" & #Owner#)>
	<cfset FldProcessdays              = evaluate("Form.ProcessDays_" & #Owner#)>
	<cfset FldPathVacancyText          = evaluate("Form.PathVacancyText_" & #Owner#)>
	<cfset FldPathHistoryProfile       = evaluate("Form.PathHistoryProfile_" & #Owner#)>
	<cfset FldRosterSearchMinimum      = evaluate("Form.RosterSearchMinimum_" & #Owner#)>
	<!--- discontinued 
	<cfset FldRosterdays               = evaluate("Form.RosterDays_" & #Owner#)>
	--->
	<cfset FldEnableVARosterFilter     = evaluate("Form.EnableVARosterFilter_" & #Owner#)>
	<cfset FldHidePostSpecific         = evaluate("Form.HidePostSpecific_" & #Owner#)>
	<cfset FldFunctionClassSelect      = evaluate("Form.FunctionClassSelect_" & #Owner#)>
	<cfparam name="Form.SelectionDaysOverwrite_#Owner#" default="0">
	<cfset FldSelectionDaysOverwrite   = evaluate("Form.SelectionDaysOverwrite_" & #Owner#)>
	<cfparam name="Form.DefaultSubmission_#Owner#" default="">
	<cfset FldDefaultSubmission        = evaluate("Form.DefaultSubmission_" & #Owner#)>
	<cfset FldDefaultSubmissionShow    = evaluate("Form.DefaultSubmissionShow_" & #Owner#)>
	<cfparam name="Form.DefaultRoster_#Owner#" default="">
	<cfset FldDefaultRoster            = evaluate("Form.DefaultRoster_" & #Owner#)>
	<cfset FldHideEmptyBucket          = evaluate("Form.HideEmptyBucket_" & #Owner#)>
	<cfset FldRosterSearchBucketVA     = evaluate("Form.RosterSearchBucketVA_" & #Owner#)>
	<cfparam name="Form.DefaultRosterAdd_#Owner#" default="0">
	<cfset FldDefaultRosterAdd         = evaluate("Form.DefaultRosterAdd_" & #Owner#)>
	<cfset FldShowLastAssignment       = evaluate("Form.ShowLastAssignment_" & #Owner#)>
	<cfset FldShowPendingReview        = evaluate("Form.ShowPendingReview_" & #Owner#)>
	<cfparam name="Form.AddReviewPointer_#Owner#" default="0">
	<cfset FldAddReviewPointer         = evaluate("Form.AddReviewPointer_" & #Owner#)>
	<cfset FldRosterCandidateManual    = evaluate("Form.RosterCandidateManual_" & #Owner#)>
				
	<cfquery name="Update" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_ParameterOwner
	SET Operational            = '#FldOperational#', 
	    SelectionDays          = '#FldSelectiondays#', 
		SelectionDaysOverwrite = '#FldSelectionDaysOverwrite#',
		SelectionFilterScript  = '#FldSelectionFilterScript#',
	    ProcessDays            = '#FldProcessdays#',
		DefaultEmailAddress    = '#FldDefaultEmailAddress#', 
		PathVacancyText        = '#FldPathVacancyText#',
		PathHistoryProfile     = '#FldPathHistoryProfile#',
		<!--- 
		RosterDays             = '#FldRosterdays#',
		--->
		RosterSearchMinimum    = '#FldRosterSearchMinimum#',
		FunctionClassSelect    = '#FldFunctionClassSelect#',
		EnableVARosterFilter   = '#FldEnableVARosterFilter#',
		DefaultRosterAdd       = '#FldDefaultRosterAdd#', 
		EnableRosterTransfer   = '#FldEnableRosterTransfer#',
		HideEmptyBucket        = '#FldHideEmptyBucket#',
		HidePostSpecific       = '#FldHidePostSpecific#',
		RosterSearchBucketVA   = '#FldRosterSearchBucketVA#',
		ShowLastAssignment     = '#FldShowLastAssignment#',
		ShowPendingReview      = '#FldShowPendingReview#',
		AddReviewPointer       = '#FldAddReviewPointer#',
		RosterCandidateManual  = '#FldRosterCandidateManual#',
		<cfif #FldDefaultSubmission# neq "">
		DefaultSubmission      = '#FldDefaultSubmission#',
		</cfif>
		<cfif #FldDefaultRoster# neq "">
		DefaultRoster          = '#FldDefaultRoster#',
		</cfif>
		DefaultSubmissionShow  = '#FldDefaultSubmissionShow#'
	WHERE Owner  = '#Owner#'
	</cfquery>

</cfloop>	

<cfinclude template="ParameterEditOwnerPointer.cfm">
	
