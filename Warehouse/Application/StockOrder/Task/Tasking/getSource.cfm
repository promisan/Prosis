
<cfoutput>
<cfquery name="get" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM   RequestTask
		  WHERE  RequestId = '#URL.id#'
		  AND    TaskSerialNo = '#url.serialno#'		 
</cfquery>

<font face="Calibri" size="1">Tasked to:</font>
<font face="Calibri" size="3">
						
	<cfif get.TaskType eq "Purchase">
	
		<cfquery name="Source" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT *
			      FROM   Organization.dbo.Organization
				  WHERE  OrgUnit = (SELECT OrgUnitVendor 
				                    FROM   Purchase 
									WHERE  PurchaseNo IN (SELECT PurchaseNo 
									                      FROM   PurchaseLine 
														  WHERE  RequisitionNo = '#get.sourceRequisitionno#'))									  
		</cfquery>
		
		#Source.OrgUnitName#
	
	<cfelse>		
				
							
		<cfquery name="Source" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT *
			      FROM   WarehouseLocation
				  WHERE  Warehouse = '#get.sourcewarehouse#'
				  AND    Location  = '#get.sourcelocation#'		  
		</cfquery>
	
		#get.sourcelocation# #source.Description#
							
	</cfif>		
	
</cfoutput>					
	
	