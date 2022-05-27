
<cfquery name="getMandate" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT  *
		 FROM    Ref_Mandate
		 WHERE   Mission         = '#url.mission#'
		 AND     DateEffective  <= getDate() 
		 AND     DateExpiration >= getDate()
</cfquery>

<cfif getMandate.recordcount eq "0">

<cfquery name="getMandate" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT  TOP 1 *
		 FROM    Ref_Mandate
		 WHERE   Mission         = '#url.mission#'
		 ORDER BY DateEffective DESC		 
</cfquery>

</cfif>

<cfquery name="getOrganization" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	 SELECT    *
		 FROM      Organization
		 WHERE     Mission         = '#url.mission#'
		 AND       MandateNo       = '#getMandate.Mandateno#'		
		 ORDER BY  HierarchyCode
</cfquery>

<select name="OrgUnit" class="regularxxl" style="width:95%">

	<cfoutput query="getOrganization">
		<option value="#orgunit#" <cfif url.selected eq orgunit>selected</cfif>>#HierarchyCode# #OrgUnitName#</option>
	</cfoutput>

</select>

		