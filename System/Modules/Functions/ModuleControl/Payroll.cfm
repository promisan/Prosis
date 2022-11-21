
<!--- manual      --->

<cf_ModuleInsertSubmit
   SystemModule    = "Payroll" 
   FunctionClass   = "Manuals"
   FunctionName    = "Payroll Manual"    
   MenuOrder       = "1"
   MainMenuItem    = "1"   
   FunctionMemo    = "Payroll manual"
   FunctionDirectory = "Manual/Payroll"
   FunctionPath    = "Payroll.pdf"
   AccessUserGroup = "0">    
   
<!--- application --->
   
<cf_ModuleInsertSubmit
   SystemModule    = "Payroll" 
   FunctionClass   = "Application"
   FunctionName    = "Payroll Calculation and Review" 
   MenuClass       = "Mission"
   MenuOrder       = "1"
   MainMenuItem    = "1"   
   FunctionMemo    = "Process Payroll"
   FunctionDirectory = "Payroll/Application"
   FunctionPath    = "ProcessSchedule/ProcessList.cfm"
   AccessUserGroup = "0">
     
<cf_ModuleInsertSubmit
   SystemModule    = "Payroll" 
   FunctionClass   = "Application"
   FunctionName    = "Review Staff Contracts" 
   MenuClass       = "Mission"
   MenuOrder       = "2"
   MainMenuItem    = "1"   
   FunctionMemo    = "Contract and contract expiration"
   FunctionDirectory = "Payroll/Application"
   FunctionPath    = "Contracts/ContractSchedule.cfm"
   AccessUserGroup = "0">  
   
<cf_ModuleInsertSubmit
   SystemModule    = "Payroll" 
   FunctionClass   = "Application"
   FunctionName    = "Review Staff Entitlements" 
   MenuClass       = "Mission"
   MenuOrder       = "3"
   MainMenuItem    = "1"   
   FunctionMemo    = "Employee entitlements and obligations"
   FunctionDirectory = "Payroll/Application"
   FunctionPath    = "Entitlements/EntitlementView.cfm"
   AccessUserGroup = "0">     
   
<cf_ModuleInsertSubmit
   SystemModule    = "Payroll" 
   FunctionClass   = "Application"
   FunctionName    = "Sales Commission" 
   MenuClass       = "Mission"
   MenuOrder       = "4"
   MainMenuItem    = "1"   
   FunctionMemo    = "Review and calculate sales commission"
   FunctionDirectory = "Payroll/Application"
   FunctionPath    = "Commission/CommissionView.cfm"
   AccessUserGroup = "0">   
   
<cf_ModuleInsertSubmit
   SystemModule    = "Payroll" 
   FunctionClass   = "Application"
   FunctionName    = "Payroll Validation" 
   MenuClass       = "Mission"
   MenuOrder       = "5"
   MainMenuItem    = "1"   
   FunctionMemo    = "Payroll longitudinal analysis"
   FunctionDirectory = "Payroll/Inquiry"
   FunctionPath    = "Quality/QualityView.cfm"
   AccessUserGroup = "0">         
   
<cf_ModuleInsertSubmit
   SystemModule    = "Payroll" 
   FunctionClass   = "Application"
   FunctionName    = "Payroll Settlement dataset" 
   MenuClass       = "Mission"
   MenuOrder       = "6"
   MainMenuItem    = "1"   
   FunctionMemo    = "Dataset Payroll settlement"
   FunctionDirectory = "Payroll/Inquiry"
   FunctionPath    = "Settlement/SettlementView.cfm"
   AccessUserGroup = "0">      

   
<!--- context menu --->   
    
<cf_ModuleInsertSubmit
   SystemModule     = "Payroll" 
   FunctionClass    = "Employee"
   FunctionName     = "Bank account" 
   MenuClass        = "Payroll"
   MenuOrder        = "1"
   MainMenuItem     = "0"
   FunctionMemo     = "Bank account"
   ScriptName       = "bankaccount"> 
     
<cf_ModuleInsertSubmit
   SystemModule     = "Payroll" 
   FunctionClass    = "Employee"
   FunctionName     = "Overtime" 
   MenuClass        = "Payroll"
   MenuOrder        = "2"
   MainMenuItem     = "0"
   FunctionMemo     = "Overtime"
   ScriptName       = "overtime"> 
   
<cf_ModuleInsertSubmit
   SystemModule     = "Payroll" 
   FunctionClass    = "Employee"
   FunctionName     = "Miscellaneous" 
   MenuClass        = "Payroll"
   MenuOrder        = "3"
   MainMenuItem     = "0"
   FunctionMemo     = "Miscellaneous"
   ScriptName       = "miscellaneous">  
    
<cf_ModuleInsertSubmit
   SystemModule     = "Payroll" 
   FunctionClass    = "Employee"
   FunctionName     = "Entitlements" 
   MenuClass        = "Payroll"
   MenuOrder        = "4"
   MainMenuItem     = "0"
   FunctionMemo     = "Entitlements"
   ScriptName       = "entitlement">  
   
<cf_ModuleInsertSubmit
   SystemModule     = "Payroll" 
   FunctionClass    = "Employee"
   FunctionName     = "Payment Method" 
   MenuClass        = "Payroll"
   MenuOrder        = "7"
   MainMenuItem     = "0"
   FunctionMemo     = "Distribute payroll"
   ScriptName       = "distribution">         
     
<cf_ModuleInsertSubmit
   SystemModule     = "Payroll" 
   FunctionClass    = "Employee"
   FunctionName     = "Payslip" 
   MenuClass        = "Payroll"
   MenuOrder        = "8"
   MainMenuItem     = "0"
   FunctionMemo     = "Payslip"
   ScriptName       = "payroll">     
     
 <cf_ModuleInsertSubmit
   SystemModule      = "Payroll" 
   FunctionClass     = "Employee"
   FunctionName      = "Local Payroll" 
   MenuClass         = "Payroll"
   MenuOrder         = "9"
   MainMenuItem      = "0"
   FunctionMemo      = "Localised payroll recapitulation"
   ScriptName        = "payrolllocal">               

<cf_ModuleInsertSubmit
   SystemModule      = "Payroll" 
   FunctionClass     = "Maintain"
   FunctionName      = "Payroll Trigger" 
   MenuClass         = "Main"
   MenuOrder         = "4"
   MainMenuItem      = "1"
   FunctionMemo      = "Maintain Selectable Payroll entitlements"
   FunctionDirectory = "Payroll/Maintenance"
   FunctionPath      = "Trigger/RecordListing.cfm"
   FunctionIcon      = "Maintain">  
   
<cf_ModuleInsertSubmit
   SystemModule      = "Payroll" 
   FunctionClass     = "Reference"
   FunctionName      = "Trigger Class" 
   MenuClass         = "Main"
   MenuOrder         = "5"
   MainMenuItem      = "1"
   FunctionMemo      = "Maintain Payroll Triggers classes"
   FunctionDirectory = "Payroll/Maintenance"
   FunctionPath      = "TriggerGroup/RecordListing.cfm"
   FunctionIcon      = "Maintain">  
   
 <cf_ModuleInsertSubmit
   SystemModule="Payroll" 
   FunctionClass = "Reference"
   FunctionName = "Payroll Group" 
   MenuClass    = "Main"
   MenuOrder    = "6"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Payroll Slip Grouping"
   FunctionDirectory = "Payroll/Maintenance"
   FunctionPath = "SalaryGroup/RecordListing.cfm"
   FunctionIcon = "Maintain">  
   
<cf_ModuleInsertSubmit
   SystemModule="Payroll" 
   FunctionClass = "Maintain"
   FunctionName = "Salary scale elements" 
   MenuClass    = "Main"
   MenuOrder    = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Salary scale elements"
   FunctionDirectory = "Payroll/Maintenance"
   FunctionPath = "Component/RecordListing.cfm"
   FunctionIcon = "Maintain">      

<cf_ModuleInsertSubmit
   SystemModule="Payroll" 
   FunctionClass = "Reference"
   FunctionName = "Payroll Duty Station" 
   MenuClass    = "Main"
   MenuOrder    = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Payroll Duty Stations"
   FunctionDirectory = "Payroll/Maintenance"
   FunctionPath = "Location/RecordListing.cfm"
   FunctionIcon = "Maintain">      
      
<cf_ModuleInsertSubmit
   SystemModule="Payroll" 
   FunctionClass = "Maintain"
   FunctionName = "Payslip Item" 
   MenuClass    = "Main"
   MenuOrder    = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Payslip Items and Presentation"
   FunctionDirectory = "Payroll/Maintenance"
   FunctionPath = "SalaryItem/RecordListing.cfm"
   FunctionIcon = "Maintain">    
        
<cf_ModuleInsertSubmit
   SystemModule="Payroll" 
   FunctionClass = "Reference"
   FunctionName = "Bank" 
   MenuClass    = "Main"
   MenuOrder    = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Bank Institutions"
   FunctionDirectory = "Payroll/Maintenance"
   FunctionPath = "Bank/RecordListing.cfm"
   FunctionIcon = "Maintain">     
      
<cf_ModuleInsertSubmit
   SystemModule="Payroll" 
   FunctionClass = "Maintain"
   FunctionName = "Calculation Base" 
   MenuClass    = "Main"
   MenuOrder    = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Calculation Base"
   FunctionDirectory = "Payroll/Maintenance"
   FunctionPath = "CalculationBase/RecordListing.cfm"
   FunctionIcon = "Maintain">
 
<cf_ModuleInsertSubmit
   SystemModule="Payroll" 
   FunctionClass = "Reference"
   FunctionName = "Designation" 
   MenuClass    = "Main"
   MenuOrder    = "5"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Designations"
   FunctionDirectory = "Payroll/Maintenance"
   FunctionPath = "Designation/RecordListing.cfm"
   FunctionIcon = "Maintain">    