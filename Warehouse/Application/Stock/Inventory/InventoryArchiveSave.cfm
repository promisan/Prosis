<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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
			   '#SESSION.first#'	)
	</cfquery>	

</cfloop>	

<!--- provision to not have records for each second --->

<cfoutput>

<script language="JavaScript">    
    locarcshow('#List.warehouse#','#List.location#','#List.itemno#','#List.UoM#','#List.TransactionLot#','locarc#url.box#_#url.currentrow#','enforce')
</script>

</cfoutput>




