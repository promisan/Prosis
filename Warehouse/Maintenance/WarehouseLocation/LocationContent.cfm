
<!--- control list data content --->

<cfquery name="Param" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	  *
	FROM   	  Ref_ParameterMission
	WHERE  	  Mission = '#url.Mission#'							
</cfquery>	

<cfsavecontent variable="myquery">

	<cfoutput>	  
	
		SELECT *, Created
		FROM (	
	
			SELECT      WL.StorageId, 
			            R.Description  AS LocationClass, 
						WL.Location    AS LocationCode, 
						WL.Description AS LocationName, 
						Location.LocationName AS GeoLocation, 
                        ISNULL ((SELECT  OrgUnitName
                                 FROM    Organization.dbo.Organization
                                 WHERE   OrgUnit = WL.OrgUnitOperator), 'Internal') AS Operator,
                        (SELECT  COUNT(DISTINCT Location) AS Expr1
                         FROM    ItemTransaction
                         WHERE   Warehouse = WL.Warehouse 
						 AND     Location = WL.Location) AS InUse, 
						 WL.BillingMode, 
						 WL.Operational, 
						 WL.Created
			FROM         WarehouseLocation AS WL INNER JOIN
                         Ref_WarehouseLocationClass AS R ON WL.LocationClass = R.Code INNER JOIN
                         Location ON WL.LocationId = Location.Location
			WHERE        WL.Warehouse = '#url.warehouse#'
			
		) as D
		WHERE 1=1
		--condition	
		
	</cfoutput>	
	
</cfsavecontent>						

<cf_tl id = "Class"         var = "vClass">
<cf_tl id = "Location"      var = "vLocation">
<cf_tl id = "Storage"       var = "vCode">
<cf_tl id = "Geo Location"  var = "vGeo">
<cf_tl id = "Operator"      var = "vOperator">
<cf_tl id = "Billing"       var = "vBilling">
<cf_tl id = "In Use"        var = "vInUse">
<cf_tl id = "Active"        var = "vOperational">
<cf_tl id = "Billing"       var = "vBilling">

<cfset fields=ArrayNew(1)>

<cfset itm = 1>		
<cfset fields[itm] = {label           = "#vClass#",                    	                   
     				field             = "LocationClass",					
					column            = "common",												
					search            = "text",
					filtermode  	  = "3"}>		
					
<cfset itm = itm+1>		
<cfset fields[itm] = {label           = "#vLocation#",                    	                   
     				field             = "LocationCode",																				
					search            = "text"}>	
					
<cfset itm = itm+1>		
<cfset fields[itm] = {label           = "#vCode#",                    	                   
     				field             = "LocationName",					
					column            = "common",												
					search            = "text",
					filtermode  	  = "3"}>											
   
	
<cfset itm = itm+1>		
<cfset fields[itm] = {label           = "#vGeo#",                    
     				field             = "GeoLocation",	
					column            = "common",	
					search            = "text",	
					filtermode        = "3"}>	

				
<cfset itm = itm+1>		
<cfset fields[itm] = {label           = "#vInUse#",                    
     				field             = "InUse",	
					search            = "text",	
					filtermode        = "3",
					formatted         = "Rating",
					ratinglist        = "0=yellow,1=Green"}>							

				
<cfset itm = itm+1>		
<cfset fields[itm] = {label           = "#vOperator#",                    
     				field             = "Operator",						
					search            = "text",	
					filtermode        = "2"}>		
			
<cfset itm = itm+1>		

<cfset fields[itm] = {label           = "#vBilling#",                    
     				field             = "BillingMode",	
					search            = "text",						
					filtermode        = "2"}>		
					
					

				
<cfset itm = itm+1>		
<cfset fields[itm] = {label           = "#vOperational#",                    	                    
	     			  field           = "Operational",										 
					  align       	  = "center",
					  formatted       = "Rating",																								
					  ratinglist      = "0=Red,1=Green"}>	
										  		  						

<cfset itm = itm+1>						
<cf_tl id="Created" var="1">
<cfset fields[itm] = {label      = "#lt_text#",    					
					field        = "Created",							
					labelfilter  = "#lt_text#",						
					formatted    = "dateformat(Created,CLIENT.DateFormatShow)"}>	
					
			
		
<cfset itm = itm+1>
			
<!--- hidden fields --->
		
<cfset fields[itm] = {label     = "Id",                    
     				field       = "StorageId",					
					display     = "No",
					alias       = ""}>		
						
			
				
			
<!--- define access 
<cfsavecontent variable="myaddscript">

	<cfoutput>
	    
		h = #client.height-150#;
		w = #client.width-150#;
		ptoken.open('#SESSION.root#/warehouse/maintenance/warehouselocation/LocationItemUoM/ItemUoMEdit.cfm?warehouse=#url.warehouse#&location=#url.location#','_blank', 'left=20, top=20, width=' + w + ',height=' + h + ',status=yes, toolbar=no, scrollbars=yes, resizable=yes');
		
	</cfoutput>

</cfsavecontent>

--->

<cfset menu=ArrayNew(1)>	

<cfinvoke component         = "Service.Access"  
		   method           = "WarehouseProcessor" 
		   mission          = "#url..mission#"	  
		   warehouse        = "#url.warehouse#"
		   systemfunctionid = "#url.systemfunctionid#"
		   returnvariable   = "access">			   	     
				  
<cfif url.warehouse neq "" and url.systemfunctionid neq "">
		
		<cfif access eq "EDIT" or access eq "ALL" or getFunction.FunctionClass eq "Maintain">		
		
			<cf_tl id="Add Location" var="addNew">
			
			<!---
														
			<cfset menu[1] = {label = "#addNew#", icon = "insert.gif", script = "#myaddscript#"}>	
			
			--->
										
		</cfif>
				
</cfif>
	   
<!--- embed|window|dialogajax|dialog|standard --->		
	<cf_listing
	    header              = "itemlocationlist"
	    box                 = "warehouselocation_#url.warehouse#"
		link                = "#SESSION.root#/Warehouse/Maintenance/WarehouseLocation/LocationContent.cfm?mission=#url.mission#&warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#"		
		datasource          = "AppsMaterials"
		listquery           = "#myquery#"	
		listgroup           = "LocationClass"			
		listorder           = "LocationName"
		listorderalias      = ""
		listorderdir        = "ASC"		
		show                = "500"		
		menu                = "#menu#"
		filtershow          = "Hide"
		excelshow           = "Yes" 		
		listlayout          = "#fields#"
		drillmode           = "tab" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "Warehouse/Maintenance/WarehouseLocation/LocationView.cfm?warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#&location="
		drillkey            = "LocationCode">	
		


