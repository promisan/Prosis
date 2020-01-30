
<!--- entity --->

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
