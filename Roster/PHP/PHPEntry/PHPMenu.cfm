
<!--- launch template menu --->
<cfparam name="URL.ID1"	default="">

<cf_NavigationLeftmenu
	Alias        = "AppsSelection"
	Section      = "#URL.Section#"
	SectionTable = "Ref_ApplicantSection"
	TableName    = "ApplicantSubmission"
	Object       = "Applicant"
	Objectid     = "No"
	Group        = "#url.triggergroup#"
	PersonNo     = "#client.PersonNo#"
	Owner        = "#url.owner#"
	Mission      = "#url.mission#"
	ID           = "#URL.id#"
	ID1          = "#URL.id1#"
	IconWidth    = "48"
	IconHeight   = "48">
 


 
