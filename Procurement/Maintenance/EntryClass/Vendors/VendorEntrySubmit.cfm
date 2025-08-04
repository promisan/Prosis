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

<cfparam name="url.Vendor" default="">
	
	<cfquery name="CheckVendor" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT 	*
		 FROM 		Ref_EntryClassVendor 
		 WHERE 		EntryClass = '#URL.entryclass#'
		 AND 		OrgUnitVendor = '#url.vendor#'
	</cfquery>
		
	<cfif CheckVendor.recordcount eq "0">
	
		<cftransaction>
			
			<cfquery name="InsertVendor" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_EntryClassVendor
			         (EntryClass,
					 OrgUnitVendor,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			      VALUES ('#URL.entryclass#',
			      	  '#url.vendor#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
			</cfquery>
			
			<cfquery name="getItems" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 	SELECT 	*
					FROM	ItemMaster
					WHERE	EntryClass = '#url.entryClass#'
			</cfquery>
			
			<cfloop query="getItems">
				
				<cftry>
					
					<cfquery name="InsertItemVendor" 
					     datasource="AppsPurchase" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO ItemMasterVendor
					         (
							 Code,
							 OrgUnitVendor,
							 Source,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName
							 )
					      VALUES (
						  	  '#Code#',
					      	  '#url.vendor#',
							  'Inherited',
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#'
							  )
					</cfquery>
					
					<cfcatch>
						<cfquery name="UpdateItemVendor" 
						     datasource="AppsPurchase" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
						     UPDATE ItemMasterVendor
						     SET
							 	Operational = 1,
								Source = 'Inherited'
							 WHERE OrgUnitVendor = '#url.vendor#'
							 AND Code = '#code#'
						</cfquery>
					</cfcatch>
				</cftry>
			
			</cfloop>
		
		
		</cftransaction>
	
	</cfif>

<cfoutput>  	
	<script>
		ptoken.navigate('Vendors/VendorEntry.cfm?entryclass=#url.entryclass#&vendor=&idmenu=#url.idmenu#&fmission=#url.fmission#','contentbox1')
	</script>
</cfoutput>	
 
