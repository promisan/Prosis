
<table width="99%" height="99%" align="center" style="border:0px dotted silver;padding;4px" cellspacing="0" cellpadding="0">
	
	<cfquery name="List" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_AssetAction
	WHERE  Operational = 1
	AND    Code IN (SELECT Code
	                FROM   Ref_AssetActionList 
				    WHERE  Operational = 1) 
					
	<!--- enabled or used --->
					
	AND    ( Code IN (SELECT ActionCategory
	                  FROM   AssetItemAssetAction 
					  WHERE  AssetId = '#url.assetid#')	
			 OR 
			 
			 Code IN (SELECT DISTINCT ActionCategory
			          FROM  AssetItemAction
					  WHERE AssetId = '#url.assetid#')
					  
		   )			  
			       					
	</cfquery>
	
	<cfset itm = 1>  
	
	<cfif list.recordcount eq "0">
	
			<tr><td align="center"><font face="Verdana" size="3">Action logging not enabled</font></td></tr>
	
	<cfelse>
	   
			<tr><td>
			<table width="100%" cellspacing="0" cellpadding="0"><tr>
			
			<cfset wd = "22">
			<cfset ht = "22">	
			
			<cf_menutab base="action" 
			   item       = "#itm#" 
		       iconsrc    = "Logos/Warehouse/Inspection.png" 
			   iconwidth  = "#wd#" 
			   iconheight = "#ht#" 
			   target     = "boxaction"
			   targetitem = "1"
			   class      = "highlight1"
			   name       = "Observation"
			   source     = "../Observation/ObservationViewListing.cfm?assetid=#url.assetid#">		   
			
			<cfloop query="List">
			
				<cfset itm = itm+1>  
					
				<cfset cl = "regular">	  
					
				<cf_menutab base="action" 
				   item       = "#itm#" 
			       iconsrc    = "#tabicon#" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   target     = "boxaction"
				   targetitem = "1"
				   class      = "#cl#"
				   name       = "#Description#"
				   source     = "AssetActionContent.cfm?assetid=#url.assetid#&code=#code#">		   
			   
			</cfloop>   
			
			
			</tr>
			</table>
			</td>
			
					
		</td></tr>		
				
		<tr><td class="linedotted"></td></tr>
		
		<tr><td>
			<cf_menucontainer name="boxaction" item="1" class="regular">
			   		 <cfinclude template="../Observation/ObservationViewListing.cfm"> 
		 	<cf_menucontainer>	
		</td></tr>
		
	</cfif>	


</table>