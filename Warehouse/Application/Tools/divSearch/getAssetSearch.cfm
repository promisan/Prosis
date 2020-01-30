
<script>
	 try {
	 document.getElementById('personselectbox').className = "hide" 
	 } catch(e) {}

</script>

<cfif url.search eq "">

	<script>
		 document.getElementById("assetselectbox").className = "hide"
	</script> 

<cfelse>

	<script>
		 document.getElementById("assetselectbox").className = ""
	</script> 
	
</cfif>

<cfquery name="Category" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Ref_Category
	WHERE Category = '#url.category#'
</cfquery>	

<cfquery name="Get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     TOP 9 A.*, I.ItemDescription,
	
	             (
				 SELECT TOP 1 O.OrgUnitName 
				 FROM   Organization.dbo.Organization O,
				        AssetItemOrganization AO
				 WHERE  AO.AssetId = A.AssetId
				 AND    O.OrgUnit = AO.OrgUnit
				 AND    ActionStatus = '1'
				 ORDER BY AO.DateEffective DESC
				 ) AS OrgUnitName,					
			   
	         C.Category
			 
	FROM       AssetItem A INNER JOIN Item I ON A.ItemNo = I.ItemNo 
	INNER JOIN Ref_Category C ON C.Category = I.Category  			
	WHERE      (AssetBarCode LIKE '%#url.search#%' OR AssetDecalNo LIKE '%#url.search#%' OR SerialNo LIKE '%#url.search#%')	
	AND        A.Mission = '#url.mission#'	
	<!--- filter the search on the category of the item as selected --->	
	AND        A.ItemNo IN  (SELECT ItemNo 
	                         FROM   Item 
	                         WHERE  Category = '#url.category#')	
	<!--- filter of the item is indeed to be supplied this type of supply item --->
	AND     (   
	            
				A.AssetId IN (SELECT S.AssetId 
	                         FROM   AssetItemSupply S
							 WHERE  S.AssetId      = A.Assetid
							 AND    S.SupplyItemNo = '#url.itemno#'
							 AND    S.Operational = 1) 
				
				OR
				
				I.ItemNo IN (SELECT S.ItemNo 
	                         FROM   ItemSupply S
							 WHERE  S.ItemNo       = I.ItemNo
							 AND    S.SupplyItemNo = '#url.itemno#'
							 AND    S.Operational = 1) 
							 
			)							 
							 
	<!--- limit to items enabled for warehouse only --->						 
	<cfif Category.DistributionFilter eq "1">
		AND        A.AssetId IN (
		                         SELECT AssetId 
		                         FROM   AssetItemSupplyWarehouse 
								 WHERE  AssetId      = A.Assetid
								 AND    SupplyItemNo = '#url.itemno#'
								 AND    Warehouse    = '#url.warehouse#' 
								 ) 
	</cfif>			
	<!--- added 3/4/2012 --->	
	AND    A.Operational = 1		
		 
	ORDER BY   AssetDecalNo, AssetBarCode 
</cfquery>

<table width="500" border="1" cellspacing="0" cellpadding="0" bordercolor="silver" bgcolor="white" class="formpadding">

<input type="hidden" name="assetselectrow" id="assetselectrow" value="0">

<cfif get.recordcount eq "0">

<tr><td height="50" align="center"><font size="2"><cf_tl id="No records found"></td></tr>

</cfif>

<cfoutput query="get">

	<cfif currentrow eq "1">

    <script>
		document.getElementById('assetidselect').value='#assetid#'
	</script>
	
	</cfif>

	<tr><td 
	    id          = "assetline#currentrow#" 
	    name        = "assetline#currentrow#" 
	    onclick     = "document.getElementById('assetselect').value='<cfif get.AssetDecalNo neq "">#AssetDecalNo#<cfelse>#AssetBarCode#</cfif>';document.getElementById('assetidselect').value='#assetid#';ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/Transaction/getAsset.cfm?mission=#url.mission#&assetid='+document.getElementById('assetidselect').value,'assetbox')" 
	    class       = "regular" 
		style       = "cursor:pointer"
	    onmouseover =  "if (this.className=='regular') { this.className='highlight2' }"
		onmouseout  =  "if (this.className=='highlight2') { this.className='regular' }">
		
		<cfif get.AssetDecalNo neq "">
		
			<input type="hidden" name="r_#currentrow#_assetmeta" id="r_#currentrow#_assetmeta" value="#get.AssetDecalNo#">
		
		<cfelse>
		
		    <input type="hidden" name="r_#currentrow#_assetmeta" id="r_#currentrow#_assetmeta" value="#get.AssetBarCode#">
		
		</cfif>
		
		<input type="hidden" name="r_#currentrow#_assetid" id="r_#currentrow#_assetid"       value="#assetid#">
		
		<table cellspacing="0" cellpadding="0">
		
			<tr>
				<td class="labelit" width="10%" style="padding-left:3px"><font color="808080"><cf_space spaces="20"><cf_tl id="Make">:</font></td>
			    <td class="labelit" style="padding-left:5px;padding-right:3px" width="40%" >#get.Make# </td>
				<td class="labelit" height="18" style="padding-left:3px" width="10%"><font color="808080"><cf_space spaces="20"><cf_tl id="Model">:</font></td>
				<td class="labelit" style="padding-left:5px;padding-right:3px" width="40%"><cf_space spaces="60">#get.Model#</td>
			</tr>			
							
			<tr>
				<td class="labelit" style="padding-left:3px"><font color="808080">Item:</td>
				<td class="labelit" colspan="1" style="padding-left:5px;padding-right:3px">#ItemDescription#</td>
				<td class="labelit" style="padding-left:3px"><font color="808080">Unit:</td>
				<td class="labelit" colspan="1" style="padding-left:5px;padding-right:3px">#OrgUnitName#</td>
			</tr>
			
			<tr><td class="labelit" height="18" style="padding-left:3px"><font color="808080"><cf_tl id="Name">:</font></td>
			    <td class="labelit" colspan="3" style="padding-left:5px;padding-right:3px">#get.Description# </td>
			</tr>
				
			<cfif get.AssetDecalNo neq "">				
			<tr>				
				<td class="labelit" height="18" style="padding-left:3px"><font color="808080"><cf_tl id="DecalNumber">:</font></td>
				<td class="labelit" style="padding-left:5px;padding-right:3px">#get.AssetDecalNo#</td>
			</tr>
			</cfif>
			<cfif get.AssetBarCode neq "">
			<tr>				
					<td  style="padding-left:3px" class="labelit"><font color="808080"><cf_tl id="BarCode">:</td>
					<td style="padding-left:5px;padding-right:3px" class="labelit">#get.AssetBarCode#</td>
			</tr>
			</cfif>
			<cfif get.AssetSerialNo neq "">
			<tr>			
					<td  style="padding-left:3px" class="labelit"><font color="808080"><cf_tl id="SerialNo">:</td>
					<td style="padding-left:5px;padding-right:3px" class="labelit">#get.SerialNo#</td>	
			</tr>		
			</cfif>
						
			<cfif currentrow neq recordcount>
				<tr><td colspan="4" class="line"></td></tr>
			</cfif>
		
		</table>
	
	</td></tr>
			
</cfoutput>

</table>
