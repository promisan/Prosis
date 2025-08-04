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

<cfquery name="Request" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM RequestHeader		
	WHERE  RequestHeaderid = '#url.ajaxid#'	
</cfquery>

<cfquery name="RequestType" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Request		
	WHERE  Code = '#Request.RequestType#'	
</cfquery>
	
<cfparam name="url.action" default="">	
			
<table width="100%" cellspacing="0" cellpadding="0">
<tr><td>
	
<cfset wflink = "Warehouse/Application/StockOrder/Request/Create/Document.cfm?drillid=#url.ajaxid#">
					
<cf_ActionListing 
	EntityCode       = "WhsRequest"
	EntityClass      = "#Request.EntityClass#"
	EntityGroup      = ""
	EntityStatus     = ""
	Mission          = "#Request.mission#"
	OrgUnit          = "#Request.orgunit#"		
	PersonEMail      = "#Request.EmailAddress#"
	ObjectReference  = "#Request.Reference#"
	ObjectReference2 = "#RequestType.description#"						
	ObjectKey4       = "#url.ajaxid#"
	AjaxId           = "#url.ajaxid#"
	ObjectURL        = "#wflink#"
	Reset            = "No"
	Show             = "Yes"
	ToolBar          = "Hide">
		
</td></tr>			
</table>