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
<!---

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#FactAllotment"> 
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#FactRequests"> 
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#FactExecution"> 

<!---
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#ExecutionIMIS"> 
--->

<cfquery name="Param" 
	 datasource="AppsProgram" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   Ref_ParameterMission 
	 WHERE  Mission = '#url.mission#'
</cfquery>	 

<cfsavecontent variable="ProgramMaster">
    <cfoutput>
	SELECT Px.ProgramCode, Px.ProgramName, Pex.PeriodHierarchy, Pex.Period
	FROM   Program.dbo.Program Px INNER JOIN Program.dbo.ProgramPeriod Pex ON Px.ProgramCode = Pex.ProgramCode
	AND    Px.Mission = '#URL.Mission#'
	</cfoutput>
</cfsavecontent>
		
<cfquery name="Requests" 
	 datasource="AppsProgram" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">

	SELECT	newid() as FactTableId,
	
			CONVERT(varchar,isnull(PORG.OrgUnit,'0')) as ParentUnit_dim,			
			PORG.OrgUnitName as ParentUnit_nme,
			
			CONVERT(varchar,isnull(ORG.OrgUnit,'0')) as Orgunit_dim,
			ORG.OrgUnitName as OrgUnit_nme,
			
			PP.ProgramCode                        as MainProgram_dim,
			LEFT(PP.ProgramName,60)               as MainProgram_nme,			
			PP.PeriodHierarchy                    as MainProgram_ord,
			
			P.ProgramCode                         as Program_dim,
			Pe.Reference + ' - ' + P.ProgramName  as Program_nme,
			Pe.PeriodHierarchy                    as Program_ord,
			
			PAD.ItemMaster as Item_dim,
			(SELECT Description FROM Purchase.dbo.ItemMaster WHERE Code = PAD.ItemMaster) as Item_nme,
						
			(   SELECT  TOP 1 BudgetCategory 
				FROM    ProgramAllotmentRequest R 
				WHERE   P.ProgramCode = R.ProgramCode 
				AND     PAD.Period    = R.Period 
				AND     PAD.EditionId = R.EditionId) AS BudgetCategory,
				
			RS.Code                as Resource_dim,
			RS.Description         as Resource_nme,
			
			O.Code                 as Object_dim,
			O.Description          as Object_nme,
			
			CONVERT(varchar,isnull(PAD.EditionId,'')) as Edition_dim,
			E.Description          as Edition_nme,
			
			PAD.Period             as Period_dim,
			PAD.Fund               as Fund_dim,
			
			PAD.ActionStatus as RequirementStatus_dim,			
			CASE PAD.ActionStatus WHEN '0' THEN 'On-hold' WHEN '1' THEN 'Requested'	END as RequirementStatus_nme,
			
			CASE WHEN CONVERT(varchar,isnull(PAD.RequestRemarks,'')) = '' THEN PAD.RequestDescription 
				 WHEN RequestDescription = convert(varchar(500),RequestRemarks) THEN PAD.RequestDescription 
				 ELSE PAD.RequestDescription + '. ' + convert(varchar(500),PAD.RequestRemarks) END as RequestRemarks,
			
			round(PAD.RequestQuantity,2)       as RequestQuantity, 
			round(PAD.RequestPrice,2)          as RequestPrice, 
			round(PAD.RequestAmountBase*(ED.PercentageRelease/100),2) AS Total <!--- budget currency 26/8/2018 --->		
						
	INTO   UserQuery.dbo.#SESSION.acc#FactRequests
	
	FROM   ProgramPeriod Pe 
			INNER JOIN ProgramAllotment PA         ON Pe.ProgramCode  = PA.ProgramCode  AND Pe.Period = PA.Period
			INNER JOIN ProgramAllotmentRequest PAD ON PA.ProgramCode  = PAD.ProgramCode AND PA.Period = PAD.Period AND PA.EditionId = PAD.EditionId
			INNER JOIN Ref_AllotmentEditionFund ED ON ED.Fund         = PAD.Fund        AND ED.EditionId = PA.EditionId
			INNER JOIN Program P                   ON Pe.Programcode  = P.ProgramCode
			INNER JOIN Ref_Object O                ON PAD.ObjectCode  = O.code
			INNER JOIN Ref_Resource RS             ON O.Resource      = RS.Code
			INNER JOIN Ref_AllotmentEdition E      ON PAD.EditionId   = E.EditionId <!---AND PAD.Period = E.Period--->
			
			<!--- find the root programcode for this one --->
			
			LEFT OUTER JOIN (#preservesinglequotes(ProgramMaster)#) as PP ON SUBSTRING(Pe.PeriodHierarchy,charindex('_',Pe.PeriodHierarchy)+1,
					       CASE charindex('.',Pe.PeriodHierarchy) WHEN 0 THEN len(Pe.PeriodHierarchy) ELSE (charindex('.',Pe.PeriodHierarchy)-1) END 
						   -(charindex('_',Pe.PeriodHierarchy))) = PP.ProgramCode 
						   AND Pe.Period = PP.Period	
			 
			INNER JOIN Organization.dbo.Organization ORG ON ORG.OrgUnit = Pe.OrgUnit
			LEFT JOIN  Organization.dbo.Organization PORG ON ORG.HierarchyRootUnit = PORG.OrgUnitCode AND ORG.Mission = PORG.Mission 

			<!--- to be reviewed to make it generic --->
			LEFT JOIN ProgramAllotmentRequestTopic PAT ON PAD.RequirementId = PAT.RequirementId
			<!---
			LEFT JOIN Ref_TopicList TL1 ON PAT.Topic = TL1.code and PAT.ListCode = TL1.ListCode	 AND TL1.Code ='CF01'
			LEFT JOIN Ref_TopicList TL2 ON PAT.Topic = TL2.code and PAT.ListCode = TL2.ListCode	 AND TL2.Code ='PRI01'
			--->
	
	WHERE   PORG.MandateNo =  ( SELECT TOP 1 MandateNo
	                            FROM   Organization.dbo.Ref_MissionPeriod
						        WHERE  Mission       = '#url.mission#'
						        AND    DefaultPeriod = 1 )	
	
	AND     P.Mission = '#url.mission#'
	
	AND     PAD.ActionStatus IN ('0','1')
	AND     Pe.RecordStatus != '9'
		
</cfquery>
	 			             
<cfquery name="Allotment" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   
		SELECT	newid() as FactTableId,
		
				<!--- root unit devision/service --->
				CONVERT(varchar,isnull(PORG.OrgUnit,'')) as Service_dim,		 
				PORG.OrgUnitName   as Service_nme,
		
				<!--- unit of the program --->		
				CONVERT(varchar,isnull(ORG.OrgUnit,'')) as Orgunit_dim,
				ORG.OrgUnitName    as OrgUnit_nme,
				
				<!--- added 1/6/2013 added source unit --->
				CONVERT(varchar,isnull(AORG.OrgUnit,'0')) as SourceUnit_dim,
				AORG.OrgUnitName   as SourceUnit_nme,
				
				PP.ProgramCode     as MainProgram_dim,
				PP.ProgramName     as MainProgram_nme,
				PP.PeriodHierarchy as MainProgram_ord,
				
				P.ProgramCode as Program_dim,
				LEFT(Pe.Reference + ' - ' + P.ProgramName,60) as Program_nme,				 
				Pe.PeriodHierarchy as Program_ord,
				
				(   SELECT TOP 1 BudgetCategory 
				    FROM   ProgramAllotmentRequest R 
				    WHERE  P.ProgramCode = R.ProgramCode 
				    AND    PAD.Period = R.Period AND PAD.EditionId = R.EditionId) AS BudgetCategory,
					
				RS.Code          as Resource_dim,
				RS.Description   as Resource_nme,
				
				O.Code           as OExpenditure_dim,
				O.Description    as OExpenditure_nme,
				
				CONVERT(varchar,isnull(PAD.EditionId,'')) as Edition_dim,
				E.Description                             as Edition_nme,
				
				PAD.Period       as Period_dim,
				
				CONVERT(varchar,DATEPART(year, PAD.TransactionDate))  as Year_dim,
				CONVERT(varchar,DATEPART(month, PAD.TransactionDate)) as Month_dim,
				
				PAD.Fund         as Fund_dim,				
				<!--- budget currency --->
				ROUND(SUM(PAD.Amount*(ED.PercentageRelease/100)),2) AS BudgetAmount   
				
		INTO    UserQuery.dbo.#SESSION.acc#FactAllotment
		
		FROM	ProgramPeriod Pe 
				INNER JOIN Program P                   ON Pe.Programcode = P.ProgramCode
				INNER JOIN ProgramAllotment PA         ON Pe.ProgramCode = PA.ProgramCode AND Pe.Period = PA.Period
				INNER JOIN ProgramAllotmentDetail PAD  ON PA.ProgramCode = PAD.ProgramCode AND PA.Period = PAD.Period AND PA.EditionId = PAD.EditionId
				INNER JOIN Ref_AllotmentEditionFund ED ON ED.Fund = PAD.Fund AND ED.EditionId = PA.EditionId				
				INNER JOIN Ref_Object O                ON PAD.ObjectCode = O.code
				INNER JOIN Ref_Resource RS             ON O.Resource     = RS.Code
				INNER JOIN Ref_AllotmentEdition E      ON PAD.EditionId  = E.EditionId <!---AND PAD.Period = E.Period--->
				
				LEFT OUTER JOIN (#preservesinglequotes(ProgramMaster)#) PP ON substring(Pe.PeriodHierarchy,charindex('_',Pe.PeriodHierarchy)+1,
					       CASE charindex('.',Pe.PeriodHierarchy) WHEN 0 
					                                       THEN len(Pe.PeriodHierarchy)	
														   ELSE (charindex('.',Pe.PeriodHierarchy)-1) END -(charindex('_',Pe.PeriodHierarchy))) 
				 = PP.ProgramCode AND Pe.Period = PP.Period	
						
				INNER JOIN Organization.dbo.Organization ORG       ON ORG.OrgUnit = Pe.OrgUnit
				<!--- obtain the root unit --->
				LEFT JOIN Organization.dbo.Organization PORG       ON ORG.HierarchyRootUnit = PORG.OrgUnitCode AND ORG.Mission = PORG.Mission 
				
				<!--- added --->
				LEFT OUTER JOIN Organization.dbo.Organization AORG ON AORG.OrgUnit = PAD.OrgUnit
				
		WHERE   PORG.MandateNo =  (SELECT TOP 1 MandateNo 
		                           FROM   Organization.dbo.Ref_MissionPeriod
		                           WHERE  Mission       = '#url.mission#'
								   AND    DefaultPeriod = 1)
								   
		AND     P.Mission  = '#url.mission#'
		AND     PAD.Status IN ('0','1')
		AND     Pe.RecordStatus != '9'
		
		<!--- PE.Period    = '#url.period#' --->
		 
		GROUP BY PORG.OrgUnit,
		        PORG.OrgUnitName,
				ORG.OrgUnit,
				ORG.OrgUnitName,
				AORG.OrgUnit,
				AORG.OrgUnitName,
				PP.ProgramCode,
				PP.ProgramName, 
				PP.PeriodHierarchy, 
				P.ProgramCode,
				Pe.Reference,
				P.ProgramName, 
				Pe.PeriodHierarchy, 
				RS.Code,
				RS.Description,
				O.Code,
				O.Description,
				PAD.EditionId,
				E.Description,
				PAD.Period,
				PAD.Fund,
				PAD.TransactionDate
		
</cfquery>

	
<cfquery name="Execution" 
   datasource="AppsLedger" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">      
   	   
	   SELECT     newid() as FactTableId, *
	   
	   INTO       UserQuery.dbo.#SESSION.acc#FactExecution	    
	              
	   FROM      (
	   
			   SELECT TOP 100 PERCENT   
			   			  <!--- transaction Disbursement, obligation --->				  
			              H.Journal AS Transaction_dim, 
						  Journal.Description  as Transaction_nme, 
						  
						  L.Fund AS Fund_dim, 
						  
						  S.Code AS Resource_dim, 
						  S.Description           as Resource_nme, 
						  
						  L.ObjectCode            as Object_dim, 
			              O.Description           as Object_nme, 
						 				 				  
						  P.ProgramCode           as Program_dim,
						  LEFT(P.ProgramName,60)  as Program_nme,			
						  Pe.PeriodHierarchy      as Program_ord,
														  
						  PP.ProgramCode          as MainProgram_dim,
					      LEFT(PP.ProgramName,60) as MainProgram_nme,			
						  PP.PeriodHierarchy      as MainProgram_ord,				  
						  
						  L.ProgramPeriod         as Period_dim,
										  
						  H.Reference             as Document_dim, 
		
						  H.AccountPeriod         as AccountPeriod_dim, 
						  
						  <!--- orgunit --->
			              ISNULL(CONVERT(varchar,H.ReferenceOrgUnit),'0')   as OrgUnit_dim,
						  
			                    (SELECT    OrgUnitName
			                     FROM      Organization.dbo.Organization
			                     WHERE      (OrgUnit = H.ReferenceOrgUnit)) as OrgUnit_nme, 
		
						 CONVERT(varchar,DATEPART(year, L.TransactionDate)) as Year_dim, 
						 
						 CASE DatePart(month,L.TransactionDate) 
			                      WHEN 1 THEN 'January' 
								  WHEN 2 THEN 'February' 
								  WHEN 3 THEN 'March' 
								  WHEN 4 THEN 'April' 
								  WHEN 5 THEN 'May' 
								  WHEN 6 THEN 'June' 
								  WHEN 7 THEN 'July' 
								  WHEN 8 THEN 'August' 
								  WHEN 9 THEN 'September' 
								  WHEN 10 THEN 'October' 
								  WHEN 11 THEN 'November' 
								  WHEN 12 THEN 'December' 
								  END AS Month_dim,						   
								   
		                 DATEPART(month, L.TransactionDate)        as Month_ord, 								   
								   
		                 L.TransactionPeriod as AccountPeriodSub_dim,
						 
						 ISNULL(Person.Gender,'_na')               as Gender_dim,
						 ISNULL(Person.Nationality,'_na')          as Nationality_dim,
						 
						 ISNULL((SELECT Name FROM System.dbo.Ref_Nation WHERE Code = Person.Nationality),'_na') 
						                                           as Nationality_nme,
					 
					 	 ISNULL(C.ContractLevel,'_na')             as Level_dim,
						 ISNULL((SELECT PostOrder FROM Employee.dbo.Ref_PostGrade WHERE PostGrade = C.ContractLevel),'0') 
						                                           as Level_ord,			 
						 
						 L.Currency,
						 
						 H.TransactionDate, 
						
						<!--- expressed in budget currency, but we can apply this better !!! --->								
						 (L.AmountBaseDebit - L.AmountBaseCredit) as Amount, 						 
						 
			             L.ReferenceName      as TransactionReference, 
						 Person.FirstName     as EmployeeFirstName, <!--- show the costs of the person itself --->
						 Person.LastName      as EmployeeLastName,
						 Person.IndexNo       as EmployeeIndexNo,   
						 H.Description        as Memo, 				 
						 H.OfficerLastName							 
						
		
				FROM     Program.dbo.Ref_Resource          AS S 
				         INNER JOIN Program.dbo.Ref_Object AS O              ON S.Code          = O.Resource 
						
						 INNER JOIN TransactionHeader      AS H 
						 INNER JOIN (#preservesingleQuotes(TransactionLine)#) AS L  ON H.Journal       = L.Journal AND H.JournalSerialNo = L.JournalSerialNo 
						 
						 INNER JOIN Journal                                  ON H.Journal       = Journal.Journal ON O.Code = L.ObjectCode 
						 
						 <!--- the line has to have a link to the prgoramperiod here !!!! --->
						 INNER JOIN Program.dbo.Program       AS P           ON L.Programcode   = P.ProgramCode 			
						 INNER JOIN Organization.dbo.Ref_MissionPeriod AS MP ON MP.Mission = '#url.mission#' AND MP.Period = L.ProgramPeriod 
						 INNER JOIN Program.dbo.ProgramPeriod AS Pe          ON MP.PlanningPeriod = Pe.Period AND L.ProgramCode = Pe.ProgramCode
						 
							 
						 <!--- optional information --->
						 LEFT OUTER JOIN Employee.dbo.Person Person        ON Person.PersonNo = H.ReferencePersonNo
						 LEFT OUTER JOIN Employee.dbo.skPersonContract C   ON C.PersonNo      = H.ReferencePersonNo		
						 
						 LEFT OUTER JOIN (#preservesinglequotes(ProgramMaster)#) PP ON substring(Pe.PeriodHierarchy,charindex('_',Pe.PeriodHierarchy)+1,
							       CASE charindex('.',Pe.PeriodHierarchy) WHEN 0 
							                                       THEN LEN(Pe.PeriodHierarchy)	
																   ELSE (charindex('.',Pe.PeriodHierarchy)-1) END -(charindex('_',Pe.PeriodHierarchy))) 
						 = PP.ProgramCode AND Pe.Period = PP.Period	
		
				WHERE    H.Mission             = '#url.mission#' 
				
				<!--- added by Dev 16/01/2018 --->
				AND      H.TransactionSource   NOT IN ('PayrollSeries','ForecastSeries')
				AND      L.TransactionSerialNo <> '0' 
				AND      H.RecordStatus        != '9'
				AND      H.ActionStatus        != '9'
		
				ORDER BY O.Code
						
		) as Sub
	   
</cfquery>
	
<cfset session.table1_ds = "#SESSION.acc#FactAllotment">
<cfset session.table2_ds = "#SESSION.acc#FactRequests">
<cfset session.table3_ds = "#SESSION.acc#FactExecution"> 

<!--- 22/8/2018 removed
<cfset client.table4_ds = "#SESSION.acc#ExecutionIMIS"> 
--->

--->


<cfquery name="Param" 
	 datasource="AppsProgram" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   Ref_ParameterMission 
	 WHERE  Mission = '#url.mission#'
</cfquery>	 

<cfsavecontent variable="ProgramMaster">
    <cfoutput>
	SELECT Px.ProgramCode, Px.ProgramName, Pex.PeriodHierarchy, Pex.Period
	FROM   Program.dbo.Program Px INNER JOIN Program.dbo.ProgramPeriod Pex ON Px.ProgramCode = Pex.ProgramCode
	AND    Px.Mission = '#URL.Mission#'
	</cfoutput>
</cfsavecontent>

<!--- express execution in budget currency --->

<cfset currency = param.budgetcurrency>

<!--- from the url.period -> execution period we obtain the account period to filter on --->

<cfsavecontent variable="TransactionLine">

<cfoutput>

		SELECT     TOP 100 PERCENT 
		           SL.Journal, 
		           SL.JournalSerialNo, 
				   SL.TransactionSerialNo, 
				   SL.GLAccount, 
				   SL.Memo, 
				   SL.OrgUnit, 
				   SL.OrgUnitProvider, 
				   SL.Fund, 
				   SL.ProgramCode, 
				   SL.ActivityId, 
				   SL.ProgramPeriod, 
				   SL.ObjectCode, 
                   SL.AccountPeriod, 
				   SL.TransactionDate, 
				   SL.TransactionPeriod, 
				   SL.Reference, 
				   SL.ReferenceName, 
				   SL.ReferenceNo, 
				   SL.ReferenceId, 
				   SL.Currency, 
				  				   
				   CASE SL.Currency WHEN '#application.basecurrency#' THEN SL.AmountBaseDebit 
							                WHEN '#Currency#' THEN SL.AmountDebit  															            
										    ELSE SL.AmountBaseDebit * (SELECT TOP 1 ExchangeRate
																	 FROM   Accounting.dbo.CurrencyExchange V
																     WHERE  V.Currency       = '#Currency#' <!--- requested currency --->
																     AND    V.EffectiveDate <= SH.TransactionDate
																	 ORDER BY V.EffectiveDate DESC) 
						    END as AmountBaseDebit,
										  
							CASE SL.Currency WHEN '#application.basecurrency#' THEN SL.AmountBaseCredit 
											WHEN '#Currency#' THEN SL.AmountCredit  														            
										    ELSE SL.AmountBaseCredit * (SELECT TOP 1 ExchangeRate
																	   FROM   Accounting.dbo.CurrencyExchange V
																       WHERE  V.Currency       = '#Currency#' 
																       AND    V.EffectiveDate <= SH.TransactionDate
																	   ORDER BY V.EffectiveDate DESC) 
																	 
							END as AmountBaseCredit,			  						   
				  				  
							
					 SL.ParentJournal, 
					 SL.ParentJournalSerialNo, 
					 SL.ParentTransactionId 
					
					 
		FROM         TransactionLine SL INNER JOIN TransactionHeader SH ON SL.Journal = SH.Journal AND SL.JournalSerialno = SH.JournalSerialNo
		
		WHERE        SH.Mission       = '#url.mission#' 
		AND          SH.AccountPeriod IN (SELECT AccountPeriod 
		                                  FROM   Organization.dbo.Ref_MissionPeriod 
										  WHERE  Mission = '#url.mission#' 
										  AND    Period = '#url.period#') 
				

</cfoutput>

</cfsavecontent>

<cfoutput>
			
<cfsavecontent variable="myquery">
	
   	   
	   SELECT   Sub.*, TransactionDate
	   	              
	   FROM     (
	   
			   SELECT TOP 100 PERCENT   
			   			  <!--- transaction Disbursement, obligation --->				  
			              H.TransactionId,
						  H.Journal               as Transaction_dim, 
						  Journal.Description     as Transaction_nme, 
						  
						  L.Fund                  as Fund, 
						  
						  S.Code                  as Resource_dim, 
						  S.Description           as Resource_nme, 
						  
						  L.ObjectCode            as Object_dim, 
			              O.Description           as Object_nme, 
						 				 				  
						  P.ProgramCode           as Program_dim,
						  LEFT(P.ProgramName,60)  as Program_nme,			
						  Pe.PeriodHierarchy      as Program_ord,
														  
						  PP.ProgramCode          as MainProgram_dim,
					      LEFT(PP.ProgramName,60) as MainProgram_nme,			
						  PP.PeriodHierarchy      as MainProgram_ord,				  
						  
						  L.ProgramPeriod         as Period_dim,
										  
						  H.Reference             as Document_dim, 
		
						  H.AccountPeriod         as AccountPeriod_dim, 
						  
						  <!--- orgunit --->
			              ISNULL(CONVERT(varchar,H.ReferenceOrgUnit),'0')   as OrgUnit_dim,
						  
			                    (SELECT    OrgUnitName
			                     FROM      Organization.dbo.Organization
			                     WHERE      (OrgUnit = H.ReferenceOrgUnit)) as OrgUnit_nme, 
								 
							    (SELECT    HierarchyCode
			                     FROM      Organization.dbo.Organization
			                     WHERE      (OrgUnit = H.ReferenceOrgUnit)) as OrgUnit_ord,  
								 
						 L.TransactionDate, 	
														   
		                 L.TransactionPeriod,
						 
						 ISNULL(Person.Gender,'_na')               as Gender_dim,
						 ISNULL(Person.Nationality,'_na')          as Nationality_dim,
						 
						 ISNULL((SELECT Name FROM System.dbo.Ref_Nation WHERE Code = Person.Nationality),'_na') 
						                                           as Nationality_nme,
					 
					 	 ISNULL(C.ContractLevel,'_na')             as Level_dim,
						 ISNULL((SELECT PostOrder FROM Employee.dbo.Ref_PostGrade WHERE PostGrade = C.ContractLevel),'0') 
						                                           as Level_ord,			 						 
						 L.Currency,						 
						
						<!--- expressed in budget currency, but we can apply this better !!! --->								
						 (L.AmountBaseDebit - L.AmountBaseCredit) as Amount, 						 
						 
			             L.ReferenceName      as TransactionReference, 
						 Person.FirstName     as EmployeeFirstName, <!--- show the costs of the person itself --->
						 Person.LastName      as EmployeeLastName,
						 Person.IndexNo       as EmployeeIndexNo,   
						 H.Description        as Memo, 				 
						 H.OfficerLastName							
		
				FROM     Program.dbo.Ref_Resource          AS S 
				         INNER JOIN Program.dbo.Ref_Object AS O              ON S.Code          = O.Resource 
						
						 INNER JOIN TransactionHeader      AS H 
						 INNER JOIN (#preservesingleQuotes(TransactionLine)#) AS L  ON H.Journal  = L.Journal AND H.JournalSerialNo = L.JournalSerialNo 
						 
						 INNER JOIN Journal                                  ON H.Journal       = Journal.Journal ON O.Code = L.ObjectCode 
						 
						 <!--- the line has to have a link to the prgoramperiod here !!!! --->
						 INNER JOIN Program.dbo.Program       AS P           ON L.Programcode   = P.ProgramCode 			
						 INNER JOIN Organization.dbo.Ref_MissionPeriod AS MP ON MP.Mission = '#url.mission#' AND MP.Period = L.ProgramPeriod 
						 INNER JOIN Program.dbo.ProgramPeriod AS Pe          ON MP.PlanningPeriod = Pe.Period AND L.ProgramCode = Pe.ProgramCode
						 
							 
						 <!--- optional information --->
						 LEFT OUTER JOIN Employee.dbo.Person Person        ON Person.PersonNo = H.ReferencePersonNo
						 LEFT OUTER JOIN Employee.dbo.skPersonContract C   ON C.PersonNo      = H.ReferencePersonNo		
						 
						 LEFT OUTER JOIN (#preservesinglequotes(ProgramMaster)#) PP ON substring(Pe.PeriodHierarchy,charindex('_',Pe.PeriodHierarchy)+1,
							       CASE charindex('.',Pe.PeriodHierarchy) WHEN 0 
							                                       THEN LEN(Pe.PeriodHierarchy)	
																   ELSE (charindex('.',Pe.PeriodHierarchy)-1) END -(charindex('_',Pe.PeriodHierarchy))) 
						 = PP.ProgramCode AND Pe.Period = PP.Period	
		
				WHERE    H.Mission             = '#url.mission#' 
				
				<!--- added by Dev 16/01/2018 --->
				AND      H.TransactionSource   NOT IN ('PayrollSeries','ForecastSeries')
				AND      L.TransactionSerialNo <> '0' 
				AND      H.RecordStatus        != '9'
				AND      H.ActionStatus        != '9'
		
				ORDER BY O.Code
						
		) as Sub	
		
		WHERE 1=1 
				
		-- condition	
			
						

</cfsavecontent>

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

<cfset itm = itm+1>	
<cf_tl id="Journal" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "Transaction_nme",																	
					display           = "1",	
					column            = "common",																																									
					displayfilter     = "yes",																																									
					search            = "text",
					filtermode        = "3"}>	
					
<cfset itm = itm+1>	
<cf_tl id="Fund" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "Fund",																	
					display           = "1",	
					column            = "common",																																									
					displayfilter     = "yes",																																									
					search            = "text",
					filtermode        = "3"}>						

<cfset itm = itm+1>	
<cf_tl id="Program" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "MainProgram_nme",												
					fieldsort         = "MainProgram_ord",
					display           = "1",	
					column            = "common",																																									
					displayfilter     = "yes",																																									
					search            = "text",
					filtermode        = "3"}>	
					
<cfset itm = itm+1>	
<cf_tl id="Component" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "Program_nme",												
					fieldsort         = "Program_ord",
					display           = "1",																																												
					displayfilter     = "yes",																																									
					search            = "text",
					filtermode        = "3"}>						

<!---							
<cfset itm = itm+1>
<cf_tl id="Unit" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "OrgUnit_nme",												
					fieldsort         = "OrgUnit_ord",
					display           = "1",																																													
					displayfilter     = "yes",																																									
					search            = "text",
					filtermode        = "3"}>		
					
--->					
	
			
<cfset itm = itm+1>
<cf_tl id="Resource" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "Resource_nme",																	
					display           = "1",	
					column            = "common",																																									
					displayfilter     = "yes",																																									
					search            = "text",
					filtermode        = "3"}>	

<cfset itm = itm+1>
<cf_tl id="Object" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "Object_nme",																	
					display           = "1",																									
					displayfilter     = "yes",																																									
					search            = "text",
					filtermode        = "3"}>	
										
<cfset itm = itm+1>	
<cf_tl id="Reference" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "TransactionReference",												
					display           = "1",	
					width             = "30",																																												
					displayfilter     = "yes",																																									
					search            = "text"}>	
					
<cfset itm = itm+1>	
<cf_tl id="Period" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "TransactionPeriod",								
					column            = "common",
					search            = "text",					
					display           = "1",																																														
					displayfilter     = "yes"}>																
				
<cfset itm = itm+1>	
<cf_tl id="Date" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "TransactionDate",								
					column            = "month",
					search            = "date",	
					formatted         = "dateformat(TransactionDate,CLIENT.DateFormatShow)",				
					display           = "1",																																														
					displayfilter     = "yes"}>	
					
<cfset itm = itm+1>	
<cf_tl id="Currency" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "Currency",											
					display           = "1",																																															
					displayfilter     = "yes",																																									
					search            = "text",
					filtermode        = "3"}>												
						
<cfset itm = itm+1>	
<cf_tl id="Amount" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "Amount",		
					fieldsort         = "Item_dim",						
					aggregate         = "SUM",
					align             = "right",
					display           = "1",																																										
					displayfilter     = "yes",																																									
					search            = "amount"}>																			
																
<cfset menu=ArrayNew(1)>	

<cf_listing
    header              = "execution"
    box                 = "execution_#url.mission#"
	link                = "#session.root#/Procurement/Application/Funding/Listing/ExecutionViewContent.cfm?SystemFunctionId=#url.systemfunctionid#&mission=#url.mission#&planningperiod=#url.planningperiod#&period=#url.period#"
    html                = "No"		
	tableheight         = "100%"
	tablewidth          = "100%"
	calendar            = "9" 
	font                = "Calibri"
	datasource          = "AppsLedger"
	listquery           = "#myquery#"		
	listorderfield      = ""
	listorder           = ""
	listorderdir        = "ASC"		
	headercolor         = "ffffff"		
	menu                = "#menu#"
	showrows            = "1"
	filtershow          = "Yes"
	excelshow           = "Yes" 					
	listlayout          = "#fields#"	
	drillmode           = "tab"	
	drillargument       = "920;1200;false;false"	
	drilltemplate       = "Gledger/Application/Transaction/View/TransactionView.cfm?id="
	drillkey            = "transactionid"
	drillbox            = "execution">
		
		