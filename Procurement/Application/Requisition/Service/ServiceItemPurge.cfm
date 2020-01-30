
<cfquery name="Delete" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM RequisitionLineService 
		 WHERE RequisitionNo = '#URL.ID#'
		 AND Serviceid = '#URL.ID2#'
</cfquery>


<cfquery name="Total" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT  SUM(ServiceQuantity * Quantity * UoMRate) AS Total
		 FROM    RequisitionLineService
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

<cfoutput>

<script>	
	try { document.getElementById("requestquantity").value = "1"	
	      document.getElementById("requestcostprice").value = "#Total.Total#"	
	} catch(e) {}
	base2('#url.id#','#Total.Total#','1')	
	tagging()
	ColdFusion.navigate('../Service/ServiceItem.cfm?ID=#URL.ID#&ID2=new','iservice') 
</script>		

</cfoutput>