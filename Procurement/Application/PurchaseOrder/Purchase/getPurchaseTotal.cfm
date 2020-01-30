
 <cfquery name="get" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   *
     FROM     Purchase
	 WHERE    PurchaseNo = '#URL.ID1#'
 </cfquery>
 
 <cfquery name="Parameter" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   *
     FROM     Ref_ParameterMission
	 WHERE    Mission = (SELECT Mission FROM Purchase WHERE PurchaseNo = '#URL.ID1#')
 </cfquery>

 <cfif Parameter.EnablePurchaseClass eq "0">
	  
 <table width="99%">
 
 	 <cfquery name="Total" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT   Currency, 
		          SUM(OrderAmount) AS Total, 
				  SUM(OrderAmountBase) AS TotalBase
	     FROM     PurchaseLine
	     WHERE    PurchaseNo = '#URL.ID1#' 
		 GROUP BY Currency           
	 </cfquery>
	 
	 <cfoutput query="Total">
	  	
		  <tr style="height:20px" class="line labelmedium"><td>#Currency#</td>
		  <td>#numberFormat(Total.Total/Total.TotalBase,".____")#</td>
		  <td align="right" style="padding-right:5px;color:008000">#numberFormat(Total.Total,",.__")#</td>		  
		  </tr>		  
			  	  
	 </cfoutput>
	 
	 <cfif get.OrderDate neq "">
	 
		 <cfquery name="Cur" 
		     datasource="AppsLedger" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT   *
		     FROM     Currency
			 WHERE    EnableProcurement = 1
			 AND      Currency NOT IN (#quotedvalueList(Total.Currency)#)
			 AND      Currency != '#APPLICATION.BaseCurrency#'	 
		 </cfquery>
	 
		 <cfoutput query="Cur">
		 
		 	<cf_exchangeRate 
		        CurrencyFrom = "#Total.Currency#" 
		        CurrencyTo   = "#Currency#"
				EffectiveDate = "#dateformat(get.OrderDate,CLIENT.DateFormatShow)#">	 	 	
		 
			 <tr style="height:20px" class="line labelmedium">
			      <td>#Currency#</td>
				  <td>#numberFormat(exc,".____")#</td>
				  <td align="right" style="padding-right:5px">#numberFormat(Total.Total/exc,",.__")#</td>
			  </tr>
		  
		 </cfoutput>
	 	 
		 <cfoutput>		 
		 
		  <cfif get.currency neq APPLICATION.BaseCurrency>
			  <tr style="height:20px" class="labelmedium">
				  <td>#APPLICATION.BaseCurrency#</td>
				  <td></td>
				  <td align="right" <td align="right" style="padding-right:5px;color:6688aa">#numberFormat(Total.TotalBase,",.__")#</td>
			  </tr>
		  </cfif>
		  
		 </cfoutput>
	  
	   </cfif>
  
 </table>
 
 <cfelse>
 
	 <cfinclude template="POViewClassHeader.cfm">
 
 </cfif>	