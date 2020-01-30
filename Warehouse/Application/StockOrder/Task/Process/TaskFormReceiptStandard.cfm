
<!---  
   make a header
   get for the same stock order id all the lines for the same shiptowarehouse 
   listing to record the quantity for the lines
   refresh each line   
   --->
   
<cfparam name="url.taskid"    default="EBC6CA41-A90B-460F-8B26-F02820803B4D">   
<cfparam name="url.actormode" default="recipient">   
<cfparam name="url.action"    default="add">   
<cfparam name="url.actionid"  default="">  

<cfquery name="getTask" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  	SELECT  T.*,
			WC.TaskOrderAttachmentEnforce
	FROM    RequestTask T  
			INNER JOIN Warehouse W
				ON T.SourceWarehouse = W.Warehouse
			INNER JOIN Ref_WarehouseClass WC
				ON W.WarehouseClass = WC.Code
	WHERE   T.TaskId = '#url.taskid#'	
</cfquery>

<cfquery name="LinesTask" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  	SELECT   O.OrgUnitName, 
             H.Contact, 
			 H.Mission,
			 H.DateDue, 
			 H.Reference, 
			 R.RequestDate, 
			 H.Category,
			 H.OrgUnit,
			 R.ItemNo, 
			 I.ItemDescription, 
			 I.ItemPrecision,
			 R.UoM, 
			 U.UoMDescription, 
			 R.RequestedQuantity, 
             T.TaskQuantity, 
			 T.StockOrderId,
			 T.RequestId,
			 T.TaskSerialNo,
			 T.TaskType,
			 T.ShipToDate, 
			 T.ShipToMode,
			 T.ShipToWarehouse, 
			 T.SourceWarehouse,
			 W.WarehouseName,
			 T.ShipToLocation,
			 
			  <!--- we retrieve already recorded / pending receipts --->
			  
			  (SELECT  ISNULL(SUM(TransactionQuantity),0)
              FROM    ItemTransaction P
			  WHERE   P.RequestId    = T.RequestId									
			  AND     P.TaskSerialNo = T.TaskSerialNo
			  <!--- make sure we have the shipping transactions 
			  AND     TransactionId IN (SELECT TransactionId 
			                            FROM   ItemTransactionShipping
										WHERE  TransactionId = T.TransactionId)
			  --->			  
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
			 Warehouse W ON T.ShipToWarehouse = W.Warehouse		 
	WHERE    T.StockOrderId    = '#getTask.StockOrderId#'	
	AND      T.ShipToWarehouse = '#getTask.ShipToWarehouse#'
	AND      T.ShipToMode      = '#getTask.ShipToMode#'
	AND      T.RecordStatus   != '3'
	
</cfquery>

<cfif linestask.recordcount eq "0">

	<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white" class="formpadding">
	<tr><td align="center" height="60" class="labelit">
		It appears that this task order has no (more) lines.
	</td></tr>
	</table>

	<cfabort>

</cfif>

<!---

<cfset qty = getTask.TaskQuantity - getTask.PickedQuantity>

<cfif qty lte "0">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white">
<tr><td align="center" height="60">
	<font face="Verdana" color="0080FF">It appears that this task order was fullfilled already</font>
</td></tr>
</table>

<cfabort>

</cfif>

--->

<cfquery name="getAction" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT TOP 1 A.*
	  FROM   RequestTask T, RequestTaskAction A
	  WHERE  T.RequestId    = A.RequestId
	  AND    T.TaskSerialNo = A.TaskSerialNo
	  AND    T.TaskId       = '#url.taskid#'
	  ORDER BY A.Created DESC
</cfquery>  

<cfif getTask.ShipToMode eq "Collect">
  
	<cf_screentop scroll="No" height="100%" layout="webapp" banner="gray"  user="yes" close="ColdFusion.Window.hide('dialogprocesstask')" bannerheight="60" line="no"  label="Process Taskorder : <b>Collection</b>">

<cfelse>

	<cf_screentop scroll="no" height="100%" layout="webapp" banner="gray" user="yes" close="ColdFusion.Window.hide('dialogprocesstask')" bannerheight="60" line="no" label="Process Taskorder : <b>Delivery</b>">

</cfif>

<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white" class="formpadding">
   	
	<tr class="hide"><td height="2" align="center" id="processtask"></td></tr> 	
	
	<td valign="top">
	
	<cfform method="POST" name="formtask">
	
	<table width="95%" cellspacing="0" cellpadding="0" bgcolor="white" align="center" class="formpadding">
	
		<cfoutput>
				
		   <cfif getTask.ShipToMode eq "Collect">
		   
		     <tr><td class="labelmedium"><b><cf_tl id="Issue"><cf_tl id="To"></td></tr>
			 <tr><td colspan="2" class="linedotted"></td></tr>
			 
		   	 <tr>
		   
			   <cfquery name="get" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				    SELECT * 
				    FROM   Warehouse 
				    WHERE  Warehouse = '#getTask.ShipToWarehouse#'
			   </cfquery>			
			   
			   <td class="labelit">#get.WarehouseName#:</td>
		   
		   <cfelse>
		   
		   		<tr>
		   		   
			    <cfquery name="get" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				    SELECT * 
				    FROM   Warehouse 
				    WHERE  Warehouse = '#getTask.SourceWarehouse#'
			  </cfquery>				  		   
			   
			   <td class="labelit">#get.WarehouseName#:</td>
			   
		   </cfif>
					   		   
		   <cfquery name="param" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT    *
			   FROM      Ref_ParameterMission
			   WHERE     Mission = '#get.mission#'  
		   </cfquery>
		   
		   <td height="20">		
		   
		   <table width="100%" cellspacing="0" cellpadding="0"><tr><td>
		   			   		
			<cfquery name="LocationList" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   W.*, W.Description+' '+W.StorageCode as LocationName, 
					         R.Description as LocationClassName
					FROM     WarehouseLocation W, Ref_WarehouseLocationClass R
					<cfif getTask.ShipToMode eq "Collect">
					WHERE    Warehouse = '#getTask.ShipToWarehouse#'		
					<cfelse>
					WHERE    Warehouse = '#getTask.SourceWarehouse#'	
					</cfif>
					AND      W.LocationClass = R.Code					
					AND      W.Operational = 1 
					<cfif getTask.StockOrderId neq "">
					AND      Location IN (SELECT Location FROM Taskorder WHERE StockOrderId = '#getTask.StockOrderId#')
					<cfelseif getAction.ActionLocation neq "">
					AND      Location = '#getAction.ActionLocation#'
					</cfif>
					<!--- move only to locations that have this stock item recorded --->
					AND      W.Location IN (
					                        SELECT Location
					                        FROM   ItemWarehouseLocation
											WHERE  Warehouse = W.Warehouse
											AND    Location  = W.Location
											AND    ItemNo    IN (#preservesinglequotes(LinesTask.ItemNo)#)
											)
					ORDER BY LocationClass
			</cfquery>	
			
			<cfif LocationList.recordcount eq "0">			
			
				<cfquery name="LocationList" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   W.*, W.Description+' '+W.StorageCode as LocationName, 
						         R.Description as LocationClassName
						FROM     WarehouseLocation W, Ref_WarehouseLocationClass R
						<cfif getTask.ShipToMode eq "Collect">
						WHERE    Warehouse = '#getTask.ShipToWarehouse#'		
						<cfelse>
						WHERE    Warehouse = '#getTask.SourceWarehouse#'	
						</cfif>
						AND      W.LocationClass = R.Code					
						AND      W.Operational = 1 					
						<!--- move only to locations that have this stock item recorded --->
						AND      W.Location IN (
					                        SELECT Location
					                        FROM   ItemWarehouseLocation
											WHERE  Warehouse = W.Warehouse
											AND    Location  = W.Location
											AND    ItemNo    IN (#preservesinglequotes(LinesTask.ItemNo)#)
											)
						ORDER BY LocationClass
				</cfquery>	
			
			</cfif>						
									
			<cfselect name="location"
	          group    = "LocationClassName"
	          query    = "LocationList"
			  selected = "#getAction.ActionLocation#"
	          value    = "Location"
	          display  = "LocationName"
			  class    = "regularxl"
	          visible  = "Yes"
	          enabled  = "Yes"
	          style    = "font:12px"/>		
			  
			  </td>
			  
			  <td class="label" align="right">
			  <!--- #getTask.Contact# --->
			  </td>
			  
			  </tr></table>			  		   
		   
		   </td>
	   </tr>	   	
	   
	   <tr>
	    <td class="labelit"><cf_tl id="Receipt No">*:</td>
		<td height="20">
		<input type="text" class="regularxl" name="BatchReference" size="15" maxlength="20">
	   </tr>	 
	   
	    <tr>
	    <td class="labelit"><cf_tl id="Usage">:</td>
		<td height="20">
										
			<!--- check categories that have supplies defined --->
			
			<cfquery name="Category" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_Category
				WHERE  Category IN ( 
								      SELECT DISTINCT I.Category 
	                                  FROM   AssetItem AI, Item I
									  WHERE  AI.ItemNo = I.ItemNo
									  AND    AI.Mission = '#LinesTask.mission#'
									  <!--- exists in the unit of the requester --->
									  AND    AI.AssetId IN (SELECT AssetId 
									                        FROM   AssetItemOrganization O
									                        WHERE  AI.AssetId = O.AssetId
															AND    O.OrgUnit = '#LinesTask.OrgUnit#') 
															
									  AND    AI.AssetId IN (SELECT DISTINCT AssetId 
										                    FROM   AssetItemSupply P																			   
															WHERE  AI.Assetid = P.Assetid)
									)					
							
			</cfquery>	
			
			<cfif Category.recordcount eq "0">
			
				<cfquery name="Category" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_Category
					WHERE  Category IN ( 
									      SELECT DISTINCT I.Category 
		                                  FROM   AssetItem AI, Item I
										  WHERE  AI.ItemNo = I.ItemNo
										  AND    AI.Mission = '#LinesTask.mission#'
										 															
										  AND    AI.AssetId IN (SELECT DISTINCT AssetId 
											                    FROM   AssetItemSupply P																			   
																WHERE  AI.Assetid = P.Assetid)
										)					
								
				</cfquery>	
						
			</cfif>
										
			<select name="category" class="regularxl" id="category" style="font:10px;width:228">				   
				<cfloop query="Category">
					<option value="#Category#" <cfif LinesTask.Category eq Category>selected</cfif>>#Description#</option>
				</cfloop>
				<cfif Category.recordcount eq "0">
					 <option value="">-- Any --</option>
				</cfif>				
			</select>	
							
			</td>
		</tr>			
	   
	   <tr>
	   
		<td class="labelit"><cf_tl id="Date">/<cf_tl id="Time">:</td>
		<td height="20">			
			  
		   <cfif getTask.ShipToMode eq "Deliver">
		   
		   	   <cf_getWarehouseTime warehouse="#getTask.ShipToWarehouse#">	
		   
			   <cfquery name="get" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT * 
				  FROM   Warehouse 
				  WHERE  Warehouse = '#getTask.ShipToWarehouse#'
			   </cfquery>			
			   
			   <!---
			   to be transferred to <font face="Verdana" size="2"><b><u>#get.WarehouseName#</font>
			   --->
		   
		   <cfelse>
		   
		      <cf_getWarehouseTime warehouse="#getTask.SourceWarehouse#">	
		   		   
			  <cfquery name="get" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT * 
				  FROM   Warehouse 
				  WHERE  Warehouse = '#getTask.SourceWarehouse#'
			  </cfquery>	
			  		   
			   <!---
			   to be issued from <b>#get.WarehouseName#</b>
			   --->
			   
		   </cfif>
					
		    <cfset hr = "#timeformat(localtime,'HH')#">
			<cfset mn = "#timeformat(localtime,'MM')#">
				 	 
			<table cellspacing="0" cellpadding="0">
			
				<tr>
				
				<td>
								
					<cf_intelliCalendarDate8
						FieldName="TransactionDate" 
						Default="#dateformat(localtime,CLIENT.DateFormatShow)#"
						Class="regularxl"
						AllowBlank="false"> 		
				
			    </td>
				
				<td>&nbsp;</td>
				
				<td>					
				
				<select name="Transaction_hour" id="Transaction_hour" style="height:23;font-size:13px">
				
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
				
				<select name="Transaction_minute" id="Transaction_minute" style="height:23;font-size:13px">
					
					<cfloop index="it" from="0" to="59" step="1">
					
						<cfif it lte "9">
						  <cfset it = "0#it#">
						</cfif>				 
						
						<option value="#it#" <cfif mn eq it>selected</cfif>>#it#</option>
					
					</cfloop>	
									
				</select>						
				
				</td>
				
				</tr>
				
			</table>			
        
	    </td>
						
	 </tr>				
							
	 <cfquery name="Actors" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT    *
		   FROM      Ref_TaskTypeActor
		   WHERE     Code = '#getTask.TaskType#'  
		   <cfif getTask.ShipToMode eq "Collect">   
		   AND       EnableTransaction = 1
		   </cfif>
		   ORDER BY  ListingOrder
	   </cfquery>
	   
	   <cfif getTask.ShipToMode eq "Collect">
	   			   
		   <cfset SetPerson = GetAction.PersonNo>
		  		   
	   <cfelse>
	   
		   <cfquery name="get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT   *
			   FROM     TaskOrder
			   <cfif getTask.StockOrderId neq "">
			   WHERE    StockOrderId = '#getTask.stockorderid#'	
			   <cfelse>
			   WHERE    1=0
			   </cfif>				   
		   </cfquery>
		   
		   <cfset SetPerson = get.PersonNo>
		   
		</cfif>   
			
		 <tr>
		    <td style="font:0px;"></td>
			<td style="font:0px;">
				<table cellspacing="0" cellpadding="0">
					<tr>
					    <td class="labelsmall" style="font:9px;width:100"><cf_tl id="Id"></td>
						<td class="labelsmall" style="font:9px;width:130;padding-left:7px"><cf_tl id="FirstName"></td>
						<td class="labelsmall" style="font:9px;width:130;padding-left:7px"><cf_tl id="LastName"></td>
					</tr>
					<tr><td colspan="3" class="linedotted"></td></tr>
				</table>
			</td>			
		</tr>
		   
		<cfloop query="Actors">
		
		<tr>
		  <td class="labelit">#Description#:</td>
		  
		  <td height="16">		
		  
		  	<table cellspacing="0" cellpadding="0">
		       		  
		  	<cfif entrymode eq "Lookup">	
			
			    <!--- inherit the first person --->  
			
				<cfset link = "#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/getEmployee.cfm?field=Actor_#role#">	
										
				<tr>
				<td>
				
				<cfif currentrow eq "1">
				    <!--- inherit the officer / driver --->
					<cfdiv bind="url:#link#&selected=#SetPerson#" id="person_#role#"/>
				<cfelse>
					<cfdiv bind="url:#link#" id="person_#role#"/>
				</cfif>
				
				</td>
				
				<td style="padding-left:3px">
				
				   <cf_selectlookup
				    box        = "person_#role#"
					link       = "#link#"
					button     = "Yes"
					icon       = "contract.gif"
					style      = "height:18;width:18"
					close      = "Yes"
					type       = "employee"
					des1       = "Selected">
					
				</td>
				
				</tr>
			
			<cfelse>
			
				<cfif currentrow eq "1">
								
					<cfquery name="get" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   SELECT    *
					   FROM      Person			  
					   WHERE     PersonNo = '#SetPerson#'				 		   
				    </cfquery>				
					
					<tr>
					   <td>
						<input type="text" name="reference_#role#" id="reference_#role#" value="#get.Reference#" style="width:100" maxlength="20" class="regularxl">						
						</td>
						<td style="padding-left:7px">
						<input type="text" name="firstname_#role#" id="firstname_#role#" value="#get.FirstName#" style="width:130" maxlength="40" class="regularxl">						
						</td>									
						<td style="padding-left:7px">
						<input type="text" name="lastname_#role#" id="lastname_#role#" value="#get.LastName#" style="width:130" maxlength="30" class="regularxl">						
						</td>
					</tr>
				
				<cfelse>
				
					<tr>
					   <td>
						<input type="text" name="reference_#role#" id="reference_#role#" value="" style="width:100" maxlength="20" class="regularxl">						
						</td>
						<td style="padding-left:7px">
						<input type="text" name="firstname_#role#" id="firstname_#role#" value="" style="width:130" maxlength="40" class="regularxl">						
						</td>									
						<td style="padding-left:7px">
						<input type="text" name="lastname_#role#" id="lastname_#role#" value="" style="width:130" maxlength="30" class="regularxl">
						</td>
					</tr>
				
				</cfif>				
							
			</cfif>			
			
			</table>
		 		  
		  </td>	
		</tr>	
		
		</cfloop>	
		
		<tr><td colspan="1" class="labelit" valign="top" style="padding-top:4px">Shipment</td>
			<td>	
			
			<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
			
			<tr>
				<td class="labelit">Product</td>
				<td class="labelit">Location</td>
				<td class="labelit" style="padding-left:4px">UoM</td>
				<td class="labelit" align="right">Tasked</td>
				<td class="labelit" align="right">Shipped</td>
				<td class="labelit" align="right">Receipt</td>			
			</tr>
			
			<tr><td colspan="6" class="linedotted"></td></tr>
					
			<cfloop query="LinesTask">
			
				<cf_precision precision="#ItemPrecision#">	
			
				<tr>
					<td Class="labelit" height="20">#ItemDescription#</td>
					<td>
														  
					   <cfif ShipToMode eq "Deliver">
					      <cfset whs = ShipToWarehouse>
					   <cfelse>
					      <cfset whs = SourceWarehouse>
					   </cfif>				   
					   
					   <cfquery name="getWarehouse" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT  *
						    FROM    Warehouse
							WHERE   Warehouse = '#whs#'						
						</cfquery>
						
					   <cfif PickedQuantity gte TaskQuantity>
					   
					        
					   
					   <cfelse>
					 			  			 			   
						   <cfselect name    = "StorageId_#left(taskid,8)#" 
						       style         = "width:170;font:10px" 
						   	   bind          = "cfc:service.Input.InputDropdown.getlocation('#whs#','#ItemNo#')"
							   bindonload    = "yes"
							   queryposition = "below"
						       value         = "storageid" 
							   display       = "Description" 	
							   selected      = "">				   <!--- #Location.storageid# --->
							   
						   </cfselect>
					   
					   </cfif>
				  				
					</td>
					<td Class="labelit" style="padding-left:4px">#UoMDescription#</td>
					<td Class="labelit" align="right">#numberformat(TaskQuantity,'#pformat#')#</td>
					<td Class="labelit" align="right">#numberformat(PickedQuantity,'#pformat#')#</td>
					<td Class="labelit" align="right" class="labelit" style="padding-left:4px">
					<cfif PickedQuantity gte TaskQuantity>
						<font color="008000">fulfilled</font>
					<cfelse>					
						<input type="text" 
						name="Quantity_#left(taskid,8)#" 
						style="padding-top:1px;width:40px;text-align:right;height:20px;padding-right:2px" value="0">
					</cfif>
					</td>		
				</tr>
							
			</cfloop>
			
			</table>
				
		</td></tr>
							
		<tr>
		  <td valign="top" style="padding-top:3px" class="labelit"><cf_tl id="Remarks">:</td>
		  <td>
		  <textarea name="Remarks" id="Remarks" totlength="100" class="regular" style="width:100%;height:60" onkeyup="return ismaxlength(this)"	></textarea>
		  </td>		
		</tr>
		
		<cf_assignid>
		
		<cfset batchid = rowguid>
		
		<tr>
		  <td class="labelit"><cf_tl id="Attachments"> <cfif getTask.TaskOrderAttachmentEnforce eq 1><font color="FF0000">*</font></cfif>:</td>
		  <td>
		  
		  <cf_filelibraryN 
			DocumentPath="WhsBatch" 
			SubDirectory="#BatchId#" 
			Filter="" 
			Insert="yes" 
			Remove="yes" 
			LoadScript="false" 
			rowHeader="no" 
			ShowSize="yes"> 
		  
		  </td>		
		</tr>			
		
		<tr><td colspan="2" class="linedotted" style="padding-top:4px;padding-bottom:4px"></td></tr>
		
		<tr><td colspan="2" align="center">
		
				<table cellspacing="0" cellpadding="0" class="formpadding">
				<tr>
								
				<td>
				<cf_tl id="Submit" var="1">
				
				<cf_button type="button" 
				       name="Submit"
					   id="Submit" 
					   value="#lt_text#" 					   
					   onclick="processtaskorderreceipt('#url.taskid#','#url.actormode#','receiptstandard','#url.action#','#url.actionid#','#batchid#')">
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




                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             