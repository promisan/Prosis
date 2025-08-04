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

<cfparam name="url.scope" default="portal">
<cfparam name="URL.ID" default="All">

<cfif URL.ID neq "All">

  <cfquery name="Update" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
       DELETE WarehouseCart
  	   WHERE  CartId      = '#URL.ID#'	  
   </cfquery>
       
	<cfoutput> 
	
	<script language="JavaScript">
		   
		 document.getElementById('row#URL.ID#').className = "hide"
		 se = document.getElementById('smenu1')
		 if (se) {
		 	ColdFusion.navigate('Requester/CartStatus.cfm','smenu1')
		 }
		 
		 se = document.getElementById('draft_#url.itemlocationid#')
		 if (se) {
			 ColdFusion.navigate('../Stock/InquiryWarehouseGetCart.cfm?itemlocationid=#url.itemlocationid#','draft_#url.itemlocationid#') 
		 
		 }		
		 
	</script>
	
	</cfoutput>
   
<cfelse>

   <cfquery name="Update" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
    DELETE  WarehouseCart
	WHERE   UserAccount = '#SESSION.acc#'
   </cfquery>
      
	<cfinclude template="Cart.cfm">
   
</cfif>

<cf_compression>


