<cfquery name="getLookup" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	*
		FROM	Ref_ServiceItemDomainClass
		WHERE	ServiceDomain = '#URL.ID1#'
</cfquery>

<select name="serviceDomainClass" id="serviceDomainClass" class="regularxl">
	<option value=""></option>
	<cfoutput query="getLookup">		
	  	<option value="#Code#" <cfif code eq #URL.ID2#>selected</cfif>>#Code# - #Description#</option>
  	</cfoutput>
</select>