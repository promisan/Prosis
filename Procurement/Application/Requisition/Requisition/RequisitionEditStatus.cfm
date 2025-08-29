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
<cfparam name="url.id" default="">
<cfparam name="url.requisitionNo" default="#url.id#">

<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    RequisitionLine
	WHERE   RequisitionNo = '#url.requisitionNo#'	
</cfquery>	

<cfquery name="Status" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Status
	WHERE   StatusClass = 'Requisition' 
	AND     Status      = '#Line.ActionStatus#'
</cfquery>	
		
<cfif Line.ActionStatus eq "0">
  <cfset c = "blue">
<cfelseif Line.ActionStatus eq "9"> 
  <cfset c = "red"> 
<cfelse>
  <cfset c = "black"> 
</cfif>

<cfoutput>
    <table><tr><td class="labelmedium">
	<font color="#c#">#Status.StatusDescription# (#Line.ActionStatus#)</font>
	</td></tr></table>
</cfoutput>
