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
<cfquery name="Doc" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   Peu.ReviewId,
	         Peu.OrgUnit,
			 Peu.Period,
			 R.Description,
			 R.AuditDate,
			 R.Auditid
	FROM     ProgramPeriodAudit Peu INNER JOIN
	         Ref_Audit R ON Peu.AuditId = R.AuditId 
	WHERE    ReviewId = '#URL.Ajaxid#' 
</cfquery>

<cfquery name="Unit" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Organization
	WHERE    OrgUnit = '#Doc.OrgUnit#' 
</cfquery>

<cfquery name="CheckMe" 
datasource="AppsProgram"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#Unit.Mission#'
</cfquery>

<cfif CheckMe.IndicatorAuditWorkflowStart lte Doc.AuditDate>
	
	 <cfset link = "ProgramRem/Application/Indicator/Audit/IndicatorAudit.cfm?id=mission&reviewid=#url.ajaxid#&mode=submission">				
	
      <cf_ActionListing 
		    TableWidth       = "99%"
		    EntityCode       = "EntIndicator"
			EntityClass      = "Standard"	
			Mission          = "#Unit.mission#"
			OrgUnit          = "#Doc.OrgUnit#"
			ObjectReference  = "#Unit.OrgUnitName# #doc.Description#"
			ObjectReference2 = "#dateformat(Doc.AuditDate,CLIENT.DateFormatShow)#"
			ObjectKey4       = "#Doc.ReviewId#"
			AjaxId           = "#URL.ajaxId#"
		  	ObjectURL        = "#link#"
			DocumentStatus   = "0">
		
</cfif>		
		
