
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
 
