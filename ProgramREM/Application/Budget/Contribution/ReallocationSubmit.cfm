
<!--- 

	to be completed

	reallocation submit transaction in this screen we make a correction based on the assigned contributions hereto we make a contraction
	
	1. based on the transactionid we determine the programallotment details i.e
	     program, period, edition, fund, objectcode and unit and the amount		 
	2.  we create a new Amendment transaction	 
	3a.	We then record based on the amount a negative transaction for the same and for the original contributions as associated to that transaction	 	
	3b. We check once we lower for each contribution if the already mapped transactions would not exceed the new lower allotment amount	
	3c. We then record based on the same amount a positive transaction and the selected contributions 	
	4. we repeat then the same for the defined PSC based on the amount * percentage for the defined Orgunit	
	(attention : we make sure if such a transaction exists already for that combination : 
		program, period, edition, fund, PSC OE and unit)
	
	we check if a workflow has to be create, if not we close and refresh, otherwise we open the workflow.

--->

<!--- first we get some context information for basic posting --->

<cfset TraIds     = "">

<cfloop index="transactionid" list="#form.transactionids#" delimiters=":">
	
	<cfif TraIds eq "">
		<cfset TraIds = "'#TransactionId#'">
	<cfelse>
		<cfset TraIds = "#TraIds#,'#TransactionId#'">
	</cfif>	

</cfloop>

<cfquery name="source" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   ContributionLine
		WHERE  ContributionLineId = '#url.contributionlineid#'		
</cfquery>	


<!--- contains the new transactions indeed posted --->
<cfset ValidTraIds = "">

<cftransaction>

	<!--- we group the transactions by program/period/edition so we get one batch transaction per project --->

	<cfquery name="getActions" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT ProgramCode,Period,EditionId 
		FROM   ProgramAllotmentDetail D
		WHERE  TransactionId IN (#preserveSingleQuotes(TraIds)#)	
		AND    (TransactionIdSource is NULL or TransactionIdSource NOT IN (SELECT TransactionId 
		                                   FROM   ProgramAllotmentDetail 
									       WHERE  TransactionId = D.TransactionIdSource )		)
	</cfquery>	
		
	<cfif getActions.recordcount eq "0">
	
		<script>
		  alert("It appears that the selected transactions have been processed already !")
		  Prosis.busy('no');
		</script>
		<cfabort>		
	
	</cfif>	
		
	<!--- WEDNESDA we NEED to first determine if indeed something has changed for that line otherwise we are not going to
	create a fake  transaction with positive and negatives --->
		
	<cfloop query="getActions">
	
	  <!--- verify if header program allotment record exists for the edition --->
	  
	  <cfquery name="Check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       ProgramAllotment
			WHERE      ProgramCode = '#programcode#'	
			AND        Period      = '#period#'   
			AND        EditionId   = '#EditionId#'
	  </cfquery>
	  
	  <cfif Check.recordcount eq "0">
	  
		  <cfquery name="Insert" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO ProgramAllotment
				   (ProgramCode, 
				    Period, 
					EditionId,
					OfficerUserId, 
					OfficerLastName, 
					OfficerFirstName)
			Values ('#ProgramCode#', 
			        '#period#', 
					'#EditionId#', 
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#')
		  </cfquery>
	
	  </cfif>
	  			
	  <!--- budget transaction header ---> 
				
	  <cfset dateValue = "">
	  <CF_DateConvert Value="#Form.TransactionDate#">
	  <cfset dte = dateValue>
		
	  <cfquery name="getProgram" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			    SELECT     *
			    FROM       Program
				WHERE      ProgramCode = '#ProgramCode#'	   	 	
	  </cfquery>
	  
  	  <cfquery name="param" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT     *
		    FROM       Ref_ParameterMission
			WHERE      Mission = '#getProgram.Mission#'	   	 	
	  </cfquery>
	
	  <!--- --------------------------------- --->
	  <!--- assign a transaction reference No --->
	  <!--- --------------------------------- --->
	
	  <cfquery name="getAllotment" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		    SELECT     TransactionSerialNo
		    FROM       ProgramAllotment
			WHERE      ProgramCode = '#ProgramCode#'	   
		 	AND        EditionId   = '#editionId#'
			AND        Period      = '#period#'		
	  </cfquery>
	
	  <cfset last = getAllotment.TransactionSerialNo+1>
	
	  <cfquery name="setAllotment" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		    UPDATE     ProgramAllotment
			SET        TransactionSerialNo = '#last#'
			WHERE      ProgramCode         = '#ProgramCode#'	   
		 	AND        EditionId           = '#editionId#'
			AND        Period              = '#period#'		
	  </cfquery>	
	
	  <cfquery name="getOrganization" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		    SELECT     *
		    FROM       ProgramPeriod
			WHERE      ProgramCode = '#ProgramCode#'	
			AND        Period      = '#period#'   	 	
	  </cfquery>
				
	  <cfif getOrganization.Reference neq "">
		<cfset ref = getOrganization.Reference>
		<cfif len(ref) gte "5">
			<cfset ref = left(ref,5)>
			<cfset ref = trim(ref)>
		</cfif>
	  <cfelse>
	    <cfset ref = Form.Program>
	  </cfif>		
	
	  <cf_assignId>	
	  <cfset newactionid = rowguid>
	
	  <!--- insert the header of the action --->
	
	  <cfquery name="InsertHeader" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO ProgramAllotmentAction
					(ProgramCode, 
				     EditionId,
				     Period,
				     ActionClass, 
					 ActionMemo,
					 ActionDate,
					 ActionId,
					 ActionType, 
					 Reference,
					 Status,
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)
			VALUES ('#ProgramCode#', 
		            '#EditionId#', 
				    '#Period#',
				    'Amendment', 
					'#Form.Memo#',
					#dte#,
					'#newactionid#', 
					'Contribution',					
					'#getProgram.Mission#/#Period#/#ref#/#last#',  <!--- this is the reference code --->
					'1',
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#')
	  </cfquery>  
	
	  <!--- ------------------------------------------------ --->
	  <!--- ----now we record the details of the transaction --->
	  <!--- ----make the transfer detail lines in a loop---- --->
	  <!--- ------------------------------------------------ --->
	
	  <cfquery name="getActionLines" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT ProgramCode, 
			       EditionId, 
				   Period, 
				   Amount, 				   
				   AmountBase, 
				   Fund, 
				   ObjectCode, 
				   OrgUnit, 
				   TransactionId, 
				   TransactionDate,
				   TransactionId as SelectedTransactionId
			FROM   ProgramAllotmentDetail
			WHERE  ProgramCode = '#ProgramCode#'
			AND    EditionId   = '#EditionId#'
			AND    Period      = '#Period#'
			AND    TransactionId IN (#preserveSingleQuotes(TraIds)#)			
	 </cfquery>	
	 
	 <cfset newactions = "">	 
	 				
	 <cfloop query="getActionLines">
	 	 		 	 
		<cfset prior  = SelectedTransactionId>	 		
		<!--- retrieve the contributions from the user screen --->
				
	    <cfparam name="Form.ContributionLineIds_#left(prior,8)#" default="">
	    <cfset contributionIds = evaluate("Form.ContributionLineIds_#left(Prior,8)#")>
	  
		<cfif contributionIds eq "">
				
		<cfelse>
			 	  
		  <!--- -------------------------------------------------------- --->
		  <!--- ---------------- 1 of 2 base transaction --------------- --->
		  <!--- -------------------------------------------------------- --->
		  
		  <!---
		  <cfoutput>id:#SelectedTransactionId#</cfoutput>
		  --->

		  <cf_assignid>		 
		  <cfset offset = rowguid>
		  
		  <!--- -------------------------------------------------------- --->
		  <!--- --1a. negative transaction with the old contribution---- --->
		  <!--- -------------------------------------------------------- --->
		  	 		  
		  <cfquery name="InsertTransaction" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO ProgramAllotmentDetail
							(TransactionId,
							 ProgramCode, 
							 EditionId,
							 Period,
							 ActionId,
							 TransactionDate, 
							 Currency,
							 Amount,
							 ExchangeRate,
							 AmountBase,
							 Fund,
							 ObjectCode,
							 OrgUnit,
							 Status,
							 TransactionIdSource,
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName)
					VALUES ('#offset#',
							'#ProgramCode#', 
					        '#EditionId#', 
							'#Period#',
							'#newactionid#',
							'#TransactionDate#', 
							'#param.budgetCurrency#',
							#amount*-1#,
							'#round(amount*1000/amountbase)/1000#',
							#amountbase*-1#,				
							'#Fund#',
							'#ObjectCode#',
							'#OrgUnit#',
							'1',
							'#prior#',   <!--- to indicate that this transaction is indeed closed --->
							'#SESSION.acc#', 
							'#SESSION.last#', 
							'#SESSION.first#')
			</cfquery> 				
					
			<!--- -- create negative contribution association from the prior transaction -- --->
									
			<cfquery name="InsertTransactionContribution" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO ProgramAllotmentDetailContribution
							    (TransactionId, 
								 ContributionLineId,
								 Amount,				
								 OfficerUserId, 
								 OfficerLastName, 
								 OfficerFirstName)
						SELECT  '#offset#',
						         ContributionLineId,
							     Amount*-1,
							    '#SESSION.acc#', 
							    '#SESSION.last#', 
							    '#SESSION.first#'
						FROM    ProgramAllotmentDetailContribution	   
						WHERE   TransactionId = '#prior#'
			</cfquery> 		
						
			<!--- -------------------------------------------------------- --->
			<!--- 1b. make the positive transaction with new contributions --->
			<!--- -------------------------------------------------------- --->
						
			<cf_assignid>		
			<cfset newtraid = rowguid>	
			
			<cfquery name="InsertTransaction" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO ProgramAllotmentDetail
							(TransactionId,
							 ProgramCode, 
							 EditionId,
							 Period,
							 ActionId,
							 TransactionDate, 
							 Currency,
							 Amount,
							 ExchangeRate,
							 AmountBase,
							 Fund,
							 ObjectCode,
							 OrgUnit,
							 Status,						
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName)
					VALUES ('#newtraid#',
							'#ProgramCode#', 
					        '#EditionId#', 
							'#Period#',
							'#newactionid#',
							#dte#, 
							'#param.budgetCurrency#',
							#amount#,
							'#round(amount*1000/amountbase)/1000#',
							#amountbase#,				
							'#Fund#',
							'#ObjectCode#',
							'#OrgUnit#',
							'1',						
							'#SESSION.acc#', 
							'#SESSION.last#', 
							'#SESSION.first#')
			</cfquery> 
									
			<!--- reconstruct the possible new donor lines as they were presented to the user --->	
									 
			<cfquery name="Donor" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				  SELECT    CL.ContributionLineId, 
				            CL.AmountBase,
						   (   SELECT  ISNULL(SUM(Amount),0) 
							   FROM    ProgramAllotmentDetailContribution CD
							   WHERE   ContributionLineId = CL.ContributionLineId
			
							   <!--- valid allotment transaction --->
							   AND     TransactionId IN (SELECT TransactionId 
							                             FROM   ProgramAllotmentDetail 
														 WHERE  TransactionId = CD.TransactionId and Status != '9')
														 
							   AND     TransactionId !='#url.transactionid#') as AmountBaseAllocated		
							   	  
			      FROM      Contribution C INNER JOIN
			                ContributionLine CL ON C.ContributionId = CL.ContributionId INNER JOIN
			                Organization.dbo.Organization O ON C.OrgUnitDonor = O.OrgUnit
			
			      WHERE     ContributionLineId IN (#preserveSingleQuotes(ContributionIds)#)
				 	 
			</cfquery>
			
			<!--- create the positive contribution associations --->
			
			<cfloop query="donor">				
				
				<cfparam name="form.AllocationAmount_#left(prior,8)#_#left(contributionlineid,8)#" default="">
				<cfset amt = evaluate("form.AllocationAmount_#left(prior,8)#_#left(contributionlineid,8)#")>
				<cfset amt = replace(amt,',','','ALL')> 	
								
				<cfif isNumeric(amt)>	
												
					<cfif amt neq "0">		
					
						<!--- now we create an entry --->
					
						<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
							   method               = "associateContribution" 
							   TransactionId        = "#newtraid#" 
							   ContributionLineId   = "#contributionlineid#"
							   Amount               = "#amt#">		   																						
					   
					</cfif>				
				
				</cfif>
			
			</cfloop>				
			
			<!--- we also check if the new contributions are different from the old lines as otherwise we
			start recorded old and new with just the same data hereto we extract the old and compare it with the new --->
			
			<cfquery name="getPrior" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  * 
				FROM    ProgramAllotmentDetailContribution	   
				WHERE   TransactionId = '#prior#'
			</cfquery>	
			
			<cfset submitgo = "0">			
			
			<!---
			<cfdump var="#getPrior#" output="browser">
			--->
			
			<cfloop query="getprior">
									
				<cfquery name="getNew" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT  * 
					FROM    ProgramAllotmentDetailContribution	   
					WHERE   TransactionId      = '#newtraid#'
					AND     ContributionLineId = '#contributionlineid#' 
					AND     Amount             = '#Amount#'
				</cfquery>	
				
				<!---
				<cfdump var="#getNew#" output="browser">
				--->
				
				<cfif getNew.recordcount eq "0">
				     <!--- combination does not exist and thus it is a go --->
					 <cfset submitgo = "1">		
									 					 
				</cfif>						
										
			</cfloop>
										
			<cfif submitgo eq "0">
			
					<!--- remove the unneeded transactions both revert and new --->
																				
					<cfquery name="remove" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						DELETE FROM ProgramAllotmentDetail   
						WHERE   (TransactionIdSource = '#prior#' OR TransactionId = '#newtraid#')						
					</cfquery>							    
										
			<cfelse>								  
					
					<cfif validTraIds eq "">
						<cfset validTraIds = "'#newtraid#'">
					<cfelse>
						<cfset validTraIds = "#validTraIds#,'#newtraid#'">
					</cfif>	
			
					<!--- Now we check as the amounts that are lowered could have resulted in overspending a contribution 
					Attention : you can solve this adjusting the mapping (undo mapping) --->
					
					<cfquery name="OriginalContribution" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">					
							SELECT *
							FROM   ProgramAllotmentDetailContribution	   
							WHERE  TransactionId = '#Transactionid#'
					</cfquery> 
					
					<cfloop query="OriginalContribution">
					
							<cfquery name="getContribution" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">					
									SELECT CL.*, C.Reference as ContributionReference
									FROM   ContributionLine CL, Contribution C
									WHERE  CL.ContributionLineId = '#ContributionLineId#'
									AND   CL.ContributionId = C.ContributionId
							</cfquery> 							
					
							<cfinvoke component    = "Service.Process.Program.ProgramAllotment"  
							   method              = "validateContributionBalance" 
							   ProgramCode         = "#getActionLines.programcode#" 
							   Period              = "#getActionLines.Period#"	
							   Fund                = "#getActionLines.Fund#"
							   ObjectCode          = "#getActionLines.ObjectCode#"						  
							   ContributionLineId  = "#ContributionLineId#"
							   returnvariable      = "contribution">
										 
						   <cfif contribution.accept eq "No">
						   
						        <cfoutput>
							    	<script>
										alert("Attention : Adjusting the contribution [#getContribution.ContributionReference#/#getContribution.reference#] will result in overspending (#numberformat(contribution.disbursed,"__,__.__")#) its alloted amounts (#numberformat(contribution.allotment,"__,__.__")#) It is required to reset the mapped commitments for this project first. Operation aborted.")
										try {document.getElementById('apply').className = "regular" } catch(e) {}
										Prosis.busy('no');
									</script>
								</cfoutput>
								
							    <cfabort>
								  
						   </cfif>
					
					</cfloop>										
					
					<!--- ------------------------------------------------ --->
					<!--- ------- 2 of 2 program support transaction ----- --->
					<!--- ------------------------------------------------ --->		
										
					<!--- correction 15/9/2015 to aply this only if the mater OE is enabled for that 
					
					#ObjectCode#
					
					--->		
					
					<cfquery name="getObject" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT     *
							FROM       Ref_Object
							WHERE      Code  = '#ObjectCode#'				
					</cfquery>
					
					<cfif getObject.SupportEnable eq "1">		
								
							<cfif check.SupportObjectCode neq "" and check.SupportPercentage gt "0">
							
								<cf_assignid>
								<cfset offsetsupport = rowguid>
								
								<cfset amtsup = amount * (check.SupportPercentage/100)>			
								<cfset amtsup = round(amtsup*100)/100>
								
								<cfset amtbasesup = amountbase * (check.SupportPercentage/100)>			
								<cfset amtbasesup = round(amtbasesup*100)/100>
																	
								<!--- --create negative contribution association from the prior transaction-- --->
							
								<cfquery name="OffsetSupport" 
									datasource="AppsProgram" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									INSERT INTO ProgramAllotmentDetail
									
											(TransactionId,
											 ProgramCode, 
											 EditionId,
											 Period,
											 ActionId,
											 TransactionDate, 
											 TransactionType,
											 Currency,
											 Amount,
											 ExchangeRate,
											 AmountBase,
											 Fund,
											 ObjectCode,
											 OrgUnit,
											 Status,
											 TransactionIdSource,						 
											 OfficerUserId, 
											 OfficerLastName, 
											 OfficerFirstName)		
											 			 
									VALUES ('#offsetsupport#',
											'#ProgramCode#', 
									        '#EditionId#', 
											'#Period#',
											'#newactionid#',
											#dte#, 
											'Support',
											'#param.BudgetCurrency#',
											#amtsup#*-1,
											'#round(amtsup*1000/amtbasesup)/1000#',											
											#amtbasesup#*-1,				
											'#fund#',
											'#check.SupportObjectCode#',
											'#OrgUnit#',
											'1',
											'#prior#',  <!--- we set here the transactionid the triggered the offset --->
											'#SESSION.acc#', 
											'#SESSION.last#', 
											'#SESSION.first#')
											
							    </cfquery> 
								
								<!--- -- and also create negative contribution association from the prior base 
								         transaction, there was na issue here -- --->												
												
								<cfquery name="InsertTransactionContribution" 
											datasource="AppsProgram" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											INSERT INTO ProgramAllotmentDetailContribution
													(TransactionId, 
													 ContributionLineId,
													 Amount,				
													 OfficerUserId, 
													 OfficerLastName, 
													 OfficerFirstName)
											SELECT '#rowguid#',
											       ContributionLineId,
												   -Amount*#(check.SupportPercentage/100)#,
												   '#SESSION.acc#', 
												   '#SESSION.last#', 
												   '#SESSION.first#'
											FROM   ProgramAllotmentDetailContribution	   
											WHERE  TransactionId = '#prior#' 
								</cfquery> 
																	
							<!--- -------------------------------------------------------- --->
							<!--- 1b. make the positive transaction with new contributions --->
							<!--- -------------------------------------------------------- --->
							
							<cf_assignid>
							
							<cfquery name="InsertTransaction" 
									datasource="AppsProgram" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									INSERT INTO ProgramAllotmentDetail
											(TransactionId,
											 ProgramCode, 
											 EditionId,
											 Period,
											 ActionId,
											 TransactionType,
											 TransactionDate, 
											 Currency,
											 Amount,
											 ExchangeRate,
											 AmountBase,
											 Fund,
											 ObjectCode,
											 OrgUnit,
											 Status,						
											 OfficerUserId, 
											 OfficerLastName, 
											 OfficerFirstName)
									VALUES ('#rowguid#',
											'#ProgramCode#', 
									        '#EditionId#', 
											'#Period#',
											'#newactionid#',
											'Support',
											#dte#, 
											'#Param.BudgetCurrency#',
											#amtsup#,
											'#round(amtsup*1000/amtbasesup)/1000#',		
											#amtbasesup#,				
											'#Fund#',
											'#check.SupportObjectCode#',
											'#OrgUnit#',
											'1',						
											'#SESSION.acc#', 
											'#SESSION.last#', 
											'#SESSION.first#')
							</cfquery> 		
												
							<!--- create the positive contribution associations --->
							
							<cfloop query="donor">
								
								<cfparam name="form.AllocationAmount_#left(prior,8)#_#left(contributionlineid,8)#" default="">
								<cfset amt = evaluate("form.AllocationAmount_#left(prior,8)#_#left(contributionlineid,8)#")>
								<cfset amt = replace(amt,',','','ALL')> 	
											
								<cfif isNumeric(amt)>	
								
									<cfset amt = amt * (check.SupportPercentage/100)> 
																
									<cfif amt neq "0">		
									
										<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
											   method               = "associateContribution" 
											   TransactionId        = "#rowguid#" 
											   ContributionLineId   = "#contributionlineid#"
											   Amount               = "#amt#">		   																						
									   
									</cfif>				
								
								</cfif>
							
							</cfloop>		
												  
					   </cfif>  
				   
				 </cfif>  
		   
			 </cfif>
			 
		  </cfif>	 
	   	
	   </cfloop>
	
	</cfloop>
	
	<!--- remove the actions that have no single details --->
	
	<cfquery name="clear" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		    DELETE FROM ProgramAllotmentAction
			WHERE ActionId NOT IN (SELECT ActionId 
			                       FROM   ProgramAllotmentDetail 
								   WHERE  ActionId is NOT NULL)		
			AND Status != '9'					   		
	</cfquery>
					
</cftransaction>


<!--- posting completed, now we create the workflows outside the transaction --->

<cfif validTraIds eq "">

		<script language="JavaScript">
		    alert("No reallocations were recorded.")
			document.getElementById('apply').className = "regular"	
			Prosis.busy('no');
		</script>

<cfelse>

	<!--- ATTENTION : 8/7/2013 --------------

    we need to create NNN transactions for processing to be shown which we do by showing them on the left
	allowing the user to click through them --->
 	
	<cfquery name="getAction" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		    SELECT     *
		    FROM       Ref_AllotmentAction
			WHERE      Code = 'Amendment'	   	 	
	</cfquery>
	
	<cfif getAction.entityClass neq "">
	
		<!--- create workflow object --->
		
		<cfquery name="getDocument" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT     DISTINCT ProgramCode, ActionId
		    FROM       ProgramAllotmentDetail
			WHERE      TransactionId IN (#preservesingleQuotes(ValidTraIds)#)
		</cfquery>
								
		<cfif getDocument.recordcount eq "1">
									
			<cfset link = "ProgramREM/Application/Budget/Action/AllotmentActionView.cfm?ID=#newactionid#">
			
			<cfquery name="getProgram" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT     *
			    FROM       Program
				WHERE      ProgramCode = '#getDocument.ProgramCode#'			
			</cfquery>
		 
		    <!--- ---------------------- --->	
		    <!--- create workflow object --->
		    <!--- ---------------------- --->
		   					
		    <cf_ActionListing 
			    TableWidth       = "100%"
			    EntityCode       = "EntBudgetAction"
				EntityClass      = "#getAction.entityClass#"  
				EntityGroup      = "" 	
				EntityStatus     = ""		
				Mission          = "#getProgram.Mission#"		
				ObjectReference  = "Allotment Transfer"
				ObjectReference2 = "#getProgram.ProgramName#"
				ObjectKey4       = "#getDocument.ActionId#"
				Show             = "No"	
			  	ObjectURL        = "#link#"
				DocumentStatus   = "0">
			
			<cfoutput>
						
				<script language="JavaScript">	
					<!--- launch the dialog for action --->	
					ColdFusion.navigate('#session.root#/ProgramREM/Application/Budget/Action/AllotmentActionViewContent.cfm?ID=#getDocument.actionid#','main')					
					Prosis.busy('no');
				</script>
			
			</cfoutput>
			
		<cfelse>		
		
			<cfset actions = valueList(getDocument.ActionId,":")>
			
			<cfoutput>
			
			<script language="JavaScript">							
					ColdFusion.navigate('#session.root#/ProgramREM/Application/Budget/Action/AllotmentActionViewMultiple.cfm?actions=#actions#&ID=#getDocument.actionid#','main')					
					Prosis.busy('no');
			</script>
			
			</cfoutput>
						
			<!--- ----------------------------------------------------------------------------------- --->
			<!--- create a layout -to allow to select transactions generated and to view each of them --->
			<!--- ----------------------------------------------------------------------------------- --->
							
		</cfif>			
		
	<cfelse>	
	
		<!--- now we can just close and refresh the screen --->
	
	    <cfoutput>
		<script language="JavaScript">
		    parent.contributionreallocatefresh('#url.systemfunctionid#','#source.contributionid#','#source.contributionlineid#')
		    parent.ColdFusion.Window.destroy('mycontribution',true)			
		</script>
		</cfoutput>
	
	</cfif>
	
</cfif>	

	