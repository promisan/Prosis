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
<cfquery name="Transport" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	 FROM       Ref_TransportTrack
	 WHERE      TransportCode = '#URL.TransportCode#' 
	 AND        Operational = 1
	 ORDER BY   TrackingOrder	    	
</cfquery>

<cftransaction action="BEGIN">
 
<cfloop query="transport">
  
  <!--- remove prior entry --->
  <cfquery name="Reset" 
      datasource="AppsPurchase" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      DELETE From PurchaseTracking
      WHERE PurchaseNo  = '#URL.PurchaseNo#'
	    AND TrackingId = '#trackingid#'
  </cfquery>		

  <cfset plan     = Evaluate("FORM.DatePlanning_" & #currentrow#)>
  
  <cfif plan neq "">
   	   <CF_DateConvert Value="#DateFormat(plan, '#CLIENT.DateFormatShow#')#">
       <cfset plandte = dateValue>
  <cfelse>
       <cfset plandte = "">  	   
  </cfif>
  
  <cfset actual   = Evaluate("FORM.DateActual_" & #currentrow#)>
  
  <cfif actual neq "">
   	   <CF_DateConvert Value="#DateFormat(actual, '#CLIENT.DateFormatShow#')#">
       <cfset actualdte = dateValue>
  <cfelse>
       <cfset actualdte = "">  	   
  </cfif>
  
  <cfset remarks  = Evaluate("FORM.TrackingRemarks_" & #currentrow#)>
    		
  <cfquery name="Insert" 
     datasource="AppsPurchase" 
     username=#SESSION.login# 
     password=#SESSION.dbpw#>
     INSERT INTO PurchaseTracking  
         (PurchaseNo, 
		  TrackingId,
		  DatePlanning,
		  DateActual,
		  TrackingRemarks,
		  OfficerUserId,
		  OfficerLastName,
		  OfficerFirstName)
      VALUES ('#url.purchaseno#',
          '#trackingid#', 
		  <cfif plandte neq "">
		 	#plandte#, 
		  <cfelse>
		  	NULL,
		  </cfif>
		  <cfif actualdte neq "">
			#actualdte#,
		  <cfelse>
		  	NULL,
		  </cfif>
		  '#remarks#',
     	  '#SESSION.acc#',
		  '#SESSION.last#',
		  '#SESSION.first#')
    </cfquery>		

</cfloop>

</cftransaction>

<script>
 parent.parent.ProsisUI.closeWindow('deliverdialog')	
</script>
  
	

