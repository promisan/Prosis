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