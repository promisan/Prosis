<cfquery name="getUnit" 
 datasource="appsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     Organization
	 WHERE    OrgUnit = '#URL.OrgUnit#'
</cfquery>

<cfif getUnit.recordCount eq 1>
	<cfoutput>
		<script>
			$('##orgunitname').val('#getUnit.orgunitname#');
			$('##orgunitclass').val('#getUnit.orgunitclass#');
			$('##mandateno').val('#getUnit.mandateno#');
			$('##orgunit').val('#getUnit.orgunit#');
			$('##mission').val('#getUnit.mission#');
			$('##orgunitcode').val('#getUnit.orgunitcode#');
		</script>
	</cfoutput>
</cfif>