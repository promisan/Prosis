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
<table cellspacing="0" cellpadding="0">

<cf_verifyOperational 
    datasource= "AppsMaterials"
    module    = "Accounting" 
    Warning   = "No">
		 
	<cfquery name="getItemMaster" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Item
		WHERE   ItemMaster = '#Requisition.ItemMaster#'		
	</cfquery>	 
			
	<cfif getItemMaster.recordcount eq 0>
		<tr>
			<td colspan="4" class="labelit" align="center">Do note no Warehouse item has been created previously for this ItemMaster. 
			Select the category from the below</td>
		</tr> 
	
	</cfif>		
	
	<cfquery name="Cat" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_Category R	
		WHERE 	Category IN (SELECT Category 
		                     FROM   Warehouse W, WarehouseCategory WC
		                     WHERE  W.Warehouse = W.Warehouse
							 AND    W.Mission   = '#Purchase.mission#')
		<cfif Operational eq "1">
		<!--- has a valid GL account --->
		AND 	R.Category IN (SELECT Category 
		                       FROM   Ref_CategoryGLedger R
						       WHERE  Area = 'Stock'
						       AND    GLAccount IN (SELECT GLAccount 
						                            FROM   Accounting.dbo.Ref_Account A
												    WHERE  A.GLAccount = R.GLAccount)
						   )
		</cfif>
		<!--- has subitems defined --->
		AND		R.Category IN (SELECT Category 
		                       FROM   Ref_CategoryItem 
							   WHERE  Category = R.Category)  
	</cfquery>
	
	<cfif getItemMaster.recordcount eq "0">
		<cfset cl = "regular">
	<cfelse>
	    <cfset cl = "hide">
	</cfif>
				
	<cfif Cat.recordcount neq 0>
	
		<tr class="#cl#">
	    
			<td style="padding-right:7px" class="labelit"><cf_tl id="Category">:<font color="FF0000">*</font></b></td>
	   		
			<td style="padding-right:7px">
			<!--- helper --->
			
			<cfif StructKeyExists(helper['category'],getItemMaster.Category)>
				<cfset categoryItem = helper['category']['#getItemMaster.Category#']>
			<cfelse>
				<cfset categoryItem = getItemMaster.CategoryItem>
			</cfif>
					
			<cfselect name="category" 			
				query="Cat" 
				required="Yes" 
				value="Category" 
				class="regularxl"
				style="width:200px"
				onchange="ptoken.navigate('#SESSION.root#/Warehouse/Maintenance/Item/getCategoryItem.cfm?Category='+this.value+'&CategoryItem=#getItemMaster.CategoryItem#','divCategoryItem')"
				message="Please, select a valid item category." 
				display="Description" 
				selected="#getItemMaster.Category#"/>			
					
			</td>
			
			<td class="labelit"><cf_tl id="Category Item"> : <font color="FF0000">*</font></td>
						
		    <td style="padding-right:7px">			
				
				<cf_securediv id="divCategoryItem" bind="url:#SESSION.root#/Warehouse/Maintenance/Item/getCategoryItem.cfm?Category=#getItemMaster.Category#&CategoryItem=#categoryItem#">
			
		    </td>
			
	    </tr>
	
	</cfif>
		
	<cfquery name="getTopics" 
	      datasource="AppsMaterials"
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT   *
		  FROM     Ref_Topic T, Ref_TopicEntryClass C
		  WHERE    T.Code        = C.Code
		  AND      EntryClass    = '#Requisition.EntryClass#'
		  AND      T.Operational = 1
		  ORDER BY ListingOrder
	</cfquery>
	
	<cfset row = 0>
	
	<cfset cont = 0>
	
	<cfoutput query="getTopics">
	
	    <cfif ValueClass eq "List" or ValueClass eq "Lookup">
		
			<cfset cont = cont +1>
		
			<cfset row = row+1>
			<cfset ip  = itempointer>
			
			<cfif row eq "1">
			<tr>
			</cfif>
			
				<td class="labelit" width="90">#TopicLabel#:</td>
			
			    <td style="padding:1px;padding-right:5px">
				
					<cfif valueClass eq "List">
					
					   <cfquery name="GetList" 
						  datasource="AppsMaterials" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
							  SELECT T.*, P.ListCode as Selected
							  FROM   Ref_TopicList T LEFT OUTER JOIN ItemClassification P ON P.Topic = T.Code AND P.ItemNo = '#URL.ItemNo#'
							  WHERE  T.Code = '#GetTopics.Code#'		
							  AND    T.Operational = 1		
					  		  ORDER BY ListOrder
						</cfquery>
					
					<cfelseif valueClass eq "Lookup">
					
					   <cfquery name="GetList" 
						  datasource="#ListDataSource#" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
					
							 SELECT    DISTINCT 
							           #ListPK# as ListCode, 
							           #ListDisplay# as ListValue,
									   P.Value as Selected,
									   #ListOrder# as ListOrder
							  FROM     #ListTable# T
							  		   LEFT OUTER JOIN 
									   	(SELECT ItemNo, Topic, ListCode As Value 
										 FROM Materials.dbo.ItemClassification 
										 WHERE ItemNo='#URL.ItemNo#') P 
									   ON P.Topic = '#GetTopics.Code#' 
							  WHERE    #PreserveSingleQuotes(ListCondition)#
							  ORDER BY #ListOrder#
					
						</cfquery>
					
					</cfif>
					
					<!--- helper --->
					<cfif StructKeyExists(helper['topics'],Requisition.EntryClass)>
						<cfset lastSelected = listGetAt(helper['topics'][Requisition.EntryClass],cont)>
					<cfelse>
					
						<!--- get from requisition classificati8on --->
						
						 <cfquery name="GetValue" 
						  datasource="appsPurchase" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
							SELECT   *
							FROM     RequisitionLineTopic
							WHERE    RequisitionNo = '#url.reqno#' 
							AND      Topic = '#GetTopics.Code#'
						 </cfquery>
						 
						<cfset lastSelected = getValue.ListCode>
												
					</cfif>
					<!--- /helper --->
					
				    <select class="regularxxl" style="width:200px" name="Topic_#GetTopics.Code#" ID="Topic_#GetTopics.Code#">
					
					<!--- disabled
					<cfif ValueObligatory eq "0">
					<option value=""></option>
					</cfif>
					--->
					
					<cfloop query="GetList">
						<cfif ip neq "UoM">
						
							<option value="#GetList.ListCode#" 
								<cfif GetList.Selected eq GetList.ListCode or GetList.ListCode eq lastSelected >selected</cfif>>
								#GetList.ListValue#
							</option>
							
						<cfelse>
							
							<option value="#GetList.ListCode#" 
								<cfif  URL.UoM eq GetList.ListCode or GetList.ListCode eq lastSelected>selected</cfif>>#GetList.ListValue#
							</option>
							
						</cfif>	
					</cfloop>
					</select>					
				
				</td>	
	
			<cfif row eq "2">	
				
				</tr>
				<cfset row=0>
				
			</cfif>
				
		</cfif>
		
	</cfoutput> 

</table>