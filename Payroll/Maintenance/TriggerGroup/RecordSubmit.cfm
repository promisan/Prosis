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

<cfquery name="Verify" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_TriggerGroup
		WHERE 	TriggerGroup  = '#url.id1#' 
</cfquery>

<cfif verify.recordCount eq 1>

	<cfquery name="Update" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE	Ref_TriggerGroup
			SET		Description = '#Form.Description#',
					ReviewerActionCodeOne = <cfif trim(Form.ReviewerActionCodeOne) neq ''>'#Form.ReviewerActionCodeOne#'<cfelse>NULL</cfif>,
					ReviewerActionCodeTwo = <cfif trim(Form.ReviewerActionCodeTwo) neq ''>'#Form.ReviewerActionCodeTwo#'<cfelse>NULL</cfif>
			WHERE 	TriggerGroup  = '#url.id1#' 
	</cfquery>

</cfif>

<script language="JavaScript">
     window.close()
	 opener.history.go()
</script>  
