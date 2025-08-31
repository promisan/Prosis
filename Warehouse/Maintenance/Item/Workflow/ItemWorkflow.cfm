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
<cfquery name="Item" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Item 
		 WHERE  ItemNo = '#url.ajaxid#'		
</cfquery>

<cfset link = "Warehouse/Maintenance/Item/RecordEdit.cfm?id=#url.ajaxid#&mode=workflow">

<cf_ActionListing 
    EntityCode       = "WhsItem"
	EntityClass      = "Standard"
	EntityClassReset = "1"
	EntityGroup      = ""
	EntityStatus     = ""
	Mission          = "#Item.Mission#"
	OrgUnit          = ""
	ObjectReference  = "#Item.ItemNo#"
	ObjectReference2 = "#Item.ItemDescription#"
	ObjectKey1       = "#Item.ItemNo#"			
  	ObjectURL        = "#link#"
	Show             = "Yes"
	ActionMail       = "Yes"
	AjaxId           = "#URL.AjaxId#"	
	PersonNo         = ""
	PersonEMail      = ""
	TableWidth       = "100%"
	DocumentStatus   = "0">		
	