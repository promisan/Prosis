<cfset Form.DateEffective  = Form.CostPeriod_Start>
<cfset Form.DateExpiration = Form.CostPeriod_End>

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  PurchaseLine
	WHERE RequisitionNo = '#URL.ID#'
</cfquery>


<cfquery name="Check" 
	  datasource="AppsTravelClaim" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   Ref_ClaimCategory	   
	   WHERE  Code   = '#form.ClaimCategory#'			  	
</cfquery>

<cfset url.currency = Line.Currency>

<cfoutput>
		
	<cfset rate        = replace("#form.rate#",",","")>
	
	<cfif check.RequestDays eq "1">
	
		<cfset qty         = replace("#form.quantity#",",","")>
	
		<cfif not LSIsNumeric(qty)>
	
			<script>
			    alert('Incorrect quantity #qty#')					
			</script>	 
		
			<cfabort>
	
		</cfif>
	
	<cfelse>
	
		<cfset qty = 1>
	
	</cfif>
	
	
	<cfif not LSIsNumeric(rate)>
	
		<script>
		    alert('Incorrect rate #rate#')						
		</script>	 
		
		<cfabort>
	
	</cfif>
			
	<cfif Form.DateEffective neq ''>
	    <CF_DateConvert Value="#Form.DateEffective#">
		<cfset EFF = dateValue>
	<cfelse>
	    <cfset EFF = 'NULL'>
	</cfif>	
	
	<cfif Form.DateExpiration neq ''>
	    <CF_DateConvert Value="#Form.DateExpiration#">
		<cfset EXP = dateValue>
	<cfelse>
	    <cfset EXP = 'NULL'>
	</cfif>	
	
	<cfif URL.ID2 neq "new">
	
		 <cfquery name="Update" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			   UPDATE PurchaseLineTravel 
			   SET    ClaimCategory      = '#Form.ClaimCategory#',
			          DateEffective      = #Eff#,
					  DateExpiration     = #Exp#,
					  LocationCode       = '#Form.LocationCode#',			          
					  UoMRate            = '#Rate#',
				      Quantity           = '#qty#',
					  Memo               = '#Form.Memo#'		   
			   WHERE  RequisitionNo      = '#URL.ID#'
			   AND    DetailId           = '#URL.ID2#'		
	   	</cfquery>
		
		<cfset rowid = URL.ID2>	
				
	<cfelse>
	
			<cf_assignid>
						
			<cfquery name="Insert" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO PurchaseLineTravel				 
				        (RequisitionNo,
						 DetailId,
						 ClaimCategory ,
						 DateEffective,
						 DateExpiration,
						 LocationCode, 
						 Currency,
						 CurrencyRate,
						 UOMPercentage,
						 UoMRate,
						 Quantity,
						 Memo,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName )
			      VALUES ('#url.id#',
				          '#rowguid#',
				          '#Form.ClaimCategory#',
				          #eff#,
						  #exp#,
						  '#Form.LocationCode#',
						  '#Form.Currency#',
						  '#Form.CurrencyRate#',
						  '#Form.UoMPercentage#',
						  '#Rate#',
						  '#qty#',
						  '#Form.Memo#',
						  '#session.acc#',
						  '#session.last#',
						  '#session.first#')				 
			    
			</cfquery>
			
			<cfset rowid = rowguid>
		
					
	</cfif>
	
	<cfif url.id2 neq "new">
	
	<cfquery name="Clean" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM PurchaseLineTravelPointer
		  WHERE       RequisitionNo      = '#URL.ID#'
			   AND    DetailId           = '#URL.ID2#'		
	    
	</cfquery>
	
	</cfif>
	
	<cfloop index="itm" list="T03,T04" delimiters=",">
	
		<cfparam name="Form.IndicatorCode_#itm#" default="">
		<cfset ind = evaluate("form.IndicatorCode_#itm#")>
		
		<cfif ind eq "1">
	
			<cfquery name="Insert" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO PurchaseLineTravelPointer
						         (RequisitionNo,
								 DetailId,
								 IndicatorCode)
				      VALUES ('#url.id#',
					          '#rowid#',
					          '#itm#')
			</cfquery>
			
		</cfif>	
		
	</cfloop>
	
	<cfquery name="Total" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT  SUM(Quantity * UoMRate) AS Total
			 FROM    PurchaseLineTravel
			 WHERE   RequisitionNo      = '#URL.ID#'		 
	</cfquery>
	
	<cfquery name="Exc"
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT TOP 1 * FROM CurrencyExchange
		    WHERE    Currency = '#url.currency#'
			AND      EffectiveDate <= getDate()
			ORDER BY EffectiveDate DESC
		</cfquery>	 
		
		<cfset pr = numberformat(Total.Total/Exc.ExchangeRate,".__")>
		
		<cfquery name="Update" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE PurchaseLine
		  SET
			
			 OrderQuantity         = '1', 
			 OrderUoM              = 'Package', 
			 OrderMultiplier       = '1',
			 <!---
			 Currency              = '#url.Currency#',
			 --->
			 OrderZero             = 0,			
			 OrderPrice            = '#Total.Total#',
			 OrderDiscount         = '0',
			 OrderTax              = '0', 
			 TaxIncluded           = '1',
			 OrderAmountCost       = '#Total.Total#',
			 OrderAmountTax        = '0', 
			 ExchangeRate          = '#Exc.ExchangeRate#',
			 OrderAmountBaseCost   = '#pr#', 
			 OrderAmountBaseTax    = '0'
		  WHERE RequisitionNo = '#URL.ID#'
		</cfquery>
		
		
	<script>	    		
		ColdFusion.navigate('../Travel/TravelItem.cfm?ID=#URL.ID#&mode=edit','iservice')
		ProsisUI.closeWindow('dialogtravel')		
		    try {
				parent.parent.document.getElementById('refreshpurchasline').click()	
			} catch(e) { parent.parent.history.go() }			
		</script>
		
	</script>		

</cfoutput>
 	

  
