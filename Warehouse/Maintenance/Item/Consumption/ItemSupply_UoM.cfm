<cfquery name="getLookup" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ItemUoM
		WHERE	ItemNo = '#URL.ID#'
</cfquery>
<cfoutput>
<input type="Hidden" name="countUoM" id="countUoM" value="#getLookup.recordCount#">
<select name="SupplyItemUoM" id="SupplyItemUoM" class="regularxl">
	<cfloop query="getLookup">
	  <option value="#getLookup.UoM#" <cfif getLookup.UoM eq URL.uom>selected</cfif>>#getLookup.UoM# - #getLookup.UoMDescription#</option>
  	</cfloop>
</select>
</cfoutput>
 