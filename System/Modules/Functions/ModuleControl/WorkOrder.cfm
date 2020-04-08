
<cf_ModuleInsert
   SystemModule    = "WorkOrder" 
   Description     = "Operations Management"
   MenuTemplate    = "WorkOrder" 
   Hint            = "Plan, Control and Review"
   MenuOrder       = "8">
   
<!---
<cf_ModuleInsertSubmit
   SystemModule="WorkOrder" 
   FunctionClass = "Application"
   FunctionName = "Workorder Request" 
   MenuClass = "Mission"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Customer Profile"
   FunctionDirectory = "System/Organization"
   FunctionPath = "Customer/CustomerView.cfm"      
   AccessUserGroup = "0">         
--->      

<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Application"
   FunctionName      = "Mission Posting" 
   MenuClass         = "Main"
   MenuOrder         = "1"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Mission Posting"
   FunctionDirectory = "WorkOrder/Maintenance/"
   FunctionPath      = "MissionPosting/RecordListing.cfm"
   AccessUserGroup   = "0">       
   
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Application"
   FunctionName      = "Sales Planning" 
   MenuClass         = "Mission"
   MenuOrder         = "1"
   MainMenuItem      = "1"
   FunctionMemo      = "Shipment of WorkOrders"
   FunctionDirectory = "Workorder/Application"
   FunctionPath      = "Assembly/Sales/Forecast/ForecastView.cfm"     
   AccessUserGroup   = "0">           
           
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Application"
   FunctionName      = "Customer Orders" 
   MenuClass         = "Mission"
   MenuOrder         = "2"
   MainMenuItem      = "1"
   FunctionMemo      = "Manage and record WorkOrders"
   FunctionDirectory = "System/Organization"
   FunctionPath      = "Customer/CustomerView.cfm"   
   FunctionCondition = "dsn=AppsWorkOrder"
   AccessUserGroup   = "0">    
       
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Application"
   FunctionName      = "Workorder Shipment" 
   MenuClass         = "Mission"
   MenuOrder         = "3"
   MainMenuItem      = "1"
   FunctionMemo      = "Shipment of WorkOrders"
   FunctionDirectory = "Workorder/Application"
   FunctionPath      = "Shipping/ShippingView.cfm"     
   AccessUserGroup   = "0">    
   
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Application"
   FunctionName      = "Workorder Delivery" 
   MenuClass         = "Mission"
   MenuOrder         = "4"
   MainMenuItem      = "1"
   FunctionMemo      = "Delivery planner"
   FunctionDirectory = "Workorder/Application"
   FunctionPath      = "Delivery/DeliveryView.cfm"     
   AccessUserGroup   = "0">    
   
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Application"
   FunctionName      = "Workorder Medical" 
   MenuClass         = "Mission"
   MenuOrder         = "5"
   MainMenuItem      = "1"
   FunctionMemo      = "Medical Services Manager"
   FunctionDirectory = "Workorder/Application"
   FunctionPath      = "Medical/ServiceDetails/WorkPlan/WorkPlanView.cfm"     
   AccessUserGroup   = "0">    
   
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Application"
   FunctionName      = "Workorder Locations" 
   MenuClass         = "Mission"
   MenuOrder         = "6"
   MainMenuItem      = "1"
   FunctionMemo      = "Service Location Manager"
   FunctionDirectory = "Workorder/Maintenance"
   FunctionPath      = "Location/LocationListing.cfm"     
   AccessUserGroup   = "0">     
        
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Application"
   FunctionName      = "Patient File" 
   MenuClass         = "Mission"
   MenuOrder         = "3"
   MainMenuItem      = "1"
   FunctionMemo      = "Patient Archive"
   FunctionDirectory = "Roster/RosterGeneric/"
   FunctionPath      = "CandidateSearch.cfm"
   FunctionCondition = "class=4"   
   ScriptName        = ""
   AccessUserGroup   = "1">                
   
<!--- --------------- --->   
<!--- medical tasks-- --->
<!--- --------------- --->  
      
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Medical"
   FunctionName      = "Pending Requests" 
   MenuClass         = "Schedule"
   MenuOrder         = "1"
   MainMenuItem      = "0"
   BrowserSupport    = "2"
   FunctionMemo      = "Workplan"
   ScriptName        = "medicalrequest"   
   FunctionIcon      = "Maintain">      
   
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Medical"
   FunctionName      = "Scheduled Contacts" 
   MenuClass         = "Schedule"
   MenuOrder         = "1"
   MainMenuItem      = "0"
   BrowserSupport    = "2"
   FunctionMemo      = "Workplan"
   ScriptName        = "medicalcontact"   
   FunctionIcon      = "Maintain">       
       
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Medical"
   FunctionName      = "Schedule Medical Actions" 
   MenuClass         = "Schedule"
   MenuOrder         = "2"
   MainMenuItem      = "0"
   BrowserSupport    = "2"
   FunctionMemo      = "Workplan"
   ScriptName        = "medicalaction"    
   FunctionIcon      = "Maintain">   
   
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Medical"
   FunctionName      = "Notifications" 
   MenuClass         = "Schedule"
   MenuOrder         = "3"
   MainMenuItem      = "0"
   BrowserSupport    = "2"
   FunctionMemo      = "Workplan"
   ScriptName        = "medicalnotification"     
   FunctionIcon      = "Maintain">          
        
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Medical"
   FunctionName      = "Charges and Receivables" 
   MenuClass         = "Schedule"
   MenuOrder         = "4"
   MainMenuItem      = "0"
   BrowserSupport    = "2"
   FunctionMemo      = "Workplan"
   ScriptName        = "medicalbilling" 
   FunctionIcon      = "Maintain">        
           

<!--- --------------- --->   
<!--- shipping tasks- --->
<!--- --------------- --->   
         
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Shipping"
   FunctionName      = "Clear Transactions" 
   MenuClass         = "Shipment"
   MenuOrder         = "1"
   MainMenuItem      = "0"
   BrowserSupport    = "2"
   FunctionMemo      = "Clear transaction"
   FunctionDirectory = "WorkOrder/Application/Shipping"
   FunctionPath      = "ShipmentView/ShipmentListing.cfm"
   FunctionCondition = "ID=STA"
   FunctionIcon      = "Maintain">    
           
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Shipping"
   FunctionName      = "Shipment return" 
   MenuClass         = "Shipment"
   MenuOrder         = "2"
   MainMenuItem      = "0"
   BrowserSupport    = "2"
   FunctionMemo      = "Revert shipped transactions"
   FunctionDirectory = "WorkOrder/Application/Shipping"   
   FunctionPath      = "Return/WorkOrderListing.cfm"
   FunctionCondition = "Status=All"
   FunctionIcon      = "Maintain">   
   
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Shipping"
   FunctionName      = "Customer return" 
   MenuClass         = "Shipment"
   MenuOrder         = "3"
   MainMenuItem      = "0"
   BrowserSupport    = "2"
   FunctionMemo      = "Revert shipped transactions"
   FunctionDirectory = "WorkOrder/Application/Shipping"   
   FunctionPath      = "CustomerReturn/WorkOrderListing.cfm"
   FunctionCondition = "Status=All"
   FunctionIcon      = "Maintain">      
          
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Shipping"
   FunctionName      = "Issue Invoice" 
   MenuClass         = "Shipment"
   MenuOrder         = "4"
   MainMenuItem      = "0"
   BrowserSupport    = "2"
   FunctionMemo      = "Generate Invoice for shipped transactions"
   FunctionDirectory = "WorkOrder/Application/Shipping"
   FunctionPath      = "Billing/WorkOrderListing.cfm"
   FunctionCondition = "ID1=Billing&ID=STA"
   FunctionIcon      = "Maintain">     
   
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Shipping"
   FunctionName      = "Issue Credit Note" 
   MenuClass         = "Shipment"
   MenuOrder         = "5"
   MainMenuItem      = "0"
   BrowserSupport    = "2"
   FunctionMemo      = "Generate Credit note for returned transactions"
   FunctionDirectory = "WorkOrder/Application/Shipping"
   FunctionPath      = "Billing/WorkOrderListing.cfm"
   FunctionCondition = "ID1=Billing&ID=CRE"
   FunctionIcon      = "Maintain">   
   
<!--- ----------------- --->   
<!--- Inquiry functions --->
<!--- ---------------- --->      

<cf_ModuleInsertSubmit
   SystemModule="WorkOrder" 
   FunctionClass = "Dataset"
   FunctionName = "Sales Workorder Inquiry" 
   MenuClass    = "Main"
   MenuOrder    = "4"
   MainMenuItem = "1"
   FunctionMemo = "Sales Workorder Inquiry Dataset"
   FunctionDirectory = "WorkOrder/Inquiry/"
   FunctionPath = "WorkOrderItem/Dataset.cfm"
   FunctionIcon = "Dataset">                
             
<!--- ------------- --->   
<!--- system tables --->
<!--- ------------- --->                 
       
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "Global Settings" 
   MenuClass         = "Main"
   MenuOrder         = "1"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain System Settings"
   FunctionDirectory = "Workorder/Maintenance/"
   FunctionPath      = "Parameter/ParameterEdit.cfm"
   AccessUserGroup   = "0">       
 
        
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "Service Item and Rates" 
   MenuClass         = "Main"
   MenuOrder         = "2"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Service Items and related Service Units and Rates"
   FunctionDirectory = "Workorder/Maintenance/"
   FunctionPath      = "ServiceItem/RecordListing.cfm"
   AccessUserGroup   = "0">      
   
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "Settlement" 
   MenuClass         = "Main"
   MenuOrder         = "2"
   MainMenuItem      = "0"
   FunctionMemo      = "WorkOrder Sale Settlement settings"
   FunctionDirectory = "Workorder/Maintenance/"
   FunctionPath      = "Settlement/RecordListing.cfm"
   AccessUserGroup   = "0">                                           
     
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "WorkOrder Actions" 
   MenuClass         = "Main"
   MenuOrder         = "3"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain WorkOrder Actions"
   FunctionDirectory = "Workorder/Maintenance/"
   FunctionPath      = "Action/RecordListing.cfm"
   AccessUserGroup   = "0">   
        
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "Request Workflow routing" 
   MenuClass         = "Main"
   MenuOrder         = "4"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Request and Request Workflow actiobs"
   FunctionDirectory = "WorkOrder/Maintenance/"
   FunctionPath      = "RequestWorkflow/RecordListing.cfm"
   AccessUserGroup   = "0">          
    
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "Custom Fields" 
   MenuClass         = "Main"
   MenuOrder         = "5"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Custom Fields WorkOrder"
   FunctionDirectory = "WorkOrder/Maintenance/"
   FunctionPath      = "Custom/RecordListing.cfm"
   AccessUserGroup   = "0">   
     
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "Funding" 
   MenuClass         = "Main"
   MenuOrder         = "9"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Funding for workorder lines (UN only)"
   FunctionDirectory = "WorkOrder/Maintenance/"
   FunctionPath      = "Funding/ItemSearch.cfm"
   AccessUserGroup   = "0">

<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "Customer Mapping" 
   MenuClass         = "Main"
   MenuOrder         = "10"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Customer Mappings (UN only)"
   FunctionDirectory = "WorkOrder/Maintenance/"
   FunctionPath      = "CustomerMapping/ItemSearch.cfm"
   AccessUserGroup   = "0">  
  
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "Service Item Load Trigger" 
   MenuClass         = "Main"
   MenuOrder         = "11"
   MainMenuItem      = "0"
   FunctionMemo      = "Service Item Load Trigger (UN only)"
   FunctionDirectory = "WorkOrder/Maintenance/"
   FunctionPath      = "ServiceItemLoadTrigger/RecordListing.cfm"
   AccessUserGroup   = "0">  

<!--- --------- --->   
<!--- reference --->
<!--- --------- --->   
    
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "Service Class" 
   MenuClass         = "Reference"
   MenuOrder         = "1"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Service Items Classes"
   FunctionDirectory = "Workorder/Maintenance/"
   FunctionPath      = "ServiceClass/RecordListing.cfm"
   AccessUserGroup   = "0">  
     
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "Unit Class" 
   MenuClass         = "Reference"
   MenuOrder         = "2"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Service Item Unit Classes"
   FunctionDirectory = "WorkOrder/Maintenance/"
   FunctionPath      = "UnitClass/RecordListing.cfm"
   AccessUserGroup   = "0">     
   
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "Service Domain" 
   MenuClass         = "Reference"
   MenuOrder         = "3"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Service Domain which defined the reference"
   FunctionDirectory = "Workorder/Maintenance/"
   FunctionPath      = "Domain/RecordListing.cfm"
   AccessUserGroup   = "0">       
   
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "Type of Request" 
   MenuClass         = "Reference"
   MenuOrder         = "4"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Service Request Types"
   FunctionDirectory = "Workorder/Maintenance/"
   FunctionPath      = "RequestType/RecordListing.cfm"
   AccessUserGroup   = "0">   
      
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "Billing Mode" 
   MenuClass         = "Reference"
   MenuOrder         = "5"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Billing Mode"
   FunctionDirectory = "WorkOrder/Maintenance/"
   FunctionPath      = "BillingMode/RecordListing.cfm"
   AccessUserGroup   = "0"> 
   
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "Terms" 
   MenuClass         = "Reference"
   MenuOrder         = "6"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Terms"
   FunctionDirectory = "WorkOrder/Maintenance/"
   FunctionPath      = "Terms/RecordListing.cfm"
   AccessUserGroup   = "0"> 
   
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "Frequency" 
   MenuClass         = "Reference"
   MenuOrder         = "7"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Billing Frequency"
   FunctionDirectory = "WorkOrder/Maintenance/"
   FunctionPath      = "Frequency/RecordListing.cfm"
   AccessUserGroup   = "0"> 
   
<cf_ModuleInsertSubmit
   SystemModule      = "WorkOrder" 
   FunctionClass     = "Maintain"
   FunctionName      = "Presentation Mode" 
   MenuClass         = "Reference"
   MenuOrder         = "8"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Presentation Mode"
   FunctionDirectory = "WorkOrder/Maintenance/"
   FunctionPath      = "PresentationMode/RecordListing.cfm"
   AccessUserGroup   = "0">