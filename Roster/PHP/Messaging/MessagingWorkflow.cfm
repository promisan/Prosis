<cfparam name="URL.ID"     	default="">
<cfparam name="URL.ajax" 	default="No">

<!--- If I remove this the comments work as plannned --->

<cfquery name="getObject" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   * 
	FROM     OrganizationObject
	WHERE    ObjectKeyValue4 = '#url.ajaxid#'	
</cfquery>

<cfif getObject.recordcount eq "0">
	
	<cfquery name="Mail" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   * 
		FROM     ApplicantMail
		WHERE    MailId = '#url.ajaxid#'
	</cfquery>
	
	<cfquery name="Person" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   * 
		FROM     Applicant
		WHERE    PersonNo = '#Mail.PersonNo#'	
	</cfquery>
	
	<cfset link = "Roster/PHP/Messaging/MailView.cfm.cfm?id=#url.ajaxid#">
								
	<cf_ActionListing 
		EntityCode       = "CanMail"
		EntityClass      = "Standard"		
		EntityStatus     = ""
		OrgUnit          = ""
		PersonNo         = "#Person.PersonNo#" 
		PersonEMail      = "#Person.EMailAddress#"
		ObjectReference  = "#Person.FirstName# #Person.LastName#"		
		ObjectKey4       = "#url.ajaxid#"
		ObjectURL        = "#link#"
		Show             = "No"					
		Framecolor       = "ECF5FF"
		CompleteFirst    = "No">	
		
</cfif>		
	

<cfquery name="getObject" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   * 
	FROM     OrganizationObject
	WHERE    ObjectKeyValue4 = '#url.ajaxid#'	
</cfquery>
		
<cf_commentlisting objectid="#getObject.ObjectId#" ajax="#url.ajax#" mail="0">		

<!--- refreshing the content in the listing --->

<cfoutput>
<script>
  applyfilter('1','','#url.ajaxid#')		
</script>
</cfoutput>

<cfif url.ajax eq "Yes">
	<cfset AjaxOnLoad("initTextArea")>
</cfif>

