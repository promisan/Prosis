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

<table width="98%" height="100%" cellspacing="0" cellpadding="0" align="center">

<cfquery name="Asset" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   AssetItem A, Item I
	WHERE  AssetId = '#URL.Assetid#'	
	AND    A.ItemNo = I.ItemNo
</cfquery>

<!--- check access rights --->

<cfinvoke component = "Service.Access"  
   method           = "AssetHolder" 
   mission          = "#Asset.Mission#" 
   assetclass       = "#Asset.category#"
   returnvariable   = "access">	

<cfset prior = "">
<cfset cur   = "">
<cfset back = "">
<cfset next = "">

<cfloop index="itm" list="#url.list#" delimiters="|">

   <cfif Asset.AssetSerialNo eq itm>
 
    <cfif prior neq "" and back eq "">
	    <cfset back = prior>				
	</cfif> 
	<cfset cur = 1>
	
  <cfelse>
  
  	 <cfif cur eq "1" and next eq "">
     <cfset cur = "">
	 <cfset next = itm>
	 </cfif>	
	  
  </cfif>
      
  <cfset prior = itm>

</cfloop>

<cfoutput>

<cfset itm = 0>  
	   
<tr><td>
	<table width="100%" cellspacing="0" cellpadding="0"><tr>
		
	<cfset wd = "64">
	<cfset ht = "64">
	
	<cfset itm = itm+1>  

	<cf_tl id = "General Information" var = "1">
	<cf_menutab item  = "#itm#" 
       iconsrc    = "Information.png" 
	   iconwidth  = "#wd#" 
	   iconheight = "#ht#" 
	   class      = "highlight1"
	   name       = "#lt_text#"
	   source     = "../AssetEntry/AssetEdit.cfm?assetid=#url.assetid#">	
	 	   
	<cfset itm = itm+1>  

	<cf_tl id = "Photo" var = "1">	   
	
	<cf_menutab item  = "#itm#" 
       iconsrc    = "Set-Profile-Pic.png" 
	   iconwidth  = "#wd#" 
       targetitem = "1"	  
	   iconheight = "#ht#" 
	   name       = "#lt_text#"
	   source     = "AssetPictureBox.cfm?assetid=#URL.assetid#">	
	   
	 <cfset itm = itm+1>  

 	  <cf_tl id = "Depreciation Log" var = "1">	   	   		   	   	   
	  <cf_menutab item  = "#itm#" 
	   targetitem = "1"
       iconsrc    = "Depreciation.png" 
	   iconwidth  = "#wd#" 
	   iconheight = "#ht#" 
	   name       = "#lt_text#"
	   source     = "../AssetDetail/ItemDetailDepreciation.cfm?assetid=#URL.assetid#">
			   
	<cfset itm = itm+1>        	

	<cf_tl id = "Observations and Action" var = "1">	
	   	   
	<cf_menutab item   = "#itm#" 
	   targetitem = "1"
       iconsrc    = "Observe-Action.png" 
	   iconwidth  = "#wd#" 
	   iconheight = "#ht#" 
	   name       = "#lt_text#"
	   source     = "AssetAction.cfm?assetid=#URL.assetid#">	   
	
	<!--- asset service / workorder log --->
	   
 	<cf_tl id = "Service History" var = "1">	
	
	<cf_VerifyOperational Module="WorkOrder">
	
	<cfif operational eq "1"> 
	
		<cfquery name="CheckWorkOrder" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT TOP 1 *
		    FROM   WorkOrderLineAsset
			WHERE  AssetId = '#URL.Assetid#'			
		</cfquery>   
		
		<cfif checkworkorder.recordcount gte "1">	
		
			<cfset itm = itm+1>    	   		   	   
			
			<cf_menutab item   = "#itm#" 
			   targetitem      = "1"
		       iconsrc         = "Logos/User/UserGroup.png" 
			   iconwidth       = "#wd#" 
			   iconheight      = "#ht#" 
			   name            = "#lt_text#"
			   source          = "../Service/ServiceList.cfm?assetid=#URL.assetid#">	 
		   
		</cfif> 
	
	</cfif>  
		   	
	<cfquery name="CheckSupply" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    
		<!--- asset itself is a consumer --->
	    
		SELECT TOP 1 *
	    FROM   ItemTransaction
		WHERE  AssetId = '#URL.Assetid#' 	
		AND    TransactionQuantity < 0	
		
		<!--- or one of the children is the consumer of the supplies --->
		
		UNION
		
		SELECT TOP 1 *
	    FROM   ItemTransaction
		WHERE  AssetId IN (SELECT AssetId 
		                   FROM   AssetItem 
						   WHERE  ParentAssetid = '#URL.Assetid#') 	
		AND    TransactionQuantity < 0	
			
	</cfquery>   	
				   
	 <cfif (checksupply.recordcount gte "1" and Asset.ParentAssetId eq "") or (getAdministrator(asset.mission) eq "1" and checksupply.recordcount gte "1")>
	 
		 <cfset itm = itm+1>    
		 <input type="hidden" name="consumptionViewMenuItem" id="consumptionViewMenuItem" value="#itm#">
		 
	 	<cf_tl id = "Consumption Analysis" var = "1">	   	   
		 <cf_menutab item   = "#itm#" 
		   targetitem = "1"
	       iconsrc    = "Logos/Warehouse/monitoring.png" 
		   iconwidth  = "#wd#" 
		   iconheight = "#ht#" 
		   name       = "#lt_text#"
		   source     = "Consumption/AssetSupplyConsumptionView.cfm?assetid=#URL.assetid#&height={height}&width={width}">	
	 
	 </cfif>  	
	   
	 <cfif access eq "EDIT" or access eq "ALL">
	   
		 <cfset itm = itm+1>    
		   
	 	 <cf_tl id = "Components" var = "1">	   	   		   
		 <cf_menutab item   = "#itm#" 
		   targetitem = "1"
	       iconsrc    = "Components.png" 
		   iconwidth  = "#wd#" 
		   iconheight = "#ht#" 
		   name       = "#lt_text#"
		   source     = "../Parent/ListChildren.cfm?assetid=#url.assetid#">	
	   
	 </cfif>       	   
	 
	  <cfset itm = itm+1>
	  <input type="hidden" name="consumptionMenuItem" id="consumptionMenuItem" value="#itm#">

   	  <cf_tl id = "Consumption" var = "1">	   	   		   	   	   
	  <cf_menutab item  = "#itm#" 
	   targetitem = "1"
       iconsrc    = "Consumption.png" 
	   iconwidth  = "#wd#" 
	   iconheight = "#ht#" 
	   name       = "#lt_text#"
	   source     = "../../../Maintenance/Item/Consumption/ItemSupply.cfm?id=#URL.assetid#&type=AssetItem">
	  
   </tr></table>

</tr>

<tr><td height="4"></td></tr>

<tr><td class="linedotted"></td></tr>

</cfoutput>

<tr><td height="30" align="center" style="padding-left:10px;padding-right:10px">

    <cfoutput>
	
	<table width="97%" align="center" cellspacing="0" cellpadding="0">
		
	<tr>
	
	<td align"right">
	
	<cfif back neq "">
	
		<cfquery name="Check" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT *
		    FROM   AssetItem
		    WHERE  AssetSerialNo = '#back#'	
		</cfquery>
						
		<cfif check.recordcount eq "1">
	
		<img src="#SESSION.root#/Images/iconback.jpg" 
		     style="cursor: pointer;" 
			 onclick="navigate('#check.assetid#')" 
			 border="0">
			 
		</cfif>	 
		
	</cfif>
	
	</td>
	<td width="5"></td>
	<td width="100%" align="center">
		<table width="100%" class="formspacing">
		   
			<tr>
			<td height="50" class="labelmedium"><font color="808080"><cf_tl id="SerialNo">:</td>
			<td class="labelmedium">#Asset.SerialNo#</td>
			<td class="labelmedium"><font color="808080"><cf_tl id="Make">/<br><cf_tl id="Model">:</td>
			<td class="labelmedium">#Asset.Make#/<br>#Asset.Model#</td>
			<td class="labelmedium"><font color="808080"><cf_tl id="Barcode">/<br><cf_tl id="DecalNumber"></td>
			<td class="labelmedium"><cfif Asset.AssetBarCode eq "">n/a<cfelse>#Asset.AssetBarCode#</cfif>	<br>
			                       <cfif Asset.AssetDecalNo eq "">n/a<cfelse>#Asset.AssetDecalNo#</cfif></td>
			<td></td>
			<td class="labelmedium"><font color="808080"><cf_tl id="Value">:</td>
			<td class="labelmedium">#numberformat(Asset.depreciationbase,"__,__.__")#</td>
			</tr>			
		</table>
	</td>
	<td width="5"></td>
	<td align="left">
	<cfif next neq "">
	
		<cfquery name="Check" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT *
		    FROM   AssetItem
			WHERE  AssetSerialNo= '#next#'	
		</cfquery>
		
		<cfif check.recordcount eq "1">
		
		<img src="#SESSION.root#/Images/iconnext.jpg" 
		     style="cursor: pointer;"
			 onclick="navigate('#check.assetid#')" 
			 border="0">
			 
		</cfif>	 
		
	</cfif>
	</td>
	</tr>
	</table>
	
	</cfoutput>
	
</td></tr>

<tr><td class="linedotted"></td></tr>

<tr><td height="5"></td></tr>
<tr><td>
	<cf_menucontainer item="1" class="regular">
		 <cfinclude template="../AssetEntry/AssetEdit.cfm"> 
 	<cf_menucontainer>	
</td></tr>

</table>
