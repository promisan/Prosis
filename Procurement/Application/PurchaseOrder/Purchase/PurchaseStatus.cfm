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

<cfif PO.ActionStatus eq "3">

<cfoutput>
<script>
	ptoken.location("POView.cfm?header=#url.header#&Mode=view&role=#URL.Role#&ID1=#URL.Purchaseno#")
</script>
</cfoutput>

</cfif>