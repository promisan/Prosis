
<cfparam name="url.ClaimType" default="">

<cfquery name="Tab" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ClaimTypeTab
	WHERE   TabName = 'Control'	
	<cfif url.claimtype neq "">
	AND     Code    = '#url.ClaimType#' xxx
	</cfif>
	AND     Mission='#url.mission#'
</cfquery>

<cfif Tab.TabTemplate eq "">
	    
	<cfquery name="ClaimTypeList" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_ClaimType		
	</cfquery>
	
	<cfloop query="ClaimTypeList">
	
		<cftry>
	
		<cfquery name="Tab" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ClaimTypeTab
			(Mission,Code,TabName)
			VALUES
			('#url.mission#','#code#','Control')		
		</cfquery>
		
		<cfcatch></cfcatch>
		
		</cftry>
	
	</cfloop>

	<cf_tl id= "Module scope (ControlEmployee/ControlOrganization) could not be determined." class="Message" var ="1">
	<cfset vText1 = lt_text>
	
	<cf_tl id= "Please contact your administrator" class="Message" var ="1">
	<cfset vText2 = lt_text>
	
    <cf_message message="#vText1# #vText2#">

<cfelse>

	<cfparam name="url.mid" default="">
	
	<cflocation addtoken="No" url="#SESSION.root#/CaseFile/Application/Case/#Tab.TabTemplate#/ClaimView.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&mid=#url.mid#">

</cfif>



