
<cfparam name="url.selectuom" default="1">

<cfoutput>
<cfquery name="Item" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Item
	WHERE ItemNo = '#URL.ItemNo#'
</cfquery>

<input type="text" name="itemno" id="itemno" size="4" value="#Item.ItemNo#" class="regularxl" readonly style="text-align: center;">
<input type="text" name="itemdescription" id="itemdescription" value="#Item.ItemDescription#" class="regularxl" size="30" readonly style="text-align: left;">
<cfif url.selectuom eq 1>
	
	<cfquery name="qUoM" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     ItemUoM
			WHERE    ItemNo = '#URL.ItemNo#'
			ORDER BY UOMMultiplier
	</cfquery>	

	<select name="itemuom" id="itemuom" class="regularxl">
		<cfloop query="qUoM">
			<option value="#UOM#" <cfif UOM eq url.uom>selected</cfif>>#UOMDescription#</option>
		</cfloop>
	</select> 
	
<cfelse>

	<cfquery name="qUoM" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     ItemUoM
			WHERE    ItemNo = '#URL.ItemNo#'
			AND		 UoM = '#url.uom#'
	</cfquery>	
	<input type="hidden" name="itemuom" id="itemuom" size="4" value="#qUoM.uom#" class="regularxl" readonly style="text-align: center;">
	( <input type="text" name="itemuomdesc" id="itemuomdesc" size="10" value="#qUoM.UOMDescription#" class="regularxl" readonly style="text-align: center;"> )
	
</cfif>
</cfoutput>		   