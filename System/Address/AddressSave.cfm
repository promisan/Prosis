<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.context"   default="">
<cfparam name="url.contextid" default="">
<cfparam name="url.addressid" default="">

<cfif url.addressid eq "">

	<cf_AssignId>
	<cfset AddressId = rowguid>
	
<cfelse>

	<cfset AddressId = url.addressid>

</cfif>	

<!--- address object --->	
<cf_address datasource="appsEmployee" 
          addressid="#addressid#" mode="save" 
		  addressscope="#url.context#">
		  
<cfswitch expression="#url.context#">
	
	<cfcase value="TaxCode">
	
	   <cfquery name="TaxCode" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE CountryTaxCode
				SET    AddressId = '#addressid#'
				WHERE  TaxCode = '#url.contextid#'		
		</cfquery>	
	
	</cfcase>

</cfswitch>		  

<script>
   ProsisUI.closeWindow('address')
</script>

