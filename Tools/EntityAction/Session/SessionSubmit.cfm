
<!--- submit session --->

<cfparam name="Form.Operational" default="0">
<cfparam name="Form.SessionIP" default="">

<cfquery name="UserSession" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT    *
	FROM      OrganizationObjectActionSession
	WHERE     ActionId        = '#url.actionid#'
	AND       EntityReference = '#url.referenceId#'
</cfquery>

<cfquery name="Object" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT    OOA.ObjectId, 
	          OO.EntityCode, 
			  OO.Mission, 
			  OO.OrgUnit, 
			  OO.ActionPublishNo, 
			  R.ActionCode,
			  R.ActionDescription
	FROM      OrganizationObjectAction AS OOA INNER JOIN
	          OrganizationObject AS OO ON OOA.ObjectId = OO.ObjectId INNER JOIN
	          Ref_EntityActionPublish AS R ON OO.ActionPublishNo = R.ActionPublishNo AND OOA.ActionCode = R.ActionCode
	WHERE     OOA.ActionId = '#url.actionid#'
</cfquery>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.SessionPlanStart#">
<cfset STR = dateValue>
<cfset STR = DateAdd("h", "#Form.HourSessionPlanStart#", "#STR#")> 
<cfset STR = DateAdd("m", "#Form.MinuteSessionPlanStart#", "#STR#")>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.SessionPlanEnd#">
<cfset end = dateValue>	
<cfset end = DateAdd("h", "#Form.HourSessionPlanEnd#",   "#end#")> 
<cfset end = DateAdd("m", "#Form.MinuteSessionPlanEnd#", "#end#")>

<cfif UserSession.recordcount eq "1">

	<cfquery name="Update" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		UPDATE  OrganizationObjectActionSession
		SET     SessionPlanStart  = #str#, 
				SessionPlanEnd    = #end#, 		
				SessionIP         = '#form.sessionip#', 
				SessionPasscode   = '#form.passcode#',
				Operational       = '#form.Operational#'
		WHERE ActionSessionId = '#UserSession.ActionSessionId#'	
	</cfquery>

<cfelseif UserSession.recordcount eq "0">
	
	<cf_assignid>
	
	<cfquery name="AddSession" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">		
		
		INSERT INTO OrganizationObjectActionSession		
					(ActionSessionId, 
					 EntityCode, 
					 EntityReference, 
					 ActionId, 
					 SessionDocumentId, 		 
					 SessionPlanStart, 
					 SessionPlanEnd, 		
					 SessionIP, 
					 SessionPasscode, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)
					 		
		VALUES   ('#rowguid#',
				  '#Object.EntityCode#',
				  '#url.Referenceid#',
				  '#url.actionid#',
				  '#form.documentId#',
				  #str#,
				  #end#,
				  '#form.SessionIP#',
				  '#form.Passcode#',
				  '#session.acc#',
				  '#session.last#',
				  '#session.first#')		
				  		  
	</cfquery>	
	
	<cfquery name="UserSession" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT    *
		FROM      OrganizationObjectActionSession
		WHERE     ActionId        = '#url.actionid#'
		AND       EntityReference = '#url.referenceId#'
	</cfquery>	  					 

</cfif>

<cfoutput>

	<script>	
	    _cf_loadingtexthtml='';
		ptoken.navigate('#session.root#/tools/entityaction/session/setsession.cfm?actionid=#Usersession.ActionId#&entityreference=#Usersession.entityreference#','session_#url.Referenceid#')	
		ProsisUI.closeWindow('wfusersession')
	</script>

</cfoutput>

