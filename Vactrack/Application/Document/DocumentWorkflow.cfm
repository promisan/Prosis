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


<cfquery name="Doc" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Document
	WHERE DocumentNo = '#URL.ajaxId#'
</cfquery>

<cfquery name="Position" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Position
	WHERE PositionNo = '#Doc.PositionNo#'
</cfquery>

<cfset link = "Vactrack/Application/Document/DocumentEdit.cfm?ID=#url.ajaxid#&IDCandlist=ZoomIn&ActionId=undefined">
 					
<cf_ActionListing 
    ReadMode         = "read_uncommitted"     
    TableWidth       = "100%"
    EntityCode       = "VacDocument"
	EntityClass      = "#Doc.EntityClass#"
	EntityGroup      = "#Doc.Owner#"
	EntityStatus     = ""		
	Mission          = "#Doc.Mission#"
	OrgUnit          = "#Position.OrgUnitOperational#"
	ObjectReference  = "#Doc.FunctionalTitle#"
	ObjectReference2 = "#Doc.Mission# - #Doc.PostGrade#"
	ObjectKey1       = "#Doc.DocumentNo#"	
	AjaxId           = "#URL.ajaxId#"
  	ObjectURL        = "#link#"
	DocumentStatus   = "#Doc.Status#">
		
