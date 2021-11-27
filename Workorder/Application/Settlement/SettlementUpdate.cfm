
<cfparam name="url.close" default="0">
<cfparam name="transtime" default="00_00_00">
<cfparam name="url.transactiontime" default="00_00_00">

<cfset transtime = "#url.transactiontime#">
<cfset transtime = replace(transtime,"_",":","all")>
<cfset transtime = "#transtime#.000">

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     WorkOrderLine
	WHERE    WorkOrderLineid   = '#url.workorderlineId#' 	  
</cfquery>	

<cfquery name="Settlement" 
  datasource="AppsWorkorder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT   *	
	FROM     Ref_Settlement 
	WHERE    Code = '#form.settlement#'   
</cfquery> 

<cfquery name="getSettle"
 datasource="AppsWorkOrder" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT  SE.*, S.Mode
	 FROM    WorkOrderLineSettlement SE INNER JOIN Ref_Settlement S ON SE.SettleCode = S.Code
	 WHERE   WorkOrderId   = '#get.WorkOrderId#'
	 AND     WorkorderLine = '#get.WorkOrderLine#'
	 AND     OrgUnitOwner  = '#url.orgunitowner#'
	 AND     TransactionDate = '#url.transactiondate# #transtime#' 

	<cfswitch expression="#settlement.mode#">
		<cfcase value="Gift">
			AND   PromotionCardNo = '#FORM.Gift_number#'	
		</cfcase>
		<cfcase value="Credit">
			AND   CreditCardNo    = '#FORM.CC_number#'
			AND   ApprovalCode    = '#FORM.approval_number#'								
		</cfcase>
		<cfcase value="Check">
			AND   BankName        = '#FORM.bank_number#'
			AND	  ApprovalReference = '#FORM.reference_number#'
		</cfcase>
		<cfcase value="Cash">
			AND   SettleCode      = '#FORM.settlement#'			
		</cfcase>
	</cfswitch>			  
	 AND     SettleCurrency       = '#Form.currency#'
	 ORDER BY SE.Created DESC
</cfquery> 

<cfif getSettle.recordcount eq 0>

	<cfquery name="qInsert"
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
		 INSERT INTO WorkOrderLineSettlement (
		
			  WorkOrderId,
			  WorkOrderLine,
			  OrgUnitOwner,
			  TransactionDate,
		      SettleCode,	
			  SettlePersonNo,
			  SettleReference,
			  SettleCustomerName,		 
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
			'#get.WorkOrderId#',
			'#get.WorkOrderLine#',
			'#url.orgunitOwner#',	
			'#url.transactiondate# #transtime#',					
			'#Form.Settlement#',	
			'#Form.SettlePersonNo#',
			'#Form.SettleReference#',
			'#Form.SettleCustomerName#',		
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
			'#form.currency#',
			'#FORM.line_amount_number#'			
		    )
			
	</cfquery> 

<cfelse>

	<cfif Settlement.mode eq "Cash">
	
		<cfquery name="qUpdate"
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE WorkOrderLineSettlement
			 SET    SettleAmount    = '#getSettle.SettleAmount + FORM.line_amount_number#' 
			 WHERE  WorkOrderId     = '#get.WorkOrderId#'
			 AND    WorkorderLine   = '#get.WorkOrderLine#'
			 AND    OrgUnitOwner    = '#url.orgunitowner#'
			 AND    TransactionDate = '#url.TransactionDate# #transtime#'
			 AND    SettleCode      = '#form.settlement#'
			 AND    SettleCurrency  = '#form.currency#'			 
		</cfquery> 	
	
	<cfelse>
	
		<cf_tl id="Gift number"        var="mGift">
		<cf_tl id="CC number"          var="mCC1">
		<cf_tl id="Approval"           var="mCC2">
		<cf_tl id="Bank"               var="mBank1">
		<cf_tl id="Check number"       var="mBank2">
		<cf_tl id="is already settled" var="mEnd">
	
		<cfset vMessage = "">
		<cfswitch expression="#Settlement.mode#">
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

<!--- was throwing an error 
<script>
	resetSettlement();
</script>
--->

<cfset url.close = "1">
<cfinclude template="SettlementLines.cfm">

 