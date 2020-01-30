
<!--- show in this template the stock for the warehouse to which the person has access, then the option to open the
warehouse to process --->

<cfif url.mission eq "">
	<table align="center"><tr><td>No entity selected</td></tr></table>
	<cfabort>
</cfif>

<cf_setRequestStatus mission = "#url.mission#">

<!--- ----------------------- --->
<!--- ------end of check----- --->
<!--- ----------------------- --->

<cfparam name="url.city" default="">

<cfquery name="WarehouseListValidate" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT W.City
		   		   
	FROM   Warehouse W, 
		   Ref_WarehouseCity WC,
	       WarehouseLocation WL, 
		   <!--- detail stock location --->
		   ItemWarehouseLocation I,
		   Ref_WarehouseLocationClass R,
		   Item IM,
		   Ref_Category C,
		   ItemUoM IU
		   
	WHERE  W.Mission      = '#url.mission#' 
	AND    W.Warehouse    = WL.Warehouse
	AND    IM.Category    = C.Category
	AND    W.Mission      = WC.Mission
	AND    W.City         = WC.City
	AND    WL.Warehouse   = I.Warehouse
	AND    WL.Location    = I.Location
	AND    R.Code         = WL.LocationClass
	AND    I.ItemNo       = IM.ItemNo
	AND    I.ItemNo       = IU.ItemNo
	AND    I.UoM          = IU.UoM 	
	AND    W.Operational  = 1
	AND    WL.Operational = 1
	AND    IM.ItemClass   = 'Supply'
					
	<!--- limit access based on granted access as whs procesor which is derrived from the determined missionorgunitid --->
		
	<cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->
		
	<cfelse>	
	
	AND    W.MissionOrgUnitId IN
	
	           (
			   
                  SELECT DISTINCT O.MissionOrgUnitId 
                  FROM   Organization.dbo.Organization O, 
				         Organization.dbo.OrganizationAuthorization OA
				  WHERE  O.Mission      = '#url.Mission#'
				  AND    O.OrgUnit      = OA.OrgUnit
				  AND    OA.UserAccount = '#SESSION.acc#'											  
				  AND    OA.Role        = 'WhsPick'  
				  AND    OA.AccessLevel = '2'

				  UNION
				  
				  SELECT DISTINCT O.MissionOrgUnitId 
                  FROM   Organization.dbo.Organization O, 
				         Organization.dbo.OrganizationAuthorization OA
				  WHERE  O.Mission  = '#url.Mission#'
				  AND    O.Mission = OA.Mission
				  AND    OA.OrgUnit is NULL
				  AND    OA.UserAccount = '#SESSION.acc#'											  
				  AND    OA.Role        = 'WhsPick'  
				  AND    OA.AccessLevel = '2'
																	  
			   )	
			   
	</cfif>		
	
	<cfif url.city neq "">
	 	AND  W.City = '#url.city#'
	 </cfif> 	
		
</cfquery>

<cfif WarehouseListValidate.City eq "">

	<table align="center"><tr><td height="100" class="labelmedium">You were not granted access to any Facility</td></tr></table>
	<cfabort>

</cfif>
		
<cfset vType = "accordion">

<cf_layout 
	type="#vType#" 
	defaultOpen="calendar">
	
	<!--- Scheduled Receipts and Confirmations ---> 
	<cf_tl id="Stock Transaction Confirmation" var="1">
	
	<cf_layoutArea type 	= "#vType#"
				   id 		= "calendar" 
				   state    = "open"
				   label 	= "#lt_text#">
		
			<cfparam name="URL.Fnd"        default="">
			<cfparam name="URL.status"     default="0">  <!--- only pending --->
			<cfparam name="URL.warehouse"  default="portal">			

			<cfinclude template="../../Application/Stock/Batch/StockBatchPrepare.cfm">						
						
			<cfparam name="client.selecteddate" default="#now()#">
			<cfparam name="url.selecteddate" default="#client.selecteddate#">
											
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
		
	</cf_layoutArea>
	
	<!--- Stock on hand --->
	<cf_tl id="Fuel Stock Levels" var="1">
	<cf_layoutArea 
		type 	= "#vType#"
		id 		= "onHand" 
		label 	= "#lt_text#"
		onshow 	= "ColdFusion.navigate('#session.root#/warehouse/portal/Stock/InquiryWarehouse.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&webapp=#url.webapp#&city=#url.city#','divOnHand');">
		
			<cf_divscroll overflowy="scroll">
				<cfdiv id="divOnHand" style="height:100%;min-height:100%;">
			</cf_divscroll>
		
		<!--- bind="url:#session.root#/warehouse/portal/Stock/InquiryWarehouse.cfm?mission=#url.mission#&webapp=#url.webapp#&city=#url.city#" --->
		
	</cf_layoutArea>		
	

</cf_layout>
