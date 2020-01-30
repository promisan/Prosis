
<!--- set dleivery status --->

<cfoutput>

<cfif url.recordstatus eq "3">
	
	<cfquery name="SetStatus" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE PurchaseLine
			 SET    DeliveryStatus        = '3',
			        RecordStatus          = '3',
					RecordStatusDate      = getDate(),
					RecordStatusOfficer   = '#session.acc#'
			 WHERE  RequisitionNo         = '#url.RequisitionNo#'		 
	</cfquery>		
	
	<input type   = "checkbox" 
	      name    = "delivery#RequisitionNo#" 
		  value   = "3" 
		  checked
		  onclick = "ColdFusion.navigate('setDeliveryStatus.cfm?requisitionno=#url.requisitionno#&recordstatus=1','status_#requisitionno#')"
		  class   = "radiol">	
		  
	<script>
		 try { document.getElementById('add#url.RequisitionNo#').className = "hide"	} catch(e) {}
	</script>	  

<cfelse>

	<cfquery name="SetStatus" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE PurchaseLine
			 SET    DeliveryStatus       = '1',
			        RecordStatus         = '1',
					RecordStatusDate     = NULL,
					RecordStatusOfficer  = NULL
			 WHERE  RequisitionNo        = '#url.RequisitionNo#'		 
	</cfquery>		
	
	<cf_UIToolTip tooltip="set the delivery status of this purchase to completed">
	<input type   = "checkbox" 
	      name    = "delivery#RequisitionNo#" 
		  value   = "1" 		  
		  onclick = "ColdFusion.navigate('setDeliveryStatus.cfm?requisitionno=#url.requisitionno#&recordstatus=3','status_#requisitionno#')"
		  class   = "radiol">	
	</cf_UIToolTip>
	
	<script>
		 try {document.getElementById('add#url.RequisitionNo#').className = "regular"} catch(e) {}	
	</script>	  	

</cfif>

</cfoutput>

