
<cfparam name="url.openmode" default="dialog">

<cfquery name="WorkOrder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrder
	 WHERE   WorkOrderId     = '#url.workorderid#'	
</cfquery>

<cfquery name="Line" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrderLine WL INNER JOIN 
	         WorkOrderService WS ON WL.ServiceDomain = WS.ServiceDomain AND WL.Reference = WS.Reference 
	 WHERE   WL.WorkOrderId     = '#url.workorderid#'	
	 AND     WL.WorkOrderLine   = '#url.workorderline#'
</cfquery>

<cfquery name="Item" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    ServiceItem
	 WHERE   Code   = '#workorder.serviceitem#'	
</cfquery>

<cfquery name="Domain" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ServiceItemDomain
	 WHERE   Code   = '#item.servicedomain#'	
</cfquery>

<cfquery name="Customer" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Customer
	 WHERE   CustomerId     = '#workorder.customerid#'	
</cfquery>

<cfquery name="Parameter" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ParameterMission
	 WHERE   Mission  = '#workorder.mission#'	
</cfquery>

<cfinvoke component = "Service.Access"  
   method           = "WorkorderProcessor" 
   mission          = "#WorkOrder.Mission#" 
   serviceitem      = "#workorder.serviceitem#"	  
   returnvariable   = "accessProcess">	

<cfinvoke component = "Service.Access"  
   method           = "WorkorderFunder" 
   mission          = "#Parameter.TreeCustomer#" 
   orgunit          = "#Customer.OrgUnit#"
   serviceitem      = "#workorder.serviceitem#"
   returnvariable   = "accessFunding">	
				
<cfinvoke component = "Service.Access"  
   method           = "ServiceRequester" 
   mission          = "#Parameter.TreeCustomer#"  
   returnvariable   = "accessRequest">		   

<!--- check if some of the units for this service has manual transactions --->
											
<cfquery name="ManualEntry" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    ServiceItemUnitMission
	 WHERE   ServiceItem  = '#workorder.serviceitem#'	
	 AND     Mission      = '#workorder.mission#'
	 AND     DateEffective <= getDate()
	 AND     EnableUsageEntry = 1
</cfquery>

<cf_divscroll>

<table bgcolor="white" 
   width="98%" align="center" height="100%">

<tr><td>

	<table width="97%" align="center" height="100%">
	
	<cfoutput>
	
		<cfif workorder.reference neq "">
		
		<tr>
			<td class="labellarge" style="padding-left:1px;padding-top:4px" colspan="2" align="left">
			
			<table>
				<tr>
				   <cfif url.openmode eq "embed">
					<td>
					<img src="#session.root#/images/Back.png" height="32" width="32" alt="" border="0" onclick="javascript:history.back()" style="cursor:pointer">
					</td>
					</cfif>
				
					<td class="labelmedium" style="padding-left:2px;font-size:16px">
				
					<a href="javascript:history.back()">
					<font color="gray"><cfif workorder.reference neq "">#Workorder.reference#</cfif></a></font>
					
					<cfif Item.ServiceMode eq "WorkOrder">
						[<cfif workorder.actionstatus eq "0">
						          <cf_tl id="Quotation">
						 <cfelseif workorder.actionstatus eq "1">
						          <cf_tl id="In Process">
						 <cfelse>
						          <cf_tl id="Completed">
						 </cfif>]
					 </cfif>
					 
					 </td>
					 
				</tr>
			</table>
			 
			</td>
		</tr>	
		
		</cfif>
			
	</cfoutput>	
	
	<!--- check if the are any pending workflows for this item --->
	
	<cfquery name="getRequest" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   RWO.RequestId
		FROM     WorkOrderLine WL INNER JOIN
		         RequestWorkOrder RWO ON WL.WorkOrderId = RWO.WorkOrderId AND WL.WorkOrderLine = RWO.WorkOrderLine
		WHERE    WL.Reference     = '#Line.Reference#'
		AND      WL.DateEffective <= '#Line.DateEffective#'		
	</cfquery>
	
	<cfset transferstatus = "enabled">
		
	<cfloop query="getRequest">
		
		<cf_wfactive EntityCode="WrkRequest" ObjectKeyValue4="#RequestId#">		
		<cfif wfStatus neq "closed">			
			<cfset transferstatus = "disable">
		</cfif>
			
	</cfloop>	
					
<cfquery name="Line" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrderLine
	 WHERE   WorkOrderId     = '#url.workorderid#'	
	 AND     WorkOrderLine   = '#url.workorderline#'
</cfquery>

<cfquery name="DomainClass" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT   *					 
     FROM    Ref_ServiceItemDomainClass			 
	 WHERE   ServiceDomain   = '#Line.ServiceDomain#'
	 AND     Code            = '#Line.ServiceDomainClass#'			
 </cfquery>

 <cfquery name="Children" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">

		SELECT   WO.*, 
		         (SELECT CustomerName 
				  FROM Customer 
				  WHERE CustomerId = W.CustomerId) as CustomerName,
		         P.IndexNo AS IndexNo, 
				 P.LastName AS LastName, 
				 P.FirstName AS FirstName,
				 P.Nationality,
				 P.Gender				
				 
	     FROM    WorkOrder W 
		         INNER JOIN WorkOrderLine WO ON W.WorkOrderId = WO.WorkOrderId
		 		 LEFT OUTER JOIN Employee.dbo.Person P ON WO.PersonNo = P.PersonNo
				 
		 WHERE   WO.ParentWorkOrderId   = '#url.workorderid#'
		 AND     WO.ParentWorkorderLine = '#url.workorderline#'					
 
	</cfquery>
	
	<tr><td id="custom" height="40" style="padding-top:3px;padding-bottom:3px">		
	   <cfinclude template="ServiceLineHeader.cfm">		
	</tr>
				
	<tr class="line"><td height="40" style="min-width:1200">
	
		<table width="100%" cellspacing="0" align="center" cellpadding="0">
		<tr>
		
			<cfset wd = "50">
			<cfset ht = "50">				
												
		   <cfif DomainClass.ServiceType eq "" or DomainClass.ServiceType eq "Service">		
				<cfinclude template="ServiceLineMenuService.cfm">				
		   <cfelseif DomainClass.ServiceType eq "Activity">		   
		   	    <cfinclude template="ServiceLineMenuActivity.cfm">			
		   <cfelseif DomainClass.ServiceType eq "Produce">		   		   
		   	   <cfinclude template="ServiceLineMenuProduce.cfm">			   
		   <cfelseif DomainClass.ServiceType eq "Sale">		   		   
		   	   <cfinclude template="ServiceLineMenuSale.cfm">	   		   
		   <cfelse>		   
		   	   <cfinclude template="ServiceLineMenuWorkOrder.cfm">		   
		   </cfif>
				
		</tr>						
		</table>	
	</td>
	</tr>
										
	<tr><td colspan="2" height="100%" valign="top" style="padding:3px">
			
		<table width="100%" height="100%">
						
				<cf_menucontainer item="1" class="regular">
				    <cfset url.tabno = 1>
				    <cfif DomainClass.ServiceType eq "Activity">					    
					    <cfinclude template="ServiceLineForm.cfm"> 
					<cfelseif  DomainClass.ServiceType eq "WorkOrder">	
					    <cfinclude template="../../Assembly/Items/FinalProduct/Summary/SummaryView.cfm">
					<cfelseif  DomainClass.ServiceType eq "Sale">	
					    <cfinclude template="../../Assembly/Items/FinalProduct/Summary/SummaryView.cfm">	
					<cfelseif  DomainClass.ServiceType eq "Produce">	
					    <cfinclude template="../../Assembly/Items/HalfProduct/Summary/SummaryView.cfm">	
					<cfelse>
						<cfinclude template="Billing/DetailBilling.cfm">
					</cfif>	
				</cf_menucontainer>
				<cf_menucontainer item="2" class="hide">
			
		</table>
		
	</td></tr>	
		
	</table>

</td></tr>

</table>

</cf_divscroll>