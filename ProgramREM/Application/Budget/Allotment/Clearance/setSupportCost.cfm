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
<cfset program     = Evaluate("FORM.Program")>
<cfset period      = Evaluate("FORM.Period")>
<cfset edition     = Evaluate("FORM.Edition")>


<cfquery name="get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT     *
    FROM       Program
	WHERE      ProgramCode = '#Form.Program#'	   	 		
</cfquery>

<cfquery name="Param" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT     *
    FROM       Ref_ParameterMission
	WHERE      Mission = '#get.Mission#'	   	 		
</cfquery>

<cfquery name="Allotment" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       ProgramAllotment
		WHERE      ProgramCode = '#Form.Program#'	   
	 	AND        EditionId   = '#Form.edition#'
		AND        Period      = '#Form.period#'			
</cfquery>

<!--- ------------------------------------------------------------------------------------- --->
<!--- get the potential transaction to be reviewed if they have been selected for clearance --->
<!--- ------------------------------------------------------------------------------------- --->

<cfquery name="getPendingTransactions" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       ProgramAllotmentDetail R
		WHERE      ProgramCode     = '#Form.Program#'	   
	 	AND        EditionId       = '#Form.edition#'
		AND        Period          = '#Form.period#'
		AND        Fund            = '#url.fund#'		
		AND        TransactionType = 'Standard'		
		<!--- only OE that are enabled for support costs --->
		AND        ObjectCode IN (SELECT Code 
					              FROM   Ref_Object 
							      WHERE  Code = R.ObjectCode 
								  AND    SupportEnable = 1)
		AND        Status          = '0'		
		AND        Amount <> 0				
		ORDER BY   OrgUnit,TransactionId
</cfquery>

<cfset amt = 0>
<cfset traload = getPendingTransactions.TransactionId> 

<!--- we create support costs by orgunit --->

<cfoutput query="getPendingTransactions" group="OrgUnit">

	    <!--- to ensure we refresh the correct line to be shown in bottom --->
		<cfif orgunit eq url.orgunit>
			<cfset traload = transactionid>
		</cfif>
	
		<cfquery name="getSupportTransaction" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			    SELECT  * 
				FROM    ProgramAllotmentDetail			
				WHERE   ProgramCode     = '#Form.Program#'	   
			 	AND     EditionId       = '#Form.edition#'
				AND     Period          = '#Form.period#'
				AND     Fund            = '#url.fund#'
				AND     OrgUnit         = '#OrgUnit#'			
				AND     Status          = '0'		
				AND     TransactionType = 'Support'					
		</cfquery>
	
		<cfif Param.EnableDonor neq "1">
		
		<!--- ------- --->
			
		<cfelse>
			
			<cfset supportid = getSupportTransaction.TransactionId>
				
			<cfif getSupportTransaction.recordcount eq "0">
		
				<!--- we need to generate and entry based on the selection ---->
			
			<cfelse>
		
				<!--- clear the contributions --->
				    
				<cfquery name="setInitialSupport" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    DELETE FROM ProgramAllotmentDetailContribution
						WHERE  TransactionId = '#supportid#'						
				</cfquery>		
					
			</cfif>
		
			<cfoutput>
		
			<cfset traid = replaceNoCase(transactionid,"-","","ALL")> 
		
			<cfparam name="Form.Decision_#traid#" default="0">
			
			<cfset de  = Evaluate("Form.Decision_#traid#")>
					
			<cfif de eq "1">
					
					<cfset amt = amt + amount>
					
					<!--- create the PSC transaction based on the entry for that line --->
					
					<cfquery name="getContributions" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">					
						SELECT    ContributionLineId, 
								  Amount * #allotment.SupportPercentage/100# AS Amount, 
								  OfficerUserId, 
								  OfficerLastName,
								  OfficerFirstName
						FROM      ProgramAllotmentDetailContribution
						WHERE     TransactionId = '#transactionId#'		
					</cfquery>			
											
					<cfloop query="getContributions">		
					
						<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
						   method               = "associateContribution" 
						   TransactionId        = "#supportId#" 
						   ContributionLineId   = "#contributionlineid#"
						   Amount               = "#amount#">		   																			
						
					</cfloop>	
						
		      </cfif>
			  
			  </cfoutput>	
				
				<!--- revalidates the total on the line level based on the association
				maybe we can move this also into the component --->
				
				<cfquery name="getContribution" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT     Amount, 
						           (SELECT isNULL(SUM(Amount),0)
						            FROM   ProgramAllotmentDetailContribution
									WHERE  TransactionId = D.TransactionId) as AmountContribution						  
						FROM       ProgramAllotmentDetail D			   
						WHERE      ProgramCode     = '#Form.Program#'	   
					 	AND        EditionId       = '#Form.edition#'
						AND        Period          = '#Form.period#'
						AND        Fund            = '#url.fund#'
						AND        OrgUnit         = '#Orgunit#'
						AND        Status          = '0'		
						AND        TransactionType = 'Support'		
				</cfquery>	
				
				<cfquery name="getSupportValue" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						    SELECT  * 
							FROM    ProgramAllotmentDetail				
							WHERE   ProgramCode     = '#Form.Program#'	   
						 	AND     EditionId       = '#Form.edition#'
							AND     Period          = '#Form.period#'
							AND     OrgUnit         = '#OrgUnit#'
							AND     Fund            = '#url.fund#'
							AND     Status          = '0'		
							AND     TransactionType = 'Support'					
				</cfquery>
				
				<cfquery name="setSupportValue" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						    UPDATE     ProgramAllotmentDetail
							SET        Amount          = '#getContribution.AmountContribution#', 
							           AmountBase      = '#getContribution.AmountContribution#'/ExchangeRate		
							WHERE      ProgramCode     = '#Form.Program#'	   
						 	AND        EditionId       = '#Form.edition#'
							AND        Period          = '#Form.period#'
							AND        OrgUnit         = '#OrgUnit#'
							AND        Fund            = '#url.fund#'
							AND        Status          = '0'		
							AND        TransactionType = 'Support'					
				</cfquery>
								
				<cfif url.orgunit eq orgunit>	
				<font color="0080C0">#NumberFormat(getContribution.AmountContribution,",.__")#</font>
				</cfif>
				
				<script language="JavaScript">
				
					<cfif getContribution.AmountContribution eq "0">		
				      document.getElementById('Decision_#getSupportValue.transactionid#_1').value=0
					<cfelse>		
				      document.getElementById('Decision_#getSupportValue.transactionid#_1').value=1
					</cfif>
					
				</script>	
				
			</cfif>	
	
</cfoutput>

<cfoutput>

	<cfif Param.EnableDonor neq "1">
	
		<script>		
			<!--- show the support costs and then update the overall summary --->							   
		    ptoken.navigate('setAllocationSummary.cfm','amountaction','','','POST','clear')
		</script> 
	
	<cfelse>
	
		<script>		
			<!--- show the support costs and then update the overall summary --->					
		    ptoken.navigate('DonorAllocationViewLines.cfm?datamode=limited&transactionid=#traload#','donor_#traload#')		
		    ptoken.navigate('setAllocationSummary.cfm','amountaction','','','POST','clear')
		</script> 
	
	</cfif>
 
</cfoutput>

	

