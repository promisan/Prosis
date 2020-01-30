
<!--- shows the information for the date as to how many are pending for that date --->
<!--- capture the selected warehouse --->

<cfoutput>
<input type="hidden" id="warehouseselected" value="#url.warehouse#">
</cfoutput>

  <cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Warehouse
	  WHERE  Warehouse = '#url.warehouse#'
  </cfquery>	  

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
			  
	<tr><td valign="top">		
	
			<cfparam name="client.selecteddate" default="#now()#">
			
			<cfif client.selecteddate lt (now()-300)>
			   <cfset client.selecteddate = now()>
			</cfif>	
			
			<cfparam name="url.selecteddate" default="#client.selecteddate#">								
								
			<cf_calendarView 
			   title          = "#get.WarehouseName#"	
			   selecteddate   = "#url.selecteddate#"
			   relativepath   =	"../../.."				
			   autorefresh    = "0"				   
			   preparation    = "Warehouse/Application/Stock/Batch/StockBatchPrepare.cfm"	    				  
			   content        = "Warehouse/Application/Stock/Batch/StockBatchCalendarDate.cfm"			  
			   target         = "Warehouse/Application/Stock/Batch/StockBatchCalendarList.cfm"
			   condition      = "mission=#url.mission#&warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#&status=#url.status#"		   
			   cellwidth      = "fit"
			   cellheight     = "fit">
			
	</td></tr> 

</table>
 