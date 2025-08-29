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
<cfparam name="url.mission" default="">

<cfquery name="getCondition" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     UserModuleCondition C
		WHERE    C.Account   = '#SESSION.acc#'
		AND      C.SystemFunctionId = '#url.SystemFunctionId#'  	
		AND      C.ConditionField = '#url.conditionfield#' 
		AND      C.ConditionValue = '#url.ConditionValue#'
</cfquery>	

<!--- the filtering date field is the document date reflecting the moment of happening of the sale functionally --->

<cfif getCondition.ConditionValueAttribute3 neq "recorded">
	<cfparam name="datefield" default="DocumentDate">	
<cfelse>
	<cfset datefield = "TransactionDate">	
</cfif>

<table width="100%" class="navigation_table">
	
	<cfset Today        = DateAdd("d",0,now())>	
	<cfset Yesterday    = DateAdd("d",-1,now())>
	<cfset LastMonth    = DateAdd("m",-1,now())>
	<cfset TodayMinus2  = DateAdd("d",-2,now())>	
	<cfset TodayMinus3  = DateAdd("d",-3,now())>	
	<cfset TodayMinus7  = DateAdd("d",-7,now())>	
	<cfset TodayMinus30 = DateAdd("d",-30,now())>
	
	<cfset dayNo = DayOfWeek(Yesterday)>
	
	<cfset yearAgoDate     = DateAdd("yyyy", -1, Today)>		
	<cfset twoYearsAgoDate = DateAdd("yyyy", -2, Today)>	
		
    <CF_DateConvert Value="#DateFormat(TodayMinus30,CLIENT.DateFormatShow)#">
    <cfset SQL_TODAYMINUS30 = dateValue>
	
	<CF_DateConvert Value="#DateFormat(TodayMinus7,CLIENT.DateFormatShow)#">
    <cfset SQL_TODAYMINUS7  = dateValue>

    <CF_DateConvert Value="#DateFormat(Yesterday,CLIENT.DateFormatShow)#">
    <cfset SQL_YESTERDAY    = dateValue>
	
	<CF_DateConvert Value="#DateFormat(TodayMinus2,CLIENT.DateFormatShow)#">
    <cfset SQL_TODAYMINUS2  = dateValue>
	
	<CF_DateConvert Value="#DateFormat(TodayMinus3,CLIENT.DateFormatShow)#">
    <cfset SQL_TODAYMINUS3  = dateValue>
	
	<!--- historic view --->
	
	<!--- month --->		
	<CF_DateConvert Value="#DateFormat(today,CLIENT.DateFormatShow)#">		
	<cfset str = createDate(year(dateValue),  month(dateValue),  1)>
	<cfset end = createDate(year(dateValue),  month(dateValue),  daysinmonth(datevalue))>	
	<cfset end = dateadd("d",1,end)>
    <cfset SQL_MONTH      = "BETWEEN #str# AND #end#">	
	
	<!--- last month --->		
	<CF_DateConvert Value="#DateFormat(LastMonth,CLIENT.DateFormatShow)#">		
	<cfset str = createDate(year(dateValue),  month(dateValue),  1)>
	<cfset end = createDate(year(dateValue),  month(dateValue),  daysinmonth(datevalue))>	
	<cfset end = dateadd("d",1,end)>
    <cfset SQL_YEAR         = "BETWEEN #str# AND #end#">	
	
	<!--- last month prior year --->		
	<CF_DateConvert Value="#DateFormat(yearAgoDate,CLIENT.DateFormatShow)#">		
	<cfset str = createDate(year(dateValue),  month(dateValue),  1)>
	<cfset end = createDate(year(dateValue),  month(dateValue),  daysinmonth(datevalue))>	
	<cfset end = dateadd("d",1,end)>
    <cfset SQL_YEARAGO      = "BETWEEN #str# AND #end#">	
	
	<!--- last month 2 years ago --->											
	<CF_DateConvert Value="#DateFormat(twoYearsAgoDate,CLIENT.DateFormatShow)#">		
	<cfset str = createDate(year(dateValue),  month(dateValue),  1)>
	<cfset end = createDate(year(dateValue),  month(dateValue),  daysinmonth(datevalue))>	
	<cfset end = dateadd("d",1,end)>
    <cfset SQL_YEARAGO2     = "BETWEEN #str# AND #end#">	
	
	<CF_DateConvert Value="#DateFormat(Today,CLIENT.DateFormatShow)#">
    <cfset SQL_TODAY        = dateValue>
	
	<cfif getCondition.ConditionValueAttribute1 eq "" or getCondition.ConditionValueAttribute1 eq "undefined">
	    <cfset cur = application.BaseCurrency>
	<cfelse>	
		<cfset cur = getCondition.ConditionValueAttribute1>
	</cfif>
		
	<cfif getCondition.ConditionValueAttribute2 eq "">
	    <cfset lng = "closing">
	<cfelse>	
		<cfset lng = getCondition.ConditionValueAttribute2>
	</cfif>
			
	<cfquery name="getExchange"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">							 
		SELECT   *
		FROM      Currency
		WHERE     Currency = '#cur#'								
	</cfquery>
	
	<cftransaction isolation="READ_UNCOMMITTED">
		
	<cfquery name="getSales"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
								
			SELECT   'Sale' as Mode,
					 H.TransactionCategory,
			         I.Category,
					 C.Description,
					 H.#datefield#,
					 L.Currency,	
					 COUNT(DISTINCT H.JournalTransactionNo) as Transactions,					 						
					 
					 CASE WHEN L.Currency = '#cur#' THEN SUM(L.AmountCredit - L.AmountDebit) ELSE SUM(L.AmountBaseCredit - L.AmountBaseDebit) 
                      * #getExchange.ExchangeRate# END AS Total
					
			FROM     TransactionHeader H  INNER JOIN 
			         TransactionLine L  ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
					 INNER JOIN Materials.dbo.Item I ON I.ItemNo = L.ReferenceNo
					 INNER JOIN Materials.dbo.Ref_Category  C ON C.Category = I.Category
			
			WHERE    H.Mission = '#url.mission#'	
			AND      H.TransactionSource   = 'SalesSeries' 
			AND      H.TransactionCategory = 'Receivables' 
			AND      L.TransactionSerialNo != '0'
			
			AND      H.RecordStatus    = '1'
	 		AND      H.ActionStatus IN ('0','1')			

			AND      H.TransactionSourceId IN (SELECT BatchId 
			                                   FROM   Materials.dbo.WarehouseBatch 								           
                                               WHERE  BatchId   = H.TransactionSourceId
											   AND    #url.conditionfield# = '#url.conditionvalue#'  )
					
			<cfif lng eq "Current">								   
			AND      H.#datefield# BETWEEN #SQL_TODAYMINUS30# AND #SQL_TODAY# 		
			<cfelseif lng eq "Closing">														   
			AND      H.#datefield# BETWEEN #SQL_TODAYMINUS3# AND #SQL_TODAY# 
			<cfelseif lng eq "Historic">
			
			AND      (
				     H.#datefield# #preservesingleQuotes(SQL_MONTH)# 
				     OR H.#datefield# #preservesingleQuotes(SQL_YEAR)# 
			         OR H.#datefield# #preservesingleQuotes(SQL_YEARAGO)# 
				     OR H.#dateField# #preservesingleQuotes(SQL_YEARAGO2)#
				      )
			<cfelse>
			AND      H.#datefield# IN (#SQL_TODAY#,#SQL_YESTERDAY#)  
			</cfif>
			GROUP BY I.Category, 
			         L.Currency,
			         C.Description, 
					 H.#datefield#,
					 H.TransactionCategory
					 
				 
			UNION ALL							
			
			SELECT 'Settlement' AS Mode,
				    H.TransactionCategory,
			        L.GLAccount,
					A.Description,
					LH.#datefield#,
					L.Currency,		
					COUNT(*) as Transactions,						
									
					CASE WHEN L.Currency = '#cur#' THEN SUM(L.AmountDebit - L.AmountCredit) ELSE SUM(L.AmountBaseDebit - L.AmountBaseCredit) 
                      * #getExchange.ExchangeRate# END AS Total
																					
			FROM    TransactionHeader H   
					INNER JOIN TransactionLine L  ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo 
					INNER JOIN TransactionHeader LH  ON LH.Journal = L.ParentJournal AND LH.JournalSerialNo = L.ParentJournalSerialNo
					INNER JOIN Ref_Account A  ON L.GlAccount = A.GlAccount
			WHERE   H.Mission = '#url.mission#'					
			
			AND     EXISTS (SELECT 'X' 
                            FROM   Materials.dbo.WarehouseBatch  
				            WHERE  BatchId   = LH.TransactionSourceId
							AND    #url.conditionfield# = '#url.conditionvalue#'
							AND    BatchClass = 'WhsSale')  <!--- added to prevent mixing with workorder : aldana related sales --->
											   
			AND      LH.RecordStatus    = '1'
	 		AND      LH.ActionStatus IN ('0','1')	
											   
			AND  	(
			           (H.TransactionCategory = 'Receipt'  AND L.TransactionSerialNo != '0') <!--- direct payment ---> OR
    			 	   (H.TransactionCategory = 'Banking'  AND L.TransactionSerialNo = '0')  <!--- AR payment ---> OR
					   (H.TransactionCategory = 'Advances' AND L.TransactionSerialNo = '0')	<!--- Advance payment --->						
					)	
					
			AND     H.RecordStatus    = '1'
	 		AND     H.ActionStatus IN ('0','1')	
			
			<cfif lng eq "Current">								   
			AND      LH.#datefield# BETWEEN #SQL_TODAYMINUS30# AND #SQL_TODAY# 	
			<cfelseif lng eq "Closing">											   
			AND      LH.#datefield# BETWEEN #SQL_TODAYMINUS3# AND #SQL_TODAY# 		
			<cfelseif lng eq "Historic">
			
			AND      (
				     LH.#datefield# #preservesingleQuotes(SQL_MONTH)# 
				     OR LH.#datefield# #preservesingleQuotes(SQL_YEAR)# 
			         OR LH.#datefield# #preservesingleQuotes(SQL_YEARAGO)# 
				     OR LH.#dateField# #preservesingleQuotes(SQL_YEARAGO2)#
				      )					   
			<cfelse>
			AND      LH.#datefield# IN (#SQL_TODAY#,#SQL_YESTERDAY#)  
			</cfif> 				
													   
			GROUP BY L.GlAccount, 
			         L.Currency,
			         A.Description, 
					 LH.#datefield#,
					 H.TransactionCategory	
					 
			UNION ALL		 
					 
			SELECT  'COGS' as Mode,
				         '',
				         I.Category,
						 C.Description,
						 H.#datefield#,
						 L.Currency,
						 1,							 
						 CASE WHEN L.Currency = '#cur#' THEN SUM(L.AmountDebit - L.AmountCredit) ELSE SUM(L.AmountBaseDebit - L.AmountBaseCredit) 
	                      * #getExchange.ExchangeRate# END AS Total						 
							 
				FROM     TransactionHeader H  
						 INNER JOIN TransactionLine L  ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
						 INNER JOIN Materials.dbo.Item I  ON I.ItemNo = L.ReferenceNo
						 INNER JOIN Materials.dbo.Ref_Category C  ON C.Category = I.Category
						 
				WHERE    H.Mission = '#url.mission#'	
				<!--- valid batch no --->
				
				AND      EXISTS (SELECT 'X' 
                                 FROM   Materials.dbo.WarehouseBatch  
					             WHERE  BatchId   = H.TransactionSourceId
							     AND    #url.conditionfield# = '#url.conditionvalue#')	
									 
				AND  	 H.TransactionSource   = 'WarehouseSeries' 
				AND  	 H.TransactionCategory = 'Inventory' 				
				AND      H.RecordStatus        = '1'
		 		AND      H.ActionStatus IN ('0','1')
				
				<!--- 12/7/2020 added condition as in case of Charlie a disposal was also shown--->
				AND		 H.Reference = 'Sale'
				
				AND  	 L.JournalSerialNo    != '0'	
												   
				AND EXISTS ( SELECT 'X'
							 FROM   Materials.dbo.Ref_CategoryGledger 
						     WHERE  Category  = I.Category
						     AND    Area      = 'COGS'
						     AND    Mission IS NULL
						     AND    GlAccount = L.GLAccount
	  				)	
					
				<cfif lng eq "Current">								   
				AND      H.#datefield# BETWEEN #SQL_TODAYMINUS30# AND #SQL_TODAY# 		
				<cfelseif lng eq "Closing">											   
				AND      H.#datefield# BETWEEN #SQL_TODAYMINUS3# AND #SQL_TODAY# 									   
				<cfelseif lng eq "Historic">
				AND      (
				     
				     H.#datefield# #preservesingleQuotes(SQL_MONTH)# 
				     OR H.#datefield# #preservesingleQuotes(SQL_YEAR)# 
			         OR H.#datefield# #preservesingleQuotes(SQL_YEARAGO)# 
				     OR H.#dateField# #preservesingleQuotes(SQL_YEARAGO2)#
				      )
				<cfelse>
				AND      H.#datefield# IN (#SQL_TODAY#,#SQL_YESTERDAY#)  
				</cfif>
										           
				GROUP BY I.Category, 
				         L.Currency,
				         C.Description, 
						 H.#datefield#								 
											 
								
	</cfquery>	
	
	</cftransaction>
	
	<!---
	<cfoutput>#cfquery.executiontime#</cfoutput>
	--->
									
	<cfif getSales.recordcount eq "0">
		
	<tr><td align="center" class="labelmedium"><cf_tl id="No sales recorded"></td></tr>
	
	<cfelse>
	
	<!---
	
	<cfelse>	
								
		<cfquery name="getCOGS"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
						
				SELECT  'Sale' as Mode,
				         '',
				         I.Category,
						 C.Description,
						 H.#datefield#,
						 L.Currency,
						 1,							 
						 CASE WHEN L.Currency = '#cur#' THEN SUM(L.AmountDebit - L.AmountCredit) ELSE SUM(L.AmountBaseDebit - L.AmountBaseCredit) 
	                      * #getExchange.ExchangeRate# END AS Total						 
							 
				FROM     TransactionHeader H  
						 INNER JOIN TransactionLine L  ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
						 INNER JOIN Materials.dbo.Item I  ON I.ItemNo = L.ReferenceNo
						 INNER JOIN Materials.dbo.Ref_Category C  ON C.Category = I.Category
						 
				WHERE    H.Mission = '#url.mission#'	
				<!--- valid batch no --->
				
				AND      EXISTS (SELECT 'X' 
                                 FROM   Materials.dbo.WarehouseBatch  
					             WHERE  BatchId   = H.TransactionSourceId
							     AND    #url.conditionfield# = '#url.conditionvalue#')	
									 
				AND  	 H.TransactionSource   = 'WarehouseSeries' 
				AND  	 H.TransactionCategory = 'Inventory' 				
				AND      H.RecordStatus        = '1'
		 		AND      H.ActionStatus IN ('0','1')
				
				<!--- 12/7/2020 added condition as in case of Charlie a disposal was also shown--->
				AND		 H.Reference = 'Sale'
				
				AND  	 L.JournalSerialNo    != '0'	
												   
				AND EXISTS ( SELECT 'X'
							 FROM   Materials.dbo.Ref_CategoryGledger 
						     WHERE  Category  = I.Category
						     AND    Area      = 'COGS'
						     AND    Mission IS NULL
						     AND    GlAccount = L.GLAccount
	  				)	
					
				<cfif lng eq "Current">								   
				AND      H.#datefield# BETWEEN #SQL_TODAYMINUS30# AND #SQL_TODAY# 		
				<cfelseif lng eq "Closing">											   
				AND      H.#datefield# BETWEEN #SQL_TODAYMINUS3# AND #SQL_TODAY# 									   
				<cfelseif lng eq "Historic">
				AND      (
				     
				     H.#datefield# #preservesingleQuotes(SQL_MONTH)# 
				     OR H.#datefield# #preservesingleQuotes(SQL_YEAR)# 
			         OR H.#datefield# #preservesingleQuotes(SQL_YEARAGO)# 
				     OR H.#dateField# #preservesingleQuotes(SQL_YEARAGO2)#
				      )
				<cfelse>
				AND      H.#datefield# IN (#SQL_TODAY#,#SQL_YESTERDAY#)  
				</cfif>
										           
				GROUP BY I.Category, 
				         L.Currency,
				         C.Description, 
						 H.#datefield#			
								
		</cfquery>	
		
		
		<cfoutput>#cfquery.executiontime#
		#getCOGS.recordcount#
		</cfoutput>
			
		--->	
	
	
		
		<tr>
			<td valign="top" colspan="2" id="statcontent" style="padding-right:0px" height="100%">
									
				<table cellpadding="0" cellspacing="0" width="100%">
				
					<cfoutput>
					
					<cfif lng eq "Current" or lng eq "closing">
	
					<tr class="line" style="border-top:1px solid silver" bgcolor="<cfif url.conditionfield eq 'mission'>f1f1f1<cfelse>white</cfif>">
					    <td align="center" class="labelit"><cf_tl id="Item"></td>
						<td align="center" style="border-left:1px solid gray" class="labelit">
						
							<table width="100%">
								<tr><td class="labelit" style="padding-left:8px">
								<cf_tl id="Today"> <font size="2">(#cur#)</font>
								</td>										
								
									<cfquery name="close"
									datasource="AppsLedger" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									
									SELECT    *
									FROM      Event
									WHERE     OrgUnit IN
				                                 (SELECT    O.OrgUnit
				                                  FROM      Materials.dbo.Warehouse W, Organization.dbo.Organization O
				                                  WHERE     W.MissionorgUnitid = O.MissionOrgUnitId
												  AND       W.Warehouse = '#url.conditionvalue#') 
									AND        ActionCode = 'Closing' 
								    AND        EventDate = #SQL_TODAY#			
												
									</cfquery>
													
								<td class="labelit" style="padding-right:4px" align="right" id="#url.conditionvalue#closetoday">
								
								    <cfif url.conditionfield neq "mission">
									 
										<cfif close.recordcount eq "0">								
											<cf_img icon="open" tooltip="Close Initiation" onclick="ptoken.navigate('#session.root#/Warehouse/Application/SalesOrder/Closing/Closing.cfm?date=#dateformat(sql_today,client.dateformatshow)#&warehouse=#url.conditionvalue#','#url.conditionvalue#closetoday')">
										<cfelse>								
											<cf_img icon="edit" tooltip="Close Initiation" onclick="ptoken.navigate('#session.root#/Warehouse/Application/SalesOrder/Closing/Closing.cfm?eventid=#close.eventid#&warehouse=#url.conditionvalue#','#url.conditionvalue#closetoday')">						
										</cfif>
									
									</cfif>
													
								</td>
								</tr>
							</table>
						
						</td>
						
						<td align="center" style="border-left:1px solid gray" class="labelit">
						
							<table width="100%">
							<tr><td class="labelit" style="padding-left:8px">
							<cf_tl id="Yesterday"> <font size="2">(#cur#)
							</td>		
							
							    <cftransaction isolation="READ_UNCOMMITTED">
															
								<cfquery name="close"
								datasource="AppsLedger" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								
									SELECT    *
									FROM      Event
									WHERE     OrgUnit IN
				                                 (SELECT    O.OrgUnit
				                                 FROM       Materials.dbo.Warehouse W, Organization.dbo.Organization O
				                                 WHERE      W.MissionorgUnitid = O.MissionOrgUnitId
												 AND        W.Warehouse = '#url.conditionvalue#') 
									AND        ActionCode = 'Closing' 
								    AND        EventDate = #SQL_YESTERDAY#
								
								</cfquery>
								
								</cftransaction>
												
							<td class="labelit" align="right" style="padding-right:4px" id="#url.conditionvalue#closeyesterday">
							
								<cfif url.conditionfield neq "mission">
							
									<cfif close.recordcount eq "0">
										<cf_img icon="open" tooltip="Close Initiation" onclick="ptoken.navigate('#session.root#/Warehouse/Application/SalesOrder/Closing/Closing.cfm?date=#dateformat(sql_yesterday,client.dateformatshow)#&warehouse=#url.conditionvalue#','#url.conditionvalue#closeyesterday')">
									<cfelse>
										<cf_img icon="edit" tooltip="Close Initiation" onclick="ptoken.navigate('#session.root#/Warehouse/Application/SalesOrder/Closing/Closing.cfm?eventid=#close.eventid#&warehouse=#url.conditionvalue#','#url.conditionvalue#closeyesterday')">						
									</cfif>									
								
								</cfif>	
							
							</td>
							</tr>
							</table>					
						
						</td>					
						
						<cfif lng eq "closing">
						
						   <td align="center" style="border-left:1px solid gray" class="labelit">
						   
							    <table width="100%">
									<tr><td class="labelit" style="padding-left:8px">
									#DateFormat(todayminus2,CLIENT.DateFormatShow)# 
									</td>		
									
										<cftransaction isolation="READ_UNCOMMITTED">								
									
										<cfquery name="close"
										datasource="AppsLedger" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										
										SELECT    *
										FROM      Event
										WHERE     OrgUnit IN (
										              SELECT  O.OrgUnit
					                                  FROM    Materials.dbo.Warehouse W, Organization.dbo.Organization O
					                                  WHERE   W.MissionorgUnitid = O.MissionOrgUnitId
													  AND     W.Warehouse = '#url.conditionvalue#'
													  ) 
										AND        ActionCode = 'Closing' 
									    AND        EventDate = #SQL_TODAYMINUS2#						
										</cfquery>
										
										</cftransaction>
														
									<td class="labelit" align="right" style="padding-right:4px" id="#url.conditionvalue#closetodayminus2">
									
										<cfif url.conditionfield neq "mission">
										
										<cfif close.recordcount eq "0">
											<cf_img icon="open" tooltip="Close Initiation" onclick="ptoken.navigate('#session.root#/Warehouse/Application/SalesOrder/Closing/Closing.cfm?date=#dateformat(sql_todayminus2,client.dateformatshow)#&warehouse=#url.conditionvalue#','#url.conditionvalue#closetodayminus2')">
										<cfelse>
											<cf_img icon="edit" tooltip="Open Closing" onclick="ptoken.navigate('#session.root#/Warehouse/Application/SalesOrder/Closing/Closing.cfm?eventid=#close.eventid#&warehouse=#url.conditionvalue#','#url.conditionvalue#closetodayminus2')">						
										</cfif>
										
										</cfif>
														
									</td>
									</tr>
								</table>
							
							</td>
							
							<td align="center" style="border-left:1px solid gray" class="labelit">
						   
							   <table width="100%">
									<tr><td class="labelit" style="padding-left:8px">
									#DateFormat(todayminus3,CLIENT.DateFormatShow)# 
									</td>
									
									<cftransaction isolation="READ_UNCOMMITTED">										
									
									<cfquery name="close"
									datasource="AppsLedger" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										
										SELECT    *
										FROM     Event
										WHERE     OrgUnit IN
					                                 (SELECT    O.OrgUnit
					                                 FROM       Materials.dbo.Warehouse W, Organization.dbo.Organization O
					                                 WHERE      W.MissionorgUnitid = O.MissionOrgUnitId
													 AND        W.Warehouse = '#url.conditionvalue#') 
										AND        ActionCode = 'Closing' 
									    AND        EventDate = #SQL_TODAYMINUS3#						
										
									</cfquery>
									
									</cftransaction>
														
									<td class="labelit" style="padding-right:4px" align="right" id="#url.conditionvalue#closetodayminus3">
									
										<cfif url.conditionfield neq "mission">
										
										<cfif close.recordcount eq "0">
											<cf_img icon="open" tooltip="Close Initiation" onclick="ptoken.navigate('#session.root#/Warehouse/Application/SalesOrder/Closing/Closing.cfm?date=#dateformat(sql_todayminus3,client.dateformatshow)#&warehouse=#url.conditionvalue#','#url.conditionvalue#closetodayminus3')">
										<cfelse>
											<cf_img icon="edit" tooltip="Open Closing" onclick="ptoken.navigate('#session.root#/Warehouse/Application/SalesOrder/Closing/Closing.cfm?eventid=#close.eventid#&warehouse=#url.conditionvalue#','#url.conditionvalue#closetodayminus3')">						
										</cfif>
										
										</cfif>
														
									</td>
									</tr>
								</table>
							
							</td>						
							
						
						<cfelse>
											
						<td align="center" style="border-left:1px solid gray" class="labelit"><cf_tl id="Last 7 days"> </td>	
						<td align="center" style="border-left:1px solid gray" class="labelit"><cf_tl id="Last 30 days"></td>	
						
						</cfif>
					</tr>
						
					
					<cfelse>
					
					<tr class="line" style="border-top:1px solid silver" bgcolor="<cfif url.conditionfield eq 'mission'>f1f1f1<cfelse>white</cfif>">
					    <td align="center" class="labelit"><cf_tl id="Item"></td>
						<td align="center" style="border-left:1px solid gray" class="labelit">#DateFormat(today,"MMM YYYY ")#</td>
						<td align="center" style="border-left:1px solid gray" class="labelit">#DateFormat(lastmonth,"MMM YYYY ")#</td>
						<td align="center" style="border-left:1px solid gray" class="labelit">#DateFormat(yearAgoDate,"MMM YYYY ")#</td>	
						<td align="center" style="border-left:1px solid gray" class="labelit">#DateFormat(twoyearsAgoDate,"MMM YYYY")#</td>	
					</tr>				
					
					</cfif>
					
					</cfoutput>				
									
					<tr>
					
					<cfquery name="list" dbtype="Query">
						SELECT   Mode, Category, Description, MIN(TransactionCategory) as TransactionCategory
						FROM     getSales	
						WHERE    Mode <> 'COGS'										
						GROUP BY Mode, Category, Description
						ORDER BY Mode, Category, Description
					</cfquery>		
					
									
					<cfif lng eq "Current">
						<cfset mlist = "item,day,yesterday,week,month30">
					<cfelseif lng eq "Closing">				
						<cfset mlist = "item,day,yesterday,dayminus2,dayminus3">	
					<cfelseif lng eq "Historic">	
						<cfset mlist = "item,month,year,yearago,yearago2">					    
					<cfelse>
						<cfset mlist = "item,day,yesterday,yearago,yearago2">	
					</cfif>
											
					<cfloop index="per" list="#mlist#">
											
						<td width="<cfif per eq 'item'>36<cfelse>16</cfif>%" align="center" valign="top">
						
							<table width="100%" align="center">
							
								<cfoutput query="list" group="mode">
								
									<cfset vTotalAmount = "0">
									<cfset vTotalCOGS = "0">		
									<cfset vTotalTransactions = "0">																   
										
									<cfif per eq "Item">	
									<tr><td style="padding-left:2px" class="labelit">&nbsp;</td></tr>								
									<cfelseif Mode eq "Sale">								   
									<tr class="line labelmedium2" style="height:20px">
										<td colspan="2" align="right" style="min-width:80px;padding-right:4px"><cf_tl id="#Mode#"></td>
										 <cfif per neq "Item">
										<td colspan="2" align="right" bgcolor="f4f4f4" style="min-width:80px;padding-right:4px"><cf_tl id="COGS"></td>
										</cfif>
									</tr>
									<cfelse>
									<tr><td colspan="4" align="right" style="padding-right:4px" class="labelit"><cf_tl id="#Mode#"></td></tr>
									</cfif>
																																			
									<cfoutput>
																		
											<cfquery name="qSale" dbtype="Query">
												SELECT  SUM(Transactions) as Transactions, SUM(Total) as Total
												FROM    getSales
												WHERE   Mode = '#mode#'
												<cfif per eq "day">
												AND     #datefield# >= #SQL_TODAY#
												<cfelseif per eq "yesterday">
												AND     #datefield# = #SQL_YESTERDAY#
												<cfelseif per eq "dayminus2">																						   
												AND     #datefield# = #SQL_TODAYMINUS2#
												<cfelseif per eq "dayminus3">											   											
												AND     #datefield# = #SQL_TODAYMINUS3#		
												<cfelseif per eq "month">											   											
												AND     #datefield# #preserveSingleQuotes(SQL_MONTH)#		
												<cfelseif per eq "year">
												AND     #datefield#  #preserveSingleQuotes(SQL_YEAR)#								
												<cfelseif per eq "yearago">
												AND     #datefield#  #preserveSingleQuotes(SQL_YEARAGO)#
												<cfelseif per eq "yearago2">
												AND     #datefield#  #preserveSingleQuotes(SQL_YEARAGO2)#
												<cfelseif per eq "week">
												AND     #datefield# >= #SQL_TODAYMINUS7#
												<cfelse>
												AND     #datefield# >= #SQL_TODAYMINUS30#
												</cfif>
												
												AND     Category = '#Category#'																									
											</cfquery>	
																					
											<cfif Mode eq "Sale">	
											
												<cfquery name="qCOGS" dbtype="Query">
													SELECT  SUM(Total) as Total
													FROM    getSales
													WHERE   Mode = 'COGS'
													<cfif per eq "day">
													AND     #datefield# >= #SQL_TODAY#
													<cfelseif per eq "yesterday">
													AND     #datefield# = #SQL_YESTERDAY#
													<cfelseif per eq "dayminus2">											   
													AND     #datefield# = #SQL_TODAYMINUS2#
													<cfelseif per eq "dayminus3">											   
													AND     #datefield# = #SQL_TODAYMINUS3#		
													<cfelseif per eq "month">											   											
													AND     #datefield# #preserveSingleQuotes(SQL_MONTH)#		
													<cfelseif per eq "year">
													AND     #datefield#  #preserveSingleQuotes(SQL_YEAR)#								
													<cfelseif per eq "yearago">
													AND     #datefield#  #preserveSingleQuotes(SQL_YEARAGO)#
													<cfelseif per eq "yearago2">
													AND     #datefield#  #preserveSingleQuotes(SQL_YEARAGO2)#												
													<cfelseif per eq "week">
													AND     #datefield# >= #SQL_TODAYMINUS7#
													<cfelse>
													AND     #datefield# >= #SQL_TODAYMINUS30#	
													</cfif>													
													AND     Category = '#Category#'														
												</cfquery>	
																																	
											</cfif>											
																			
																			
									<tr class="navigation_row">	
									
									 <cfif per eq "Item">									
										<td width="100%" align="left" style="<cfif currentrow neq 1>border-top:1px solid e1e1e1;</cfif>height:21px;padding-left:3px" class="fixlength labelmedium">
										<cfif transactionCategory eq "Advances"><cf_tl id="Advances"><cfelse>#Description#</cfif></td>								 
									 <cfelse>		
									 								
										<cfif Mode eq "Sale">	
																				
											<cfif qSale.Total neq "">
											    <cfset amt = floor(qSALE.Total)>		
												<cfset dgt = (qSALE.Total-floor(qSale.Total))*100>
												<cfif dgt lt "10">
													<cfset dgt = "0#dgt#">																					
												</cfif>
											<cfelse>
											    <cfset amt = "">
												<cfset dgt = "">	
											</cfif>
											
											<td width="48%" align="right" style="border-top:1px solid e1e1e1;height:21px;padding-left:3px" class="labelmedium">																
											#Numberformat(amt,",.")#<font size="1">#left(dgt,2)#</font></td>
											<td width="2%"></td>	
											
											
											<cfif qCOGS.Total neq "">
												<cfset amt = floor(qCOGS.Total)>
												<cfset dgt = (qCOGS.Total-floor(qCOGS.Total))*100>
												<cfif dgt lt "10">
													<cfset dgt = "0#dgt#">																					
												</cfif>
											<cfelse>
											    <cfset amt = "">
												<cfset dgt = "">	
											</cfif>
																							
											<td width="48%" align="right" style="border-top:1px solid e1e1e1;height:21px;background-color:##d4d4d450" class="labelmedium">
											#Numberformat(amt,",.")#<font size="1">#left(dgt,2)#</font></td>									
											<td width="2%"></td>	
											
											<cfif qSALE.Total neq "">
												<cfset vTotalAmount = vTotalAmount + qSALE.Total>
											</cfif>
											<cfif qCOGS.Total neq "">
												<cfset vTotalCOGS   = vTotalCOGS + qCOGS.Total>
											</cfif>  											
										
										<cfelse>
										
										<td colspan="1" align="right" style="height:21px;border-top:1px solid e1e1e1;padding-right:4px"  class="labelmedium">
										<cfif qSale.Transactions neq "0">#qSale.Transactions#</cfif></td>
										<td></td>		
										<td width="48%" colspan="1" style="height:21px;border-top:1px solid e1e1e1;" align="right"  class="labelmedium">
										
										
										<cfif qSale.Total neq "">	
																			
											<cfset amt = floor(abs(qSale.Total))>																				
											<cfset dgt = (abs(qSale.Total)-floor(abs(qSale.Total)))*100>
											<cfif dgt lt "10">
												<cfset dgt = "0#dgt#">																					
											</cfif>
										<cfelse>
											 <cfset amt = "">
											<cfset dgt = "">	
										</cfif>
										
										#Numberformat(amt,",.")#<font size="1">#left(dgt,2)#</font></td>
										<td></td>	
																			
										<cfif qSALE.Total neq "">
										
											<cfif transactionCategory eq "Advances">
											<cfset vTotalAmount = vTotalAmount - qSALE.Total>
											<cfelse>
											<cfset vTotalAmount = vTotalAmount + qSALE.Total>
											</cfif>										
											<cfset vTotalTransactions = vTotalTransactions + qSale.Transactions>	
											
										</cfif>
																												
										</cfif>		
												
									 </cfif>	
									 
									</tr>		
																																					
								    </cfoutput>
									
									<cfif mode neq "Sale">
																								
									    <!--- obtain pendings by currency --->
																			
											<cftransaction isolation="READ_UNCOMMITTED">
																			
												<cfquery name="getPending"
												datasource="AppsLedger" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">									
													SELECT   Currency, SUM(AmountOutstanding) AS Outstanding
													FROM     TransactionHeader AS H
													WHERE    Mission = '#url.mission#'
													AND      EXISTS  (SELECT   'X'
											                          FROM     Materials.dbo.WarehouseBatch
				                            						  WHERE    #url.conditionfield# = '#url.conditionvalue#' 
																	  AND      BatchId = H.TransactionSourceId) 
													AND      TransactionSource   = 'SalesSeries' 
													AND      TransactionCategory = 'Receivables' 
													AND 	 RecordStatus IN ('0','1')
													AND		 ActionStatus !=  '9' 
													
													<cfif per eq "day">
													AND     #datefield# >= #SQL_TODAY#
													<cfelseif per eq "yesterday">
													AND     #datefield# = #SQL_YESTERDAY#
													<cfelseif per eq "dayminus2">											   
													AND     #datefield# = #SQL_TODAYMINUS2#
													<cfelseif per eq "dayminus3">											   
													AND     #datefield# = #SQL_TODAYMINUS3#		
													<cfelseif per eq "month">											   											
													AND     #datefield# #preserveSingleQuotes(SQL_MONTH)#		
													<cfelseif per eq "year">
													AND     #datefield#  #preserveSingleQuotes(SQL_YEAR)#								
													<cfelseif per eq "yearago">
													AND     #datefield#  #preserveSingleQuotes(SQL_YEARAGO)#
													<cfelseif per eq "yearago2">
													AND     #datefield#  #preserveSingleQuotes(SQL_YEARAGO2)#
													<cfelseif per eq "week">
													AND    #datefield# >= #SQL_TODAYMINUS7#
													<cfelse>
													AND    #datefield# >= #SQL_TODAYMINUS30#
													</cfif>		    												
													GROUP BY Currency
													HAVING SUM(AmountOutstanding) > 1
												</cfquery>
											
											</cftransaction>
																						
										<cfset total = "0">
										<cfparam name="outstanding" default="0">
																			
										<cfloop query="getPending">
										
											<cfif cur eq currency>
											
												<cfset total = total + outstanding>
											
											<cfelse>
											
												<cf_exchangeRate Currencyfrom="#currency#" CurrencyTo="#cur#">
											
												<cfset out = outstanding / exc>
												<cfset total = total + out>	
											
											</cfif>									
										
										</cfloop>
										
										<cfset vTotalAmount = vTotalAmount + Total>
													
										<tr bgcolor="E6F2FF">								
											<cfif per eq "Item">	
											<td width="100%" align="left" style="border-top:1px solid e1e1e1;height:21px;padding-left:3px" class="line labelmedium">
											<cf_tl id="Accounts Receivable">
											</td>									
											<cfelse>										
											
											<cfif Total neq "">	
												<cfset amt = floor(Total)>											
												<cfset dgt = (Total-floor(Total))*100>
												<cfif dgt lt "10">
													<cfset dgt = "0#dgt#">																					
												</cfif>
											<cfelse>
												<cfset amt = "">
												<cfset dgt = "">	
											</cfif>
																			
											<td width="48%" colspan="3" align="right"  style="border-top:1px solid e1e1e1;height:21px"class="line labelmedium">#Numberformat(amt,",.")#<font size="1">#left(dgt,2)#</font></td>
											<td></td>								
											</cfif>
										</tr>
									
									</cfif>
									
									<tr class="fixlengthlist">	
									<cfif per eq "Item">	
																	
										<td  width="100%" align="left" style="padding-left:23px" class="line labelmedium"><cf_tl id="Total"></td>
										
									<cfelse>		
									
										<cfif Mode eq "Sale">										
										
										<cfif vTotalAmount neq "">	
											<cfset amt = floor(vTotalAmount)>											
											<cfset dgt = (vTotalAmount-floor(vTotalAmount))*100>
											<cfif dgt lt "10">
												<cfset dgt = "0#dgt#">																					
											</cfif>
										<cfelse>
											<cfset amt = "">
											<cfset dgt = "">	
										</cfif>
																				
										<td align="right"  style="padding-left:3px" class="line labelmedium"><b>#Numberformat(amt,",.")#<font size="1">#left(dgt,2)#</font></td>
										<td></td>										
										
										<cfif vTotalCOGS neq "">
											<cfset amt = floor(vTotalCOGS)>	
											<cfset dgt = (vTotalCOGS-floor(vTotalCOGS))*100>
											<cfif dgt lt "10">
												<cfset dgt = "0#dgt#">																					
											</cfif>
										<cfelse>
											<cfset amt = "">
											<cfset dgt = "">	
										</cfif>
																															
										<td align="right"  bgcolor="f4f4f4" class="line labelmedium"><b>#Numberformat(amt,",.")#<font size="1">#left(dgt,2)#</font></td>									
										<td></td>	
										<cfelse>	
										<td colspan="1" align="right"  style="padding-right:4px" class="line labelit"><cfif vTotalTransactions neq "0">#vTotalTransactions#</cfif></td>
										<td></td>									
										
										<cfif vTotalAmount neq "">
											<cfset amt = floor(vTotalAmount)>	
											<cfset dgt = (vTotalAmount-floor(vTotalAmount))*100>
											<cfif dgt lt "10">
												<cfset dgt = "0#dgt#">																					
											</cfif>
										<cfelse>
											<cfset amt = "">
											<cfset dgt = "">	
										</cfif>
											
										<td colspan="1" align="right"  class="line labelmedium"><b>#Numberformat(amt,",.")#<font size="1">#left(dgt,2)#</font></td>
										<td></td>			
										</cfif>	
									</cfif>	
									</tr>	
																									
								</cfoutput>
								
							</table>
						</td>	
						
					</cfloop>
						
					</tr>
				</table>
				
			</td>
		</tr>
	
	</cfif>
	
	
				
</table>

<cfset ajaxonload("doHighlight")>

