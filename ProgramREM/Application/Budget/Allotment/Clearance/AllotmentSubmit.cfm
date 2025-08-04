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

<cfquery name="getProgram" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       Program
		WHERE      ProgramCode = '#Form.Program#'	   	 	
</cfquery>


<cfquery name="Edit" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT     *
	  FROM       Ref_AllotmentEdition
	  WHERE      EditionId = '#Form.Edition#'	   
</cfquery>

<cfquery name="Parameter" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT     *
	  FROM       Ref_ParameterMission
	  WHERE      Mission = '#getProgram.Mission#'	   
</cfquery>

<cfquery name="getOrganization" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       ProgramPeriod
		WHERE      ProgramCode = '#Form.Program#'	
		AND        Period      = '#Form.period#'   	 	
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

<cfquery name="getTransactions" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       ProgramAllotmentDetail
		WHERE      ProgramCode = '#Form.Program#'	   
	 	AND        EditionId   = '#Form.edition#'
		AND        Period      = '#Form.period#'
		AND        Status      = '0'		
		AND        Amount <> 0		
		ORDER BY TransactionId
</cfquery>


<cfset st = "0">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cftransaction>

<!--- --------------------------------- --->
<!--- assign a transaction reference No --->
<!--- --------------------------------- --->

<cfquery name="getAllotment" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       ProgramAllotment
		WHERE      ProgramCode = '#Form.Program#'	   
	 	AND        EditionId   = '#Form.edition#'
		AND        Period      = '#Form.period#'		
</cfquery>

<cfset last = getAllotment.TransactionSerialNo+1>

<cfquery name="setAllotment" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    UPDATE     ProgramAllotment
		SET        TransactionSerialNo = '#last#'
		WHERE      ProgramCode = '#Form.Program#'	   
	 	AND        EditionId   = '#Form.edition#'
		AND        Period      = '#Form.period#'		
</cfquery>

<!--- --------------------------------- --->
<!--- end assign a transaction reference No --->
<!--- --------------------------------- --->

<cfquery name="getAction" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       Ref_AllotmentAction
		WHERE      Code = 'Transaction'	   	 	
</cfquery>

<!--- update amounts by edition --->

<cfset program     = Evaluate("FORM.Program")>
<cfset period      = Evaluate("FORM.Period")>
<cfset edition     = Evaluate("FORM.Edition")>
<cfset memo        = Evaluate("FORM.ActionMemo")>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.TransactionDate#">
<cfset dte = dateValue>

<cfset list        = "">

<!--- create transaction document --->

<cf_assignId>
	
<cfquery name="Insert" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO ProgramAllotmentAction
			(ActionId,
			 ProgramCode,
			 Period,
			 EditionId,
			 ActionClass, 			
			 ActionType, 
			 ActionDate,
			 Status,
			 Reference,
			 ActionMemo,
			 AmountRounding,
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
	VALUES ('#rowguid#',
	        '#Program#',
	        '#Period#',
			'#Edition#',
	        'Transaction', 			
			'Processed',
			#dte#,
			<cfif getAction.entityClass neq "">
			'0',
			<cfelse>
			'1',
			</cfif>
			'#getProgram.Mission#/#Form.period#/#ref#/#last#',
			'#memo#',
			'#getAllotment.AmountRounding#',
			'#SESSION.acc#', 
			'#SESSION.last#', 
			'#SESSION.first#')
</cfquery>  

<cfloop query="getTransactions">

	<cfif list eq "">
		<cfset list = "'#transactionid#'">
	<cfelse>
		<cfset list = "#list#,'#transactionid#'">
	</cfif>
	
	<cfset traid = replaceNoCase(transactionid,"-","","ALL")> 
	
	<cfparam name="Form.Decision_#traid#" default="0">	
	<cfset de  = Evaluate("Form.Decision_#traid#")>	
		
	<cfif de neq "0">
	
		<!--- check if the cleared transaction is correctly funded --->
			  
		<cfif Parameter.EnableDonor eq "1" and Edit.BudgetEntryMode eq "1" and de eq "1">
		  			
				<cfquery name="getContribution" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT     Amount, 
					            (SELECT isNULL(SUM(Amount),0)
					             FROM ProgramAllotmentDetailContribution
								 WHERE TransactionId = D.TransactionId) as AmountContribution						  
					FROM       ProgramAllotmentDetail D			   
					WHERE      TransactionId  = '#transactionid#'	   
			   </cfquery>	
			   
			   <cfset diff = getContribution.amount - getContribution.AmountContribution>
			   
			   <cfif abs(diff) gte 0.02>
			   
			   		<cf_alert message="The Program Support costs (#getContribution.Amount#) were not correctly covered by one or more contribution lines (#getContribution.AmountContribution#). Operation interrupted">
					<cfabort>
						
			   </cfif> 
		  
		</cfif>
		
		<!--- link to the transaction --->
		  		 	  
		<cfquery name="ProcessTransactionDecision" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE     ProgramAllotmentDetail
				SET        Status           = '#de#',
				           ActionId         = '#rowguid#',
						   TransactionDate  = #dte#,
				           OfficerUserId    = '#SESSION.acc#',
						   OfficerLastName  = '#SESSION.last#',
						   OfficerFirstName = '#SESSION.first#',
						   Created          = getDate()  
				WHERE      TransactionId    = '#transactionid#'	   
		</cfquery>	 
		  
		<cfif de eq "9">
		  
		     <cfquery name="SetRequirementAsDenied" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE     ProgramAllotmentRequest
				SET        ActionStatus = '#de#'
				WHERE      RequirementId IN (SELECT RequirementId 
				                             FROM   ProgramAllotmentDetailRequest 
											 WHERE  TransactionId = '#transactionid#')	 
				AND        ActionStatus = '1'											   
		 	 </cfquery>			
		  
		</cfif>		  
	
	</cfif>
	
</cfloop>	

<!--- perform a sync --->

<cfinvoke component = "Service.Process.Program.Program"  
	   method           = "SyncProgramBudget" 
	   ProgramCode      = "#Program#" 
	   Period           = "#Period#"
	   EditionId        = "#Edition#">	

</cftransaction>
	   
<!--- -------- --->	   
<!--- workflow --->
<!--- -------- ---> 


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
		OrgUnit          = "#getOrganization.OrgUnit#"
		ObjectReference  = "Allotment #getOrganization.Reference#"
		ObjectReference2 = "#getProgram.ProgramName#"
		ObjectKey4       = "#rowguid#"
		Show             = "No"	
	  	ObjectURL        = "#link#"
		DocumentStatus   = "0">
	
	<cfoutput>
	
		<script language="JavaScript">	
			<!--- launch the dialog for action --->	
			ColdFusion.navigate('#client.root#/ProgramREM/Application/Budget/Action/AllotmentActionViewContent.cfm?ID=#rowguid#','main')					
		</script>
	
	</cfoutput>
	
<cfelse>	

	<cfoutput>

	<script language="JavaScript">
	    try {
	    	se = opener.document.getElementById('verify#edition#')		
			se.click() } catch(e) {}		
		window.close()			
	</script>
	
	</cfoutput>

</cfif>

<cfquery name="cleanemptyaction" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE ProgramAllotmentAction 
		FROM   ProgramAllotmentAction A
		WHERE  ActionId NOT IN (SELECT ActionId 
		                        FROM   ProgramAllotmentDetail 
								WHERE  ActionId = A.ActionId)	
		AND    Status != '9'						
</cfquery>  

<script>
	Prosis.busy('no')
</script>

	
