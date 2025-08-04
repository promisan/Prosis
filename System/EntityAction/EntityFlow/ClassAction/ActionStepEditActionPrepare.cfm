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

<cfquery name="Entity" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Entity
	WHERE EntityCode = '#URL.EntityCode#'
</cfquery>

<cfquery name="Embed" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityClass
	WHERE EntityCode = '#URL.EntityCode#'
	AND EmbeddedFlow = '1'
</cfquery>

<cfquery name="Dialog" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityDocument
	WHERE EntityCode = '#URL.EntityCode#'
	AND DocumentType = 'Dialog'
	ORDER BY DocumentDescription
	</cfquery>
	
<cfquery name="Mail" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_EntityDocument
	WHERE EntityCode = '#URL.EntityCode#'
	AND   DocumentType = 'Mail'
	ORDER BY DocumentDescription
	</cfquery>	
	
<cfquery name="Script" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_EntityDocument
	WHERE EntityCode = '#URL.EntityCode#'
	AND   DocumentType = 'Script'
	ORDER BY DocumentDescription
	</cfquery>			

<cfif URL.PublishNo eq "">

	<cfquery name="Get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityClassAction
	WHERE ActionCode  = '#URL.ActionCode#'
	AND   EntityClass = '#URL.EntityClass#'
	AND   EntityCode  = '#URL.EntityCode#' 
	</cfquery>
	
	<cfquery name="Last" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Max(ActionOrder) as ActionOrder
	FROM Ref_EntityClassAction
	WHERE EntityCode = '#URL.EntityCode#'
	AND EntityClass  = '#URL.EntityClass#'
	AND ActionCode != '#URL.ActionCode#' 
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
	
<!---	<cfquery name="Parent" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityClassAction
	WHERE EntityCode = '#URL.EntityCode#'
	AND EntityClass = '#URL.EntityClass#'
	AND ActionCode != '#URL.ActionCode#' 
	AND ActionOrder > '0'
	</cfquery>
--->

	<cfquery name="Parent" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityClassAction
	WHERE EntityCode = '#URL.EntityCode#'
	AND EntityClass = '#URL.EntityClass#'
	<cfif Get.ActionParent neq "">
		AND ActionCode = '#Get.ActionParent#' 
	<cfelse>	
		AND (ActionGoToYes = '#URL.ActionCode#' OR ActionGoToNo = '#URL.ActionCode#')
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
	AND ActionCode != '#URL.ActionCode#' 
	<!--- Hanno 29/05/05 
	AND ActionCode NOT IN (SELECT ActionGoToYes
	                         FROM Ref_EntityClassAction
							 WHERE ActionGoToYes > ''
							 AND ActionCode != '#URL.ActionCode#')
	AND ActionCode NOT IN (SELECT ActionGoToNo
	                         FROM Ref_EntityClassAction
							 WHERE ActionGoToNo > ''
							 AND ActionCode != '#URL.ActionCode#')	
							 --->
	ORDER BY ActionOrder						 						 
	</cfquery>
	
		
	<cfloop index="itm" list="Due,Submission,Deny,Condition" delimiters=",">
		
		<cfquery name="Script#itm#" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_EntityClassActionScript
			WHERE ActionCode  = '#URL.ActionCode#'
			AND   EntityClass = '#URL.EntityClass#'
			AND   EntityCode  = '#URL.EntityCode#' 
			<cfif itm eq "Submission">
			AND   Method      IN ('#itm#','submit') 
			<cfelse>
			AND   Method      = '#itm#'
			</cfif>			
		</cfquery>
	
	</cfloop>
		
<cfelse>

	<cfquery name="Get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityActionPublish A, Ref_EntityClassPublish P
	WHERE A.ActionCode    = '#URL.ActionCode#'
	AND A.ActionPublishNo = '#URL.PublishNo#'
	AND A.ActionPublishNo = P.ActionPublishNo
	</cfquery>
	
	<cfquery name="Parent" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityActionPublish
	WHERE ActionPublishNo = '#URL.PublishNo#'
	AND ActionCode = '#get.ActionParent#' 
	</cfquery>
		
	<cfloop index="itm" list="Due,Submission,Deny,Condition" delimiters=",">
		
		<cfquery name="Script#itm#" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_EntityActionPublishScript
			WHERE ActionPublishNo = '#URL.PublishNo#'
			AND ActionCode        = '#URL.ActionCode#' 
			<cfif itm eq "Submission">
			AND   Method      IN ('#itm#','submit') 
			<cfelse>
			AND   Method      = '#itm#'
			</cfif>	
		</cfquery>
	
	</cfloop>
					
</cfif>	