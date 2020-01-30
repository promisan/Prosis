
<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset dte = dateValue>
      		
<cfquery name="Actions" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 		
	   SELECT  	WA.WorkActionId							  
	   FROM     WorkorderLine WL INNER JOIN 
	            WorkOrderLineAction WA ON WL.WorkOrderId = WA.WorkorderId AND WL.WorkOrderLine = WA.WorkorderLine 			  
	   WHERE    WL.WorkOrderId   = '#url.workorderid#'		
	   AND      WL.Operational   = 1
	   AND      WL.DateEffective <= #dte# AND (WL.DateExpiration is NULL or DateExpiration >= #dte#)	  	  
	   AND      CONVERT(VARCHAR(10),WA.DateTimePlanning,126) = '#dateformat(dte,"YYYY-MM-DD")#' 			   
</cfquery>		

<cfinvoke component = "Service.Connection.Connection"  
   method           = "setconnection" 
   scopeid          = "#url.workorderid#" 
   object           = "attachment" 
   objectcontent    = "#actions#"
   objectidfield    = "workactionid"
   delay            = "15">	
   
<table width="100%" align="right">
     <tr><td align="right" style="padding-top:3px;padding-right:14px" class="line labelit">Prosis ActivSync enabled</td></tr>
</table>
   