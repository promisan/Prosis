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
<cfparam name="url.ItemNo" default="">
<cfparam name="url.Mode"   default="Item">
<cfparam name="url.UoM"    default="">
<cfparam name="url.Prefix" default="">
<cfparam name="url.MaterialId" default="">
<cfparam name="url.boxnumber" default="0">

<cfif URL.MaterialId neq "">

	<cfquery name="GetBOM" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM ItemBOMDetail
		WHERE MaterialId = '#URL.MaterialId#'
	</cfquery>		
	
	<cfquery name="GetItem" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    Item I INNER JOIN Ref_Category R ON I.Category = R.Category
		WHERE	I.ItemNo = '#GetBOM.MaterialItemNo#'
	</cfquery>
	
<cfelse>

	<cfquery name="GetItem" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    Item I INNER JOIN Ref_Category R ON I.Category = R.Category
		WHERE	I.ItemNo = '#url.itemno#'				
	</cfquery>
	
</cfif>

<cfoutput>

<!-- <cfform>-->

<table width="100%" border="0" align="center" id="tbox#url.boxnumber#">

	<cfif url.boxnumber eq "0">
		
		<tr class="labelmedium2 line">
		   <td></td>
		   <td><cf_tl id="Item"></td>
		   <td><cf_tl id="Reference"></td>
		   <td><cf_tl id="UoM"></td>
		   <td align="right"><cf_tl id="Quantity"></td>
		   <td align="right"><cf_tl id="Price"></td>	
		   <td></td>  	   
	   </tr>
 	
	</cfif>	

	<tr class="line labelmedium2">
	
		<td style="min-width:20px;padding-top:2px;padding-right:6px">
		<cf_img icon="edit" onclick="editmemo('memo_#url.boxnumber#')" ></td>
		
		<td style="height:22px;width:100%" class="labelit" align="left">
		
			#GetItem.ItemDescription#		
			<input type="hidden" required="true" name="itemno#URL.boxnumber#" id="itemno#URL.boxnumber#" value="#getItem.ItemNo#">	
			<input type="hidden" required="true" name="idisplay#URL.boxnumber#" id="idisplay#URL.boxnumber#" value="1">
			
		</td>
		
		<td align="left" style="min-width:100px;padding-right:1px">
				
			<cfif URL.MaterialId neq "">
				<cfset vRef = GetBOM.MaterialReference>
			<cfelse>
				<cfset vRef = "">	
			</cfif>			
						
			<cfinput type		= "text" 
		         name		= "itemreference#URL.boxnumber#" 
				 id			= "itemreference#URL.boxnumber#"
			     value		= "#vRef#" 
				 class		= "regularxl enterastab"
				 size		= "6" 
				 maxLength =  "9"
				 required	= "no"
				 style		= "border:0px;background-color:f1f1f1;padding-right:3px;border-bottom:0px;text-align: left;">		
					 		
		</td>			
		
		<td id="uombox" style="min-width:200px">
		
			<cfif URL.MaterialId neq "">
				<cfset vUoM = GetBOM.MaterialUoM>
			<cfelse>
				<cfset vUoM = URL.UoM>	
			</cfif>		
		
			<cfquery name="GetUoM" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT 	*
			    FROM 	ItemUoM U
				WHERE	U.ItemNo = '#GetItem.ItemNo#'
			</cfquery>	
			
			<cfif getUoM.recordcount eq "1">
			
				<input type="hidden" name="uom#URL.boxnumber#" value="#getUoM.uom#">			
				#getUoM.UoMDescription# <cfif getUoM.itembarcode neq "">/ #getUoM.ItemBarCode#</cfif>
			
			<cfelse>	
			
				<select name = "uom#URL.boxnumber#" 
				    class    = "regularxl enterastab" 
					style="border:0px;background-color:f1f1f1;"
				    onchange = "ptoken.navigate('#session.root#/Warehouse/Maintenance/Item/UoM/UoMBom/getItemUOM.cfm?boxnumber=#url.boxnumber#&MaterialId=#URL.MaterialId#&ItemNo=#getItem.ItemNo#&UoM='+this.value+'&Mission='+document.getElementById('mission').value,'process')">
					
					<cfloop query="GetUoM">
						<option value="#uom#" <cfif vUoM eq UoM>selected</cfif>>#UoMDescription# <cfif itembarcode neq "">/ #ItemBarCode# </cfif></option>			
					</cfloop>
					
				</select>
			
			</cfif>
			
		</td>
		
		<td align="right" style="min-width:60px;padding-left:1px">
		
			<cfif URL.MaterialId neq "">
				<cfset vQuantity= "#GetBOM.MaterialQuantity#">
			<cfelse>
				<cfset vQuantity = 0>	
			</cfif>
			
			<cfinput type		="text" 
			         name		="itemquantity#URL.boxnumber#" 
					 id			="itemquantity#URL.boxnumber#"
				     value		="#vQuantity#" 
					 validate	="float"
					 message	="Invalid Quantity"
					 class		="regularxl enterastab"
					 size		="3" 
					 required	="yes"
					 style		="border:0px;background-color:f1f1f1;padding-right:3px;width:50px;text-align: right;">				
		</td>	
		
		<td align="right" style="min-width:70px;padding-left:1px">
				
			<cfif URL.MaterialId neq "">
				<cfset vCost = GetBOM.MaterialCost>
			<cfelse>					
				<cfset vCost = GetUom.StandardCost>	
			</cfif>
			
			<cfinput type		= "text" 
			         name		= "itemcost#URL.boxnumber#" 
					 id			= "itemcost#URL.boxnumber#"
				     value		= "#vCost#" 
					 validate	= "float"
					 message	= "Invalid Cost"
					 class		= "regularxl enterastab"
					 size		= "5" 
					 required	= "yes"
					 style		= "border:0px;background-color:f1f1f1;padding-right:3px;width:60px;text-align: right;">				
		</td>			
		
		<td align="right" width="2%" style="padding-left:3px">
			<cf_img icon="delete" onclick="removebox('#url.boxnumber#')">
		</td>
	</tr>

	<tr id="memo_#url.boxnumber#" style="display:none">
	
		<td colspan="6" style="padding-top:3px">
		
			<table width="100%" cellspacing="0" cellpadding="0">
			
			<tr>
		   
			<td style="padding-left:50px" class="labelit"><cf_tl id="Memo">:</td>
			<td style="padding-bottom:3px">
			
				<cfif URL.MaterialId neq "">
					<cfset vMemo=GetBOM.MaterialMemo>
				<cfelse>
					<cfset vMemo="">	
				</cfif>
			
		    	<input type      = "text"
				       name      = "itemmemo#URL.boxnumber#"  
					   id        = "itemmemo#URL.boxnumber#" 
					   value     = "#vMemo#" 
		 			   class     = "regularh" 						
					   maxlength = "80" 
		 			   style     = "border:0px;background-color:f1f1f1;padding-right:3px;;width:100%;text-align: left;">		
				
			</td>
			</tr>
			</table>
		
		</td>
					
	</tr>
										 			
</table>	

<!-- </cfform> -->

</cfoutput>