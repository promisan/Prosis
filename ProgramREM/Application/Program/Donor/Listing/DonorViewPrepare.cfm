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
	
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#DonorStatus">	

<cfif url.mode eq "don">
	
	<cfquery name="getDonor"
	    datasource="AppsProgram" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
			SELECT *
			FROM  Organization.dbo.Organization 
			WHERE OrgUnit = '#url.id1#'
	</cfquery>		

</cfif>

<cfif url.mode eq "Summary">
   <cfif url.filter eq "active">
	    <cfset clfilter = "AND (SC.DateExpiration >= getDate() or SC.DateExpiration is NULL)">	
   <cfelseif url.filter eq "expired">   
        <cfset clfilter = "AND SC.DateExpiration < getDate()">	
   <cfelse>   
   		<cfset clfilter = "">		
   </cfif>	
   <cfset orfilter = "">
<cfelseif url.mode eq "Contribution">
	<cfset clfilter = "">	
	<cfset orfilter = "">
<cfelseif url.mode eq "Tranche">
	<cfset clfilter = "">	
	<cfset orfilter = "">   
<cfelse>
	<cfset clfilter = "">	
	<cfset orfilter = "AND  O.HierarchyCode LIKE ('#getDonor.HierarchyCode#%')">
</cfif>	
	
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
				   C.Reference, 
				   C.ContributionClass, 
				   
				   (SELECT Description
				    FROM   Ref_ContributionClass R
					WHERE  R.Code = C.ContributionClass) as ContributionClassName, 
					
				  (SELECT Description
				    FROM   Ref_Earmark S
					WHERE  C.Earmark = S.Earmark) as EarmarkName, 
					
				   E.StatusDescription, 
				   C.ActionStatus, 
                   C.DateSubmitted, 
				   C.Description, 
				   SC.Fund, 
				   SUM(SC.AmountBase) as Contribution,
				   
				   ( 
				     SELECT SUM(CLP.AmountBase) 
				     FROM   ContributionLinePeriod CLP, ContributionLine SC
					 WHERE  CLP.ContributionLineId = SC.ContributionLineid
					 #preservesingleQuotes(clfilter)#
					 AND    SC.Contributionid = C.ContributionId
				   ) as Correction,
									
				   (SELECT count(*) 
					FROM   ContributionLine SC
				    WHERE  SC.Contributionid = C.ContributionId
					#preservesingleQuotes(clfilter)#) as Lines,
					
				   (SELECT SUM(SP.Amount) 
				    FROM   ProgramAllotmentDetailContribution SP,  ContributionLine SC
					WHERE  SP.ContributionLineId = SC.ContributionLineid
					AND    SC.Contributionid = C.ContributionId
					#preservesingleQuotes(clfilter)#
					AND    SP.TransactionId IN (SELECT TransactionId 
					                            FROM   ProgramAllotmentDetail 
												WHERE  TransactionId = SP.TransactionId 
												AND    Status = '1')		<!--- has indeed been cleared --->
					) as Alloted,	
					
					SUM(SC.AmountBase) + ( 
				     SELECT SUM(CLP.AmountBase) 
				     FROM   ContributionLinePeriod CLP, ContributionLine SC
					 WHERE  CLP.ContributionLineId = SC.ContributionLineid
					 #preservesingleQuotes(clfilter)#
					 AND    SC.Contributionid = C.ContributionId
				     ) - (
					 SELECT ISNULL(SUM(SP.Amount),0)
				     FROM   ProgramAllotmentDetailContribution SP,  ContributionLine SC
					 WHERE  SP.ContributionLineId = SC.ContributionLineid
					 #preservesingleQuotes(clfilter)#
					 AND    SP.TransactionId IN (SELECT TransactionId FROM ProgramAllotmentDetail WHERE TransactionId = SP.TransactionId and Status = '1')	
					 AND    SC.Contributionid = C.ContributionId
					 ) as Balance,					
										
				   C.ContributionId
				   
		INTO       userQuery.dbo.#SESSION.acc#DonorStatus	   
				   
		FROM       Contribution AS C LEFT OUTER JOIN ContributionLine AS SC ON C.ContributionId = SC.ContributionId INNER JOIN
				   Organization.dbo.Organization AS O     ON O.OrgUnit = C.OrgUnitDonor INNER JOIN                  				  
                   Organization.dbo.Ref_EntityStatus AS E ON C.ActionStatus = E.EntityStatus LEFT OUTER JOIN
				   Employee.dbo.Person P                  ON P.PersonNo = C.PersonNo
		
		WHERE      E.EntityCode = 'EntDonor'
		AND        C.Mission = '#url.mission#' 
		AND        C.ActionStatus <> '9'
		
		<cfif url.period neq "">
						
		AND         EXISTS (SELECT 'X' 
				            FROM   Program.dbo.ContributionLinePeriod CLP
						    WHERE  CLP.ContributionLineId = SC.ContributionLineId 						   
							AND    CLP.Period = '#url.period#') 
														
		</cfif>			
				
		#preservesingleQuotes(clfilter)#
		#preservesingleQuotes(orfilter)#
				
		GROUP BY   C.Mission, 
		           C.OrgUnitDonor,
				   CASE O.OrgunitClass
				   		WHEN 'Individual' THEN P.LastName + ' ' + P.FirstName
						ELSE O.OrgUnitName
				   END, 
				   C.Reference, 
				   C.ActionStatus, 
				   C.DateSubmitted, 
				   C.Description, 
				   SC.Fund, 
				   C.ContributionId, 
				   C.ContributionClass, 
				   C.Earmark,				 
                   E.StatusDescription		    				 
							
</cfquery>						