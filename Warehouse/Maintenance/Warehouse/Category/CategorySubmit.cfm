
<cf_tl id = "Sorry, this category already exists." var = "msg">

<cfquery name="Exist" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT    	*
		FROM     	WarehouseCategory
		WHERE    	Warehouse = '#Form.Warehouse#'
	    AND    		Category  = '#Form.Category#'
</cfquery>

<cfif url.id2 eq ""> 
	
	<cfif Exist.recordCount eq "0">
		
		<cfquery name="Insert" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO WarehouseCategory
			         	(Warehouse,
						 Category,
						 Selfservice,
						 Oversale,
						 RequestMode,
						 MinReorderMode,
						 TaxCode,
						 ThresholdDiscount,
						 Operational,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
		      VALUES ('#Form.Warehouse#',
			  		  '#Form.Category#',
					  '#Form.Selfservice#',
					  '#Form.OverSale#',
					  '#Form.RequestMode#',
					  '#Form.MinReorderMode#',
					  '#Form.TaxCode#',
					  '#Form.ThresholdDiscount#',
					  #Form.Operational#,
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
		</cfquery>
		
		<cfoutput>
			<script language="JavaScript">   
	     		ptoken.navigate('RecordEdit.cfm?idmenu=#url.idmenu#&id1=#url.id1#','contentbox1');
				ProsisUI.closeWindow('mydialog');
			</script>
		</cfoutput>
			
	<cfelse>
		<script>
			<cfoutput>
				alert("#msg#")
			</cfoutput>
		</script>
				
	</cfif>	

<cfelse>
	
	<cfif Exist.recordCount gt 0 and Form.Category neq Form.CategoryOld>
		
		<script>
			<cfoutput>
				alert("#msg#")
			</cfoutput>
		</script>				
			
	<cfelse>
					
		<cfquery name="Update" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE WarehouseCategory
			 SET	Category          = '#Form.Category#',
			 		Operational       = '#Form.Operational#',
					Selfservice       = '#Form.Selfservice#',
					Oversale          = '#Form.OverSale#', 
					ThresholdDiscount = '#Form.ThresholdDiscount#',
					TaxCode           = '#Form.TaxCode#',
					RequestMode       = '#Form.RequestMode#',
					MinReorderMode    = '#Form.MinReorderMode#'
			 WHERE 	Warehouse         = '#Form.Warehouse#'
			 AND	Category          = '#Form.CategoryOld#'
		</cfquery>
		
		<cfoutput>
			<script language="JavaScript">   			  
	     		// ptoken.navigate('Category/CategoryEdit.cfm?idmenu=#url.idmenu#&id1=#url.id1#&id2=#url.id2#','contentsubbox1');
				ptoken.navigate('Category/CategoryListing.cfm?ID1=#url.id1#','#url.id1#_list');
			</script>	
			<cfinclude template="CategoryEdit.cfm">		
			<cfoutput><cf_tl id="Updated #timeformat(now(),'HH:MM:SS')#"></cfoutput>
		</cfoutput>
				
	</cfif>	

</cfif>
