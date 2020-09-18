
<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_Nation
</cfquery>
 
<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   * 
	FROM     Warehouse 
	WHERE    Warehouse = '#URL.ID1#'
</cfquery>

<cfquery name="OrgUnit" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     Organization 
	WHERE    MissionOrgUnitId = '#Get.MissionOrgUnitId#'
	ORDER BY OrgUnit DESC
</cfquery>

<cfif client.googleMAP eq "1">	 
	<cfajaximport tags="cfmap" params="#{googlemapkey='#client.googlemapid#'}#"> 
	<cfset maplink = "mapaddress()">
<cfelse>
	<cfset maplink = "">	
</cfif>

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#&id1=#URL.ID1#" style="height:100%;width:100%" method="POST" name="warehouse" id="warehouse">

<cf_divscroll style="height:100%;width:100%">
	
<table width="98%" cellspacing="0" align="center">

<tr><td valign="top" width="100%">

<!--- Entry form --->

<table width="93%" align="center" class="formpadding" cellpadding="0">

   <tr><td height="10"></td></tr>
	
   <!--- Field: Id --->
   
   <cfquery name="check" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   TOP 1 * 
		FROM     ItemTransaction 
		WHERE    Warehouse = '#URL.ID1#'
	</cfquery>
	
	<cfif check.recordcount eq "0">
	
    <TR>
    <td width="80" class="labelmedium"><cf_tl id="Code">:</td>
    <TD class="labelmedium">
		      	
			<cfinput class = "regularxl" 
				type       = "Text" 
				name       = "Warehouse" 
	            id         = "Warehouse"
				value      = "#Get.Warehouse#" 
				message    = "Please enter a valid code.\n\n** Must start with a letter and may contain numbers and letters." 
				required   = "Yes" 
				size       = "20" 
				style      = "padding-left:3px"
				maxlength  = "20" 
				validate   = "regex" 
				pattern    = "^[a-zA-Z][a-zA-Z0-9]*$">
				
		
	</TD>
	</TR>			
			
	<cfelse>
		
		<!--- <cfoutput>#Get.Warehouse#</cfoutput>	--->
			
		<input type="hidden" name="Warehouse" id="Warehouse" value="<cfoutput>#Get.Warehouse#</cfoutput>">
		
	</cfif>	
			
	<input type="hidden" name="WarehouseOld" id="WarehouseOld" value="<cfoutput>#Get.Warehouse#</cfoutput>">
	
	
	<!--- Field: Description --->
    <TR>
    <TD class="labelmedium"><cf_tl id="Name">:</TD>
    <TD>
		<cfinput class="regularxl" 
		     type="Text" 
			 style="padding-left:3px"
			 name="WarehouseName"  
			 value="#Get.WarehouseName#" 
			 message="Please enter description" 
			 required="Yes" 
			 size="40" 
			 maxlength="100">
	</TD>
	</TR>
	
	<cfquery name="GetClass" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_WarehouseClass 		
	</cfquery>		
	
	<cfif getClass.Recordcount eq "0">
	
		<cfoutput>
			<input class="hide" type="Text" name="WarehouseClass" value="" size="20" maxlength="20">
		</cfoutput>
		
	<cfelse>	
			
	    <TR>
	    <TD style="width:30%" class="labelmedium"><cf_tl id="Facility Class">:</TD>
	    <TD style="width:70%">	
		    	 
			<cfselect name="WarehouseClass" 
			   style="font:10px" query="getClass" 
			   value="Code" 
			   class="regularxl"
			   selected="#Get.WarehouseClass#"
			   display="Description">	
			</cfselect>
				
		</TD>
		</TR>	
	
	</cfif>
	
	<!--- Field: Location --->
    <TR>
    <TD class="labelmedium"><cf_tl id="Default Receipt storage">:</TD>
    <TD>
		
	<cfquery name="GetLocation" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   WarehouseLocation 
		WHERE  Warehouse = '#URL.ID1#'
		AND    (Operational = 1 or Location = '#get.LocationReceipt#')
	</cfquery>		
	
	<cfif getLocation.Recordcount eq "0">
	
	    <cfoutput>
			<input class="regular" type="Text" name="LocationReceipt" id="LocationReceipt"  value="#Get.LocationReceipt#" size="20" maxlength="20">
		</cfoutput>
		
	<cfelse>
    	 
		<cfselect name="LocationReceipt" 
			   group="LocationClass"
			   style="font:10px" 
			   query="getLocation" 
			   value="Location" 
			   class="regularxl"
			   selected="#Get.LocationReceipt#"
			   display="Description" 
			   visible="Yes" 
			   enabled="Yes"
			   required="true" 			   
			   id="LocationReceipt">	
		</cfselect>
	
	</cfif>	
		
		
	</TD>
	</TR>	
		
	<!--- Field: Stock Location --->
    <TR>
    <TD class="labelmedium"><cf_tl id="Price Location">:</TD>
    <TD>
	
		<cfquery name="getLocations" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT 	L.*,
					(LocationCode + ' - ' + LocationName) as LocationDisplay,
					C.Description as ClassDescription
			FROM   	Location L,
					Ref_LocationClass C
			WHERE  	L.LocationClass = C.Code
			AND		L.Mission = '#get.mission#'
			AND		L.StockLocation = 1
		</cfquery>
				
		<cfif getLocations.recordcount eq "0">

		<select name="locationId" id="locationId" class="regularxl">
			<option value="">Not available</option>
		</select>		

		<cfelse>
				
		<cfselect 	name     = "locationId" 
					value    = "location" 
					class    = "regularxl"
					display  = "LocationDisplay" 					
					query    = "getLocations" 					
					selected = "#get.LocationId#"/>			
					
		</cfif>			
		
	</TD>
	</TR>	
	
	 <!--- Field: Section --->
    <TR>
    <TD class="labelmedium"><cf_tl id="Unit">:</TD>
    	<TD>
		
		<table cellspacing="0" cellpadding="0">
		<tr>
		
		<cfoutput>			
		
		<td>	
		
		<input type="text" name="orgunitname1"  id="orgunitname1" value="#OrgUnit.OrgUnitName#" class="regularxl" size="50" maxlength="50" readonly>
		<input type="hidden" name="mission1"    id="mission1"     class="disabled" size="20" maxlength="20" readonly>
	   	<input type="hidden" name="orgunit1"    id="orgunit1"     value="#OrgUnit.OrgUnit#">
						
		</td>
		<td style="padding-left:2px">		
					
	 		 <img src="#SESSION.root#/Images/contract.gif" alt="Select authorised unit" name="img0" 
					  onMouseOver="document.img0.src='#SESSION.root#/Images/button.jpg'" 
					  onMouseOut="document.img0.src='#SESSION.root#/Images/contract.gif'"
					  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
					  onClick="selectorgmis('webdialog','orgunit1','orgunitcode1','mission1','orgunitname1','orgunitclass1','<cfoutput>#get.mission#</cfoutput>','','')">
					  
					 </td>
		</cfoutput>
		
		</tr></table>
		</TD>
		
				
	</tr>
	
	<tr><td height="4"></td></tr>
	
	<tr><td class="labellarge" colspan="2" height="20" style="border-bottom:1px dotted silver"><cf_tl id="Address">/<cf_tl id="Contact"></td></tr>
		
	<TR>
    <TD class="labelmedium" height="20" style="padding-left:8px"><cf_tl id="Country">:</TD>
    <TD>
	 
	   	<select name="country" id="country" onchange="<cfoutput>#maplink#</cfoutput>" required="No" class="regularxl">
		    <cfoutput query="Nation" >
				<option value="#Code#" <cfif get.Country eq Code>selected</cfif>>
				#Name#
				</option>
			</cfoutput>	    
	   	</select>		
		
	</TD>
	</TR>
	
	<TR>
    	<TD class="labelmedium" height="20"  style="padding-left:8px"><cf_tl id="Region">: <font color="FF0000">*</font></TD>
	    <TD>	
				
		<cfquery name="getRegions" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT 	*
			FROM   	Ref_WarehouseCity L
			WHERE  	L.Mission = '#get.mission#'	
			ORDER BY ListingOrder
		</cfquery>		
				
		<select name="addresscity" id="addresscity" class="regularxl" onchange="<cfoutput>#maplink#</cfoutput>">
		<cfoutput query="getRegions">
			<option value="#City#" <cfif get.City eq City>selected</cfif>>#City#</option>
		</cfoutput>
		</select>		
		
		</TD>
	</TR>
	
	<TR>
    	<TD class="labelmedium" height="20"  style="padding-left:8px"><cf_tl id="Address">: <font color="FF0000">*</font></TD>
	    <TD>	
		<cfinput class="regularxl" style="padding-left:3px" onchange="#maplink#" type="Text" name="address" value="#get.Address#" message="Please enter an address" required="Yes" size="50" maxlength="100">	   	
		</TD>
	</TR>
	
	<tr>
		<td class="labelmedium" style="padding-left:8px"><cf_tl id="Coordinates">:</td>		
		<td>
		<table cellspacing="0" cellpadding="0">
		<tr>
		<!---
		<td class="labelmedium" align="right"><cf_tl id="Lat">:</td>	
		--->
		<td>
		<cfinput type="Text" style="padding-left:3px" name="cLatitude" value="#get.Latitude#" validate="float" required="No" size="15" maxlength="20" class="regularxl">	
		</td>
		<!---
		<td class="labelmedium" style="padding-left:6px" align="right"><cf_tl id="Long">:</td>		
		--->
		<td style="padding-left:4px">		
		<cfinput class="regularxl" style="padding-left:3px" validate="float" value="#get.Longitude#" type="Text" name="cLongitude"  require="No" size="15" maxlength="20">	
		</td>		
		</tr>
		</table>
		</td>
	</tr>
	
	<TR>
    	<TD class="labelmedium" height="20"  style="padding-left:8px"><cf_tl id="Contact">: </TD>
	    <TD>	
		<cfinput class="regularxl" style="padding-left:3px" type="Text" name="contact" value="#get.Contact#" size="50" maxlength="80">	   	
		</TD>
	</TR>
	
	<TR>
    	<TD class="labelmedium" height="20"  style="padding-left:8px"><cf_tl id="eMail">: </TD>
	    <TD>	
		<cfinput class="regularxl" style="padding-left:3px" type="Text"  validate="email" message="Invalid eMail address" name="emailaddress" value="#get.eMailAddress#" size="50" maxlength="80">	   	
		</TD>
	</TR>
	
		
    <!--- Field: Phone--->
    <TR>
    <TD class="labelmedium" style="padding-left:8px"><cf_tl id="Phone">:</TD>
    <TD><cfoutput>
		<input class="regularxl" style="padding-left:3px" type="Text" name="Telephone" id="Telephone" value="#Get.Telephone#" size="25" maxlength="25">
		</cfoutput>
	</TD>
	</TR>	
	
    <!--- Field: Fax--->
    <TR class="hide">
    <TD class="labelmedium" style="padding-left:8px"><cf_tl id="Fax">:</TD>
    <TD><cfoutput>
		<input class="regularxl" style="padding-left:3px" type="Text" name="Fax" id="Fax" value="#Get.Fax#" size="15" maxlength="15">
		</cfoutput>
	</TD>
	</TR>	
	
	<cf_calendarscript>
	
	 <!--- Field: Fax--->
    <TR>
    <TD class="labelmedium" valign="top" style="padding-left:8px;padding-top:4px"><cf_tl id="Time Zone">:</TD>
    <TD>
		
		<table cellspacing="0" cellpadding="0">
		
		   <tr>
		   <td class="labelmedium"><cf_tl id="Effective"></td>
		   <td class="labelmedium" align="right" style="padding-left:10px">GMT +/-</td>
		   </tr>
		   <tr><td colspan="2" class="line"></td></tr>
								   
			<cfquery name="Zone" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   * 
				FROM     WarehouseTimeZone 
				WHERE    Warehouse = '#URL.ID1#'
				ORDER BY DateEffective
			</cfquery>
			
		  <cfset dt = dateformat(now(),CLIENT.DateFormatShow)>
		  <cfset zn = "0">	
   
   		   <cfoutput query="Zone">
		   
			   <cfif currentrow neq recordcount>
				   <tr>
				   <td class="labelmedium" height="20" style="padding-left:18px">#dateformat(DateEffective,CLIENT.DateFormatShow)#</td>
				   <td class="labelmedium" style="padding-left:9px" align="center">#TimeZone#</td>		   
				   </tr>
			   <cfelse>
			     	<cfset dt = dateformat(DateEffective,CLIENT.DateFormatShow)>
				    <cfset zn = TimeZone>			   	   
			   </cfif>	
		   	  
		   </cfoutput>
		   
		    <tr><td colspan="2" class="line"></td></tr>
		   
		   <tr>
		   <td height="25">
		   <cfif zone.recordcount gte "1">
		   		<cf_intelliCalendarDate9
						FieldName="DateEffective" 
						Manual="True"	
						class="regularxl"	
						DateValidStart="#Dateformat(dt, 'YYYYMMDD')#"											
						Default="#dt#"
						AllowBlank="False">	
			<cfelse>
				<cf_intelliCalendarDate9
						FieldName="DateEffective" 
						Manual="True"	
						class="regularxl"																
						Default="#dt#"
						AllowBlank="False">	
			</cfif>			
		   </td>
		   <td align="right">
		   <cfinput class="regularxl" type="Text" name="TimeZone" range="-12,12" value="#zn#" validate="range" required="Yes" style="text-align:center;width:40">
		   </td>
		  </tr>	
	   	
		</table>
	</TD>
	</TR>	
		
		
</table>	

</td>

<td valign="top">

	<cfif client.googleMAP eq "1">

	    <table width="100%" cellspacing="0" cellpadding="0">
	
		    <cfquery name="Other" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Warehouse 
				WHERE  Mission = '#get.mission#'  
				AND    Warehouse != '#url.id1#'
				AND    Latitude  != '' 
				AND    Longitude != ''
			</cfquery>
				
			<cfif other.recordcount gte "1" AND get.latitude neq "">
			
			<cfoutput>
			
			<tr>
			  <td colspan="2" style="padding-top:5px" align="center" class="labelmedium">#get.mission# Facilities: #other.recordcount#  [<a href="javascript:ptoken.navigate('ShowOther.cfm?mission=#get.Mission#&warehouse=#get.warehouse#','other');"><font color="0080FF"><cf_tl id="Show"></font></a>]</td>
			</tr>		
			<tr class="hide"><td id="other"></td></tr>
				
			</cfoutput>
			
			</cfif>
	
	         <tr>
			    <td colspan="2" align="center" valign="top" style="padding-top:15px;padding-right:6px;border:0px solid silver">			
				<cf_mapshow scope="embed" zoomlevel="10" mode="edit" width="360" height="360" latitude="#get.Latitude#" longitude="#get.Longitude#">					
			    </td>
			</tr>
		
		</table>
	
	</cfif>

</td>

</tr>

<tr><td colspan="2" style="padding-left:20px">
<table width="100%" class="formpadding">

<tr><td colspan="2" height="20" style="border-bottom:1px dotted silver">
	
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr><td class="labellarge" style="padding-left:33px;height:40px;font-size:27px">
		<cf_tl id="Settings for Operations">
		</td>
		<td align="right" style="padding-right:30px">
			<table><tr>
			
		    <TD class="labelmedium" style="padding-left:8px"><cf_UIToolTip tooltip="Preferred warehouse for transactional processing"><cf_tl id="Default Warehouse">:</cf_UIToolTip></TD>
		    <TD style="padding-left:10px"><input type="checkbox" class="radiol" name="WarehouseDefault" id="WarehouseDefault" value="1" <cfif "1" eq get.WarehouseDefault>checked</cfif>></TD>	
			<td class="labelmedium" height="20" style="padding-left:8px"><cf_tl id="Operational">:</td>
			<td style="padding-left:10px"><input class="radiol" type="checkbox" name="Operational" id="Operational" value="1" <cfif "1" eq get.Operational>checked</cfif>></td>
			</tr>	
			</table>
		</td>
		</tr>	
		</table>
	
	</td></tr>
						  
	<tr>
	<td class="labelmedium" style="padding-left:33px"><cf_UIToolTip tooltip="This storage location can be used in a request direction process"><cf_tl id="Stock Distributor">:</cf_UIToolTip></td>
	<td>   
	   <table cellspacing="0" cellpadding="0"><tr><td>	
	   <input type="checkbox" class="radiol" name="Distribution" id="Distribution" value="1" <cfif "1" eq get.Distribution>checked</cfif>>					
	   </td>
	   <td class="labelmedium" style="padding-left:15px">Enable initial stock option:</td>
	   <td style="padding-left:10px" class="labelmedium">
	   <input type="checkbox" class="radiol" name="ModeInitialStock" id="ModeInitialStock" value="1" <cfif "1" eq get.ModeInitialStock>checked</cfif>>		
	   </td>
	   </table>
	</td>
	</tr>	
	
    <TR>
    <TD class="labelmedium" style="padding-left:33px"><cf_tl id="Parent Facility">:</TD>
	
    <TD id="supply">
	
		<table cellspacing="0" cellpadding="0"><tr><td>
		
		<cfquery name="Parent" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    Warehouse 
				WHERE   Mission = '#get.Mission#' 
				AND     SupplyWarehouse = '#get.Warehouse#' 								
		</cfquery>	
					
		<cfif parent.recordcount gte "1">
		
			<input type="text" name="SupplyWarehouse" value="">
		
		<cfelse>
		
			<cfquery name="Supply" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    Warehouse 
				WHERE   Mission = '#get.Mission#' 
				-- AND     (SupplyWarehouse = '' OR SupplyWarehouse is NULL)
				AND     Warehouse != '#get.Warehouse#'
				ORDER BY City
			</cfquery>		
		
			<cfselect name="SupplyWarehouse" class="regularxl" 
			      group="City" 
				  queryposition="below" 
				  query="Supply" 
				  value="warehouse" 
				  display="warehouseName" 
				  selected="#get.SupplyWarehouse#" 
				  visible="Yes" 
				  enabled="Yes" 
				  id="SupplyWarehouse">
				<option value="">N/A</option>			
			</cfselect>
		
		</cfif>
		
		</td>
				
		<td class="labelmedium">
		
		<img src="<cfoutput>#SESSION.root#</cfoutput>/images/finger.gif" align="absmiddle" alt="" border="0"> Applies to Resupply request
		
		</td></tr>
		</table>
				
	</TD>
	</TR>		
		
			
	<tr>
	<td class="labelmedium" height="20" style="padding-left:33px"><cf_UIToolTip tooltip="Taskorder Sourcing"><cf_tl id="Tasking Mode"></cf_UIToolTip>:</td>
	<td>   
	   <table cellspacing="0" cellpadding="0">
	   <tr><td>
	   <input type="radio" name="TaskingMode" value="0" <cfif "0" eq get.TaskingMode>checked</cfif>>		
	   </td><td class="labelmedium" style="padding-left:3px;padding-right:4px">Internal</td>
	   <td>
	   <input type="radio" name="TaskingMode" value="1" <cfif "1" eq get.TaskingMode>checked</cfif>>	
	   </td><td class="labelmedium" style="padding-left:3px;padding-right:4px">External and Internal</td>	  
	   </tr></table>		
	</td>
	</tr>				
			
	<tr>
	<td height="20" class="labelmedium" style="padding-left:33px"><cf_UIToolTip tooltip="Mode under which items to be transferred are transferred are accepted in this warehouse"><cf_tl id="Receipt Mode"></cf_UIToolTip>:</td>
	<td>   
	   <table cellspacing="0" cellpadding="0">
	   <tr><td>
	   <input type="radio" name="ModeSetItem" id="ModeSetItem" value="Always" <cfif "Always" eq get.ModeSetItem or get.ModeSetItem eq "Dispatch">checked</cfif>>		
	   </td><td class="labelmedium" style="padding-left:3px;padding-right:4px">Always</td>
	   <td>
	   <input type="radio" name="ModeSetItem" id="ModeSetItem" value="Category" <cfif "Category" eq get.ModeSetItem>checked</cfif>>	
	   </td><td class="labelmedium" style="padding-left:3px;padding-right:4px">Limit to below defined categories</td>
	   <td>
	   <input type="radio" name="ModeSetItem" id="ModeSetItem" value="Location" <cfif "Location" eq get.ModeSetItem>checked</cfif>>		
	   </td><td class="labelmedium" style="padding-left:3px;padding-right:4px">Only if exists in storage location</td>
	   </tr></table>		
	</td>
	</tr>	
			
    <TR>
    <TD valign="top" class="labelmedium" style="padding-top:4px;padding-left:33px"><cf_tl id="Stock Managed">:</TD>
    <TD style="width:500">
		<cfdiv id="#url.id1#_list" bind="url:Category/CategoryListing.cfm?ID1=#url.id1#">
	</TD>
	</TR>	
	
	<TR>
	    <TD class="labelmedium" style="padding-left:33px"><cf_UIToolTip tooltip="Default Sale Currency"><cf_tl id="POS Sale Mode">:</cf_UIToolTip></TD>
	    <TD>
		
			<table cellspacing="0" cellpadding="0">
			<tr class="labelmedium">
			
			<td>
			
			<select name="SaleMode" id="SaleMode" class="regularxl">
								
				   <option value="0" <cfif get.SaleMode eq 0>selected</cfif>>Disabled</option>
				   <option value="1" <cfif get.SaleMode eq 1>selected</cfif>>Standard Receivable</option>
				   <option value="2" <cfif get.SaleMode eq 2>selected</cfif>>Cash and Carry</option> 
				   <option value="3" <cfif get.SaleMode eq 3>selected</cfif>>Cash and Carry with Receivable</option>
				
			</select>
			
			</td>
			
			<TD style="padding-left:8px"><cf_tl id="Maximum POS discount">:</TD>
			<td style="padding-left:8px">
				<cfinput class="regularxl" style="padding-left:3px;text-align:right" type="Text" name="SaleDiscount" id="SaleDiscount" value="#Get.SaleDiscount#" size="3" maxlength="3">%
		    </td>
			
			<td style="padding-left:4px">
		
			<cfquery name="currencylist" 
				  datasource="AppsLedger" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					    SELECT *
						FROM   Currency
						WHERE  EnableProcurement = 1	   							   
				</cfquery>	
		
			<select name="SaleCurrency" id="SaleCurrency" class="regularxl">
				
				<cfoutput query="currencylist">
				   <option value="#Currency#" <cfif get.SaleCurrency eq Currency>selected</cfif>>#Currency#</option>
				</cfoutput>
			</select>
			
			</td>
			
			<TD class="hide labelmedium" style="padding-left:8px"><cf_tl id="Sales Background">:</TD>
	    	<TD class="hide"><cfoutput>
			<cfinput class="regularxl" style="padding-left:3px" type="Text" name="SaleBackground" id="SaleBackground" value="#Get.SaleBackground#" size="50" maxlength="80">
			</cfoutput>
			</TD>
		
			</tr>
			
			</table>
		
		</TD>
	</TR>	
	
</table>
</td>
</tr>	

<tr><td height="4"></td></tr>
		
<tr><td colspan="2" align="center" id="submitbox" class="line">

	 <cfoutput>
	 
	 
	 	<table class="formspacing" height="30" cellspacing="0" cellpadding="0">
		
		<tr><td height="4"></td></tr>
		
	    <cf_tl id  = "Close"   var = "vClose">
 	    <cf_tl id  = "Save"   var = "vSave">	 
 	    <cf_tl id  = "Delete" var = "vDelete">	
				
	    <tr>
		
		    <td><input type="button" class="button10g" style="width:120;height:27" name="Close" id="Close" value="#vClose#" onClick="window.close()"></td>
			<td><input type="submit" onclick="Prosis.busy('yes')" class="button10g" style="width:120;height:27" name="Update" id="Update" value="#vSave#"></td>
		
			 <cfquery name="CountRec" 
		     datasource="appsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT    *
		     FROM      ItemWarehouse
		     WHERE     Warehouse  = '#get.Warehouse#'
			</cfquery>
			
			<cfif countRec.recordcount eq "0">
			    <td>
				<input type="button" type="Button" class="button10g" style="width:120;height:27" name="Delete" id="Delete" value=" #vDelete# " onclick="return ask('#url.id1#,#url.idmenu#')">	
				</td>
			</cfif>
			
			</td>
			
		</tr>
		
		</table>
	
	</cfoutput>	
		
</td></tr>
	
</TABLE>

<table>
	<tr><td id="processWH"></td></tr>
</table>

</cf_divscroll>	
	
</CFFORM>

