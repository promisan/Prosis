
<!--- Hanno improve performance we can move this to apply at the moment the tree is opened --->

<cfquery name="Mission"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Mission
	WHERE  Mission = '#mis#'
</cfquery>

<cf_wfPending 
     EntityCode           = "VacDocument" 
	 EntityCodeIgnoreLast = "0"	
	 entityCode2          = "VacCandidate" 
	 mailfields           = "No" 
	 includeCompleted     = "No" 	 
	 Mission              = "#url.mission#"
	 Mode                 = "table"
	 Table                = "#session.acc#_#mission.MissionPrefix#_VacancyTrack">
	 

<cf_listingscript>

<cf_screentop html="No" jquery="Yes" height="100%">

<cfoutput>

	<script>
	function showdocument(vacno) {	
		  ptoken.open('#session.root#/Vactrack/Application/Document/DocumentEdit.cfm?ID=' + vacno, 'track'+vacno);
		}
		
	Prosis.busy('yes')
	
	</script>
		
	<table style="width:100%;height:100%">	
	<tr><td style="height:600px" valign="top">
	 <cfinclude template="ControlListingPositionContent.cfm">
	 <!---
	 <cf_securediv id="content" bind="url:ControlListingPositionContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&hierarchycode=#url.hierarchycode#">
	 --->
	</td></tr>
	</table>

</cfoutput>
