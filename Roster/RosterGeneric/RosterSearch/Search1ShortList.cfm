
<cfparam name="url.mode"        default="vacancy">
<cfparam name="url.wActionId"   default="">

<cfajaximport tags="cfform">
<cf_menuscript>

<cfif url.wActionId neq "">

	<cfquery name="param" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     R.ActionDialogParameter
		FROM       OrganizationObjectAction OA INNER JOIN
	               Ref_EntityActionPublish R ON OA.ActionPublishNo = R.ActionPublishNo AND OA.ActionCode = R.ActionCode
		WHERE      OA.ActionId = '#url.wActionId#'
	</cfquery>
	
	<cfset url.wParam = param.ActionDialogParameter>

</cfif>

<cfparam name="url.wParam"      default="">
<cfparam name="url.functionno"  default="">
	
<cfif url.mode eq "vacancy">
	
	<!--- check if matching OccGroup and grade in Vactrack rosters --->
	
	<cfquery name="Doc" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Document D
		WHERE  D.DocumentNo = #URL.DocNo# 
	</cfquery>
	
	<cfset owner = "">
	
	<cfif doc.owner eq "">
	
		<cfquery name="Owner" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Ref_ParameterOwner D
			WHERE D.Owner IN (SELECT MissionOwner 
			                  FROM   Organization.dbo.Ref_Mission 
							  WHERE  Mission = '#Doc.Mission#')
		</cfquery>
	
		<cfset own = owner.owner>
	
	<cfelse>
	
		<cfquery name="Owner" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_ParameterOwner D
			WHERE  D.Owner = '#doc.owner#'
		</cfquery>
	
	    <cfset own = owner.owner>
	
	</cfif>
	
	<cfif own eq "">
	
	  <cf_message message="Roster has not been configured for this track" return="close()">
	  <cfabort>
	
	</cfif>
		
	<!---
	<cfif ShortList.recordcount eq "0">  this would load a different screen for this bucket only to a full view does not work, better to merge
	bucket search with the full view in one container
	--->
		
		<cf_screentop title="Full Roster search for vacancy #URL.DocNo#" html="No" scroll="no">   	
					
		<cfset url.wparam = "FULL">
		<cfset url.owner  = Own>
		<cfset url.mode   = "Vacancy">	
						
		<cfinclude template="InitView.cfm">
	
<cfelseif url.mode eq "ssa">	

	<!--- this is triggered from the procurement portion --->

	<cfquery name="Job" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Job 
		WHERE JobNo = '#URL.JobNo#' 
	</cfquery>
	
	<cfquery name="Mission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Ref_Mission 
		WHERE Mission = '#Job.Mission#' 
	</cfquery>
		
		<cfset url.owner  = Mission.MissionOwner>
		<cfset url.mode   = "ssa">	
		<cfset url.docno  = url.jobno>
						
		<cfinclude template="InitView.cfm">

</cfif>


