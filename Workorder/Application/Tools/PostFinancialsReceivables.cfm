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
<!--- ------attention 2/2/2014: this would need to be grouped by MISSION---- --->
<!--- ---------------------------------------------------------------------- --->

<!--- ------------------------------------------ --->
<!--- --------we take a snaphot----------------- --->
<!--- ------------------------------------------ --->
	
<cfset schedulelogid="">

	<cf_ScheduleLogInsert   
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Snapshot created">
	
	<!--- logging of the totals for audit purposes later on --->			
	
<!--- ------------------------------------------ --->
<!--- posting of the amounts into the Financials --->
<!--- ------------------------------------------ --->
		
<cfset cnt= 0>

<cfloop query="workorder">
		
	<!---	
	<cfset agreedcorrection = StructNew()>	
	<cfset StructClear(agreedcorrection)>
	--->
	
	<cfset woid = workorderid>


	<cfset cnt = cnt+1>	
				
	<cfquery name="Customer" 
    datasource="NovaWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#"
	timeout="#scripttimeout#">
		SELECT   *
		FROM     Customer
		WHERE    CustomerId = '#workorder.customerid#'		
	</cfquery>
				
	<cfif customer.terms eq "">
	
		<cfset d = 15>		
	
	<cfelse>
	
		<cfquery name="Terms" 
	    datasource="NovaWorkOrder" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#"
		timeout="#scripttimeout#">
			SELECT   *
			FROM     Ref_Terms
			WHERE    Code = '#customer.terms#'		
		</cfquery>
		
		<cfset d = terms.paymentdays>
	
	</cfif>
	
	<cfset due = dateadd("d",d, sel)>
	
	<cfquery name="getServiceItem" 
    datasource="NovaWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#"
	timeout="#scripttimeout#">
		SELECT   *
		FROM     ServiceItem S INNER JOIN ServiceItemMission M ON S.Code = M.ServiceItem		
		WHERE    Mission     = '#url.mission#'
		AND      ServiceItem = '#workorder.serviceitem#'
	</cfquery>	
	
	<!--- 28/04/2011 the issue is how to reconcile amounts once the actual goes beyond --->
	
	<cfquery name="Journal" 
    datasource="NovaWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#"
	timeout="#scripttimeout#">
		SELECT   *
		FROM     Accounting.dbo.Journal
		WHERE    Journal = '#getserviceitem.journal#'		
	</cfquery>		
				
	<cfif Journal.recordcount eq "1">					
	
	        <!--- ------------------------------------------------------------------------------------ --->
			<!--- PENDING : provision if no lines for the workorder found anymore, 
			                                                                       should it correct ? --->
			<!--- ------------------------------------------------------------------------------------ --->
					
			<cfquery name="currencylist" 
		    datasource="NovaWorkOrder" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#"
			timeout="#scripttimeout#">
				SELECT   DISTINCT Currency
				FROM     skWorkOrderCharges
				WHERE    WorkOrderId = '#woid#'	
			</cfquery>
		
			<cfoutput query="currencylist" group="currency">
									
				<cfset cur         = currency>
				
				<!--- PENDING need to add a provision if the GLAccount changes completely and thus 
				we no longer have a comparison base from the source. Very Unlikely (I hope..) --->
									
				<!--- we loop through the posting dates starting from the first date for this workorder
				to check for retro changes, 
				
				Note for the file : at some point we limit the retro changes list to the last
				3 months or so --->
				
				<cfquery name="selectiondates" 
			    datasource="NovaWorkOrder" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#"
				timeout="#scripttimeout#">
					SELECT   DISTINCT SelectionDate
					FROM     skWorkOrderCharges
					WHERE    WorkOrderId = '#woid#'
					AND      Currency    = '#cur#'	
					
					<!--- NEW Dev 2011-09-11, only the period to be considered --->
					
					<cfif getServiceItem.DatePostingCalculate neq "">						
					AND      SelectionDate >= '#getServiceItem.DatePostingCalculate#' 
					<cfelse>		 
					AND      SelectionDate >= '#Param.DatePostingCalculate#'
					</cfif>													
										
					ORDER BY SelectionDate 
				</cfquery>
				
				<!--- loop through the full charge period that is to be calculated from start to end 
				as such it will pick up differences for each month and correct these --->
				
				<cfset agreedcorrection = StructNew()>	
				<cfset StructClear(agreedcorrection)>
											
				<cfloop query="selectiondates">

						<cfset dateValue = "">
						<CF_DateConvert Value="#dateformat(SelectionDate,CLIENT.DateFormatShow)#">
						<cfset SELT = dateValue>
																
						<!--- -------------------------------------------------------------------- --->
						<!--- -- 1. retrieve relevant SLA's for the period under consideration --- --->
						<!--- -------------------------------------------------------------------- --->
						
						<cfquery name="getSLAList" 
							datasource="NovaWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#"
							timeout="#scripttimeout#">
							
							SELECT   DISTINCT DateEffective 
							FROM     WorkOrderBaseLine
							WHERE    WorkOrderId = '#woid#'
							AND      ActionStatus = '3'
							
							<!--- 04/11 we take only the SLA that is valid in that year of action but to cumulate
								agreements from different year --->														
																						
								<cfif getServiceItem.DatePostingCalculate neq "">	
								AND      DateEffective >= '#getServiceItem.DatePostingCalculate#' 		
								<cfelse>		 
								AND      DateEffective >= '#Param.DatePostingCalculate#'
								</cfif>								
								AND      DateEffective <= #SELT#	
								
								<!--- on 29/03 the mechnism changed, as we use the SLA to correct
								the amounts of Units covered under the SLA, instead of replacing it
								until the amounts were reached --->
								
								AND      DateExpiration >= #SELT#					
							
							ORDER BY DateEffective DESC			
									  
					   </cfquery>					   
					   
				   
					   <!--- Attention SLa are meant for YEARLY charging --->			   			  
					   
					   <cfset slaid = "">
					   
					   <cfloop query = "getSLAList">
					   									
						   <cfquery name="Agreement" 
							    datasource="NovaWorkOrder" 
							    username="#SESSION.login#" 
							    password="#SESSION.dbpw#"
								timeout="#scripttimeout#">
								SELECT   TOP 1 *
								FROM     WorkOrderBaseLine
								WHERE    ActionStatus = '3'
								AND      WorkOrderId = '#woid#'
								AND      DateEffective  = '#dateformat(dateEffective,client.dateSQL)#'							
								ORDER BY Created DESC  
							</cfquery>	
							
							<cfif slaid eq "">
							    <cfset slaid = "'#agreement.transactionid#'">	
							<cfelse>
								<cfset slaid = "#slaid#,'#agreement.transactionid#'">		
							</cfif>	
												
						</cfloop>								
					
						<cfset chgRegular  = 0>
						<cfset chgPersonal = 0>
						<cfset tot         = 0>
																	
						
						<!--- ------------------------------------------------------------------ --->
						<!--- define the charges on the line level which would need to be posted --->
						<!--- ------------------------------------------------------------------ --->
						<cfsavecontent variable="chargescalc">
											
							SELECT   C.WorkOrderId,
							         C.Currency,
									 C.WorkorderLine,	
									 C.ServiceItemUnit,
									 R.UnitDescription,						 
							         U.Code as UnitClass,
							         U.Description as ClassDescription,
									 C.GLAccount, 
									 C.Charged,      <!--- type of charging --->									 
									 C.Frequency,
									 round(SUM(C.Amount),2) AS Total, 
									 
									 <!--- ad a column as the basis for charging which is NOT
									  a SUM but an amount of the charge for the frequency 
									 --->
									 
									 (
									 CASE C.Frequency 
									 									 
									   WHEN 'Year' THEN
										 
										 (
										 SELECT   TOP 1 AmountBase 
										 FROM     skWorkorderCharges s
										 WHERE    s.WorkOrderId      = '#woid#'
										 AND      s.Workorderline    = C.WorkOrderLine
										 AND      s.Currency         = '#cur#'
										 AND      s.ServiceItemUnit  = C.ServiceitemUnit
										 AND      s.Charged          = C.Charged
										 AND      s.Frequency        = C.Frequency
										 ORDER BY s.SelectionDate DESC
										 ) 
										 
									   WHEN 'Quarter' THEN
										
										 (
										 SELECT   TOP 1 AmountBase 
										 FROM     skWorkorderCharges s
										 WHERE    s.WorkOrderId      = '#woid#'
										 AND      s.Workorderline    = C.WorkOrderLine
										 AND      s.Currency         = '#cur#'
										 AND      s.ServiceItemUnit  = C.ServiceitemUnit
										 AND      s.Charged          = C.Charged
										 AND      s.Frequency        = C.Frequency
										 ORDER BY s.SelectionDate DESC
										 )  
									 
									 ELSE 0 
									 END
									 
									 ) as TotalBase							

						</cfsavecontent>		
															
						<cf_droptable dbname="NovaQuery" tblname="#SESSION.acc#WorkOrderCharges">	
								
						<!--- we prepare the billable charges by 
						    wo line, unit, glaccount, charged and frequency etc --->

						<cfquery name="qAccounts" 
						    datasource="NovaWorkOrder" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#"
							timeout="#scripttimeout#">
							SELECT DISTINCT C.GlAccount
							FROM     skWorkOrderCharges C INNER JOIN 
							         ServiceItemUnit R ON C.ServiceItem = R.ServiceItem AND C.ServiceItemUnit = R.Unit
									 INNER JOIN	 Ref_UnitClass U ON U.Code = R.UnitClass
							WHERE    C.WorkOrderId = '#woid#'
							AND      C.Currency    = '#cur#'
							<!--- ---------------------------------------------- --->						 
							<!--- ----- select charge >= posting startdate ----- --->
							<!--- ---------------------------------------------- --->
							<cfif getServiceItem.DatePostingCalculate gt getServiceItem.DatePostingStart>							 
							    AND      C.SelectionDate >= '#getServiceItem.DatePostingCalculate#'
							<cfelseif getServiceItem.DatePostingStart neq "">							
							    <!--- an alternate date as of which moment for this mission/service posting data should be started to get information from the charges table --->						    
							    AND      C.SelectionDate >= '#getServiceItem.DatePostingStart#' 		
							<cfelse>		 
								AND      C.SelectionDate >= '#Param.DatePostingCalculate#'
							</cfif>	
																								
							<cfif slaid eq "">
							
								AND      C.SelectionDate <= #SELT#				
							
							<cfelse>
							
								<!--- ATTENTION 1/2: 31/3/2014 Dev
								if we have an SLA we need to prevent
								that lines that have disappeared and swapped by new line
								will contribute for the past monthly value to the
								billing --->
								
								AND  (
									 
									 C.SelectionDate = #SELT#												 
								 
								     )
							</cfif>
						</cfquery>
							

						<cfquery name="qCheck" 
						    datasource="NovaWorkOrder" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#"
							timeout="#scripttimeout#">
								SELECT *
								FROM Accounting.dbo.Ref_Account 
								WHERE GLAccount in (#QuotedValueList(qAccounts.GlAccount)#) 
						</cfquery>	

						<cfif qCheck.recordcount eq 0>
							
							Please check the following GlAccounts:<br>
							#qAccounts.GlAccount#
							<br>

						</cfif>	


															
						<cfquery name="prepareCharges" 
						    datasource="NovaWorkOrder" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#"
							timeout="#scripttimeout#">
							
							#preserveSingleQuotes(chargescalc)#
							 
							INTO     userQuery.dbo.#SESSION.acc#WorkOrderCharges
					 
							FROM     skWorkOrderCharges C INNER JOIN 
							         ServiceItemUnit R ON C.ServiceItem = R.ServiceItem AND C.ServiceItemUnit = R.Unit
									 INNER JOIN	 Ref_UnitClass U ON U.Code = R.UnitClass
							WHERE    C.WorkOrderId = '#woid#'
							AND      C.Currency    = '#cur#'
							
							<!--- has a valid GL account --->
							
							AND      C.GLAccount IN (SELECT GLAccount 
							                         FROM   Accounting.dbo.Ref_Account 
													 WHERE  GLAccount = C.GLAccount)
							
							<!--- ---------------------------------------------- --->						 
							<!--- ----- select charge >= posting startdate ----- --->
							<!--- ---------------------------------------------- --->
							
							<cfif getServiceItem.DatePostingCalculate gt getServiceItem.DatePostingStart>							 
							    AND      C.SelectionDate >= '#getServiceItem.DatePostingCalculate#'
							<cfelseif getServiceItem.DatePostingStart neq "">							
							    <!--- an alternate date as of which moment for this mission/service posting data should be started to get information from the charges table --->						    
							    AND      C.SelectionDate >= '#getServiceItem.DatePostingStart#' 		
							<cfelse>		 
								AND      C.SelectionDate >= '#Param.DatePostingCalculate#'
							</cfif>	
																								
							<!--- -------------------------------------99--------- --->					
							<!--- only charges equal or before the selection date- --->				
							<!--- ------------------------------------------------ --->	
							
							<cfif slaid eq "">
							
								AND      C.SelectionDate <= #SELT#				
							
							<cfelse>
							
								<!--- ATTENTION 1/2: 31/3/2014 Dev
								if we have an SLA we need to prevent
								that lines that have disappeared and swapped by new line
								will contribute for the past monthly value to the
								billing --->
								
								AND  (
									 
									 C.SelectionDate = #SELT#												 
								 
								     )
							</cfif>
							
							<!--- ------------------------------------------------ --->
							<!--- ------------------------------------------------ --->	
							
							GROUP BY C.WorkorderId,
							         C.Currency,
									 C.WorkorderLine,
									 C.ServiceItemUnit,
									 R.UnitDescription,	
							         U.Code,
							         U.Description, 
									 C.GLAccount, 
									 C.Frequency,
									 C.Charged 
									 
							ORDER BY C.WorkorderLine		 						 
									 
						</cfquery>							





					<!--- ---------------------------------------- --->
				    <!--- 29/03/SLA correction to the billing file --->	
					<!--- ---------------------------------------- --->											
					
					<cfif slaid neq "">		
					
						<!---					
					    	define the sla NN quantity for a per unit
							adjust the total to 0 for NN records
							the remaining keep the amount
					    --->								
										
						<cfquery name="UnitsSLA" 
						    datasource="NovaWorkOrder" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#"
							timeout="#scripttimeout#">
								SELECT   ServiceItemUnit,
								         SUM(R.Quantity) AS QuantitySLA,
										 SUM(R.Amount)   AS ValueSLA
								FROM     WorkOrderBaseLineDetail R
								
								<!--- selected agreement for a workorder --->
								WHERE    R.TransactionId IN (#preservesinglequotes(slaid)#)			
											
								GROUP BY ServiceItemUnit							
						</cfquery>
												
						<!--- ATTENTION 2/2 : 31/3/2014 Dev
						We need a correction for wo-lines that were already additionally 
						charged in a prior month but fall under SLA in the current month as 
						other lines fell off, we need to make sure that these charges are
						NOT corrected --->										
						
						<cfloop query="UnitsSLA">
						
							<cfparam name="agreedcorrection.#serviceItemUnit#" default="0">		
						
							<cfif UnitsSLA.QuantitySLA gte "1">
							
							    <!--- we determine if there are any billed charges until today that
								should NOT be forgotten and thus be added to the value of the SLA --->
								
								<cfset SLAAmount = ValueSLA + agreedcorrection[serviceItemUnit]>								
														
								<!--- check ho many business lines we have to be charged for this unit --->
								
								<cfquery name="getLines" 
								    datasource="NovaWorkOrder" 
								    username="#SESSION.login#" 
								    password="#SESSION.dbpw#"
									timeout="#scripttimeout#">
									SELECT * 
									FROM  userQuery.dbo.#SESSION.acc#WorkOrderCharges									
									WHERE ServiceItemUnit = '#serviceItemUnit#'
									AND   Total > 0
									AND   Frequency = 'Month'
									AND   Charged   = '1' <!--- only business charges --->																
								</cfquery>
																
								<cfif getLines.recordcount gte "1">
																								
									<cfif getLines.recordcount lt QuantitySLA>
									    <!--- if the quantity is lower than the SLA, 
										   we increase the baseprice so we still reach the SLA --->										
										<cfset base = SLAAmount/getLines.recordcount>
																
									<cfelse>									   	
										<cfset base = SLAAmount/QuantitySLA>									
									</cfif>	
							
									<cfquery name="setUnitsCoveredBySLA" 
									    datasource="NovaWorkOrder" 
									    username="#SESSION.login#" 
									    password="#SESSION.dbpw#"
										timeout="#scripttimeout#">
										UPDATE TOP (#QuantitySLA#) userQuery.dbo.#SESSION.acc#WorkOrderCharges
										SET    TotalBase = '#base#',
										       Frequency = 'Year'  <!--- calculated SLA --->
										WHERE  ServiceItemUnit = '#serviceItemUnit#'
										AND    Total > 0
										AND    Frequency = 'Month'
										AND    Charged = '1' <!--- only business charges --->																
									</cfquery>
								
								</cfif>
								
								<!--- if we have a overcharge we need to determine this and carry it forwards 
								so it can be adjusted in the SLA  --->
																								
								<cfquery name="getOverCharge" 
								    datasource="NovaWorkOrder" 
								    username="#SESSION.login#" 
								    password="#SESSION.dbpw#"
									timeout="#scripttimeout#">
									SELECT ISNULL(ROUND(SUM(Total),0),0) as OverCharge 
									FROM   userQuery.dbo.#SESSION.acc#WorkOrderCharges									
									WHERE  ServiceItemUnit = '#serviceItemUnit#'
									AND    Total > 0
									AND    Frequency = 'Month'
									AND    Charged   = '1' <!--- only business charges --->																
								</cfquery>				
																								
								<cfset agreedcorrection[serviceItemUnit] =  agreedcorrection[serviceItemUnit] + getOverCharge.OverCharge>	
														
							</cfif>
						
						</cfloop>
					
					</cfif>					
								
					<!--- --------------------------------------------------------- --->
					<!--- --------- Ledger Posting line preparation --------------- --->	
					<!--- --------------------------------------------------------- --->			
														
					<!--- Now define CORRECT calculated charges which will have to be matched
					      summed by unit CLASS derrived from the unit for all lines --->
					
					<cfquery name="getAccumulatedChargesForBilling" 
					    datasource="NovaWorkOrder" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#"
						timeout="#scripttimeout#">
					
						SELECT    UnitClass, 	
							      ClassDescription,
								  GLAccount, 
								  Charged,  							 
								  round(SUM(Total),2) as Total,
								  round(SUM(Total),2) as TotalCorrected <!--- nothing to be corrected --->
								  
						FROM      userQuery.dbo.#SESSION.acc#WorkOrderCharges
						
						WHERE     Frequency IN ('Once','Month')
						
						GROUP BY  UnitClass, 
							      ClassDescription, 
								  GLAccount, 
								  Charged									
								  
						UNION ALL
						
						SELECT    UnitClass, 	
							      ClassDescription,
								  GLAccount, 
								  Charged,  							 
								  round(SUM(Total),2) as Total,
								  <!--- this reflects the total if you charge upfront for a period longer than one month 
								  so in case of a quarter is will be 30, 30, 30, 60, 60, 60 base is 30, per month = 10
								  --->
								  round(SUM(CEILING(Total/TotalBase) * TotalBase),2) as TotalCorrected	
								  
						FROM      userQuery.dbo.#SESSION.acc#WorkOrderCharges
						
						WHERE     Frequency IN ('Quarter','Year')
						
						GROUP BY  UnitClass, 
							      ClassDescription, 
								  GLAccount, 
								  Charged		

					</cfquery>		
				

					<!--- -------------------------- --->
					<!--- to be based on the service --->
					<!--- -------------------------- --->										
										
					<cfif getServices.modeglaccount eq "0">
											
						<!--- aggregate on the unit level as we define the posting as part of the threshold --->
						
						<cfquery name="getAccumulatedChargesForBilling" dbtype="query">
						
							SELECT    UnitClass, 	
								      ClassDescription,											  						  
									  Charged,  			
									  '' as GLAccount,				 
									  SUM(Total) as Total,
									  SUM(TotalCorrected) as TotalCorrected <!--- nothing to be corrected --->
									  
							FROM      getAccumulatedChargesForBilling
													
							GROUP BY  UnitClass, 
								      ClassDescription, 								 
									  Charged						
											
						</cfquery>	
						
						<cfquery name="priorLedgerPosting" 
					    datasource="NovaLedger" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#"
						timeout="#scripttimeout#">
						
						SELECT    L.ReferenceNo AS UnitClass, 						         
								  L.TransactionType
								  
						FROM      TransactionHeader H INNER JOIN
	                    		  TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
								  Ref_Account A ON L.GlAccount = A.GLAccount
								  
						WHERE     H.Journal IN (SELECT  Journal
				                                FROM    WorkOrder.dbo.ServiceItemMission
				                                WHERE   Mission = '#url.mission#') 
												
						AND       H.ReferenceId   = '#woid#' 
						AND       H.Currency      = '#cur#'
						AND		  A.AccountClass  = 'Result'
						AND		  H.TransactionSource =  'WorkOrderSeries'
						<!---AND 	  H.RecordStatus = '1'--->
											
						<!--- filter by document date --->					
						
						<!--- NEW Jdiaz 2014-03-13. validate the following before enable--->
						AND 	  H.DocumentDate >= 
							(
									SELECT DatePostingCalculate
		                            FROM   WorkOrder.dbo.ServiceItemMission
								    WHERE  ServiceItem = '#ProcessService#'
								    AND    Mission     = '#url.mission#'
							)
						
									
						GROUP BY  L.ReferenceNo, 						        
								  L.TransactionType
						</cfquery>
						
						<cfloop query="priorLedgerPosting">
						
						<!--- check if combination exisits and if not we add it to the query object --->
						
							<cfif TransactionType eq "Standard">
								<cfset charged = "1">
							<cfelse>
								<cfset charged = "2">
							</cfif>
						
							<cfquery name="check" dbtype="query">
								SELECT    *
								FROM      getAccumulatedChargesForBilling
								WHERE     UnitClass = '#unitclass#'								
								AND       Charged   = '#charged#'
							</cfquery>						
						
							<cfif check.recordcount eq "0">
								
								<cfset temp = queryaddrow(getAccumulatedChargesForBilling, 1)>							
								<!--- set values in cells --->
								<cfset temp = querysetcell(getAccumulatedChargesForBilling, "UnitClass", "#Unitclass#")>
								<cfset temp = querysetcell(getAccumulatedChargesForBilling, "Charged", "#charged#")>
								<cfset temp = querysetcell(getAccumulatedChargesForBilling, "Total", "0")>
								<cfset temp = querysetcell(getAccumulatedChargesForBilling, "TotalCorrected", "0")>						
							
							</cfif>
											
						</cfloop>		  
													
						<cfquery name="getThreshold" 
					    datasource="NovaWorkOrder" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#"
						timeout="#scripttimeout#">
						  
						  SELECT *
						  FROM  (						
						
								SELECT   R.GLAccount, 
										 SUM(Amount) AS Threshold,
										
										 
										 (										
										     SELECT ISNULL(SUM(L.TransactionAmount),0) AS Total
										 	 FROM     Accounting.dbo.TransactionHeader H INNER JOIN
											          Accounting.dbo.TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
											 WHERE    H.ReferenceId     = '#woid#'
											 AND      H.Journal         = '#getserviceitem.journal#'	    
											 AND      H.Currency        = '#cur#'
											 <!---AND      H.RecordStatus    = '1'--->
																									
												<!--- we only consider billed amounts the refer to a period after the 
													billing base date of that service, this is the actual period to which the
													charge apply --->	
													
											 <cfif getServiceItem.DatePostingCalculate neq "">	
											 AND        H.DocumentDate >= '#getServiceItem.DatePostingCalculate#' 
											</cfif>
											AND   L.GLAccount = R.GLAccount
											GROUP BY L.GLAccount
										 ) as Used,
										 
										 MIN(Priority) as Priority								 									
										 
									
								FROM     WorkOrderFunding F INNER JOIN Ref_Funding R ON F.FundingId = R.FundingId
	
								WHERE    F.WorkOrderId = '#woid#' 
								AND      F.Operational = 1							
								AND      F.Currency    = '#cur#'
								AND      F.DateEffective <= #selt#
								AND      (F.DateExpiration is NULL or F.DateExpiration >= #selt#)	
								GROUP BY R.GLAccount	
							
							  ) as B
							
							ORDER BY B.Priority					
							
						</cfquery>					
																		
						<cfset tot = 0>		
						<cfset post = 0>	
						<cfset ar=ArrayNew(3)>																			



						
						<cfloop query="getAccumulatedChargesForBilling">
						
						     <!--- we deduct that what has already been charged --->
							 
							 <!--- conversion for financials --->
							
							<cfif Charged eq "2">
								<cfset tratype = "Personal">
							<cfelse>
							    <cfset tratype = "Standard"> 
							</cfif>								
																		 
							<cfquery name="PriorPosted" 
						    datasource="NovaWorkOrder" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#"
							timeout="#scripttimeout#">
							
								SELECT   SUM(L.TransactionAmount) AS Total
								
								FROM     Accounting.dbo.TransactionHeader H INNER JOIN
							             Accounting.dbo.TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
										 
								WHERE    H.ReferenceId     = '#woid#'
								AND      H.Journal         = '#getserviceitem.journal#'	    
								AND      H.Currency        = '#cur#'
								AND      L.ReferenceNo     = '#UnitClass#'									
								AND      L.TransactionType = '#tratype#'	
								<!---AND		 H.RecordStatus    = '1'							--->
								
								<!--- we only consider billed amounts the refer to a period after the 
								billing base date of that service, this is the actual period to which the
								charge apply --->	
								
								<cfif getServiceItem.DatePostingCalculate neq "">	
								  AND        H.DocumentDate >= '#getServiceItem.DatePostingCalculate#' 
								</cfif>
																						
								<!--- DocumentDate is the actual date when the correction is applied. --->						  
								  
								AND      H.DocumentDate <= #SELT#						
								
							</cfquery>
							 							 
							 <cfif PriorPosted.total eq "">
								<cfset charge = totalcorrected>
							<cfelse>
								<cfset charge = totalcorrected - PriorPosted.total>
							</cfif>		
																												
							<cfset row = currentrow>
							<cfset fd = 0>
																										
							<cfloop query="getThreshold">
														
								<cfparam name="glcorrection.#glaccount#" default="0">	
								
								<cfif used neq "">		
									<cfset available = Threshold - Used - glcorrection[glaccount]>																	
								<cfelse>								
									<cfset available = Threshold - glcorrection[glaccount]>										
								</cfif>	
																
								<!--- deduct or if this is the last one we take it anyways !!!! --->
																													
								<cfif available gte charge or currentrow eq recordcount>
																								
									<cfset posted   = charge>																									
									<cfset charge   = 0>
																																						
								<cfelse>
									
								   <cfset posted  = available>
								   <!--- add record --->								   
								   <cfset charge  = charge - posted>								   
																	  																		
								</cfif>												
								
								<cfif abs(posted) gte "0.05">
								
									<cfset fd = fd+1>
									<cfset post = "1">
															
									<!--- capture posting --->
									<cfset ar[row][fd][1] = glaccount>				
									<cfset ar[row][fd][2] = posted>		
									
									<cfset tot = tot+posted>												
								
								</cfif>
								
								<cfset glcorrection[glaccount] = glcorrection[glaccount] + posted>	
																						
							</cfloop>	
												
						</cfloop>							
						
						<!--- drop correction --->
						
						<!---<cfset StructClear(glcorrection)>--->
													
					<cfelse>	
											
						<cfquery name="getAccumulatedChargesForBilling" dbtype="query">
						
							SELECT    UnitClass, 	
								      ClassDescription,
									  GLAccount, 
									  Charged,  							 
									  SUM(Total) as Total,
									  SUM(TotalCorrected) as TotalCorrected <!--- nothing to be corrected --->
									  
							FROM      getAccumulatedChargesForBilling
													
							GROUP BY  UnitClass, 
								      ClassDescription, 
									  GLAccount, 
									  Charged						
											
						</cfquery>												
						
						<!--- ---1. POSTING PREPARATION correction for :: getAccumulatedChargesForBilling-- --->
						
						<!--- NEW Dev 12/10/2013 we determine the combinations that exist for this
							workorder and that no longer exist in the charges to ensure the 
							charges are corrected 
							for service unit Class, GL account and charge (P/B) for this workorder
								
								--------------------------------------------------------------------------- --->							
						<!--- ----------------------------------------------------------------------------- --->
						
						<cfquery name="priorLedgerPosting" 
					    datasource="NovaLedger" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#"
						timeout="#scripttimeout#">
						
						SELECT    L.ReferenceNo AS UnitClass, 
						          L.GLAccount, 
								  L.TransactionType
								  
						FROM      TransactionHeader H INNER JOIN
	                    		  TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
								  Ref_Account A ON L.GlAccount = A.GLAccount
								  
						WHERE     H.Journal IN (SELECT  Journal
				                                FROM    WorkOrder.dbo.ServiceItemMission
				                                WHERE   Mission = '#url.mission#') 
												
						AND       H.ReferenceId   = '#woid#' 
						AND       H.Currency      = '#cur#'
						AND		  A.AccountClass  = 'Result'
						AND		  H.TransactionSource =  'WorkOrderSeries'
						
						<!---AND		  H.RecordStatus  = '1'					--->
						<!--- filter by document date --->					
												
						AND 	  H.DocumentDate >= 
							(
									SELECT DatePostingCalculate
		                            FROM   WorkOrder.dbo.ServiceItemMission
								    WHERE  ServiceItem = '#ProcessService#'
								    AND    Mission     = '#url.mission#'
							)
						
									
						GROUP BY  L.ReferenceNo, 
						          L.GLAccount, 
								  L.TransactionType 
						</cfquery>		
						
						<!--- check if combination exists and if not we add it to the query object so we have all valid combination --->				
											
						<cfloop query="priorLedgerPosting">
												
							<cfif TransactionType eq "Standard">
								<cfset charged = "1">
							<cfelse>
								<cfset charged = "2">
							</cfif>
						
							<cfquery name="check" dbtype="query">
								SELECT    *
								FROM      getAccumulatedChargesForBilling
								WHERE     UnitClass = '#unitclass#'
								AND       GLAccount = '#GLAccount#'
								AND       Charged   = '#charged#'
							</cfquery>						
						
							<cfif check.recordcount eq "0">
								
								<cfset temp = queryaddrow(getAccumulatedChargesForBilling, 1)>							
								<!--- set values in cells --->
								<cfset temp = querysetcell(getAccumulatedChargesForBilling, "UnitClass", "#Unitclass#")>
								<cfset temp = querysetcell(getAccumulatedChargesForBilling, "GLAccount", "#GLAccount#")>
								<cfset temp = querysetcell(getAccumulatedChargesForBilling, "Charged", "#charged#")>
								<cfset temp = querysetcell(getAccumulatedChargesForBilling, "Total", "0")>
								<cfset temp = querysetcell(getAccumulatedChargesForBilling, "TotalCorrected", "0")>						
							
							</cfif>
											
						</cfloop>		  
						
						<!--- ---------------------------------------------------------------------------- --->
						<!--- -------------	end making a vanishing correction in the lines --------------- --->
						<!--- ---------------------------------------------------------------------------- --->
																		
						<cfset post = "0">
						<cfset tot  = "0">


						<cfloop query="getAccumulatedChargesForBilling">	
						
							<!--- is grouped by unit UNIT CLASS;  CHARGE TYPE AND ACCOUNT
							 we then compare with the posting todate --->	
																			
							<cfset totalcharge = TotalCorrected>	
							
							<!--- conversion for financials --->
							
							<cfif Charged eq "2">
								<cfset tratype = "Personal">
							<cfelse>
							    <cfset tratype = "Standard"> 
							</cfif>												
													
							<!--- now we will define how much was already posted in prior periods for this service/workorder 
							by unitclass and then we decide if we need to issue an invoice for the difference in the financials --->
										
							<cfquery name="Posted" 
						    datasource="NovaWorkOrder" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#"
							timeout="#scripttimeout#">
							
								SELECT   SUM(L.TransactionAmount) AS Total
								
								FROM     Accounting.dbo.TransactionHeader H INNER JOIN
							             Accounting.dbo.TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
										 
								WHERE    H.ReferenceId     = '#woid#'
								AND      H.Journal         = '#getserviceitem.journal#'	    
								AND      H.Currency        = '#cur#'
								AND      L.ReferenceNo     = '#UnitClass#'	
								AND      L.GLAccount       = '#GLAccount#' 
								AND      L.TransactionType = '#tratype#'	
								<!---AND H.RecordStatus    = '1' --->
								
								<!--- we only consider billed amounts the refer to a period after the 
								billing base date of that service, this is the actual period to which the
								charge apply --->	
								
								<cfif getServiceItem.DatePostingCalculate neq "">	
								  AND        H.DocumentDate >= '#getServiceItem.DatePostingCalculate#' 
								</cfif>
																						
								<!--- DocumentDate is the actual date when the correction is applied. --->						  
								  
								AND      H.DocumentDate <= #SELT#						
								
							</cfquery>

													
							<cfif posted.total eq "">
								<cfset diff = totalcharge>
							<cfelse>
								<cfset diff = totalcharge - posted.total>
							</cfif>		

																					
							<!--- --------------------------------------------------------------------------------------------- --->		
							<!--- --------------------------------------------------------------------------------------------- --->
										
							<!--- rounding the figure --->
							<cfset diff = round(diff*100)/100>
														
							<cfif abs(diff) gte "0.05">		
							    <!--- prepare the amounts for posting into an array --->			
								<cfset ar[currentrow] = diff>
								<cfset post = "1">							
								<!--- define an overall total for the header --->
								<cfset tot = tot+diff>
							<cfelse>
								<cfset ar[currentrow] = 0>
							</cfif>							
																		
						</cfloop>	
						
					</cfif>										
					
					<!--- --------------------------------- --->
					<!--- ---- Start Posting financials --- --->
					<!--- --------------------------------- --->				
					
					<cfquery name="Period" 
					    datasource="NovaLedger" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#"
						timeout="#scripttimeout#">
							SELECT   TOP 1 *
							FROM     Period
							WHERE    ActionStatus = '0'
							AND      PeriodDateStart <= #sel#
							ORDER BY PeriodDateStart DESC					
					</cfquery>
										
					<cfset JTransNo = "">

							
					<cfif post eq "1">			
					

							<!--- post the header amounts under one header and several limes --->
							
							<cf_GledgerEntryHeader
							    DataSource            = "NovaWorkOrder"
								Mission               = "#url.Mission#"
								OrgUnitOwner          = ""
								AccountPeriod         = "#Period.AccountPeriod#"
								Journal               = "#getserviceitem.journal#"			
								JournalTransactionNo  = ""						
								Description           = "#getserviceitem.description#"
								TransactionSource     = "WorkOrderSeries"			
								TransactionCategory   = "Receivables"
								MatchingRequired      = "1"
								ActionStatus		  = "1"
								ReferenceOrgUnit      = "#customer.orgunit#"			
								Reference             = "Service Charge"       
								ReferenceId           = "#woid#"
								ReferenceName         = "#customer.customername#"
								DocumentCurrency      = "#cur#"
								ActionBefore          = "#DateFormat(due,CLIENT.DateFormatShow)#"
								DocumentDate          = "#DateFormat(selt,CLIENT.DateFormatShow)#" 
								JournalBatchDate      = "#DateFormat(selend,CLIENT.DateFormatShow)#"
								DocumentAmount        = "#tot#">	
								
								<!--- AR line --->				
								
								<cf_GledgerEntryLine
							        DataSource            = "NovaWorkOrder"
									Lines                 = "1"
								    Journal               = "#getserviceitem.journal#"		
									JournalNo             = "#JournalTransactionNo#"	
									AccountPeriod         = "#Period.AccountPeriod#"		
									Currency              = "#cur#"					
									TransactionSerialNo1  = "0"
									Class1                = "Credit"
									Reference1            = "Standard"       
									ReferenceName1        = "#getserviceitem.description#"
									Description1          = "Receivable"
									GLAccount1            = "#Journal.GLAccount#"
									Costcenter1           = ""
									ProgramCode1          = ""
									ProgramPeriod1        = ""
									ReferenceId1          = "#woid#"
									ReferenceNo1          = "#customer.customername#"
									TransactionType1      = "Standard"
									Amount1               = "#tot#">
																		
									<!--- Newly added : now we have defined the total for the workorder line, unitcharge and class we are capturing the same total for the
									line evels as well in TransactionHeaderWorkOrder 																	
																									
									we have to make sure the total is the same
									
									- we run a query that generates all combinations									
									- we determine the amount per line amount corrected and deduct the prior -																		
									- we compare the total with #tot# and cater for a workorderline = NULLL correction.															
																	
									--->
																	
									<cfif getServices.modeglaccount eq "1">
									
										<cfquery name="addDetailsUnderHeader" 
									    datasource="NovaLedger" 
									    username="#SESSION.login#" 
									    password="#SESSION.dbpw#"
										timeout="#scripttimeout#">
										
										INSERT INTO Accounting.dbo.TransactionHeaderWorkOrder
										
										(Journal,JournalSerialNo,
										 JournalBatchDate,SelectionDate,
										 WorkOrderId,WorkOrderLine,UnitClass,Charged,
										 Currency,TransactionAmount,
										 OfficerUserId,OfficerLastName,OfficerFirstName)
																			
										SELECT   '#getserviceitem.journal#',
										         '#JournalTransactionNo#',
											      #selend#    as JournalBatchDate,
											      #selt#      as SelectionDate,
											      WorkOrderId, WorkOrderLine, UnitClass, Charged,'#cur#' as Currency,
											      TotalCorrected - Posted as TransactionAmount,
												  '#session.acc#','#session.last#','#session.first#'										   								
										
										FROM (
										
												<!--- line combinatinos new and line combinations found in the billing file, Once and Month --->
										
												SELECT     WorkOrderId, WorkOrderLine, UnitClass, Charged, round(SUM(Total), 2) AS TotalCorrected,
								                          (SELECT   ISNULL(SUM(TransactionAmount),0)
								                            FROM    Accounting.dbo.TransactionHeaderWorkOrder
								                            WHERE   WorkOrderId   = C.WorkOrderId
															AND     WorkOrderLine = C.WorkOrderLine 
															AND     UnitClass     = C.UnitClass 
															AND     Charged       = C.Charged 
															AND     Currency      = '#cur#'
															
															<cfif getServiceItem.DatePostingCalculate neq "">	
															AND     SelectionDate >= '#getServiceItem.DatePostingCalculate#' 
															</cfif>														  
															AND     SelectionDate <= #SELT#				
															
															) AS Posted
														
												FROM      userQuery.dbo.#SESSION.acc#WorkOrderCharges C
												WHERE     Frequency IN ('Once', 'Month')
												GROUP BY WorkOrderId, WorkOrderLine, UnitClass, Charged
			
												UNION
												
												<!--- line combinatinos new and line combinations found in the billing file, Quater and Year --->
												
												SELECT     WorkOrderId, WorkOrderLine, UnitClass, Charged, round(SUM(CEILING(Total / TotalBase) * TotalBase), 2) AS TotalCorrected,
								                          (SELECT    ISNULL(SUM(TransactionAmount),0)
			    	            				           FROM      Accounting.dbo.TransactionHeaderWorkOrder
							                               WHERE     WorkOrderId = C.WorkOrderId 
														   AND       WorkOrderLine = C.WorkOrderLine 
														   AND       UnitClass = C.UnitClass 
														   AND       Charged = C.Charged 
														   AND       Currency = '#cur#'
														   <cfif getServiceItem.DatePostingCalculate neq "">	
														   AND       SelectionDate >= '#getServiceItem.DatePostingCalculate#' 
														   </cfif>														  
														   AND       SelectionDate <= #SELT#				
															) AS Posted
														   
												FROM      userQuery.dbo.#SESSION.acc#WorkOrderCharges C
												WHERE     Frequency IN ('Year', 'Quarter')
												
												GROUP BY  WorkOrderId, WorkOrderLine, UnitClass, Charged
			
												UNION
												
												<!--- line combinatinos only found in prior postings --->
												
												SELECT     WorkorderId, WorkorderLine, UnitClass, Charged, 0 AS TotalCorrected, SUM(TransactionAmount) AS Posted
												
												FROM       Accounting.dbo.TransactionHeaderWorkOrder S
												WHERE     (NOT EXISTS
									                          (SELECT   'X'
									                            FROM    userQuery.dbo.#SESSION.acc#WorkOrderCharges
									                            WHERE   WorkOrderId   = S.WorkOrderId 
																AND     WorkOrderLine = S.WorkOrderLine 
																AND     UnitClass     = S.UnitClass 
																AND     Charged       = S.Charged)) 
												AND       WorkorderId   = '#woid#' 
												AND       Currency      = '#cur#'
												<cfif getServiceItem.DatePostingCalculate neq "">	
												AND       SelectionDate >= '#getServiceItem.DatePostingCalculate#' 
												</cfif>														  
												AND       SelectionDate <= #SELT#													
												

												GROUP BY WorkorderId, WorkorderLine, UnitClass, Charged
												) CC
												
												 WHERE ABS(TotalCorrected - Posted) > 0
												
										</cfquery>
										
										<!--- now we check if the total matches with the tot amount and make a correction --->
										
										<cfquery name="getHeaderTotal" 
									    datasource="NovaLedger" 
									    username="#SESSION.login#" 
									    password="#SESSION.dbpw#">
										
											SELECT ISNULL(SUM(TransactionAmount),0) as Total
											FROM   TransactionHeaderWorkOrder
											WHERE  JournalBatchDate = #selend#
											AND    SelectionDate    = #selt#
											AND    WorkOrderId        = '#woid#'
											AND    Currency         = '#cur#'
										
										</cfquery>
										
										<cfif abs(getHeaderTotal.Total - tot) gte 0.05>
										
											<cfset diff = tot - getHeaderTotal.Total>
											
											<cfquery name="setDifference" 
										    datasource="NovaLedger" 
										    username="#SESSION.login#" 
										    password="#SESSION.dbpw#">									
												INSERT INTO TransactionHeaderWorkOrder
											
												(Journal,JournalSerialNo,
												 JournalBatchDate,SelectionDate,
												 WorkOrderId,WorkOrderLine,UnitClass,Charged,
												 Currency,TransactionAmount)									 
											 
											    VALUES ('#getserviceitem.journal#',
												    	 '#JournalTransactionNo#',
 		  											     #selend#,
	 										             #selt#,
													     '#woid#',
													     '0',
													     'Undefined',
													     '1',
													     '#cur#',
													     '#diff#'
												 )				
													 
											</cfquery>		 
																						
										</cfif>
									
									</cfif>
										
									<!--- ------------------------------------------------------------- --->
									<!--- we have 2 modes of posting pushed account, threshold accounts --->										
									<!--- -------loop through the lines of the source file------------- --->		
																	
									<cfloop query="getAccumulatedChargesForBilling">	
										
										<!--- Lines of the invoice itself --->
												
										<cfif Charged eq "2">
											 <cfset tratype = "Personal">												
										<cfelse>
											 <cfset tratype = "Standard"> 
										</cfif>
										
										<cfif getServices.modeglaccount eq "0">
										
											<cfloop index="fld" array="#ar[currentrow]#">
											
												<cfif abs(fld[2]) gt "0.02">
												
													<cf_GledgerEntryLine
														    DataSource            = "NovaWorkOrder"
															Lines                 = "1"
														    Journal               = "#getserviceitem.journal#"			
															JournalNo             = "#JournalTransactionNo#"	
															AccountPeriod         = "#Period.AccountPeriod#"		
															Currency              = "#cur#"										
															TransactionSerialNo1  = "#currentrow#"
															Class1                = "Debit"
															Reference1            = "Charges"       
															ReferenceName1        = "#ClassDescription#"
															Description1          = "Charges for #getserviceitem.description#"
															GLAccount1            = "#fld[1]#"
															Costcenter1           = ""
															ProgramCode1          = ""
															ProgramPeriod1        = ""
															ReferenceId1          = "#woid#"
															ReferenceNo1          = "#UnitClass#"
															TransactionType1      = "#tratype#"
															Amount1               = "#fld[2]#">		
														
												</cfif>														
											
											</cfloop>															
										
										<cfelse>			
									
											<cfif abs(ar[currentrow]) gt "0.05">											
										  													
												<cf_GledgerEntryLine
												    DataSource            = "NovaWorkOrder"
													Lines                 = "1"
												    Journal               = "#getserviceitem.journal#"			
													JournalNo             = "#JournalTransactionNo#"	
													AccountPeriod         = "#Period.AccountPeriod#"		
													Currency              = "#cur#"										
													TransactionSerialNo1  = "#currentrow#"
													Class1                = "Debit"
													Reference1            = "Charges"       
													ReferenceName1        = "#ClassDescription#"
													Description1          = "Charges for #getserviceitem.description#"
													GLAccount1            = "#GLAccount#"
													Costcenter1           = ""
													ProgramCode1          = ""
													ProgramPeriod1        = ""
													ReferenceId1          = "#woid#"
													ReferenceNo1          = "#UnitClass#"
													TransactionType1      = "#tratype#"
													Amount1               = "#ar[currentrow]#">															
																									
											</cfif>													
																					
										</cfif>											
																				
										<cfset JTransNo = JournalTransactionNo>	
												 
								  </cfloop>		
								  
						</cfif>  												

																
				</cfloop>
				
				<!--- selection date --->	 
				
			</cfoutput>	<!--- currency within the workorder --->	
			
	</cfif>			

	<cfif cnt eq "100">
						
		<cf_ScheduleLogInsert
	   		ScheduleRunId  = "#schedulelogid#"
			Description    = "Posting Invoices for workorders #currentrow#/#recordcount#">
				
		<cfset cnt = 0>

	</cfif>

</cfloop>		
	
<!--- --------------------------------------------- --->	
<!--- --------------------------------------------- --->
<!--- posting of the amounts for payroll recovery-- --->
<!--- --------------------------------------------- --->
<!--- --------------------------------------------- --->

<cfparam name="url.mission" default="OICT">

<!--- ----------------------------------------- --->
<!--- 2012-05-21 JDiaz. Generate the memo files --->
<!--- ----------------------------------------- --->
<!---
<cfparam name="url.memo" default="0">
<cfif url.Memo eq "1">
	<cfinclude template="FinancialsMemo.cfm">
</cfif>
--->
<cfoutput>#now()# : #tp# personal</cfoutput>