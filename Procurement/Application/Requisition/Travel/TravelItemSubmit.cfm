<cfset Form.DateEffective  = Form.CostPeriod_Start>
<cfset Form.DateExpiration = Form.CostPeriod_End>

<cfquery name="Check" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   RequisitionLine	   
	   WHERE  RequisitionNo      = '#URL.ID#'			  	
</cfquery>

<cfquery name="Check" 
	  datasource="AppsTravelClaim" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   Ref_ClaimCategory	   
	   WHERE  Code   = '#form.ClaimCategory#'			  	
</cfquery>

<cfif Check.recordcount eq "0">

		<script>
		    alert('Requisition no longer exists. Please create a new requisition.')						
		</script>	
		 
		<cfabort>

</cfif>

<cfparam name="#Form.Quantity#" default="1">

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
	
		<cfset qty         = replace("#form.quantity#",",","")>
	
	</cfif>
		
	<cfif not LSIsNumeric(rate)>
	
		<script>
		    alert('Incorrect rate #rate#')						
		</script>	 
		
		<cfabort>
	
	</cfif>
			
	<cfif Len(Form.Memo) gt 400>
	
	   <cf_alert message = "You entered a memo which exceeded the allowed size of 450 characters."
	       return = "back">
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
			   UPDATE RequisitionLineTravel 
			   SET    ClaimCategory      = '#Form.ClaimCategory#',
			          DateEffective      = #Eff#,
					  DateExpiration     = #Exp#,
					  LocationCode       = '#Form.LocationCode#',	
					  Currency           = '#Form.Currency#',
					  CurrencyRate       = '#Form.CurrencyRate#',		          
					  UoMRate            = '#Rate#',
				      Quantity           = '#qty#',
					  UOMPercentage      = '#Form.UoMPercentage#',
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
			     INSERT INTO RequisitionLineTravel
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
	     DELETE FROM RequisitionLineTravelPointer
		  WHERE       RequisitionNo      = '#URL.ID#'
			   AND    DetailId           = '#URL.ID2#'		
	    
	</cfquery>
	
	</cfif>
	
	<cfquery name="Item" 
		datasource="AppsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Indicator 
		WHERE  Category   = 'DSA' 
		AND    Operational = 1
	</cfquery>
	
	<cfloop index="itm" list="#valueList(item.Code)#" delimiters=",">
	
		<cfparam name="Form.IndicatorCode_#itm#" default="">
		<cfset ind = evaluate("form.IndicatorCode_#itm#")>
		
			<cfif ind eq "1">
	
			<cfquery name="Insert" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO RequisitionLineTravelPointer
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
		     SELECT  SUM(Amount) AS Total
			 FROM    RequisitionLineTravel
			 WHERE   RequisitionNo      = '#URL.ID#'		 
	</cfquery>
	
	<cfquery name="Update" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   UPDATE RequisitionLine 
		   SET    RequestQuantity    = '1',
		          RequestCostPrice   = '#Total.Total#',
		          RequestAmountBase  = '#Total.Total#'  
		   WHERE  RequisitionNo      = '#URL.ID#'		  
	</cfquery>
	
	<script>
	   
	    _cf_loadingtexthtml='';	 		
		try { document.getElementById("requestquantity").value = "1"	
		      document.getElementById("requestcostprice").value = "#Total.Total#"	
		} catch(e) {}		
		base2('#url.id#','#Total.Total#','1')			
		tagging()		
		ptoken.navigate('../Travel/TravelItem.cfm?ID=#URL.ID#','iservice')
		ProsisUI.closeWindow('dialogtravel')
		
	</script>		

</cfoutput>
 	

  
