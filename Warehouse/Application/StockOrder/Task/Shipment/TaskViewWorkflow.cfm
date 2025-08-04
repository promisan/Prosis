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

<!--- generate workflow --->

<cfquery name="get" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT  * 
	FROM    Taskorder
	WHERE   StockOrderId = '#url.ajaxid#'	
</cfquery>

<cfset wflink = "Warehouse/Application/StockOrder/Task/Shipment/TaskView.cfm?stockorderid=#url.ajaxid#">

<cfset Reset = "Yes">

<cfinvoke component = "Service.Process.Materials.Taskorder"  
	method           = "CheckCompleted" 
	mission          = "#get.mission#"
	warehouse        = "#get.warehouse#"
	tasktype         = "#get.tasktype#"
	stockorderid     = "#get.stockorderid#"
	returnvariable   = "counted">	
		
<cfif counted eq 0>
	<cfset AllowProcess = "No">
<cfelse>
	<cfset AllowProcess = "Yes">
</cfif>
					
<cf_ActionListing 
	EntityCode       = "WhsTaskorder"
	EntityClass      = "#get.tasktype#"
	EntityGroup      = ""
	EntityStatus     = ""
	Mission          = "#get.mission#"
	OrgUnit          = ""		
	PersonEMail      = ""
	ObjectReference  = "#get.Reference#"
	ObjectReference2 = ""						
	ObjectKey4       = "#url.ajaxid#"
	AjaxId           = "#url.ajaxid#"
	ObjectURL        = "#wflink#"
	Reset            = "#reset#"
	Show             = "Yes"
	ToolBar          = "Yes"
	AllowProcess     = "#AllowProcess#">

<!---	removed by hanno as it seems to give issues

<script>
	try {opener.document.getElementById('tasktreerefresh').click();}  catch(e){};			
</script>	
--->	