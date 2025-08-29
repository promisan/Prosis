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
<cfquery name="Request" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Request
		WHERE  Requestid = '#url.requestid#'
</cfquery>

<cfquery name="Status" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityStatus
		WHERE  EntityCode  = 'wrkRequest'
		AND    EntityStatus = '#Request.ActionStatus#'
</cfquery>

<cfoutput>

    <cf_space spaces="40">
	<cfif status.entitystatus eq "0"><font color="gray">
	<cfelseif status.entitystatus eq "9"><font color="red">
	</cfif>
	#Status.StatusDescription# on : <b><font color="408080">#dateformat(request.created,CLIENT.DateFormatShow)# #timeformat(request.created,"HH:MM")#
	
</cfoutput>	


