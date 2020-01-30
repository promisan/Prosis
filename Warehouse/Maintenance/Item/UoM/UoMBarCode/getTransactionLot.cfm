<cfquery name="qLot" 
datasource="AppsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT  DISTINCT TransactionLot
	FROM    ItemUoMMissionLot
	WHERE   TransactionLot > '0' 
	AND     Mission      	= '#url.warehouse#'
	AND     ItemNo         	= '#url.id#' 
	AND     UoM 			= '#url.UoM#'
</cfquery>

<cfoutput>				
	<select name="sLot" id="sLot" class="regularxl" id="sLot" onChange="updateButton('#url.id#','#url.uom#',document.getElementById('labels').value,document.getElementById('sWarehouse').value)">
	    <option value="">No lot</option>
		<cfloop query="qLot">
			<option value="#TransactionLot#">#TransactionLot#</option>
		</cfloop>
	</select>
</cfoutput>