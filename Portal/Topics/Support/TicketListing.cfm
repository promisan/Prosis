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
<cfquery name="get" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT   *
		  FROM     Ref_ModuleControl
		  WHERE    SystemModule  = 'Portal'
		  AND      FunctionClass = 'Portal'
		  AND      FunctionName  = 'Pending Support Tickets'  
	</cfquery> 

<cfif get.recordcount gte "1">
	
	<cf_screentop html="No" jquery="yes">
	
	<table width="96%" height="100%" align="right" class="formpadding">
	
	<tr><td  class="labellarge" style="font-size:35px;padding-right:10px;font-weight:200">Support ticket center <font size="3" color="0080FF"></b>&nbsp;&nbsp;&nbsp;<u><a href="TicketOpen.cfm">Pending tickets</a></font></td></tr>
	<tr><td></td></tr>
	
	<tr><td style="padding-right:4px" height="100%">
	
	<cfinclude template="../../../System/Modification/ModificationTicketListing.cfm">
		
	</td></tr>
	
	</table>

</cfif>