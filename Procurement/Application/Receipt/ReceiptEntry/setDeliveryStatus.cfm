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

