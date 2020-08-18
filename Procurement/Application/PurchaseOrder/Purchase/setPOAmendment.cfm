
<!--- amendment --->

<!--- check access,
      reset PO amendmentNo
	  reset status
	  reset workflow
	  reload
--->

 <cfquery name="PO" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Purchase P
		WHERE  PurchaseNo ='#URL.PurchaseNo#'
		AND    PurchaseNo IN (SELECT PurchaseNo 
		                      FROM   PurchaseLine
							  WHERE  PurchaseNo = P.PurchaseNo)
</cfquery>	

<cfinvoke component="Service.Access"
	   Method         = "procApprover"
	   OrgUnit        = "#PO.OrgUnit#"
	   OrderClass     = "#PO.OrderClass#"
	   ReturnVariable = "ApprovalAccess">	

<cfif ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL">
	
	<cftransaction>
	
	 <cfquery name="Purchase" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	       UPDATE Purchase
		   SET    ModificationNo     = ModificationNo+1,
			      ModificationDate   = getDate(),
			      ModificationUserId = '#session.acc#',
				  ActionStatus       = '2'
		   WHERE PurchaseNo = '#url.purchaseNo#'		       		
	 </cfquery>
	 
	  <cfquery name="workflow" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	       UPDATE Organization.dbo.OrganizationObject
		   SET    Operational = 0
		   WHERE  ObjectKeyValue1 = '#url.purchaseNo#'	
		   AND    EntityCode = 'ProcPO'
		   AND    Operational = 1	
	 </cfquery>
	 
	</cftransaction> 

</cfif>
 
<cfoutput>
<script>
    Prosis.busy('no')
	ptoken.location("POView.cfm?header=#url.header#&Mode=edit&role=#URL.Role#&ID1=#URL.Purchaseno#")
</script>
</cfoutput>
 
 
