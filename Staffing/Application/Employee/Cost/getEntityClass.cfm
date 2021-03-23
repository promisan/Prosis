
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
	    SELECT   *
	    FROM     Ref_EntityClass
		WHERE    EntityCode  = 'EntCost'
		AND      Operational = 1	
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

<cfquery name="Item" 
	datasource="AppsPayroll"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_PayrollItem
	WHERE     PayrollItem = '#url.entitlement#'	
</cfquery>

<cfoutput>
	
	<cfif Item.entityclass neq "">	
		
		<select name="entityClass_#url.itm#" class="enterastab regularxxl" style="width:97%;border:0px" 
		  onchange="_cf_loadingtexthtml='';ptoken.navigate('getActors.cfm?personno=#url.personno#','actor','','','POST','MiscellaneousEntry')">	
				<option value="#Item.EntityClass#">#Item.EntityClass#</option>	
		</select>
	
	<cfelse>
		
		<select name="entityClass_#url.itm#" class="enterastab regularxxl" style="width:97%;border:0px" 
		  onchange="_cf_loadingtexthtml='';ptoken.navigate('getActors.cfm?personno=#url.personno#','actor','','','POST','MiscellaneousEntry')">
		
			<cfif entity.workflowenforce neq "1">
				<option value=""></option>
			</cfif>
			<cfloop query="EntityClass">
			    <option value="#entityClass#">#entityClassName#</option>
		    </cfloop>
		</select>
	
	</cfif>

</cfoutput>