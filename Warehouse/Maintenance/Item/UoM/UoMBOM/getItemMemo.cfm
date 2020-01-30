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

<table width="100%" border="0"  align="center" id="tbox#url.boxnumber#">

	<cfif url.boxnumber eq "0">
		
		<tr class="labelit line">
		   <td></td>
		   <td><cf_tl id="Item"></td>
		   <td><cf_tl id="Reference"></td>
		   <td><cf_tl id="UoM"></td>
		   <td align="right"><cf_tl id="Quantity"></td>
		   <td align="right"><cf_tl id="Price"></td>	  	   
	   </tr>
 	
	</cfif>	

	<tr class="line">
		<td width="1%" style="padding-top:2px;padding-right:6px"><cf_img icon="edit" onclick="editmemo('memo_#url.boxnumber#')" ></td>
		
		<td style="height:22px" class="labelit" width="50%" align="left">
		
			#GetItem.ItemDescription#		
			<input type="hidden" required="true" name="itemno#URL.boxnumber#" id="itemno#URL.boxnumber#" value="#getItem.ItemNo#">	
			<input type="hidden" required="true" name="idisplay#URL.boxnumber#" id="idisplay#URL.boxnumber#" value="1">
			
		</td>
		
		<td width="10%" align="left" style="padding-right:1px">
				
			<cfif URL.MaterialId neq "">
				<cfset vRef = GetBOM.MaterialReference>
			<cfelse>
				<cfset vRef = "">	
			</cfif>			
						
			<cfinput type		= "text" 
		         name		= "itemreference#URL.boxnumber#" 
				 id			= "itemreference#URL.boxnumber#"
			     value		= "#vRef#" 
				 class		= "regular enterastab"
				 size		= "6" 
				 maxLength =  "9"
				 required	= "no"
				 style		= "border:1px solid gray;height:19px;text-align: left;">		
					 		
		</td>			
		
		<td id="uombox" width="35%" style="font-size:11px"class="labelit">
		
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
				&nbsp;&nbsp;#getUoM.UoMDescription# <cfif getUoM.itembarcode neq "">/ #getUoM.ItemBarCode#</cfif>
			
			<cfelse>	
			
				<select name = "uom#URL.boxnumber#" 
				    class    = "regularh enterastab" 
				    onchange = "ColdFusion.navigate('#session.root#/Warehouse/Maintenance/Item/UoM/UoMBom/getItemUOM.cfm?boxnumber=#url.boxnumber#&MaterialId=#URL.MaterialId#&ItemNo=#getItem.ItemNo#&UoM='+this.value+'&Mission='+document.getElementById('mission').value,'process')" 
				    style    = "border:1px solid gray;height:16px;width:97%">
					
					<cfloop query="GetUoM">
						<option value="#uom#" <cfif vUoM eq UoM>selected</cfif>>#UoMDescription# <cfif itembarcode neq "">/ #ItemBarCode# </cfif></option>			
					</cfloop>
					
				</select>
			
			</cfif>
			
		</td>
		
		<td width="6%" align="right" style="Padding-left:1px">
		
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
					 class		="regular enterastab"
					 size		="3" 
					 required	="yes"
					 style		="border:1px solid gray;width:50px;height:19px;text-align: right;">				
		</td>	
		
		<td width="6%" align="right" style="padding-left:1px">
				
			<cfif URL.MaterialId neq "">
				<cfset vCost = GetBOM.MaterialCost>
			<cfelse>					
				<cfset vCost = GetUom.StandardCost>	
			</cfif>
			
			<cfinput type		="text" 
			         name		="itemcost#URL.boxnumber#" 
					 id			="itemcost#URL.boxnumber#"
				     value		="#vCost#" 
					 validate	="float"
					 message	="Invalid Cost"
					 class		="regular enterastab"
					 size		="5" 
					 required	="yes"
					 style		="border:1px solid gray;width:60px;height:19px;text-align: right;">				
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
		 			   style     = "border:1px solid gray;width:100%;text-align: left;">		
				
			</td>
			</tr>
			</table>
		
		</td>
					
	</tr>
										 			
</table>	

<!-- </cfform> -->

</cfoutput>