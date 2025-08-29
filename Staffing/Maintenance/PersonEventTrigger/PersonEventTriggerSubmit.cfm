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
<cfif url.code eq "">

	<cfquery name="validate"
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT 	*
			FROM 	Ref_PersonEventTrigger
			WHERE	EventTrigger = '#url.trigger#'
			AND		EventCode = '#form.code#'
	</cfquery>
	
	<cfif validate.recordCount gt 0>
	
		<script>
			alert('Event code is in use.');
		</script>
	
	<cfelse>
	
		<cfquery name="insert"
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO Ref_PersonEventTrigger
			         (EventTrigger,
					 EventCode,
					 ActionImpact,
					 <cfif trim(Form.ReasonCode) neq "">ReasonCode,</cfif>
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			  VALUES ('#url.trigger#',
			          '#Form.Code#', 
					  '#Form.ActionImpact#', 
					  <cfif trim(Form.ReasonCode) neq "">'#Form.ReasonCode#',</cfif> 
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
		</cfquery>
		
		<cfoutput>
			<script>
				ptoken.navigate('PersonEventListing.cfm?id1=#URL.trigger#','divPersonEvent');
				ProsisUI.closeWindow('mydialog');
			</script>
		</cfoutput>
		
	</cfif>
	
<cfelse>

	<cfquery name="update"
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE	Ref_PersonEventTrigger
			SET		ActionImpact = '#Form.ActionImpact#',
					ReasonCode = <cfif trim(Form.ReasonCode) neq "">'#Form.ReasonCode#'<cfelse>null</cfif>
			WHERE	EventTrigger = '#url.trigger#'
			AND		EventCode = '#url.code#'
	</cfquery>
	
	<cfoutput>
		<script>
			ptoken.navigate('PersonEventListing.cfm?id1=#URL.trigger#','divPersonEvent');
			ProsisUI.closeWindow('mydialog');
		</script>
	</cfoutput>

</cfif>