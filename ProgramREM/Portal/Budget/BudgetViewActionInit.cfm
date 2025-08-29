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
<cfparam name="url.mission"    default="Promisan">
<cfparam name="url.id1"        default="0">
<cfparam name="url.period"     default="">

<cfquery name="Parameter" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
     FROM   Ref_ParameterMission
	 WHERE  Mission = '#url.mission#'
</cfquery>

<cfset url.editionid = "#Parameter.BudgetPortalEdition#">
 
<cfquery name="Org" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
     FROM   Organization
	 WHERE  OrgUnit = '#url.id1#'
</cfquery>

<cfif org.recordcount eq "1">

<cfquery name="ParentList" 
	datasource="AppsProgram">
		SELECT *
		FROM   Program
		WHERE  Mission = '#URL.Mission#'
		AND    isServiceParent = 1
		AND    ProgramClass = 'Program'
</cfquery>

<cfloop query="ParentList">
										
	<cfquery name="Class" 
	datasource="AppsWorkorder">
		SELECT *
		FROM   ServiceItemClass	
		WHERE  Operational = 1
	</cfquery>

	<cfset parent = ProgramCode>
		
	<cfloop query="Class">
	
	    <CF_DropTable dbName="AppsQuery" 
	      tblName="Billing#SESSION.acc#_#Code#">
	
		<cftransaction>
		
		<cfset url.editionid = "#Parameter.BudgetPortalEdition#">
							
		<cfinvoke component = "Service.Process.Program.Program"  
		   method             = "CreateProgram" 
		   mission            = "#url.Mission#"
		   ProgramName        = "#Description#"
		   ServiceClass       = "#Code#"
		   ProgramDescription = "#Description#"
		   Period             = "#url.period#"
		   OrgUnit            = "#url.id1#"		  
		   ProgramClass       = "Component"
		   ProgramScope       = "Unit"
		   ParentCode         = "#Parent#"
		   returnvariable     = "newCode"/>
		   
		   <!--- ----------------- --->
		   <!--- get forecast data --->
		   <!--- ----------------- --->
		   
		  <cfquery name="Edition" 
			datasource="AppsProgram"  
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * FROM Ref_AllotmentEdition WHERE EditionId = '#url.editionid#'
		  </cfquery>	
		  
		    <cfquery name="Version" 
			datasource="AppsProgram"  
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * FROM Ref_AllotmentVersion
			WHERE Code = '#Edition.Version#'			
		  </cfquery>	
		  
		
		  <cfquery name="EditionFund" 
			datasource="AppsProgram"  
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * FROM Ref_AllotmentEditionFund WHERE EditionId = '#url.editionid#'
			AND FundDefault = 1 
		 </cfquery>	
		 
		 <!--- ----------------------- --->
		 <!--- define the default fund --->
		 <!--- ----------------------- --->
		
		 <cfset url.fund = "#EditionFund.Fund#">
		
		 <cfif url.fund neq "">		
		 	
			<!--- take valid billing records for quantity ---> 
			
			<cfquery name="Billing" 
			datasource="AppsProgram"  
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 				
			 SELECT B.WorkOrderId, 
				    B.ServiceItem, 
					COUNT(*) AS Quantity, 
					B.Rate, 
					R.ServiceItemUnitForecast, 
					R.RateForecast, 
					R.Frequency
			  INTO  userQuery.dbo.Billing#SESSION.acc#_#Code#		
              FROM  Workorder.dbo.WorkOrderLineBillingDetail AS B INNER JOIN
                    WorkOrder.dbo.WorkOrderLine AS L ON B.WorkOrderId = L.WorkOrderId AND B.WorkOrderLine = L.WorkOrderLine INNER JOIN
                    WorkOrder.dbo.skRate R ON B.ServiceItem = R.Serviceitem AND B.ServiceItemUnit = R.ServiceItemUnit
              WHERE (B.ServiceItem IS NOT NULL) 
			  AND   (B.BillingEffective < '01/01/2011') 
			  AND   (L.Operational = 1) 
			  		
			  AND    L.WorkOrderId IN (SELECT WorkorderId FROM Workorder.dbo.WorkOrder WHERE CustomerId IN
						                    (SELECT   CustomerId
						                     FROM     WorkOrder.dbo.Customer
						                     WHERE    (OrgUnit = '#url.id1#')
											)
									  )
			 
              GROUP BY B.WorkOrderId, 
			           B.ServiceItem, 
					   B.Rate, 
					   R.ServiceItemUnitForecast, 
					   R.RateForecast, 
					   R.Frequency		
					   
			</cfquery>  
				   
		   <cfquery name="Source" 
			datasource="AppsProgram"  
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
						
			SELECT   C.CustomerId,
			         C.CustomerName, 
					 S.ServiceClass, 
					 W.ServiceItem, 
					 skRate.ServiceItemUnitForecast, 					

					 (SELECT TOP 1 ObjectCode 
					         FROM Purchase.dbo.ItemMasterobject 
							 WHERE ItemMaster = W.ServiceItem) as ObjectCode,
					 
					 skRate.Quantity,					
					 skRate.RateForecast as Rate,
					 skRate.Frequency
			
			 FROM   WorkOrder.dbo.WorkOrder AS W INNER JOIN
			        WorkOrder.dbo.ServiceItem AS S ON W.ServiceItem = S.Code INNER JOIN
			        WorkOrder.dbo.Customer AS C ON W.CustomerId = C.CustomerId INNER JOIN
			        userQuery.dbo.Billing#SESSION.acc#_#Code# skRate ON W.WorkOrderId = skRate.WorkOrderId  
					
			WHERE   (W.CustomerId IN
			                    (SELECT   CustomerId
			                     FROM     WorkOrder.dbo.Customer
			                     WHERE    (OrgUnit = '#url.id1#'))) 
			
			AND       S.ServiceClass = '#Code#'							
									
			ORDER BY C.CustomerName,
			         W.ServiceItem,
			         skRate.ServiceItemUnitForecast 
			
		   </cfquery>	
		   
			<cfquery name="Check" 
			datasource="AppsProgram"  username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				SELECT  * 
				FROM    ProgramAllotment
				WHERE   ProgramCode = '#newcode#'
				AND     Period      = '#url.period#'
				AND     EditionId   = '#url.editionid#'
			</cfquery>
			
			<cfif check.recordcount eq "0">
			
				<cfquery name="AddAllotment" 
				 datasource="AppsProgram"  
				 username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
						
					INSERT INTO  ProgramAllotment
					          (ProgramCode, 
					           Period, 
							   EditionId, 							  
							   OfficerUserId, 
							   OfficerLastName, 
							   OfficerFirstName)							   
					 VALUES   ('#newCode#',
					           '#url.period#',
							   '#url.editionid#',							
							   '#SESSION.acc#',
							   '#SESSION.last#',
							   '#SESSION.first#')
								
				</cfquery>				 
			
		    </cfif>		
			
			<cfquery name="AddLineHeader" 
				 datasource="AppsProgram" 
				 username="#SESSION.login#" 
			     password="#SESSION.dbpw#">					
				 DELETE FROM ProgramAllotmentRequestQuantity
				 WHERE  RequirementId IN (SELECT RequirementId 
					                      FROM   ProgramAllotmentRequest 
										  WHERE  ProgramCode = '#newcode#'
											AND  Period      = '#url.period#'
											AND  EditionId   = '#url.editionid#'
											AND  Source      = 'Forecast')
			</cfquery>		
						
			<cfquery name="RemoveLine" 
				 datasource="AppsProgram" 
				 username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					
					DELETE FROM ProgramAllotmentRequest
					WHERE  ProgramCode = '#newcode#'
					AND    Period      = '#url.period#'
					AND    EditionId   = '#url.editionid#'
					AND    Source      = 'Forecast'
					
			</cfquery>				
		   
		    <cfloop query="Source">
			
				<cfquery name="GetMaster" 
				datasource="AppsProgram"  username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					SELECT  * 
					FROM    Purchase.dbo.ItemMaster
					WHERE   Code = '#ServiceItem#'
				</cfquery>
				
				<!--- the below will filter the entries to just one entry per year as the 
				periods will have the class B --->
				
				<cfquery name="Period" 
     			datasource="AppsProgram"  username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					SELECT  * 
					FROM    Ref_Audit 
					WHERE   Period = '#edition.period#'
					<cfif getmaster.BudgetAuditClass neq "">
					AND     AuditId IN (SELECT AuditId FROM Ref_AuditClass WHERE AuditClass = '#GetMaster.BudgetAuditClass#')
					</cfif>				
		    	</cfquery>
			
				<cfquery name="GetObject" 
					datasource="AppsProgram"  
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  * 
						FROM    Purchase.dbo.ItemMasterObject 
						WHERE   ItemMaster = '#ServiceItem#'						
						AND     ObjectCode IN (SELECT Code FROM Ref_Object WHERE ObjectUsage = '#Version.ObjectUsage#')
				</cfquery>				
				
				<cfset Object = GetObject.ObjectCode>
					   
		   		<cfif Object neq "">
				
				   	<cf_assignId>
			   
				   	<cfquery name="AddLineHeader" 
					 datasource="AppsProgram" 
					 username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
					
						INSERT INTO  ProgramAllotmentRequest
						          (RequirementId,
								   ProgramCode, 
						           Period, 
								   EditionId, 
								   ObjectCode, 
								   Fund, 
								   ItemMaster, 
								   TopicValueCode, 
								   RequestQuantity, 
								   RequestPrice, 							 
		                           RequestRemarks, 
								   RequestDescription,
								   Source,
								   ActionStatus,
								   OfficerUserId, 
								   OfficerLastName, 
								   OfficerFirstName)
								   
						 VALUES   ('#rowguid#',
						           '#newCode#',
						           '#url.period#',
								   '#url.editionid#',
								   '#Object#',
								   '#url.fund#',
								   '#serviceitem#',
								   '#ServiceItemUnitForecast#',
								   '#quantity*period.recordcount#',
								   '#Rate#',	
								   '#customername#',
								   '#customername#',
								   'Forecast',
								   '1',
								   '#SESSION.acc#',
								   '#SESSION.last#',
								   '#SESSION.first#')
							
			        </cfquery>	
					
					<cfset qty = quantity>			   		
			   
			   		<cfloop query="Period">
					
						<cfquery name="AddLine" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
							INSERT INTO ProgramAllotmentRequestQuantity
							          (RequirementId,AuditId,RequestQuantity)						   
							VALUES    ('#rowguid#','#auditid#','#qty#')
						</cfquery>			   
			   
			   		</cfloop>	  
				
				</cfif> 
		   
		   </cfloop>		  
		   
		<!--- recalculate the amounts --->
				
		<cfinvoke component = "Service.Process.Program.Program"  
		   method           = "SyncProgramBudget" 
		   ProgramCode      = "#newcode#" 
		   Period           = "#url.Period#"
		   EditionId        = "#url.EditionId#">	
		
		</cfif>	 		
		   
		</cftransaction>
				
		<CF_DropTable dbName="AppsQuery" 
		      tblName="Billing#SESSION.acc#_#Code#">
		  			  		   
		<!--- process the forecast 
		   
		   1. Extract the lines for the service class
		   2a. Loop through the lines and 
		     2b then loop through the period to create
		   3. Define Object as detailed	  
		   		   
		--->	   	   
					
	</cfloop>
	
	<!--- additional option for minor maintenance --->
	
	<cfinvoke component = "Service.Process.Program.Program"  
			   method             = "CreateProgram" 
			   mission            = "#url.Mission#"
			   ProgramName        = "Minor Maintenance for application"
			   ServiceClass       = "PFS"
			   ProgramDescription = "Minor Maintenance for application"
			   Period             = "#url.period#"
			   OrgUnit            = "#url.id1#"			   
			   ProgramClass       = "Component"
			   ProgramScope       = "Unit"
			   ParentCode         = "#Parent#"
			   returnvariable     = "newCode"/>	
			   
	<!--- additional option for minor maintenance --->
	
	<cfinvoke component = "Service.Process.Program.Program"  
			   method             = "CreateProgram" 
			   mission            = "#url.Mission#"
			   ProgramName        = "ICT General"
			   ServiceClass       = "PFS"
			   ProgramDescription = "ICT General"
			   Period             = "#url.period#"
			   OrgUnit            = "#url.id1#"			   
			   ProgramClass       = "Component"
			   ProgramScope       = "Unit"
			   ParentCode         = "#Parent#"
			   returnvariable     = "newCode"/>				   
	
</cfloop>	

<cfif ParentList.recordcount gte "1">
	<cf_programHierarchy programcode = "#parent#" period="#url.period#">
</cfif>	

</cfif>

<cfinclude template="../../Application/Budget/AllotmentView/AllotmentViewDetail.cfm">

