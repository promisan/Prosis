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
<cfparam name="Object.ObjectKeyValue4"  default="">

<!--- set url.id values based on the context --->
<cfif Object.ObjectKeyValue4 neq "">

	<cfset url.drillid = Object.ObjectKeyValue4>	
    <cfset url.workflow = "1">
		
	<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM  Ref_ParameterMission
		WHERE Mission = '#Object.Mission#'
	</cfquery>
	
<cfelse>

	<cfset url.workflow  ="0">
    <cfparam name="URL.ID1" default="">
	
</cfif>

<cfquery name="RequestLines" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT L.*
	FROM   Materials.dbo.RequestHeader H,
	       Materials.dbo.Request L 		 	 
	WHERE      H.Mission         = L.Mission
	AND        H.Reference       = L.Reference
	AND        H.RequestHeaderId = '#url.drillid#' 	

</cfquery>

<cfoutput>
<cfif RequestLines.recordcount eq "1">
	<iframe src="../../Warehouse/Application/StockOrder/Task/Tasking/TaskView.cfm?requestid=#requestlines.requestid#&mode=embed" width="100%" height="100%" frameborder="0"></iframe>
<cfelse>
	<cfinclude template="DocumentLines.cfm">
</cfif>
</cfoutput>