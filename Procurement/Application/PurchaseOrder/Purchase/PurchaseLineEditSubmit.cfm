
<cfparam name="Form.QuoteZero"  default="0">
<cfparam name="Form.OrderPrice" default="0">

<cfif Len(Form.OrderItem) gt 200>

	<script>
		alert('Maximum length Description allowed is 200');
	</script>
	<cfabort>
</cfif>

<cfquery name="Check" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
      SELECT   P.PurchaseNo, P.Mission, R.InvoiceWorkflow, PL.OrderPrice
      FROM     PurchaseLine PL INNER JOIN
               Purchase P ON PL.PurchaseNo = P.PurchaseNo INNER JOIN
               Ref_OrderType R ON P.OrderType = R.Code
      WHERE    PL.RequisitionNo = '#URL.ID#'
</cfquery>

<cfquery name="Parameter" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
      SELECT   *
      FROM     Ref_ParameterMission
	  WHERE    Mission = '#Check.Mission#'
</cfquery>

<cfif Parameter.InvoiceRequisition eq "1">
	
	<!--- define the amount matched for this line only --->
	
	<cfquery name="Matched" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	     SELECT   SUM(AmountMatched) AS amount
		 FROM     InvoicePurchase IP, 
		          Invoice I
		 WHERE    I.InvoiceId      = IP.InvoiceId
		 AND      I.ActionStatus  != '9'
	  	 AND      IP.RequisitionNo = '#URL.ID#'
	</cfquery>
	
	<cfset inv = Matched.Amount>
		
	<cfif Form.TaxExemption eq "1">
		  <cfset poamt = Form.CostPrice>
	<cfelse>
		  <cfset poamt = Form.CostPrice + Form.TaxPrice>
	</cfif>	

<cfelse>

	<!--- define the amount matched for the complete PO --->
	
	<cfquery name="Matched" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	     SELECT   I.DocumentCurrency, SUM(I.DocumentAmount) AS amount
		 FROM     InvoicePurchase IP, 
		          Invoice I
		 WHERE    I.InvoiceId = IP.InvoiceId
		 AND      I.ActionStatus != '9'
		 AND      IP.PurchaseNo = '#Check.PurchaseNo#' 
		 GROUP BY DocumentCurrency	  	 
	</cfquery>
	
	<cfset inv = 0>
	
	<cfloop query="Matched">
	
			<cf_exchangeRate 
				DataSource="AppsPurchase"
				CurrencyFrom = "#Documentcurrency#" 
				CurrencyTo   = "#APPLICATION.BaseCurrency#"
				EffectiveDate = "#dateformat(now(),CLIENT.DateFormatShow)#">
			
			<cfif Exc eq "0" or Exc eq "">
				<cfset exc = 1>
			</cfif>								
		
			<cfset inv = Matched.Amount/exc+inv>
	
	</cfloop>
	
	<!--- this line --->
	
	<cfif Form.TaxExemption eq "1">
		  <cfset poamt = Form.CostPriceB>
	<cfelse>
		  <cfset poamt = Form.CostPriceB + Form.TaxPriceB>
	</cfif>	
	
	<!--- other lines --->
		
	<cfquery name="Lines" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	     SELECT   SUM(OrderAmountBase) AS amount
		 FROM     PurchaseLine 		
		 WHERE    PurchaseNo     = '#Check.PurchaseNo#'
		 AND      RequisitionNo <> '#URL.ID#' 
		 AND      ActionStatus  <> '9' 	  	
	</cfquery>
	
	<cfif Lines.amount neq "">
		<cfset poamt = poamt+lines.amount>
	</cfif>	
	
</cfif>

<cfif matched.recordcount neq "0" 
     and poamt lt inv 
	 and Form.OrderPrice lt Check.OrderPrice>

	   <script>
		   alert("The revised amount will result into a Purchase Order which amount is lower than the already invoiced amounts. /n/nThis operation not allowed!")			
	   </script>

<cfelse>

	<cfquery name="Check" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Purchase 
	  WHERE  PurchaseNo IN (SELECT PurchaseNo FROM PurchaseLine WHERE RequisitionNo = '#URL.ID#')
	</cfquery>
	
	<!--- check if the amounts are changed --->
	
	<cfquery name="Log" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
      SELECT   *
      FROM     PurchaseLineAmendment 
      WHERE    RequisitionNo = '#URL.ID#'	  
	</cfquery>
	
	<cfquery name="Prior" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
      SELECT   *
      FROM     PurchaseLine 
      WHERE    RequisitionNo = '#URL.ID#'
	</cfquery>
	
	<cftransaction>
	<!--- record the transaction if no initial value existed --->
	
	<cfif Log.recordcount eq "0">
	
		  <cfquery name="Insert" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			 INSERT INTO PurchaseLineAmendment
				 (RequisitionNo,Reference,Memo,AmountCost, AmountTax,OfficerUserId,OfficerLastName,OfficerFirstName,Created)
			 VALUES
				 ('#url.id#','0','Initial Entry','#Prior.OrderAmountCost#','#Prior.OrderAmountTax#','#Prior.OfficerUserId#','#Prior.OfficerLastName#','#Prior.OfficerFirstName#','#Prior.Created#')		 
		  </cfquery>			 
			
	</cfif>
				
	<cfquery name="Update" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  UPDATE PurchaseLine
	  SET    OrderItemNo           = '#Form.OrderItemNo#',
			 OrderItem             = '#Form.OrderItem#',
			 ListingOrder          = '#Form.ListingOrder#',
			 LineReference         = '#Form.LineReference#',
			 OrderQuantity         = '#Form.OrderQuantity#', 
			 OrderUoM              = '#Form.OrderUoM#', 
			 <cfif isvalid("numeric",Form.OrderUoMHeight)>
			 OrderUoMHeight        = '#Form.OrderUoMHeight#',
			 </cfif>
			 <cfif isvalid("numeric",Form.OrderUoMWidth)>
			 OrderUoMWidth         = '#Form.OrderUoMWidth#',
			 </cfif>
			 <cfif isvalid("numeric",Form.OrderUoMLength)>
			 OrderUoMLength        = '#Form.OrderUoMLength#',
			 </cfif>
			 <cfif isvalid("numeric",Form.OrderUoMVolume)>
			 OrderUoMVolume        = '#Form.OrderUoMVolume#',
			 </cfif>
			 OrderMultiplier       = '#Form.OrderMultiplier#',
			 Currency              = '#Form.Currency#',
			 <cfif Form.QuoteZero eq "1" and Form.CostPriceB eq "0">
			 OrderZero             = 1,
			 <cfelse>
			 OrderZero             = 0,
			 </cfif>
			 TaxExemption          = '#Form.TaxExemption#',
			 OrderPrice            = '#Form.OrderPrice#',
			 OrderDiscount         = '#Form.OrderDiscount/100#',
			 OrderTax              = '#Form.OrderTax/100#', 
			 TaxIncluded           = '#Form.TaxIncluded#',
			 OrderAmountCost       = '#Form.CostPrice#',
			 <cfif Form.TaxExemption eq "1">
			  OrderAmountTax    = 0,	
			 <cfelse>
			  OrderAmountTax    = '#Form.TaxPrice#',
			 </cfif>				  
			 ExchangeRate          = '#Form.ExchangeRate#',
			 OrderAmountBaseCost   = '#Form.CostPriceB#', 
			 <cfif Form.TaxExemption eq "1">
			     OrderAmountBaseTax        = 0,	
				 OrderAmountBaseObligated  = '#Form.CostPriceB#',  
			 <cfelse>
			     OrderAmountBaseTax        = '#Form.TaxPriceB#',
				 OrderAmountBaseObligated  = '#Form.CostPriceB+Form.TaxPriceB#', 
			 </cfif>			 
			 <cfif check.actionStatus eq  "3">
			 AmendmentNo = AmendmentNo+1,
			 </cfif>	
			 Remarks               = '#Form.Remarks#'
	  WHERE RequisitionNo = '#URL.ID#'
	</cfquery>
	
	<cfquery name="New" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
      SELECT   *
      FROM     PurchaseLine 
      WHERE    RequisitionNo = '#URL.ID#'
	</cfquery>
	
	<cfset log = 0>
	
	<cfif Prior.OrderAmountCost neq New.OrderAmountCost or
		  Prior.OrderAmountTax neq New.OrderAmountTax>
		  
		  <cfset cost = New.OrderAmountCost - Prior.OrderAmountCost>
		  <cfset tax  = New.OrderAmountTax - Prior.OrderAmountTax>
		  
		  <cfset log = 1>
		  
		  <cfquery name="Insert" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			 INSERT INTO PurchaseLineAmendment
			 (RequisitionNo,AmountCost, AmountTax,OfficerUserId,OfficerLastName,OfficerFirstName)
			 VALUES
			 ('#url.id#','#cost#','#tax#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')		 
		  </cfquery>	  
		  
    </cfif>
		
	<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Ref_ParameterMission
		WHERE Mission = '#Check.Mission#' 
	</cfquery>
	
	<cfif Parameter.EnablePurchaseClass eq "1">
	
		<cfquery name="def" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_PurchaseClass 
			WHERE   SetAsDefault = 1
		</cfquery>
		
		<cfquery name="Class" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  sum(AmountPurchase) as Total
			FROM    PurchaseLineClass 
			WHERE   RequisitionNo = '#URL.ID#'
			AND     PurchaseClass != '#def.Code#'
		</cfquery>
		
		<cfquery name="Line" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  OrderAmount as Amount
			FROM    PurchaseLine 
			WHERE   RequisitionNo = '#URL.ID#'
		</cfquery>
			
		<cfif Class.total eq "">
			<cfset cla = 0>
		<cfelse>
			<cfset cla = Class.total>
		</cfif>
		
		<cfif abs(Line.Amount - cla) gte 0.01 and def.recordcount eq "1">
		
			<cftry>
			
				<cfquery name="PurchaseClass" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO PurchaseLineClass 
					(RequisitionNo, 
					 PurchaseClass, 
					 AmountPurchase, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)
					VALUES
					('#URL.ID#',
					 '#def.Code#',
					 '#Line.Amount - cla#',
					 '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#')
				</cfquery>
						
				<cfcatch>
					
					<cfquery name="PurchaseClass" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE PurchaseLineClass 
							SET    AmountPurchase = '#Line.Amount - cla#'
							WHERE  RequisitionNo = '#URL.ID#'
							AND    PurchaseClass = '#def.Code#'
						</cfquery>
					
				</cfcatch>
			
			</cftry>	
				
		</cfif>
	
	</cfif>
					
	<cfif check.actionStatus eq "3" and form.CostPriceB neq form.CostPriceB_old>
	
		<cfquery name="Update" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Purchase 
		  SET    ActionStatus = '2'
		  WHERE  PurchaseNo IN (SELECT PurchaseNo 
		                        FROM   PurchaseLine 
								WHERE  RequisitionNo = '#URL.ID#')
		</cfquery>
		
		<!--- reset the workflow --->
		
		<cfquery name="ResetWorkflow" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Organization.dbo.OrganizationObject
		  SET    Operational = '0'
		  WHERE  ObjectKeyValue1 = (SELECT PurchaseNo 
		                            FROM PurchaseLine 
								    WHERE RequisitionNo = '#URL.ID#')
		  AND    Operational = '1'							
		</cfquery>		
		
		<script>
		    alert("Attention:\n\nYou must issue and clear this purchase Order again !")		
			parent.parent.history.go()	
		</script>	
		
	<cfelse>			
	
		<cfif log eq "0">
		
			<script>
			    parent.parent.ColdFusion.Window.hide('myline')
				try {
					parent.parent.document.getElementById('refreshpurchasline').click()	
				} catch(e) { parent.parent.history.go() }			
			</script>
			
		<cfelse>
		
			<script>
			    parent.document.getElementById('menu2').click()
				try {
					parent.parent.document.getElementById('refreshpurchasline').click()	
				} catch(e) { parent.parent.history.go() }			
			</script>
			
		</cfif>	
	
	</cfif>
	
	</cftransaction>

</cfif>
