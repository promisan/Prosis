
<cfquery name="get" 
   datasource="AppsMaterials"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   Request
	   WHERE  RequestId = '#URL.Id#'
</cfquery>	   

<cfquery name="qUpdate" 
   datasource="AppsMaterials"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   UPDATE RequestTask
	   SET    RecordStatus        = '3',	         
	          RecordStatusDate    = getDate(), 
			  RecordStatusOfficer = '#SESSION.acc#',
			  DeliveryStatus      = '3'
	   WHERE  RequestId           = '#URL.Id#'
	   AND    TaskSerialNo        = '#URL.tn#'
</cfquery>	  

<!--- ---------------------------------- --->
<!--- set the status of the request line --->
<!--- ---------------------------------- --->
		
<cf_setRequestStatus requestid = "#url.Id#">

<cfoutput>

<script>
	document.getElementById('r'+'#URL.Id#'+'_'+'#URL.tn#').className = 'highLight4';
	
	try {	
	if (opener.document.getElementById('tasktreerefresh')) {				
        opener.ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/View/StockOrderTreeTaskRefresh.cfm?mission=#get.mission#&warehouse=#get.warehouse#','tasktreerefresh')
    }	
	} catch(e) {}
	
	try {	
	if (document.getElementById('tasktreerefresh')) {				
        ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/View/StockOrderTreeTaskRefresh.cfm?mission=#get.mission#&warehouse=#get.warehouse#','tasktreerefresh')
    }	
	} catch(e) {}
	
</script>	

</cfoutput>		   	   