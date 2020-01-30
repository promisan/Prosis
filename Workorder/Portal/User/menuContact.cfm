
<!--- contact info --->

<cfset url.mission = "OICT">

<cfquery name="List" 
	datasource="AppsWorkOrder"
     username="#SESSION.login#"
     password="#SESSION.dbpw#">							
	  SELECT     TOP 1 W.*	 
	  FROM       ServiceItemClass C INNER JOIN
	             ServiceItem S ON C.Code = S.ServiceClass INNER JOIN
				 Ref_ServiceItemDomain D ON D.Code = S.ServiceDomain INNER JOIN
                 WorkOrder W ON S.Code = W.ServiceItem INNER JOIN
                 WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId
      WHERE      WL.PersonNo = '#client.personno#' AND
	  			 WL.Operational = '1' AND
				 S.Operational = 1 AND
				 S.Selfservice = 1 AND
				 (WL.DateExpiration is NULL or DateExpiration > getDate()-50) AND
				 W.Mission = '#url.mission#'
	  ORDER BY   C.Description, S.Description, WL.Reference						  
</cfquery>	
	
<cfset url.scope = "portal">	

<cfif list.recordcount eq "1">	


<table width="96%" height="100%" align="center"><tr><td>

	<cfset url.init = 0>
        <cfset url.scope = "portal">
	<cfset url.workorderid = "#list.workorderid#">
	<cfinclude template="../../../custom/portal/muc/WorkOrderAddress.cfm">
	
	</td></tr></table>

</cfif>