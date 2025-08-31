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
<cfparam name="url.mission" default="">

<cfswitch expression="#url.class#">
	
	<cfcase value="3">
	
		<script>
			document.getElementById('entity').className = "regular"
			document.getElementById('indexno').readOnly = false
			
		</script>
	
		<cfquery name="Entity" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT Mission 
			    FROM  Ref_ParameterMission A		
				WHERE Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE Mission = A.Mission)		
		</cfquery>
		
		<select name="Mission" required="Yes" class="regularxl enterastab">
		      <cfoutput query="Entity"><option value="#Mission#" <cfif url.mission eq mission>selected</cfif>>#Mission#</option></cfoutput>
	    <select>	
				
	</cfcase>

	<cfcase value="4">
	
		<script>
			document.getElementById('entity').className = "regular"
			document.getElementById('indexno').readOnly = false
		</script>
	
		<cfquery name="Entity" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT Mission 
			    FROM  Ref_ParameterMission A
				WHERE Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE Mission = A.Mission)				
		</cfquery>
		
		<select name="Mission" required="Yes" class="regularxl enterastab">
		      <cfoutput query="Entity"><option value="#Mission#" <cfif url.mission eq mission>selected</cfif>>#Mission#</option></cfoutput>
	    </select>	
	
	</cfcase>
	
	<cfdefaultcase>
	
		<script>
			document.getElementById('entity').className = "hide"
			document.getElementById('indexno').readOnly = true
			document.getElementById('indexno').value = ""
		</script>
	
	</cfdefaultcase>

</cfswitch>
