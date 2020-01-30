<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><head><title>Insert Report Step</title></head><body>


<cfoutput>

<cfset ActionCode  = Evaluate("#Tree#.ActionCode")>
<cfset ActionGoToYes  = Evaluate("#Tree#.ActionGoToYes")>
<cfset ActionGoToNo  = Evaluate("#Tree#.ActionGoToNo")>
<cfset TypeOfAction = Evaluate("#Tree#.ActionType")>

<cfif TypeOfAction eq "Decision" AND ActionGoToYes neq "">

	<cfquery name="FlowInsert" 
	 datasource="AppsQuery"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 Insert INTO #SESSION.acc#FlowSteps#FileNo#
	 	(ActionCode,
 			ActionParent,
 			ActionDescription,
			ActionType,
			ActionGoToYes,
			ActionGoToYesLabel,
			ActionGoToNo,
			ActionGoToNoLabel,
			ActionFromBranch)
		Select 	ActionCode,
 			ActionParent,
 			ActionDescription,
			ActionType,
			ActionGoToYes,
			ActionGoToYesLabel,
			ActionGoToNo,
			ActionGoToNoLabel,
			'YES'
		FROM Organization.dbo.Ref_EntityActionPublish
		WHERE ActionPublishNo = '#URL.PublishNo#'
		AND ActionCode = '#ActionGoToYes#'  
	</cfquery>
	
	<cfset InsertAction = "#ActionGoToYes#">

<cfelseif TypeOfAction eq "NO" AND ActionGoToNo neq "">

	<cfquery name="FlowInsert" 
	 datasource="AppsQuery"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 Insert INTO #SESSION.acc#FlowSteps#FileNo#
	 	(ActionCode,
 			ActionParent,
 			ActionDescription,
			ActionType,
			ActionGoToYes,
			ActionGoToYesLabel,
			ActionGoToNo,
			ActionGoToNoLabel,
			ActionFromBranch)
		Select 	ActionCode,
 			ActionParent,
 			ActionDescription,
			ActionType,
			ActionGoToYes,
			ActionGoToYesLabel,
			ActionGoToNo,
			ActionGoToNoLabel,
			'NO'
		FROM Organization.dbo.Ref_EntityActionPublish
		WHERE ActionPublishNo = '#URL.PublishNo#'
		AND ActionCode = '#ActionGoToNo#'
	</cfquery>
	
	<cfset InsertAction = "#ActionGoToNo#">	
	
<cfelse>

	<cfquery name="FlowInsert" 
	 datasource="AppsQuery"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 Insert INTO #SESSION.acc#FlowSteps#FileNo#
	 	(ActionCode,
 			ActionParent,
 			ActionDescription,
			ActionType,
			ActionGoToYes,
			ActionGoToYesLabel,
			ActionGoToNo,
			ActionGoToNoLabel,
			ActionFromBranch)
		Select 	ActionCode,
 			ActionParent,
 			ActionDescription,
			ActionType,
			ActionGoToYes,
			ActionGoToYesLabel,
			ActionGoToNo,
			ActionGoToNoLabel,
			''
		FROM Organization.dbo.Ref_EntityActionPublish
		WHERE ActionPublishNo = '#URL.PublishNo#'
		AND ActionParent = '#ActionCode#'
	</cfquery>
	
	<cfquery name="FlowInsert" 
	 datasource="AppsQuery"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 Select *
		FROM #SESSION.acc#FlowSteps#FileNo#
		WHERE ActionParent = '#ActionCode#'
	</cfquery>		
		
	<cfif FlowInsert.RecordCount gte 1>
		<cfset InsertAction = "#FlowInsert.ActionCode#">	
	<cfelse>
		<cfset InsertAction = "">
	</cfif>	

</cfif>

<cfif InsertAction neq "">

	<cfset lvl = #lvl#+1>

	<cfquery name="Flow#lvl#" 
	 datasource="AppsQuery"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 Select *
		FROM #SESSION.acc#FlowSteps#FileNo#
		WHERE ActionCode = '#InsertAction#'
	</cfquery>	
	
	<cfset Tree = "Flow#lvl#">
	<cfinclude Template="InsertReportStep.cfm">					

</cfif>

</cfoutput>