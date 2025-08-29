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
<cfquery name="Duplicate" 
	datasource="appsWorkorder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   W.WorkOrderId, 
	             W.WorkOrderLine, 
				 W.WorkorderLineId,
				 W.Reference,
				 WA.AssetId, 
				 WA.DateEffective, 
				 WA.DateExpiration, 
				 WA.OfficerUserId, 
				 WA.OfficerLastName, 
				 WA.OfficerFirstName, 
	             WA.Created
	   FROM      WorkorderLine W, WorkOrderLineAsset WA
	   WHERE     W.WorkOrderId     =  WA.WorkOrderId
	   AND       W.WorkOrderLine   =  WA.WorkOrderLine
	   AND       WA.TransactionId  <> '#detail.TransactionId#' 
	   AND       WA.Assetid        = '#detail.assetid#'
	   AND       W.Operational  = 1
	   AND       WA.Operational = 1
	   <cfif detail.dateExpiration eq "">
	   AND       WA.DateEffective  <= getDate() 
	   <cfelse>
	   AND       WA.DateEffective  <= '#detail.dateexpiration#' 
	   </cfif>
	   AND       (WA.DateExpiration >= '#detail.dateeffective#' or WA.DateExpiration is NULL)
	
	   <!--- same workorder area --->
	   AND       W.WorkOrderId IN
	                       (
						    SELECT   WorkOrderId
	                        FROM     WorkOrder
	                        WHERE    ServiceItem IN (SELECT Code 
							                         FROM   ServiceItem 
													 WHERE  ServiceDomain = '#service.servicedomain#')
							)							
						
</cfquery>

<cfoutput>

<cfset format = domain.displayformat>

<cfif duplicate.recordcount gte "1">	
	
	<cfloop query="Duplicate">	
	<tr><td height="26"></td>	    
	    <td colspan="#cols-1#" class="line labelmedium" bgcolor="yellow" style="padding-left:4px" align="center">
		<font color="black">
		<cf_stringtoformat value="#duplicate.reference#" format="#format#">								
		<b><cf_tl id="Attention">:</b> 
		 <cf_tl id="This device is assigned in the same period to another service item" class="message"> : <b>#val#</b>. &nbsp;<cf_tl id="Please click"> <a href="javascript:editworkorderline('#workorderlineid#')"><font color="0080C0"><b><font size="2"><cf_tl id="HERE"></font></b></font></a> <cf_tl id="to view">.
		</font>
	    </td>
	</tr>
	<tr><td></td>
	    <td colspan="#cols-1#" class="line">
	</cfloop>

</cfif>						
			
			
</cfoutput>			