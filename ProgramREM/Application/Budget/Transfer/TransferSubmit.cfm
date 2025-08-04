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

<!--- submit --->

<!--- 
1. checkentry in ProgramAllotment
2. create entry in ProgramAllotmentAction
3. create entries in ProgramAllotmentDetail
	3.1 record the contribution
	3.2 create PSC entry if applicable
--->

<cfquery name="Lines" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM  dbo.#SESSION.acc#BudgetTransfer_#client.sessionNo# 			
</cfquery>	

<cftransaction>
	
	<cfloop query="Lines">
	
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
	  
	</cfloop> 
	
	<!--- budget transaction header ---> 
	
	<cf_assignId>
	
	<cfset actionid = rowguid>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.TransactionDate#">
	<cfset dte = dateValue>
	
	<cfquery name="getProgram" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		    SELECT     *
		    FROM       Program
			WHERE      ProgramCode = '#Lines.ProgramCode#'	   	 	
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
			WHERE      ProgramCode = '#Lines.ProgramCode#'	   
		 	AND        EditionId   = '#Lines.editionId#'
			AND        Period      = '#Lines.period#'		
	</cfquery>
	
	<cfset last = getAllotment.TransactionSerialNo+1>
	
	<cfquery name="setAllotment" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		    UPDATE     ProgramAllotment
			SET        TransactionSerialNo = '#last#'
			WHERE      ProgramCode = '#Lines.ProgramCode#'	   
		 	AND        EditionId   = '#Lines.editionId#'
			AND        Period      = '#Lines.period#'		
	</cfquery>
	
	<cfquery name="getOrganization" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		    SELECT     *
		    FROM       ProgramPeriod
			WHERE      ProgramCode = '#Lines.ProgramCode#'	
			AND        Period      = '#Lines.period#'   	 	
	</cfquery>
	
	<cfquery name="Parameter" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT     *
	     FROM       Ref_ParameterMission
		 WHERE      Mission = '#getProgram.Mission#'			    
	</cfquery>  	
			
	<cfset cur = parameter.BudgetCurrency>
			
	<cfquery name="getPeriod" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT     *
	     FROM       Ref_Period
		 WHERE      Period = '#Lines.period#'			    
	</cfquery>  	
			
	<cf_exchangeRate 
	    DataSource    = "AppsProgram"
		CurrencyFrom  = "#cur#" 
		CurrencyTo    = "#Application.BaseCurrency#"
		EffectiveDate = "#dateformat(getPeriod.DateEffective,CLIENT.DateFormatShow)#">
				
	<cfif Exc eq "0" or Exc eq "">
		<cfset exc = 1>
	</cfif>								
	
	<cfquery name="Param" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		    SELECT     *
		    FROM       ProgramPeriod
			WHERE      ProgramCode = '#Lines.ProgramCode#'	
			AND        Period      = '#Lines.period#'   	 	
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
			VALUES ('#Lines.ProgramCode#', 
		            '#Lines.EditionId#', 
				    '#Lines.Period#',
				    '#Lines.ActionClass#', 
					'#Form.Memo#',
					#dte#,
					'#rowguid#', 
					'#Lines.ActionClass#',					
					'#getProgram.Mission#/#Lines.Period#/#getOrganization.Reference#/#last#',
					'1',
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#')
	</cfquery>  
	
	<!--- ------------------------------------------------ --->
	<!--- ----now we record the details of the transaction --->
	<!--- ----make the transfer detail lines in a loop---- --->
	<!--- ------------------------------------------------ --->
	
	<cfloop query="Lines">
	
	  <cfif ActionClass eq "Transfer">
	      
		  <cfset amt = amount>
		  
	  <cfelse>
	  
	     <cfquery name="Amount" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    SUM(Amount) as Amount
				FROM      ProgramAllotmentDetail
				WHERE     ProgramCode = '#programcode#'
				AND       Period      = '#period#'
				AND       EditionId   = '#editionid#' 
				AND       ObjectCode  = '#objectcode#'
				AND       Fund        = '#fund#'
				AND       Status = '1'			
		</cfquery>	
	  
	    <cfif amount.amount eq "">
			<cfset amt = amount>
		<cfelse>
		    <cfset amt = amount - amount.amount>
		</cfif>
		   
	  </cfif>
	  
	  <!--- ---------------------------------------- --->
	  <!--- -------- 1 of 2 main transaction ------- --->
	  <!--- ---------------------------------------- --->
	  
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
						 TransactionDate, 
						 Currency,
						 Amount,
						 ExchangeRate,
						 AmountBase,
						 Fund,
						 ObjectCode,
						 Status,
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName)
				VALUES ('#rowguid#',
						'#ProgramCode#', 
				        '#EditionId#', 
						'#Period#',
						'#actionid#',
						#dte#, 
						'#cur#',
						#amt#,
						'#exc#',
						#round((amt*100)/exc)/100#,				
						'#fund#',
						'#ObjectCode#',
						'1',
						'#SESSION.acc#', 
						'#SESSION.last#', 
						'#SESSION.first#')
		</cfquery> 		
			
		<cfif contributionLineId neq "">
		
			<!--- create the contribution association --->
		
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
					VALUES 
						('#rowguid#',
						'#contributionLineId#', 				
						#amt#,				
						'#SESSION.acc#', 
						'#SESSION.last#', 
						'#SESSION.first#')
			</cfquery> 
				
		</cfif>
		
		<!--- ------------------------------------------------ --->
		<!--- ------- 2 of 2 program support transaction ----- --->
		<!--- ------------------------------------------------ --->
			
		<cfif check.SupportObjectCode neq "" and check.SupportPercentage gt "0">
		
			<cf_assignid>
			
			<cfset amtsup = amt * (check.SupportPercentage/100)>
			
			<cfset amtsup = round(amtsup*100)/100>
		
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
						 TransactionType,
						 Currency,
						 Amount,
						 ExchangeRate,
						 AmountBase,
						 Fund,
						 ObjectCode,
						 Status,
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName)					 
				VALUES 
						('#rowguid#',
						'#ProgramCode#', 
				        '#EditionId#', 
						'#Period#',
						'#actionid#',
						#dte#, 
						'Support',
						'#cur#',
						#amtsup#,
						'#exc#',
						#round(amtsup*100/exc)/100#,				
						'#fund#',
						'#check.SupportObjectCode#',
						'1',
						'#SESSION.acc#', 
						'#SESSION.last#', 
						'#SESSION.first#')
		    </cfquery> 
			
			<cfif contributionLineId neq "">
		
				<!--- create the contribution association --->
			
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
						VALUES 
							('#rowguid#',
							'#contributionLineId#', 				
							#amtsup#,				
							'#SESSION.acc#', 
							'#SESSION.last#', 
							'#SESSION.first#')
				</cfquery> 
				
			</cfif>	
		  
	   </cfif>  
	
	</cfloop>
	
	<!--- clear --->
	
	<cfquery name="remove" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM userQuery.dbo.#SESSION.acc#BudgetTransfer_#client.sessionNo# 			
	</cfquery>	
	
</cftransaction>

<cfquery name="getAction" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       Ref_AllotmentAction
		WHERE      Code = '#Lines.ActionClass#'	   	 	
</cfquery>

<cfif getAction.entityClass neq "">

	<!--- create workflow object --->
	
	<cfset link = "ProgramREM/Application/Budget/Action/AllotmentActionView.cfm?ID=#rowguid#">
 
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
		ObjectKey4       = "#actionid#"
		Show             = "No"	
	  	ObjectURL        = "#link#"
		DocumentStatus   = "0">
	
	<cfoutput>
	
		<script language="JavaScript">	
			<!--- launch the dialog for action --->	
			ColdFusion.navigate('#client.root#/ProgramREM/Application/Budget/Action/AllotmentActionViewContent.cfm?ID=#actionid#','main')					
		</script>
	
	</cfoutput>
	
<cfelse>	

	<script language="JavaScript">
	    opener.history.go()
		window.close()	
	</script>

</cfif>





