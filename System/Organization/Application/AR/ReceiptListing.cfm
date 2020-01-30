
<cf_screentop height="100%" scrolll="No" html="No" jquery="Yes">

<cf_DialogProcurement>
<cf_DialogOrganization>
<cf_listingscript>

<cfajaximport tags="cfwindow">

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
		<cfdiv style="height:100%" bind="url:#SESSION.root#/System/Organization/Application/AR/ReceiptListingContent.cfm?systemfunctionid=#url.systemfunctionid#&id1=VED&id2=#URL.ID#&mission=#org.mission#" id="detail"/>
	</td></tr>	
</table>
