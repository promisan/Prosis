
<cfquery name="getTask" 
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
			 T.TaskType,
			 T.ShipToDate, 
			 T.ShipToMode,
			 T.ShipToWarehouse, 
			 T.SourceWarehouse,
			 W.WarehouseName,
			 T.ShipToLocation,
			 WC.TaskOrderAttachmentEnforce,
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
	FROM     RequestHeader H 
	         INNER JOIN  Request R ON H.Mission = R.Mission AND H.Reference = R.Reference 
			 INNER JOIN  RequestTask T ON R.RequestId = T.RequestId 
			 INNER JOIN  Organization.dbo.Organization O ON H.OrgUnit = O.OrgUnit 
			 INNER JOIN  ItemUoM U ON R.ItemNo = U.ItemNo AND R.UoM = U.UoM 
			 INNER JOIN  Item I ON R.ItemNo = I.ItemNo 
			 INNER JOIN  Warehouse W ON T.ShipToWarehouse = W.Warehouse
			 INNER JOIN  Warehouse WS ON T.SourceWarehouse = WS.Warehouse 
			 INNER JOIN  Ref_WarehouseClass WC ON WS.WarehouseClass = WC.Code 
	WHERE    T.TaskId = '#url.taskid#'	
</cfquery>

<cfset qty = getTask.TaskQuantity - getTask.PickedQuantity>

<cfif qty lte "0">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white" class="formpadding">
<tr><td align="center" height="60" class="labelit">
	<font color="0080FF">It appears that this task order was fulfilled already</font>
</td></tr>
</table>

<cfabort>

</cfif>

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
  
	<cf_screentop scroll="No" height="100%" html="Yes" layout="webapp" banner="green"  user="yes" close="ColdFusion.Window.hide('dialogprocesstask')" bannerheight="60" line="no"  label="Process Taskorder : <b>Collection</b>">

<cfelse>

	<cf_screentop scroll="no" height="100%" html="Yes" layout="webapp" banner="red" user="yes" close="ColdFusion.Window.hide('dialogprocesstask')" bannerheight="60" line="no" label="Process Taskorder : <b>Delivery</b>">

</cfif>

<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white" class="formpadding">

	<cfquery name="getmode" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT    *
		   FROM      Ref_ShipToMode
		   WHERE     Code = '#getTask.shiptomode#'  
		</cfquery>				
		
	<cfif getTask.ShipToMode eq "Collect">	
	
	<cfoutput>	
		<tr><td id="processtask"></td></tr>	
	</cfoutput>
	
	<cfelse>
		
	<cfoutput>	
	<tr><td>
		<table width="100%">
			<tr><td style="padding-top:4px" class="labellarge">#getMode.Description#</td><td align="right" id="processtask"></td></tr>
		</table>
	</td></tr>
	<tr><td class="linedotted"></td></tr>
	</cfoutput>
	
	</cfif>
	
	<tr>
		
	<td valign="top">
	
	<cfform method="POST" name="formtask">
	
	<table width="95%" cellspacing="0" cellpadding="0" bgcolor="white" align="center" class="formpadding">
	
		<cfoutput>
				
		   <cfif getTask.ShipToMode eq "Collect">
		   
		     <tr><td class="labelmedium" style="padding-right:4px"><b><i><cf_tl id="Issue"><cf_tl id="To"></td></tr>
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
			   
			   <td class="label">#get.WarehouseName#:</td>
		   
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
			   
			   <td class="labelit" style="padding-right:4px"><b><cf_tl id="From"></b>#get.WarehouseName#:<cf_space spaces="50"></td>
			   
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
					AND      W.Location IN (SELECT Location
					                        FROM   ItemWarehouseLocation
											WHERE  Warehouse = W.Warehouse
											AND    Location  = W.Location
											AND    ItemNo    = '#GetTask.ItemNo#'
											AND    UoM       = '#GetTask.UoM#')
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
						AND      W.Location IN (SELECT Location
						                        FROM   ItemWarehouseLocation
												WHERE  Warehouse = W.Warehouse
												AND    Location  = W.Location
												AND    ItemNo    = '#GetTask.ItemNo#'
												AND    UoM       = '#GetTask.UoM#')
						ORDER BY LocationClass
				</cfquery>	
			
			</cfif>						
									
			<cfselect name="location"
	          group    = "LocationClassName"
	          query    = "LocationList"
			  selected = "#getAction.ActionLocation#"
	          value    = "Location"
	          display  = "LocationName"
	          visible  = "Yes"
	          enabled  = "Yes"
			  class    = "enterastab regularxl"/>		
			  
			  </td>
			  
			  <td class="label" align="right">
			  <!--- #getTask.Contact# --->
			  </td>
			  
			  </tr></table>			  		   
		   
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
						Class="regularxl enterastab"
						AllowBlank="false"> 		
				
			    </td>
				
				<td>&nbsp;</td>
				
				<td>					
				
				<select name="Transaction_hour" class="enterastab" id="Transaction_hour" class="regularxl">
				
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
				
				<select name="Transaction_minute" class="enterastab" id="Transaction_minute" class="regularxl">
					
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
										  AND    AI.Mission = '#getTask.mission#'
										  
										   <!--- exists in the unit of the requester --->
									       AND    AI.AssetId IN (SELECT AssetId 
										                         FROM   AssetItemOrganization O
									                             WHERE  AI.AssetId = O.AssetId
															     AND    O.OrgUnit = '#getTask.OrgUnit#') 
										  
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
											  AND    AI.Mission = '#getTask.mission#'
											 										  
											  AND    AI.AssetId IN (SELECT DISTINCT AssetId 
												                    FROM   AssetItemSupply P																			   
																	WHERE  AI.Assetid = P.Assetid)
											)					
									
					</cfquery>	
								
				</cfif>
											
				<select name="category" id="category" class="enterastab regularxl">				   
					<cfloop query="Category">
						<option value="#Category#" <cfif getTask.Category eq Category>selected</cfif>>#Description#</option>
					</cfloop>
					<cfif Category.recordcount eq "0">
					 <option value="">-- Any --</option>
					</cfif>
				</select>	
				
				
				</td>
		</tr>
	 	   
	 <tr>
	    <td class="labelit"><cf_tl id="Receipt No"> <font color="FF0000">*</font>:</td>
		<td height="20">
		<input type="text" name="BatchReference" value="" class="enterastab regularxl" size="15" maxlength="20">
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
		  
		  <td height="13">		
		  
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
						<input type="text" class="enterastab regularxl" name="reference_#role#" id="reference_#role#" value="#get.Reference#" style="width:100" maxlength="20">						
						</td>
						<td style="padding-left:7px">
						<input type="text" class="enterastab regularxl" name="firstname_#role#" id="firstname_#role#" value="#get.FirstName#" style="width:130" maxlength="30">						
						</td>									
						<td style="padding-left:7px">
						<input type="text" class="enterastab regularxl" name="lastname_#role#" id="lastname_#role#"   value="#get.LastName#"  style="width:130" maxlength="40">						
						</td>
					</tr>
				
				<cfelse>
				
					<tr>
					   <td>
						<input type="text" class="enterastab regularxl" name="reference_#role#" id="reference_#role#" value="" style="width:100" maxlength="20">						
						</td>
						<td style="padding-left:7px">
						<input type="text" class="enterastab regularxl" name="firstname_#role#" id="firstname_#role#" value="" style="width:130" maxlength="30">						
						</td>									
						<td style="padding-left:7px">
						<input type="text" class="enterastab regularxl" name="lastname_#role#" id="lastname_#role#"  value="" style="width:130"  maxlength="40">
						</td>
					</tr>
				
				</cfif>
										
			</cfif>			
			
			</table>
		 		  
		  </td>	
		</tr>	
		
		</cfloop>	
		
		<tr>
		
		  <td height="20" class="labelit"><cf_tl id="Tasked Quantity">:</td>
		  <td class="labelmedium">  
		  <cf_precision precision="#getTask.ItemPrecision#">											
		  <b>#getTask.ItemDescription# <font size="5">#numberformat(getTask.TaskQuantity,'#pformat#')#</font> #getTask.UoMDescription# 			   
		  </td>	
		  		  
		</tr>			
		
		<tr>		  
		   <td colspan="2"><cfinclude template="TaskFormReceiptFuelDetail.cfm"></td>
		</tr>	
		
		<tr><td height="4"></td></tr>
		
		<cfif getTask.ShipToMode eq "Deliver">	
						
			<tr><td class="labelit"><cf_tl id="Seal">:</td>
			
				<td>
				
					<table cellspacing="0" cellpadding="0">
					
						<cfloop index="itm" from="1" to="5">
						
							<cfif itm eq "1" or itm eq "6"><tr></cfif>
							<td style="padding-right:6px" class="labelsmall">#itm#.</td>
							<td style="padding-right:6px">
							<input class="enterastab regular" type="text" name="Reference1_#itm#" id="Reference1_#itm#" maxlength="10" class="regular" style="width:60">
							</td>
							
						</cfloop>
							
					</table>
				
				</td>
			
			</tr>	
			
		</cfif>	
						
		<tr>
		  <td valign="top" style="padding-left:2px;padding-top:3px" class="labelit"><cf_tl id="Remarks">:</td>
		  <td>
		  <textarea name="Remarks" id="Remarks" totlength="100" class="regular enterastab" style="font-size:14px;padding:3px;width:100%;height:40" onkeyup="return ismaxlength(this)"	></textarea>
		  </td>		
		</tr>
		
		<cf_assignid>
		
		<cfset batchid = rowguid>
		
		<tr>
		  <td class="labelit"><cf_tl id="Attachments"> <cfif getTask.ShipToMode eq "Deliver" or (getTask.ShipToMode eq "Collect" and getTask.TaskOrderAttachmentEnforce eq 1)><font color="FF0000">*</font></cfif>:</td>
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
		
		<tr><td colspan="2" class="linedotted"></td></tr>
		
		
		<tr><td colspan="2" align="center">
		
				<table cellspacing="0" cellpadding="0" class="formpadding">
				<tr>
								
				<td style="padding-top:4px">
				<cf_tl id="Submit" var="1">
				
				<cfparam name="url.actionid" default="">
				
				<cfinput type="button" 
				       name="Submit"
					   id="Submit" 
					   class="button10s" style="width:180;height:24;font-size:13px"
					   value="#lt_text#" 					   
					   onclick="processtaskorderreceipt('#url.taskid#','#url.actormode#','receiptfuel','#url.action#','#url.actionid#','#batchid#')">
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



                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  