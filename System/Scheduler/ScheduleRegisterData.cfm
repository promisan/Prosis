
<cfquery name="System" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM    Parameter
</cfquery>

<!--- create ETL to be initially run on the application server on which this template is first launched
which server is verified in the central code/deployment database 
in case of UN, the script is recorded on dpko-pmss-04 to be run by secap071, and recorded on secap901 to be run by the
first server that opens the script and that is recorded in the control database (secap527) : see policy
--->

<cftry>

	<cfquery name="Host" 
		datasource="AppsInit">
			SELECT *
			FROM    Parameter P 
			WHERE   P.HostName = '#CGI.HTTP_HOST#' 
			AND     P.ApplicationServer IN (SELECT ApplicationServer 
			                               FROM   [#System.ControlServer#].Control.dbo.ParameterSite)
	</cfquery>

	<cfcatch>
	
		<cfquery name="Host" 
		datasource="AppsInit">
		SELECT *
		FROM    Parameter P 
		WHERE   P.HostName = '#CGI.HTTP_HOST#' 	
		</cfquery>
		
	</cfcatch>
	
</cftry>
	
<cfif host.recordcount neq "1">
	 <cfset auto = 0> 
<cfelse> 
 
<!--- basic schedules --->
 
<cf_ScheduleRegister
   SystemModule      = "System" 
   ScheduleTemplate  = "tools/cfreport/EngineReport.cfm"
   ScheduleName      = "ReportBatch"
   ScheduleMemo      = "Prepare subscription reports" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "01:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">

<cf_ScheduleRegister
   SystemModule      = "System" 
   ScheduleTemplate  = "system/organization/CheckObjectIntegrity.cfm"
   ScheduleName      = "OrgUnitCheck"
   ScheduleMemo      = "Check for inconsistent primary objects association" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "01:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "weekly">   
    
<cf_ScheduleRegister
   SystemModule      = "System" 
   ScheduleTemplate  = "tools/process/UserStats.cfm"
   ScheduleName      = "UserStats"
   ScheduleMemo      = "Prepare user statistics" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "01:10"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">   
      
<cf_distributer>

<cfif master eq "1">

	<!--- prevents adding this schedule to the operational servers
	refers to Control database which only exists in QA --->
	   
	<cf_ScheduleRegister
	   SystemModule      = "System" 
	   ScheduleTemplate  = "tools/template/TemplateCheck.cfm"
	   ScheduleName      = "Template"
	   ScheduleMemo      = "Source Code Daily Sniffer" 
	   ScheduleStartDate = "01/01/07"
	   ScheduleStartTime = "02:00"
	   ApplicationServer = "#Host.ApplicationServer#" 
	   ScheduleInterval  = "daily">  
	   
	   	   
	<cf_ScheduleRegister
	   SystemModule      = "System" 
	   ScheduleTemplate  = "tools/template/CM_Sniffer.cfm"
	   ScheduleName      = "CMManager"
	   ScheduleMemo      = "Observation Code Sniffer" 
	   ScheduleStartDate = "01/01/07"
	   ScheduleStartTime = "17:00"
	   ApplicationServer = "#Host.ApplicationServer#" 
	   ScheduleInterval  = "daily">     
	     
	<cf_ScheduleRegister
	   SystemModule      = "System" 
	   ScheduleTemplate  = "System/Parameter/DataDictionary/RefreshDictionary.cfm"
	   ScheduleName      = "DataDictionary"
	   ScheduleMemo      = "Scan databases to refresh data dictionary" 
	   ScheduleStartDate = "01/01/07"
	   ScheduleStartTime = "02:30"
	   ApplicationServer = "#Host.ApplicationServer#" 
	   ScheduleInterval  = "daily">  
	   
<cfelse>

	<cf_ScheduleRegister
	   SystemModule      = "System" 
	   ScheduleTemplate  = "System/Parameter/DataDictionary/RefreshDictionary.cfm"
	   ScheduleName      = "DataDictionary"
	   ScheduleMemo      = "Scan databases to refresh data dictionary" 
	   ScheduleStartDate = "01/01/07"
	   ScheduleStartTime = "02:30"
	   ApplicationServer = "#Host.ApplicationServer#" 
	   ScheduleInterval  = "daily">  
	   
	<!--- remove unwanted schedules on operational server 

	<cfquery name="Check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Schedule
	WHERE ScheduleName IN ('Template','DataDictionary')	    
	</cfquery>
	
	--->
	   
</cfif>	   

<cf_ScheduleRegister
   SystemModule      = "System" 
   ScheduleTemplate  = "System/InitConfig.cfm"
   ScheduleName      = "SystemConfig"
   ScheduleMemo      = "Updates System configuration tables" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "01:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "weekly">    
   
<cf_ScheduleRegister
   SystemModule      = "System" 
   ScheduleTemplate  = "System/Language/View/UpdateInterfaceText.cfm"
   ScheduleName      = "Language"
   ScheduleMemo      = "Update language dictionary" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "03:30"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "weekly">          

<!---  pending development  
<cf_ScheduleRegister
   SystemModule      = "System" 
   ScheduleTemplate  = "tools/entityaction/api/DataSet.cfm"
   ScheduleName      = "Workflow"
   ScheduleMemo      = "Generate several workflow status tables" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "05:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">   
   --->
        
   
<cf_ScheduleRegister
   SystemModule      = "System" 
   ScheduleTemplate  = "tools/entityaction/api/WorkFlowTrigger.cfm"
   ScheduleName      = "WorkflowTrigger"
   ScheduleMemo      = "Triggers scheduled workflows for identified entities" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "01:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">   
      
<cf_ScheduleRegister
   SystemModule      = "System" 
   ScheduleTemplate  = "tools/entityaction/api/WorkFlowReminder.cfm"
   ScheduleName      = "WorkflowReminder"
   ScheduleMemo      = "Triggers reminder eMail for identified entities and mission" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "05:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">      
   
<cf_ScheduleRegister
   SystemModule      = "System" 
   ScheduleTemplate  = "tools/entityaction/api/WorkFlowIntegrity.cfm"
   ScheduleName      = "WorkflowIntegrity"
   ScheduleMemo      = "Verifies and clears integrity issues with the workflow" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "06:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">         

<cf_ScheduleRegister
   SystemModule      = "Roster" 
   ScheduleTemplate  = "roster/Maintenance/PrepareRosterSearch.cfm"
   ScheduleName      = "Roster"
   ScheduleMemo      = "Prepare roster tables" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "03:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">
   
<cf_ScheduleRegister
   SystemModule      = "Program" 
   ScheduleTemplate  = "ProgramREM/Application/Budget/Forecast/ForecastBatch.cfm"
   ScheduleName      = "ProgramForecasting"
   ScheduleMemo      = "Prepare Program Budget execution forecast" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "03:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">      

<cf_ScheduleRegister
   SystemModule      = "Program" 
   ScheduleTemplate  = "ProgramREM/Maintenance/Process/setProgramHierarchy.cfm"
   ScheduleName      = "ProgramHierarchy"
   ScheduleMemo      = "Verify Program Hierarchy" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "03:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">   
   
<cf_ScheduleRegister
   SystemModule      = "WorkOrder" 
   ScheduleTemplate  = "Workorder\Application\Tools\Schedule\StockSale.cfm"
   ScheduleName      = "WorkOrderSales"
   ScheduleMemo      = "Workorder Sale stats" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "01:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">         
  
<cf_ScheduleRegister
   SystemModule      = "WorkOrder" 
   ScheduleTemplate  = "Workorder\Application\WorkOrder\ServiceDetails\Charges\ChargesFactTablePrepare.cfm"
   ScheduleName      = "WorkOrderStats"
   ScheduleMemo      = "Workorder Statistics and datasets" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "01:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">      
   

<cf_ScheduleRegister
   SystemModule      = "Roster" 
   ScheduleTemplate  = "roster/rosterspecial/rosterProcess/ApplicationFunctionDecisionBatchMail.cfm"
   ScheduleName      = "RosterMail"
   ScheduleMemo      = "Batch Roster Mail" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "21:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">   
   
   
<cf_ScheduleRegister
   SystemModule      = "Staffing" 
   ScheduleTemplate  = "Staffing/Application/Employee/Leave/LeaveBalanceBatch.cfm"
   ScheduleName      = "Leave Balances"
   ScheduleMemo      = "Reviews and calaculates leave balances until today" 
   ScheduleStartDate = "01/01/09"
   ScheduleStartTime = "04:55"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "weekly">      
   
<cf_ScheduleRegister
   SystemModule      = "Staffing" 
   ScheduleTemplate  = "Staffing/Application/Employee/Workflow/StepIncrement/StepIncreaseBatch.cfm"
   ScheduleName      = "Step Increment Batch"
   ScheduleMemo      = "Reviews and generates step increment appointment records" 
   ScheduleStartDate = "01/01/09"
   ScheduleStartTime = "04:55"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">      
      
<cf_ScheduleRegister
   SystemModule      = "Vacancy" 
   ScheduleTemplate  = "vactrack/application/tools/TrackVerify.cfm"
   ScheduleName      = "TrackVerify"
   ScheduleMemo      = "Reviews and Corrects Track status information" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "03:55"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">      
   
<cf_ScheduleRegister
   SystemModule      = "Vacancy" 
   ScheduleTemplate  = "tools/process/VacancyCandidate.cfm"
   ScheduleName      = "Selection"
   ScheduleMemo      = "Generate reference tables with recent selections" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "03:30"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">     
   
<cf_ScheduleRegister
   SystemModule      = "Warehouse" 
   ScheduleTemplate  = "warehouse/application/tools/WarehouseRequest.cfm"
   ScheduleName      = "StockRequest"
   ScheduleMemo      = "Initiate Stock replenishment requests" 
   ScheduleStartDate = "01/01/10"
   ScheduleStartTime = "03:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">        
   
<cf_ScheduleRegister
   SystemModule      = "Warehouse" 
   ScheduleTemplate  = "warehouse/application/tools/WarehouseStats.cfm"
   ScheduleName      = "Warehouse"
   ScheduleMemo      = "Prepare Warehouse Consolidated Information" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "03:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">   
      
<cf_ScheduleRegister
   SystemModule      = "Warehouse" 
   ScheduleTemplate  = "warehouse/application/tools/WarehousePrices.cfm"
   ScheduleName      = "Sales Pricing"
   ScheduleMemo      = "Prepare WWW pricing lookup table" 
   ScheduleStartDate = "01/01/21"
   ScheduleStartTime = "03:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">     
                 
	  
<cf_ScheduleRegister
   SystemModule      = "Accounting" 
   ScheduleTemplate  = "gledger/application/transaction/schedule/Closing.cfm"
   ScheduleName      = "Closing"
   ScheduleMemo      = "Prepare Opening Transaction for open Periods" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "03:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">  
 
<cf_ScheduleRegister
   SystemModule      = "Accounting" 
   ScheduleTemplate  = "gledger/application/transaction/schedule/ExchangeDiff.cfm"
   ScheduleName      = "Exchange"
   ScheduleMemo      = "Revaluation Monetary accounts" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "03:40"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">    
   
<cf_ScheduleRegister
   SystemModule      = "Accounting" 
   ScheduleTemplate  = "gledger/application/transaction/schedule/Purchases.cfm"
   ScheduleName      = "TransitionPurchase"
   ScheduleMemo      = "Review value of transition account : Purchases" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "03:40"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">       

<cf_ScheduleRegister
   SystemModule      = "Accounting" 
   ScheduleTemplate  = "ProgramREM/Application/Budget/Allotment/Setting/batchMappingTransaction.cfm"
   ScheduleName      = "Contribution"
   ScheduleMemo      = "Auto Assign contributions to Financials transactions" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "03:50"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">       
        
<cf_ScheduleRegister
   SystemModule      = "System" 
   ScheduleTemplate  = "gledger/application/transaction/schedule/JournalAction.cfm"
   ScheduleName      = "JournalAction"
   ScheduleMemo      = "Generate Journal Actions" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "01:10"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">      
    
<cf_ScheduleRegister
   SystemModule      = "Accounting" 
   ScheduleTemplate  = "gledger/application/transaction/schedule/Audit.cfm"
   ScheduleName      = "Transaction Audit"
   ScheduleMemo      = "Perform various integrity measures on the accounting database" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "03:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">     

<cf_ScheduleRegister
   SystemModule      = "Warehouse" 
   ScheduleTemplate  = "Warehouse/Application/Stock/Schedule/StockOnHand.cfm"
   ScheduleName      = "StockLevel"
   ScheduleMemo      = "Verifies consistency and generate a stock level lookup table" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "03:50"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">   
   
     
<cf_ScheduleRegister
   SystemModule      = "Staffing" 
   ScheduleTemplate  = "Staffing/Application/tools/StaffingStats.cfm"
   ScheduleName      = "StaffingStats"
   ScheduleMemo      = "Generate views and aggregated staffing information" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "04:50"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">   
   
   
<cf_ScheduleRegister
   SystemModule      = "Program" 
   ScheduleTemplate  = "ProgramREM/Application/tools/ProgramStats.cfm"
   ScheduleName      = "ProgramStats"
   ScheduleMemo      = "Generate views and aggregated information" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "04:50"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">      
     
<cf_ScheduleRegister
   SystemModule      = "Procurement" 
   ScheduleTemplate  = "procurement/Application/tools/ProcurementStats.cfm"
   ScheduleName      = "ProcStats"
   ScheduleMemo      = "Generate aggregated procurement information" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "04:30"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">
      
<cf_ScheduleRegister
   SystemModule      = "Warehouse" 
   ScheduleTemplate  = "Warehouse/Application/Stock/Schedule/Backorder.cfm"
   ScheduleName      = "BackOrder"
   ScheduleMemo      = "Verifies reset of backordered items" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "04:50"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">                 
   
<cf_ScheduleRegister
   SystemModule      = "TravelClaim" 
   ScheduleTemplate  = "travelclaim/Application/Process/Merge/Upload.cfm"
   ScheduleName      = "MergeClaim"
   ScheduleMemo      = "Merge Claim Information from source" 
   ScheduleStartDate = "01/01/07"
   ScheduleStartTime = "04:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">
   
<cf_ScheduleRegister
   SystemModule      = "Accounting" 
   ScheduleTemplate  = "System/Gledger/AmountOutstandingCheck.cfm"
   ScheduleName      = "AmountOutstanding Audit"
   ScheduleMemo      = "checks for wrongly calculated amountOustanding" 
   ScheduleStartDate = "07/01/16"
   ScheduleStartTime = "03:00"
   ApplicationServer = "#Host.ApplicationServer#" 
   ScheduleInterval  = "daily">  
   
</cfif>	     