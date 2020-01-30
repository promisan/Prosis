
<cfparam name="URL.Fnd"        default="">
<cfparam name="URL.status"     default="0">  <!--- only pending --->
<cfparam name="URL.warehouse"  default="portal">			

<cfinclude template="../../Application/Stock/Batch/StockBatchPrepare.cfm">						
			
<cfparam name="client.selecteddate" default="#now()#">
<cfparam name="url.selecteddate" default="#client.selecteddate#">

<table width="100%" height="100%" bgcolor="FFFFFF"><tr><td valign="top">
								
<cf_calendarView 
   title          = "Receipts and Pending Confirmations"	
   selecteddate   = "#url.selecteddate#"
   relativepath   =	"../../.."	
   preparation    = "Warehouse/Application/Stock/Batch/StockBatchPrepare.cfm"	  					    				  
   content        = "Warehouse/Application/Stock/Batch/StockBatchCalendarDate.cfm"			  
   target         = "Warehouse/Application/Stock/Batch/StockBatchCalendarList.cfm"
   condition      = "mission=#url.mission#&warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#&status=#url.status#"		   
   cellwidth      = "fit"
   cellheight     = "40">
   
</td></tr></table>   