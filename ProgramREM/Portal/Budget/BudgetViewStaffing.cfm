
<cfquery name="Org" 
		datasource="appsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM  Organization		
		WHERE OrgUnit = '#url.org#' 				
</cfquery>
			
<cfparam name="URL.ID"                default="ORG">	
<cfparam name="URL.Org"               default="#Org.OrgUnit#">		
<cfparam name="URL.ID1"               default="#Org.OrgUnitCode#">
<cfparam name="URL.Mission"           default="#Org.Mission#">
<cfparam name="URL.Mandate"           default="#Org.MandateNo#">
  
<cfparam name="URL.header"            default="Portal">
	
<cf_customLink
	FunctionClass = "Staffing"
	FunctionName  = "stPosition"
	Scroll        = "no"
	Key           = "">
	
<cfset url.lay = "listing">		


<table width="100%" align="center" border="0"><tr><td id="list">
	<cfinclude template="../../../Staffing/Application/Position/MandateView/MandateViewList.cfm">
</td></tr></table>


