
<cfparam name="Form.PHPEntryCalendar" default="0">

<cfquery name="Update" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Parameter
SET SearchNo               = '#Form.SearchNo#', 
	DocumentLibrary        = '#Form.DocumentLibrary#',
	DocumentURL            = '#Form.DocumentURL#',
	DefaultOrganization    = '#Form.DefaultOrganization#',
	PHPSource              = '#Form.PHPSource#',
	PHPEntry               = '#Form.PHPEntry#',
	PHPEntryCalendar       = '#Form.PHPEntryCalendar#',
	TemplateRoot           = '#Form.TemplateRoot#', 
	ReviewOwnerAccess      = '#Form.ReviewOwnerAccess#',
	TemplateHome           = '#Form.TemplateHome#',
	TemplateValidation     = '#Form.TemplateValidation#',
	TemplateIntroduction   = '#Form.TemplateIntroduction#'
WHERE Identifier           = '#Form.Identifier#'
</cfquery>

<cfinclude template="ParameterEditGlobal.cfm">
	
