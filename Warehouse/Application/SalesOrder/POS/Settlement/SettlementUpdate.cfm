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
<cfparam name="url.addressid"  default="00000000-0000-0000-0000-000000000000">

<cfquery name="Settlement" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT   *	
	FROM     Ref_Settlement 
	WHERE    Code = '#url.mode#'
</cfquery> 

<cfquery name="Warehouse" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT   *	
	FROM     Warehouse 
	WHERE    Warehouse = '#url.warehouse#'
</cfquery> 

<cfif url.scope neq "workflow" and url.scope neq "standalone">

	<cfquery name="Sale"
 	datasource="AppsMaterials" 
 	username="#SESSION.login#" 
 	password="#SESSION.dbpw#">
	 	SELECT  TOP 1 *
	 	FROM    vwCustomerRequest
		WHERE   RequestNo = '#url.RequestNo#'	 	
	</cfquery>	
	
<cfelse>	

	<cfquery name="qBatch" 
  	datasource="AppsMaterials" 
  	username="#SESSION.login#" 
  	password="#SESSION.dbpw#">	
		SELECT *
		FROM    Materials.dbo.WarehouseBatch B 
	 	WHERE   B.BatchId = '#URL.BatchId#'
	</cfquery> 	

	<cfquery name="Sale"
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT  *
		 FROM   ItemTransaction 
		 WHERE  TransactionBatchNo = '#qBatch.BatchNo#'	
	</cfquery> 	
	
</cfif>

<cfquery name="Mission" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT   *	
	FROM     Ref_SettlementMission 
	WHERE    Code = '#url.mode#'
	AND      Mission = '#warehouse.mission#'
</cfquery> 

<cfif Mission.GLAccount eq "">

	<cfif Sale.customerIdInvoice neq "">	

		<cfinvoke component  = "Service.Process.Materials.Customer"  
		   method            = "CustomerReceivables" 
		   mission           = "#warehouse.Mission#" 
		   customerid        = "#Sale.customerIdInvoice#"  
		   amountCurrency    = "#url.currency#"
		   amount            = "#FORM.line_amount_number#"
		   returnvariable    = "credit">	 
		   
		<cfset post = credit.result> 	   
			   
	<cfelse>
	
		<cfinvoke component  = "Service.Process.Materials.Customer"  
			method           = "CustomerReceivables" 
			mission          = "#warehouse.Mission#" 
			customerid       = "#Sale.customerId#"  
			amountCurrency   = "#url.currency#"
		    amount           = "#FORM.line_amount_number#"
			returnvariable   = "credit">	
			
		<cfset post = credit.result>   	
	
	</cfif>	
		
<cfelse>

	<cfset post = "1">	
	
</cfif>

<cfif post eq "1">
	
	<cfquery name="getSettle"
	 datasource="AppsTransaction" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT  SE.*, S.Mode
		 FROM    Settle#URL.Warehouse# SE INNER JOIN Materials.dbo.Ref_Settlement S ON SE.SettleCode = S.Code
		 WHERE   RequestNo  = '#url.RequestNo#'
		 AND     SettleCode = '#url.mode#'
	 	 	
		<cfswitch expression="#Settlement.mode#">
			<cfcase value="Gift">
				AND PromotionCardNo= '#FORM.Gift_number#'	
			</cfcase>
			<cfcase value="Credit">
				AND CreditCardNo = '#FORM.CC_number#'
				AND ApprovalCode = '#FORM.approval_number#'								
			</cfcase>
			<cfcase value="Check">
				AND BankName= '#FORM.bank_number#'
				AND	ApprovalReference = '#FORM.reference_number#'
				AND ApprovalCode = '#FORM.approval_number#'
			</cfcase>
		</cfswitch>				  
		 AND     SettleCurrency = '#url.currency#'
	</cfquery> 
	
	<cfif getSettle.recordcount eq 0>
	
		<cfquery name="qInsert"
		 datasource="AppsTransaction" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
			 INSERT INTO Settle#URL.Warehouse# (
			
				  CustomerId,				
				  AddressId,
				  RequestNo,
			   
			      SettleCode,
				  <cfswitch expression="#Settlement.mode#">
		  		  <cfcase value="Gift">
					PromotionCardNo,		
				  </cfcase>
				  <cfcase value="Credit">
					CreditCardNo,				
					ExpirationMonth,				
					ExpirationYear,				
					ApprovalCode,													
					ApprovalReference,																
				  </cfcase>
		  		  <cfcase value="Check">			  
				  	BankName,				
					ApprovalReference,																
					ApprovalCode,																					
				  </cfcase>			  
				  </cfswitch>
			      SettleCurrency,
			      SettleAmount )
	
			 VALUES (
			 
				'#url.customerid#',

				<cfif url.addressid neq "">
					'#url.addressid#',
				<cfelse>
					NULL,
				</cfif>	
				'#url.RequestNo#',
				
				'#url.mode#',
				
				<cfswitch expression="#Settlement.mode#">
				<cfcase value="Gift">
					'#FORM.Gift_number#',		
				</cfcase>
				<cfcase value="Credit">
					'#FORM.CC_number#'	,
					'#FORM.exp_month_number#',
					'#FORM.exp_year_number#',			
					'#FORM.approval_number#',						
					'#FORM.reference_number#',									
				</cfcase>
		  		  <cfcase value="Check">			  
				  	'#FORM.bank_number#',				
					'#FORM.reference_number#',						
					'#FORM.approval_number#',																	
				  </cfcase>			  
				</cfswitch>			
				'#url.currency#',
				'#FORM.line_amount_number#'			
			    )
				
		</cfquery> 
	
	<cfelse>
	
		<cfif getSettle.mode eq "Cash">
		
			<cfquery name="qUpdate"
			 datasource="AppsTransaction" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 UPDATE Settle#URL.Warehouse#
				 SET    SettleAmount    = '#getSettle.SettleAmount + FORM.line_amount_number#' 
				 WHERE  RequestNo       = '#url.RequestNo#'
				 AND    SettleCode      = '#url.mode#'
				 AND    SettleCurrency  = '#url.currency#'	 	 		
			</cfquery> 	
		
		<cfelse>
		
			<cf_tl id="Gift number"     var="mGift">
			<cf_tl id="CC number"       var="mCC1">
			<cf_tl id="Approval"        var="mCC2">
			<cf_tl id="Bank"            var="mBank1">
			<cf_tl id="Check number"    var="mBank2">
			<cf_tl id="is already settled" var="mEnd">
		
			<cfset vMessage = "">
			<cfswitch expression="#url.mode#">
				<cfcase value="Gift">
					<cfset vMessage = "#mGift#: " & FORM.Gift_number & "\n">
				</cfcase>
				<cfcase value="Credit">
					<cfset vMessage = "#mCC1#: " & FORM.CC_number  & "\n">
					<cfset vMessage = vMessage & "#mCC2#: " & FORM.approval_number  & "\n">
				</cfcase>
				<cfcase value="Check">
					<cfset vMessage = "#mBank1#: " & FORM.bank_number  & "\n">
					<cfset vMessage = vMessage & "#mBank2#: " & FORM.reference_number  & "\n">
				</cfcase>
			</cfswitch>
			<cfset vMessage = vMessage & "\n#mEnd#.">
		
			<cfoutput>
				<script>
					alert('#vMessage#');
				</script>
			</cfoutput>
			
		</cfif>
	
	</cfif>
	
	<script>
		resetSettlement();
	</script>
	
</cfif>
	
<table width="100%" align="center">
  
  <cfif post eq "0">	
  <tr><td align="center" class="labellarge" style="height:50px;color:red"><cf_tl id="Credit limit surpassed"></td></tr>
  </cfif>
  <tr><td style="padding-left:15px"><cfinclude template="SettlementLines.cfm"></td></tr>
  
</table>
	

 