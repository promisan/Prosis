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
				
	<cfquery name="getObjects" 
	     datasource="AppsProgram" 
	  	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT Code
		 FROM   userQuery.dbo.#SESSION.acc#Ref_Object
		 WHERE  ParentCode = 
			     (SELECT TOP 1 ParentCode 
				  FROM   userQuery.dbo.#SESSION.acc#Ref_Object
				  WHERE  Code = '#ObjectCode#')				
	</cfquery>	
				
	<cfset objects = quotedValueList(getObjects.Code)>	
		
	<cfif ModeMapping eq "1">
	
		<cfquery name="getDonor" 
	     datasource="AppsProgram" 
	  	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">					 
		
			SELECT     ContributionLineId, DateExpiration, DateEffective
								
			FROM       ContributionLine AS L
			
			<!--- covers the batch date --->
			
			WHERE       DateEffective <= '#dateformat(JournalBatchDate,client.dateSQL)#'
			AND         (DateExpiration >= '#dateformat(JournalBatchDate,client.dateSQL)#' OR DateExpiration IS NULL) 
			
			<!--- is indeed used to cover the project / fund / period --->
			
			AND         ContributionLineId IN
	                          (SELECT     PC.ContributionLineId
	                            FROM      ProgramAllotmentDetail AS PD INNER JOIN
	                                      ProgramAllotmentDetailContribution AS PC ON PD.TransactionId = PC.TransactionId
	                            WHERE     PD.ProgramCode = '#ProgramCode#' 
								AND       PD.Fund        = '#Fund#' 
								AND       PD.Period      = '#ProgramPeriod#')
			
			GROUP BY   L.ContributionLineId, L.DateExpiration, L.DateEffective
			
			<!--- we have funds left and amount bigger than the disbursement transaction --->
			
			HAVING      (
			
			             (SELECT  SUM(PC.Amount)
                          FROM    ProgramAllotmentDetail AS PD INNER JOIN
                                  ProgramAllotmentDetailContribution AS PC ON PD.TransactionId = PC.TransactionId
		                  WHERE   PD.ProgramCode = '#ProgramCode#' 
						  AND     PD.Fund        = '#Fund#' 									
						  AND     PD.Period      = '#getPeriod.PlanningPeriod#'
						  AND     PD.EditionId   = '#getPeriod.EditionId#'
						  <cfif supportaccount neq "">
						  AND     PD.ObjectCode != '#supportaccount#' 
						  </cfif>
						  AND     PC.ContributionLineId = L.ContributionLineId)  
													 
						 - 
								
						(SELECT   ISNULL(SUM(AmountBaseDebit - AmountBaseCredit), 0) 
	                     FROM     Accounting.dbo.TransactionLine TL
						 WHERE    Journal IN (SELECT Journal 
							                  FROM   Accounting.dbo.Journal 
									          WHERE  Mission = '#Mission.Mission#')
						 <!--- we also compare only with the same Project/Fund here --->					
						 AND     TL.ProgramCode   = '#ProgramCode#' 
						 AND     TL.Fund          = '#Fund#' 									 
						 AND     TL.ProgramPeriod = '#ProgramPeriod#'
						 <cfif supportaccount neq "">
					     AND     TL.ObjectCode != '#supportaccount#' 
					     </cfif>								  
                               AND      ContributionLineId = L.ContributionLineId)
						 
						 ) 
						 
						 >= '#Amount#'
									   
			ORDER BY   ISNULL(DateExpiration, '9999-12-31'), DateEffective						   
							
		</cfquery>		
		
		<cfif getDonor.recordcount eq "0">
		
		    <!--- ------------------------------------------------------------------- --->
			<!--- if no result is found we try with a larger period by adding 30 days --->
			<!--- ------------------------------------------------------------------- --->
			
			<cfquery name="getDonor" 
		     datasource="AppsProgram" 
		  	 username="#SESSION.login#" 
		     password="#SESSION.dbpw#">						 
			 						
				SELECT     ContributionLineId, DateExpiration, DateEffective
									
				FROM       ContributionLine AS L
				
				<!--- covers the batch date --->
				
				WHERE       DateEffective <= '#dateformat(JournalBatchDate,client.dateSQL)#'
				AND         (DateExpiration+30 >= '#dateformat(JournalBatchDate,client.dateSQL)#' OR DateExpiration IS NULL) 
				
				<!--- is indeed used to cover the project / fund / period --->
				
				AND         ContributionLineId IN
		                          (SELECT     PC.ContributionLineId
		                            FROM      ProgramAllotmentDetail AS PD INNER JOIN
		                                      ProgramAllotmentDetailContribution AS PC ON PD.TransactionId = PC.TransactionId
		                            WHERE     PD.ProgramCode = '#ProgramCode#' 
									AND       PD.Fund        = '#Fund#' 
									AND       PD.Period      = '#ProgramPeriod#')
				
				GROUP BY   L.ContributionLineId, L.DateExpiration, L.DateEffective
				
				<!--- we have funds left and amount bigger than the disbursement transaction --->
				
				HAVING      (
				
				             (SELECT  SUM(PC.Amount)
	                          FROM    ProgramAllotmentDetail AS PD INNER JOIN
	                                  ProgramAllotmentDetailContribution AS PC ON PD.TransactionId = PC.TransactionId
			                  WHERE   PD.ProgramCode = '#ProgramCode#' 
							  AND     PD.Fund        = '#Fund#' 									
							  AND     PD.Period      = '#getPeriod.PlanningPeriod#'
							  AND     PD.EditionId   = '#getPeriod.EditionId#'
							  <cfif supportaccount neq "">
							  AND     PD.ObjectCode != '#supportaccount#' 
							  </cfif>
							  AND     PC.ContributionLineId = L.ContributionLineId)  
														 
							 - 
									
							(SELECT   ISNULL(SUM(AmountBaseDebit - AmountBaseCredit), 0) 
		                     FROM     Accounting.dbo.TransactionLine TL
							 WHERE    Journal IN (SELECT Journal 
								                  FROM   Accounting.dbo.Journal 
										          WHERE  Mission = '#Mission.Mission#')
							 <!--- we also compare only with the same Project/Fund here --->					
							 AND     TL.ProgramCode   = '#ProgramCode#' 
							 AND     TL.Fund          = '#Fund#' 									 
							 AND     TL.ProgramPeriod = '#ProgramPeriod#'
							 <cfif supportaccount neq "">
						     AND     TL.ObjectCode != '#supportaccount#' 
						     </cfif>								  
                                AND      ContributionLineId = L.ContributionLineId)
							 
							 ) 
							 
							 >= '#Amount#'
										   
				ORDER BY   ISNULL(DateExpiration, '9999-12-31'), DateEffective						   
								
			</cfquery>		
										
		</cfif>										
		
		<cfset donorhigh = getDonor.recordcount>
		<cfset base = QuotedValueList(getDonor.ContributionLineId)>
		
	<cfelse>
	
		<cfset donorhigh = "">
		<cfset base = "">
						
	</cfif>				
	
	<cfif donorhigh eq "0">
	
		 <cfset con = "">
	
		<!--- no luck, we have to go to the next record, no mapping possible --->
	
	<cfelseif donorhigh eq "1">
	
	   <cfset con = getDonor.contributionlineid>
	
		<!--- we have good luck we apply this contributionlineid to the record independent
		if we have the match of the OE --->
			
	<cfelse>				
						
		<!--- we go one step deeper and try to match on the OE first --->
		
		<cfquery name="getDonorDeeper" 
	     datasource="AppsProgram" 
	  	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 										
			SELECT    ContributionLineId, DateExpiration, DateEffective
			
			FROM      ContributionLine AS L
			
			WHERE     DateEffective <= '#dateformat(JournalBatchDate,client.dateSQL)#'
			AND       (DateExpiration >= '#dateformat(JournalBatchDate,client.dateSQL)#' OR  DateExpiration IS NULL) 

			<!--- contribution is indeed created to cover the project / fund / OE (parent) --->	
			
			AND       L.ContributionLineId IN
	                          (SELECT     PC.ContributionLineId
	                            FROM      ProgramAllotmentDetail AS PD INNER JOIN
	                                      ProgramAllotmentDetailContribution AS PC ON PD.TransactionId = PC.TransactionId
	                            WHERE     PD.ProgramCode = '#ProgramCode#' 
								AND       PD.Fund        = '#Fund#' 
								AND       PD.ObjectCode IN (#preserveSingleQuotes(objects)#)
								AND       PD.Period      = '#getPeriod.PlanningPeriod#'
								AND       PD.EditionId   = '#getPeriod.EditionId#')
			
			<!--- technically we do have funds on the higher level already --->			
			<cfif base neq "">		
				AND     L.ContributionLineId IN (#preserveSingleQuotes(base)#)					
			</cfif>

			GROUP BY  ContributionLineId, DateExpiration, DateEffective
			
			<!--- Project/Fund/Period + OE level donor contribution amount -/- already allocated >= transaction value --->

			HAVING     (SELECT  SUM(PC.Amount)
                           FROM    ProgramAllotmentDetail AS PD INNER JOIN
                                   ProgramAllotmentDetailContribution AS PC ON PD.TransactionId = PC.TransactionId
	                    WHERE   PD.ProgramCode = '#ProgramCode#' 
						AND     PD.Fund        = '#Fund#' 
						AND     PD.ObjectCode IN (#preserveSingleQuotes(objects)#)
						AND     PD.Period      = '#getPeriod.PlanningPeriod#'
						AND     PD.EditionId   = '#getPeriod.EditionId#'
						<cfif supportaccount neq "">
					    AND     PD.ObjectCode != '#supportaccount#' 
					    </cfif>
						AND     PC.ContributionLineId = L.ContributionLineId) 
						
						-
									
                         (SELECT   ISNULL(SUM(AmountBaseDebit - AmountBaseCredit), 0) 
                           FROM    Accounting.dbo.TransactionLine TL
						WHERE   Journal IN (SELECT Journal 
				                            FROM   Accounting.dbo.Journal 
									        WHERE  Mission = '#Mission.Mission#')
						
						<!--- we also compare only with the same OE that were mapped --->					
						AND     TL.ProgramCode   = '#ProgramCode#' 
						AND     TL.Fund          = '#Fund#' 
						AND     TL.ObjectCode IN (#preserveSingleQuotes(objects)#)
						AND     TL.ProgramPeriod = '#ProgramPeriod#'
						<cfif supportaccount neq "">
					    AND     TL.ObjectCode   != '#supportaccount#' 
					    </cfif>														
                           AND     TL.ContributionLineId = L.ContributionLineId) 
																		
						>= '#Amount#'
															
			ORDER BY ISNULL(DateExpiration, '9999-12-31'), DateEffective				
							
		</cfquery>		
						
		<cfif getDonorDeeper.recordcount gte "1">	
		
			<!--- we can apply it granularly on the OE --->				
			<cfset con = getDonorDeeper.contributionlineid>
			
		<cfelse>
		
			<!--- OE not found so we map it any contribution --->			
			<cfif ModeMapping eq "1">
				<cfset con = getDonor.contributionlineid>					
			<cfelse>
				<cfset con = "">
			</cfif>	
		
		</cfif>
					
	</cfif>				
	
	<cfif con neq "">
	
		<cfquery name="setLine" 
	     datasource="AppsLedger" 
	  	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		  	UPDATE TransactionLine
			SET    ContributionLineid = '#con#' 
		    WHERE  TransactionLineId = '#TransactionLineid#'
		</cfquery>  
			
	</cfif>
					
	<cfquery name="getLine" 
	   datasource="AppsProgram" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		SELECT    *
		FROM      ContributionLine AS L
		<cfif con neq "">
		WHERE     ContributionLineId = '#con#'
		<cfelse>
		WHERE     1=0
		</cfif>
	</cfquery>	
	
	<!---
	#ObjectCode# - #objects# - #journalserialno# - #con# : [#donorhigh#] [#getDonorDeeper.recordcount#] #getLine.Reference#  <br>
	--->