
<!--- background entry passthru --->

<!--- first we check if there is an applicant record for the source and personNo --->

<cfparam name="URL.entryScope"   default="Backoffice">
<cfparam name="url.section" 	 default="">
<cfparam name="URL.source"       default="Manual">  
<cfparam name="URL.Topic"        default="Employment"> 
<cfparam name="url.id1"          default="">
<cfparam name="url.applicantno"  default="">
<cfparam name="url.owner"        default="">
<cfparam name="url.mid"          default="">

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM Parameter
</cfquery>

<cfif url.applicantno eq "">
	
	<cfquery name="check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM ApplicantSubmission
		WHERE PersonNo = '#url.id1#'
		AND   Source = '#url.source#'
		ORDER BY Created DESC
	</cfquery>
	
	<cfif check.recordcount gte "1">
	
	   <cfset url.applicantno = check.applicantno>
	
	<cfelse>
	
	
	</cfif>

</cfif>

<cfoutput>

<iframe src="#session.root#/Roster/Candidate/Details/Background/BackgroundEntry.cfm?owner=#url.owner#&applicantno=#url.applicantno#&section=profile&entryScope=#url.entryscope#&Source=#url.source#&Topic=#url.topic#&ID=&ID1=#url.id1#&ID2=#url.id2#" frameborder="0" style="width:100%;height:100%"></iframe>


</cfoutput>
