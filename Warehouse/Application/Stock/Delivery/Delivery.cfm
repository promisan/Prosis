<!--
    Copyright © 2025 Promisan

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

<cfquery name="Batch"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
			
		SELECT *
		FROM   WarehouseBatch
		WHERE  BatchId = '#url.id#'
		
</cfquery>		

<cfquery name="hasOrder"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	
	 SELECT     W.*, WL.DateEffective, ServiceDomain, ServiceDomainClass, OrgUnitImplementer, WorkOrderLineMemo
	 FROM       WorkOrder AS W INNER JOIN
                WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId
     WHERE      W.WorkOrderid = '#url.id#' 
	 AND        WL.WorkOrderLine = '1'
	 AND        W.ActionStatus != '9'
	
</cfquery>		

<cfform method="POST" name="DeliveryEntry">

	<table width="99%" align="center" class="formpadding">
	
	<!---
	
		<tr><td colspan="2">
		
		if not exists do below
		
		Option will only be shown for confirmed transactions
		Show the customer and allow to open it <br>
		Select customer address (this address will go to organization address) <br>
		Target date : effective - expiration <br>
		Allow to select the type of workorder : delivery and class for the modality <br>
		
		- Transfer to shipper 
		- Delivery internal
		- Orgunit that performs : orgunitimplementer
		- OrgUnit that triggers => warehouse orgunit
		
		<br>
		
		Record the boxes and a memo text
		
		<br>
		
		-> save will create customer, workorder, workorder line and action + workflow for the action which can be view and processed here.
		
		if exists we show the order and action
	
		</td></tr>
		
		--->
	
	
	
	<!--- delivery base screen --->
		
	    <cfif hasOrder.recordcount eq "0">
		
		    <tr class="labelmedium2"><td><cf_tl id="Customer"></td><td><cfoutput><a href="javascript:editCustomer('#get.customerid#')">#get.CustomerName#</a></cfoutput></td></tr>
			
		    <tr class="labelmedium2"><td><cf_tl id="Address"></td>
	
		    <td>
			
			<cfquery name="get"
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				
				    SELECT     W.BatchNo, W.BatchWarehouse, C.CustomerId, C.CustomerName, C.PhoneNumber, C.MobileNumber, W.AddressId
		            FROM       WarehouseBatch AS W INNER JOIN
		                       Customer AS C ON W.CustomerId = C.CustomerId
		            WHERE      W.BatchNo = '#batch.BatchNo#'
				
			</cfquery>		
			
			<cfoutput>
			
			<table>
			
			<tr>
			<td id="addressbox">
			
				<cfset url.customerid = get.Customerid>		
				<cfinclude template="getAddress.cfm">
			
			</td>
		    <td style="padding-left:4px"><input type="button" value="refresh" class="button10g" style="width;30px" onclick="ptoken.navigate('#session.root#/Warehouse/Application/Stock/Delivery/getAddress.cfm?customerid=#url.Customerid#','addressbox')"></td>
		  		
			</tr>
			</table>
			
			</cfoutput>	
		
		    </td>
			
			</tr>
		
		<cfelse>
		
			 <tr class="labelmedium2"><td><cf_tl id="Address"></td>
	
		    <td>
		
			<cfquery name="Customer"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				
				    SELECT     *
		            FROM       Customer
		            WHERE      CustomerId = '#hasOrder.CustomerId#' 
				
			</cfquery>	
			
			<cfoutput>
						
			#Customer.City# #Customer.PostalCode# #Customer.Address#
			
			</cfoutput>
			
			</tr>
		
		
		</cfif>
	
	</tr>
	
	<cfif hasOrder.recordcount eq "0">
	 
	<tr class="labelmedium2"><td><cf_tl id="Packaging"></td>
		
		<cfquery name="Package"
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				SELECT    CollectionId, BatchNo, CollectionCode, CollectionName, OfficerUserId, OfficerLastName, OfficerFirstName, Created
				FROM      WarehouseBatchCollection
			    WHERE     BatchNo = '#batch.BatchNo#'
				ORDER BY  CollectionCode
		</cfquery>		
		
		<cfif hasOrder.Ordermemo eq "">
		  
		  		<cfset pck = "#package.CollectionName#">
				
		  <cfelse>
		  
		  	    <cfset pck = "#hasOrder.Ordermemo#">
		  				
		  </cfif>
	
		<cfoutput> 
		<td><input type="text" name="Packaging" class="regularxxl" value="#pck#" style="width:400px" maxlength="70"></td>
		</cfoutput>
		
	</tr>
	
	<cfelse>
	
		<tr class="labelmedium2">
		  
		     <td><cf_tl id="Packaging"></td>
			 <td><cfoutput>#hasOrder.Ordermemo#</cfoutput></td>
			 
		 </tr>	 
		
	</cfif>
	
	<cfif hasOrder.recordcount eq "0">
			
		<tr class="labelmedium2"><td><cf_tl id="Delivery mode"></td>
		
		    <td>
			
			<cfquery name="DomainClass"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
			
					SELECT       DC.ServiceDomain, DC.Code, DC.Description, DC.ListingOrder, DC.ServiceType, DC.PointerRequest
					FROM         ServiceItem AS S INNER JOIN
					             Ref_ServiceItemDomain AS D ON S.ServiceDomain = D.Code INNER JOIN
					             Ref_ServiceItemDomainClass AS DC ON D.Code = DC.ServiceDomain
					WHERE        S.ServiceDomain = 'DEL' 
					AND          S.Operational = 1 
					AND          DC.Operational = 1 
					AND          S.Code IN  (SELECT   ServiceItem
					                         FROM     ServiceItemMission
					                         WHERE    Mission = '#batch.Mission#')
					ORDER BY     DC.ListingOrder
				
			 </cfquery>		
			
			 <select id="domainclass" name="domainclass" size="1" class="regularxxl">
				 <cfoutput query="DomainClass">
					<option value="#Code#" <cfif hasOrder.servicedomainclass eq Code>selected</cfif>>#Description#</option>
				</cfoutput>
			 </select>
			
			</td>
			
		</tr>
		
	<cfelse>
	
		<cfquery name="DomainClass"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
			
					SELECT       DC.ServiceDomain, DC.Code, DC.Description, DC.ListingOrder, DC.ServiceType, DC.PointerRequest
					FROM         ServiceItem AS S INNER JOIN
					             Ref_ServiceItemDomain AS D ON S.ServiceDomain = D.Code INNER JOIN
					             Ref_ServiceItemDomainClass AS DC ON D.Code = DC.ServiceDomain
					WHERE        S.ServiceDomain = 'DEL' 
					AND          DC.Code = '#hasOrder.servicedomainclass#'					
				
			 </cfquery>		
	
		<tr class="labelmedium2">
		    <td><cf_tl id="Delivery mode"></td>		
		    <td><cfoutput>#DomainClass.Description#</cfoutput></td>			
		</tr>		
	
	</cfif>	
	
	<cfif hasOrder.recordcount eq "0">
	
	<tr class="labelmedium2"><td><cf_tl id="Requested Delivery"></td><td>
	
	      <cfif hasOrder.OrderDate eq "">
		  
		  		<cfset dte = now()>
				
		  <cfelse>
		  
		  		<cfset dte = hasOrder.DateEffective>
				
		  </cfif>

	      <cf_intelliCalendarDate9
				FieldName="DateEffective" 
				Manual="True"		
				class="regularxxl"					
				DateValidStart="#Dateformat(Batch.TransactionDate, 'YYYYMMDD')#"
				Default="#Dateformat(dte, client.dateformatshow)#"					
				AllowBlank="False">	
	
	</td></tr>
	
	<cfelse>
	
	<tr class="labelmedium2"><td><cf_tl id="Requested Delivery"></td><td>
	
		<cfoutput>#Dateformat(hasOrder.DateEffective, client.dateformatshow)#</cfoutput>	   
	
	</td></tr>
	
	
	</cfif>
	
    <cfif hasOrder.recordcount eq "0">
	
	   <tr class="labelmedium2"><td><cf_tl id="Memo"></td><td>
	
       <cfoutput>
	   <input type="text" name="Comments" value="#hasOrder.WorkOrderLineMemo#" maxlength="80" class="regularxxl" style="width:500px">
	   </cfoutput>
	   
	   </td></tr>
	   
	<cfelse>
	
		<tr class="labelmedium2"><td><cf_tl id="Memo"></td><td>
	
		 <cfoutput>#hasOrder.WorkOrderLineMemo#</cfoutput>
		 
		  </td>
		</tr>
	
	</cfif>   
	
	<tr><td colspan="2" class="line"></td></tr>
		
	<cfif hasOrder.recordcount eq "0">
	 
		 <tr>
			 <td align="center" style="padding-top:5px">		 
			
			 
			     <cfoutput>
			 	 
			     <input type="button" 
				     style="width:200px" 
					 class="button10g" 
					 name="Submit" value="Submit" 
					 onclick="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('#session.root#/Warehouse/Application/Stock/Delivery/DeliverySubmit.cfm?batchid=#url.id#','content','','','POST','DeliveryEntry')">
					 
				</cfoutput>	 
					 
			 </td>
		 </tr>
		 
		 <tr><td colspan="2" id="content"></td></tr>
	
	<cfelse>	
	
		<cfquery name="get"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
			  		SELECT    *
					FROM      WorkOrderLineAction
					WHERE     WorkOrderid = '#url.id#' 
					AND       WorkOrderLine = '1' 
					AND       ActionClass = 'Delivery'		
				</cfquery>	
				
		<cfset url.ajaxid = get.WorkActionId>
		<cfparam name="url.mid" default="">
		<cfset wflnk = "#session.root#/Warehouse/Application/Stock/Delivery/DeliveryWorkflow.cfm">
		
		<cfoutput>
		<input type="hidden" id="workflowlink_#url.ajaxid#" value="#wflnk#"> 
		</cfoutput>
	    
	
		<tr>
		    <td colspan="2" id="content" style="padding-left:4px;padding-right:4px">	
			
			    
				<cfdiv id="#url.ajaxid#"  bind="url:#wflnk#?ajaxid=#url.ajaxid#&mid=#url.mid#"/>
		 
				<!---
				 <input type="hidden" 
				          id="workflowlinkprocess_#pk#" 
				          value="#wflnk#"> 
	  
	                --->
				
			</td>
			
		</tr>	
	
			 			 
	 </cfif> 	 
			
	
	</table>

</cfform>

<cfset ajaxonload("doCalendar")>