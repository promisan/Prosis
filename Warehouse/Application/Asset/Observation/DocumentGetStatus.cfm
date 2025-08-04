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

<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    AssetItemObservation
		WHERE   ObservationId = '#url.Observationid#'
</cfquery>

<cfquery name="Status" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityStatus
		WHERE  EntityCode  = 'AssObservation'
		AND    EntityStatus = '#get.ActionStatus#'
</cfquery>

<cfoutput>

	<cfif status.entitystatus eq "0"><font color="gray">
	<cfelseif status.entitystatus eq "9"><font color="red">
	</cfif>
	#Status.StatusDescription# on : <font color="408080">#dateformat(get.created,CLIENT.DateFormatShow)# #timeformat(get.created,"HH:MM")#
	
</cfoutput>	


