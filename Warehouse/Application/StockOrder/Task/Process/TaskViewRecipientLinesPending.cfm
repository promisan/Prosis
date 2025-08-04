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
	

<cfquery name="pendingRequests" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
   SELECT     O.OrgUnitName, 
              H.Contact, 
			  H.DateDue, 
			  H.Reference, 
			  R.RequestDate, 
			  R.OriginalQuantity, 
			  R.ItemNo, 
			  I.ItemDescription, 
			  I.ItemPrecision, 
			  I.ItemShipmentMode, 
			  R.UoM, 
			  U.UoMDescription, 
              R.RequestedQuantity, 
			  H.ActionStatus, 
			  R.Status, 
			  Status.Description, 
			  R.RequestId, 
			  H.Mission, 
			  R.RequestType, 
			  H.RequestShipToMode, 
			  W.WarehouseName,
			  W.WarehouseClass
   FROM       RequestHeader H
              INNER JOIN Request R ON H.Mission = R.Mission AND H.Reference = R.Reference 
			  INNER JOIN Organization.dbo.Organization O ON H.OrgUnit = O.OrgUnit 
			  INNER JOIN ItemUoM U ON R.ItemNo = U.ItemNo AND R.UoM = U.UoM 
			  INNER JOIN Item I ON R.ItemNo = I.ItemNo 
			  INNER JOIN Status ON H.ActionStatus = Status.Status AND Status.Class = 'Header' 
			  INNER JOIN Warehouse W ON R.ShipToWarehouse = W.Warehouse
   WHERE      R.Status <> '9' 
   AND        H.Mission = '#url.mission#'  

   <!--- only tasked lines, not the pickticket lines  --->	
   AND       R.RequestType <> 'PickTicket' 
   
   <!--- not set as completed --->			 
   AND       H.ActionStatus < '5'
       
   <!--- no valid taskorder recorded --->
   AND       R.RequestId NOT IN
                          (SELECT    RequestId
                            FROM     RequestTask
                            WHERE    RequestId = R.RequestId
							AND      RecordStatus IN ('1','3'))
  
   <!--- and no actual shipment recorded --->
   AND       R.RequestId NOT IN
                          (SELECT    RequestId
                            FROM     ItemTransaction
                            WHERE    RequestId = R.RequestId)
								
   <cfif getAdministrator(url.mission) eq "1">
	
	<!--- no filtering --->
	
   <cfelse>	
	
	<!--- show only destination warehouses to which the user has accesss --->
	
	AND  (
		
				 R.ShipToWarehouse IN (
				 <!--- only if the user may indeed submit for the warehouse --->
				 #preservesinglequotes(requestaccess)#	
			     ) OR
				 R.ShipToWarehouse IN (
				 <!--- only if the user may indeed submit for the warehouse --->
				 #preservesinglequotes(facilityaccess)#	
			     )
			 )	
			   
	</cfif>								
							
   ORDER BY  R.ShiptoWarehouse, H.DateDue DESC
   
</cfquery>   


<cfquery name="Facility" dbtype="query">
	 SELECT DISTINCT WarehouseName
	 FROM   PendingRequests
</cfquery>

<cfoutput query="pendingRequests" group="WarehouseName">

	<cfif Facility.recordcount gt "1">
									
			<tr class="clsRequest"><td colspan="13" class="labelmedium creference" style="padding-left:20px">#WarehouseName#</td></tr>				
			<tr class="clsRequest"><td colspan="13" class="linedotted"></td></tr>
		
	</cfif>

	<!---  hidden
	<tr>
		<td colspan="13" class="labellarge" style="color:6688aa;height:35;font-size:20px">
		<i><cf_tl id="#Description#"></i></b>				
		</td>
	</tr>		
	<tr><td colspan="13" class="linedotted"></td></tr>
	--->
	
	<cfset prior = "">
	
	<cfoutput>	
	
	<cfif (WarehouseClass eq "PGC" and RequestDate gte now()-40) or WarehouseClass neq "PGC">
					
		<tr class="navigation_row clsRequest box#actionstatus#">
		
			<td></td>
			<td style="padding-left:3px cursor:pointer" class="labelit creference navigation_action" onclick="javascript:mail2('0','#reference#')">
				<cfif reference neq prior><font color="0080C0"><cfelse><font color="FFFFFF"></cfif>#Reference#
			</td>						
							
			<td style="padding-left:3px" class="labelit">#DateFormat(RequestDate,client.dateformatshow)#</td>
			<td style="padding-left:3px" class="labelit"><cfif len(Contact) gte "16">#left(Contact,15)#..<cfelse>#Contact#</cfif></td>
			<td style="padding-left:3px" class="labelit">#ItemDescription#</td>
			
			<cf_precision precision="#ItemPrecision#">		
			<td align="right" style="padding-left:3px;padding-right:4px" class="labelit">							
			  #numberformat(OriginalQuantity,'#pformat#')#							
			</td>				
			
			<td align="right" style="padding-left:3px;padding-right:4px" class="labelit">							
			  #numberformat(RequestedQuantity,'#pformat#')#							
			</td>
			<td bgcolor="fafafa"></td>
			<td bgcolor="fafafa"></td>
			<td class="labelit" style="padding-left:3px;padding-right:3px">#dateformat(DateDue,client.dateformatshow)#</td>
			<td bgcolor="fafafa"></td>
			
			<!---
			<td colspan="4" align="center" class="labelit creference" bgcolor="f1f1f1"><font color="808080"><i>-- #RequestShipToMode# by #dateformat(DateDue,client.dateformatshow)# --</td>
			--->
			
		</tr>
	
		<tr class="clsRequest"><td colspan="10" class="linedotted"></td>
	    	<td class="hide creference">#Reference# #WarehouseName#</td>
		</tr>
	
	</cfif>
	
	<cfset prior = Reference>
		
	</cfoutput>
		
</cfoutput>		
		
		