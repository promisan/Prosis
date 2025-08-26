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
		 		
<cfparam name="url.onlynew" default="false">		

   <!--- define people to be extended --->
	
	<cfquery name="DefineAssignment" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
		SELECT    DISTINCT A.PersonNo, 
		          Ext.DateExtension, 
				  #END# as DateExpiration, 
				  A.AssignmentNo
		INTO      userQuery.dbo.#SESSION.acc#PersonExtension
		FROM      Employee.dbo.PersonAssignment A INNER JOIN
	              Employee.dbo.PersonExtension Ext ON A.PersonNo = Ext.PersonNo INNER JOIN
	              Employee.dbo.Position P ON A.PositionNo = P.PositionNo AND Ext.Mission = P.Mission AND Ext.MandateNo = P.MandateNo
		WHERE     A.AssignmentStatus IN ('0','1') 
		AND       A.DateExpiration  >= #STR1#
		AND       P.Mission         = '#URL.Mission#' 
		AND       P.MandateNo       = '#Form.MissionTemplate#'
		
		<cfif url.onlynew eq "true">
		
		<!--- only people that do not have an occurency yet --->
		
		AND       Ext.PersonNo NOT IN (
		                               SELECT DISTINCT PA.PersonNo 
		                               FROM   Employee.dbo.PersonAssignment PA, 
									          Employee.dbo.Position Po
									   WHERE  PA.PositionNo = Po.PositionNo
									   AND    Po.Mission   = '#url.mission#'
									   AND    Po.MandateNo = '#man#'
									  ) 
				
		</cfif>
		
		
	</cfquery>
	
			
	<!--- 1. adjust extension date based on already issued contracts for that person in that mission which expiration lies 
	  in the next mandate --->
	
	<cfquery name="Dates" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
			UPDATE userQuery.dbo.#SESSION.acc#PersonExtension 
			SET    DateExtension = C.DateExpiration 
			FROM   userQuery.dbo.#SESSION.acc#PersonExtension E, Employee.dbo.PersonContract C
			WHERE  E.Personno       = C.PersonNo
			AND    C.Mission        = '#URL.Mission#' 
			AND    C.ActionStatus   = '1' 
			AND    C.DateExpiration > #STR1# 
			<!--- we included contracts that were just loaded here --->
			AND    C.HistoricContract = 0
	</cfquery>
	
	<!--- 2. correct the extensions to fall within the mandate --->
			
	<cfquery name="ExpirationDates" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
			UPDATE userQuery.dbo.#SESSION.acc#PersonExtension 
			SET    DateExpiration = DateExtension 
			WHERE  DateExtension < #END#
			AND    DateExtension >= #STR# 
	</cfquery>	
							
	<!--- 3. insert assignments for the next mandate --->
	
	<cfquery name="InsertAssignment" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
		INSERT INTO Employee.dbo.PersonAssignment
			  (PersonNo, 
			   PositionNo, 
			   OrgUnit, 
			   FunctionNo, 
			   FunctionDescription, 
			   LocationCode, 
			   DateEffective, 
			   DateExpiration, 
			   AssignmentStatus, 
			   AssignmentClass,
			   AssignmentType, 
			   Incumbency, 
			   Source,
			   SourceId,				 
			   OfficerUserId, 
			   OfficerLastName, 
			   OfficerFirstName, 
			   Created)
		SELECT A.PersonNo,
		       P.PositionNo,
			   P.OrgUnitOperational, 
		       A.FunctionNo,
			   A.FunctionDescription,
			   A.LocationCode,
			   #STR#, 
		  	   Ext.DateExpiration,
			  '0',
			   A.AssignmentClass,
			   A.AssignmentType,
			   A.Incumbency,
	           '#URL.Mission#-#man#',		  
			   A.AssignmentNo,				  
			   '#SESSION.acc#', 
			   '#SESSION.last#', 
			   '#SESSION.first#',
			   getDate()
		FROM   Employee.dbo.PersonAssignment A, 
		       Employee.dbo.Position P, 
			   Organization O,
			   userQuery.dbo.#SESSION.acc#PersonExtension Ext
		WHERE  O.Mission    = '#URL.Mission#' 
		AND    O.MandateNo  = '#man#'
		AND    O.OrgUnit    = P.OrgUnitOperational
		AND    A.PositionNo = P.SourcePositionNo
		AND    A.AssignmentNo = Ext.AssignmentNo
	 </cfquery>
	 
	 <!--- correction of the assignment end date in case it exceeds the position end date --->
	 
	 <cfquery name="UpdateAssignment" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">  
	  UPDATE Employee.dbo.PersonAssignment
	  SET    DateExpiration = P.DateExpiration
	  FROM   Employee.dbo.PersonAssignment PA INNER JOIN
             Employee.dbo.Position P ON PA.PositionNo = P.PositionNo
	  WHERE  PA.Source = '#URL.Mission#-#man#'
	  AND    PA.DateExpiration > P.DateExpiration		 
	 </cfquery> 
	 
	 <!--- also copy over the assignment group and warden info --->	 
	 
	 <cfquery name="InsertAssignmentGroup" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">  
			INSERT INTO Employee.dbo.PersonAssignmentGroup
				  (PersonNo, 
				   PositionNo, 
				   AssignmentNo,
				   AssignmentGroup,
				   Status,			   	 
				   OfficerUserId, 
				   OfficerLastName, 
				   OfficerFirstName, 
				   Created)
			SELECT A.PersonNo,
			       A.PositionNo,
				   A.AssignmentNo, 
			       G.AssignmentGroup,
				   G.Status,			 	  
				   '#SESSION.acc#', 
				   '#SESSION.last#', 
				   '#SESSION.first#',
				   getDate()
			FROM   Employee.dbo.PersonAssignment A, 
			       Employee.dbo.PersonAssignmentGroup G,
				   userQuery.dbo.#SESSION.acc#PersonExtension Ext
			WHERE  A.PersonNo = G.PersonNo
			AND    G.AssignmentNo = A.SourceId
			AND    A.Source      = '#URL.Mission#-#man#'	
			AND    G.AssignmentNo = Ext.AssignmentNo	
	 </cfquery>
			 	 	 
	<!--- 4. insert contract extensions for the next mandate for people whose
	 contract ends on exactly on the mandate expiration date and which are selected for extension like assignment --->
	 
	<cfquery name="InsertContracts" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
		INSERT INTO Employee.dbo.PersonContract
		
				(PersonNo, 
				Mission, 
				MandateNo,
				DateEffective, 
				DateExpiration, 
				ContractType, 
				ContractTime, 
				ContractFunctionNo,
				ContractFunctionDescription,
				ContractStatus, 
				AppointmentStatus, 
				AppointmentStatusMemo,
				SalarySchedule, 
	            SalaryBasePeriod, 
				ContractLevel, 
				ContractStep, 
				ServiceLocation, 
				ContractSalaryAmount, 
				Remarks, 
				StepIncrease, 
				StepIncreaseDate, 
				ActionStatus, 
	            ActionCode, 				
				PersonnelActionNo, 
				EnforceFinalPay, 
				ReviewPanel, 
				HistoricContract, 
				RecordStatus,
				OfficerUserId, 
				OfficerLastName, 
				OfficerFirstName)
			
		SELECT    PC.PersonNo, 
		          PC.Mission, 
				  '#man#',
				  #STR#, 
				  Ext.DateExpiration,
				  PC.ContractType, 
				  PC.ContractTime, 
				  PC.ContractFunctionNo,
			   	  PC.ContractFunctionDescription,
				  PC.ContractStatus, 
				  PC.AppointmentStatus, 
				  PC.AppointmentStatusMemo,
				  PC.SalarySchedule, 
	              PC.SalaryBasePeriod, 
				  PC.ContractLevel, 
				  PC.ContractStep, 
				  PC.ServiceLocation, 
				  PC.ContractSalaryAmount, 
				  PC.Remarks, 
				  PC.StepIncrease, 
				  PC.StepIncreaseDate, 
				  '1', 
	              '3003', 				 
				  PC.PersonnelActionNo, 
				  PC.EnforceFinalPay, 
				  PC.ReviewPanel, 
				  PC.HistoricContract, 
				  '1',
				  '#SESSION.acc#', 
				  '#SESSION.last#', 
				  '#SESSION.first#'
		FROM      Employee.dbo.PersonContract PC, 
		          userQuery.dbo.#SESSION.acc#PersonExtension Ext
		WHERE     Mission = '#URL.Mission#' 
		AND       PC.PersonNo = Ext.PersonNo
		AND       ActionStatus = '1' 
		AND       PC.DateExpiration = #STR1# <!--- if contract is null is automatically extends itself OR DateExpiration IS NULL) ---> 
	    <!---- Removed on June 30th 2011 BY dev AND     HistoricContract = 0 --->
		<!--- do not carry over already existing records --->
		AND       PC.PersonNo NOT IN (
		                              SELECT PersonNo 
		                              FROM   Employee.dbo.PersonContract 
									  WHERE  PersonNo      = PC.PersonNo 
									  AND    Mission       = '#url.mission#' 
									  AND    ActionStatus != '9'
									  AND    DateEffective >= #STR#
									 )		
	  </cfquery>	  

	  <cfquery name="InsertEntitlement" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">  
		INSERT INTO Payroll.dbo.PersonEntitlement
			( PersonNo, 
			  EntitlementId, 
			  DateEffective, 
			  DateExpiration, 
			  SalarySchedule, 
			  EntitlementClass, 
			  SalaryTrigger, 
			  PayrollItem, 
			  Period, 
			  Currency, 
			  Amount, 
              DocumentReference, 
			  Remarks, 
			  Status, 
			  ContractId, 
			  ActionReference, 
			  OfficerUserId, 
			  OfficerLastName, 
			  OfficerFirstName)
			
		SELECT   PersonNo, 
			   newid(), 
			   DateEffective, 
			   DateExpiration, 
			   SalarySchedule, 
			   EntitlementClass, 
			   SalaryTrigger, 
			   PayrollItem, 
			   Period, 
			   Currency, 
			   Amount, 
               DocumentReference, 
			   Remarks, 
			   Status, 
			   (SELECT TOP 1 ContractId 
			    FROM   Employee.dbo.PersonContract 
				WHERE  PersonNo      = S.PersonNo 
				AND    Mission       = '#url.mission#' 
				AND    MandateNo     = '#man#'
				AND    DateEffective = #str#) as ContractId	,						  
			   ActionReference, 
			   '#SESSION.acc#', 
			   '#SESSION.last#', 
			   '#SESSION.first#'
		FROM   Payroll.dbo.PersonEntitlement S
		      
		WHERE  ContractId IN ( SELECT  PC.ContractId				  
							   FROM    Employee.dbo.PersonContract PC, userQuery.dbo.#SESSION.acc#PersonExtension Ext
							   WHERE   Mission = '#URL.Mission#' 
							   AND     ActionStatus = '1' 
							   AND     PC.DateExpiration = #STR1# <!--- if contract is null is automatically extends itself OR DateExpiration IS NULL) ---> 
							  <!---- Removed on June 30th 2011 BY dev AND     HistoricContract = 0 --->
								<!--- do not carry over with already existing records --->
							   AND     PC.PersonNo NOT IN (SELECT PersonNo 
								                              FROM   Payroll.dbo.PersonEntitlement
															  WHERE  PersonNo = PC.PersonNo 
															  AND    DateEffective >= #STR#)
							)								  
	  </cfquery>
	  
			 
