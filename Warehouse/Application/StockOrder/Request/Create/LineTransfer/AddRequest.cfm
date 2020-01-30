
<cfquery name="getWarehouse" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Warehouse
		WHERE 	Warehouse = '#url.warehouse#' 
</cfquery>

<cfparam name="url.refresh" default="0">

<cfform name="frmAddRequest"
   action="#SESSION.root#/Warehouse/Application/Stockorder/Request/Create/LineTransfer/AddRequestSubmit.cfm?scope=#url.scope#&mission=#url.mission#&warehouse=#url.warehouse#&refresh=#url.refresh#">
   
<table bgcolor="FFFFFF" width="100%" height="100%">
<tr><td valign="top">

<table width="90%" align="center" class="formpadding" cellspacing="0" cellpadding="0">

	<tr><td height="20"></td></tr>
   			
	<tr>
		<td width="1%" height="23"></td>
		<td width="30%" class="labelit" style="padding-right:10px"><cf_tl id="Ship to Facility">:</td>
		<td>
		
			<cfinvoke component = "Service.Access"  
				   method           = "WarehouseAccessList" 
				   mission          = "#url.mission#" 					   					 
				   Role             = "'WhsPick'"
				   accesslevel      = "" 					  
				   returnvariable   = "Access">
		
			<cfquery name="qWarehouse" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	W.*, MC.Listingorder
					FROM 	Warehouse W, Ref_WarehouseCity MC
					WHERE   W.Mission   = MC.Mission
					AND     W.City      = MC.City					
					AND  	W.Mission   = '#url.mission#' 	
					<cfif getAdministrator(url.mission) eq "1">	
					<!--- no filtering --->
					<cfelse>					
					AND     Warehouse IN (#preservesingleQuotes(access)#)				
					</cfif>	
					AND     Warehouse IN (SELECT Warehouse FROM ItemWarehouseLocation WHERE Warehouse = W.warehouse and Operational = 1)
					ORDER BY MC.ListingOrder, W.WarehouseName
			</cfquery>
			
			<cfselect name="ShipToWarehouse" 
					query="qWarehouse" 
					value="warehouse" 
					display="WarehouseName" 
					required="Yes" 
					group="City"
					style="width:100%"
					class="regularxl enterastab"
					message="Please, select a valid facility to ship to."
					onchange="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/Request/Create/LineTransfer/AddRequestGeoLocation.cfm?scope=#url.scope#&mission=#url.mission#&directtowarehouse=#url.warehouse#&warehouse='+this.value,'divAddRequestGeoLocation');"/>					
			
		</td>
	</tr>
	
	<tr>
		<td width="20" height="23"></td>
		<td width="20%" class="labelit"><cf_tl id="GeoLocation">:</td>
		<td>
				
			<cfdiv id="divAddRequestGeoLocation" 
			  bind="url:#SESSION.root#/warehouse/application/stockorder/Request/Create/LineTransfer/AddRequestGeoLocation.cfm?scope=#url.scope#&mission=#url.mission#&directtowarehouse=#url.warehouse#&warehouse=#qWarehouse.warehouse#">
		
		</td>
	</tr>
	
		
	<tr>
		<td height="23"></td>
		<td width="20%" class="labelit">Product:</td>
		<td>								
			<cfdiv id="divAddRequestProduct"/>						
		</td>
	</tr>
	
	
	<tr>
		<td width="20" height="23"></td>
		<td width="20%" class="labelit"><cf_tl id="Storage Location">:</td>
		<td class="labelit">								
			<cfdiv id="divAddRequestLocation"/>			
		</td>
	</tr>
		
	<tr>
		<td height="23"></td>
		<td width="20%" class="labelit"><cf_tl id="Quantity">:</td>
		<td>					
			<cfdiv id="divAddRequestProductUoM"/>						
		</td>
	</tr>
		
	<cfif url.scope eq "backoffice">
		<cfset cl = "hide">
	<cfelse>
		<cfset cl = "regular">
	</cfif>		
					
	<tr class="<cfoutput>#cl#</cfoutput>">		
	
		<td height="20"></td>			   			        
		<TD height="20" colspan="1" class="labelit"><cf_tl id="Submit to">:					
		<td><cfdiv id="divAddRequestDirectTo"/></td>
				   
    </TR>	
		
	<TR> 
	    <td height="23"></td>
		<td width="20%" valign="top" style="padding-top:3px" class="labelit"><cf_tl id="Memo">:</td>
	</tr>
	
	<tr>	
		<td></td>
	    <td colspan="2">
		
		<cfif url.scope eq "backoffice">
					
			    <textarea name     = "remarks" 
					 id        = "remarks"					     
					 class     = "regular" 
					 totlength = "200"
					 onkeyup   = "return ismaxlength(this)"					
					 style     = "font-size:14px;padding:3px;height:100;width:99%"></textarea>
					 
		<cfelse>
		
			   <textarea name     = "remarks" 
					 id        = "remarks"					     
					 class     = "regular" 
					 totlength = "200"
					 onkeyup   = "return ismaxlength(this)"					
					 style     = "font-size:14px;padding:3px;height:64;width:99%"></textarea>
		
		
		</cfif>			 
					
	    </td>			  	   
	</TR>		
		
	<tr><td height="4"></td></tr>
	<tr><td class="linedotted" colspan="3"></td></tr>
		
	<tr>
		<td colspan="3" align="center" id="submitbox">
			<input type="Submit" name="save" id="save" class="button10g" value="Add Request" style="width:165;height:25;font-size:12px">
		</td>
	</tr>
	
</table>

</td></tr></table>

</cfform>



