
<!--- status --->

<cf_insertStatus  Class="Header"   Status="0"  ListingOrder="0" Description="Draft"            Description2="Draft">
<cf_insertStatus  Class="Header"   Status="1"  ListingOrder="2" Description="Submitted"        Description2="Submitted">
<cf_insertStatus  Class="Header"   Status="2"  ListingOrder="3" Description="Approved"         Description2="Approved">
<!---
<cf_insertStatus  Class="Header"   Status="2p" ListingOrder="4" Description="Partially Tasked" Description2="Partially Tasked">
--->
<cf_insertStatus  Class="Header"   Status="3"  ListingOrder="5" Description="Tasked"           Description2="Tasked">
<cf_insertStatus  Class="Header"   Status="8"  ListingOrder="6" Description="Rejected"         Description2="Rejected">
<cf_insertStatus  Class="Header"   Status="9"  ListingOrder="7" Description="Cancelled"        Description2="Cancelled">

<cf_insertAction  Code="Consolidated"  Description="Request Consolidated">
<cf_insertAction  Code="Monitor"       Description="Customer Monitor">
<cf_insertAction  Code="Moved"         Description="Request Moved">
<cf_insertAction  Code="Picked"        Description="Request Picked">
<cf_insertAction  Code="Collection"    Description="Request to be collected">
<cf_insertAction  Code="Deny"          Description="Batch deny">
<cf_insertAction  Code="Clear"         Description="Batch clear">
<cf_insertAction  Code="Reinstate"     Description="Batch Reinstate">
<cf_insertAction  Code="Send"          Description="Send quote">
<cf_insertAction  Code="SalesPerson"   Description="Set Sale person">
<cf_insertAction  Code="Amend"         Description="Amend transaction">

<cf_insertStatus  Class="Request"  Status="1"  ListingOrder="2" Description="Cleared"          Description2="Pending Approval">
<cf_insertStatus  Class="Request"  Status="2"  ListingOrder="3" Description="Approved"         Description2="Pending Picking">
<cf_insertStatus  Class="Request"  Status="2b" ListingOrder="4" Description="On Back Order"    Description2="On Back order">
<cf_insertStatus  Class="Request"  Status="3"  ListingOrder="5" Description="Shipped"          Description2="Shipped">
<cf_insertStatus  Class="Request"  Status="i"  ListingOrder="1" Description="Submitted"        Description2="Pending Clearance">
<cf_insertStatus  Class="Request"  Status="0"  ListingOrder="6" Description="Cancelled"        Description2="Cancelled">

<cf_insertStatus  Class="TaskOrder"  Status="0"  ListingOrder="0" Description="Pending"        Description2="Pending">
<cf_insertStatus  Class="TaskOrder"  Status="1"  ListingOrder="1" Description="Partial"        Description2="Partial">
<cf_insertStatus  Class="TaskOrder"  Status="3"  ListingOrder="3" Description="Completed"      Description2="Completed">
<cf_insertStatus  Class="TaskOrder"  Status="9"  ListingOrder="9" Description="Cancelled"      Description2="Cancelled">

<cf_insertStatus  Class="TaskLine"   Status="1"  ListingOrder="1" Description="Active"         Description2="Active">
<cf_insertStatus  Class="TaskLine"   Status="3"  ListingOrder="3" Description="Completed"      Description2="Completed">
<cf_insertStatus  Class="TaskLine"   Status="9"  ListingOrder="9" Description="Cancelled"      Description2="Cancelled">

<cf_insertStatus  Class="Shipment" Status="0"  ListingOrder="1" Description="Pending Shipping" Description2="Pending Shipping">
<cf_insertStatus  Class="Shipment" Status="1"  ListingOrder="2" Description="Pending Delivery" Description2="On it ways">
<cf_insertStatus  Class="Shipment" Status="2"  ListingOrder="3" Description="Received" Description2="Received and confirmed">
<cf_insertStatus  Class="Shipment" Status="9"  ListingOrder="4" Description="Returned" Description2="Returned">

<cf_insertAreaGLedger Area="Stock"          AccountClass="Balance" Description="Stock On Hand"        Order="1">
<cf_insertAreaGLedger Area="Receipt"        AccountClass="Balance" Description="Goods to be paid AP"  Order="2">
<cf_insertAreaGLedger Area="Shipped"        AccountClass="Balance" Description="Goods in Transit AR"  Order="3">

<cf_insertAreaGLedger Area="InitialStock"   AccountClass="Result"  Description="Initial Stock"        Order="4">
<cf_insertAreaGLedger Area="Production"     AccountClass="Result"  Description="Manufacturing"        Order="5">
<cf_insertAreaGLedger Area="Sales"          AccountClass="Result"  Description="Income from sales"    Order="6">
<cf_insertAreaGLedger Area="COGS"           AccountClass="Result"  Description="Cost of Goods Sold"   Order="7">
<cf_insertAreaGLedger Area="Depreciation"   AccountClass="Result"  Description="Asset Depreciation"   Order="8">
<cf_insertAreaGLedger Area="WriteOff"       AccountClass="Result"  Description="WriteOff"             Order="9">
<cf_insertAreaGLedger Area="Variance"       AccountClass="Result"  Description="Variances"            Order="10">
<cf_insertAreaGLedger Area="PriceChange"    AccountClass="Result"  Description="Standard Cost Change" Order="11">
<cf_insertAreaGLedger Area="Provision"      AccountClass="Balance" Description="Service Provision"    Order="12">
<cf_insertAreaGLedger Area="Interoffice"    AccountClass="Balance" Description="Interoffice AP IN"    Order="13">
<cf_insertAreaGLedger Area="InterOut"       AccountClass="Balance" Description="Interoffice AR OUT"   Order="14">

<cf_insertRequirementMode  Code="Active"   Description="Active">
<cf_insertRequirementMode  Code="Blocked"  Description="Blocked">

<cf_insertSettlement  Code="Cash"   Description="Cash">
<cf_insertSettlement  Code="Credit" Description="Credit Card">
<cf_insertSettlement  Code="Check"  Description="Bank Check">
<cf_insertSettlement  Code="Gift"   Description="Gift Card">

<cf_insertTransactionClass  TransactionClass="Receipt"      ListingOrder="1" QuantityNegative="0">
<cf_insertTransactionClass  TransactionClass="Distribution" ListingOrder="2" QuantityNegative="1">
<cf_insertTransactionClass  TransactionClass="Variance"     ListingOrder="3" QuantityNegative="0" >
<cf_insertTransactionClass  TransactionClass="Transfer"     ListingOrder="4" QuantityNegative="0">

<cf_insertTransactionType  TransactionType="0" Description="Production"        Area="Receipt"      TransactionClass="Receipt">
<cf_insertTransactionType  TransactionType="1" Description="Receipt"           Area="Receipt"      TransactionClass="Receipt">
<cf_insertTransactionType  TransactionType="2" Description="Distribution"      Area="COGS"         TransactionClass="Distribution">
<cf_insertTransactionType  TransactionType="3" Description="Return"            Area="WriteOff"     TransactionClass="Variance">
<cf_insertTransactionType  TransactionType="4" Description="Disposal"          Area="WriteOff"     TransactionClass="Variance">
<cf_insertTransactionType  TransactionType="5" Description="Inventory"         Area="Variance"     TransactionClass="Variance">
<cf_insertTransactionType  TransactionType="6" Description="Conversion"        Area="Variance"     TransactionClass="Transfer">
<cf_insertTransactionType  TransactionType="7" Description="Bill of materials" Area="COGS"         TransactionClass="Distribution">
<cf_insertTransactionType  TransactionType="8" Description="Transfer"          Area="Variance"     TransactionClass="Transfer">
<cf_insertTransactionType  TransactionType="9" Description="Initial Stock"     Area="InitialStock" TransactionClass="Receipt">

<!--- others for initial stock --->
<cf_insertBatchClass  Code="RctDistr"      Description="Receipt and Inspection handling">
<cf_insertBatchClass  Code="WhsInitial"    Description="Warehouse Initial Stock">
<cf_insertBatchClass  Code="WhsDispose"    Description="Warehouse Disposal">
<cf_insertBatchClass  Code="WhsSale"       Description="Warehouse Sale">
<cf_insertBatchClass  Code="WhsTrSale"     Description="Warehouse Sale Transfer">
<cf_insertBatchClass  Code="WhsIssue"      Description="Warehouse Stock Issuance">
<cf_insertBatchClass  Code="WhsShip"       Description="Warehouse Stock Shipment">
<cf_insertBatchClass  Code="WhsTrans"      Description="Warehouse Stock Transfer">
<cf_insertBatchClass  Code="WhsInvent"     Description="Warehouse Stock Inventory">
<cf_insertBatchClass  Code="WOShip"        Description="WorkOrder Stock Shipment">
<cf_insertBatchClass  Code="WOEarmark"     Description="WorkOrder Stock Earmarking">
<cf_insertBatchClass  Code="WOCollect"     Description="WorkOrder Stock BOM Collection">
<cf_insertBatchClass  Code="WOReturn"      Description="WorkOrder Stock Return">
<cf_insertBatchClass  Code="Production"    Description="WorkOrder Stock Production">
<cf_insertBatchClass  Code="WOMedical"     Description="Medical Stock Issuance">
<cf_insertBatchClass  Code="Quote"         Description="Standard Quote">
<cf_insertBatchClass  Code="QteReserve"    Description="Quote Reservation">

<cf_insertRequestType  Code="Pickticket"   Description="Pickticket Request">
<cf_insertRequestType  Code="TaskOrder"    Description="TaskOrder Request">
<cf_insertRequestType  Code="Warehouse"    Description="Warehouse Request">

<cf_insertValuation  Code="Average"        Operational="0"   Description="Average">
<cf_insertValuation  Code="FIFO"           Operational="1"   Description="First In, First Out (FIFO)">
<cf_insertValuation  Code="LIFO"           Operational="1"   Description="Last In, First Out (LIFO)">
<cf_insertValuation  Code="Last"           Operational="0"   Description="Last Purchase Price">
<cf_insertValuation  Code="Manual"         Operational="1"   Description="Standard Cost Price">

<cf_insertAssetAction Code="Condition"     Description="Item Condition">
<cf_insertAssetAction Code="Inventory"     Description="Inventory Check">
<cf_insertAssetAction Code="Operations"    Description="Operations Log">

<cf_insertItemClass Code="Asset"           Description="Serialised Item">
<cf_insertItemClass Code="Supply"          Description="Inventoried Item">
<cf_insertItemClass Code="Service"         Description="Service item">
<cf_insertItemClass Code="Other"           Description="Non-Inventoried Item">

<cf_insertDisposal  Code="1"               Description="Donation">
<cf_insertDisposal  Code="2"               Description="Sales">

<cf_insertShipToMode  Code="deliver" Description="Delivery" ListingOrder="1">
<cf_insertShipToMode  Code="collect" Description="Collection" ListingOrder="2">

<cf_insertPriceSchedule  Code="1" Description="Price schedule 1">
<cf_insertPriceSchedule  Code="2" Description="Price schedule 2">
<cf_insertPriceSchedule  Code="3" Description="Price schedule 3">
<cf_insertPriceSchedule  Code="4" Description="Price schedule 3">
<cf_insertPriceSchedule  Code="5" Description="Price schedule 3">



