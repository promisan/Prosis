<cf_ApplicantTextArea
	Table           = "Applicant.dbo.Ref_SubmissionEditionProfile" 
	Domain          = "Edition"
	FieldOutput     = "EditionNotes"				
	LanguageCode    = "#url.languagecode#"
	Mode            = "save"
	Log             = "No"				
	Key01           = "SubmissionEdition"
	Key01Value      = "#url.submissionedition#"
	Key02           = "Actionid"
	Key02Value      = "#url.ActionId#"
	Officer         = "N">	

<cfinclude template = "PublishText.cfm">

			