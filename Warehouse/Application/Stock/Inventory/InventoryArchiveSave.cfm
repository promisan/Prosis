
<!--- archives transaction for loggin only --->

<cfparam name="Form.description_#url.loc#" default="">	
<cfset memo = evaluate("Form.description_#url.loc#")>	

<cfset date = evaluate("Form.transaction_#url.loc#_date")>	
<cfset hour = evaluate("Form.transaction_#url.loc#_hour")>	
<cfset minu = evaluate("Form.transaction_#url.loc#_minute")>	

<CF_DateConvert Value = "#date#">
<cfset dte = dateValue>		

<cfset dte = DateAdd("h","#hour#", dte)>
<cfset dte = DateAdd("n","#minu#", dte)>

<cfquery name="List"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   userTransaction.dbo.StockInventory#url.whs#_#SESSION.acc# 
	WHERE  ActualStock is not NULL
	AND    Location        = '#url.loc#'
	AND    ItemNo          = '#url.itemno#'
	AND    UoM             = '#url.uom#'
	AND    TransactionLot  = '#url.TransactionLot#'
</cfquery>

<cfloop query="List">
	
	<cfquery name="Archive"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   INSERT INTO ItemWarehouseLocationInventory
		   (Warehouse,
		    Location,
			ItemNo,
			UoM,
			TransactionLot,
			DateInventory,
			QuantityOnHand,
			QuantityVariance,
			QuantityCounted,
			ValueMetric,
			Memo,
			OfficerUserId,
			OfficerLastName,
			OfficerFirstName)
		VALUES ('#Warehouse#',
			   '#Location#',
			   '#ItemNo#',
			   '#UoM#',
			   '#TransactionLot#',
			   #dte#,
			   <cfif OnHand eq "">0<cfelse>#onhand#</cfif>,
			   <cfif OnHand eq "">#ActualStock#<cfelse>#ActualStock-onhand#</cfif>,
			   '#counted#',
			   '#metric#',		
			   '#memo#',	  
			   '#SESSION.acc#',
			   '#SESSION.last#',
			   '#SESSION.first#'		)
	</cfquery>	

</cfloop>	

<!--- provision to not have records for each second --->

<cfoutput>

<script language="JavaScript">
    locarcshow('#List.warehouse#','#List.location#','#List.itemno#','#List.UoM#','#List.TransactionLot#','locarc#url.box#_#url.currentrow#','enforce')
</script>

</cfoutput>




