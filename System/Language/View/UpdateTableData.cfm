<!--
    Copyright © 2025 Promisan

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

<!--- -------------------- --->
<!--- -----SYSTEM--------- --->
<!--- -------------------- --->
  
<cfquery name="Delete" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM LanguageSource
</cfquery>

<!--- system tables are meant as interface / label tables --->

<cfinvoke component="UpdateTable" method="table"
      TableCode      = "Ref_Nation"
      SystemModule   = "System"
      DataSource     = "AppsSystem" 
      KeyFieldName   = "Code"
      InterfaceTable = "1"
      Fields         = "Name,Nationality,Continent">    
	  
<cfinvoke component  = "UpdateTable"  method="table" 
	  TableCode      = "TopicNation" 
	  TableName      = "Ref_Topic"
	  SystemModule   = "Warehouse"  
      DataSource     = "AppsSystem"  
      KeyFieldName   = "Code" 
	  Fields         = "TopicLabel,Description,Tooltip">	
			  
<cfinvoke component  = "UpdateTable" method="table" 
	  TableCode      = "TopicNationList" 
	  TableName      = "Ref_TopicList"
	  SystemModule   = "Warehouse"  
      DataSource     = "AppsSystem"  
      KeyFieldName   = "Code" 
	  KeyFieldName2  = "ListCode"
	  Fields         = "ListValue">			
	   	  
  	  
	  
	  

<cfinvoke component="UpdateTable" method="table"
      TableCode      = "Ref_Application"
      SystemModule   = "System"
      DataSource     = "AppsSystem" 
      KeyFieldName   = "Code"
      InterfaceTable = "1"
      Fields         = "Description">     
	  				  
<cfinvoke component  = "UpdateTable" method="table" 
	  TableCode      = "Ref_SystemModule" 
	  SystemModule   = "System"
      DataSource     = "AppsSystem"  
	  InterfaceTable = "1" 
	  KeyFieldName   = "SystemModule"	 
	  Fields         = "Description, Hint">
	  	  	 		  	
<cfinvoke component="UpdateTable" method="table" 
	  TableCode      = "Ref_ModuleControl" 
	  SystemModule   = "System"
      DataSource     = "AppsSystem"  
      KeyFieldName   = "SystemFunctionId"
	  KeyFieldName2  = "Mission"
	  InterfaceTable = "1"
	  Fields         = "FunctionName,FunctionMemo">		  
	  
<!--- NEW management info listing  added 22/8/2011 --->

<cfinvoke component="UpdateTable" method="table" 
	  TableCode      = "Ref_ModuleControlSection" 
	  SystemModule   = "System"
      DataSource     = "AppsSystem"  
	  InterfaceTable = "1"
	  KeyFieldName   = "SystemFunctionId"
	  KeyFieldName2  = "FunctionSection"     
	  Fields         = "SectionName">	  
  
<cfinvoke component="UpdateTable" method="table" 
	  TableCode      = "Ref_ModuleControlSectionCell" 
	  SystemModule   = "System"
      DataSource     = "AppsSystem"  
	  InterfaceTable = "1"
	  KeyFieldName   = "SystemFunctionId"
	  KeyFieldName2  = "FunctionSection"   
	  KeyFieldName3  = "CellCode"       
	  Fields         = "CellLabel">	  	
	  
<!--- -------------------------- --->
<!--- -----ORGANIZATION--------- --->
<!--- -------------------------- --->	   	  

<cfinvoke component="UpdateTable" method="table" 
	  TableCode="Ref_EntityClass" 
	  SystemModule="System"
      DataSource="AppsOrganization"  
      KeyFieldName="EntityCode"
	  KeyFieldName2="EntityClass"
	  Fields="EntityClassName">

<cfinvoke component="UpdateTable" method="table" 
	  TableCode="Ref_EntityAction" 
	  SystemModule="System"
      DataSource="AppsOrganization"  
      KeyFieldName="ActionCode"
	  Fields="ActionDescription">
	
<cfinvoke component="UpdateTable" method="table" 
	  TableCode="Questionaire" 
	  SystemModule="System"
      DataSource="AppsOrganization"  
	  TableName="Ref_EntityDocumentQuestion"
      KeyFieldName="QuestionId"
	  Fields="QuestionLabel,QuestionMemo">
	 	  
<cfinvoke component="UpdateTable" method="table" 
	  TableCode      = "Ref_EntityDocument" 
	  SystemModule   = "System"
      DataSource     = "AppsOrganization"  
      KeyFieldName   = "DocumentId"
	  Fields         ="DocumentDescription">
 
<cfinvoke component="UpdateTable" method="table" 
	  TableCode     = "Organization" 
	  SystemModule  = "System"
      DataSource    = "AppsOrganization"  
      KeyFieldName  = "OrgUnit"
	  Fields        = "OrgUnitName,OrgUnitNameShort,Remarks">
	  
<cfinvoke component="UpdateTable" method="table" 
	  TableCode     = "MissionProfile" 
	  SystemModule  = "System"
      DataSource    = "AppsOrganization"  
      KeyFieldName  = "ProfileId"
	  Fields        = "FunctionName">	  
	  
<cfinvoke component="UpdateTable" method="table" 
	  TableCode="Ref_EntityClassAction" 
	  SystemModule="System"
      DataSource="AppsOrganization"  
      KeyFieldName="EntityCode"
	  KeyFieldName2="EntityClass"
	  KeyFieldName3="ActionCode"
	  Fields="ActionDescription,ActionProcess,ActionCompleted,ActionDenied,ActionReference,ActionGoToLabel">
	  
<cfinvoke component="UpdateTable" method="table" 
	  TableCode="Ref_EntityActionPublish" 
	  SystemModule="System"
      DataSource="AppsOrganization"  
      KeyFieldName="ActionPublishNo"	
	  KeyFieldName2="ActionCode"
	  Fields="ActionDescription,ActionProcess,ActionCompleted,ActionDenied,ActionReference,ActionGoToLabel">	  
		
	  
<cf_verifyOperational module="Program">	  

<cfif ModuleEnabled eq "1">
	
	<!--- -------------------program------------- --->		  
		  
	<cfinvoke component="UpdateTable"  method="table" 
		  TableCode="Program" 
		  SystemModule="Program"
	      DataSource="AppsProgram"  
	      KeyFieldName="ProgramCode"
		  Fields="ProgramName">	
		  
	<cfinvoke component="UpdateTable"  method="table" 
		  TableCode="ProgramPeriod" 
		  SystemModule="Program"
	      DataSource="AppsProgram"  
	      KeyFieldName="ProgramCode" KeyFieldName2="Period"
		  Fields="PeriodProblem,PeriodDescription,PeriodGoal,PeriodObjective">		
		  
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="ProgramTarget" 
		  SystemModule="Program"
		  DataSource="AppsProgram"  
	      KeyFieldName="TargetId"
		  Fields="TargetDescription,TargetIndicator,Outcome">			    
		
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="ProgramActivity" 
		  SystemModule="Program"
		  DataSource="AppsProgram"  
	      KeyFieldName="ProgramCode" KeyFieldName2="ActivityPeriod" KeyFieldName3="ActivityId"
		  Fields="ActivityDescription">		
		  
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="ProgramActivityOutput" 
		  SystemModule="Program"
	      DataSource="AppsProgram"  
	      KeyFieldName="ProgramCode" KeyFieldName2="ActivityPeriod" KeyFieldName3="OutputId"
		  Fields="ActivityOutput">
			
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="ProgramActivityProgress" 
		  SystemModule="Program"
	      DataSource="AppsProgram"  
	      KeyFieldName="ProgramCode" KeyFieldName2="ActivityPeriod" KeyFieldName3="ProgressId"
		  Fields="ProgressMemo">
		  
	<cfinvoke component="UpdateTable"  method="table" 
		  TableCode="TopicProgram" 
		  TableName="Ref_Topic"
		  SystemModule="Program"  
	      DataSource="AppsProgram"  
	      KeyFieldName="Code" 
		  Fields="TopicLabel,Description,Tooltip">		    	  
					  
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="TopicProgramList" 
		  TableName="Ref_TopicList"
		  SystemModule="Program"  
	      DataSource="AppsProgram"  
	      KeyFieldName="Code" KeyFieldName2="ListCode"
		  Fields="ListValue">				 
		  		
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="Ref_Indicator" 
		  SystemModule="Program" 
	      DataSource="AppsProgram"  
	      KeyFieldName="IndicatorCode"
		  Fields="IndicatorDescription">	    	    
		  	
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="Ref_Object"
		  SystemModule="Program"  
	      DataSource="AppsProgram"  
	      KeyFieldName="Code">	    	    
		  	
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="Ref_Resource" 
		  SystemModule="Program" 
	      DataSource="AppsProgram"  
	      KeyFieldName="Code">	
	  
</cfif>


<cf_verifyOperational module="Procurement">	  

<cfif ModuleEnabled eq "1">	  
		  
	<!--- Items --->	 
		
	<cfinvoke component="UpdateTable" method="table" 
	  TableCode="StatusProcurement" 
	  TableName="Status"
	  SystemModule="Procurement"
      DataSource="AppsPurchase"  
      KeyFieldName="StatusClass"
	  KeyFieldName2="Status"
	  Fields="Description">	 
			
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="ItemMaster" 
		  SystemModule="Procurement" 
	      DataSource="AppsPurchase"  
	      KeyFieldName="Code"
		  Fields="Description">		 

	<cfinvoke component="UpdateTable"  method="table" 
			  TableCode="TopicPurchase" 
			  TableName="Ref_Topic"
			  SystemModule="Procurement"  
		      DataSource="AppsPurchase"  
		      KeyFieldName="Code" 
			  Fields="TopicLabel,Description,Tooltip">	
			  
	<cfinvoke component="UpdateTable" method="table" 
			  TableCode="TopicPurchaseList" 
			  TableName="Ref_TopicList"
			  SystemModule="Procurement"  
		      DataSource="AppsPurchase"  
		      KeyFieldName="Code" KeyFieldName2="ListCode"
			  Fields="ListValue">				  		  
			  
			  
		  
</cfif>	  

<cf_verifyOperational module="Warehouse">	  

<cfif ModuleEnabled eq "1">	  
		  
	<!--- Items --->	  
			
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="Item" 
		  SystemModule="Warehouse" 
	      DataSource="AppsMaterials"  
	      KeyFieldName="ItemNo"
		  Fields="ItemDescription">		
		  
	<!--- Category --->	  
			
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="Ref_Category" 
		  SystemModule="Warehouse" 
	      DataSource="AppsMaterials"  
	      KeyFieldName="Category"
		  Fields="Description">			
		  
	<!--- CategoryItem (sub category)--->
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="Ref_CategoryItem" 
		  SystemModule="Warehouse" 
	      DataSource="AppsMaterials"  
	      KeyFieldName="Category" KeyFieldName2="CategoryItem"
		  Fields="CategoryItemName">		
		  
	<!--- Commodity --->	  
			
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="Ref_Commodity" 
		  SystemModule="Warehouse" 
	      DataSource="AppsMaterials"  
	      KeyFieldName="CommodityCode"
		  Fields="Description">				
		  
	<cfinvoke component="UpdateTable"  method="table" 
			  TableCode="TopicWarehouse" 
			  TableName="Ref_Topic"
			  SystemModule="Warehouse"  
		      DataSource="AppsMaterials"  
		      KeyFieldName="Code" 
			  Fields="TopicLabel,Description,Tooltip">	
			  
	<cfinvoke component="UpdateTable" method="table" 
			  TableCode="TopicWarehouseList" 
			  TableName="Ref_TopicList"
			  SystemModule="Warehouse"  
		      DataSource="AppsMaterials"  
		      KeyFieldName="Code" KeyFieldName2="ListCode"
			  Fields="ListValue">				 	      
	  
</cfif>	 


<cf_verifyOperational module="Payroll">	  

<cfif ModuleEnabled eq "1">	  
		  
	<!--- Payroll --->	  
			
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="Ref_PayrollItem" 
		  SystemModule="Payroll" 
	      DataSource="AppsPayroll"  
	      KeyFieldName="PayrollItem"
		  Fields="PayrollItemName,PrintDescription,PrintDescriptionLong">		
	  
</cfif>	   


<cf_verifyOperational module="ePas">	  

<cfif ModuleEnabled eq "1">	  
		  
	<!--- EPas --->	  
			
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="Ref_ContractSection" 
		  SystemModule="EPas" 
	      DataSource="AppsEPas"  
	      KeyFieldName="Code"
		  Fields="Description,Instruction">		
	  
</cfif>	  
	  
<cf_verifyOperational module="TravelClaim">	  

<cfif ModuleEnabled eq "1">	  
		<!--- travel claim --->	  
			
		<cfinvoke component="UpdateTable" method="table" 
			  TableCode="Ref_ClaimSection" 
			  SystemModule="TravelClaim" 
		      DataSource="AppsTravelClaim"  
		      KeyFieldName="Code"
			  Fields="Description,Instruction">	  	  	
	  
</cfif>	    

<!--- case file --->

<cf_verifyOperational module="Insurance">	 

<cfif ModuleEnabled eq "1">	 
	
	<cfinvoke component="UpdateTable"  method="table" 
			  TableCode="TopicInsurance" 
			  TableName="Ref_Topic"
			  SystemModule="Insurance"  
		      DataSource="AppsCaseFile"  
		      KeyFieldName="Code" 
			  Fields="TopicLabel,Description,Tooltip">	
			  
	<cfinvoke component="UpdateTable" method="table" 
			  TableCode="TopicInsuranceList" 
			  TableName="Ref_TopicList"
			  SystemModule="Insurance"  
		      DataSource="AppsCaseFile"  
		      KeyFieldName="Code" KeyFieldName2="ListCode"
			  Fields="ListValue">				  
		  
</cfif>		


<cf_verifyOperational module="Staffing">	

<!--- employee --->	

<cfif ModuleEnabled eq "1">	
	
	<cfinvoke component="UpdateTable" method="table" 
			  TableCode="Ref_LeaveType" 
			  SystemModule="Staffing" 
		      DataSource="AppsEmployee"  
		      KeyFieldName="LeaveType"
			  Fields="Description">	  
		  
	<cfinvoke component="UpdateTable" method="table" 
			  TableCode="Ref_AddressType" 
			  SystemModule="Staffing" 
		      DataSource="AppsEmployee"  
		      KeyFieldName="AddressType"
			  Fields="Description">	  	
		  
	<cfinvoke component="UpdateTable"  method="table" 
			  TableCode="TopicStaffing" 
			  TableName="Ref_Topic"
			  SystemModule="Staffing"  
		      DataSource="AppsEmployee"  
		      KeyFieldName="Code" 
			  Fields="TopicLabel,Description,Tooltip">	
			  
	<cfinvoke component="UpdateTable" method="table" 
			  TableCode="TopicStaffingList" 
			  TableName="Ref_TopicList"
			  SystemModule="Staffing"  
		      DataSource="AppsEmployee"  
		      KeyFieldName="Code" KeyFieldName2="ListCode"
			  Fields="ListValue">				  	    
		  
</cfif>			  
	  
<!--- applicant --->	

<cf_verifyOperational module="Roster">	  

<cfif ModuleEnabled eq "1">	
	
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="Ref_ApplicantSection" 
		  SystemModule="Roster" 
	      DataSource="AppsSelection"  
	      KeyFieldName="Code"
		  Fields="Description,Instruction">	  
		  	
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="Ref_Experience" 
		  SystemModule="Roster"  
	      DataSource="AppsSelection"  
	      KeyFieldName="ExperienceFieldId">	 
		  
	<cfinvoke component="UpdateTable"  method="table" 
		  TableCode="Ref_ExperienceClass" 
		  SystemModule="Roster"  
	      DataSource="AppsSelection"  
	      KeyFieldName="ExperienceClass">	
			  
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="Ref_ExperienceParentTopic" 
		  SystemModule="Roster"  
	      DataSource="AppsSelection"  
	      KeyFieldName="FieldTopicId">	  	  
		  
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="Ref_Topic" 
		  SystemModule="Roster"  
	      DataSource="AppsSelection"  
	      KeyFieldName="Topic"
		  Fields="Description,Tooltip,Question">	  
		  
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="Ref_TopicClass" 
		  SystemModule="Roster"  
	      DataSource="AppsSelection"  
	      KeyFieldName="TopicClass"
		  Fields="Description,Tooltip">	  		  
			  
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="Ref_TopicList" 
		  SystemModule="Roster"  
	      DataSource="AppsSelection"  
	      KeyFieldName="Code" KeyFieldName2="ListCode"
		  Fields="ListValue,ListExplanation">	
		  
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="Ref_TopicListCode" 
		  SystemModule="Roster"  
	      DataSource="AppsSelection"  
	      KeyFieldName="ListCode"
		  Fields="ListLabel,ListExplanation">		  
		  
	<cfinvoke component="UpdateTable" method="table" 
		  TableCode="FunctionTitle" 
		  SystemModule="Roster"  
	      DataSource="AppsSelection"  
	      KeyFieldName="FunctionNo"
		  Fields="FunctionDescription">	
		  
	<cfinvoke component="UpdateTable"  method="table" 
		  TableCode="OccGroup" 
		  SystemModule="Roster"  
	      DataSource="AppsSelection"  
	      KeyFieldName="OccupationalGroup"
		  Fields="Description,DescriptionFull">	

	<cfinvoke component="UpdateTable"  method="table" 
		  TableCode = "EditionFunctionTitle"
  		  TableName = "Ref_SubmissionEditionPosition"
		  SystemModule="Roster"  
		  InterfaceTable = "1"
	      DataSource="AppsSelection"  
	      KeyFieldName="SubmissionEdition"
		  KeyFieldName2 = "PositionNo"
		  Fields="FunctionDescription">
		  
	<cfinvoke component="UpdateTable"  method="table" 
		  TableCode="Ref_TextArea" 
		  SystemModule="Roster"  
	      DataSource="AppsSelection"  
	      KeyFieldName="Code"
		  Fields="Description">		 

	<cfinvoke component="UpdateTable"  method="table" 
		  TableCode="Ref_Salutation" 
		  SystemModule="Roster"  
	      DataSource="AppsSelection"  
	      KeyFieldName="Code"
		  Fields="Description,Abbreviation">

</cfif>		   


<!--- case file --->

<cf_verifyOperational module="Accounting">	 

<cfif ModuleEnabled eq "1">	 
	
	<cfinvoke component="UpdateTable"  method="table" 
			  TableCode="TopicAccounting" 
			  TableName="Ref_Topic"
			  SystemModule="Accounting"  
		      DataSource="AppsLedger"  
		      KeyFieldName="Code" 
			  Fields="TopicLabel,Description,Tooltip">	
			  
	<cfinvoke component="UpdateTable" method="table" 
			  TableCode="TopicAccountingList" 
			  TableName="Ref_TopicList"
			  SystemModule="Accounting"  
		      DataSource="AppsLedger"  
		      KeyFieldName="Code" KeyFieldName2="ListCode"
			  Fields="ListValue">			  
		  
</cfif>		   		  	  	    	   

<!--- Workorder --->

	  
<cf_verifyOperational module="Workorder">	 

<cfif ModuleEnabled eq "1">	 
	
	<cfinvoke component="UpdateTable"  method="table" 
			  TableCode="TopicWorkorder" 
			  TableName="Ref_Topic"
			  SystemModule="Workorder"  
		      DataSource="AppsWorkorder"  
		      KeyFieldName="Code" 
			  Fields="TopicLabel,Description,Tooltip">	
			  
	<cfinvoke component="UpdateTable" method="table" 
			  TableCode="TopicWorkOrderList" 
			  TableName="Ref_TopicList"
			  SystemModule="WorkOrder"  
		      DataSource="AppsWorkOrder"  
		      KeyFieldName="Code" KeyFieldName2="ListCode"
			  Fields="ListValue">					  
			  
	<cfinvoke component="UpdateTable"  method="table" 
			  TableCode="ServiceItem" 
			  TableName="ServiceItem"
			  SystemModule="Workorder"  
		      DataSource="AppsWorkorder"  
		      KeyFieldName="Code" 
			  Fields="Description">	
			  
	<cfinvoke component="UpdateTable"  method="table" 
			  TableCode="ServiceItemUnit" 
			  TableName="ServiceItemUnit"
			  SystemModule="Workorder"  
		      DataSource="AppsWorkorder"  
		      KeyFieldName="ServiceItem" 
			  KeyFieldName2 = "Unit"
			  Fields="UnitDescription,UnitSpecification">	
			  
	<cfinvoke component="UpdateTable"  method="table" 
			  TableCode="ServiceItemClass" 
			  TableName="ServiceItemClass"
			  SystemModule="Workorder"  
		      DataSource="AppsWorkorder"  
		      KeyFieldName="Code" 
			  Fields="Description">	

	<cfinvoke component="UpdateTable"  method="table" 
			  TableCode="Ref_UnitClass" 
			  TableName="Ref_UnitClass"
			  SystemModule="Workorder"  
		      DataSource="AppsWorkorder"  
		      KeyFieldName="Code" 
			  Fields="Description">	
			  
	<cfinvoke component="UpdateTable"  method="table" 
			  TableCode="Ref_ServiceItemDomainClass" 
			  TableName="Ref_ServiceItemDomainClass"
			  SystemModule="Workorder"  
		      DataSource="AppsWorkorder"  
		      KeyFieldName="ServiceDomain" 
		      KeyFieldName2 = "Code"
			  Fields="Description">	
			  
	<cfinvoke component="UpdateTable"  method="table" 
			  TableCode="Ref_Request" 
			  TableName="Ref_Request"
			  SystemModule="Workorder"  
		      DataSource="AppsWorkorder"  
		      KeyFieldName="Code" 
			  Fields="Description">			
			  
	<cfinvoke component="UpdateTable"  method="table" 
			  TableCode="Ref_RequestWorkflow" 
			  TableName="Ref_RequestWorkflow"
			  SystemModule="Workorder"  
		      DataSource="AppsWorkorder"  
		      KeyFieldName="RequestType" 
			  KeyFieldName2="ServiceDomain"
			  KeyFieldName3="RequestAction"
			  Fields="RequestActionName">			
					  
</cfif>	
  
<cf_verifyOperational module="Accounting">	 

<cfif ModuleEnabled eq "1">	 
	
	<cfinvoke component="UpdateTable"  method="table" 
			  TableCode="AccountGL" 
			  TableName="Ref_Account"
			  SystemModule="Accounting"  
		      DataSource="AppsLedger"  
		      KeyFieldName="GLAccount" 
			  Fields="Description">	
			  
	<cfinvoke component="UpdateTable"  method="table" 
			  TableCode="AccountGroup" 
			  TableName="Ref_AccountGroup"
			  SystemModule="Accounting"  
		      DataSource="AppsLedger"  
		      KeyFieldName="AccountGroup" 
			  Fields="Description">	
			  
	<cfinvoke component="UpdateTable"  method="table" 
			  TableCode="AccountParent" 
			  TableName="Ref_AccountParent"
			  SystemModule="Accounting"  
		      DataSource="AppsLedger"  
		      KeyFieldName="AccountParent" 
			  Fields="Description">			  
		  
</cfif>	