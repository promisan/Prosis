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
<cfparam name="url.mission"         default="">
<cfparam name="url.itemmaster"      default="">
<cfparam name="url.personno"        default="">
<cfparam name="url.orgunit"         default="">
<cfparam name="url.requirementId"   default="">
<cfparam name="url.workorderid"     default="">
<cfparam name="url.workorderline"   default="">
<cfparam name="url.mode"            default="">

<cfif url.workorderid neq "">
	<cfset url.context = "workorder">		
</cfif> 

<cfif url.mode eq "">
	<!--- is used for the submit control for adding --->
	<cfset url.mode = url.context>
</cfif>

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#' 
   </cfquery>

<cfparam name="URL.Period" default="#Parameter.DefaultPeriod#">

<cfquery name="Delete" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT RequisitionNo 
	FROM   RequisitionLine
    WHERE  (OrgUnit is NULL or RequestDate is NULL)
	AND    OfficerUserId = '#SESSION.acc#' 
	AND    ActionStatus = '0'
</cfquery>

<cfloop query="Delete">

	<cfif DirectoryExists("#SESSION.rootDocumentPath#\#Parameter.RequisitionLibrary#\#Delete.RequisitionNo#")>
	
	<cftry>
		<cfdirectory 
		   action    = "DELETE" 
		   recurse   = "Yes" 
	       directory = "#SESSION.rootDocumentPath#\#Parameter.RequisitionLibrary#\#Delete.RequisitionNo#">
				 
	<cfcatch></cfcatch>			 
	</cftry>
				 					 
	</cfif>
	
</cfloop>

<cfquery name="Select" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   RequisitionLine
    WHERE  (OrgUnit is NULL or RequestDate is NULL)
	AND    OfficerUserId = '#SESSION.acc#'	
	AND    ActionStatus = '0'
	AND Created<= DateADD(mi, -1, Current_TimeStamp)
</cfquery>

<cfloop query="Select">
		
	<cfquery name="Delete"
	datasource="AppsPurchase"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	    DELETE FROM RequisitionLine
	    WHERE  RequisitionNo = '#RequisitionNo#'
	</cfquery>

</cfloop>


<cfinclude template="AssignRequisitionNo.cfm">


<cfset URL.ID = "#Parameter.MissionPrefix#-#No#">

<cfparam name="client.orgunit" default="">

<!--- create requisitions under the preparation period by default 

<cfif Parameter.PeriodPreparation neq "">
     <cfset per = Parameter.PeriodPreparation>
<cfelse>
     <cfset per = url.period> 
</cfif>
--->

<cfset per  = url.period> 

<cfif client.orgunit eq "">

	<cfset setunit = url.orgunit>	
		
<cfelse>
	
	<cfquery name="getUnit" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   O.OrgUnit, R.Mission, R.Period
			FROM     Organization.dbo.Organization O INNER JOIN
                     Organization.dbo.Ref_MissionPeriod R ON O.Mission = R.Mission AND O.MandateNo = R.MandateNo
			WHERE    O.OrgUnit = '#client.orgunit#' 
			AND      R.Period = '#per#'
			AND      O.Mission = '#URL.Mission#'
	</cfquery>
	
	<cfset setunit = getUnit.OrgUnit>	

</cfif>
	
<cfif url.context eq "WorkOrder" and url.RequirementId neq "">

	<cfquery name="getItem" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT   I.ItemMaster, 
		         I.ItemDescription, 
				 WIL.ItemNo, 
				 WIL.UoM, 
				 WIL.Quantity, 
				 I.ItemClass, 
				 WL.OrgUnitImplementer,
				 WIL.ItemMemo
		FROM     WorkOrder.dbo.WorkOrderLineItem WIL 
		         INNER JOIN Materials.dbo.Item I ON WIL.ItemNo = I.ItemNo 
				 INNER JOIN WorkOrder.dbo.WorkOrderLine WL ON WIL.WorkOrderId = WL.WorkOrderId AND WIL.WorkOrderLine = WL.WorkOrderLine
		WHERE    WorkOrderItemId = '#url.RequirementId#'
		
	</cfquery>
	
	<!--- check if the orgunit exists under the current period --->
	
	<cfif getItem.OrgUnitImplementer neq "">
	
			<cfquery name="getUnit" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT   O.OrgUnit, R.Mission, R.Period
				FROM     Organization O INNER JOIN
	                     Ref_MissionPeriod R ON O.Mission = R.Mission AND O.MandateNo = R.MandateNo
				WHERE    O.OrgUnit = '#getItem.OrgUnitImplementer#' 
				AND      R.Period = '#per#'
				AND      O.Mission = '#URL.Mission#'
				
			</cfquery>
			
			<cfif getUnit.recordcount eq "1">				
				<cfset setUnit = getUnit.OrgUnit>				
			</cfif>
			
	</cfif>				
		
	<!--- get cost price --->
	
	<cfquery name="getPrice" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     ItemUoMMission				
			WHERE    ItemNo  = '#getItem.ItemNo#'
			AND      UoM     = '#getItem.UoM#'
			AND      Mission = '#URL.Mission#' 
	</cfquery>
	
	<cfif getPrice.StandardCost gt 0>
	
			<cfset prc = getPrice.StandardCost>
							
	<cfelse>
			
			<cfquery name="getPrice" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     ItemUoM			
					WHERE    ItemNo  = '#getItem.ItemNo#'
					AND      UoM     = '#getItem.UoM#'			
			</cfquery>
		
			<cfset prc = getPrice.StandardCost>
	
	</cfif>
	
<cfelseif url.context eq "Workflow">		

 	<cfquery name="getObject" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT   *
		FROM     Organization.dbo.OrganizationObject 
		WHERE    ObjectKeyValue4 = '#url.RequirementId#'			
		
	</cfquery>
	
	<cfset setunit = getObject.OrgUnit>
	
	
<cfelseif url.context eq "Budget">	

	<!--- feature (Herve) to quickly add a pre-encumberance --->

    <cfquery name="getBudget" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT   *
		FROM     Program.dbo.ProgramAllotmentRequest 
		WHERE    RequirementId = '#url.ContextId#'			
		
	</cfquery>
	
	<cfif getBudget.recordcount eq "0">
				
		<cfquery name="getBudget" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT   *
			FROM     Program.dbo.ProgramAllotmentDetail 
			WHERE    TransactionId = '#url.ContextId#'			
			
		</cfquery>
		
		<cfset budgetmode = "direct">
	
	<cfelse>
	
		<cfset budgetmode = "requirement">
		
	</cfif>
					
	 <cfquery name="getProgramPeriod" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT   *
		FROM     Program.dbo.ProgramPeriod
		WHERE    ProgramCode = '#getBudget.ProgramCode#'
		AND      Period      = '#getBudget.Period#'
		
	</cfquery>
	
	<cfset setUnit = getProgramPeriod.OrgUnit>				
			
	<cfquery name="getEdition" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT   *
		FROM     Program.dbo.Ref_AllotmentEdition 
		WHERE    EditionId = '#getBudget.EditionId#'
		
	</cfquery>
	
	<cfquery name="Param" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT   *
		FROM     Program.dbo.Ref_ParameterMission 
		WHERE    Mission = '#getEdition.Mission#'
		
	</cfquery>
	
	<cf_ExchangeRate DataSource="AppsPurchase" 
	         CurrencyFrom="#Param.BudgetCurrency#"
			 CurrencyTo="#Application.BaseCurrency#">
		
</cfif>		
					
<cfquery name="Insert" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

   INSERT INTO RequisitionLine 
	(Mission,
	 RequisitionNo, 
	 <cfif setUnit neq "">
	 	OrgUnit, 
		OrgUnitImplement,
	 </cfif>
	 Period, 
	 
	 <cfif url.context eq "workorder">		
	 
		 WorkOrderId,
		 WorkOrderLine,
		 <cfif url.RequirementId neq "">
		   RequirementId,
		   <cfif getItem.ItemClass neq "Service">
		       RequestCurrency,
		       RequestQuantity,
			   RequestCurrencyPrice,
			   RequestCostPrice,
			   RequestAmountBase,
			   ItemMaster,		 
			   RequestDescription,
			   RequestType,
			   WarehouseItemNo,
			   WarehouseUoM,
		   </cfif>		   
		 </cfif>
		 
	 <cfelseif url.context eq "budget">
	 
	          RequestCurrency,
			  RequestQuantity,
			  <cfif budgetmode eq "requirement">
			  RequestCurrencyPrice,
			  RequestCostPrice,
			  RequestAmountBase,
	 		  ItemMaster,
			  RequestDescription,
			  </cfif>
			  RequestType,	
			  
	 <cfelseif url.context eq "workflow">		  		  
	 RequestDescription,
	 <cfif url.RequirementId neq "">
		     RequirementId,
	 </cfif>	
	 <cfif url.PersonNo neq "">
		     PersonNo,
	 </cfif>	
	  <cfif url.ItemMaster neq "">
		     ItemMaster,
	 </cfif>	    
	  	 
	 </cfif>	
	 
	 Source,	 	 
	 OfficerUserId, 
	 OfficerLastName, 
	 OfficerFirstName)
	 
VALUES ('#URL.Mission#',
        '#URL.ID#',
		 <cfif setUnit neq "">
		'#setunit#',
		'#setunit#',
		 </cfif>
		'#Per#',
		<cfif url.context eq "workorder">		
			'#url.workorderid#',
			'#url.workorderline#',
			<cfif url.RequirementId neq "">
			  '#url.RequirementId#',
			  <cfif getItem.ItemClass neq "Service">	
			   '#application.basecurrency#',			   
			   '#getItem.Quantity#',
			   '#prc#',
			   '#prc#',
			   '#prc*getItem.Quantity#',
			   '#getItem.ItemMaster#',		 
			   '#getItem.ItemMemo#',
			   'Warehouse',
			   '#getItem.ItemNo#',
			   '#getItem.UoM#',
			  </cfif>		  
			</cfif>
		<cfelseif url.context eq "budget">	
		
		      '#Param.BudgetCurrency#',
			  '1',
			  <cfif budgetmode eq "requirement">
			  '#getBudget.RequestAmountBase#',
			  '#getBudget.RequestAmountBase#',
			  '#getBudget.RequestAmountBase/exc#',
			  '#getBudget.ItemMaster#',
			  '#getBudget.RequestDescription#',
			  </cfif>
			  'Regular',		
			  
		<cfelseif url.context eq "workflow">		  		  
		
			 '#getObject.ObjectReference#',
			 <cfif url.RequirementId neq "">
				 '#url.requirementid#',
			 </cfif>	
			 <cfif url.PersonNo neq "">
				 '#url.personno#', 
			 </cfif>	
			 <cfif url.ItemMaster neq "">
			     '#url.itemmaster#',
			 </cfif>	     	  
			 
			  	
		</cfif>
		'#URL.Context#',
		'#SESSION.acc#', 
		'#SESSION.last#', 
		'#SESSION.first#') 					
</cfquery>


	
<!--- populate the topics --->

<cfif url.context eq "WorkOrder" and url.RequirementId neq "">

	<cfif getItem.ItemClass eq "Supply">	
	
		<cfquery name="ItemMaster" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT   *
			FROM     ItemMaster
			WHERE    Code = '#getItem.ItemMaster#'
		</cfquery>
	
		<cfquery name="Insert" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO RequisitionLineTopic				
					(RequisitionNo, 
					 Topic, 
					 ListCode,
					 TopicValue,
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)					 
			SELECT   '#URL.ID#', 
			         Topic, 
					 ListCode, 
					 TopicValue, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName						 
			FROM     Materials.dbo.ItemClassification				
			WHERE    ItemNo = '#getItem.ItemNo#'				
			AND      Topic IN (SELECT Code 
	    	                   FROM   Ref_TopicEntryClass 
						       WHERE  EntryClass = '#ItemMaster.EntryClass#')							   
		</cfquery>				   
	
	 </cfif>
	 
<cfelseif url.context eq "Budget">

	<cfif budgetmode eq "requirement">
	
		<cfquery name="Insert" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO RequisitionLineFunding				
					(RequisitionNo, 
					 Fund, 
					 ProgramPeriod,
					 ProgramCode,
					 ObjectCode,
					 Percentage,						
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)					 
			SELECT   '#URL.ID#',
			         Fund, 
			         '#getEdition.Period#', 
					 ProgramCode, 
					 ObjectCode, 
					 '1',
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName						 
			FROM     Program.dbo.ProgramAllotmentRequest				
			WHERE    RequirementId = '#url.contextid#'										   
		</cfquery>		
		
	<cfelse>
	
		<cfquery name="Insert" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO RequisitionLineFunding				
					(RequisitionNo, 
					 Fund, 
					 ProgramPeriod,
					 ProgramCode,
					 ObjectCode,
					 Percentage,						
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)					 
			SELECT   '#URL.ID#',
			         Fund, 
			         '#getEdition.Period#', 
					 ProgramCode, 
					 ObjectCode, 
					 '1',
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName						 
			FROM     Program.dbo.ProgramAllotmentDetail				
			WHERE    TransactionId = '#url.contextid#'												   
		</cfquery>		
	
	</cfif>			   

</cfif>

