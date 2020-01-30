
<cfparam name="#url.languagecode#" default="">

<cfif url.languagecode neq "">

<cf_ApplicantTextArea
		Table           = "Employee.dbo.PositionParentProfile" 
		Domain          = "Position"
		FieldOutput     = "JobNotes"
		Mode            = "save"
		Log             = "No"
		LanguageCode    = "#url.languagecode#"
		Key01           = "PositionParentId"
		Officer         = "N"
		Key01Value      = "#URL.ID#">

<cfset url.accessmode = "view">	
<cfinclude template="PositionProfileContent.cfm">


</cfif>
			
			