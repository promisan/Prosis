
<cfquery name="Delete" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM UserQuery.dbo.#SESSION.acc#ExecutionRequest_#client.sessionNo#
		 WHERE SerialNo = '#URL.ID2#'
</cfquery>

<cfquery name="Total" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT  SUM(DetailAmount) AS Total
		 FROM    UserQuery.dbo.#SESSION.acc#ExecutionRequest_#client.sessionNo#		 	 
</cfquery>

<cfoutput>

<script>	
	document.getElementById("RequestAmount").value  = "#numberformat(Total.Total,'__,__.__')#"	
	ColdFusion.navigate('Details/DetailItem.cfm?ID2=new','iservice')
</script>		

</cfoutput>