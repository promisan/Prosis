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
<cfparam name="WorkFlowEnforce" default="0">

<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT C.*, R.OrgUnit, M.PaymentFund as Fund
	FROM   Claim C, ClaimRequest R, Ref_DutyStation M
	WHERE  ClaimId = '#URL.ClaimId#'
	AND    C.ClaimRequestId = R.ClaimRequestId 
	AND    M.Mission = R.Mission
</cfquery>

<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Person
	WHERE PersonNo = '#Claim.PersonNo#'
</cfquery>

<cfif Claim.DocumentNo eq "0">

	<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
	
		<cfquery name="Parameter" 
	    datasource="appsTravelClaim" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT *
		    FROM Parameter
		</cfquery>
			
		<cfset No = Parameter.ClaimNo+1>
		<cfif No lt 10000>
		     <cfset No = 10000+No>
		</cfif>
			
		<cfquery name="Update" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Parameter
			SET ClaimNo = '#No#'
		</cfquery>
	
	</cflock>

<cfelse>
	<cfset No = "#Claim.DocumentNo#">
</cfif>

<cfparam name="Form.Agreement" default="0">
<cfparam name="Form.PaymentCode" default="01">
<cfparam name="Form.WorkFlowEnforce" default="0">

<cfif Form.Agreement eq "1">
  <CF_DateConvert Value="#Form.DateSubmission#">
  <cfset DTE = #dateValue#>
</cfif>	  

<!--- save header --->

<cfparam name="Form.PaymentMode" default="">

<cfif form.paymentMode eq "">
	<cf_message message="Reimbursement mode could not be determined" return="back">
		<cfabort>
</cfif>

<cfset curr  =  Evaluate("Form.PaymentCurrency_" & "#Form.PaymentMode#")>
		  	
<cfquery name="Update" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Claim
	SET PaymentMode     = '#Form.PaymentMode#',
	    DocumentNo      = '#No#',
		PaymentCurrency = '#Curr#',
		PaymentFund     = '#Claim.Fund#', 
		<cfif Form.WorkFlowEnforce neq "0">
		WorkFlowEnforce = '#Form.WorkFlowEnforce#',
		</cfif>
		<cfif #Form.Agreement# eq "1">
			ClaimDate   = #DTE#,
	    </cfif>
		ActionStatus    = '#Status#'  
		
    WHERE ClaimId = '#URL.ClaimId#'
</cfquery>

<cfquery name="Clear" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE ClaimReimbursement
	WHERE ClaimId = '#URL.ClaimId#'
</cfquery>

<!--- save payment --->

<cfquery name="Cluster" 
		 datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT *
		 FROM Ref_PaymentModeCluster
		 WHERE PaymentCode ='#Form.PaymentMode#'
		 ORDER By ListingOrder
</cfquery>

<cfloop query="Cluster">
					
		<cfquery name="Fields" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
		    FROM Ref_ClusterField
			WHERE ClusterCode ='#ClusterCode#'
			ORDER BY ListingOrder
		</cfquery>
			  
	  <cfloop query="fields">
	  	
		   <cfset pay  =  Evaluate("Form.f" & "#Form.PaymentMode#" & "_" & "#ClusterCode#" & "_" & "#fieldName#")>
		  						
    	   <cfquery name="InsertLine" 
		 	  datasource="appsTravelClaim" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  INSERT INTO  ClaimReimbursement
					      (ClaimId, 
						   ClusterCode,
						   FieldName,
						   FieldValue,
						   OfficerUserId,
						   OfficerLastName,
						   OfficerFirstName)
			  VALUES ('#URL.ClaimId#',
			          '#ClusterCode#',
					  '#FieldName#',
					  '#pay#',
					  '#SESSION.acc#', 
					  '#SESSION.last#',
					  '#SESSION.first#')  
			  </cfquery>	
			 			  			 		  	  		  
	  </cfloop>
	  
</cfloop>	 

<!--- check if other currency is selected from bankaccount --->

<cfquery name="Currency" 
  datasource="appsTravelClaim" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT  PersonAccount.AccountCurrency
	FROM    ClaimReimbursement INNER JOIN
	        PersonAccount ON ClaimReimbursement.FieldValue = PersonAccount.AccountId
	WHERE   ClaimId = '#URL.ClaimId#'
	AND     FieldName = 'Account'
</cfquery>

<cfif Currency.recordcount eq "1">
	
	<cfquery name="Update" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Claim
		SET PaymentCurrency = '#Currency.AccountCurrency#'
	    WHERE ClaimId = '#URL.ClaimId#'
	</cfquery>

</cfif>	 