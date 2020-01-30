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
					  '#Form.TaxCode#',
					  '#Form.ThresholdDiscount#',
					  #Form.Operational#,
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
		</cfquery>
		
		<cfoutput>
			<script language="JavaScript">   
	     		ColdFusion.navigate('RecordEdit.cfm?idmenu=#url.idmenu#&id1=#url.id1#','contentbox1');
				ColdFusion.Window.hide('mydialog');
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
					RequestMode       = '#Form.RequestMode#'
			 WHERE 	Warehouse         = '#Form.Warehouse#'
			 AND	Category          = '#Form.CategoryOld#'
		</cfquery>
		
		<cfoutput>
			<script language="JavaScript">   
	     		ColdFusion.navigate('Category/CategoryEdit.cfm?idmenu=#url.idmenu#&id1=#url.id1#&id2=#url.id2#','contentsubbox1');
				ColdFusion.navigate('RecordEdit.cfm?idmenu=#url.idmenu#&id1=#url.id1#','contentbox1');
			</script>
		</cfoutput>
				
	</cfif>	

</cfif>
