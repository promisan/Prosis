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
<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
	
		<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Ref_ParameterMission
			WHERE Mission = '#URL.Mission#' 
		</cfquery>
		
		<cfif Parameter.recordcount eq "0" or Parameter.MissionPrefix eq "">
		
			<cf_tl id="REQ017" var="1">
			<cfset vReq017=#lt_text#>			
			<cf_message message="#vReq017# : Prefix">
			<cfabort>
		
		</cfif>
			
		<cfset No = Parameter.RequisitionNo+1>
		<cfif No lt 10000>
		     <cfset No = 10000+No>
		</cfif>
			
		<cfquery name="Update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Ref_ParameterMission
			SET    RequisitionNo = '#No#'
			WHERE  Mission = '#URL.Mission#' 
		</cfquery>
	
</cflock>