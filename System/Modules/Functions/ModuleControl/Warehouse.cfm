

<!--- create views --->

 <cfquery name="Drop"
	datasource="appsMaterials">
      if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vwCustomerAddress]') 
	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwCustomerAddress]
  </cfquery>

  <cfquery name="CreateView"
	datasource="appsMaterials">
	CREATE VIEW dbo.vwCustomerAddress
	AS
		
	SELECT    TOP 100 PERCENT s.*,
	          A.AddressScope, 
	          A.Address, 
			  A.Address2, 
			  A.AddressCity, 
			  A.AddressRoom, 			
			  A.AddressPostalCode, 
			  A.State, 
			  A.Country, 
			  A.Coordinates, 
              A.eMailAddress, 
			  A.Source, 
			  A.Remarks
	FROM      dbo.CustomerAddress S INNER JOIN System.dbo.Ref_Address A ON S.AddressId = A.AddressId
	ORDER BY  S.CustomerId  
	
  </cfquery>
  

<!--- -------------------------- --->
<!--- -------Applications------- --->
<!--- -------------------------- --->

<cf_ModuleInsertSubmit
	   SystemModule="Warehouse" 
	   FunctionClass = "Application"
	   FunctionName = "Asset Control" 
	   MenuClass = "Mission"
	   MenuOrder = "1"
	   MainMenuItem = "1"
	   FunctionMemo = "Asset Control and Management"
	   ScriptName = "asset"
	   AccessUserGroup = "0">     
	   
<cf_ModuleInsertSubmit
	   SystemModule="Warehouse" 
	   FunctionClass = "Application"
	   FunctionName = "Supply Request and Stock Task Order" 
	   MenuClass = "Mission"
	   MenuOrder = "2"
	   MainMenuItem = "1"
	   FunctionMemo = "Warehouse Stock Request and Processing"
	   ScriptName = "taskorder"
	   AccessUserGroup = "0">   	   

<!--- disabled --->

<cf_ModuleInsertSubmit
	   SystemModule="Warehouse" 
	   FunctionClass = "Application"
	   FunctionName = "Requisition Portal" 
	   MenuClass = "Mission"
	   MenuOrder = "3"
	   MainMenuItem = "1"
	   FunctionIcon = "personal"
	   FunctionMemo = "Issue requests for (Non) expendable items"
	   ScriptName = "supply"
	   AccessUserGroup = "0"
	   Operational="0">	   
	 	    
<cf_ModuleInsertSubmit
	   SystemModule="Warehouse" 
	   FunctionClass = "Application"
	   FunctionName = "Requisition Clearance" 
	   MenuClass = "Mission"
	   MenuOrder = "4"
	   MainMenuItem = "1"   
	   FunctionMemo = "Batch Clearance Warehouse Requisitions"
	   FunctionDirectory = "Warehouse/Application"
	   FunctionPath = "Process/Clearance/Listing.cfm"
	   AccessUserGroup = "0">
    
<cf_ModuleInsertSubmit
	   SystemModule="Warehouse" 
	   FunctionClass = "Application"
	   FunctionName = "Stock Control" 
	   MenuClass = "Mission"
	   MenuOrder = "5"
	   MainMenuItem = "1"
	   FunctionMemo = "Warehouse Stock Processing and Management"
	   ScriptName = "stock"
	   AccessUserGroup = "0">      

<cf_ModuleInsertSubmit
	   SystemModule="Warehouse" 
	   FunctionClass = "Application"
	   FunctionName = "Maintain Physical Locations" 
	   MenuClass = "Mission"
	   MenuOrder = "6"
	   MainMenuItem = "1"
	   FunctionMemo = "Maintain asset locations"
	   ScriptName = "assetlocation"
	   AccessUserGroup = "0">  
   
<cf_ModuleInsertSubmit
	   SystemModule="Warehouse" 
	   FunctionClass = "Application"
	   FunctionName = "Customer" 
	   MenuClass = "Mission"
	   MenuOrder = "7"
	   MainMenuItem = "1"
	   FunctionMemo = "Maintain Customer Profile"
	   FunctionDirectory = "Warehouse/Application"
	   FunctionPath = "Customer/View/CustomerView.cfm"   	   
	   AccessUserGroup = "0"
	   Operational="0">   	   
	   
	   <!--- FunctionCondition="dsn=AppsMaterials" --->

<!--- -------------------------- --->
<!--- ---------Inquiry---------- --->
<!--- -------------------------- --->

<cf_ModuleInsertSubmit
   SystemModule      = "Warehouse" 
   FunctionClass     = "Inquiry"
   FunctionName      = "Stock Distribution" 
   MenuClass         = "Main"
   MenuOrder         = "7"
   MainMenuItem      = "1"
   FunctionMemo      = "Stock Distribution Inquiry"
   FunctionDirectory = "Warehouse/Inquiry"
   FunctionPath      = "Warehouse/WarehouseView.cfm"   	  
   AccessUserGroup   = "0"
   Operational       = "1">   	
   
<cf_ModuleInsertSubmit
   SystemModule      = "Warehouse" 
   FunctionClass     = "Inquiry"
   FunctionName      = "Record Natural Person" 
   MenuClass         = "Main"
   MenuOrder         = "2"
   MainMenuItem      = "1"
   FunctionMemo      = "Record an individual"
   FunctionDirectory = "Roster/PHP/"
   FunctionPath      = "PHPEntry/Inception/General.cfm"
   FunctionCondition = "class=5&action=create&scope=backoffice"
   ScriptName        = ""
   AccessUserGroup   = "1">    
   
<cf_ModuleInsertSubmit
   SystemModule      = "Warehouse" 
   FunctionClass     = "Inquiry"
   FunctionName      = "Natural Person Repository" 
   MenuClass         = "Main"
   MenuOrder         = "3"
   MainMenuItem      = "1"
   FunctionMemo      = "Search for a recorded individual"
   FunctionDirectory = "Roster/"
   FunctionPath      = "RosterGeneric//CandidateSearch.cfm"
   FunctionCondition = "class=5"
   ScriptName        = ""
   AccessUserGroup   = "1">        
   
	   
<!--- ------------------------ --->   
<!--- Stock control functions- --->
<!--- ------------------------ --->


<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Inquiry"
   FunctionName    = "External Receipts" 
   MenuClass       = "General"
   MenuOrder       = "0"
   MainMenuItem    = "0"
   FunctionMemo    = "External receipts"
   ScriptName      = "stockextreceipt"
   AccessUserGroup = "0">    
    
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Inquiry"
   FunctionName    = "Distribution" 
   MenuClass       = "General"
   MenuOrder       = "2"
   MainMenuItem    = "0"
   FunctionMemo    = "Distribution"
   ScriptName      = "stockdistribution"
   AccessUserGroup = "0">   
    
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Inquiry"
   FunctionName    = "Taskorders" 
   MenuClass       = "General"
   MenuOrder       = "3"
   MainMenuItem    = "0"
   FunctionMemo    = "Distribution"
   ScriptName      = "stockorder"
   AccessUserGroup = "0">          
         
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Inquiry"
   FunctionName    = "Sale Transactions" 
   MenuClass       = "General"
   MenuOrder       = "4"
   MainMenuItem    = "0"
   FunctionMemo    = "Sale Transactions"
   ScriptName      = "saletransaction"
   AccessUserGroup = "0">          
	    
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Inquiry"
   FunctionName    = "Stock on Hand" 
   MenuClass       = "General"
   MenuOrder       = "5"
   MainMenuItem    = "0"
   FunctionMemo    = "Stock on hand"
   ScriptName      = "stockonhand"
   AccessUserGroup = "0">   
   
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Inquiry"
   FunctionName    = "Stock Diversity" 
   MenuClass       = "General"
   MenuOrder       = "7"
   MainMenuItem    = "0"
   FunctionMemo    = "Items that are used within a warehouse"
   ScriptName      = "stockdiversity"
   AccessUserGroup = "0">     
       
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Inquiry"
   FunctionName    = "Transactional Stock" 
   MenuClass       = "General"
   MenuOrder       = "6"
   MainMenuItem    = "0"
   FunctionMemo    = "Stock on hand for transactional stock"
   ScriptName      = "stockonhandtransaction"
   AccessUserGroup = "0">        
          
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Stock"
   FunctionName    = "Resupply Requests" 
   MenuClass       = "Inquiry"
   MenuOrder       = "3"
   MainMenuItem    = "0"
   FunctionMemo    = "Stock on Order"
   ScriptName      = "stockonorder"
   AccessUserGroup = "0"
   operational     = "0">      

<!--- ---------------------- --->      
<!--- -core stock actions--- --->     
<!--- ---------------------- --->   
   
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Stock"
   FunctionName    = "Record Initial Stock" 
   MenuClass       = "General"
   MenuOrder       = "1"
   MainMenuItem    = "0"
   FunctionMemo    = "Register Initial Stock"
   ScriptName      = "stockinitial"
   AccessUserGroup = "0">     
  
<!---
 
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Stock"
   FunctionName    = "Record Production Stock" 
   MenuClass       = "General"
   MenuOrder       = "2"
   MainMenuItem    = "0"
   FunctionMemo    = "Register Production Stock"
   ScriptName      = "stockproduction"
   AccessUserGroup = "0">      
   
   --->   
    
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Stock"
   FunctionName    = "Inventory Reconciliation" 
   MenuClass       = "General"
   MenuOrder       = "4"
   MainMenuItem    = "0"
   FunctionMemo    = "Stock Inventory"
   ScriptName      = "stockinventory"
   AccessUserGroup = "0">     
   
<!--- -------------------- --->   
<!--- -- sales mutations-- --->
<!--- -------------------- --->     
      
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "StockSale"
   FunctionName    = "Point of Sale" 
   MenuClass       = "General"
   MenuOrder       = "1"
   MainMenuItem    = "0"
   FunctionMemo    = "Sales Entry"
   ScriptName      = "stockpos"
   AccessUserGroup = "0">  

<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "StockSale"
   FunctionName    = "Sale Quotes" 
   MenuClass       = "General"
   MenuOrder       = "2"
   MainMenuItem    = "0"
   FunctionMemo    = "Sales Entry"
   ScriptName      = "stockquote"
   AccessUserGroup = "0">   
   
 <cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "StockSale"
   FunctionName    = "Collect Sale" 
   MenuClass       = "General"
   MenuOrder       = "1"
   MainMenuItem    = "0"
   FunctionMemo    = "Sales Entry"
   ScriptName      = "stockcol"
   AccessUserGroup = "0">  
   
   <cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "StockSale"
   FunctionName    = "Customer View" 
   MenuClass       = "General"
   MenuOrder       = "1"
   MainMenuItem    = "0"
   FunctionMemo    = "Customer View"
   ScriptName      = "customerview"
   AccessUserGroup = "0">    
   
  <cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "StockSale"
   FunctionName    = "Dispatch Items Sold" 
   MenuClass       = "General"
   MenuOrder       = "3"
   MainMenuItem    = "0"
   FunctionMemo    = "Sales Entry"
   ScriptName      = "saledispatch"
   AccessUserGroup = "0">            
 
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "StockSale"
   FunctionName    = "Price management" 
   MenuClass       = "General"
   MenuOrder       = "4"
   MainMenuItem    = "0"
   FunctionMemo    = "Maintain Item Sales Pricing"
   ScriptName      = "itemprice"
   AccessUserGroup = "0">                  
  
<!--- -------------------- --->   
<!--- core stock mutations --->
<!--- -------------------- --->  

<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "StockTask"
   FunctionName    = "Distribution of Receipts" 
   MenuClass       = "General"
   MenuOrder       = "0"
   MainMenuItem    = "0"
   FunctionMemo    = "Distribution of receipts items among facilities"
   ScriptName      = "stockreceiptissue"
   AccessUserGroup = "0">     
   

<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "StockTask"
   FunctionName    = "Consignment Stock Retour" 
   MenuClass       = "General"
   MenuOrder       = "1"
   MainMenuItem    = "0"
   FunctionMemo    = "Return of receipts that are not billed yet"
   ScriptName      = "stockreturn"
   AccessUserGroup = "0">          
       
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "StockSale"
   FunctionName    = "Point of Sale" 
   MenuClass       = "General"
   MenuOrder       = "1"
   MainMenuItem    = "0"
   FunctionMemo    = "Sales Entry"
   ScriptName      = "stockpos"
   AccessUserGroup = "0">  
      
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "StockTask"
   FunctionName    = "Stock Consumption" 
   MenuClass       = "General"
   MenuOrder       = "2"
   MainMenuItem    = "0"
   FunctionMemo    = "Direct entry of consumption"
   ScriptName      = "stocksale"
   AccessUserGroup = "0">  
   
<!---
     
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "StockTask"
   FunctionName    = "External Stock Consumption" 
   MenuClass       = "General"
   MenuOrder       = "2"
   MainMenuItem    = "0"
   FunctionMemo    = "External Sales of goods"
   ScriptName      = "stockexternalsale"
   AccessUserGroup = "0">     
   
   --->
   
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "StockTask"
   FunctionName    = "Stock Disposal" 
   MenuClass       = "General"
   MenuOrder       = "2"
   MainMenuItem    = "0"
   FunctionMemo    = "Direct entry of disposal"
   ScriptName      = "stockdisposal"
   AccessUserGroup = "0">     
       
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "StockTask"
   FunctionName    = "Stock Issue/Transfer" 
   MenuClass       = "General"
   MenuOrder       = "3"
   MainMenuItem    = "0"
   FunctionMemo    = "Stock Issue/Transfer"
   ScriptName      = "stockissue"
   AccessUserGroup = "0">     
  
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "StockTask"
   FunctionName    = "Process Requested Items" 
   MenuClass       = "General"
   MenuOrder       = "1"
   MainMenuItem    = "0"
   FunctionMemo    = "Process Requests and Prepare Pickticket"
   ScriptName      = "stockpicking"
   AccessUserGroup = "0">    
 
      
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "StockTask"
   FunctionName    = "Internal Transfer" 
   MenuClass       = "General"
   MenuOrder       = "3"
   MainMenuItem    = "0"
   FunctionMemo    = "Stock on hand"
   ScriptName      = "stocktransfer"
   AccessUserGroup = "0">      
	
     
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "StockTask"
   FunctionName    = "Billing of issued stock" 
   MenuClass       = "General"
   MenuOrder       = "5"
   MainMenuItem    = "0"
   FunctionMemo    = "Process Issuances for billing"
   ScriptName      = "stockshipping"
   AccessUserGroup = "0">   
   
<!--- -------------------- --->   
<!--- core stock mutations --->
<!--- -------------------- --->     
  
   
<!--- --disabled as this was moved to asset control--   
   
<cf_ModuleInsertSubmit
   SystemModule   = "Warehouse" 
   FunctionClass  = "StockTask"
   FunctionName   = "Asset Distribution" 
   MenuClass      = "General"
   MenuOrder      = "6"
   MainMenuItem   = "0"
   FunctionMemo   = "Process Requisitions and Assign Assets"
   ScriptName     = "stockasset"
   AccessUserGroup = "0"
   Operational    =  "0">     
   
 --->        
        
<cf_ModuleInsertSubmit
   SystemModule     = "Warehouse" 
   FunctionClass    = "StockTask"
   FunctionName     = "Resupply Stock Level" 
   MenuClass        = "General"
   MenuOrder        = "7"
   MainMenuItem     = "0"
   FunctionMemo     = "Resupply stock"
   ScriptName       = "stockresupply"
   AccessUserGroup  = "0">  
    
<!--- --------------------------- --->   
<!--- maintain stock management-- --->
<!--- --------------------------- --->        
 
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Location"
   FunctionName    = "Process Transactions" 
   MenuClass       = "General"
   MenuOrder       = "1"
   MainMenuItem    = "0"
   FunctionMemo    = "Stock Transaction movements and distribution"
   ScriptName      = "stockbatch"
   AccessUserGroup = "0">   
          
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Location"
   FunctionName    = "Stock Locations" 
   MenuClass       = "General"
   MenuOrder       = "2"
   MainMenuItem    = "0"
   FunctionMemo    = "Transfer Stock"
   ScriptName      = "stocklocation"
   AccessUserGroup = "0">       
   
  
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Location"
   FunctionName    = "Inspection Reports" 
   MenuClass       = "General"
   MenuOrder       = "3"
   MainMenuItem    = "0"
   FunctionMemo    = "Inspection Reports"
   ScriptName      = "stockinspection"
   AccessUserGroup = "0">              
   
<!--- --- end of stock control-- --->   
	
<!--- -------------------------- --->  
<!--- ------sub-general info---- --->  
<!--- -------------------------- --->
	
	<cf_ModuleInsertSubmit
	   SystemModule="Warehouse" 
	   FunctionClass = "Asset"
	   FunctionName = "Asset profile" 
	   MenuClass = "General"
	   MenuOrder = "1"
	   MainMenuItem = "0"
	   FunctionMemo = "Profile"
	   ScriptName = "aprofile"
	   FunctionIcon = "Maintain">  
	   
<!--- -------------------------- --->  
<!--- ------sub-history--------- --->  
<!--- -------------------------- --->   
	     
	<cf_ModuleInsertSubmit
	   SystemModule  = "Warehouse" 
	   FunctionClass = "Asset"
	   FunctionName  = "Location Movement" 
	   MenuClass     = "History"
	   MenuOrder     = "1"
	   MainMenuItem  = "0"
	   FunctionMemo  = "Location"
	   ScriptName    = "alocation"
	   FunctionIcon  = "Maintain">    
	   
	<cf_ModuleInsertSubmit
	   SystemModule  = "Warehouse" 
	   FunctionClass = "Asset"
	   FunctionName  = "Responsibility" 
	   MenuClass     = "History"
	   MenuOrder     = "2"
	   MainMenuItem  = "0"
	   FunctionMemo  = "Responsibility"
	   ScriptName    = "aholder"
	   FunctionIcon  = "Maintain"> 
	   
	<cf_ModuleInsertSubmit
	   SystemModule  = "Warehouse" 
	   FunctionClass = "Asset"
	   FunctionName  = "Observations" 
	   MenuClass     = "History"
	   MenuOrder     = "3"
	   MainMenuItem  = "0"
	   FunctionMemo  = "Actions"
	   ScriptName    = "aaction"
	   FunctionIcon  = "Maintain">   
	   
	<!--- -------------------------- --->  
	<!--- ------sub-financials------ --->  
	<!--- -------------------------- --->                       
	   
	<cf_ModuleInsertSubmit
	   SystemModule  = "Warehouse" 
	   FunctionClass = "Asset"
	   FunctionName  = "Depreciation" 
	   MenuClass     = "Financials"
	   MenuOrder     = "1"
	   MainMenuItem  = "0"
	   FunctionMemo  = "Profile"
	   ScriptName    = "adepreciation"
	   FunctionIcon  = "Maintain">      
	   
	<cf_ModuleInsertSubmit
	   SystemModule  = "Warehouse" 
	   FunctionClass = "Asset"
	   FunctionName  = "Serviced" 
	   MenuClass     = "Financials"
	   MenuOrder     = "2"
	   MainMenuItem  = "0"
	   FunctionMemo  = "Profile"
	   ScriptName    = "aservice"
	   FunctionIcon  = "Maintain">               
   
<!--- ------------------------ --->
<!--- ----- Maintenance ------ --->
<!--- ------------------------ --->

<cf_ModuleInsertSubmit
   SystemModule      = "Warehouse" 
   FunctionClass     = "Item"
   FunctionName      = "General settings" 
   MenuClass         = "Maintain"
   MenuOrder         = "1"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain item"
   ScriptName        = "itmedit"
   AccessUserGroup   = "0">      
   
<cf_ModuleInsertSubmit
   SystemModule      = "Warehouse" 
   FunctionClass     = "Item"
   FunctionName      = "Unit of measure" 
   MenuClass         = "Maintain"
   MenuOrder         = "1"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain item"
   ScriptName        = "itmuom"
   AccessUserGroup   = "0">   
  
<!--- disabled ItemGLedger         
<cf_ModuleInsertSubmit
   SystemModule      = "Warehouse" 
   FunctionClass     = "Item"
   FunctionName      = "Account codes" 
   MenuClass         = "Maintain"
   MenuOrder         = "5"
   MainMenuItem      = "0"
   FunctionMemo      = "Item Account codes"
   ScriptName        = "itmaccount"
   AccessUserGroup   = "0">  
--->                

<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Storage"
   FunctionName    = "Warehouse settings" 
   MenuClass       = "Maintain"
   MenuOrder       = "1"
   MainMenuItem    = "0"
   FunctionMemo    = "Warehouse storage settings"
   ScriptName      = "itmlevel"
   AccessUserGroup = "0">  
   
<!--- storage --->      
   
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Storage"
   FunctionName    = "Stock Level" 
   MenuClass       = "Inquiry"
   MenuOrder       = "1"
   MainMenuItem    = "0"
   FunctionMemo    = "Stock Level"
   ScriptName      = "stocklevel"
   AccessUserGroup = "0">      
   
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Storage"
   FunctionName    = "Storage Locations" 
   MenuClass       = "Maintain"
   MenuOrder       = "2"
   MainMenuItem    = "0"
   FunctionMemo    = "Item storage locations"
   ScriptName      = "itmloc"
   AccessUserGroup = "0">   
   
   
<!--- acquisition --->   
   
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Acquisition"
   FunctionName    = "Vendor quotes" 
   MenuClass       = "Maintain"
   MenuOrder       = "3"
   MainMenuItem    = "0"
   FunctionMemo    = "Vendor quotes"
   ScriptName      = "itmvendor"
   AccessUserGroup = "0"> 
   
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Acquisition"
   FunctionName    = "Resupply Request" 
   MenuClass       = "Inquiry"
   MenuOrder       = "2"
   MainMenuItem    = "0"
   FunctionMemo    = "Resupply Request"
   ScriptName      = "itmonorder"
   AccessUserGroup = "0">     
             
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Acquisition"
   FunctionName    = "Receipts" 
   MenuClass       = "Inquiry"
   MenuOrder       = "3"
   MainMenuItem    = "0"
   FunctionMemo    = "Receipts"
   ScriptName      = "itmreceipt"
   AccessUserGroup = "0"> 
   
<!--- sales and distribution --->                        
   
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Distribution"
   FunctionName    = "Sales price" 
   MenuClass       = "Maintain"
   MenuOrder       = "4"
   MainMenuItem    = "0"
   FunctionMemo    = "Item Pricing"
   ScriptName      = "itmprice"
   AccessUserGroup = "0">  
         
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Distribution"
   FunctionName    = "Transactions" 
   MenuClass       = "Inquiry"
   MenuOrder       = "4"
   MainMenuItem    = "0"
   FunctionMemo    = "Stock Transaction movements and distribution"
   ScriptName      = "itmtransaction"
   AccessUserGroup = "0">      
   
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Distribution"
   FunctionName    = "WorkOrder Allocation" 
   MenuClass       = "Inquiry"
   MenuOrder       = "5"
   MainMenuItem    = "0"
   FunctionMemo    = "WorkOrder Earmarking"
   ScriptName      = "itmworkorder"
   AccessUserGroup = "0">    
   
<!--- analysis and planning --->            
       
<cf_ModuleInsertSubmit
   SystemModule    = "Warehouse" 
   FunctionClass   = "Analysis"
   FunctionName    = "Analysis" 
   MenuClass       = "Inquiry"
   MenuOrder       = "6"
   MainMenuItem    = "0"
   FunctionMemo    = "Item analysis"
   ScriptName      = "itmstatistic"
   AccessUserGroup = "0">              
      
<!--- general maintenance --->      

<cf_ModuleInsertSubmit
   SystemModule      = "Warehouse" 
   FunctionClass     = "Maintain"
   FunctionName      = "Parameter" 
   MenuClass         = "System"
   MenuOrder         = "1"
   MainMenuItem      = "1"
   FunctionMemo      = "Warehouse and Asset Module parameters"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath      = "Parameter/ParameterEdit.cfm"   
   AccessUserGroup   = "0">     

<cf_ModuleInsertSubmit
   SystemModule      = "Warehouse" 
   FunctionClass     = "Maintain"
   FunctionName      = "Item Category" 
   MenuClass         = "System"
   MenuOrder         = "2"
   MainMenuItem      = "1"
   FunctionMemo      = "Item master Category and Ledger definition"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath      = "Category/RecordListing.cfm"   
   AccessUserGroup   = "0">     
   
<cf_ModuleInsertSubmit
   SystemModule      = "Warehouse" 
   FunctionClass     = "Maintain"
   FunctionName      = "Item master" 
   MenuClass         = "System"
   MenuOrder         = "2"
   MainMenuItem      = "1"
   FunctionMemo      = "Item Definition and UOM definition"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath      = "Item/ItemSearch.cfm"   
   AccessUserGroup   = "0">  
 
   
<cf_ModuleInsertSubmit
   SystemModule      = "Warehouse" 
   FunctionClass     = "Maintain"
   FunctionName      = "Business Rules" 
   MenuClass         = "System"
   MenuOrder         = "3"
   MainMenuItem      = "1"
   FunctionMemo      = "Business rules definition"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath      = "BusinessRule/RecordListing.cfm"   
   AccessUserGroup   = "0"> 
         
<!--- stock --->    
   
<cf_ModuleInsertSubmit
   SystemModule      = "Warehouse" 
   FunctionClass     = "Maintain"
   FunctionName      = "Warehouse" 
   MenuClass         = "Stock"
   MenuOrder         = "1"
   MainMenuItem      = "1"
   FunctionMemo      = "Warehouse Definition"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath      = "Warehouse/RecordListing.cfm"   
   AccessUserGroup   = "0">    
     
<cf_ModuleInsertSubmit
   SystemModule      = "Warehouse" 
   FunctionClass     = "Maintain"
   FunctionName      = "Commodity codes" 
   MenuClass         = "Stock"
   MenuOrder         = "2"
   MainMenuItem      = "1"
   FunctionMemo      = "Item Commodity Codes"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath      = "Commodity/RecordListing.cfm"   
   AccessUserGroup   = "0">        
     
<cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Manufacturer Production Lot" 
   MenuClass = "Stock"
   MenuOrder = "6"
   MainMenuItem = "1"
   FunctionMemo = "Maintain manufacturer Production Lot"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "ProductionLot/RecordListing.cfm"   
   AccessUserGroup = "0">       
   
<cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Warehouse" 
   MenuClass = "Stock"
   MenuOrder = "2"
   MainMenuItem = "0"
   FunctionMemo = "Main Warehouse registration"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "Warehouse/RecordListing.cfm"   
   AccessUserGroup = "0">  
   
<cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Request Type" 
   MenuClass = "Stock"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Request Types"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "RequestType/RecordListing.cfm"   
   AccessUserGroup = "0">   
  
<!--- asset --->  

<cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Object Topcs definition" 
   MenuClass = "Asset"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Asset Classification List Values"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "AssetClassification/RecordListing.cfm"   
   AccessUserGroup = "0">     
   
<cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Asset Action" 
   MenuClass = "Asset"
   MenuOrder = "3"
   MainMenuItem = "1"
   FunctionMemo = "Asset Actions and List Values"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "AssetAction/RecordListing.cfm"   
   AccessUserGroup = "0">     
   
<cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Operation events" 
   MenuClass = "Asset"
   MenuOrder = "3"
   MainMenuItem = "1"
   FunctionMemo = "Asset Operation events"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "AssetEvent/RecordListing.cfm"   
   AccessUserGroup = "0">            
   
   <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Make" 
   MenuClass = "Asset"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Asset Item Manufacturer"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "Make/RecordListing.cfm"   
   AccessUserGroup = "0">  
   
    <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Source" 
   MenuClass = "Asset"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Asset Ownership"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "Source/RecordListing.cfm"   
   AccessUserGroup = "0">  
   
   <!--- ---------------- --->
   <!--- sale maintenance --->
   <!--- ---------------- --->
   
     <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Settlement" 
   MenuClass = "Sale"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Tender Option : Cash, Credit"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "Settlement/RecordListing.cfm"   
   AccessUserGroup = "0"> 
   
      <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Image class" 
   MenuClass = "Sale"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Maintain image classes"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "ImageClass/RecordListing.cfm"   
   AccessUserGroup = "0"> 
   
      <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Pricing Schedules" 
   MenuClass = "Sale"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Sales Pricing Schedules"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "PriceSchedule/RecordListing.cfm"   
   AccessUserGroup = "0">
   
     <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Discount Types" 
   MenuClass = "Sale"
   MenuOrder = "3"
   MainMenuItem = "1"
   FunctionMemo = "Discount Types"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "DiscountType/RecordListing.cfm"   
   AccessUserGroup = "0">
   	    
     <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Promotions" 
   MenuClass = "Sale"
   MenuOrder = "4"
   MainMenuItem = "1"
   FunctionMemo = "Sales Promotions"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "Promotion/RecordListing.cfm"   
   AccessUserGroup = "0">  
  	  
   <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Disposal Method" 
   MenuClass = "Asset"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Asset Disposal Method"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "Disposal/RecordListing.cfm"   
   AccessUserGroup = "0">   
   
     <cf_ModuleInsertSubmit
   SystemModule      = "Warehouse" 
   FunctionClass     = "Maintain"
   FunctionName      = "Type of Maintenance" 
   MenuClass         = "Asset"
   MenuOrder         = "5"
   MainMenuItem      = "1"
   FunctionMemo      = "Maintainance Classes"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath      = "Maintain/RecordListing.cfm"   
   AccessUserGroup   = "0">   
      
   <cf_ModuleInsertSubmit
   SystemModule      = "Warehouse" 
   FunctionClass     = "Maintain"
   FunctionName      = "Depreciation Schedule" 
   MenuClass         = "Asset"
   MenuOrder         = "4"
   MainMenuItem      = "1"
   FunctionMemo      = "Asset Depreciation Schedules"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath      = "Scale/RecordListing.cfm"   
   AccessUserGroup   = "0">   
   
<!--- reference lookup --->  
       
<cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Asset Location Class" 
   MenuClass = "Lookup"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Type of Location"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "LocationClass/RecordListing.cfm"   
   AccessUserGroup = "0">      
    
<cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Stock Storage Class" 
   MenuClass = "Lookup"
   MenuOrder = "3"
   MainMenuItem = "1"
   FunctionMemo = "Type of Storage for items"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "StockStorageClass/RecordListing.cfm"   
   AccessUserGroup = "0">

<cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Metric" 
   MenuClass = "Lookup"
   MenuOrder = "4"
   MainMenuItem = "1"
   FunctionMemo = "Metrics"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "Metric/RecordListing.cfm"   
   AccessUserGroup = "0">
   

<cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Facility Batch Class" 
   MenuClass = "Lookup"
   MenuOrder = "5"
   MainMenuItem = "1"
   FunctionMemo = "Batch Class"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "BatchClass/RecordListing.cfm"   
   AccessUserGroup = "0">   
   
<cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "UoM" 
   MenuClass = "Lookup"
   MenuOrder = "5"
   MainMenuItem = "1"
   FunctionMemo = "Maintain UoM master lookup"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "UoM/RecordListing.cfm"   
   AccessUserGroup = "0">   
     
<cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Address type" 
   MenuClass = "Lookup"
   MenuOrder = "5"
   MainMenuItem = "1"
   FunctionMemo = "Define different types of Addresses"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "AddressType/RecordListing.cfm"   
   AccessUserGroup = "0">     
   
<cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Mode of shipment" 
   MenuClass = "Lookup"
   MenuOrder = "5"
   MainMenuItem = "1"
   FunctionMemo = "Mode of shipment settings"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "ShipToMode/RecordListing.cfm"   
   AccessUserGroup = "0">  
 
 <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Loss Class" 
   MenuClass = "Lookup"
   MenuOrder = "5"
   MainMenuItem = "1"
   FunctionMemo = "Loss Class Maintenance"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "LossClass/RecordListing.cfm"   
   AccessUserGroup = "0">             
   
 <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Task Order Class" 
   MenuClass = "Lookup"
   MenuOrder = "6"
   MainMenuItem = "1"
   FunctionMemo = "Task Order Class Maintenance"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "TaskOrderClass/RecordListing.cfm"   
   AccessUserGroup = "0">  
      
 <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Task Order Type" 
   MenuClass = "Lookup"
   MenuOrder = "7"
   MainMenuItem = "1"
   FunctionMemo = "Task Order Type Maintenance"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "TaskOrderType/RecordListing.cfm"   
   AccessUserGroup = "0">  
   
 <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Task Order Action" 
   MenuClass = "Lookup"
   MenuOrder = "7"
   MainMenuItem = "1"
   FunctionMemo = "Task Order Action Maintenance"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "TaskOrderAction/RecordListing.cfm"   
   AccessUserGroup = "0">  
  
 <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Area GLedger" 
   MenuClass = "Lookup"
   MenuOrder = "8"
   MainMenuItem = "1"
   FunctionMemo = "Area GLedger Maintenance"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "AreaGLedger/RecordListing.cfm"   
   AccessUserGroup = "0">
   
 <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Transaction Class" 
   MenuClass = "Lookup"
   MenuOrder = "9"
   MainMenuItem = "1"
   FunctionMemo = "Transaction Class Maintenance"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "TransactionClass/RecordListing.cfm"   
   AccessUserGroup = "0">
   
 <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Transaction Type" 
   MenuClass = "Lookup"
   MenuOrder = "10"
   MainMenuItem = "1"
   FunctionMemo = "Transaction Type Maintenance"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "TransactionType/RecordListing.cfm"   
   AccessUserGroup = "0">  
   
  
 <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Warehouse Classes" 
   MenuClass = "Lookup"
   MenuOrder = "11"
   MainMenuItem = "1"
   FunctionMemo = "Warehouse / Facility classes"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "WarehouseClass/RecordListing.cfm"   
   AccessUserGroup = "0">     

 <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Facility Regions" 
   MenuClass = "Lookup"
   MenuOrder = "12"
   MainMenuItem = "1"
   FunctionMemo = "Facility Regions by Entity"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "City/RecordListing.cfm"   
   AccessUserGroup = "0">
   
 <cf_ModuleInsertSubmit
   SystemModule="Warehouse" 
   FunctionClass = "Maintain"
   FunctionName = "Stock Class" 
   MenuClass = "Lookup"
   MenuOrder = "13"
   MainMenuItem = "1"
   FunctionMemo = "Stock Classes"
   FunctionDirectory = "Warehouse/Maintenance"
   FunctionPath = "StockClass/RecordListing.cfm"   
   AccessUserGroup = "0">