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
<cftransaction>
	<cfquery name="DeleteVendor" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 DELETE FROM Ref_EntryClassVendor
			 WHERE  EntryClass    = '#URL.entryClass#' 
			 AND    OrgUnitVendor = '#URL.vendor#'
	</cfquery>
			
	<cfquery name="UpdateItemVendor" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE ItemMasterVendor
	     SET
		 	Operational = 0
		 WHERE OrgUnitVendor = '#url.vendor#'
		 AND Code IN (SELECT Code FROM ItemMaster WHERE	EntryClass = '#url.entryClass#')
	</cfquery>
			
</cftransaction>

<cfoutput>  	
	<script>
		ptoken.navigate('Vendors/VendorEntry.cfm?entryclass=#url.entryclass#&vendor=&idmenu=#url.idmenu#&fmission=#url.fmission#','contentbox1')
	</script>
</cfoutput>	
