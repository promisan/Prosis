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

<cfparam name="form.selected" default="">

<cfif form.selected eq "">	
	
	<table width="100%" height="100%" bgcolor="white">
		<tr>
		<td bgcolor="white" width="100%" height="100%" align="center" class="labellarge">
			Please Select one or more tasked Lines
		</td>
		</tr>
	</table>
	<cfabort>

</cfif>

<cfif url.tasktype eq "Purchase">

	<cfquery name="GetTask" 
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
				 W.WarehouseName,			 	
				 T.TaskQuantity, 
				 T.ShipToDate, 
				 T.ShipToWarehouse, 
				 T.TaskType,
				 T.SourceRequisitionNo,
				 W.WarehouseName as ShipToWarehouseName,			 
				 T.TaskId,		
				 PL.PurchaseNo,
				 T.RecordStatus,
				 T.DeliveryStatus,
				 T.RequestId,		
				 T.TaskUoM,
				 T.TaskUoMQuantity,				 
				 T.ShipToMode,	 
				 T.TaskSerialNo,
				 P.OrgUnitVendor,
				 (SELECT OrgUnitName 
				  FROM   Organization.dbo.Organization 
				  WHERE  OrgUnit = P.OrgUnitvendor) as Vendor,	 			
				 T.Created as TaskedOn,
				 T.OfficerLastName as TaskedBy
				 
		FROM     RequestHeader H INNER JOIN
	             Request R ON H.Mission = R.Mission AND H.Reference = R.Reference INNER JOIN
	             RequestTask T ON R.RequestId = T.RequestId INNER JOIN
	             Organization.dbo.Organization O ON H.OrgUnit = O.OrgUnit INNER JOIN
	             ItemUoM U ON R.ItemNo = U.ItemNo AND R.UoM = U.UoM INNER JOIN
	             Item I ON R.ItemNo = I.ItemNo INNER JOIN
				 Warehouse W ON T.ShipToWarehouse = W.Warehouse INNER JOIN
				 Purchase.dbo.PurchaseLine PL ON T.SourceRequisitionNo = PL.RequisitionNo
				 INNER JOIN Purchase.dbo.Purchase P ON PL.PurchaseNo = P.PurchaseNo		 
			
		<cfif Form.Selected eq "">
		WHERE   1= 0
		<cfelse>
		WHERE   T.TaskId IN (#preservesinglequotes(form.selected)#)
		</cfif>
		ORDER BY P.OrgUnitVendor, ShipToDate, OrgUnitName
			
	</cfquery>	
	
	<cfset label = "Submit TaskOrder to Vendor">	
	
<cfelse>

	<cfquery name="GetTask" 
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
				 W.WarehouseName,			 	
				 T.TaskQuantity, 
				 T.ShipToDate, 
				 T.ShipToWarehouse, 
				 T.TaskType,
				 T.SourceRequisitionNo,
				 W.WarehouseName as ShipToWarehouseName,			 
				 T.TaskId,	
				 T.RecordStatus,
				 T.DeliveryStatus,
				 T.RequestId,		
				 T.TaskUoM,
				 T.TaskUoMQuantity,
				 T.ShipToMode,	 
				 T.TaskSerialNo,
				 T.SourceLocation,
				 S.Warehouse as SourceWarehouse,
				 S.WarehouseName as SourceWarehouseName,			
				 T.Created as TaskedOn,
				 T.OfficerLastName as TaskedBy
				 
		FROM     RequestHeader H INNER JOIN
	             Request R ON H.Mission = R.Mission AND H.Reference = R.Reference INNER JOIN
	             RequestTask T ON R.RequestId = T.RequestId INNER JOIN
	             Organization.dbo.Organization O ON H.OrgUnit = O.OrgUnit INNER JOIN
	             ItemUoM U ON R.ItemNo = U.ItemNo AND R.UoM = U.UoM INNER JOIN
	             Item I ON R.ItemNo = I.ItemNo INNER JOIN
				 Warehouse W ON T.ShipToWarehouse = W.Warehouse INNER JOIN			 
				 Warehouse S ON T.SourceWarehouse = S.Warehouse
			
		<cfif Form.Selected eq "">
		WHERE   1= 0
		<cfelse>
		WHERE   T.TaskId IN (#preservesinglequotes(form.selected)#) 
		</cfif>
		ORDER BY SourceWarehouse, ShipToDate, T.ShipToWarehouse
			
	</cfquery>
		
	<cfset label = "Issue Shipment Order to Depot">	

</cfif>

<cf_screentop height="100%" layout="webapp" 
	    user="yes" close="ColdFusion.Window.hide('dialogprocesstask')" line="no" banner="gray" bannerheight="60" label="#label#">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white" class="formpadding">
	
	<tr><td height="13" class="hide" id="processtask"></td></tr> 	
	
	<td valign="top">
			
	<cfform method="POST" name="formtask">
		
	<table width="94%" cellspacing="0" cellpadding="0" bgcolor="white" align="center" class="formpadding">
	
		<cfoutput>
		
		<cf_assignid>
		
		<input type="hidden" name="stockorderid" id="stockorderid"   value="#rowguid#">
		<input type="hidden" name="taskids"  id="taskids"      value="#form.selected#">
		
		<tr>
		
		  <cfif url.tasktype eq "purchase">
		  	  
			  <input type="hidden" name="vendor" id="vendor"     value="#getTask.OrgUnitVendor#">
			  <td height="25" width="100" class="labelit"><font color="808080">Vendor:</td>
			  <td width="40%" class="labelit">#getTask.Vendor#</td>		
			  
		  <cfelse>
		  
		  	  <input type="hidden" name="warehouse" id="warehouse"   value="#getTask.SourceWarehouse#">
			  <td height="25" class="labelit" width="100"><font color="808080">Facility:</td>
			  <td width="40%" class="labelit">#getTask.SourceWarehouseName#</td>		
			  
		  </cfif>	
		  <td height="22" class="labelit" width="100"><font color="808080">Order No:</td>
		  <td width="40%" class="labelit">				  
				  
		  <cfquery name="AssignNo" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     UPDATE  Ref_ParameterMission
				 SET     TaskOrderSerialNo = TaskOrderSerialNo+1
				 WHERE   Mission = '#url.mission#' 
		     </cfquery>
		
		  <cfquery name="LastNo" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     SELECT *
			     FROM   Ref_ParameterMission
				 WHERE  Mission = '#url.mission#'
		  </cfquery>
			  				  
		  <cfif LastNo.TaskOrderSerialNo lt 10>
		     <cfset pre = "000">
		  <cfelseif	LastNo.TaskOrderSerialNo lt 100>
		     <cfset pre = "00">
		  <cfelseif LastNo.TaskOrderSerialNo lt 1000>
		  	 <cfset pre = "0">
		  <cfelse>
		     <cfset pre = "">
		  </cfif>
		  
		  <cfset task = "#LastNo.TaskOrderPrefix#-#pre##LastNo.TaskOrderSerialNo#">
		  				  
		  #task#
		    
		  <input type="hidden" name="reference" id="reference" value="#task#">		  
		  
		  </td>	
		</tr>
		
		<cfif url.tasktype eq "internal">
		
		<tr>
			<td colspan="1" class="labelit"><font color="808080">Distribution&nbsp;through:&nbsp;</td>		
		    <td height="25" class="labelit">
			
			<cfquery name="LocationList" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   W.*, W.Description+' '+W.StorageCode as LocationName, 
					         R.Description as LocationClassName
					FROM     WarehouseLocation W, Ref_WarehouseLocationClass R					
					WHERE    Warehouse = '#getTask.SourceWarehouse#'	
					AND      W.LocationClass = R.Code					
					AND      W.Operational  = 1 
					AND      W.Distribution = 1
					<!--- move only to locations that have this stock item recorded --->
					AND      W.Location IN (SELECT Location
					                        FROM   ItemWarehouseLocation
											WHERE  Warehouse = W.Warehouse
											AND    Location  = W.Location
											AND    ItemNo    = '#GetTask.ItemNo#'
											AND    UoM       = '#GetTask.UoM#')
					ORDER BY LocationClass
			</cfquery>	
			
			<cfselect name="location"
		          group    = "LocationClassName"
		          query    = "LocationList"
				  selected = "#getTask.SourceLocation#"
		          value    = "Location"
		          display  = "LocationName"
		          visible  = "Yes"
		          enabled  = "Yes"
				  class    = "regularxl"/>		
			
			</td>
			
			<cfif getTask.ShipToMode neq "Collect">
			
				<td class="labelit">Driver:</td>
				<td class="labelit">			
				
				<cfquery name="Officer" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    *
						FROM      Person				
						WHERE     PersonStatus = '5'
						ORDER BY  LastName					
				</cfquery>	
				
				<select name="PersonNo" id="PersonNo" class="regularxl">	
				    <option value="">[select]</option>	
					<cfloop query="Officer">
						<option value="#PersonNo#">#FirstName# #LastName#</option>
					</cfloop>
				</select>		
				
				</td>
			
			</cfif>
		
		</tr>
			
		</cfif>
		
		<tr>
		  <td height="20" class="labelit"><font color="808080">Date:</td>
		  <td>
		  
		  <cf_intelliCalendarDate8
				FieldName="OrderDate" 
				Default="#dateformat(now(),CLIENT.DateFormatShow)#"
				Class="regularxl"
				AllowBlank="false"> 		
		  
		  </td>	
		
		  <td height="20" class="labelit"><font color="808080">Class:</td>
		  <td>
		  		  
			   <cfquery name="GetClass" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT * 
				  FROM   Ref_TaskOrderClass
	  		   </cfquery>
			  
			  <select name="TaskClass" id="TaskClass" class="regularxl">
				  <cfloop query="getClass">
					  <option value="#Code#">#Description#</option>
				  </cfloop>
			  </select>
		  		  
		  </td>	
		</tr>
		
		<tr>
		  <td valign="top" style="padding-top:4px" height="20" class="labelit"><font color="808080">Memo:</td>
		  <td colspan="3">
		  <textarea name="Remarks" id="Remarks" class="regular" totlength="200" style="padding:3px;width:98%;height:40" onkeyup="return ismaxlength(this)"></textarea>
		 		  
		  </td>		
		</tr>
		
		<tr><td height="5"></td></tr>
		
		<tr>
			<td colspan="4">		
		
			<cfset edit = "0">
			<cfinclude template="TaskDetail.cfm">		
			
			</td>
		</tr>		
				
		<tr>
		<td colspan="4" height="30" align="center">
		
			<table cellspacing="0" cellpadding="0" class="formpadding">
				<tr>
					<td>
					<input type="button" 
					       name="Submit" 
						   id="Submit" 
						   value="Save" 
						   class="button10s" 
						   style="width:150;height:23" 
						   onclick="submittaskorder('#url.mission#','#url.warehouse#','#url.tasktype#')">
					</td>
				</tr>
			</table>
		
		</td>
		</tr>
				
		</cfoutput>
	
	</table>
	
	</cfform>
		
	</td>
	</tr>

</table>

</cf_screentop>


