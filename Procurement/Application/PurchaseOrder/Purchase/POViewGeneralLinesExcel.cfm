<cfquery name="PO" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Purchase 
		WHERE  PurchaseNo ='#URL.purchaseno#'
		AND    PurchaseNo IN (SELECT PurchaseNo FROM PurchaseLine)
</cfquery>	

<cfinvoke component="Service.Access"
	   Method="procApprover"
	   OrgUnit="#PO.OrgUnit#"
	   OrderClass="#PO.OrderClass#"
	   ReturnVariable="ApprovalAccess">	

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#PO.Mission#' 
</cfquery>


<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_POLines">
		
<cfif Parameter.InvoiceRequisition eq "1">	  
	<cfinclude template="POViewGeneralLinesExcel_Balance.cfm"> 
<cfelse>  
	<cfinclude template="POViewGeneralLinesExcel_Regular.cfm"> 
</cfif> 
      
<cfset client.table1   = "#SESSION.acc#_POLines">