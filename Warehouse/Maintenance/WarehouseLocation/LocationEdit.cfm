
<cfparam name="url.access" default="ALL">

<cfquery name="getWhs" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Warehouse
	WHERE  Warehouse = '#url.warehouse#'	
</cfquery>

<cfquery name="getParam" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_ParameterMission
	WHERE    Mission = '#getWhs.Mission#'	
</cfquery>

<cfquery name="getVendor" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Organization
	WHERE    Mission = '#getParam.TreeVendor#'	
	ORDER BY OrgUnitName
</cfquery>

<cfquery name="get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   WarehouseLocation
	WHERE  Warehouse = '#url.warehouse#'
	AND    Location = '#url.location#'	
</cfquery>

<cfquery name="getLoc" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Location
	<cfif get.LocationId neq "">
	WHERE  Location = '#get.LocationId#'
	<cfelse>
	WHERE 1=0
	</cfif>
</cfquery>

<cfquery name="class" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_WarehouseLocationClass	
</cfquery>

<cf_divscroll>

<cfform method="POST" name="formlocation">

<table width="97%" align="center" class="formspacing" cellspacing="0" cellpadding="0">

<tr>

<td width="80%" valign="top">

	<table width="99%" align="center" class="formspacing" cellpadding="0">
	
	<tr><td colspan="1" style="padding-top:5px" class="labelmedium"><cf_tl id="Identification">:</td>
	
	  <td width="80%">
		
		<select name="LocationClass" id="LocationClass" class="regularxl">
		<cfoutput query="class">
			<option value="#code#" <cfif get.LocationClass eq code>selected</cfif>>#Description#</option>
		</cfoutput>
		</select>
	
	   </td>
	</tr>
						
	<tr><td height="20" class="labelmedium"><cf_tl id="Name">:</td>
	
	<td>
	
		   	<cfinput type="Text"
			       name="locationdescription"
			       value="#get.Description#"
				   class="regularxl"		    
				   message="Please enter name" 
			       visible="Yes"
			       enabled="Yes"
			       typeahead="No"
			       size="60"
			       maxlength="100"
				   style="text-align:left">
					   			   
	</td>
	</tr>
	
					
	<tr><td height="20" class="labelmedium"><cf_tl id="Operated by">:</td>
	
	<td>
	
	<select name="OrgUnitOperator" id="OrgUnitOperator" class="regularxl" onchange="if (this.value == '') {document.getElementById('billingbox').className='hide';document.getElementById('consignment').className='regular' } else { document.getElementById('billingbox').className='regular';document.getElementById('consignment').className='hide' }">
	    <option value="">--<cf_tl id="Internal">--</option>
		<cfoutput query="getVendor">
			<option value="#OrgUnit#" <cfif get.OrgUnitOperator eq OrgUnit>selected</cfif>>#OrgUnitName#</option>
		</cfoutput>
		</select>				   			   
	</td>
	
	</tr>
	
	<tr><td class="labelmedium"><cf_tl id="Geo Location">:</td>
	
	<td>
	<cfoutput>
	   <table><tr><td>
	   <input type="text"   name="locationname" id="locationname"   value="#getloc.LocationName#" class="regularxl" size="40" maxlength="60" readonly style="text-align: left;">
	   <input type="hidden" name="locationid"   id="locationid"     value="#getloc.Location#"> 
	   <input type="hidden" name="locationcode" id="locationcode"   value="">
	   </td>
	   <td style="padding-left:2px">
	   
	   <input type="button" class="button10g" style="width:30px"  name="search" id="search" value=" ... "  
	   onClick="selectloc('formlocation','locationid','locationcode','locationname','orgunit','orgunitname','personno','name','#getWhs.mission#')"> 	
	   
	   </td></tr></table>
	</cfoutput>
	
	</td></tr>
					
	<tr><td height="20" class="labelmedium"><cf_tl id="Barcode">:</td>
	
	<td>
	
		   	<cfinput type="Text"
			       name="storagecode"
			       value="#get.StorageCode#"
				   class="regularxl"		    
				   message="Please enter storage code" 
			       visible="Yes"
			       enabled="Yes"
			       typeahead="No"
			       size="15"
			       maxlength="20"
				   style="text-align:left">
					   			   
	</td>
	</tr>
	
	
	
	<tr><td style="padding-top:5px" class="labelmedium"><cf_tl id="Storage Dimensions">:<cf_space spaces="50"></td>
	    <td>
			<select name="storageShape" id="storageShape" class="regularxl">
				<option value="Rectangle" <cfif lcase(get.StorageShape) eq "rectangle">selected</cfif>><cf_tl id="Rectangle">
				<option value="Ellipse" <cfif lcase(get.StorageShape) eq "ellipse">selected</cfif>><cf_tl id="Ellipse">
				<option value="N/A" <cfif lcase(get.StorageShape) eq "n/a">selected</cfif>>N/A
			</select>
		</td>
	</tr>	
	<cfoutput>
	
	<tr><td align="right" class="labelit"><cf_tl id="Width">:</td>
	    <td>
		 <table cellspacing="0" cellpadding="0">
		  <tr><td>
	  	    <cf_tl id="cms"  var="vcms">
			<cfinput type="Text"
			       name="storageWidth"
			       value="#get.storageWidth#"
				   class="regular"	
				   style="text-align:center"	    
			       size="5"
			       maxlength="6">
			</td><td class="labelit" style="padding-left:3px">#vcms#.</td>
		</td>
	
	    <td align="right" class="labelit" style="padding-left:13px"><cf_tl id="Height">:</td>
	    <td style="padding-left:3px">
			<cfinput type="Text"
			       name="storageHeight"
			       value="#get.storageHeight#"
				   class="regular"		
				   style="text-align:center"    
			       size="5"
			       maxlength="6">
			</td><td class="labelit" style="padding-left:3px">#vcms#.</td>
		</td>
	
		<td align="right" class="labelit" style="padding-left:13px"><cf_tl id="Depth">:</td>
	    <td style="padding-left:3px">
			<cfinput type="Text"
			       name="storageDepth"
			       value="#get.storageDepth#"
				   class="regular"
				   style="text-align:center"		    
			       size="5"
			       maxlength="6">
			</td><td class="labelit" style="padding-left:3px">#vcms#.</td>
		</td>
		
		</tr>
		</table>
	</tr>	
	</cfoutput>
	
	<cfquery name="GetAsset" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    AssetItem
		<cfif get.Assetid eq "">
		WHERE 1=0
		<cfelse>
		WHERE   AssetId = '#get.AssetId#'	
		</cfif>
	</cfquery>
	
	<tr>
	
	<td colspan="2" style="padding-top:5px">
	
		<table cellspacing="0" cellpadding="0">
		<tr>
		<td class="labelmedium"><cf_tl id="Associated Asset"></td>
		<td id="resetasset" style="padding-left:4px;padding-top:4px" class="<cfif getAsset.recordcount eq "1">hide</cfif>"><cf_img icon="delete" onclick="ColdFusion.navigate('resetAsset.cfm','process')"></td>
		<td id="process"></td>
		</tr>
		</table>
	</td>
	
	<td>		
				
				<cfset link = "#SESSION.root#/warehouse/maintenance/warehouselocation/getAsset.cfm?">												
							
				<cfquery name="UoM" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  TOP 1 *
					FROM    ItemUoM
					WHERE   ItemNo = '#getAsset.itemno#'		 				 
				</cfquery>	
									
				<cfoutput>		
				</td>
	
	</td>
	<td id="assetselectbox" class="hide"><input type="hidden" name="AssetId" id="AssetId" value="#getAsset.AssetId#">&nbsp;</td>	
	</tr>
	
	<tr><td align="right" class="labelit"><cf_tl id="SerialNo">:</td>
	    <td><input type="text" class="regular2" value="#getAsset.SerialNo#" readonly name="serialno" id="serialno" style="width:150">
			
				<cf_selectlookup
					    box          = "assetselectbox"
						link         = "#link#"
						title        = "Search"
						icon         = "contract.gif"
						button       = "No"
						style        = "width:20;height:23"
						close        = "Yes"					
						class        = "asset"
						des1         = "assetid">	
		
		</td>
	</tr>	
	
	<tr><td align="right" class="labelit"><cf_tl id="Description">:</td>
	    <td><input type="text" class="regular2" value="#getAsset.Description#" readonly name="description" id="description" style="width:270"></td>
	</tr>	
	
	<tr><td align="right" class="labelit"><cf_tl id="Barcode">:</td>
	    <td><input type="text" class="regular2" value="#getAsset.AssetBarCode#" readonly name="assetbarcode" id="assetbarcode" style="width:100"></td>
	</tr>	
	
	<tr><td align="right" class="labelit"><cf_tl id="DecalNo">:</td>
	    <td><input type="text" class="regular2" value="#getAsset.AssetDecalNo#" readonly name="assetdecalno" id="assetdecalno" style="width:100"></td>
	</tr>	
	
	<tr><td align="right" class="labelit"><cf_tl id="Make">:</td>
	    <td><input type="text" class="regular2" value="#getAsset.Make#" readonly name="make" id="make" style="width:60"></td>
	</tr>	
	
	<tr><td align="right" class="labelit"><cf_tl id="Value">:</td>
	    <td><input type="text" class="regular2" value="#numberformat(UoM.StandardCost,'__,__.__')#" readonly name="price" id="price" style="text-align:right;width:80"></td>
	</tr>	
	
	</cfoutput>
	
		
	<tr><td colspan="2" style="padding-top:5px;height:42px" class="labellarge"><cf_tl id="Operations and Distribution settings"></td>
	
	<tr>
	<td height="25" style="padding-left:10px" class="labelmedium"><cf_UIToolTip tooltip="This storage location is hidden in any process"><cf_tl id="Operational">:</cf_UIToolTip></td>
	<td>   
	   <input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif "1" eq get.operational>checked</cfif>>					
	</td>
	</tr>
	
	<cfquery name="getCustomer" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   *
				    FROM     Customer
					WHERE    Mission = '#getWhs.Mission#'	
					ORDER BY CustomerName
				</cfquery>
						
	<tr><td style="padding-left:10px" height="20" class="labelmedium"><cf_tl id="Pickorder Priority">:</td>
	
	<td>
	
		   	<cfinput type="Text"
			       name="ListingOrder"
			       value="#get.ListingOrder#"
				   class="regularxl"
			       validate="integer"
			       required="Yes"
				   message="Please enter an order value" 
			       visible="Yes"
			       enabled="Yes"
			       typeahead="No"
			       size="1"
			       maxlength="2"
				   style="text-align:center">
					   			   
	</td>
			
	</tr>
	
	
	<cfoutput>
		
	<cfif get.OrgUnitOperator eq "">
	   <cfset cl = "hide">   
	<cfelse>
	   <cfset cl = "regular">
	</cfif>
	
	 <tr id="billingbox" class="<cfoutput>#cl#</cfoutput>">
		
		<td height="25" style="padding-left:10px" class="labelmedium"><cf_UIToolTip tooltip="Managed by"><cf_tl id="Stock Owned">:</cf_UIToolTip></td>
		<td>  
		 <table class="formpadding" cellspacing="0" cellpadding="0">
		 
		 	 <cfset tog = "if (this.value != 'Internal') {document.getElementById('customerboxbilling').className='regular' } else { document.getElementById('customerboxbilling').className='hide' }">
	
			 <tr>
				 <td><input type="radio" class="radiol" onclick="#tog#" name="BillingMode" id="BillingMode" value="Internal" <cfif "Internal" eq get.BillingMode>checked</cfif>></td>
				 <td style="padding-left:6px" class="labelmedium">#getWhs.mission#</td>
				 				 
				 <td style="padding-left:8px"><input type="radio" onclick="#tog#" class="radiol" name="BillingMode" id="BillingMode" value="External" <cfif "External" eq get.BillingMode>checked</cfif>></td>
				 <td style="padding-left:6px" class="labelmedium"><cf_tl id="Operator">(<cf_tl id="AR / AP">)</td>	 
				 
				 <cfif get.billingMode neq "Internal">
				   <cfset cl = "regular">   
				 <cfelse>
				   <cfset cl = "hide">
				 </cfif>
				 
				 <td style="padding-left:8px" id="customerboxbilling" class="#cl#"> : 
				  <select name="DistributionCustomerIdBilling" id="DistributionCustomerIdBilling" class="regularxl">	   
				  <cfloop query="getCustomer">
					<option value="#CustomerId#" <cfif get.DistributionCustomerId eq CustomerId>selected</cfif>>#CustomerName#</option>
				  </cfloop>
				 </select>		
				 </td>
				 
			  </tr>
		  </table> 
		</td>
	  </tr>			
	
	</cfoutput>
				  
	<tr>
	<td height="20" valign="top" style="padding-top:4px;padding-left:10px" class="labelmedium"><cf_UIToolTip tooltip="This storage location can be used in a taskorder fullfilment process"><cf_tl id="Distribution role">:</cf_UIToolTip></td>
	<td height="25">  
	 <table class="formpadding" cellspacing="0" cellpadding="0">
	 
	 <cfoutput>
	 <cfset tog = "if (this.value != '2') {document.getElementById('customerbox').className='hide' } else { document.getElementById('customerbox').className='regular' }">
	 
	 <cfif get.Distribution eq "2">
	 	<cfset cl = "regular">
	 <cfelse>
	    <cfset cl = "hide">
	 </cfif>
	 <!--- this is the default mode --->
	 
	 <tr>		
		 <td><input type="radio" onclick="#tog#" class="radiol" name="Distribution" id="distributor" value="1" <cfif "1" eq get.Distribution>checked</cfif>></td>		 
		 <td class="labelmedium" style="padding-left:6px"><cf_tl id="May distribute to other locations"> (<cf_tl id="default">)</td>
	 </tr>	 
	 
	 <!--- this is the default mode --->	
	
	 <tr>	
		 <td class="labelmedium"><input type="radio"  onclick="#tog#" class="radiol" name="Distribution" id="internal" value="0" <cfif "0" eq get.Distribution>checked</cfif>></td>
		 <td class="labelmedium" style="padding-left:6px"><cf_tl id="Issues internally"></td>
	 </tr>	 
		
		 <!--- 5/5/2015 Hanno i dropped the condition if the location to be associated to an asset 
		 <td class="label" style="padding-left:4px">  
		 <input type="radio" name="Distribution" id="consumption" <cfif getAsset.recordcount eq "0">disabled</cfif> value="8" <cfif "8" eq get.Distribution>checked</cfif>>
		 </td>
		 --->
		 
	  <!--- this means that any issuance/variance can be billed to the defined customer --->	 
	  
	  <cfif get.OrgUnitOperator eq "">
	   <cfset cl = "regular">   
	  <cfelse>
	   <cfset cl = "hide">
	  </cfif>
		 
	  <tr id="consignment" class="#cl#">	 
		 <td class="labelmedium">  
		 <input type="radio"  onclick="#tog#" class="radiol" name="Distribution" id="consignment" value="2" <cfif "2" eq get.Distribution>checked</cfif>>
		 </td>
		 <td class="labelmedium" style="padding-left:6px">
		 
			 <table><tr>
			 
			 <td class="labelmedium" style="padding-right:4px"> <cf_tl id="Issues under Consignment"></td>
			 
			 <td id="customerbox" class="#cl#"> :
							
				 
				 <select name="DistributionCustomerId" id="DistributionCustomerId" class="regularxl" style="width:220px">	   
				 <cfloop query="getCustomer">
					<option value="#CustomerId#" <cfif get.DistributionCustomerId eq CustomerId>selected</cfif>>#CustomerName#</option>
				 </cfloop>
				 </select>		
				 		 
			   </td>
				 
			   </tr>
			   
			  </table>
		 
		</td>
		 
	  </tr>		 
	  
	  <!--- this mode means that upon receipt the quantity is immediately consumed by this location, which acts like a final destination ---> 
		 
	  <tr>	 
		 <td class="labelmedium">  
		 <input type="radio"  onclick="#tog#" class="radiol" name="Distribution" id="consumption" value="8" <cfif "8" eq get.Distribution>checked</cfif>>
		 </td>
		 <td class="labelmedium" style="padding-left:6px"><cf_tl id="Consumes"></td>
	  </tr>	 
	  
	  </cfoutput>
		 
	  </tr>
	  </table> 
	</td>
	</tr>	
	
	
	<tr>
	<td valign="top" style="padding-left:10px;padding-top:2px" height="25" class="labelmedium"><cf_tl id="Process Issuances">:</td>
	<td>  
		 <table class="formpadding" cellspacing="0" cellpadding="0">
		 <tr>
			 <td>
		     <input type="checkbox" class="radiol" name="EnableReference" id="EnableReference" value="1" <cfif "1" eq get.EnableReference>checked</cfif>>					
			 </td>
			 <td class="labelmedium" style="padding-left:6px"><cf_tl id="Enforce Reference entry"></td>	
		 </tr>
		 <tr>
			 <td>
		     <input type="checkbox" class="radiol" name="TransferAsIssue" id="TransferAsIssue" value="1" <cfif "1" eq get.TransferAsIssue>checked</cfif>>					
			 </td>
			 <td class="labelmedium" style="padding-left:6px"><cf_tl id="Enable Transfer"></td>	
		 </tr>
		 </table> 
	</td>
	</tr>			
	
	</table>

</td>

<td valign="top">

	   <cfif client.googleMAP eq "1">
		   <cf_mapshow scope="embed" 
		      mode="view" width="380" height="490" latitude="#getloc.Latitude#" longitude="#getloc.Longitude#" format="map">
	   </cfif>
	   
</td>

</tr>

<tr><td colspan="2" class="line"></td></tr>

<cfoutput>

<tr><td colspan="2" align="center" style="padding:3px">
    <cf_tl id="Save" var = "vSave">
	<input type="button" 
	       name="Save" 
		   id="Save"
		   class="button10s" style="width:120px;height:25px;font-size:12"
		   value="#vSave#" 		  
		   onclick="ColdFusion.navigate('LocationEditSubmit.cfm?warehouse=#url.warehouse#&location=#url.location#','contentbox1','','','POST','formlocation')">
</td></tr>

<tr><td colspan="2" style="padding:3px" class="line"></td></tr>

</cfoutput>

</table>

</cfform>

</cf_divscroll>