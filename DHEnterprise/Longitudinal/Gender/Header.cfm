
<cfparam name="url.level" default="">
<cfparam name="url.qunit" default="">
<cfparam name ="userlogged" default ="">
<cfif isDefined("session.acc") AND TRIM(Session.acc) neq "">
	<cfset url.showDetail	= "1">
	<cfelse>
	<cfset url.showDetail	= "0">
</cfif>

<cfif url.level eq "null" OR url.level eq "">
	<cfset url.level = "[none]">
</cfif>

<cfquery name="qMission" 
	datasource="MartStaffing">		 
		SELECT *
		FROM   Entity
		WHERE  Entity = '#url.mission#'
</cfquery>

<cfif qMission.recordCount lte 0 AND TRIM(url.mission) eq ""> <cfoutput> error, no mission detected</cfoutput> <cfabort> </cfif>

<cfquery name="qUnit" 
	datasource="HubEnterprise">		 
		SELECT *
		FROM   Organization
		WHERE  OrgUnitId = '#qMission.EntityRootUnitId#'
</cfquery>

<cf_mobileRow>

	<cf_mobileCell class="col-lg-12 text-center m-t-md">
		  
		<h2>
		
		<cfset titleShow = REPLACE(#url.mission#,"-","")>
			<cfoutput>
			<cfif qMission.EntityName neq "">
				#qMission.EntityName#
				<cfset url.qunit = "#qMission.EntityName#">
			<cfelse>
				#titleShow#
				<cfset url.qunit = "#titleShow#">
			</cfif>
			</cfoutput>
		</h2>
					
	</cf_mobileCell>	
	
</cf_mobileRow>

