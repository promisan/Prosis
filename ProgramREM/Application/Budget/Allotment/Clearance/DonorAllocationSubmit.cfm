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
 
<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT     PA.TransactionId,
	           PA.EditionId,
	           P.Mission, 
	           P.ProgramCode, 
			   PA.Status,
	           PA.Fund, 
			   PA.ObjectCode,
			   PAH.SupportPercentage,
   			   <cfif url.contributionlineId eq "">
				   PA.Amount as AmountBase,
			   <cfelse>
			   	   PADC.Amount as AmountBase,
			   </cfif>	   
			   Per.Period as PlanningPeriod, 
			   R.Period as ProgramPeriod,
			   Per.DateEffective, 
			   Per.DateExpiration			   
	FROM       ProgramAllotmentDetail PA INNER JOIN
               Program P ON PA.ProgramCode = P.ProgramCode INNER JOIN
			   ProgramAllotment PAH ON PA.ProgramCode = PAH.ProgramCode AND PA.Period = PAH.Period AND PA.EditionId = PAH.EditionId INNER JOIN
               Ref_AllotmentEdition R ON PA.EditionId = R.EditionId INNER JOIN
               Ref_Period Per ON R.Period = Per.Period
			   <cfif url.contributionlineId neq "">
			   	 	INNER JOIN ProgramAllotmentDetailContribution PADC ON PADC.Transactionid = PA.TransactionId AND PADC.ContributionLineId = '#url.contributionlineid#'
			   </cfif>
	WHERE      PA.TransactionId = '#url.transactionid#'
</cfquery> 
 	  
<!--- get the potentially valid lines as these were shown on the entry screen as well  --->

<cfparam name="Form.ContributionLineIds_#left(TransactionId,8)#" default="">
<cfset contributionIds = evaluate("Form.ContributionLineIds_#left(url.TransactionId,8)#")>

<cfquery name="Period" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Period 
	WHERE  Period = '#get.ProgramPeriod#'
</cfquery>	
 
<!--- get the contribution information for the contributions selected to fund it --->
 
<cfquery name="Donor" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	  SELECT   CL.ContributionLineId, 
	           CL.AmountBase,
			   CL.OverAllocate, 
								
				<!--- added value for this period --->
				(   SELECT ISNULL(SUM(AmountBase),0) 
				    FROM   ContributionLinePeriod
				    WHERE  ContributionLineId = CL.ContributionLineId
				    AND    Period <= '#get.ProgramPeriod#' )
	
				   as AmountBaseAdditional,	 
								   
				<!--- amount drafted which does not have PCS included yet---> 				
				
				(   SELECT  ISNULL(SUM(PADC.Amount*(100 + PA.SupportPercentage)/100), 0)
				    FROM    ProgramAllotmentDetailContribution AS PADC INNER JOIN
                            ProgramAllotmentDetail AS PAD ON PADC.TransactionId = PAD.TransactionId INNER JOIN
                            ProgramAllotment AS PA ON PAD.ProgramCode = PA.ProgramCode AND PAD.Period = PA.Period AND PAD.EditionId = PA.EditionId
				    WHERE   PADC.ContributionLineId = CL.ContributionLineId					
					AND     PAD.Status = '0'	
					AND     PAD.Period IN (SELECT Period 
								           FROM   Ref_Period
								           WHERE  DateExpiration <= '#period.dateExpiration#')			   
				    AND     PADC.TransactionId != '#url.transactionid#') 
					
					as InProcess, 		
					
			    <!--- amount used --->				   
				   
	           (   SELECT   ISNULL(SUM(Amount),0) 
				   FROM     ProgramAllotmentDetailContribution PC
				   WHERE    ContributionLineId = CL.ContributionLineId
				   <!--- valid allotment transaction --->
				   AND      PC.TransactionId IN (SELECT TransactionId 
				                                 FROM   ProgramAllotmentDetail PAD 
												 WHERE  PAD.TransactionId = PC.TransactionId 
												 AND    PAD.Period IN (SELECT Period 
															           FROM   Ref_Period
															           WHERE  DateExpiration <= '#period.dateExpiration#')			
												 AND    PAD.Status = '1')
				   AND      PC.TransactionId != '#url.transactionid#' ) 
				   
				   as AmountBaseUsed
				   
				   	  
      FROM    Contribution C INNER JOIN
              ContributionLine CL ON C.ContributionId = CL.ContributionId INNER JOIN
              Organization.dbo.Organization O ON C.OrgUnitDonor = O.OrgUnit

      WHERE   ContributionLineId IN (#preserveSingleQuotes(ContributionIds)#)
	 	 
 </cfquery>
 	
<cfparam name="form.applytoall" default="0">

<cfif form.applytoall eq "0">	
		
		<cfquery name="clear" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  DELETE FROM ProgramAllotmentDetailContribution
			  WHERE  TransactionId     = '#url.transactionid#'    	 
			  <cfif URL.contributionlineId neq "">
			  AND    ContributionLineId = '#URL.contributionlineId#'
			  </cfif>
		</cfquery>
	
<cfelse>
	
		<cfquery name="clear" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  DELETE FROM ProgramAllotmentDetailContribution
			  WHERE  1=1	 
			  <cfif URL.contributionlineId neq "">
			  AND    ContributionLineId = '#URL.contributionlineId#'
			  </cfif>
			  AND    Transactionid IN (SELECT Transactionid 
			                           FROM   ProgramAllotmentDetail 
									   WHERE  ProgramCode = '#get.ProgramCode#' 
									   AND    Fund        = '#get.Fund#'
									   AND    Period      = '#get.PlanningPeriod#'
									   AND    Editionid   = '#get.EditionId#'
									   AND    Status      = '0'
									   AND    TransactionType = 'Standard')
		</cfquery>	
	
</cfif>
	
<cftransaction>	
	
	<cfif url.processmode eq "apply">
		
		<cfloop query="donor">
			
			<cfparam name="form.AllocationAmount_#left(url.transactionid,8)#_#left(contributionlineid,8)#" default="">
			
			<!--- amount requested to be applied --->			
			<cfset amount = evaluate("form.AllocationAmount_#left(url.transactionid,8)#_#left(contributionlineid,8)#")>
			<!--- remove commas and spaces --->
			<cfset amount = replace(amount,',','','ALL')> 	
			<cfset amount = replace(amount,' ','','ALL')> 	
			
			<cfif isNumeric(amount)>				
							
				<!--- if valid amount then we defined if we have balance over the amount already allocated 
				  Donor amount + overdraw + period correction -/- allocated -/- this added amount > 0 --->
				  
				<!--- 
				
				1. check if by associating the amount to a contribution if there is still enough monies available of that contribution
				 				
				2. also in case we remove an association to contribution which has been mapped already for this OE/Project we check if
				we are not getting into problems, hereto we need to be able to unlink thse associations to free up the monies				
				
				--->
												
				<cfif get.supportpercentage neq "" and get.Status eq "0">
				    <!--- PSC has not be calculated yet, so we need to adjust this --->			
					<cfset traamount = amount + (amount * get.supportpercentage/100)>
				<cfelse>		   
				   	<cfset traamount = amount>
				</cfif>		
				
				<cfset bal =  (AmountBase+(AmountBase*(overallocate/100))+AmountBaseAdditional)-AmountBaseUsed-InProcess-traamount>
											
				<!--- if the amount is negative, we always allow for it to be repleshed --->
					
				<cfif (round(bal) gte 0 and amount neq "0") or amount lt 0>							
						
					<cfinvoke component            = "Service.Process.Program.ProgramAllotment"  
						      method               = "associateContribution" 
						      TransactionId        = "#url.transactionid#" 
						      ContributionLineId   = "#contributionlineid#"
						      Amount               = "#amount#">																			
				   
				</cfif>				
			
			</cfif>			
		
		</cfloop>
		
	</cfif>		

<cfparam name="form.applytoall" default="0">

<cfif form.applytoall eq "0">	

	<cfoutput>

		<script>	
		  parent.donordrillrefresh('1','#url.transactionid#')	  
		  parent.ColdFusion.Window.destroy('mydialog',true)	  	  
		</script>	
		
	</cfoutput>
	
<cfelse>

        	    
	<cfquery name="getNotprocessed" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT    *
		FROM       ProgramAllotmentDetail PA 
		WHERE      PA.TransactionId != '#url.transactionid#'
		AND        PA.Transactionid NOT IN (SELECT TransactionId 
		                                    FROM ProgramAllotmentDetailContribution 
											WHERE TransactionId = PA.Transactionid)
		AND        PA.ProgramCode = '#get.ProgramCode#'
		AND        PA.Fund        = '#get.Fund#'
		AND        PA.Period      = '#get.PlanningPeriod#'
		AND        PA.Editionid   = '#get.EditionId#'
		AND        PA.Status = '0'
		AND        PA.TransactionType = 'Standard'
	</cfquery> 
	
	<cfloop query="getNotProcessed">
	
		<cfquery name="getDonor" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		
			SELECT PAD.ContributionLineId, 
		
		           PAD.Amount /
                  
				    (SELECT   SUM(Amount) AS Expr1
                     FROM     ProgramAllotmentDetailContribution
                     WHERE    TransactionId = '#url.transactionid#') AS DonorRatio, 
				   
				  CL.AmountBase, 
				  CL.OverAllocate,
				  <!--- added value for this period --->
				  ( SELECT  ISNULL(SUM(AmountBase),0) 
				    FROM    ContributionLinePeriod
				    WHERE   ContributionLineId = CL.ContributionLineId
				    AND     Period <= '#get.ProgramPeriod#'
				  ) as AmountBaseAdditional,				
				
			      ( SELECT  ISNULL(SUM(Amount),0) 
				    FROM    ProgramAllotmentDetailContribution CD
				    WHERE   ContributionLineId = CL.ContributionLineId

				    <!--- valid allotment transaction --->
				    AND     TransactionId IN (SELECT TransactionId 
				                              FROM   ProgramAllotmentDetail 
						 					  WHERE  TransactionId = CD.TransactionId 
											  AND    Status != '9')
											 
				    AND     TransactionId != '#transactionid#') as AmountBaseAllocated		
								  
		    FROM    ProgramAllotmentDetailContribution AS PAD INNER JOIN
                    ContributionLine AS CL ON PAD.ContributionLineId = CL.ContributionLineId
					
		    WHERE   PAD.TransactionId = '#url.transactionid#'

		</cfquery>	
		
		<cfset allotment = amountbase>	
		<cfset traid     = transactionid>
		
		<cfloop query="getdonor">
							
			<cfset amount = allotment*DonorRatio>
			<cfset amount = round(amount*100)/100>
					
			<cfset bal =  (AmountBase+(AmountBase*(overallocate/100))+AmountBaseAdditional)-AmountBaseAllocated-amount>	
				
				<!--- if the amount is negative, we always allow for it to be repleshed --->
					
				<cfif (round(bal) gte 0 and amount neq "0") or amount lt 0>		
																										
					<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
						   method               = "associateContribution" 
						   TransactionId        = "#traid#" 
						   ContributionLineId   = "#contributionlineid#"
						   Amount               = "#amount#">																				
										   
				</cfif>				
		
		</cfloop>
		
	</cfloop>
	
	<cfoutput>

		<script>	
		  parent.donordrillrefresh('3','#url.transactionid#')	  
		  parent.ColdFusion.Window.destroy('mydialog',true)	  	  
		</script>	
		
	</cfoutput>
		
</cfif>

</cftransaction>