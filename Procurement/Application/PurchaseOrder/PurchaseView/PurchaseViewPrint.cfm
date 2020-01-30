
 <cfquery name="PO" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Purchase 
		WHERE  PurchaseNo ='#URL.Id1#'
		AND    PurchaseNo IN (SELECT PurchaseNo FROM PurchaseLine)
</cfquery>	

<cfquery name="PurchaseClass" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_OrderClass
		WHERE  Code = '#PO.OrderClass#' 
</cfquery>
	
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#PO.Mission#' 
</cfquery>

<cfif PurchaseClass.PurchaseTemplate neq "">
	<cfset tmp = "#PurchaseClass.PurchaseTemplate#">
<cfelseif Parameter.PurchaseTemplate neq "">
    <cfset tmp = "#Parameter.PurchaseTemplate#"> 
<cfelse>
	<cfset tmp = "Procurement/Application/Purchaseorder/Purchase/POViewPrint.cfm">  
</cfif>

<cfif PO.PrintDocumentId neq "">

	<cfoutput>
	
		<script>	
			window.location =  "#SESSION.root#/Tools/Mail/MailPrepare.cfm?Id=Print&ID1=#url.id1#&docid=#PO.PrintDocumentId#"	
		</script>
	
	</cfoutput>

<cfelse>
	
	<cfoutput>
	
		<script>	
			window.location =  "#SESSION.root#/Tools/Mail/MailPrepare.cfm?Id=Print&ID1=#url.id1#&templatepath=#tmp#"	
		</script>
	
	</cfoutput>
	
</cfif>	