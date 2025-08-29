<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
