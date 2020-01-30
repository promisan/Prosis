	
	<cfquery name="Vendor" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT OrgUnit, OrgUnitName
		FROM  Organization
		WHERE OrgUnit IN (SELECT OrgUnitVendor 
		                  FROM   Purchase.dbo.Purchase 
		                  WHERE  Mission='#URL.Mission#'
						  <cfif url.period neq "">
						  AND    Period = '#URL.Period#'
						  </cfif>)
	    ORDER BY OrgUnitName
	</cfquery>
	 
    <select name="orgunitvendor" id="orgunitvendor" size="1" style="width:400px" class="regularxl">
	<option value="" selected><cf_tl id="Any"></option>
    <cfoutput query="Vendor">
		<option value="#OrgUnit#">#OrgUnitName#</option>
	</cfoutput>
    </select>