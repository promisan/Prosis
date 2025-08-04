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
	
	
<!--- --------------------------------------------- --->	
<!--- --------------------------------------------- --->
<!--- posting of the amounts for payroll recovery-- --->
<!--- --------------------------------------------- --->
<!--- --------------------------------------------- --->

<cfparam name="url.mission" default="OICT">

<cfparam name="url.selectiondate" default="2012-11-30">


<cfset selend = createdate (url.year,url.month,1)>
<cfset selend = createdate (year(selend),month(selend),daysinMonth(selend) )>
<cfset selnextMonth = dateadd("d",1,selend)>

<cfquery name="Check" 
    datasource="AppsWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">

	SELECT *
	FROM   ServiceItemMissionPosting
	WHERE  Year(SelectionDateEffective) = #url.year#
	AND    Month(selectionDateEffective)= #url.month#
	AND    EnablePortalProcessing=1
	AND    ActionStatus='0'
	AND    ServiceItem IN (
					SELECT Code
					FROM   ServiceItem
					WHERE  SelfService = 1)
		
</cfquery>	

<cfif Check.recordcount gt "0">

	<cf_ScheduleLogInsert   
	      ScheduleRunId  = "#schedulelogid#"
	      Description    = "Process Interrupted. There are services pendig of financial closing in #MonthAsString(url.month)# #url.year#"
	      StepStatus="9"
	      Abort="Yes">
		
</cfif>

<cfquery name="person" 
    datasource="AppsWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	
	SELECT PersonNo,
		   PayrollItem,
		   SUM(TotalCharges) as TotalCharges,
		   PriorCharges
		   
	FROM (	
		
			SELECT  S.PersonNo, 	        
					U.PayrollItem, 
					S.ServiceItem,
					ROUND(SUM(S.Amount), 2) AS TotalCharges,
					
		            (SELECT    SUM(M.Amount)
		             FROM      Payroll.dbo.PersonMiscellaneous M
		             WHERE     M.PersonNo     = S.PersonNo 
					 AND       M.PayrollItem  = U.PayrollItem
					 AND   	   M.DocumentDate >= (
		                           SELECT DatePostingCalculate
		                           FROM   ServiceItemMission I
		   						   WHERE  I.ServiceItem = S.Serviceitem
		   						   AND    Mission     = '#url.mission#'
						)			 
					 ) AS PriorCharges
		    
			FROM    skWorkOrderCharges S INNER JOIN ServiceItemUnit U ON S.ServiceItem = U.ServiceItem AND S.ServiceItemUnit = U.Unit
		    
			WHERE   S.Charged = '2'      <!--- personal --->
			
			<!---AND     S.ActionStatus = '1'---> <!--- only if these are cleared --->
		
			AND     U.PayrollItem IN (SELECT   PayrollItem 
			                          FROM     Payroll.dbo.Ref_PayrollItem
									  WHERE    PayrollItem = U.PayrollItem)
		
			AND     S.PersonNo IN    (
			                           SELECT   PersonNo
		                               FROM     Employee.dbo.Person
		                               WHERE    S.PersonNo = S.PersonNo
									  )
									  
			AND     S.SelectionDate >= (
			                            SELECT DatePortalProcessing
			                            FROM   ServiceItemMission
									    WHERE  ServiceItem = S.Serviceitem
									    AND    Mission     = '#url.mission#'
									   ) 			
									   
			AND     S.SelectionDate >= (
                           	SELECT DatePostingCalculate
                           	FROM   ServiceItemMission
   							WHERE  ServiceItem = S.Serviceitem
   							AND    Mission     = '#url.mission#'
  									)
									
			AND s.SelectionDate < #selnextMonth#
									   				  
		    GROUP BY S.PersonNo, S.ServiceItem,U.PayrollItem 
	) X
	GROUP BY PersonNo,
	         PayrollItem,
			 PriorCharges
			 	
</cfquery>	
	
<!--- retrieve a sum for all people and amounts they are charged already per item --->
	
<cfloop query="person">

    <cfif PriorCharges eq "">
        <cfset diff = TotalCharges>
    <cfelse>
	    <cfset diff = TotalCharges - PriorCharges>
	</cfif>	
	
	<cfif abs(diff) gte "0.50">
	
		<cfquery name="insert" 
	    datasource="AppsPayroll" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		INSERT INTO PersonMiscellaneous
			(PersonNo,
			 DateEffective,
			 DateExpiration,
			 DocumentDate,
			 DocumentReference,
			 PayrollItem,
			 Quantity,
			 Currency,
			 Amount,
			 Status,
			 OfficerUserId,
			 OfficerlastName,
			 OfficerFirstName)				 
		VALUES
			('#Personno#',
			 '#dateformat(now(),client.datesql)#', 
			 '#dateformat(now(),client.datesql)#', 
			 '#dateformat(selend,"YYYY-MM-DD")#', 
			 'Service Module',
			 '#payrollitem#',
			 '1',
			 'USD',
			 '#diff#',
			 '2',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')
		</cfquery>	
		
	</cfif>	
		
</cfloop>	

<cfinclude template="UsagePayrollFile.cfm">
