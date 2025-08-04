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

<cfset dateValue = "">
<CF_DateConvert Value="#dateformat(SelDate.SelectionDateEffective,CLIENT.DateFormatShow)#">
<cfset SEL = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#dateformat(SelDate.SelectionDateExpiration,CLIENT.DateFormatShow)#">
<cfset Selend = dateValue>

<!---
<cfset sel     = CreateDate(Year(sel),Month(sel),1)>
<cfset selend  = CreateDate(Year(sel),Month(sel),DaysInMonth(sel))>
--->

<cfif url.posting eq "1">
   
	<!--- ------------------------------------------------------------------------- --->	
	<!--- clear any batch posting for THIS mission, service and posting month ----- --->
	<!--- REASON : we are going to record this financials again for this period---- ---> 
	<!--- this means we are taking out the invoices and redo them : carefull here-- --->
	<!--- ------------------------------------------------------------------------- --->
<!-----
Removed  by Armin on October 2 2016
	<cfquery name="DeleteInvoiceDetails" 
		datasource="NovaLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
			DELETE FROM Accounting.dbo.TransactionHeaderWorkOrder
			WHERE  ServiceItem	= '#ProcessService#'		
			AND    _BatchDate = #selend#
	</cfquery>
---->	
			
	<cfquery name="ClearAnyPostingThisMonth" 
	  datasource="NovaWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#"
	  timeout="#scripttimeout#">
		DELETE FROM Accounting.dbo.TransactionHeader
		WHERE  Mission              = '#url.mission#'
		AND    TransactionCategory  = 'Receivables'
		AND    ReferenceId IN (SELECT WorkorderId 
		                       FROM   Workorder 
							   WHERE  Mission      = '#url.mission#' 
							   AND    ServiceItem  = '#ProcessService#')	
		AND    TransactionSource    = 'WorkOrderSeries'
		AND    JournalBatchDate    >= #sel#		
		AND    JournalBatchDate    <= #selend#
	</cfquery>		
	
	
</cfif>
	
<cfset curyear  = year(sel)>
<cfset curmonth = month(sel)>

<cfquery name    = "Param"
	 datasource = "NovaWorkOrder"
	 username   = "#SESSION.login#"
	 password   = "#SESSION.dbpw#"
	 timeout="#scripttimeout#">	
			  SELECT   * 
			  FROM     ServiceItemMission
			  WHERE    Mission      = '#URL.Mission#'
			  AND      ServiceItem  = '#ProcessService#'			  
</cfquery>	 

<cfif Param.DateChargesCalculate eq "">
	
	<cfquery name    = "Param"
	     datasource = "NovaWorkOrder"
	     username   = "#SESSION.login#"
	     password   = "#SESSION.dbpw#"
		 timeout="#scripttimeout#">	
		  SELECT * 
		  FROM   Ref_ParameterMission 
		  WHERE  Mission = '#URL.Mission#'
	</cfquery>	 

</cfif>

<!--- we are building up the charges from scratch as of a certain date each time --->

<cfset startyear  = year(Param.DateChargesCalculate)>
<cfset startmonth = month(Param.DateChargesCalculate)> 
	
<cfset cnt = 0>
<cfset tp  = 0>

<!--- step 1 retrieve workorder to be processed for billing which have one or more valid lines for the effective date --->

<cfquery name    = "workorder"
     datasource = "NovaWorkOrder"
     timeout="#scripttimeout#"
     username   = "#SESSION.login#"
     password   = "#SESSION.dbpw#">
  
	SELECT  W.*
	FROM    WorkOrder W
	INNER JOIN Customer C ON C.CustomerId = W.CustomerId
	WHERE   W.Mission = '#url.mission#'
	
	AND     W.WorkorderId IN (SELECT WorkOrderId 
	                        FROM   WorkorderLine
							WHERE  DateEffective <= #selend#
						    AND    (DateExpiration >= #selend# or DateExpiration is NULL)
							AND    Operational = 1)		
	
	AND     W.ServiceItem = '#processService#'	
	ORDER BY C.CustomerName DESC, W.WorkOrderId



</cfquery>		

<cfif workorder.recordcount eq "0">
	
	<cf_ScheduleLogInsert
	 	ScheduleRunId  = "#schedulelogid#"
		Description    = "Select orders to be processed"
		StepException  = "Problem nt orders found to be processed"
		StepStatus     = "9"
		abort          = "Yes">		
	
		<cfabort>	

<cfelse>

		<cfset wosel = quotedValueList(workorder.workorderid)>
		
</cfif>	


<!--- JDiaz. 2015-06-20.  Check if the workorder corresponds to a SLA.--->
<cfquery name    = "SLAWoid"
     datasource = "NovaWorkOrder"
     username   = "#SESSION.login#"
     password   = "#SESSION.dbpw#"
     timeout="#scripttimeout#">	
	 SELECT *
	 FROM WorkOrderBaseLine
	 WHERE WorkOrderId IN (#PreserveSingleQuotes(wosel)#)
</cfquery>	 

<!--- -------------------------------------------------------- --->
<!--- clean charges table : PendingTuning for more incremental --->
<!--- -------------------------------------------------------- --->

<cfquery name="cleanEntriesAfterCutoff" 
   datasource="NovaWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#"
   timeout="#scripttimeout#">
	DELETE FROM skWorkOrderCharges
	WHERE  WorkOrderId IN (SELECT WorkorderId 
	                       FROM   WorkOrder 
						   WHERE  Mission     = '#url.mission#' 
						   AND    ServiceItem = '#processService#')
	<!--- the field prevents recalculation of sk charges for older period which do not change anymore --->
	AND    SelectionDate >= '#Param.DateChargesCalculate#' 	
</cfquery>				


<cfquery name    = "SelDate"
     datasource = "NovaWorkOrder"
     username   = "#SESSION.login#"
     password   = "#SESSION.dbpw#"
     timeout="#scripttimeout#">	
	  SELECT   * 
	  FROM     ServiceItemMissionPosting
	  WHERE    Mission      = '#URL.Mission#'
	  AND      ServiceItem = '#ProcessService#'
	  AND      SelectionDateEffective >= '#Param.DateChargesCalculate#'
	  AND	   SelectionDateExpiration <= #Selend#
	  ORDER BY SelectionDateExpiration
</cfquery>	 

	<cfloop query="SelDate">
		
		<cfset sel    = Createdate(year(SelectionDateEffective), month(SelectionDateEffective),day(SelectionDateEffective))>				
		<cfset selend = Createdate(year(SelectionDateExpiration), month(SelectionDateExpiration),day(SelectionDateExpiration))>	
		<cfset cutoff = sel>

		<cfset yr = year(sel)>
		<cfset mt = month(sel)>

		<cf_ScheduleLogInsert
   		ScheduleRunId  = "#schedulelogid#"
		Description    = "Calculating Charges #yr#/#mt#">
								
		<cfif seldate.CutOffDate neq "">
			<cfset cutoff    = Createdate(year(seldate.CutOffDate), month(seldate.CutOffDate),day(seldate.CutOffDate))>
		</cfif>
		
		<cfoutput>
		
		<!--- compose the query --->
		
		<cfsavecontent variable="chargesinsert">
		
		INSERT INTO skWorkOrderCharges (
		             WorkOrderId, 
					 WorkOrderLine, 
					 SelectionDate, 
					 ServiceItem, 
					 ServiceItemUnit, 
					 Charged,										 
					 Currency,
					 BillingMode,
					 PersonNo,
					 Amount,
					 Frequency,
					 AmountBase)				
		
		</cfsavecontent>
		
		<cfsavecontent variable="billingcondition">
		
		      FROM    WorkOrderLineBillingDetail BD INNER JOIN
                         WorkOrderLineBilling B ON BD.WorkOrderId = B.WorkOrderId AND BD.WorkOrderLine = B.WorkOrderLine AND 
                         BD.BillingEffective = B.BillingEffective INNER JOIN
                         WorkOrderLine L ON B.WorkOrderId = L.WorkOrderId AND B.WorkOrderLine = L.WorkOrderLine

			  <!--- select only wo that needs to be charged --->		  				  
			  WHERE   B.WorkOrderId IN (#preservesinglequotes(wosel)#) 
			  
			  <!--- workorder line billing need it to be valid in this month for the selected cutt-off date --->
			  AND     B.BillingEffective <= #cutoff#
			  AND     (B.BillingExpiration >= #cutoff# OR B.BillingExpiration is NULL)
			  AND     BD.Charged IN ('1','2') <!--- (0 : No, 1 Customer, 2 User --->
			  
			  <!--- and workorder line itself need to be valid in this month for the select cutt-off date --->
			  AND     L.DateEffective <= #cutoff#
			  AND     (L.DateExpiration >= #cutoff# or L.DateExpiration is NULL)
			  AND     L.Operational = 1		
			  
			  <!--- billing mode is defined per unit on the line --->		  
			  AND     BD.BillingMode = 'Line'	
			
		</cfsavecontent>
	
	
		</cfoutput>
		
		<cfset selenduse = DateAdd("h","24", selend)>
				
		<!--- load charges once only billing, so it is charge only in the month of the effective  --->
		<cftry>
			<cfquery name="BillingOnce"
			   datasource="NovaWorkOrder"
			   username="#SESSION.login#"
			   password="#SESSION.dbpw#"
			   timeout="#scripttimeout#">
			   			 
			   	 #preserveSingleQuotes(chargesinsert)#
			
				 SELECT   B.WorkOrderId, 
			              B.WorkOrderLine,		
						  #selend#,										 
						  BD.ServiceItem,				 
						  BD.ServiceItemUnit, 	
						  <!--- added 20/1/2011 --->
						  BD.Charged,				
						  <!--- --------------- --->	 
						  BD.Currency,	
						  'Line',	
						  L.PersonNo, 				 
						  BD.Amount,
						  'Once',
						  BD.Amount		
						  
				 #preserveSingleQuotes(billingcondition)#
				 
				 AND  BD.Frequency = 'Once'						 

				 AND B.BillingEffective >= #sel#
				 AND B.BillingEffective <= #selend#
				  				
			</cfquery>		

			
		<cfcatch>
		
			<cf_ScheduleLogInsert   
			      ScheduleRunId  = "#schedulelogid#"
			      Description    = "Error calculating One-time charges. Process aborted"
			      StepStatus="9"
			      Abort="Yes">
		
		</cfcatch>
		
		</cftry>			
	
		<cftry>
			<cfquery name="BillingSupply"
			   datasource="NovaWorkOrder"
			   username="#SESSION.login#"
			   password="#SESSION.dbpw#"
			   timeout="#scripttimeout#">
			   			 
			   	 #preserveSingleQuotes(chargesinsert)#
				 
				 SELECT  T.WorkOrderId, 
				         T.WorkOrderLine, 
						 #selend#,	
						 W.ServiceItem, 
						 T.BillingUnit, 
						 '1' AS Charged, 
						 '#APPLICATION.BaseCurrency#' AS Currency,
						 'Supply' as BillingMode,
						 NULL,
						 SUM(S.SalesAmount) as Total,
						 'Once',
						 SUM(S.SalesAmount) as Total
						 
				FROM     Materials.dbo.ItemTransaction AS T INNER JOIN
	                     Materials.dbo.ItemTransactionShipping AS S ON T.TransactionId = S.TransactionId INNER JOIN
	                     WorkOrder W ON T.WorkOrderId = W.WorkOrderId INNER JOIN
						 WorkorderLine L ON L.WorkOrderId = T.WorkOrderId AND L.WorkOrderLine = T.WorkorderLine
				WHERE    T.WorkOrderLine IS NOT NULL		
				
				<!--- AND the once only cost needs to be in this month only --->
				
				AND       L.DateEffective <= #cutoff#
				AND       (L.DateExpiration >= #cutoff# or L.DateExpiration is NULL)
				AND       L.Operational = 1						 
				AND       T.TransactionDate  >= #sel#
				AND       T.TransactionDate  < #selenduse#
				AND       T.Mission                = '#url.mission#'	
				AND       W.ServiceItem            = '#ProcessService#' 
				GROUP BY  T.WorkOrderId, 
				          T.WorkOrderLine, 						
						  W.ServiceItem, 
						  T.BillingUnit				 				 			  				  				  
			</cfquery>	
				
		<cfcatch>
		
			<cf_ScheduleLogInsert   
			    ScheduleRunId  = "#schedulelogid#"
			    Description    = "Error calculating supply charges. Process aborted"
			    StepStatus="9"
			    Abort="Yes">
		
		</cfcatch>
		
		</cftry>			

 		<cftry> 
		
		<!--- load charges monthly billing --->	
		<cfquery name="BillingMonth"
		   datasource="NovaWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#"
		   timeout="#scripttimeout#">
		   		  
		   	 #preserveSingleQuotes(chargesinsert)#
		
			 SELECT   B.WorkOrderId, 
		              B.WorkOrderLine,	
					  #selend#,											 
					  BD.ServiceItem,				 
					  BD.ServiceItemUnit,		
					  <!--- added 20/1/2011 --->
					  BD.Charged,				
					  <!--- --------------- --->					
					  BD.Currency,	
					  'Line',	
					  L.PersonNo, 	 				 
					  BD.Amount,
					  'Month',
					  BD.Amount		
					  
			 #preserveSingleQuotes(billingcondition)#
			 
			 AND  BD.Frequency = 'Month'						 				 
			
			<!--- JDiaz. 2015-06-20.  If is SLA, include only approved--->
			<cfif SLAWoid.recordcount gt "0">
				AND BD.WorkOrderId IN (
				
					SELECT WorkOrderId		
					FROM     WorkOrderBaseLine
					WHERE    WorkOrderId IN (#preservesinglequotes(wosel)#) 
					AND      ActionStatus = '3'
																						
					<cfif getServices.DatePostingCalculate neq "">	
						AND      DateEffective >= '#getServices.DatePostingCalculate#' 		
					<cfelse>		 
						AND      DateEffective >= '#Param.DatePostingCalculate#'
					</cfif>												
									)				
			</cfif> 			
		
		</cfquery>	
 		<cfcatch>

		   	<cf_ScheduleLogInsert   
			    ScheduleRunId  = "#schedulelogid#"
			    Description    = "Error calculating Monthly charges. Process aborted"
			    StepStatus="9"
			    Abort="Yes">
		
 		</cfcatch>
		
		</cftry>			
		<!--- <cfoutput>2:#cfquery.executionTime#<br></cfoutput>	--->
		<!--- load month charges based on quarterly billing --->	
		
		<cftry>
		
		<cfquery name="BillingMonth"
		   datasource="NovaWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#"
		   timeout="#scripttimeout#">
		   	 #preserveSingleQuotes(chargesinsert)#
		
			 SELECT   B.WorkOrderId, 
		              B.WorkOrderLine,	
					  #selend#,												 
					  BD.ServiceItem,				 
					  BD.ServiceItemUnit, 	
					  <!--- added 20/1/2011 --->
					  BD.Charged,				
					  <!--- --------------- --->						
					  BD.Currency,		
					  'Line', 
					  L.PersonNo, 					 
					  BD.Amount/3,
					  'Quarter',
					  BD.Amount	
					  
			 #preserveSingleQuotes(billingcondition)#
			 
			 AND  BD.Frequency = 'Quarter'						 				 
							  				  				  
		</cfquery>	
		
		<cfcatch>
			<cf_ScheduleLogInsert   
			      ScheduleRunId  = "#schedulelogid#"
			   Description    = "Error calculating quarterly charges. Process aborted"
			    StepStatus="9"
			    Abort="Yes">
		
		</cfcatch>
		
		</cftry>				
		
		<!---
		<cfoutput>3:#cfquery.executionTime#<br></cfoutput>	
		--->
		
		<!--- load month charges based on yearly billing --->	
		<cftry>
			<cfquery name="BillingYear"
			   datasource="NovaWorkOrder"
			   username="#SESSION.login#"
			   password="#SESSION.dbpw#"
			   timeout="#scripttimeout#">
			   	 #preserveSingleQuotes(chargesinsert)#
			
				 SELECT   B.WorkOrderId, 
			              B.WorkOrderLine,	
						  #selend#,											 
						  BD.ServiceItem,				 
						  BD.ServiceItemUnit, 
						  <!--- added 20/1/2011 --->
						  BD.Charged,				
						  <!--- --------------- --->												 
						  BD.Currency,		
						  'Line', 	
						  L.PersonNo, 	 			 
						  BD.Amount/12,
						  'Year',
						  BD.Amount	
						  
				 #preserveSingleQuotes(billingcondition)#
				 
				 AND  BD.Frequency = 'Year'						 				 
								  				  				  
			</cfquery>		
						
		<cfcatch>
			<cf_ScheduleLogInsert   
			      ScheduleRunId  = "#schedulelogid#"
			    Description    = "Error calculating yearly charges. Process aborted"
			    StepStatus="9"
			    Abort="Yes">
		
		</cfcatch>
		
		</cftry>						  				
						
		<cfoutput>4:#cfquery.executionTime#<br></cfoutput>		
				
		<!--- add usage once it is defined that usage is leading for the unit --->
		
		<!--- udjust the charge and status field which will come from a portal screen --->
				
		<!--- ---------------------- --->
		<!--- business usage charges --->							 										
		<!--- ---------------------- --->
					
		<cfquery name="UpdateUsage" 
		    datasource="NovaWorkOrder" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#"
			timeout="#scripttimeout#">
			UPDATE WorkOrderLineDetail
			SET    Charged      = DC.Charged			       
            FROM   WorkOrderLineDetailCharge AS DC INNER JOIN
                   WorkOrderLineDetail AS D ON DC.WorkOrderId = D.WorkOrderId
				                           AND DC.WorkOrderLine = D.WorkOrderLine 
										   AND DC.ServiceItem = D.ServiceItem 
										   AND DC.ServiceItemUnit = D.ServiceItemUnit 
										   AND DC.Reference = D.Reference 
										   AND DC.TransactionDate = D.TransactionDate
			AND    D.WorkOrderId IN (#preservesinglequotes(wosel)#)
			AND    D.TransactionDate >= #sel# 
			AND    D.TransactionDate <= #selenduse#		
			AND    D.ActionStatus != '9'
			AND	   D.Charged <> DC.Charged			
			AND	   D.ServiceUsageSerialNo <= (	SELECT MAX(SerialNo)
												FROM   WorkOrderLineAction A
												WHERE  A.WorkOrderId = D.WorkOrderId
												AND    A.WorkOrderLine = D.WorkOrderLine
												AND    A.ActionClass = ( SELECT UsageActionClose 
																		 FROM ServiceItem S
							                                             WHERE S.Code = D.ServiceItem )
											)
		</cfquery>	  

		
		<cftry>
		
			<cfquery name="InsertUsage" 
			    datasource="NovaWorkOrder" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#"
				timeout="#scripttimeout#">
				INSERT INTO skWorkOrderCharges
				
							(WorkOrderId, 
							 WorkOrderLine, 
							 SelectionDate, 
							 ServiceItem, 
							 ServiceItemUnit, 
							 Charged,		
							 ActionStatus,												 
							 Currency,
							 BillingMode,
							 PersonNo, 	
							 Amount,
							 Frequency,
							 AmountBase)
											  
					   SELECT   L.WorkOrderId,
					            L.WorkOrderLine,
								#selend#, 														
		                        BD.ServiceItem, 
								BD.ServiceItemUnit, 								
								BD.Charged,		
								BD.ActionStatus,								
								BD.Currency, 
								'Detail',
								L.PersonNo, 	
								ROUND(SUM(BD.Amount),4) as Amount,
								'Once',
								ROUND(SUM(BD.Amount),4) as Amount
								
					   FROM     WorkOrderLine L INNER JOIN WorkOrderLineDetail BD ON  L.WorkOrderId = BD.WorkOrderId 
								    AND L.WorkOrderLine = BD.WorkOrderLine
																	
					   WHERE    L.WorkOrderId IN (#preservesinglequotes(wosel)#) 
					  				   
					    AND     L.DateEffective <= #cutoff#
				        AND     (L.DateExpiration >= #cutoff# or L.DateExpiration is NULL)
					   
					    <!--- and workorder line itself need it to be valid in this month 						
					   AND    BD.PostingDate >= #sel#	AND    BD.PostingDate <= #selend#	
					   --->	
	
					   AND      BD.TransactionDate >= #sel#	and BD.TransactionDate <= #selenduse#		   				      		 				  
					 
					   AND      L.Operational = 1	
					   
					   AND      BD.ActionStatus != '9'
									   						   				   
					   <!--- 5/12/2010 take the below for the different table we added WorkOrderLineDetailAction --->						  
					  					   
					   <!--- decision to bill is based on the occurenace in the BillingDetail table if exist if needs
					   to have Mode = "Detail" or onceit doesn't exist as unit for that item it will be charged as well --->
					   
					   AND      (
					   
					            ServiceItemUnit IN (SELECT ServiceItemUnit 
					                                FROM   WorkOrderLineBillingDetail
													WHERE  WorkOrderId   = BD.WorkOrderId
													AND    WorkOrderLine = BD.WorkOrderLine
													AND    ServiceItem   = BD.ServiceItem
													AND    BillingMode   = 'Detail')
								
								OR
								
								<!--- not found in billing --->
								
								ServiceItemUnit NOT IN (SELECT ServiceItemUnit 
					                                FROM   WorkOrderLineBillingDetail
													WHERE  WorkOrderId   = BD.WorkOrderId
													AND    WorkOrderLine = BD.WorkOrderLine
													AND    ServiceItem   = BD.ServiceItem)
													
								)					
						
					   <!--- for the usage the billing mode is derrived from ServiceItemUnit table --->
					   
					   GROUP BY L.WorkOrderId,
					            L.WorkOrderLine, 	
								L.PersonNo,											
								BD.ServiceItem, 
								BD.ServiceItemUnit,	
								BD.Currency,
								BD.Charged,
								BD.ActionStatus					
			   </cfquery>		   			    
			   
			   <!---
			   <cfoutput>6:#cfquery.executionTime#<br></cfoutput>		
			   --->
		
		<cfcatch>
		
			<cf_ScheduleLogInsert   
			      ScheduleRunId  = "#schedulelogid#"
			   Description    = "Error calculating usage charges. Process aborted"
			    StepStatus="9"
			    Abort="Yes">
			<cfabort>
		</cfcatch>
		
		</cftry>						  				
	</cfloop>													 

<!--- clean the charge for 0 records --->

<cfquery name="SetChargeFromOverwrite" 
    datasource="NovaWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#"
	timeout="#scripttimeout#">
	DELETE FROM skWorkOrderCharges
	WHERE  Amount = 0				
</cfquery>	


<cfquery name    = "getMission"
     datasource = "NovaWorkOrder"
     username   = "#SESSION.login#"
     password   = "#SESSION.dbpw#"
	 timeout="#scripttimeout#">	
	  SELECT * 
	  FROM   Ref_ParameterMission 
	  WHERE  Mission = '#URL.Mission#'
</cfquery>	 

<cfif getMission.PostingMode eq "Funding">
				
	<!--- process the fundingid values --->
	<cfinclude template="PostFinancialsSetChargesFunding.cfm">

	<!--- ---------------------------- --->

		<cf_ScheduleLogInsert   
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "Funding Asigned">

<cfelse>

    <!--- commercial mode single query --->	
	<!--- update the GLAccount from the ServiceItemUnit table --->

</cfif>		