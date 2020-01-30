
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
 parent.parent.ColdFusion.Window.hide('deliverdialog')	
</script>
  
	

