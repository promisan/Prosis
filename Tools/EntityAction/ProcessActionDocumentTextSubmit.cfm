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
<cfscript>
function cleanText(inputText){
	returnText = inputText;
//these steps are not working..need to reveiew	
	returnText = REReplaceNoCase(returnText, "<span [A-Za-z0-9_]*>", "", "ALL");
	returnText = ReplaceNoCase(returnText, "</span>", "", "ALL"); 
	return returnText;
	}
</cfscript>

<cfquery name="Documents" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   OrganizationObjectActionReport
		WHERE  ActionId   = '#URL.memoactionID#' 
		AND    DocumentId = '#URL.documentid#' 
</cfquery>


<cfloop query="documents">
		
	<cfif url.element eq "DocumentContent">
	
		<cfparam name="Form.Field#url.frm#" default="">
		<cfset content = evaluate("Form.Field#url.frm#")>		
				
		<!---
			cfset content = cleanText(content)
		--->
		 														
		<cfquery name="UpdateMemo" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 UPDATE OrganizationObjectActionReport 		
			 SET    #url.element#   = '#content#', 
			        ActionStatus    = '1'
			 WHERE  ActionId        = '#URL.MemoActionId#' 		 
			 AND    DocumentId      = '#URL.DocumentId#' 			 
		</cfquery>				
				
	<cfelse>
	
		<cfparam name="form.MarginTop"    default="2">
		<cfparam name="form.MarginBottom" default="2">
	
		<cfparam name="Form.hdrField#url.frm#" default="">
		<cfset header = evaluate("Form.hdrField#url.frm#")>
		<cfparam name="Form.ftrField#url.frm#" default="">
		<cfset footer = evaluate("Form.ftrField#url.frm#")>
				
		<cfquery name="UpdateMemo" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 UPDATE OrganizationObjectActionReport 		
			 SET    DocumentHeader        = '#header#', 
			        DocumentFooter        = '#footer#', 
			        DocumentMarginTop     = '#form.MarginTop#',
					DocumentMarginBottom  = '#form.MarginBottom#',
			        ActionStatus          = '1'
			 WHERE  ActionId              = '#URL.MemoActionID#' 		 
			 AND    DocumentId            = '#URL.DocumentId#'
			 
		</cfquery>
		
	</cfif>	
			
</cfloop>

<cfoutput>Saved #timeformat(now(),"HH:MM:SS")#</cfoutput>

