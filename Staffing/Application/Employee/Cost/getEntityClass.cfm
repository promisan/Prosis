
<cfquery name="EntityClass" 
datasource="AppsOrganization"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_EntityClass
	WHERE  EntityCode = 'EntCost'
	AND    Operational = 1
	AND    EntityClass IN (SELECT EntityClass 
	                       FROM   Ref_EntityClassMission 
						   WHERE  Mission    = '#url.mission#'	
						   AND    EntityCode = 'EntCost')
	ORDER BY ListingOrder					   
</cfquery>

<cfif entityclass.recordcount eq "0">

	<cfquery name="EntityClass" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_EntityClass
		WHERE  EntityCode  = 'EntCost'
		AND    Operational = 1	
		ORDER BY ListingOrder
	</cfquery>

</cfif>

<cfquery name="Entity" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_EntityMission
	WHERE     EntityCode = 'EntCost'
	AND       Mission = '#url.mission#'
</cfquery>

<select name="entityClass_<cfoutput>#url.itm#</cfoutput>" class="enterastab regularxl" style="width:97%;border:0px" 
  onchange="_cf_loadingtexthtml='';ptoken.navigate('getActors.cfm?personno=#url.personno#','actor','','','POST','MiscellaneousEntry')">

	<cfif entity.workflowenforce neq "1">
		<option value=""></option>
	</cfif>
	<cfoutput query="EntityClass">
	    <option value="#entityClass#">#entityClassName#</option>
    </cfoutput>
</select>