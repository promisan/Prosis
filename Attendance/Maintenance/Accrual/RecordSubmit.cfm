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
<link rel="stylesheet" type="text/css" href="../../pkdb.css"> 

<cf_preventCache>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfquery name="Verify" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_LeaveTypeCredit
	WHERE  LeaveType    = '#Form.LeaveType#' 
	AND    ContractType = '#Form.ContractType#'
	AND    DateEffective = #STR#
</cfquery>

<cfif ParameterExists(Form.Insert) or (Verify.recordcount eq "0" and ParameterExists(Form.Update))> 
	
	<cfquery name="Verify" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_LeaveTypeCredit
		WHERE  LeaveType    = '#Form.LeaveType#' 
		AND    ContractType = '#Form.ContractType#'
		AND    DateEffective = #STR#
	</cfquery>

   <cfif Verify.recordCount is 1>
		
		<cf_tl id="An accrual record for this contract type and effective date has been registered already!" var="1">
		<cfoutput>
			<script>   
				alert('#lt_text#'); 
			</script>
		</cfoutput> 
		
   <cfelse>
   
		<cfparam name="Form.Calculation" default="day">
		<cfparam name="Form.CreditFull"  default="0">
		
		<cfif Form.CreditPeriod eq "Contract">
		
			<cfset vAllGood = 1>
			<cfloop from="1" to="#Form.CountCreditRows#" index="Ent">
				<cfif isDefined("Form.ContractDuration_#Ent#")>
					<cfset vDuration = evaluate("Form.ContractDuration_#Ent#")>
					<cfset vDuration = replace(vDuration, "'", "", "ALL")>
					<cfset vDuration = replace(vDuration, ",", "", "ALL")>
					<cfset vCredit = evaluate("Form.Credit_#Ent#")>
					<cfset vCredit = replace(vCredit, "'", "", "ALL")>
					<cfset vCredit = replace(vCredit, ",", "", "ALL")>
					
					<cfif isNumeric(vDuration) AND isNumeric(vCredit) AND vDuration gte 0 AND vCredit gte 0>
						<!--- all good --->
					<cfelse>
						<cfset vAllGood = 0>
						<cf_tl id="All durations and entitlements are mandatory and must be an integer greater or equal than 0." var="1">
						<cfoutput>
							<script language="JavaScript">
						       alert('#lt_text#');
						    </script> 
						</cfoutput>
						<cfbreak>
					</cfif>
					
				</cfif>
			</cfloop>
			
			<cfif vAllGood eq 1>
			
				<cfquery name="Insert" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Ref_LeaveTypeCredit
						(
							LeaveType,
							ContractType,
							DateEffective,
							CreditPeriod,
							CarryOverMaximum,
							CarryOverOnMonth,
							AccumulationPeriod,
							MaximumBalance,
							AdvanceInCredit,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
						VALUES 
						(
							'#Form.LeaveType#',
							'#Form.ContractType#', 
							#STR#,
							'#Form.CreditPeriod#',
							'#Form.CarryOverMaximum#',
							'#Form.CarryOverOnMonth#',
							'#Form.AccumulationPeriod#',
							'#Form.MaximumBalance#',
							'#Form.AdvanceInCredit#',
							'#SESSION.acc#',
							'#SESSION.last#',		  
							'#SESSION.first#'
						)
				</cfquery>

				<cfloop from="1" to="#Form.CountCreditRows#" index="Ent">
					<cfif isDefined("Form.ContractDuration_#Ent#")>
						<cfset vDuration = evaluate("Form.ContractDuration_#Ent#")>
						<cfset vDuration = replace(vDuration, "'", "", "ALL")>
						<cfset vDuration = replace(vDuration, ",", "", "ALL")>
						<cfset vCredit = evaluate("Form.Credit_#Ent#")>
						<cfset vCredit = replace(vCredit, "'", "", "ALL")>
						<cfset vCredit = replace(vCredit, ",", "", "ALL")>
						
						<cfquery name="Insert" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO Ref_LeaveTypeCreditEntitlement
						         (LeaveType,
								 ContractType,
								 DateEffective,
								 ContractDuration,
								 Credit,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
						  VALUES ('#Form.LeaveType#',
						          '#Form.ContractType#', 
								  #STR#,
								  '#vDuration#',
								  '#vCredit#',
								  '#SESSION.acc#',
						    	  '#SESSION.last#',		  
							  	  '#SESSION.first#')
						  </cfquery>
		
					</cfif>
				</cfloop>
				
				<script language="JavaScript">
			       parent.window.close()
				   parent.opener.location.reload()
			    </script> 
			</cfif>
		
		<cfelse>
		
			<cfquery name="Insert" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO Ref_LeaveTypeCredit
					(
						LeaveType,
						ContractType,
						DateEffective,
						CreditUoM,
						CreditPeriod,
						CarryOverMaximum,
						CarryOverOnMonth,
						AccumulationPeriod,
						MaximumBalance,
						Calculation,
						CreditFull,
						AdvanceInCredit,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
					VALUES 
					(
						'#Form.LeaveType#',
						'#Form.ContractType#', 
						#STR#,
						'#Form.CreditUoM#',
						'#Form.CreditPeriod#',
						'#Form.CarryOverMaximum#',
						'#Form.CarryOverOnMonth#',
						'#Form.AccumulationPeriod#',
						'#Form.MaximumBalance#',
						'#Form.Calculation#',
						'#Form.CreditFull#',
						'#Form.AdvanceInCredit#',
						'#SESSION.acc#',
						'#SESSION.last#',		  
						'#SESSION.first#'
					)
			</cfquery>
			
			<script>
				parent.window.close()
				parent.opener.location.reload()
			</script>  
		
		</cfif>


   </cfif>		  
           
<cfelseif ParameterExists(Form.Update)>
	
	<cfparam name="Form.Calculation" default="day">
	<cfparam name="Form.CreditFull"  default="0">
	
	<cfif Form.CreditPeriod eq "Contract">

		<cfset vAllGood = 1>
		<cfloop from="1" to="#Form.CountCreditRows#" index="Ent">
			<cfif isDefined("Form.ContractDuration_#Ent#")>
				<cfset vDuration = evaluate("Form.ContractDuration_#Ent#")>
				<cfset vDuration = replace(vDuration, "'", "", "ALL")>
				<cfset vDuration = replace(vDuration, ",", "", "ALL")>
				<cfset vCredit = evaluate("Form.Credit_#Ent#")>
				<cfset vCredit = replace(vCredit, "'", "", "ALL")>
				<cfset vCredit = replace(vCredit, ",", "", "ALL")>
				
				<cfif isNumeric(vDuration) AND isNumeric(vCredit) AND vDuration gte 0 AND vCredit gte 0>
					<!--- all good --->
				<cfelse>
					<cfset vAllGood = 0>
					<cf_tl id="All durations and entitlements are mandatory and must be an integer greater or equal than 0." var="1">
					<cfoutput>
						<script language="JavaScript">
					       alert('#lt_text#');
					    </script> 
					</cfoutput>
					<cfbreak>
				</cfif>
				
			</cfif>
		</cfloop>
		
		<cfif vAllGood eq 1>
		
			<cfquery name="Update" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE Ref_LeaveTypeCredit
					SET    LeaveType          = '#Form.LeaveType#',
					       ContractType       = '#Form.ContractType#',
						   DateEffective      = #STR#,
						   AdvanceInCredit    = '#Form.AdvanceInCredit#',
						   CreditPeriod       = '#Form.CreditPeriod#',
						   CarryOverMaximum   = '#Form.CarryOverMaximum#',
						   CarryOverOnMonth   = '#Form.CarryOverOnMonth#',
						   AccumulationPeriod = '#Form.AccumulationPeriod#',
						   MaximumBalance     = '#Form.MaximumBalance#'
					WHERE  CreditId           = #Form.CreditId#
			</cfquery>
			
			<cfquery name="clearEntitlements" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE
				FROM 	Ref_LeaveTypeCreditEntitlement
				WHERE   LeaveType          = '#Form.LeaveType#'
				AND 	ContractType       = '#Form.ContractType#'
				AND 	DateEffective      = #STR#
			</cfquery>
			
			<cfloop from="1" to="#Form.CountCreditRows#" index="Ent">
				<cfif isDefined("Form.ContractDuration_#Ent#")>
					<cfset vDuration = evaluate("Form.ContractDuration_#Ent#")>
					<cfset vDuration = replace(vDuration, "'", "", "ALL")>
					<cfset vDuration = replace(vDuration, ",", "", "ALL")>
					<cfset vCredit = evaluate("Form.Credit_#Ent#")>
					<cfset vCredit = replace(vCredit, "'", "", "ALL")>
					<cfset vCredit = replace(vCredit, ",", "", "ALL")>
					
					<cfquery name="Insert" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO Ref_LeaveTypeCreditEntitlement
					         (LeaveType,
							 ContractType,
							 DateEffective,
							 ContractDuration,
							 Credit,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
					  VALUES ('#Form.LeaveType#',
					          '#Form.ContractType#', 
							  #STR#,
							  '#vDuration#',
							  '#vCredit#',
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#')
					  </cfquery>
	
				</cfif>
			</cfloop>
			
			<script language="JavaScript">
		       parent.window.close()
			   parent.opener.location.reload()
		    </script> 
		</cfif>
		
	<cfelse>
	
		<cfquery name="Update" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Ref_LeaveTypeCredit
				SET    LeaveType          = '#Form.LeaveType#',
				       ContractType       = '#Form.ContractType#',
					   DateEffective      = #STR#,
					   AdvanceInCredit    = '#Form.AdvanceInCredit#',
					   CreditUoM          = '#Form.CreditUoM#',
					   CreditPeriod       = '#Form.CreditPeriod#',
					   CarryOverMaximum   = '#Form.CarryOverMaximum#',
					   CarryOverOnMonth   = '#Form.CarryOverOnMonth#',
					   AccumulationPeriod = '#Form.AccumulationPeriod#',
					   MaximumBalance     = '#Form.MaximumBalance#',
					   Calculation        = '#Form.Calculation#', 
					   CreditFull         = '#Form.CreditFull#'
				WHERE  CreditId           = #Form.CreditId#
		</cfquery>
		
		<script language="JavaScript">
	       parent.window.close()
		   parent.opener.location.reload()
	    </script> 
	
	</cfif>
	
<cfelseif ParameterExists(Form.Delete)> 
	
	<cfquery name="Delete" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_LeaveTypeCredit
		WHERE CreditId = #FORM.CreditId#
    </cfquery>
	
	<script language="JavaScript">
	     parent.window.close()
		 parent.opener.location.reload()
	</script>  

			
</cfif>	