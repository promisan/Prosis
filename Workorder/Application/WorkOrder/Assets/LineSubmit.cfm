
<cfparam name="Form.AssetId"  default="">
<cfparam name="Form.Memo"     default="">

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset eff = dateValue>

<cfset dateValue = "">
<cfif form.dateexpiration eq "">
	<cfset exp = "NULL">
<cfelse>
	<CF_DateConvert Value="#Form.DateExpiration#">
	<cfset exp = dateValue>
</cfif>

<cfif form.assetid eq "">

	<script>
	    alert("Please select a device.")
	</script>
	<cfabort>

</cfif>

<cfif not isDate(eff) or (not isDate(exp) and exp neq "NULL")>
 
 	<script>
	    alert("Invalid effective / expiration date.")
	</script>
	<cfabort>
 
</cfif>

<cfoutput>
	
	<cfif URL.ID2 neq "new">
	
		<cfquery name="get" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT * FROM WorkOrderLineAsset 			 
			  WHERE WorkOrderId       = '#URL.WorkOrderId#' 
			  AND   TransactionId     = '#URL.ID2#'
		    </cfquery>
			
		 <cfif get.DateEffective neq eff or get.DateExpiration neq exp>
		 
		 	 <cftransaction>
		 
		 	 <cfquery name="Update" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  UPDATE   WorkOrderLineAsset 
					  SET  Operational = 0		 						   	 
					 WHERE WorkOrderId       = '#URL.WorkOrderId#' 
					 AND   TransactionId     = '#URL.ID2#'
			    </cfquery>
				
				<cfquery name="Insert" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO WorkOrderLineAsset 
			         (WorkOrderId,
					 WorkOrderLine,
					 TransactionId,
					 AssetId,	
					 DateEffective,			
					 DateExpiration,						
					 Memo,				
					 OfficerUserId,
					 OfficerLastname,
					 OfficerFirstName)
			      VALUES
				     ('#URL.WorkOrderId#',
					  '#url.workorderline#',
				      newid(),
					  '#Form.AssetId#', 
					  #eff#,	
					  #exp#,	
					  '#Form.Memo#',	
			      	  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
				</cfquery>	
				
				</cftransaction>			
		 
		 <cfelse>	
	
			 <cfquery name="Update" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  UPDATE   WorkOrderLineAsset 
					  SET  Assetid = '#Form.AssetId#', 				 
						   DateEffective     = #Eff#,
						   DateExpiration    = #Exp#,
						   Memo              = '#Form.Memo#'		 
					 WHERE WorkOrderId       = '#URL.WorkOrderId#' 
					 AND   TransactionId     = '#URL.ID2#'
			    </cfquery>
				
		  </cfif>		
				
	<cfelse>
			
			<cfquery name="Insert" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO WorkOrderLineAsset 
			         (WorkOrderId,
					 WorkOrderLine,
					 TransactionId,
					 AssetId,	
					 DateEffective,			
					 DateExpiration,						
					 Memo,				
					 OfficerUserId,
					 OfficerLastname,
					 OfficerFirstName)
			      VALUES
				     ('#URL.WorkOrderId#',
					  '#url.workorderline#',
				      '#form.TransactionId#',
					  '#Form.AssetId#', 
					  #eff#,	
					  #exp#,	
					  '#Form.Memo#',	
			      	  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
				</cfquery>				
										   	
	</cfif>
	
	<cfset url.id2 = "">
	<script>	      
		   ColdFusion.navigate('#SESSION.root#/workorder/application/workorder/Assets/Line.cfm?WorkOrderId=#URL.WorkOrderId#&workorderline=#url.workorderline#','assetbox')
	</script>	

</cfoutput>