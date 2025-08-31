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
<cfparam name="url.itemno" default="">
<cfparam name="url.uom"    default="">

<cfset vItemNo = url.ItemNo>

<cfquery name="WorkOrder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrder
		WHERE	WorkOrderId = '#url.workorderid#'						
</cfquery>

<cfquery name="GetItemDef" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Item I INNER JOIN Ref_Category R ON I.Category = R.Category
		WHERE	I.ItemNo = '#vItemNo#'
				
</cfquery>
			
<cfoutput>
	
	<!--<cfform>-->
	
		<table width="100%" cellspacing="0" cellpadding="0">
		
			<tr>
				
				<cfif url.mode neq "Production">
			    <td width="70%" class="labelmedium" style="font-weight:bold;">
					<cf_tl id="Select a valid item" var="1">
					<cfinput type="hidden" required="true" message="#lt_text#" name="itemNo" id="itemNo" value="#vItemNo#" >
					#GetItemDef.Classification# #GetItemDef.ItemDescription# (#getItemDef.ItemNo#)
					
				</td>		
				</cfif>
			
			    <!---
				<td style="padding-left:8px" class="labelit"><cf_tl id="UoM">:</td>
				--->
			   
			    <td class="labelmedium" style="font-weight:bold;">
				
			    	<cfif url.mode neq "read">
					
						<cfquery name="GetUoM" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT 	U.*,
										(SELECT UoM FROM ItemUoM WHERE ItemNo = U.ItemNo AND UoM = '#url.uom#') as Selected
								FROM 	ItemUoM U
								WHERE	U.ItemNo = '#url.ItemNo#'
								
						</cfquery>
						
						<cfset uom = getUoM.UoM>
						
						<cfif getUoM.recordcount lte "1">
						
							<input type="hidden" name="uom" id="uom" value="#GetUoM.Selected#">
							
						<cfelse>
						
							<cf_tl id="Select a valid UoM" var="1">
							<cfselect name="uom" id="uom" query="getUoM" required="true" message="#lt_text#" value="UoM" display="UoMDescription" selected="#GetUoM.Selected#" class="regularxl"/>
							
						</cfif>						
											
					<cfelse>
					
						<cfset uom = url.UoM>
					
						<cfquery name="GetUoM" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT 	U.*
								FROM 	ItemUoM U
								WHERE	1=1	
								AND		U.ItemNo = '#vItemNo#'
								AND		U.UoM    = '#url.uom#'
						</cfquery>
						
						<input type="hidden" name="uom" id="uom" value="#url.uom#">
						
						<cfif getUoM.recordcount eq "1">
							&nbsp;&nbsp;#getUoM.UoMDescription#
						<cfelse>
							<cf_tl id="Select a valid uom" var="1">
							<input type="hidden" required="true" name="uom" id="uom" value="#url.uom#">							
						</cfif>	
						
					</cfif> 
															
				</td>		
			</tr>
			
		</table>			
		
	<!--- check the category of the item, if it is the same we keep the content if it is different we clean it --->
	
	<cftry>
	
	<cfquery name="Clean"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM FinalProduct_#SESSION.acc#
		WHERE  WorkorderId != '#url.workorderid#'
	</cfquery>
	
	<cfcatch></cfcatch>
	
	</cftry>

    <!--- removed 5/5/2014
			
	<cftry>
	
		
		<cfquery name="Check"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 Category 
			FROM   FinalProduct_#SESSION.acc#
			WHERE  WorkorderId = '#url.workorderid#'
		</cfquery>
		
		<cfif vItemno neq "">
			
			<cfif Check.category neq getItemDef.Category>
			
				<cfquery name="Clean"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM FinalProduct_#SESSION.acc#
					WHERE  WorkorderId != '#url.workorderid#'
				</cfquery>
				
			<cfelse>
						
				<cfquery name="Update"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE FinalProduct_#SESSION.acc#
					SET    UoM    = '#uom#'			
					WHERE  WorkorderId = '#url.workorderid#'
					AND    ItemNo = '#vItemno#'
				</cfquery>	
							
			</cfif>	
		
		</cfif>
	
	    <cfcatch></cfcatch>
	
	</cftry>
	
	--->
	
	<!--</cfform>-->	
	
	<script language="JavaScript">
	     if (document.getElementById('selectfields')) {
		  ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/HalfProduct/HalfProductSelectItem.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&itemno=#vitemno#&uom=#uom#&itemmaster=#GetItemDef.ItemMaster#&mission=#workorder.mission#','selectfields')
		 }
	</script>	

</cfoutput>