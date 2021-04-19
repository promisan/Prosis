
<table width="100%" height="100%">
   
 <tr>
     <td align="left" width="100%">

	 	<table  width="100%" height="100%"><tr>
						   	  	    	 	   
	   		<cfset wd = "32">
			<cfset ht = "32">	
			<cfset itm = 0>   		
	        
			<cf_tl id="Active Lines" var="vActive">
			
			<cfset itm=itm+1>
			
	   		<cf_menutab 
			      base       = "lines"
			      item       = "#itm#" 
				  target     = "linesbox"
				  targetitem = "1"
				  type       = "Horizontal"
			      iconsrc    = "Logos/Workorder/LineValid.png" 
				  iconwidth  = "#wd#" 
				  iconheight = "#ht#" 						  		 
				  class      = "highlight"								 
				  name       = "#vActive#"
				  source     = "../ServiceDetails/ServiceLineListingContent.cfm?workorderid=#URL.workorderId#&systemfunctionid=#url.systemfunctionid#&filter=active">
							  			
			<cfquery name="getSchedules" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				    SELECT   TOP 1 WLS.*							  
					FROM     WorkOrderLine AS WL INNER JOIN
			                 WorkOrderLineSchedule AS WLS ON WL.WorkOrderId = WLS.WorkOrderId AND WL.WorkOrderLine = WLS.WorkOrderLine							 
					WHERE    WL.WorkOrderId    = '#url.workorderid#'					
					AND     (WL.DateExpiration IS NULL OR WL.DateExpiration >= GETDATE()) 					
					AND      WL.Operational    = 1 					
					AND      WLS.ActionStatus  = '1'						
			</cfquery>	  
			
			<cfquery name="WorkOrder" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT     *
				FROM      WorkOrder W INNER JOIN
                	      ServiceItem S ON W.ServiceItem = S.Code INNER JOIN
	                      Ref_ServiceItemDomain D ON S.ServiceDomain = D.Code
				WHERE    WorkOrderId    = '#url.workorderid#'							
			</cfquery>	  
			
			<cfif getSchedules.recordcount gte "1">
				  
			<cfset itm=itm+1>
			
			<cf_tl id="Extend Schedules" var="vExtend">
			
	   		<cf_menutab 
			      base       = "lines"
			      item       = "#itm#" 
				  target     = "linesbox"
				  targetitem = "1"
				  type       = "Horizontal"
			      iconsrc    = "Logos/Attendance/RecordTime.png" 
				  iconwidth  = "#wd#" 
				  iconheight = "#ht#" 						  		 				  						 
				  name       = "#vExtend#"
				  source     = "../ServiceDetails/Schedule/ScheduleBatchExtend.cfm?workorderid=#URL.workorderId#&systemfunctionid=#url.systemfunctionid#&filter=active">
	  
			</cfif>
			
			<cfif workorder.allowConcurrent eq "0">
			
				<cfset itm=itm+1>
											   
				<cf_tl id="Expired Lines" var="vExpired">
		   		<cf_menutab base="lines"
				      item       = "#itm#" 
					  target     = "linesbox"
					  targetitem = "1"
					  type       = "Horizontal"
				      iconsrc    = "Logos/Workorder/LineExpired.png" 
					  iconwidth  = "#wd#" 
					  iconheight = "#ht#" 				  
					  name       = "#vExpired#"
					  source     = "../ServiceDetails/ServiceLineListingContent.cfm?workorderid=#URL.workorderId#&systemfunctionid=#url.systemfunctionid#&filter=expired">
				
			 </cfif>
			 
			 <cfset itm=itm+1>
			 <cf_tl id="Disabled Lines" var="vDisabled">
	  		 <cf_menutab base="lines"
			      item       = "#itm#" 
				  target     = "linesbox"
				  targetitem = "1"
				  type       = "Horizontal"
			      iconsrc    = "Logos/Workorder/LineInvalid.png" 
				  iconwidth  = "#wd#" 
				  iconheight = "#ht#" 				 
				  name       = "#vDisabled#"
				  source     = "../ServiceDetails/ServiceLineListingContent.cfm?workorderid=#URL.workorderId#&systemfunctionid=#url.systemfunctionid#&filter=disabled">
			
			<td style="width:20%"></td>	 						  
	  </tr>
	  </table>
   
   </td>    
	 	 
 </tr>
  
 	<cf_menucontainer 
	   name="linesbox" 
	   item="1" 
	   class="regular" 	   
	   template="../../WorkOrder/Application/WorkOrder/ServiceDetails/ServiceLineListingContent.cfm">
	   					  
</table>   


