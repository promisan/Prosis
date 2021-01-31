
<cf_screentop height="100%" scrolll="No" html="No" jquery="Yes">

<cf_DialogProcurement>
<cf_DialogOrganization>
<cf_listingscript>

<cfquery name="Org" 
	datasource="appsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Organization
		WHERE Orgunit = '#url.id#'	
</cfquery>

<table width="100%" height="100%">
    <tr><td height="90">
	    <cfinclude template="../UnitView/UnitViewHeader.cfm">		
	</td></tr>
	<tr><td height="90%" style="padding-left:4px;padding-right:4px" valign="top">
	
	   <!--- obtain the data --->	   
	   <cfset url.mission = "#org.mission#">
	   <cfset url.orgunit = "#url.id#">
	   <cfset url.mode    = "AP">
	  	   
	   <!--- this query from AP_AR puts data into a temporary table --->
	   <cfinclude template="../../../../Gledger/Inquiry/AP_AR/InquiryData.cfm">
	   	   
	   <!--- now we output the data table into the listing --->	   	   	   
		<cf_securediv style="height:100%" 
		   bind="url:#SESSION.root#/System/Organization/Application/AP/APListingContent.cfm?systemfunctionid=#url.systemfunctionid#&mode=#url.mode#&orgunit=#url.orgunit#&mission=#url.mission#" 
		   id="detail">
		
	</td></tr>	
</table>
