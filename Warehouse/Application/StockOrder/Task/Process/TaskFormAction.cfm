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

<cfquery name="getTask" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  	SELECT   O.OrgUnitName, 
             H.Contact, 
			 H.DateDue, 
			 H.Reference, 
			 R.RequestDate, 
			 R.ItemNo, 
			 I.ItemDescription, 
			 I.ItemPrecision,
			 R.UoM, 
			 U.UoMDescription, 
			 R.RequestedQuantity, 
             T.TaskQuantity, 
			 T.ShipToDate, 
			 T.ShipToMode,
			 T.StockOrderId,
			 T.ShipToWarehouse, 
			 T.SourceWarehouse,
			 W.WarehouseName,
			 T.ShipToLocation,
			 
			  (SELECT  ISNULL(SUM(TransactionQuantity),0)
              FROM    ItemTransaction P
			  WHERE   P.RequestId    = T.RequestId									
			  AND     P.TaskSerialNo = T.TaskSerialNo		
			  AND     P.ActionStatus = '1'	  
			  AND     P.TransactionQuantity > 0
			  AND     P.ActionStatus != '9') as PickedQuantity, 
			 
			 T.TaskId,
			 T.Created as TaskedOn,
			 T.OfficerLastName as TaskedBy
	FROM     RequestHeader H INNER JOIN
             Request R ON H.Mission = R.Mission AND H.Reference = R.Reference INNER JOIN
             RequestTask T ON R.RequestId = T.RequestId INNER JOIN
             Organization.dbo.Organization O ON H.OrgUnit = O.OrgUnit INNER JOIN
             ItemUoM U ON R.ItemNo = U.ItemNo AND R.UoM = U.UoM INNER JOIN
             Item I ON R.ItemNo = I.ItemNo INNER JOIN
			 Warehouse W ON T.SourceWarehouse = W.Warehouse		
	<cfif url.action eq "add">			  
	WHERE    T.TaskId = '#url.taskid#'
	<cfelse>
	WHERE    T.TaskId = (SELECT TaskId 
	                     FROM   RequestTask R1, RequestTaskAction R2 
						 WHERE  R1.RequestId = R2.Requestid 
						 AND    R1.TaskSerialNo = R2.TaskSerialNo 
						 AND    R2.TaskActionId = '#url.actionid#') 
	</cfif>
	
</cfquery>

<cfquery name="TaskOrder" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   TaskOrder
	 <cfif getTask.stockOrderId neq "">
	 WHERE  StockOrderId = '#getTask.stockOrderId#'
	 <cfelse>
	 WHERE 1= 0
	 </cfif>
</cfquery> 


<cfquery name="ShipToMode" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   Ref_ShipToMode
	 WHERE  Code = '#getTask.ShipToMode#'	
</cfquery> 

<cfif getTask.PickedQuantity neq "">
	<cfset qty = getTask.TaskQuantity - getTask.PickedQuantity>
<cfelse>
    <cfset qty = getTask.TaskQuantity>
</cfif>	

<cfif qty lte "0">
	
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white" class="formpadding">
	
	<tr><td align="center" height="60" class="labelit">
		<font color="0080FF">It appears that this task order was fulfilled already</font>
	</td></tr>
	</table>
	
	<cfabort>

</cfif>
  
<cf_screentop 
  height="100%" layout="webapp" banner="gray" close="ColdFusion.Window.hide('dialogprocesstask')" bannerheight="60" 
  label="#ShipToMode.Description# Notification">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white" class="formpadding">
	
	<tr><td height="2" class="xxhide" id="processtask"></td></tr> 	
	
	<td valign="top" height="100%">
	
	<cfform method="POST" name="formtask">
	
	<table width="94%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white" align="center" class="formpadding">
	
		<cfoutput>
		
	    <tr>
		   <td style="height:22px" class="labelit"><cf_tl id="Provider">:</td>
		   <td class="verdana" height="24">#getTask.WarehouseName#</td>
	    </tr>
		
				
		<tr>
		  <td style="height:22px" class="labelit"><cf_tl id="Item">:</td>
		  <td>#getTask.ItemDescription# / #getTask.UoMDescription#</td>	
		</tr>
		
		<tr>
		  <td style="height:22px" class="labelit"><cf_tl id="Tasked"><cf_tl id="Quantity">:</td>
		  <td>
		  
		  <cf_precision precision="#getTask.ItemPrecision#">											
		  #numberformat(getTask.TaskQuantity,'#pformat#')#		
		  		  
		  </td>	
		</tr>
						
		<cfquery name="LocationList" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   W.*, W.Location+' '+W.Description as LocationName, 
					         R.Description as LocationClassName
					FROM     WarehouseLocation W, Ref_WarehouseLocationClass R
					<cfif url.actormode eq "Recipient">
					WHERE    Warehouse = '#getTask.ShipToWarehouse#'		
					<cfelse>
					WHERE    Warehouse = '#getTask.SourceWarehouse#'	
					</cfif>
					AND      W.LocationClass = R.Code					
					AND      W.Operational = 1 
					<!--- move only to locations that have this stock item recorded --->
					AND      W.Location IN (SELECT Location
					                        FROM   ItemWarehouseLocation
											WHERE  Warehouse = W.Warehouse
											AND    Location  = W.Location
											AND    ItemNo    = '#GetTask.ItemNo#'
											AND    UoM       = '#GetTask.UoM#')
					ORDER BY LocationClass
			</cfquery>					
		
		<cfif url.actormode eq "Provider">
		
			  <tr>
			   <td style="height:22px" class="labelit"><cf_tl id="Issued"><cf_tl id="by">:</td>
			   <td class="verdana" height="24">
			   			   						
				<cfselect name="location"
		          group    = "LocationClassName"
		          query    = "LocationList"
				  selected = "#TaskOrder.Location#"
		          value    = "Location"
		          display  = "LocationName"
		          visible  = "Yes"
		          enabled  = "Yes"
				  class="regularxl"
		          style    = "font:10px"/>						  
			   
			   </td>
	    	</tr>
		
			<input type="hidden" name="warehouse" id="warehouse" value="#getTask.SourceWarehouse#">			
					
		</cfif>
						
		<cfquery name="Warehouse" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   Warehouse
			 WHERE  Warehouse = '#getTask.ShipToWarehouse#'			
		</cfquery> 
		
	    <tr>
		   <td style="height:22px" class="labelit"><cf_tl id="Receiver">:</td>
		   <td class="verdana" height="24">#Warehouse.WarehouseName#</td>
	    </tr>
		
		<cfquery name="get" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   RequestTaskAction
			 <cfif url.action eq "add">	
			 WHERE  1=0  
			 <cfelse>
			 WHERE  TaskActionId = '#url.actionid#'
			 </cfif>	
	   </cfquery> 
		
		<cfif url.actormode eq "Recipient">
		
			 <tr>
			   <td style="height:22px" class="labelit"><cf_tl id="Collected"><cf_tl id="By">:</td>
			   <td class="verdana" height="24">
			   
			   <cfif get.ActionLocation neq "">
			      <cfset loc = get.ActionLocation>
			   <cfelse>
			      <cfset loc = getTask.ShipToLocation>				   
			   </cfif>
											
				<cfselect name="location"
		          group    = "LocationClassName"
		          query    = "LocationList"
				  selected = "#loc#"
		          value    = "Location"
		          display  = "LocationName"
		          visible  = "Yes"
				  class="regularxl"
		          enabled  = "Yes"
		          style    = "font:10px"/>		
				  
				  <input type="hidden" name="warehouse" id="warehouse" value="#getTask.ShipToWarehouse#">
			
			</tr>		
			<!--- define the storage truck that is going to collect --->			
		
		</cfif>
	   
	    <tr>
		   <td style="height:22px" class="labelit"><cf_tl id="Notification">:</td>
		   <td class="verdana" height="20">
		   					   
		   <cfquery name="getAction" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				 SELECT   * 
				 FROM     Ref_TaskOrderAction
				 WHERE    ShipToMode  = '#getTask.ShipToMode#'
				 AND      Operational = 1
				 ORDER BY ListingOrder
		   </cfquery> 
		   
		   <cfif getAction.recordcount eq "0">
		   
		   	   <font color="FF0000">No types defined</font>
		   
		   <cfelse>
		   
			   <select name="ActionCode" id="ActionCode" class="regularxl">
			   <cfloop query="getAction">
				   <option value="#Code#" <cfif Code eq get.ActionCode>selected</cfif>>#Description#</option>
			   </cfloop>
			   </select>
		   
		   </cfif>
		   </td>
	   </tr>
	   
	   
	      
	   		   
	   <tr>
		<td style="height:22px" class="labelit"><cf_tl id="Date">/<cf_tl id="Time">:</td>
		<td>			 	
		 	  
			 <table cellspacing="0" cellpadding="0">
				<tr>
				
				<td>
				
				<cfif getTask.ShipToMode eq "Deliver">
		   
				   <cfquery name="whs" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT * 
					  FROM   Warehouse 
					  WHERE  Warehouse = '#getTask.ShipToWarehouse#'
				   </cfquery>			
				   			   
			   <cfelse>
			   		   
				    <cfquery name="whs" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT * 
					  FROM   Warehouse 
					  WHERE  Warehouse = '#getTask.SourceWarehouse#'
				  </cfquery>	
				   
			   </cfif>
				
				<cfif url.action eq "add">	
					<cfset dte = now()>
				<cfelse>
				    <cfset dte = get.DateTimePlanning>				
				</cfif>
				
				<cfset dte = DateAdd("h", whs.TimeZone, dte)>
			    <cfset hr = "#timeformat(dte,'HH')#">
				<cfset mn = "#timeformat(dte,'MM')#">	
								
				<cf_intelliCalendarDate8
					FieldName="TransactionDate" 
					Default="#dateformat(dte,CLIENT.DateFormatShow)#"
					Class="regularxl"
					AllowBlank="false"> 	
					
			    </td>
				
				<td>&nbsp;</td>
				
				<td>					
				
				<select name="Transaction_hour" id="Transaction_hour" style="font:13px">
				
					<cfloop index="it" from="0" to="23" step="1">
					
					<cfif it lte "9">
					  <cfset it = "0#it#">
					</cfif>				 
					
					  <option value="#it#" <cfif hr eq it>selected</cfif>>#it#</option>
					
					</cfloop>	
					
				</select>
				
				</td>
				<td>-</td>
				<td>
				
				<select name="Transaction_minute" id="Transaction_minute" style="font:13px">
					
						<cfloop index="it" from="0" to="59" step="1">
						
						<cfif it lte "9">
						  <cfset it = "0#it#">
						</cfif>				 
						
						<option value="#it#" <cfif mn eq it>selected</cfif>>#it#</option>
						
						</cfloop>	
									
				</select>						
				
				</td></tr>
				</table>			
        
	    </td>
						
		</tr>			
		
		<tr>
		   <td style="height:22px" style="padding-top:5px" valign="top" class="labelit"><cf_tl id="Officer">:</td>
		   <td>
		   		
			   <table cellspacing="0" cellpadding="0">
			   
			   <!--- made this manual for MINUSTAH 5/8/2012 --->
			   
			   <tr>
			    <td class="labelsmall">First:</td>
				<td style="padding-left:4px" class="labelsmall">Last:</td>
			   </tr>	
			   
			   <tr>			 
			   <td><input type="text" name="PersonFirstName" value="#get.PersonFirstName#" class="regularxl"></td>			  
			   <td style="padding-left:4px"><input type="text" name="PersonLastName" value="#get.PersonLastName#" class="regularxl"></td>
			   </tr>
			   
			   <!---
			   <tr>
			      <td>
			   		   				
				  <cfset link = "#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/getEmployee.cfm?field=PersonNo">	
							   
			      <cf_selectlookup
					    box        = "person"
						link       = "#link#"
						button     = "Yes"
						icon       = "contract.gif"
						style      = "height:18;width:18"
						close      = "Yes"
						type       = "employee"
						des1       = "Selected">
			   
			      </td>		
				  <td width="2"></td>   
			      <td>
				  
				  <cfif url.action eq "add">	
				     <cfdiv bind="url:#link#&selected=#Taskorder.PersonNo#" id="person"/>
				  <cfelse>
				     <cfdiv bind="url:#link#&selected=#get.PersonNo#" id="person"/>
				  </cfif>
				  
				  </td>
			   
			   </tr>	
			   --->	   
			   </table>
			   
			  </td> 
		   
	   </tr>		
		
														
		<tr>
		  <td style="height:16px" colspan="2" class="labelit"><cf_tl id="Message">:</td>
		</tr>
		<tr>  
		  <td height="100%" valign="top" colspan="2" style="padding:2px">		
		    
		  <textarea name="ActionMemo"		            
		            class="regular"
		            style="border:1px solid silver;padding:4px;width: 100%;height:100%; background: FaFaFa;">#get.actionmemo#</textarea>
		 </td>			 	
		</tr>
		
		<tr><td colspan="2" class="linedotted"></td></tr>
		
		<tr><td colspan="0" height="37" align="center" class="formpadding">
		
			<table cellspacing="0" cellpadding="0" class="formpadding">
			
			<tr>
									
			<cfif getAction.recordcount gte "1">
			
				<td>
				
					<cf_tl id="Submit" var="1">
				
					<input type="button" 
					       name="Submit" 
						   id="Submit"
						   value="#lt_text#" 
						   class="button10s" 
						   style="width:120;height:23" 
						   onclick="processtaskorderreceipt('#url.taskid#','#url.actormode#','action','#url.action#','#url.actionid#','')">
						   
				</td>
				
			</cfif>
						
			</tr>
			
			</table>
		
		</td></tr>
				
		</cfoutput>
	
	</table>
	
	</cfform>
	
	</td>
	</tr>

</table>

</cf_screentop>


