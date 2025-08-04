<!--
    Copyright © 2025 Promisan

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

<cfparam name="url.Mode"   default="Item">
<cfparam name="url.UoM"    default="">
<cfparam name="url.Prefix" default="">

<cfquery name="GetItem" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Item I INNER JOIN Ref_Category R ON I.Category = R.Category
	WHERE	I.ItemNo = '#url.itemno#'				
</cfquery>

<cfquery name="GetItemUoMMission" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    ItemUoMMission I 
	WHERE	I.ItemNo  = '#url.itemno#'				
	AND     I.Mission = '#url.mission#'
</cfquery>

<cfif getItemUoMMission.standardCost gt "0">

	<cfset cost = getItemUoMMission.standardCost>
	
<cfelse>

	<cfquery name="GetItemUoM" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    ItemUoM I
		WHERE	I.ItemNo  = '#url.itemno#'					
	</cfquery>

	<cfset cost = getItemUoM.standardCost>	

</cfif>
			
<cfoutput>
						
	<cfif url.mode eq "Item">					
				
		#GetItem.Classification# #GetItem.ItemDescription#		
		<input type="hidden" required="true" name="itemNo#URL.Prefix#" id="itemNo#URL.Prefix#" value="#url.itemno#">		
		
		<script>
			ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/BOM/getItem.cfm?mission=#url.mission#&mode=uom&itemNo=#url.itemno#','uombox')			
			document.getElementById('price').value = "#numberformat(cost,',.__')#"
			try { 
			document.getElementById('applybox').className = "regular"
			} catch(e) {}
		</script>
		
	<cfelse>
	
			<!-- <cfform>-->	
			
			<cfquery name="GetUoM" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT 	U.*
			    FROM 	ItemUoM U
				WHERE	U.ItemNo = '#url.ItemNo#'
			</cfquery>		
										
			<cf_tl id="Select a valid UoM" var="1">		
							
			<cfselect name="uom#URL.Prefix#" 
				  id="uom#URL.Prefix#" 
			      query="getUoM" 
				  required="true" 
				  message="#lt_text#" 
				  value="UoM" 
				  style="width:120px"
				  selected="#URL.UoM#"	  
				  onchange="ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/BOM/getItemPrice.cfm?mission=#url.mission#&itemNo=#url.itemno#&uom='+this.value+'&quantity='+document.getElementById('quantity').value,'uomprice')"
				  display="UoMDescription" 				 
				  class="regularxl"/>			
				  
			<!-- </cfform> -->
								
	</cfif>						

</cfoutput>