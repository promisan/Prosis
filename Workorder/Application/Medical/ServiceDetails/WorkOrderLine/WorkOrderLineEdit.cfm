

<!--- edit the service item, class and action --->

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *, W.Reference as HeaderReference
		FROM      WorkOrder W INNER JOIN WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId
		WHERE     WL.WorkOrderLineId = '#url.workorderlineid#'				
</cfquery>		

<cfquery name="customer" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Customer
		WHERE     CustomerId = '#get.CustomerId#'				
</cfquery>		

<form name="formeditline" method="post">
	
	<table width="95%">
	
	<tr><td style="padding:10px">
	
	<table width="95%" align="center" class="formspacing formpadding">
	
		<tr class="labelmedium">
		    <td><cf_tl id="Service">:</td>
			<td>
			
			<cfquery name="ServiceItemList" 
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   *
				    FROM     ServiceItem
					WHERE    Code IN (SELECT ServiceItem 
					                  FROM   ServiceItemMission 
								      WHERE  Mission = '#get.mission#' 							 
								      AND    Operational = 1)
					AND      ServiceDomain = '#get.servicedomain#'			  
					AND      Operational = 1								
					ORDER BY ListingOrder
			</cfquery>	
			
			 <select name="serviceitem" 
		           id="serviceitem" 			   
				   class="regularxl">   
		   	  
			   <cfoutput query="ServiceitemList">
			   
			  	  <cfinvoke component = "Service.Access"  
					   method           = "workorderprocessor" 
					   mission          = "#get.mission#" 	
					   orgunit          = "#customer.orgunit#"
					   serviceitem      = "#code#"  
					   returnvariable   = "access">  
				   				   
				  <cfif access eq "ALL" or access eq "EDIT">		   
				      <cfset go = "1">
				      <option value="#Code#" <cfif get.serviceItem eq Code>selected</cfif>>#Description#</option>
				  </cfif>	  
				   
			   </cfoutput>
			   
		   </select>			
			
			</td>
						
		</tr>
		<tr class="labelmedium">
		
		<td><cf_tl id="Class">:</td>
		
		<td>
		
			<cfquery name="DomainClass" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    * 
				FROM      Ref_ServiceItemDomainClass
				WHERE     ServiceDomain = '#get.servicedomain#'	
				AND       Operational = 1
				ORDER BY  ListingOrder
			</cfquery>			
			
			<select name="ServiceDomainClass" id="ServiceDomainClass" class="regularxl enterastab">
				<cfoutput query="DomainClass">
				   <option value="#Code#" <cfif get.ServiceDomainClass eq code>selected</cfif>>#Description#</option>
				</cfoutput>					
			</select>
		
		</td>
				
		
		</tr>
		<tr class="labelmedium">
		
		    <td><cf_tl id="Activity">:</td>
			<td>
				<cfdiv bind="url:#session.root#/workorder/application/Medical/ServiceDetails/WorkOrderLine/getServiceReference.cfm?mission=#get.mission#&servicedomain=#get.servicedomain#&reference=#get.Reference#&serviceitem={serviceitem}">						
			</td>		
		
		</tr>
				
		<tr>	
		<td class="labelmedium"><cf_tl id="ReferenceNo">:</td>
		<td>
		<cfoutput>
		<input type="text" class="regularxl enterastab" name="Reference" id="Reference" value="#get.HeaderReference#" style="width:100">	
		</cfoutput>
		</td>
		</tr>
		
		<tr><td></td></tr>
		<tr><td colspan="2" class="line" id="xxx"></td></tr>
		<tr><td colspan="2" align="center" style="padding-top:4px">
		<cfoutput>
			<input type="button" name="Save" value="Save" class="button10g" 
			   onclick="ptoken.navigate('#session.root#/workorder/application/Medical/ServiceDetails/WorkOrderLine/WorkOrderLineEditSubmit.cfm?workorderlineid=#url.workorderlineid#','xxx','','','POST','formeditline')">	
		</cfoutput>	   
		</td></tr>
	
	</table>
	
	</td></tr>
	
	</table>

</form>
