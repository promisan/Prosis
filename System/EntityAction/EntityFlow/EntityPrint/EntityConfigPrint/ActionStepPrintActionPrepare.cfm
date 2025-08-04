<!--
    Copyright © 2025 Promisan

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

<html>
<head>
	<title>Untitled</title>
</head>

<body>


<cfif URL.PublishNo eq "">

	<cfquery name="Last" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Max(ActionOrder) as ActionOrder
	FROM Ref_EntityClassAction
	WHERE EntityCode = '#URL.EntityCode#'
	AND EntityClass  = '#URL.EntityClass#'
	AND ActionCode != '#GetAction.ActionCode#' 
	</cfquery>
	
	<cfquery name="Action" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityAction
	WHERE EntityCode = '#URL.EntityCode#'
	AND Operational = '1'
	AND ActionType IN ('Action','Decision')
	AND ActionCode NOT IN (SELECT ActionCode 
	                       FROM Ref_EntityClassAction
						   WHERE EntityCode = '#URL.EntityCode#'
						   AND EntityClass = '#URL.EntityClass#')
	</cfquery>
	
	<cfquery name="Parent" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *, Case 
				When ActionGoToYes = '#GetAction.ActionCode#' 
					AND ActionGoToYesLabel != '' AND ActionGoToYesLabel IS NOT NULL Then ActionGoToYesLabel
				When ActionGoToYes = '#GetAction.ActionCode#' 
					AND (ActionGoToYesLabel = '' OR ActionGoToYesLabel IS NULL) Then 'YES'
				When ActionGoToNo = '#GetAction.ActionCode#' 
					AND ActionGoToNoLabel != '' AND ActionGoToNoLabel IS NOT NULL Then ActionGoToNoLabel
				When ActionGoToNo = '#GetAction.ActionCode#' 
					AND (ActionGoToNoLabel = '' OR ActionGoToNoLabel IS NULL) Then 'NO'
				ELSE ''
			  END as BranchLabel
	FROM Ref_EntityClassAction
	WHERE EntityCode = '#URL.EntityCode#'
	AND EntityClass = '#URL.EntityClass#'
	<cfif GetAction.ActionParent neq "">
		AND ActionCode = '#GetAction.ActionParent#' 
	<cfelse>	
		AND (ActionGoToYes = '#GetAction.ActionCode#' OR ActionGoToNo = '#GetAction.ActionCode#')
	</cfif>	
	AND ActionOrder > '0' 
	</cfquery>
	
	<cfquery name="GoTo" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityClassAction
	WHERE EntityCode = '#URL.EntityCode#'
	AND EntityClass  = '#URL.EntityClass#'
	AND ActionCode != '#GetAction.ActionCode#' 
	ORDER BY ActionOrder						 						 
	</cfquery>
	
		
	<cfloop index="itm" list="Due,Submission,Deny" delimiters=",">
		
		<cfquery name="Script#itm#" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_EntityClassActionScript
			WHERE ActionCode  = '#GetAction.ActionCode#'
			AND   EntityClass = '#URL.EntityClass#'
			AND   EntityCode  = '#URL.EntityCode#' 
			AND   Method      = '#itm#'
		</cfquery>
	
	</cfloop>
		
<cfelse>

	<cfquery name="Parent" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *, Case 
				When ActionGoToYes = '#GetAction.ActionCode#' 
					AND ActionGoToYesLabel != '' AND ActionGoToYesLabel IS NOT NULL Then ActionGoToYesLabel
				When ActionGoToYes = '#GetAction.ActionCode#' 
					AND (ActionGoToYesLabel = '' OR ActionGoToYesLabel IS NULL) Then 'YES'
				When ActionGoToNo = '#GetAction.ActionCode#' 
					AND ActionGoToNoLabel != '' AND ActionGoToNoLabel IS NOT NULL Then ActionGoToNoLabel
				When ActionGoToNo = '#GetAction.ActionCode#' 
					AND (ActionGoToNoLabel = '' OR ActionGoToNoLabel IS NULL) Then 'NO'
				ELSE ''
			  END as BranchLabel
	FROM Ref_EntityActionPublish
	WHERE ActionPublishNo = '#URL.PublishNo#' 
	<cfif GetAction.ActionParent neq "">
		AND ActionCode = '#GetAction.ActionParent#' 
	<cfelse>	
		AND (ActionGoToYes = '#GetAction.ActionCode#' OR ActionGoToNo = '#GetAction.ActionCode#')
	</cfif>	
	</cfquery>
	
	<cfloop index="itm" list="Due,Submission,Deny" delimiters=",">
		
		<cfquery name="Script#itm#" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_EntityActionPublishScript
			WHERE ActionPublishNo = '#URL.PublishNo#'
			AND ActionCode        = '#GetAction.ActionCode#' 
			AND   Method      = '#itm#'
		</cfquery>
	
	</cfloop>
					
</cfif>	



</body>
</html>
