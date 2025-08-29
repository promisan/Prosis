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
1. delete record
2. refresh_listing
3. update amounts in ProgramAllotmentDetail and record modification
4. Refresh amount boxes
--->

<cfparam name="url.itemmaster" default="all">
<cfparam name="url.mode"       default="default">
<cfparam name="url.line"       default="0">
<cfparam name="url.objectcode" default="">

<cftransaction>

<!--- get the line that is to be removed --->
		
<cfquery name="Selected" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   ProgramAllotmentRequest
	WHERE  RequirementId = '#URL.RequirementId#'
</cfquery>		


<cfif url.objectcode neq "">
	<cfset selObjectcode = url.objectcode>
<cfelse>
    <cfset selObjectcode = selected.objectcode>
</cfif>

 <cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM       Program
	WHERE      ProgramCode = '#Selected.programCode#'			
</cfquery>

<!--- check if this requirement or related requirements through the parent has been cleared already --->

<cfif Selected.RequirementIdParent neq "">

		<!--- ------------------------------------------------------------------------- --->
		<!--- we determine if ANY of the lines of the clustered transaction has been
		involved in a ISSUES allotment action already---------------------------------- --->
		<!--- ------------------------------------------------------------------------- --->
		
		<cfquery name = "Cleared" 
		datasource    = "AppsProgram" 
		username      = "#SESSION.login#" 
		password      = "#SESSION.dbpw#">
			SELECT   * 
			FROM     ProgramAllotmentRequest
			<cfif url.line eq "0"> 
			WHERE    RequirementIdParent = '#Selected.RequirementIdParent#'
			<cfelse>
			WHERE    RequirementId       = '#Selected.RequirementId#'
			</cfif>
			AND      EditionId           = '#Selected.EditionId#'
		    AND      Period              = '#Selected.Period#'
			
			AND      RequirementId IN (SELECT RequirementId 
			                           FROM   ProgramAllotmentDetailRequest R
									   WHERE  TransactionId IN (SELECT TransactionId 
									                            FROM   ProgramAllotmentDetail
																WHERE  TransactionId = R.TransactionId
											  				    AND    Status = '1'
															  )
									)		
									
													  
		</cfquery>
		 
		<cfif Cleared.recordcount eq "0">
		
			<!--- No, none of the lines, so we can fully remove clustered transaction safely --->
			
			<cfif Selected.RequestType eq "Standard">
			
				<cfquery name="Remove" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM ProgramAllotmentDetail
					WHERE  TransactionId IN (SELECT TransactionId 
					                         FROM   ProgramAllotmentDetailRequest 
											 WHERE  RequirementId IN (SELECT RequirementId 
											                          FROM   ProgramAllotmentRequest 
																	  <cfif url.line eq "0"> 
															   		  WHERE    RequirementIdParent = '#Selected.RequirementIdParent#'
																	  <cfelse>
															          WHERE    RequirementId       = '#Selected.RequirementId#'
															          </cfif>																	  
																	  AND    EditionId           = '#Selected.EditionId#'
																	  AND    Period              = '#Selected.Period#')
											)						  	
				</cfquery>
				
				<cfquery name="Remove" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM ProgramAllotmentRequest
					<cfif url.line eq "0"> 
					WHERE    RequirementIdParent = '#Selected.RequirementIdParent#'
					<cfelse>
					WHERE    RequirementId       = '#Selected.RequirementId#'
					</cfif>						
					AND    EditionId = '#Selected.EditionId#'
				    AND    Period    = '#Selected.Period#'		
				</cfquery>
				
			<cfelse>
					    
				<!--- Provision to individually remove rippled records --->
				
				<cfquery name="Remove" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM ProgramAllotmentDetail
					WHERE  TransactionId IN (SELECT TransactionId 
					                         FROM   ProgramAllotmentDetailRequest 
											 WHERE  RequirementId IN (SELECT RequirementId 
											                          FROM   ProgramAllotmentRequest 
																	  <cfif url.line eq "0"> 
																	  WHERE    RequirementIdParent = '#Selected.RequirementIdParent#'
															  		  <cfelse>
															          WHERE    RequirementId       = '#Selected.RequirementId#'
																      </cfif>
																	  AND    EditionId       = '#Selected.EditionId#'
																	  AND    Period          = '#Selected.Period#')
											)						  	
				</cfquery>
								
				<cfquery name="Remove" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM ProgramAllotmentRequest	
					<cfif url.line eq "0"> 
					WHERE    RequirementIdParent = '#Selected.RequirementIdParent#'
					<cfelse>
					WHERE    RequirementId       = '#Selected.RequirementId#'
					</cfif>
					AND    EditionId     = '#Selected.EditionId#'
				    AND    Period        = '#Selected.Period#'		
				</cfquery>					
				
			</cfif>	
			
		<cfelse>
		
		    <!--- Yes, it has benn cleared already for one or more of the clustered transaction, if done by administrator, we roll back
			if done by user we ONLY remove the existing line which can be done if also not partially allotted			
			--->
			
			<!---
			
			<cfif getAdministrator("*") eq "0">
			
			--->
			
			    <!--- this is not an administrator so we only disable THIS line which we determine can be deleted as it was not partially allotted yet --->
				
				<cfquery name="Disable" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE ProgramAllotmentRequest
					SET    ActionStatus        = '9',
					       ActionStatusDate    = getDate(),
						   ActionStatusOfficer = '#session.acc#'
					WHERE  RequirementId       = '#url.requirementid#'		
					AND    RequirementId IN (SELECT RequirementId 
			                                 FROM   ProgramAllotmentDetailRequest R
								    	     WHERE  TransactionId IN (SELECT TransactionId 
									                                  FROM   ProgramAllotmentDetail
																      WHERE  TransactionId = R.TransactionId
											  				          AND    Status IN ('0','P') <!--- not issued for allotment --->
															         )
									        )										
				</cfquery>	
				
			    <!--- logging of allotment release amount --->
				
				<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
					   method           = "LogRequirement" 
					   RequirementId    = "#url.RequirementId#">					
			
			<!--- 14/9 Hanno disabled as it is too tricky and now we enable editing
				
			<cfelse>		
						
				<cfquery name="Disable" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE ProgramAllotmentRequest
					SET    ActionStatus        = '9',
					       ActionStatusDate    = getDate(),
						   ActionStatusOfficer = '#session.acc#'
					WHERE  RequirementIdParent = '#Selected.RequirementIdParent#'	
					AND    EditionId           = '#Selected.EditionId#'
				    AND    Period              = '#Selected.Period#'			
				</cfquery>		
				
				<cfquery name="getListLog" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * FROM ProgramAllotmentRequest					
					WHERE  RequirementIdParent = '#Selected.RequirementIdParent#'	
					AND    EditionId           = '#Selected.EditionId#'
				    AND    Period              = '#Selected.Period#'			
				</cfquery>		
				
				<cfloop query="getListLog">
				
					 <!--- logging of allotment release amount --->
					 <cfinvoke component = "Service.Process.Program.ProgramAllotment"  
					   method           = "LogRequirement" 
					   RequirementId    = "#RequirementId#">						
					   
				</cfloop>	   
			
			   <!--- ----------------------------- --->	
			   <!--- get the allotment transaction --->
			   <!--- ----------------------------- --->
			
			   <cfquery name="getAllotmentDetail" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT TransactionId
					FROM   ProgramAllotmentDetail
				    WHERE  TransactionId IN (
					                         SELECT TransactionId
											 FROM   ProgramAllotmentDetailRequest
										 	 WHERE  RequirementId IN (SELECT RequirementId
											 						  FROM   ProgramAllotmentRequest
																	  WHERE  RequirementIdParent = '#Selected.RequirementIdParent#'	
																	  AND    EditionId = '#Selected.EditionId#'
																	  AND    Period    = '#Selected.Period#' )		
											)						  
			  </cfquery>
			  
			  <cfloop query="getAllotmentDetail">
			 	 
				  <cfquery name="getCorrectedRequirement" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					 
		                SELECT SUM(Amount) as Total
						FROM   ProgramAllotmentDetailRequest R
					 	WHERE  TransactionId = '#TransactionId#'		
						
						<!--- we take only the request that have an approved status now, the others are set to 9 --->						
						AND    RequirementId IN (SELECT RequirementId 
						                         FROM   ProgramAllotmentRequest 
												 WHERE  RequirementId = R.RequirementId 
												 AND    ActionStatus = '1')
																	  
				  </cfquery>
				 
				  <cfif abs(getCorrectedRequirement.total) gt "0.05">
					 
					 <cfquery name="Update" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE ProgramAllotmentDetail
							SET    Amount        = '#getCorrectedRequirement.total#',
							       AmountBase    = '#getCorrectedRequirement.total#',
								   AmountRounded = 0,
								   ActionId = NULL,
								   Status = '0'  <!--- enforces reapproval action --->
							WHERE  TransactionId = '#getAllotmentDetail.TransactionId#'		
					 </cfquery>
				 
				  <cfelse>
							
					<cfquery name="UpdateStatustoCancelled" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE ProgramAllotmentDetail
						SET    Status = '9'
						WHERE  TransactionId = '#TransactionId#'
					</cfquery>				
					
				  </cfif>	
				  
			  </cfloop>
			  
			</cfif>  
			
			--->
		
		</cfif> 
		
</cfif>		

<!--- define total amount per fund for this object/edition/program --->

<cfquery name="RequestLines" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    Fund, SUM(RequestAmountBase) as Request
		FROM      ProgramAllotmentRequest
		WHERE     ProgramCode = '#Selected.ProgramCode#' 
		AND       Period      = '#Selected.Period#' 
		AND       EditionId   = '#Selected.EditionId#' 
		AND       ObjectCode  = '#Selected.ObjectCode#'
		AND       ActionStatus = 1  <!--- amount is cleared, which is the default --->
		GROUP BY  Fund
</cfquery>		

<!--- provision for overcomplete if there are no records found at all --->

<cfif RequestLines.recordcount eq "0">

		<cfquery name="RemovePrior" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM ProgramAllotmentDetail
				WHERE       ProgramCode = '#Selected.programCode#'	
				AND         Period      = '#Selected.period#'    
				AND         EditionId   = '#Selected.EditionId#'
				AND         ObjectCode  = '#Selected.ObjectCode#'			    
		</cfquery>

</cfif>
	   
<cfinvoke component = "Service.Process.Program.Program"  
	   method           = "SyncProgramBudget" 
	   ProgramCode      = "#Selected.ProgramCode#" 
	   Period           = "#Selected.Period#"
	   EditionId        = "#Selected.EditionId#">		   

</cftransaction>
	
<cfoutput>
	
	<script>
	
		Prosis.busy('no')
		
	    <cfif url.mode eq "resource">
		
			ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestResourceDetail.cfm?mission=#program.mission#&programcode=#selected.programCode#&period=#selected.period#&editionid=#selected.EditionId#&objectcode=#selObjectCode#&cell=#url.cell#','box#url.cell#')
			
		<cfelse>
		
		    <cfif url.scope eq "listing">
			 	<!--- refresh listing --->
				ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestList.cfm?programcode=#selected.programCode#&period=#selected.period#&editionid=#selected.EditionId#&objectcode=#selObjectCode#&cell=#url.cell#','box#url.cell#')
				<!--- refresh amount --->
				ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/Amount.cfm?programcode=#selected.programCode#&period=#selected.period#&editionid=#selected.EditionId#&objectcode=#selObjectCode#','#selected.Editionid#_#selected.ObjectCode#_total')	
			<cfelse>
				md = document.getElementById('summaryselectmode').value	
				ptoken.navigate('#SESSION.root#/programrem/application/budget/request/RequestSummary.cfm?summarymode='+md+'&programcode=#selected.programcode#&period=#selected.period#&editionid=#selected.editionid#','summary')
				ptoken.navigate('#SESSION.root#/programrem/application/budget/request/RequestList.cfm?scope=dialog&programcode=#selected.programcode#&period=#selected.period#&editionid=#selected.editionid#&objectcode=#selobjectcode#&itemmaster=#selected.ItemMaster#','details')								
			</cfif>				
		
		</cfif>
	</script>
	
</cfoutput>


