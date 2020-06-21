<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Statements Queries">	

	<cffunction name="getBalanceSheet"
             access="public"
             displayname="get the Sales Price and Tax into a struct variable">
						
		<cfargument name="Mission"             type="string"  required="true"   default="">								
		<cfargument name="AccountPeriod"       type="string"  required="true"   default="">				
		<cfargument name="TransactionPeriod"   type="string"  required="true"   default="">		
		<cfargument name="Currency"            type="string"  required="false"  default="#Application.BaseCurrency#">		
		<cfargument name="OpeningPeriod"       type="string"  required="true"   default="#AccountPeriod#">
		<cfargument name="Layout"              type="string"  required="true"   default="corporate">
		<cfargument name="Suffix"              type="string"  required="true"   default="">
		<cfargument name="Table"               type="string"  required="true"   default="">
								
		<cf_exchangeRate CurrencyFrom="#Application.BaseCurrency#" CurrencyTo="#currency#">		
			
		<cftransaction isolation="READ_UNCOMMITTED">
			
			<cfquery name="getExchange"
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">							 
				SELECT   *
				FROM      Currency
				WHERE     Currency = '#currency#'								
			</cfquery>	
		
			<cfquery name="get"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
						
				SELECT 	Data.*
				INTO   UserQuery.dbo.#table#
				FROM
				(
				
			    <cfloop index="itm" list="Debit,Credit" delimiters=",">
			
					SELECT  '#itm#' as Panel,
					        H.OrgUnitOwner,
							H.AccountPeriod,
							<cfif layout neq "corporate">				
						    H.TransactionPeriod, 	
							</cfif>
							G.GLAccount, 
					       	G.Description, 
							G.AccountLabel,
						    G.AccountGroup, 
						    G1.Description as AccountGroupDescription, 
							G1.ListingOrder as AccountGroupOrder,
							G1.AccountType  as AccountGroupType,
						    G1.AccountParent, 
						    G2.Description as AccountParentDescription, 							
							
					        SUM(T.AmountBaseDebit/#exc#)  as Debit, 
						    SUM(T.AmountBaseCredit/#exc#) as Credit
					
					 FROM 	Accounting#Suffix#.dbo.TransactionHeader H
							INNER JOIN Accounting#Suffix#.dbo.TransactionLine T
								ON H.Journal = T.Journal 
								AND H.JournalSerialNo = T.JournalSerialNo 							
							INNER JOIN Accounting#Suffix#.dbo.#Client.LanPrefix#Ref_Account G
								ON T.GLAccount = G.GLAccount
							INNER JOIN Accounting#Suffix#.dbo.#Client.LanPrefix#Ref_AccountGroup G1
								ON G.AccountGroup = G1.AccountGroup
							INNER JOIN Accounting#Suffix#.dbo.#Client.LanPrefix#Ref_AccountParent G2
								ON G1.AccountParent = G2.AccountParent
							
					 WHERE   H.Mission         = '#Mission#'
										 
					 AND     H.Journal IN (SELECT Journal 
					                       FROM   Journal
					                       WHERE  Journal       = H.Journal
										   AND    GLCategory    = 'Actuals'	
										   AND    JournalType   = 'General')
					    
					 <!--- added to exclude supporting journal --->
										 
					 AND     H.RecordStatus    IN ('1')
					 AND     H.ActionStatus    IN ('0','1')
					 AND     G1.AccountType    = '#itm#'	<!--- define on the level of the group --->
					 AND     G.AccountClass    = 'Balance'
					 
					 <cfif openingperiod neq "">	
					 					 					 
					 <!--- all opening transactions after the starting year --->
					 AND    (H.TransactionSource != 'Opening' OR H.TransactionSource = 'Opening' AND H.AccountPeriod = '#OpeningPeriod#')
					 					 					 
					 <!--- 2020-03-05 balance should not have opening transaction that do not belong
					 to that period below query was too slow 
					 
					 AND    NOT EXISTS (SELECT 'X'
					                    FROM  Accounting#Suffix#.dbo.TransactionHeader 
										WHERE Mission           = '#mission#' 
										AND   TransactionSource = 'Opening' 
										AND   AccountPeriod     > '#OpeningPeriod#' 
										AND   Journal         = H.Journal
										AND   JournalSerialNo = H.JournalSerialNo)						 
					 --->

					 </cfif>
														 		
					 AND  H.AccountPeriod IN (#preserveSingleQuotes(AccountPeriod)#) 
				 					
					 <cfif TransactionPeriod neq ""> 						
					 AND   H.TransactionPeriod <= #preserveSingleQuotes(transactionperiod)# 
					 </cfif>					  
					 
					GROUP BY H.OrgUnitOwner,
					         H.AccountPeriod, 
							 <cfif layout neq "corporate">
					         H.TransactionPeriod, 
							 </cfif>
							 G.GLAccount, 
							 G.Description, 
							 G.AccountLabel,
							 G.AccountGroup, 
							 G1.Description, 
							 G1.ListingOrder,
							 G1.AccountType,
							 G1.AccountParent, 
							 G2.Description
					
					<cfif itm eq "Debit"> UNION ALL </cfif>
					
					
				</cfloop>
				
				) AS Data
								
				ORDER BY OrgUnitOwner,
						 AccountPeriod		
						 
						
						 
			</cfquery>
			
			<!---
			<cfoutput>#cfquery.executiontime#</cfoutput>
			--->
			
		
		</cftransaction>					
						
		<cfquery name="DebitCorrection"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			UPDATE dbo.#table#
			SET    Debit = (Debit - Credit), 
			       Credit = 0.0
			WHERE  Panel = 'Debit'
			
		</cfquery>
		
		<cfquery name="CreditCorrection"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE  dbo.#table#
			SET     Credit = (Credit - Debit), 
			        Debit = 0.0
			WHERE   Panel = 'Credit'
		</cfquery>
									
		<cfquery name="Parameter" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_ParameterMission
			WHERE  Mission = '#Mission#'
		</cfquery>
		
		<cfset Threshold = 0.5>
		
		<cfif isDefined("Parameter.AmountThreshold")>
			<cfset Threshold = Parameter.AmountThreshold>
		</cfif>

		<cfquery name="SuppressZero"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			<cfif layout neq "corporate">	
				
				DELETE FROM dbo.#table#
				WHERE   abs(Credit) < #Threshold# and abs(Debit) < #Threshold#
				
			<cfelse>
			
				DELETE FROM dbo.#table#
				WHERE  GLAccount  IN (
					SELECT  GLAccount
					FROM    dbo.#table#
					GROUP   BY GLAccount 
					HAVING  ABS(SUM(Debit)) < #Threshold# AND ABS(SUM(Credit))< #Threshold#
				)
			
			</cfif>	
		
		</cfquery>			
				
	</cffunction>			
	
	<cffunction name="getIncomeStatement"
             access="public"
             displayname="get the Sales Price and Tax into a struct variable">
			 
			 	<cfargument name="Mission"             type="string"  required="true"   default="">								
				<cfargument name="AccountPeriod"       type="string"  required="true"   default="">				
				<cfargument name="TransactionPeriod"   type="string"  required="true"   default="">		
				<cfargument name="Currency"            type="string"  required="false"  default="#Application.BaseCurrency#">		
				<cfargument name="OrgUnitOwner"        type="string"  required="true"   default="">
				<cfargument name="OrgUnit"             type="string"  required="true"   default="">		
				<cfargument name="Program"             type="string"  required="true"   default="">	
				<cfargument name="History"             type="string"  required="true"   default="">
				<cfargument name="Mode"                type="string"  required="true"   default="economic">			
				<cfargument name="Aggregation"         type="string"  required="true"   default="Group">	
				<cfargument name="Layout"              type="string"  required="true"   default="corporate">
				<cfargument name="Suffix"              type="string"  required="true"   default="">
				<cfargument name="Table"               type="string"  required="true"   default="">				
										
				<cf_exchangeRate CurrencyFrom="#Application.BaseCurrency#" CurrencyTo="#currency#">		
						
				<cfquery name="getExchange"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">							 
					SELECT   *
					FROM      Accounting#Suffix#.dbo.Currency
					WHERE     Currency = '#Currency#'								
				</cfquery>	
								
				<!--- Query returning search results initial approval --->
				
				<cftransaction isolation="READ_UNCOMMITTED">
				
	
				<cfquery name="Extract"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						
					SELECT Panel,
					       AccountPeriod,
						   TransactionPeriod,						  
						   GLAccount,
						   Description,		
						   AccountType,
						   AccountLabel,				   
						   AccountGroup, 
						   AccountGroupDescription, 
						   AccountGroupOrder,
						   AccountGroupType,
						   AccountParent,
						   AccountParentDescription,	
						 
						   OrgUnit,
						   OrgUnitName,
						   OrgUnitHierarchy,
						   
						   CONVERT (varchar(10),'',1) as StatementCode,
						   CONVERT (varchar(80),'',1) as StatementName,
						   0 as StatementOrder,
						   
						   SUM(Debit) as Debit,
						   SUM(Credit) as Credit
						   
					INTO   UserQuery.dbo.#table#   	
				
					FROM (	
						
					<cfloop index="itm" list="Debit,Credit" delimiters=",">
					
					SELECT '#itm#' as Panel,
					       H.AccountPeriod,
						   
						   <cfif Mode eq "economic">
						        T.TransactionPeriod, 	
						   <cfelse>
						        H.TransactionPeriod, 	
						   </cfif>	  	 
						  
						   T.OrgUnit,
						   			
						   (SELECT OrgUnitName 
							FROM   Organization.dbo.Organization
							WHERE  OrgUnit = T.Orgunit) as OrgUnitName,
							
						   (SELECT HierarchyCode 
							FROM   Organization.dbo.Organization
							WHERE  OrgUnit = T.Orgunit) as OrgUnitHierarchy,							
								
							<!--- we add here the custom presentation --->
							
						   G.GLAccount, 
					       G.Description, 
						   G.AccountType,
						   G.AccountLabel,
						   G.AccountGroup, 
						   G1.Description  as AccountGroupDescription, 
						   G1.ListingOrder as AccountGroupOrder,
						   G1.AccountType  as AccountGroupType,
						   G1.AccountParent, 
						   G2.Description as AccountParentDescription, 						  
						   						   
						   <cfif currency eq Application.BaseCurrency>
						   						   
						       ISNULL(SUM(T.AmountBaseDebit),0)  as Debit, 
							   ISNULL(SUM(T.AmountBaseCredit),0) as Credit
						   
						   <cfelse>
						   
						   	  CASE WHEN T.Currency = '#currency#' THEN SUM(T.AmountDebit) ELSE SUM(T.AmountBaseDebit) 
				                      * #exc# END AS Debit,
							  CASE WHEN T.Currency = '#currency#' THEN SUM(T.AmountCredit) ELSE SUM(T.AmountBaseCredit) 
				                      * #exc# END AS Credit		  
								   
						   </cfif>	
						   
					 FROM 	Accounting#Suffix#.dbo.TransactionHeader H
							INNER JOIN Accounting#Suffix#.dbo.TransactionLine T
								ON H.Journal = T.Journal 
								AND H.JournalSerialNo = T.JournalSerialNo 							
							INNER JOIN Accounting#Suffix#.dbo.#Client.LanPrefix#Ref_Account G
								ON T.GLAccount = G.GLAccount
							INNER JOIN Accounting#Suffix#.dbo.#Client.LanPrefix#Ref_AccountGroup G1
								ON G.AccountGroup = G1.AccountGroup
							INNER JOIN Accounting#Suffix#.dbo.#Client.LanPrefix#Ref_AccountParent G2
								ON G1.AccountParent = G2.AccountParent	 				
											   
					WHERE   H.Mission         = '#Mission#'
										 
					 AND    H.Journal IN (SELECT Journal 
					                       FROM   Accounting#Suffix#.dbo.Journal
					                       WHERE  Journal       = H.Journal
										   AND    GLCategory    = 'Actuals'	
										   AND    JournalType   = 'General')	
										   
					<cfif History eq "AccountPeriod">					 					 
					 	AND   H.AccountPeriod IN (#preservesinglequotes(AccountPeriod)#)												  												 
					<cfelse>					
						AND   H.AccountPeriod  = #preserveSingleQuotes(AccountPeriod)#																				 
					</cfif>					      
										
					AND    H.RecordStatus    IN ( '1')
					AND    H.ActionStatus IN ('0','1')
											
					<cfif Program neq "">
					    AND   T.ProgramCode = '#Program#'
					</cfif>
															
					<cfif OrgUnit neq "">					  
						 AND   T.OrgUnit IN (#preservesingleQuotes(orgunit)#)		 
					</cfif>
					
					<cfif OrgUnitOwner neq "">
					     AND   H.OrgUnitOwner IN (#preservesinglequotes(orgunitowner)#) 	 
					</cfif>
					
					AND    G1.AccountType        = '#itm#'
					
					<!--- PL accounts --->
					AND    G.AccountClass        = 'Result'									
					
					
					GROUP BY H.AccountPeriod,
 							 <cfif Mode eq "economic">
							 T.TransactionPeriod,
							 <cfelse>
							 H.TransactionPeriod,
							 </cfif>
							 <!---
							 <cfif Aggregation eq "groupcenter" or Aggregation eq "groupdetailcenter">
							 --->
							 T.OrgUnit,
							 <!---
							 </cfif>
							 --->
							 G.GLAccount,
							 G.Description,
							 G.AccountLabel,
							 G.AccountType,
							 G.AccountGroup, 
							 G1.Description, 
							 G1.Listingorder,
							 G1.AccountType,
							 G1.AccountParent,
							 G2.Description
							 <cfif currency neq Application.BaseCurrency>
							 ,T.Currency		
							 </cfif> 
							 
					
					<cfif itm eq "Debit"> UNION ALL </cfif>
					
					</cfloop>
					
					) as Sub					
					
					GROUP BY Panel,
					         AccountPeriod,
							 TransactionPeriod,
							 <!---
							 <cfif Aggregation eq "groupcenter" or Aggregation eq "groupdetailcenter">
							 --->
							     OrgUnit,
								 OrgUnitName,
								 OrgUnitHierarchy,
							 <!---	 
						     </cfif>
							 --->
							 GLAccount,
							 Description,
							 AccountLabel,
							 AccountType,
							 AccountGroup, 
							 AccountGroupDescription, 
							 AccountGroupOrder,
							 AccountGroupType,
							 AccountParent,
							 AccountParentDescription			 
								
				</cfquery>				
				
				</cftransaction>				
				
				<!---
				<cfoutput>#cfquery.executiontime#</cfoutput>		
				--->
				
				<cfif History neq "AccountPeriod">
				
				<!--- adjustment of the original query to take out this from the filtering --->
				
				<cfquery name="clean"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					  DELETE FROM dbo.#table# 
					  WHERE TransactionPeriod NOT IN (#preservesinglequotes(transactionperiod)#) 					
				</cfquery>
				
				</cfif>
				
				<!---
				<CFOUTPUT>#CFQUERY.EXECUTIONTIME#</CFOUTPUT>
				--->				
				
				<cfquery name="updateGLAccountUnit"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					UPDATE    dbo.#table# 
					SET       StatementCode    = RU.StatementCode,
							  StatementName    = RU.StatementName,
							  StatementOrder   = RU.StatementOrder										
					
					FROM      Accounting#Suffix#.dbo.Ref_StatementAccountUnit S 
					          INNER JOIN Accounting#Suffix#.dbo.Ref_StatementPresentation RU 
								  		ON S.Mission = RU.Mission 
									   AND S.StatementCode = RU.StatementCode 
							  INNER JOIN userQuery.dbo.#table# V 
								        ON S.GLAccount = V.GLAccount 
									   AND s.OrgUnit  = V.OrgUnit
					WHERE     S.Mission = '#mission#'									
					
				</cfquery>
				
				<!--- we go a step back and match only on the GLAccount if the vlaue is still NULL --->
				
				<cfquery name="updateGLAccountSec"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE    dbo.#table# 
					SET       StatementCode    = RU.StatementCode,
							  StatementName    = RU.StatementName,
							  StatementOrder   = RU.StatementOrder										
					
					FROM      Accounting#Suffix#.dbo.Ref_StatementAccountUnit S 
					          INNER JOIN Accounting#Suffix#.dbo.Ref_StatementPresentation RU ON S.Mission = RU.Mission AND S.StatementCode = RU.StatementCode 
							  INNER JOIN userQuery.dbo.#table# V ON S.GLAccount = V.GLAccount AND s.OrgUnit = '0'
					WHERE     S.Mission = '#mission#'
					<!--- only if this was not updated yet --->
					AND       V.StatementCode is NULL					
				</cfquery>
								
				<!--- correction if the glaccount is defined as debit, make sure only debit has a value --->
				
				<cfquery name="resetDebitPanel"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE dbo.#table# 
					SET    Debit = (Debit - Credit), 
					       Credit = 0.0
					WHERE  Panel = 'Debit'
				</cfquery>
				
				<!--- correction if the glaccount is defined as debit, make sure only debit has a value --->
				
				<cfquery name="resetCreditPanel"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE  dbo.#table#  
					SET     Credit = (Credit - Debit), 
					        Debit = 0.0
					WHERE   Panel = 'Credit' 
				</cfquery>
				
				<!--- added 8/6/2015 to make the list leaner in case of near 0 amounts that are less than 1 --->
				
				<cfquery name="SuppressZero"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM dbo.#table#
					WHERE   ABS(Credit) < 0.25 and ABS(Debit) < 0.25	
				</cfquery>
		
	</cffunction>		
	
	
	<cffunction name="getFundStatement"
             access="public"
             displayname="get the Sales Price and Tax into a struct variable">
			 
			 	<cfargument name="Mission"             type="string"  required="true"   default="">								
				<cfargument name="AccountPeriod"       type="string"  required="true"   default="">				
				<cfargument name="TransactionPeriod"   type="string"  required="true"   default="">		
				<cfargument name="Currency"            type="string"  required="false"  default="#Application.BaseCurrency#">		
				<cfargument name="OrgUnitOwner"        type="string"  required="true"   default="">
				<cfargument name="OrgUnit"             type="string"  required="true"   default="">		
				<cfargument name="Program"             type="string"  required="true"   default="">	
				<cfargument name="History"             type="string"  required="true"   default="">
				<cfargument name="Mode"                type="string"  required="true"   default="economic">			
				<cfargument name="Aggregation"         type="string"  required="true"   default="Group">	
				<cfargument name="Layout"              type="string"  required="true"   default="corporate">
				<cfargument name="Suffix"              type="string"  required="true"   default="">
				<cfargument name="Table"               type="string"  required="true"   default="">				
										
				<cf_exchangeRate CurrencyFrom="#Application.BaseCurrency#" CurrencyTo="#currency#">		
						
				<cfquery name="getExchange"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">							 
					SELECT   *
					FROM      Accounting#Suffix#.dbo.Currency
					WHERE     Currency = '#Currency#'								
				</cfquery>	
								
				<!--- Query returning search results initial approval --->
				
				<cftransaction isolation="READ_UNCOMMITTED">
				
	
				<cfquery name="Extract"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						
					SELECT Panel,
					       AccountPeriod,
						   TransactionPeriod,						  
						   GLAccount,
						   Description,		
						   AccountType,
						   AccountLabel,				   
						   AccountGroup, 
						   AccountGroupDescription, 
						   AccountGroupOrder,
						   AccountGroupType,
						   AccountParent,
						   AccountParentDescription,	
						 
						   OrgUnit,
						   OrgUnitName,
						   OrgUnitHierarchy,
						   
						   CONVERT (varchar(10),'',1) as StatementCode,
						   CONVERT (varchar(80),'',1) as StatementName,
						   0 as StatementOrder,
						   						
						   GLCategory,
						   SUM(Debit) as Debit,
						   SUM(Credit) as Credit
						   
					INTO   UserQuery.dbo.#table#   	
				
					FROM (	
					
					<cfloop index="itm" list="Spending,Source" delimiters=",">
					
					<cfif itm eq "Spending">
					<cfset pnl = "Debit">
					<cfelse>
					<cfset pnl ="Credit">
					</cfif>
																
					SELECT '#pnl#' as Panel,
					       H.AccountPeriod,
						   
						   <cfif Mode eq "economic">
						        T.TransactionPeriod, 	
						   <cfelse>
						        H.TransactionPeriod, 	
						   </cfif>	  	 
						  
						   T.OrgUnit,
						   			
						   (SELECT OrgUnitName 
							FROM   Organization.dbo.Organization
							WHERE  OrgUnit = T.Orgunit) as OrgUnitName,
							
						   (SELECT HierarchyCode 
							FROM   Organization.dbo.Organization
							WHERE  OrgUnit = T.Orgunit) as OrgUnitHierarchy,							
								
							<!--- we add here the custom presentation --->
							
						   G.GLAccount, 
					       G.Description, 
						   G.AccountType,
						   G.AccountLabel,
						   G.AccountGroup, 
						   G1.Description  as AccountGroupDescription, 
						   G1.ListingOrder as AccountGroupOrder,
						   G1.AccountType  as AccountGroupType,
						   G1.AccountParent, 
						   G2.Description as AccountParentDescription, 						  
						   J.GLCategory,	
						   
						   <cfif currency eq Application.BaseCurrency>
						   
						       ISNULL(SUM(T.AmountBaseDebit),0)  as Debit, 
							   ISNULL(SUM(T.AmountBaseCredit),0) as Credit
						   
						   <cfelse>
						   
						   	  CASE WHEN T.Currency = '#currency#' THEN SUM(T.AmountDebit) ELSE SUM(T.AmountBaseDebit) 
				                      * #exc# END AS Debit,
							  CASE WHEN T.Currency = '#currency#' THEN SUM(T.AmountCredit) ELSE SUM(T.AmountBaseCredit) 
				                      * #exc# END AS Credit		  
								   
						   </cfif>		   
					
					FROM   Accounting#Suffix#.dbo.TransactionHeader H,
					       Accounting#Suffix#.dbo.TransactionLine T, 
					       Accounting#Suffix#.dbo.Journal J,
					       Accounting#Suffix#.dbo.#Client.LanPrefix#Ref_Account G, 
						   Accounting#Suffix#.dbo.#Client.LanPrefix#Ref_AccountGroup G1,
						   Accounting#Suffix#.dbo.#Client.LanPrefix#Ref_AccountParent G2,						
						   Accounting#Suffix#.dbo.Ref_GLCategory C
					
					WHERE  H.Mission         = '#Mission#'  
					
					AND    H.RecordStatus    IN ( '1')
					AND    H.ActionStatus IN ('0','1')
					
				    AND    T.Journal         = J.Journal
					AND    H.Journal         = T.Journal	
				    AND    H.JournalSerialNo = T.JournalSerialNo 
					
					<cfif Program neq "">
					    AND   T.ProgramCode = '#Program#'
					</cfif>
															
					<cfif OrgUnit neq "">					  
						 AND   T.OrgUnit IN (#preservesingleQuotes(orgunit)#)		 
					</cfif>
					
					<cfif OrgUnitOwner neq "">
					     AND   H.OrgUnitOwner IN (#preservesinglequotes(orgunitowner)#) 	 
					</cfif>
						
					AND    J.GLCategory          = 'Actuals'	
					AND    J.JournalType         = 'General'
					AND    J.GLCategory          = C.GLCategory 		
					AND    G.GLAccount           = T.GLAccount		
										
					<!--- main criteria select only header transactions that have a funding account included in the posting
					 so you see the movement of that account,
					 this thus excludes depreciation, supply distribution transaction etc are these are not relevant for
					 any cashflow perspective and would pollute the view --->
					 	 
					AND H.TransactionId IN  (
					                         SELECT   H1.TransactionId
				                             FROM     Accounting#Suffix#.dbo.TransactionLine L1, Accounting#Suffix#.dbo.TransactionHeader H1
				                             WHERE    L1.Journal         = H1.Journal 
											 AND      L1.JournalSerialNo = H1.JournalSerialNo 
											 AND      GLAccount IN ( SELECT Accounting#Suffix#.dbo.GLAccount FROM Ref_Account WHERE FundAccount = 1 )
											 AND      H1.Mission = '#Mission#' 
											 AND      H1.TransactionId = H.TransactionId
											 )
											  
					AND   T.GLAccount NOT IN ( SELECT Accounting#Suffix#.dbo.GLAccount FROM Ref_Account WHERE FundAccount = 1 )				       			  
											  
					 <cfif itm eq "Spending">
					 AND   T.AmountBaseDebit >= T.AmountBaseCredit					 										  
					 <cfelse>										 
					 AND   T.AmountBaseDebit < T.AmountBasecredit						 											   
					 </cfif>		
					 
					 <!--- to be checked for this view 01/02/2009  !!!
					 remove opening balance transactions --->
					 AND     J.Journal IN (SELECT Journal 
						                   FROM   Accounting#Suffix#.dbo.Journal 
										   WHERE  SystemJournal != 'Opening' or SystemJournal is NULL) 		
										   
										   
					 AND    J.Journal != 'SIO-9002'					   		  				
																								
					 AND    G1.AccountGroup  = G.AccountGroup	
					 AND    G1.AccountParent = G2.AccountParent
					
					<cfif History eq "AccountPeriod">
					 					 
					 	AND   H.AccountPeriod IN (#preservesinglequotes(AccountPeriod)#)	 						  
												 
					<cfelse>
					
						AND   H.AccountPeriod  = #preserveSingleQuotes(AccountPeriod)#		
												 
					</cfif>
					
					GROUP BY H.AccountPeriod,
 							 <cfif Mode eq "economic">
							 T.TransactionPeriod,
							 <cfelse>
							 H.TransactionPeriod,
							 </cfif>
							 <!---
							 <cfif Aggregation eq "groupcenter" or Aggregation eq "groupdetailcenter">
							 --->
							 T.OrgUnit,
							 <!---
							 </cfif>
							 --->
							 G.GLAccount,
							 G.Description,
							 G.AccountLabel,
							 G.AccountType,
							 G.AccountGroup, 
							 G1.Description, 
							 G1.Listingorder,
							 G1.AccountType,
							 G1.AccountParent,
							 G2.Description,							
							 J.GLCategory,
							 T.Currency	
					
					<cfif itm eq "Spending"> UNION ALL </cfif>
					
					</cfloop>
					
					) as Sub
					
					
					GROUP BY Panel,
					         AccountPeriod,
							 TransactionPeriod,
							 <!---
							 <cfif Aggregation eq "groupcenter" or Aggregation eq "groupdetailcenter">
							 --->
							     OrgUnit,
								 OrgUnitName,
								 OrgUnitHierarchy,
							 <!---	 
						     </cfif>
							 --->
							 GLAccount,
							 Description,
							 AccountLabel,
							 AccountType,
							 AccountGroup, 
							 AccountGroupDescription, 
							 AccountGroupOrder,
							 AccountGroupType,
							 AccountParent,
							 AccountParentDescription,												
							 GLCategory								 
								
				</cfquery>				
				
				</cftransaction>
				
				<!---
				<CFOUTPUT>#CFQUERY.EXECUTIONTIME#</CFOUTPUT>
				--->
				
				<cfif History neq "AccountPeriod">
				
				<!--- adjustment of the original query to take out this from the filtering --->
				
				<cfquery name="clean"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					  DELETE FROM dbo.#table# 
					  WHERE TransactionPeriod NOT IN (#preservesinglequotes(transactionperiod)#) 					
				</cfquery>
				
				</cfif>
				
				<!---
				<CFOUTPUT>#CFQUERY.EXECUTIONTIME#</CFOUTPUT>
				--->				
				
				<cfquery name="updateGLAccountUnit"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					UPDATE    dbo.#table# 
					SET       StatementCode    = RU.StatementCode,
							  StatementName    = RU.StatementName,
							  StatementOrder   = RU.StatementOrder										
					
					FROM      Accounting#Suffix#.dbo.Ref_StatementAccountUnit S 
					          INNER JOIN Accounting#Suffix#.dbo.Ref_StatementPresentation RU 
								  		ON S.Mission = RU.Mission 
									   AND S.StatementCode = RU.StatementCode 
							  INNER JOIN userQuery.dbo.#table# V 
								        ON S.GLAccount = V.GLAccount 
									   AND s.OrgUnit  = V.OrgUnit
					WHERE     S.Mission = '#mission#'									
					
				</cfquery>
				
				<!--- we go a step back and match only on the GLAccount if the vlaue is still NULL --->
				
				<cfquery name="updateGLAccountSec"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE    dbo.#table# 
					SET       StatementCode    = RU.StatementCode,
							  StatementName    = RU.StatementName,
							  StatementOrder   = RU.StatementOrder										
					
					FROM      Accounting#Suffix#.dbo.Ref_StatementAccountUnit S 
					          INNER JOIN Accounting#Suffix#.dbo.Ref_StatementPresentation RU ON S.Mission = RU.Mission AND S.StatementCode = RU.StatementCode 
							  INNER JOIN userQuery.dbo.#table# V ON S.GLAccount = V.GLAccount AND s.OrgUnit = '0'
					WHERE     S.Mission = '#mission#'
					<!--- only if this was not updated yet --->
					AND       V.StatementCode is NULL					
				</cfquery>
								
				<!--- correction if the glaccount is defined as debit, make sure only debit has a value --->
				
				<cfquery name="resetDebitPanel"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE dbo.#table# 
					SET    Debit = (Debit - Credit), 
					       Credit = 0.0
					WHERE  Panel = 'Debit'
				</cfquery>
				
				<!--- correction if the glaccount is defined as debit, make sure only debit has a value --->
				
				<cfquery name="resetCreditPanel"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE  dbo.#table#  
					SET     Credit = (Credit - Debit), 
					        Debit = 0.0
					WHERE   Panel = 'Credit' 
				</cfquery>
				
				<!--- added 8/6/2015 to make the list leaner in case of near 0 amounts that are less than 1 --->
				
				<cfquery name="SuppressZero"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM dbo.#table#
					WHERE   ABS(Credit) < 0.25 and ABS(Debit) < 0.25	
				</cfquery>
		
	</cffunction>
	
	
	<!--- can be removed --->
	
	<cffunction name="getFundStatement_old"
             access="public"
             displayname="get the Sales Price and Tax into a struct variable">
						
		<cfargument name="Mission"       type="string"  required="true"   default="">				
		<cfargument name="Period"        type="string"  required="true"   default="All">				
		<cfargument name="TableName"     type="string"  required="true"   default="">
		<cfargument name="SelectionDate" type="date"    required="false"  default="#now()#">
		<cfargument name="Currency"      type="string"  required="false"  default="USD">				
	
		<cfset FileNo = round(Rand()*30)>
		
		<cf_droptable dbname="AppsQuery" tblname="#TableName#">	

		<cfif Currency neq "USD">
			<cfquery name="ExchangeRate"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TOP 1 ExchangeRate
				FROM CurrencyExchange
				WHERE Currency = '#Currency#'
			</cfquery>
			
			<cfset vExchangeRate = ExchangeRate.ExchangeRate>		
		
		<cfelse>		
			<cfset vExchangeRate = 1>		
		
		</cfif>		
		
		<cfloop index="itm" list="Spending,Source" delimiters=",">

			<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Fund#Itm##FileNo#">
	
			<!--- Query returning search results initial approval --->
			<cfquery name="Cost"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
					SELECT DISTINCT G.GLAccount, 
					                G.Description, 
									G.AccountGroup, 
									G1.Description as AccountGroupDescription, 
									J.GLCategory,
									(SELECT PresentationColor 
									 FROM   Ref_PresentationClass 
									 WHERE Code = G.PresentationClass) as PresentationColor,
									G.FundAccount,
									'#itm#' as RecordType,
			         				ROUND(SUM(T.AmountBaseDebit) * #vExchangeRate#,2) as Debit, 
					 				ROUND(SUM(T.AmountBaseCredit) * #vExchangeRate#,2) as Credit
									
					INTO   UserQuery.dbo.#SESSION.acc#Fund#Itm##FileNo#   
					FROM   TransactionLine T, 
					       TransactionHeader H,
					       Journal J,
					       Ref_Account G, 
						   Ref_AccountGroup G1,
						   Ref_GLCategory C
					WHERE  T.Journal = H.Journal 
					 AND   T.JournalSerialNo = H.JournalSerialNo	
					 AND   T.Journal       = J.Journal
					 AND   H.Mission       = '#Mission#'
					 AND   H.Journal IN (SELECT Journal 
					                     FROM   Journal 
										 WHERE  GLCategory = 'Actuals')	
					 AND   G.GLAccount     = T.GLAccount
					 
					 <cfif SelectionDate lte now()>
				 	   AND  H.TransactionDate <= #SelectionDate#
					 </cfif>
				 		 
					 <!--- select only header transactions that have a funding account included, so you see the movement, 
					 this means that depreciation, supply distribution transaction for example are not included as not financials
					 are included --->
					 	 
					  AND H.TransactionId IN  (SELECT   H.TransactionId
				                               FROM     TransactionLine L, TransactionHeader H
				                               WHERE    L.Journal = H.Journal 
											   AND      L.JournalSerialNo = H.JournalSerialNo 
											   AND      GLAccount IN (SELECT GLAccount 
											                          FROM Ref_Account 
																	  WHERE FundAccount = 1)
											  )
					 				  
					 	 
					 <!--- only accounts that are not funding accounts 
					 AND   T.GLAccount NOT IN
				                         (SELECT  GLAccount
				                          FROM    Ref_Account
				                          WHERE   FundAccount = 1)	 
										  --->						   
										   
					 <cfif itm eq "Spending">
					 AND   (T.AmountBaseDebit >= T.AmountBasecredit
					 
					 OR T.GLAccount IN
				                         (SELECT  GLAccount
				                          FROM    Ref_Account
				                          WHERE   FundAccount = 1)	)
					 <cfelse>
					 AND   T.AmountBaseDebit < T.AmountBasecredit	
					 
					 AND   T.GLAccount NOT IN
				                         (SELECT  GLAccount
				                          FROM    Ref_Account
				                          WHERE   FundAccount = 1)	 
										   
					 </cfif>
					 	
					 AND   G1.AccountGroup = G.AccountGroup
					 AND   J.GLCategory     = C.GLCategory 
					 
					 <!--- the transactions in the warehouse/asset module are per definition not part
					 of the funds and cen be excluded --->
					 
						 AND     J.Journal NOT IN (SELECT Journal 
						                       FROM   Journal 
											   WHERE  SystemJournal IN ('Warehouse','Asset')) 
					 
						 <cfif period eq "All">
						 
						 
						 
						 <!--- to be checked for this view 01/02/2009  !!!
						 remove opening balance transactions --->
						 AND     J.Journal IN (SELECT Journal 
						                       FROM   Journal 
											   WHERE  SystemJournal != 'Opening' or SystemJournal is NULL) 
											   
										   
											   
						 <cfelse>
						 
						 AND     T.AccountPeriod  = '#Period#'
						 
						 AND     J.Journal IN (SELECT Journal 
						                       FROM   Journal 
											   WHERE  SystemJournal != 'Opening' or SystemJournal is NULL) 
											   
						 </cfif>
						 
					GROUP BY G.GLAccount, G.Description, G.AccountGroup, G1.Description,J.GLCategory,G.PresentationClass, G.FundAccount
					ORDER BY G.GLAccount, G.Description, G.AccountGroup, G1.Description,J.GLCategory,G.FundAccount
					
			</cfquery>
		
		</cfloop>

		<cfquery name="Cost1"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE dbo.#SESSION.acc#FundSpending#FileNo# 
			SET Debit = 0.0
			WHERE Debit is null
		</cfquery>
		
		<cfquery name="Cost2"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE dbo.#SESSION.acc#FundSpending#FileNo# 
			SET Debit = (Debit - Credit), Credit = 0.0
			WHERE Credit is not null
		</cfquery>
		
		<cfquery name="Gain1"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE dbo.#SESSION.acc#FundSource#FileNo# 
			SET Credit = 0.0
			WHERE Credit is null 
		</cfquery>
		
		<cfquery name="Gain2"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE dbo.#SESSION.acc#FundSource#FileNo#  
			SET Credit = (Credit - Debit), Debit = 0.0
			WHERE Debit is not null
		</cfquery>
		
		<cfquery name="IncomeStmt"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			INTO UserQuery.dbo.#TableName#
			FROM dbo.#SESSION.acc#FundSpending#FileNo#  
			UNION ALL
			SELECT *
			FROM dbo.#SESSION.acc#FundSource#FileNo#  
		</cfquery>	
				
	</cffunction>
</cfcomponent>