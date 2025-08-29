<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cf_ModuleInsertSubmit
   SystemModule="TravelClaim" 
   FunctionClass = "Application"
   FunctionName = "Export Claim" 
   MenuClass = "Main"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Prepare Claim Export File"
   FunctionDirectory = "TravelClaim/Application/"
   FunctionPath = "Process/Export/ExportList.cfm"
   FunctionIcon = "Process">  

 <cf_ModuleInsertSubmit
   SystemModule="TravelClaim" 
   FunctionClass = "Application"
   FunctionName = "Inquiry" 
   MenuClass = "Main"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Locate and List Travel Claims"
   FunctionDirectory = "TravelClaim/Application/"
   FunctionPath = "Inquiry/ClaimView.cfm"
   FunctionIcon = "Process">    
   
<!--- mainteance --->

<cf_ModuleInsertSubmit
   SystemModule="TravelClaim" 
   FunctionClass = "Maintain"
   FunctionName = "General Parameters and Settings" 
   MenuClass = "Main"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Edit Travel Claim Parameters"
   FunctionDirectory = "TravelClaim/Maintenance/"
   FunctionPath = "Parameter/ParameterEdit.cfm"
   FunctionIcon = "Maintain">                  

<cf_ModuleInsertSubmit
   SystemModule="TravelClaim" 
   FunctionClass = "Maintain"
   FunctionName = "Validation Rules" 
   MenuClass = "Main"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Manage Travel claim validation rules and thresholds"
   FunctionDirectory = "TravelClaim/Maintenance/"
   FunctionPath = "ClaimRules/RecordListing.cfm"
   FunctionIcon = "Maintain"> 
   
<cf_ModuleInsertSubmit
   SystemModule="TravelClaim" 
   FunctionClass = "Maintain"
   FunctionName = "Claim Indicators" 
   MenuClass = "Main"
   MenuOrder = "3"
   MainMenuItem = "1"
   FunctionMemo = "Manage claim indicators and pointers"
   FunctionDirectory = "TravelClaim/Maintenance/"
   FunctionPath = "ClaimIndicator/RecordListing.cfm"
   FunctionIcon = "Maintain">      
   
<cf_ModuleInsertSubmit
   SystemModule="TravelClaim" 
   FunctionClass = "Maintain"
   FunctionName = "Executive Offices" 
   MenuClass = "Main"
   MenuOrder = "3"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Executive Office and Travel Request Association"
   FunctionDirectory = "TravelClaim/Maintenance/"
   FunctionPath = "RequestUnit/RecordListing.cfm"
   FunctionIcon = "Maintain">         
    
<cf_ModuleInsertSubmit
   SystemModule="TravelClaim" 
   FunctionClass = "Maintain"
   FunctionName = "Reimbursement Rates" 
   MenuClass = "Main"
   MenuOrder = "4"
   MainMenuItem = "1"
   FunctionMemo = "Review and Maintain TRM Rates"
   FunctionDirectory = "TravelClaim/Maintenance/"
   FunctionPath = "ClaimRate/RecordListing.cfm"
   FunctionIcon = "Maintain">   
    
<cf_ModuleInsertSubmit
   SystemModule="TravelClaim" 
   FunctionClass = "Maintain"
   FunctionName = "Fund Status" 
   MenuClass = "Main"
   MenuOrder = "5"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Fund upload status"
   FunctionDirectory = "TravelClaim/Maintenance/"
   FunctionPath = "FundValidation/RecordListing.cfm"
   FunctionIcon = "Maintain">       
      
<cf_ModuleInsertSubmit
   SystemModule="TravelClaim" 
   FunctionClass = "Maintain"
   FunctionName = "City" 
   MenuClass = "Main"
   MenuOrder = "6"
   MainMenuItem = "1"
   FunctionMemo = "Maintain association of Cities with valid DSA locations"
   FunctionDirectory = "TravelClaim/Maintenance/"
   FunctionPath = "City/RecordSearch.cfm"
   FunctionIcon = "Maintain">  
   
      
   
<!--- reference --->                            
   
<cf_ModuleInsertSubmit
   SystemModule="TravelClaim" 
   FunctionClass = "Reference"
   FunctionName = "Service location" 
   MenuClass = "Main"
   MenuOrder = "11"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Service Locations"
   FunctionDirectory = "TravelClaim/Maintenance/"
   FunctionPath = "Location/RecordListing.cfm"
   FunctionIcon = "Maintain">      
    
<cf_ModuleInsertSubmit
   SystemModule="TravelClaim" 
   FunctionClass = "Reference"
   FunctionName = "Payment mode" 
   MenuClass = "Main"
   MenuOrder = "12"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Payment Modes"
   FunctionDirectory = "TravelClaim/Maintenance/"
   FunctionPath = "PaymentMode/RecordListing.cfm"
   FunctionIcon = "Maintain">  
   
<cf_ModuleInsertSubmit
   SystemModule="TravelClaim" 
   FunctionClass = "Reference"
   FunctionName = "Claim Category" 
   MenuClass = "Main"
   MenuOrder = "13"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Claim Categories"
   FunctionDirectory = "TravelClaim/Maintenance/"
   FunctionPath = "ClaimCategory/RecordListing.cfm"
   FunctionIcon = "Maintain">     

<cf_ModuleInsertSubmit
   SystemModule="TravelClaim" 
   FunctionClass = "Reference"
   FunctionName = "Travel Purpose" 
   MenuClass = "Main"
   MenuOrder = "14"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Travel Purpose"
   FunctionDirectory = "TravelClaim/Maintenance/"
   FunctionPath = "ClaimPurpose/RecordListing.cfm"
   FunctionIcon = "Maintain">     
   
<cf_ModuleInsertSubmit
   SystemModule="TravelClaim" 
   FunctionClass = "Reference"
   FunctionName = "Travel Events" 
   MenuClass = "Main"
   MenuOrder = "15"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Travel Events"
   FunctionDirectory = "TravelClaim/Maintenance/"
   FunctionPath = "ClaimEvent/RecordListing.cfm"
   FunctionIcon = "Maintain">        

<cf_ModuleInsertSubmit
   SystemModule="TravelClaim" 
   FunctionClass = "Reference"
   FunctionName = "Claimant class" 
   MenuClass = "Main"
   MenuOrder = "16"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Claimant classes"
   FunctionDirectory = "TravelClaim/Maintenance/"
   FunctionPath = "Claimant/RecordListing.cfm"
   FunctionIcon = "Maintain">    
   

<cf_ModuleInsertSubmit
   SystemModule="TravelClaim" 
   FunctionClass = "Reference"
   FunctionName = "Currency" 
   MenuClass = "Main"
   MenuOrder = "17"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Currencies"
   FunctionDirectory = "Gledger/Maintenance/"
   FunctionPath = "Currency/RecordListing.cfm"
   FunctionIcon = "Maintain">      
                         
        