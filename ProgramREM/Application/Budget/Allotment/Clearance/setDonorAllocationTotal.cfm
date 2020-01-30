<cfparam name="url.process" default="no">
<cfparam name="url.box"     default="1">

<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	
	SELECT     PA.TransactionId,
	           P.Mission, 
	           P.ProgramCode, 
	           PA.Fund, 
			   PA.Status,
			   PA.ObjectCode,
			   PAH.SupportPercentage,
   			   <cfif url.scope eq "">
				   PA.Amount as AmountBase,
			   <cfelse>
			   	   PADC.Amount as AmountBase,
			   </cfif>	   
			   Per.Period  as PlanningPeriod, 
			   R.Period    as ProgramPeriod,
			   Per.DateEffective, 
			   Per.DateExpiration
			   
	FROM       ProgramAllotmentDetail PA INNER JOIN
               Program P ON PA.ProgramCode = P.ProgramCode INNER JOIN
			   ProgramAllotment PAH ON PA.ProgramCode = PAH.ProgramCode AND PA.Period = PAH.Period AND PA.EditionId = PAH.EditionId INNER JOIN 
               Ref_AllotmentEdition R ON PA.EditionId = R.EditionId INNER JOIN
               Ref_Period Per ON R.Period = Per.Period
			   <cfif url.scope neq "">
			   	 	INNER JOIN ProgramAllotmentDetailContribution PADC ON PADC.Transactionid = PA.TransactionId AND PADC.ContributionLineId = '#url.cid#'
			   </cfif>
			   
	WHERE      PA.TransactionId = '#url.transactionid#'
	
</cfquery> 

<!--- Observation : we can sync the below query with the query in DonorAllocationViewLines --->

<cfparam name="Form.ContributionLineIds_#left(url.transactionid,8)#" default="">
<cfset Ids = evaluate("Form.ContributionLineIds_#left(url.transactionid,8)#")>

<cfquery name="Period" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Period 
	WHERE  Period = '#get.ProgramPeriod#'
</cfquery>	

<cfquery name="Donor" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT    CL.ContributionLineId, 
	            CL.AmountBase,    
				
				<!--- correction of the contribution value until this period  --->
				
				( SELECT ISNULL(SUM(AmountBase),0) FROM ContributionLinePeriod
				  WHERE  ContributionLineId = CL.ContributionLineId
				  AND    Period IN (SELECT Period 
								    FROM   Ref_Period
				                    WHERE  DateExpiration <= '#period.dateExpiration#')				   			  
				 ) as AmountBaseAdditional,
				
				<!--- percentage set for overallocation --->
				 
				CL.OverAllocate,
				
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
				  
      FROM     Contribution C INNER JOIN
               ContributionLine CL ON C.ContributionId = CL.ContributionId INNER JOIN
               Organization.dbo.Organization O ON C.OrgUnitDonor = O.OrgUnit
				
	  WHERE    ContributionLineId IN (#preserveSingleQuotes(Ids)#)			
	  	 					
	  ORDER BY OrgUnitName		  
	 
</cfquery>

<!--- now we are going to apply --->

<cfset total = 0>
 
<cfoutput query="donor">
	
	<cfquery name="getPeriod" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT     *
		FROM       ContributionLinePeriod
		WHERE      ContributionLineId = '#contributionlineid#'
		AND        Period             = '#get.ProgramPeriod#'	
	</cfquery> 
	
	<!--- total for this contribution in the pending lines --->
	
	<cfparam name="form.AllocationAmount_#left(url.transactionid,8)#_#left(contributionlineid,8)#" default="0">
	
	<cfset amount = evaluate("form.AllocationAmount_#left(url.transactionid,8)#_#left(contributionlineid,8)#")>	
	<cfset amount = replace(amount,',','','ALL')> 	
	
	<cfif isNumeric(amount) and amount neq "0">
	
		<!--- we calculate the entered amount for validation, and include the correction for the PSC if this is relevant
		if the transaction itself has a status = 0 --->	
						
		<cfif get.supportpercentage neq "" and get.Status eq "0">
		    <!--- PSC has not be calculated yet, so we need to adjust this --->			
			<cfset traamount = amount + (amount * get.supportpercentage/100)>
		<cfelse>		   
		   	<cfset traamount = amount>
		</cfif>		
				
		<!--- determine how much money is resonably available based on the status of the allotment transaction --->
	
		<cfset ava =  (AmountBase+(AmountBase*(overallocate/100))+AmountBaseAdditional)-AmountBaseUsed-InProcess>
				
		<cfset bal =  (AmountBase+(AmountBase*(overallocate/100))+AmountBaseAdditional)-AmountBaseUsed-InProcess-traamount>
				
		<cfif round(bal) lt 0 and amount gt 0>
		
			<!--- not allowed for sure --->
		
			<cfquery name="getContribution" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">					
				SELECT  CL.*, 
				        C.Reference as ContributionReference
				FROM    ContributionLine CL, Contribution C
				WHERE   CL.ContributionLineId = '#ContributionLineId#'
				AND     CL.ContributionId     = C.ContributionId
		    </cfquery> 		
							
			<script language="JavaScript">			
				
				document.getElementById('line_#url.box#_#contributionlineid#').className = 'highlight2'		
				document.getElementById('apply').className = "hide"											
				alert("#getContribution.ContributionReference#/#getContribution.reference# \n\nThe recorded amount of: #numberformat(amount,',__')# <cfif amount neq traamount>(#numberformat(traamount,',__')# with added PSC)</cfif> exceeds the CALCULATED available balance of #numberformat(ava,',__')#! \n\nOperation not allowed.")					
				
			</script>
		
										
		<cfelse>
		
			<script language="JavaScript">			
				document.getElementById('line_#url.box#_#contributionlineid#').className = 'regular'	
				document.getElementById('apply').className = "regular"						
			</script>
				
			<cfset total = total + amount>
			
		</cfif>	
		
	</cfif>

</cfoutput>

<!--- ------------------------------------- --->
<!--- show the result of the total checking --->
<!--- ------------------------------------- --->

<cfoutput>
	
	<cfif abs(total-get.AmountBase) lte 0.1>	
		    	 
		<font color="green"><b>#numberformat(total,"__,__.__")#</font>				
		<script>		 
			document.getElementById('apply').className = "regular"	
		</script>
		
	<cfelse>	
			
		<table cellspacing="0" cellpadding="0">
			<tr><td align="right">			
				<font size="3" color="FF0000">#numberformat(total,"__,__.__")#</font>
			</td></tr>
			<tr><td align="right">
				<font size="1" color="red">(#numberformat(get.AmountBase-total,"__,__.__")#)</font>
			</td></tr>
		</table>
		
	    <script>
	    	document.getElementById('apply').className = "hide"	
		</script>
		
	</cfif>

</cfoutput>