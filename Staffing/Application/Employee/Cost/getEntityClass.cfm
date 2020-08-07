
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
	</cfquery>

</cfif>

<select name="entityClass_<cfoutput>#url.itm#</cfoutput>" class="regularxl" style="border:0px">
	<option value=""><cf_tl id="NA"></option>
	<cfoutput query="EntityClass">
	    <option value="#entityClass#">#entityClassName#</option>
    </cfoutput>
</select>