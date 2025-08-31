<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfquery name="qProductUoM" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT 
				IWL.UoM, IWL.ItemNo,
				(SELECT UoMDescription 
				 FROM   ItemUoM 
				 WHERE  ItemNo = IWL.ItemNo 
				 AND    UoM = IWL.UoM) as UoMDescription
		FROM 	ItemWarehouseLocation IWL
		WHERE	IWL.Warehouse   = '#url.warehouse#'
		AND		IWL.Location    = '#url.location#'
		AND		IWL.ItemNo      = '#url.itemNo#'
		AND     IWL.Operational = 1		
		ORDER BY IWL.ItemNo
</cfquery>

<cfif qProductUoM.recordcount eq "0">
	
	<cfquery name="get" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT * 
		FROM   WarehouseLocation
		WHERE  Warehouse  = '#url.warehouse#'
		AND    Location   = '#url.location#'
	</cfquery>	
	
	<cfquery name="qProductUoM" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT 
					IWL.UoM, IWL.ItemNo,
					(SELECT UoMDescription 
					 FROM   ItemUoM 
					 WHERE  ItemNo = IWL.ItemNo 
					 AND    UoM = IWL.UoM) as UoMDescription
			FROM 	ItemWarehouseLocation IWL
			WHERE	IWL.Warehouse   = '#url.warehouse#'
			AND		IWL.Location    IN (SELECT Location 
			                            FROM   WarehouseLocation 
										WHERE  Warehouse = IWL.Warehouse 
										AND    <cfif get.LocationId eq "">LocationId is NULL<cfelse>LocationId = '#get.Locationid#'</cfif>)
			AND		IWL.ItemNo      = '#url.itemNo#'
			AND     IWL.Operational = 1		
			ORDER BY IWL.ItemNo
	</cfquery>

</cfif>


<table cellspacing="0" cellpadding="0">

<tr><td>

	<input name="quantity" 
		type="Text" 
		required="Yes" 
		message="Please, enter a valid numeric greater than 0 numeric quantity." 
		validate="numeric" 
		size="8" 	
		class="regularxl enterastab"
		maxlength="10" 
		range="0,"
		style="text-align:right; padding-right:1px;">
	
</td><td style="padding-left:2px">
	
	<select name="UoM" 
			query="qProductUoM" 
			value="UoM" 
			class="regularxl enterastab"
			display="UoMDescription"
			required="Yes" 
			message="Please, select a valid product UoM.">
			<cfoutput query="qProductUoM">
			<option value="#uom#">#uomdescription#</option>
			</cfoutput>
	</select>		
	

</td>
</tr>		

</table>


