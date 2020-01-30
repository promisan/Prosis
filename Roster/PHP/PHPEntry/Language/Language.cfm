<cf_screentop height="100%" scroll="Yes" html="No" jQuery="Yes">

<cf_param name="url.Code" 			default="" type="String">
<cf_param name="url.owner" 			default="" type="String">
<cf_param name="url.ApplicantNo" 	default="" type="String">
<cf_param name="url.Section" 		default="" type="String">
<cf_param name="url.Source"  		default="Manual" type="String">
<cf_param name="url.Scope"   		default="" type="String">
<cf_param name="url.mission"   		default="" type="String">
<cf_param name="url.showheader"  	default="Yes" type="String">

<cf_param name="url.mid"   default="" type="String">  <!--- type="GUID" --->

<cfif url.source neq "" and url.applicantno eq "">

	<cfset url.id = client.personNo>
	
	<cfquery name="getApplicant" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Applicant
		WHERE EmployeeNo='#URL.id#'
	</cfquery>
	
	<cfquery name="getApplicantSubmission" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM ApplicantSubmission
		WHERE PersonNo='#getApplicant.PersonNo#'
		AND Source = '#url.source#'
	</cfquery>	
	
	<cfset Client.appPersonNo = getApplicant.PersonNo>
	<cfset Client.ApplicantNo = getApplicantSubmission.ApplicantNo>
	
	<cfset url.applicantno = getApplicantSubmission.ApplicantNo>

</cfif>

<cfif URL.ApplicantNo eq "">
	<cfset URL.ApplicantNo = client.applicantno>
</cfif>	

<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT S.PersonNo, S.Source
	FROM   Applicant A, 
	       ApplicantSubmission S
	WHERE  A.PersonNo = S.PersonNo
	AND    S.ApplicantNo = '#URL.ApplicantNo#'
</cfquery>

<cfif URL.Section neq "">
	<cfquery name="Section" 
			datasource="appsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     #CLIENT.LanPrefix#Ref_ApplicantSection
				WHERE    Code = '#URL.Section#' 
	</cfquery>
	
	<cfquery name="SectionNext" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     #CLIENT.LanPrefix#Ref_ApplicantSection
			WHERE   CAST( ListingOrder AS INT) > #Section.ListingOrder# AND Operational='1'
	</cfquery>

</cfif>

<cfquery name="Check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	 COUNT(*) AS Total   
		FROM     ApplicantLanguage
		WHERE    ApplicantNo = '#URL.ApplicantNo#'
</cfquery>

<cfset url.id     = Get.PersonNo>
<cfif url.source eq "">
	<cfset url.source = Get.Source>
</cfif>

<cfset url.id2         = "Language">
<cfset url.entryScope  = "Portal">
<cfparam name="url.topic" default="#url.id2#">

<table width="95%" align="center" height="100%">

	<cfif url.entryScope eq "Portal">
	
		<tr><td height="10"></td></tr>
	
		<cfif url.showheader eq "Yes">
		<tr><td colspan="2" style="padding-left:14px">
		<!--- <cf_navigation_header1 toggle="Yes"> ---><cfinclude template="../PHPIdentity.cfm">
		</td></tr>	
		</cfif>
	
	<!--- 	
		<tr><td width="95%" valign="top" align="center">
		
			  <cfset url.id = client.personno>
			  <cfset ctr      = "0">		
		      <cfset openmode = "open"> 
			  <cfinclude template="../../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">		
			  <cfset url.id     = Get.PersonNo>		  
			  
		</td></tr>
		
		--->
	
	</cfif>
		
	<tr>		
		<td width="100%" height="100%" valign="top" align="center">		
			<cfdiv id="languagebox">
				<cfinclude template="../../../Candidate/Details/Language/Language.cfm">
			</cfdiv>
		</td>
	</tr>
	
	<tr><td class="linedotted"></td></tr>
	<tr>
		<td style="padding-top:20px;">

		  <cfif URL.section neq "">
		  
			<cfset setNext = 1>

			<cfif Section.Obligatory eq 1>
				<cfif Check.Total eq 0>
				  	<cfset setNext = 0>
				</cfif>  
			</cfif>  

			<!--- does it make sense to show the next button? --->
			<cfset enableNext = 1>
			<cfif SectionNext.recordcount eq 0>
				<cfset enableNext = 0>
			</cfif>
		 
		  <cf_Navigation
			 Alias         = "AppsSelection"
			 TableName     = "ApplicantSubmission"
			 Object        = "Applicant"
			 ObjectId      = "No"
			 Group         = "PHP"
			 Section       = "#URL.Section#"
			 SectionTable  = "Ref_ApplicantSection"
			 Id            = "#URL.ApplicantNo#"
			 BackEnable    = "1"
			 HomeEnable    = "1"
			 ResetEnable   = "0"
			 ResetDelete   = "0"	
			 ProcessEnable = "0"
			 NextEnable    = "1"
			 NextSubmit    = "0"
			 OpenDirect    = "0"
			 SetNext       = "#setNext#"
			 NextMode      = "#setNext#"
			 IconWidth 	  = "48"
			 IconHeight	  = "48">
			 
		  </cfif>
		</td>
	</tr>
		
</table>