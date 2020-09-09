
<cfquery name="Get" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
		    FROM   Organization E
		    WHERE  OrgUnit = '#url.orgunit#'
		</cfquery>


<cfoutput>
	<input type="text" id="orgname" name="orgname" value="#Get.OrgUnitName#" size="40" maxlength="40" class="regularxl" readonly style="padding-left:4px">				
	<input type="hidden" name="orgunit" id="orgunit" value="#Get.OrgUnit#" size="10" maxlength="10" readonly>
</cfoutput>
			