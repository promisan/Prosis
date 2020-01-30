
<table width="98%" height="100%" cellspacing="0" cellpadding="0" align="center">

<cfquery name="warehouse" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Warehouse
	WHERE  Warehouse = '#URL.warehouse#'		
</cfquery>

<cfquery name="get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   WarehouseLocation
	WHERE  Warehouse = '#URL.warehouse#'	
	AND    Location  = '#url.location#' 
</cfquery>

<cfoutput>

<tr><td height="30">

	<table width="100%" class="formspacing" cellspacing="0" cellpadding="0" class="formpadding">
	<tr>
	
	<cfquery name="Warehouse" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">		 
			 SELECT    *
			 FROM      Warehouse
			 WHERE Warehouse = '#url.Warehouse#'		 
	</cfquery>
				
	<td>
		<table class="formspacing">		   
			<tr>
			<td class="labelit"><font color="808080"><cf_tl id="Warehouse">:</td>
			<td class="labellarge"><b>#warehouse.WarehouseName#</td>	
			<td>&nbsp;&nbsp;</td>
			<td class="labelit"><font color="808080"><cf_tl id="Storage Location">:</td>
			<td class="labellarge"><b>#get.Description#</td>			
			</tr>						
		</table>
	</td>
	
	<cfif get.LocationId neq "">
			
			<cfquery name="Geo" 
				     datasource="AppsMaterials" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">		 
					 SELECT    *
					 FROM      Location
					 WHERE     Location = '#get.Locationid#'		 		
			</cfquery>	
					
			<td class="labellarge" align="right" style="padding-right:4px">
			<cfif geo.Latitude neq "">
				<a href="javascript:editLocation('#geo.Location#')"><font color="0080C0"><b>#Geo.LocationName#</font></a>
			<cfelse>
				<b>#Geo.LocationName#
			</cfif>
			</td>
		
		</cfif>
	
	
	</tr>
	</table>
	
</td></tr>

<tr><td class="line"></td></tr>

<tr><td height="20">

	<table width="100%" class="formspacing" cellspacing="0" cellpadding="0" class="formpadding">
	<tr>

	<cfset wd = "64">
	<cfset ht = "64">
	<cfset itm = 0> 
	<cfset itm = itm+1>  

	<cf_tl id="General Information" var ="vName1">
	<cf_menutab item  = "1" 
       iconsrc    = "Information.png" 
	   iconwidth  = "#wd#" 
	   iconheight = "#ht#" 
	   class      = "highlight1"
	   name       = "#vName1#">			   
	
	 <cfset itm = itm+1>    
 	 <cf_tl id="Memo" var ="vName6">   	   	   
	 <cf_menutab item   = "#itm#" 
	   targetitem = "2"
       iconsrc    = "Memo.png" 
	   iconwidth  = "#wd#" 
	   iconheight = "#ht#" 
	   name       = "#vName6#"
	   source     = "LocationMemo.cfm?mission=#warehouse.mission#&warehouse=#URL.warehouse#&location=#url.location#">	      
	
	   	   
	<cfset itm = itm+1>  
	<cf_tl id="Photo" var ="vName3">   
	   
	<cf_menutab item  = "#itm#" 
       iconsrc    = "Images.png" 
	   iconwidth  = "#wd#" 
       targetitem = "2"	  
	   iconheight = "#ht#" 
	   name       = "#vName3#"
	   source     = "LocationPicture.cfm?id=#get.storageid#">	
	   
		
	<cfquery name="Param" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	  *
		FROM   	  Ref_ParameterMission
		WHERE  	  Mission = '#warehouse.Mission#'							
	</cfquery>	   
	   
	<cfif Param.LotManagement eq "0">    	
	   
		<cfset itm = itm+1> 
		  
		<cf_tl id="Products and Stock Levels" var ="vName4">   
		<cf_menutab item   = "#itm#" 
		   targetitem    = "2"
	       iconsrc       = "Warehouse.png" 
		   iconwidth     = "#wd#" 
		   iconheight    = "#ht#" 
		   name          = "#vName4#"
		   source        = "#session.root#/Warehouse/Application/Stock/Inquiry/Onhand/ListingDataContainer.cfm?mode=item&filterwarehouse=1&systemfunctionid=#url.systemfunctionid#&mission=#warehouse.mission#&warehouse=#URL.warehouse#&location=#url.location#">		
		   
	<cfelse>
	
    	<cfset itm = itm+1> 
		  
		<cf_tl id="Location Products" var ="vName4a">   
		<cf_menutab item   = "#itm#" 
		   targetitem    = "2"
	       iconsrc       = "Logos/Warehouse/ItemInfo.png" 
		   iconwidth     = "#wd#" 
		   iconheight    = "#ht#" 
		   name          = "#vName4a#"
		   source        = "#session.root#/Warehouse/Application/Stock/Inquiry/Onhand/ListingDataContainer.cfm?mode=item&filterwarehouse=1&systemfunctionid=#url.systemfunctionid#&mission=#warehouse.mission#&warehouse=#URL.warehouse#&location=#url.location#">		
		
		<cfset itm = itm+1> 
		
		<cf_tl id="Stock On Hand" var ="vName4b">   
		<cf_menutab item   = "#itm#" 
		   targetitem    = "2"
	       iconsrc       = "Logos/Warehouse/StockLevel.png" 
		   iconwidth     = "#wd#" 
		   iconheight    = "#ht#" 
		   name          = "#vName4b#"
		   source        = "#session.root#/Warehouse/Application/Stock/Inquiry/Onhand/ListingDataContainer.cfm?mode=stock&filterwarehouse=1&systemfunctionid=#url.systemfunctionid#&mission=#warehouse.mission#&warehouse=#URL.warehouse#&location=#url.location#">					
	
	</cfif>   
	
	<cfif get.storageShape neq "" and lcase(get.storageShape) neq "n/a">
	
		<cfset itm = itm+1>  
		<cf_tl id="Storage details" var ="vName2">		
		<cf_menutab item  = "#itm#" 
	       iconsrc    = "Detail.png" 
		   iconwidth  = "#wd#" 
	       targetitem = "2"
		   iconheight = "#ht#" 
		   name       = "#vName2#"
		   source     = "Details.cfm?warehouse=#URL.warehouse#&location=#url.location#">
	   
	 </cfif>
	   
	 <cfset itm = itm+1>    
 	 <cf_tl id="Statistics" var ="vName5">   	   
	 <cf_menutab item   = "#itm#" 
	   targetitem = "2"
       iconsrc    = "Statistics.png" 
	   iconwidth  = "#wd#" 
	   iconheight = "#ht#" 
	   name       = "#vName5#"
	   source     = "LocationStatistics/LocationStatistics.cfm?mission=#warehouse.mission#&warehouse=#URL.warehouse#&location=#url.location#">		 
		   
	 
	 		  
   </tr>
   </table>

</tr>

<tr><td class="line"></td></tr>

</cfoutput>

<tr><td height="5"></td></tr>
<tr><td height="100%" valign="top">
   <table width="100%" height="100%" cellspacing="0" cellpadding="0">
	<cf_menucontainer item="1" class="regular">
		 <cfinclude template="LocationEdit.cfm"> 
 	<cf_menucontainer>	
	<cf_menucontainer item="2" class="hide">		
 	<cf_menucontainer>	
   </table>	
</td></tr>
<tr><td colspan="2" height="1"></td></tr>

</table>
