<cfparam name="url.childassetid" default="">
<cfparam name="url.action"       default="">

<cfif url.action eq "remove">

	<cfquery name="Update" 
	    datasource="appsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		UPDATE    AssetItem
		SET       ParentAssetId = NULL
		WHERE     AssetId       = '#url.childassetid#'
	</cfquery>

<cfelse>
	
	<cfif url.childassetid neq "">
		
		<cfif url.childassetid neq url.assetid>
		
			<cfquery name="CheckChild" 
	   			datasource="appsMaterials" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				SELECT *
				FROM AssetItem
				WHERE AssetId = '#url.childassetid#'
				AND ParentAssetId <> '#url.assetid#'
			</cfquery>

			<cfif CheckChild.recordcount eq "0">
				<cfquery name="Update" 
				    datasource="appsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					UPDATE    AssetItem
					SET       ParentAssetId = '#url.assetid#'
					WHERE     AssetId       = '#url.childassetid#'
				</cfquery>

			<cfelse>
			
				<cfquery name="GetParent" 
		   			datasource="appsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					SELECT * 
					FROM AssetItem
					WHERE AssetId IN (
						SELECT ParentAssetId
						FROM AssetItem
						WHERE AssetId = '#url.childassetid#')						
				</cfquery>		
				
				<cfoutput>
				<script>alert('This Item is a component of the asset with Serial No. #GetParent.SerialNo#') </script>
				</cfoutput>				
				
			</cfif>				
		
		
		</cfif>
	
	</cfif>

</cfif>

<cfquery name="Asset" 
    datasource="appsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    *
	FROM      AssetItem
	WHERE     AssetId = '#url.assetid#'
</cfquery>

<cfquery name="Children" 
    datasource="appsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    *
	FROM      AssetItem
	WHERE     ParentAssetId = '#url.assetid#'
</cfquery>

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">


<tr class="labelit linedotted">
  <td></td>
  <td><cf_tl id="Description"></td>
  <td><cf_tl id="SerialNo"></td>
  <td><cf_tl id="Barcode"></td>
  <td><cf_tl id="Make"></td>
  <td><cf_tl id="Model"></td>
  <td align="right"><cf_tl id="Value"></td>
  <td></td>
</tr>

<!--- show the parent --->

<cfif Asset.ParentAssetId neq "">
	
	<tr><td colspan="8" height="30"><font size="2" color="808080"><cf_tl id="This asset item is a component of"></td></tr>
	
	<cfquery name="Parent" 
	    datasource="appsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT    *
		FROM      AssetItem
		WHERE     AssetId = '#Asset.ParentAssetId#'
	</cfquery>
	
	<cfoutput query="parent">
		
		<tr class="navigation_row labelit linedotted">
		  <td>
		  <img src="#SESSION.root#/Images/edit.gif" alt="" name="img0_#currentrow#" 
						  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
						  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/edit.gif'"
						  style="cursor: pointer;" alt="" width="12" height="13" border="0" align="middle" 
						  onClick="javascript:AssetDialog('#AssetId#')">  
		  </td>
		  <td>#Description#</td>
		  <td>#SerialNo#</td>
		  <td>#AssetBarcode#</td>
		  <td>#Make#</td>
		  <td>#Model#</td>
		  <td align="right">#Numberformat(AmountValue,"__,__.__")#</td>
		  <td align="right">
		  
		         <img src="#SESSION.root#/Images/trash3.gif" alt="Delink" name="img1_#currentrow#" 
					 onMouseOver="document.img1_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
					 onMouseOut="document.img1_#currentrow#.src='#SESSION.root#/Images/trash3.gif'"
					 style="cursor: pointer" alt="" width="13" height="14" border="0" align="middle" 
					 onClick="ColdFusion.navigate('../Parent/ListChildren.cfm?assetid=#assetid#&action=remove&childassetid=#url.assetid#','contentbox1')">    
		  </td>
		</tr>
	
	</cfoutput>
	
<cfelse>
	
	<!--- only if the item is not a subitem you can make it a parent, prevent recursive associations --->
	
	<tr class="navigation_row labelit linedotted"><td colspan="8" align="center" height="35">

	   <cfset link = "../Parent/ListChildren.cfm?assetid=#url.assetid#">	
			
	   <cf_selectlookup
			    box          = "contentbox1"
				link         = "#link#"
				title        = "Asset Selection"
				icon         = "contract.gif"
				button       = "Yes"
				close        = "Yes"
				filter1      = "Mission"
				filter1value = "#Asset.Mission#"
				class        = "asset"
				des1         = "childassetid">

	</td></tr>	
	
</cfif>

<!--- show the children --->

<cfif Children.recordcount gte "1">

<tr><td colspan="8" height="30" class="labelmedium"><font color="gray"><cf_tl id="The following items are part of this asset"></td></tr>

</cfif>

<cfoutput query="children">
	
	<tr class="navigation_row labelit linedotted">
	  <td style="padding-left:4px">
	  <cf_img icon="edit" onClick="javascript:AssetDialog('#AssetId#')" navigation="Yes">  
	  </td>
	  <td>#Description#</td>
	  <td>#SerialNo#</td>
	  <td>#AssetBarcode#</td>
	  <td>#Make#</td>
	  <td>#Model#</td>
	  <td align="right">#Numberformat(AmountValue,"__,__.__")#</td>
	  <td align="right" style="padding-right:4px">
	  		 <cf_img icon="delete" onClick="ColdFusion.navigate('../Parent/ListChildren.cfm?assetid=#url.assetid#&action=remove&childassetid=#assetid#','contentbox1')" navigation="Yes"> 
   	  </td>
	</tr>
	
</cfoutput>

</table>	

<cfset ajaxonload("doHighlight")>
