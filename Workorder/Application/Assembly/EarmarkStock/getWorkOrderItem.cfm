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

<cfoutput>

<cfparam name="url.workorderid" default="">

<!--- get the relevant items --->

<cfif url.workorderid eq "all">
	 
	  <table width="99%" cellspacing="0" cellpadding="0">
					
		<tr>
		
		   <td width="98%" style="height:30px;padding-left:7px;border:1px solid silver" id="itembox"></td>
		   	
		   <td width="30" valign="top" style="padding-left:3px">
		   	
	        <cfset link = "#SESSION.root#/Workorder/Application/Assembly/EarmarkStock/getItem.cfm?mission=#url.mission#&warehouse=#url.warehouse#&workorderid=#url.workorderid#">
		   										
			<!--- take the runtime value of the warehouse instead --->
										    									   
	   		<cf_selectlookup
				    box          = "itembox"
					link         = "#link#"
					title        = "Item Selection"
					icon         = "contract.gif"
					style        = "height:25px"
					button       = "Yes"
					close        = "Yes"	
					filter1      = "warehouse"
					filter1value = "#url.warehouse#"													
					class        = "Item"
					des1         = "ItemNo">	
					
			<input type="hidden" 
				    name="itemno" 
					id="itemno" 
					size="4" 
					value="" 
					class="regular" 
					readonly 
					style="text-align: center;">	
		
			</td>
				
			
		</tr>
					
	</table>  					

<cfelse>

     <!--- get the FP earmarked items in this workorder for wich the net stock quantity > 1 --->

	<cfquery name="item" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	  	SELECT    ItemNo, ItemNo+' '+ItemDescription as Name, Category
		FROM      Item 	I
		
		WHERE EXISTS
		
					(		
					SELECT    'X'
					FROM      ItemTransaction T
					WHERE     Mission     = '#url.mission#' 					
					AND       ItemNo      = I.ItemNo
					
					<cfif url.workorderid neq "">
					
					AND       WorkOrderId = '#url.workorderid#'
					
					<!--- ----------------------------------------------------------- --->
					<!--- only earmarked transaction associated to workorderllineitem --->
					<!--- -----keep in mind that in the system the requirementid does
					not have to be the same as the item of the stock transaction ---- --->										
					<!--- ----------------------------------------------------------- --->
					
					AND      T.RequirementId IN (SELECT WorkOrderItemId 
		                    			         FROM   WorkOrder.dbo.WorkOrderLineItem 
											     WHERE  WorkOrderItemId = T.RequirementId)
												 											 
												 
					<cfelse>
					
					AND      T.RequirementId is NULL
					
					AND      T.ItemCategory IN (SELECT Category 
					                            FROM   Ref_Category 
												WHERE  FinishedProduct = 1)
												
					</cfif>							 
					
					GROUP BY  ItemNo
					HAVING    SUM(TransactionQuantity) > 0.25			
			        )
					
		ORDER BY Category, ItemDescription				
				 
    </cfquery>  
		
	 <table width="99%" cellspacing="0" cellpadding="0">
							
		<cfif Item.recordcount eq "0">
			
			<tr>
		
			<td>	
			<select name="itemno"
				  onchange="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Workorder/Application/Assembly/EarmarkStock/getItem.cfm?mode=details&mission=#url.mission#&workorderid=#url.workorderid#&itemno='+this.value,'itembox')"
		          visible="Yes"
				  style="height:30px;font-size:17px;10px;width:95%"
		          enabled="Yes"
		          id="itemno"
		          class="regularxl">
				
				<option value=""><cf_tl id="No items found"></option>
		    
			</select>			
			
			</td>
		
			</tr>
			
			<script>
			 document.getElementById('uomlabel').className     = "hide"
			 document.getElementById('boxwarehouse').className = "hide"
			 ptoken.navigate('#SESSION.root#/Workorder/Application/Assembly/EarmarkStock/blank.cfm','stockbox')
			</script>		
		
		<cfelse>
		
			<tr>
		
			<td>	
		
			<!-- <cfform> -->

			<cfselect name="itemno"
				  onchange="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Workorder/Application/Assembly/EarmarkStock/getItem.cfm?mode=details&mission=#url.mission#&workorderid=#url.workorderid#&itemno='+this.value,'itembox')"
		          visible="Yes"
				  query="item"
		          value="itemno"
		          display="name"
				  group="category"
				  style="height:30px;font-size:17px;10px;width:390px"
		          enabled="Yes"
		          id="itemno"
		          class="regularxl">			
		    
			</cfselect>
			
			<!-- </cfform> -->
			
			</td>
		
			</tr>			
		
			<tr><td height="4"></td></tr>
						
			<tr>
		
			<td width="98%" style="height:30px;padding-left:7px;border:0px solid silver" id="itembox">
			
				<cfset url.mode     = "details">
				<cfset url.itemno   = item.itemno>
				<cfinclude template = "getItem.cfm">
			
			</td>
			
			</tr>
			
			<script>
				 document.getElementById('uomlabel').className     = "regular"
				 document.getElementById('boxwarehouse').className = "regular"
				 document.getElementById('stockbox').className     = "regular"
			</script>
		
		</cfif>		
		
	</table>	

</cfif>

</cfoutput>