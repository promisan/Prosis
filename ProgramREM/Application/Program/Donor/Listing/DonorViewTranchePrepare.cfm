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
<!--- get data --->

<!--- prepare table --->
	
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#TrancheStatus">	
	
<cfquery name="getDonorData"
	    datasource="AppsProgram" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">			
		
	     SELECT    C.Mission, 
		           C.OrgUnitDonor,
				   CASE O.OrgunitClass
				   		WHEN 'Individual' THEN P.LastName + ' ' + P.FirstName
						ELSE O.OrgUnitName
				   END AS OrgUnitName,
				   SC.Reference as LineReference, 
				   C.ContributionClass, 
				   R.Description AS ContributionClassName, 
				   S.Description AS EarmarkName, 
				   E.StatusDescription, 
				   C.ActionStatus, 
                   C.DateSubmitted,
                   SC.DateReceived   as LineDateReceived,
                   SC.DateEffective  as LineDateEffective,
                   SC.DateExpiration as LineDateExpiration, 
				   C.Description, 
				   SC.Fund, 
				   SC.AmountBase as Tranche,
				   
				   ( 
				     SELECT SUM(CLP.AmountBase) 
				     FROM   ContributionLinePeriod CLP
					 WHERE  CLP.ContributionLineId = SC.ContributionLineid					 					
				   ) as Correction,
										
				   (SELECT SUM(SP.Amount) 
				    FROM   ProgramAllotmentDetailContribution SP
					WHERE  SP.ContributionLineId = SC.ContributionLineid										
					AND    SP.TransactionId IN (SELECT TransactionId FROM ProgramAllotmentDetail WHERE TransactionId = SP.TransactionId and Status = '1')		
					) as Alloted,	
					
					SC.AmountBase + ( 
				     SELECT SUM(CLP.AmountBase) 
				     FROM   ContributionLinePeriod CLP
					 WHERE  CLP.ContributionLineId = SC.ContributionLineid					
				     ) - (
					 SELECT ISNULL(SUM(SP.Amount),0)
				     FROM   ProgramAllotmentDetailContribution SP
					 WHERE  SP.ContributionLineId = SC.ContributionLineid					
					 AND    SP.TransactionId IN (SELECT TransactionId FROM ProgramAllotmentDetail WHERE TransactionId = SP.TransactionId and Status = '1')						
					 ) as Balance,	
					 				
										
				   C.ContributionId
				   
		INTO       userQuery.dbo.#SESSION.acc#TrancheStatus	   
				   
		FROM       Contribution AS C LEFT OUTER JOIN
                   ContributionLine AS SC ON C.ContributionId = SC.ContributionId INNER JOIN
				   Organization.dbo.Organization AS O ON O.OrgUnit = C.OrgUnitDonor INNER JOIN
                   Ref_ContributionClass AS R ON C.ContributionClass = R.Code INNER JOIN
				   Ref_Earmark AS S ON C.Earmark = S.Earmark INNER JOIN
                   Organization.dbo.Ref_EntityStatus AS E ON C.ActionStatus = E.EntityStatus LEFT OUTER JOIN
				   Employee.dbo.Person P ON P.PersonNo = C.PersonNo
		
		WHERE      E.EntityCode = 'EntDonor'
		AND        C.Mission = '#url.mission#' 
		AND        C.ActionStatus <> '9'
		
		<cfif url.period neq "">
		AND         EXISTS (SELECT 'X' 
				            FROM   Program.dbo.ContributionLinePeriod CLP
						    WHERE  CLP.ContributionLineId = SC.ContributionLineId 						   
							AND    CLP.Period = '#url.period#') 
							
		</cfif>				
		
		<!---		
		#preservesingleQuotes(clfilter)#
		#preservesingleQuotes(orfilter)#
		--->
				
						 
							
</cfquery>						