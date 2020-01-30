<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><head><title>Step Report</title></head><body>


<cfparam name="URL.PublishNo">

<cfoutput>

<cfset lvl = 1>

<cfset FileNo = round(Rand()*100)>
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#FlowSteps#FileNo#">

<cfquery name="Flow#lvl#" 
 datasource="AppsQuery"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 Select ActionCode,
 		ActionParent,
 		ActionDescription,
		ActionType,
		ActionGoToYes,
		ActionGoToYesLabel,
		ActionGoToNo,
		ActionGoToNoLabel,
		'   ' as ActionFromBranch
	INTO #SESSION.acc#FlowSteps#FileNo#
	FROM Organization.dbo.Ref_EntityActionPublish
	WHERE ActionPublishNo = '#URL.PublishNo#'
	AND ActionParent = 'INIT'		
</cfquery>

<cfquery name="Flow#lvl#" 
 datasource="AppsQuery"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 Select *
	FROM #SESSION.acc#FlowSteps#FileNo#
</cfquery>	

</cfoutput>

<cfset Tree = "Flow#lvl#">
<cfset TypeOfAction = Evaluate("#Tree#.ActionType")>

<cfif TypeOfAction eq "Decision">


</cfif>
<cfinclude Template="InsertReportStep.cfm">					

<cfoutput>

<cfquery name="Flow#lvl#" 
	 datasource="AppsQuery"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 Select *
		FROM #SESSION.acc#FlowSteps#FileNo#  ..
	</cfquery>

</cfoutput>			 
