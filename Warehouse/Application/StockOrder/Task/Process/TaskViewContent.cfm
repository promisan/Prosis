<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Warehouse
	  WHERE Warehouse = '#url.warehouse#'
</cfquery>	  			

<cfparam name="client.selecteddate" default="#now()#">
<cfparam name="url.selecteddate" default="#client.selecteddate#">

<cfoutput>
<input type="hidden" id="warehouseshow" value="#url.warehouse#">
</cfoutput>
								
<cf_calendarView 
   title          = "#get.WarehouseName#"	
   selecteddate   = "#url.selecteddate#"
   relativepath   =	"../../.."						    				  
   content        = "Warehouse/Application/StockOrder/Task/Process/TaskViewDate.cfm"			  
   target         = "Warehouse/Application/StockOrder/Task/Process/TaskViewDetail.cfm"
   condition      = "mission=#url.mission#&warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#"		   
   cellwidth      = "fit"
   cellheight     = "40">