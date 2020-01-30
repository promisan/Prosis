
<!--- set the selected account --->


<cfquery name="item" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Item I, ItemUoM U
		WHERE  I.ItemNo = U.ItemNo
		AND    U.ItemUoMId = '#url.itemuomid#'		
</cfquery>

<cfif item.ItemClass eq "Asset">

	<script>
	 document.getElementById("warehousequantity").focus()
	 alert('Transaction not supported')
	 </script>
	<cfabort>

<cfelseif item.ItemClass eq "Supply">

	
	<cfquery name="glaccount" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM   Ref_CategoryGledger
			WHERE  Category = '#item.Category#'
			AND    Area = 'Receipt'		
	</cfquery>
		
	<cfquery name="get" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_Account
		WHERE  GLAccount = '#glaccount.GLaccount#'
	</cfquery>
	
	<cfif get.GLAccount eq "">
	   <script>
	    document.getElementById("warehousequantity").focus() 
	   	alert('GL Account not defined for this item')	   
	   </script>
	   <cfabort>
	</cfif> 
	
<cfelse>
	
	<cfquery name="glaccount" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_CategoryGledger
		WHERE  Category = '#item.Category#'
		AND    Area = 'COGS'		
	</cfquery>	

	<cfquery name="get" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_Account
		WHERE  GLAccount = '#glaccount.GLaccount#'
	</cfquery>
	
	<cfif get.GLAccount eq "">
	   <script>alert('GL Account not defined for this item')</script>
	   <cfabort>
	</cfif> 

</cfif>

<cfoutput>
	
<script language="JavaScript">

	document.getElementById("entryglaccount").value     = '#get.GLAccount#'		
	document.getElementById("entrygldescription").value = '#get.Description#'		
	document.getElementById("entrydebitcredit").value   = '#get.AccountType#' 
	
	document.getElementById("itemno").value             = '#item.ItemNo#' 	
	document.getElementById("itemdescription").value    = '#item.ItemDescription#' 
	document.getElementById("itemuom").value            = '#item.UoM#' 
	document.getElementById("uomname").value            = '#item.UoMDescription#' 
	document.getElementById("warehousequantity").focus()
		
</script>	

</cfoutput>