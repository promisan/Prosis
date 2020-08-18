
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
	  
 <table width="100%">
 
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
	 
	 <tr style="height:20px;" class="labelmedium">
	 
	 <cfoutput query="Total">
	  	
		  <td style="padding-left:9px">#Currency#</td>
		  <td style="width:60px"><cfif get.currency neq APPLICATION.BaseCurrency>#numberFormat(Total.Total/Total.TotalBase,"._____")#</cfif></td>
		  <td align="right" style="padding-right:5px;color:008000">#numberFormat(Total.Total,",.__")#</td>	 
			  	  
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
		 			
				  <td style="padding-left:9px">#Currency#</td>	
				  <td style="padding-left:3px;width:60px">#numberformat(exc,'._____')#</td>	    			  
				  <td align="right" style="padding-left:3px;padding-right:5px">#numberFormat(Total.Total/exc,",.__")#</td>
		  
		 </cfoutput>
	 	 
		 <cfoutput>		
		 
		 </tr> 
		 
		  <cfif get.currency neq APPLICATION.BaseCurrency>
			  <tr style="height:25px;border-top:1px solid silver" class="labelmedium">
				  <td style="padding-left:9px">#APPLICATION.BaseCurrency#</td>				  
				  <td align="right" colspan="#cur.recordcount*3+2#" style="font-size:16px;padding-right:5px;color:6688aa">#numberFormat(Total.TotalBase,",.__")#</td>
			  </tr>
		  </cfif>
		  
		 </cfoutput>
		 
	   <cfelse>
	   
	   <cfif get.currency neq APPLICATION.BaseCurrency>
			  <tr style="height:25px;border-top:1px solid silver" class="labelmedium">
				  <td style="padding-left:9px">#APPLICATION.BaseCurrency#</td>				  
				  <td align="right" colspan="2" style="font-size:16px;padding-right:5px;color:6688aa">#numberFormat(Total.TotalBase,",.__")#</td>
			  </tr>
		  </cfif>
	   	 
	  
	   </cfif>
  
 </table>
 
 <cfelse>
 
	 <cfinclude template="POViewClassHeader.cfm">
 
 </cfif>	