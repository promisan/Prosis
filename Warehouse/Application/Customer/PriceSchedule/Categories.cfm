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
<cfset dateValue = "">
<cf_dateConvert value="#url.dateeffective#">
<cfset vDateEffective = dateValue>

<cfquery name="customer" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM	Customer
			WHERE	CustomerId = '#url.CustomerId#'			
	</cfquery>
	
	<cfquery name="getmission" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT Mission
			FROM   WarehouseBatch
			WHERE CustomerId = '#url.CustomerId#'			
	</cfquery>
	
	<cfquery name="customer" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM	Customer
			WHERE	CustomerId = '#url.CustomerId#'			
	</cfquery>
	
	<cfquery name="getmission" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT Mission
			FROM   WarehouseBatch
			WHERE CustomerId = '#url.CustomerId#'			
	</cfquery>
	
	<cfquery name="categories" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT R.TabOrder,
					R.Category, 
					R.Description,
					(	SELECT 	PriceSchedule
						FROM	CustomerSchedule
						WHERE	CustomerId    = '#url.CustomerId#'
						AND		Category      = R.Category
						AND		DateEffective = #vDateEffective#
					) AS Selected
			FROM   Ref_Category R
			WHERE  R.Category IN (SELECT WC.Category
			                      FROM   Warehouse W INNER JOIN WarehouseCategory WC ON W.Warehouse = WC.Warehouse
								  WHERE  W.Mission IN ('#customer.Mission#'<cfif getMission.recordcount gte "1">,#quotedValueList(getMission.Mission)#</cfif>)
								)
			AND	   R.Operational = 1
			AND    R.FinishedProduct = 1				   			
			ORDER BY R.TabOrder			
	</cfquery>

	<cfquery name="priceSchedule" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Ref_PriceSchedule
		ORDER BY ListingOrder
	</cfquery>

<cf_tl id="Please, select a valid price schedule" var="errorMessage">
<cf_tl id="Select Schedule" var="selectMessage">

<!-- <cfform name="dummy"> -->
	<table width="100%" class="navigation_table">
		<tr class="line">
			<td class="labelmedium" width="25%">
				<cf_tl id="Category">
			</td>
			<td class="labelmedium">
				<cf_tl id="Price Schedule">
			</td>
			<td class="labelmedium" width="25%">
				<cf_tl id="Category">
			</td>
			<td class="labelmedium">
				<cf_tl id="Price Schedule">
			</td>
		</tr>
				
		<cfset row = "0">
		
		<cfoutput query="categories">
		
			<cfset row = row + 1>
			<cfif row eq "1">
			<tr class="navigation_row labelmedium2">
			</cfif>
			
			<cfquery name="mission" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   DISTINCT W.Mission
					FROM     WarehouseCategory AS WC INNER JOIN
	                         Warehouse AS W ON WC.Warehouse = W.Warehouse
					WHERE    WC.Category = '#category#'
				</cfquery>	
						
				<td style="padding-left:7px"><b>#Description#</b>
				<br><font size="1">(<cfloop query="mission">#mission#<cfif currentrow neq recordcount>,</cfif></cfloop>)</font>
				</td>
				<td style="padding:2px;padding-right:5px">
					<cfselect 
						name="PriceSchedule_#trim(Category)#" 
						id="PriceSchedule_#trim(Category)#" 
						query="priceSchedule" 
						display="Description" 
						value="Code" 
						style="width:100%"
						class="regularxxl selPriceSchedule" 
						required="Yes" 
						selected="#Selected#" 
						message="#errorMessage#" 
						queryposition="below">
						<option value="">-- #selectMessage# --
					</cfselect>
					<br>
					<cfif currentrow eq 1 AND recordCount gt 1>
						<font size="1"><a style="color:##369CF5; padding-left:15px;min-width:50px" href="javascript:$('.selPriceSchedule').val($('##PriceSchedule_#trim(Category)#').val());"><cf_tl id="Same for all"></a>
					</cfif>
				</td>
			<cfif row eq "2">	
			</tr><cfset row = "0">
			</cfif>
		</cfoutput>
	</table>
<!-- </cfform> -->

<cfset AjaxOnLoad("doHighlight")>

<script>
	Prosis.busy('no')
</script>