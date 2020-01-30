
<!--- ------------------------------------------------------- --->
<!--- this form is only used for receipt confirmation of fuel --->
<!--- ------------------------------------------------------- --->

<cfquery name="getTask" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  	SELECT   O.OrgUnitName, 
			 H.Mission,
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
			 T.StockOrderId,
			 T.ShipToDate, 
			 T.ShipToMode,
			 T.TaskType,
			 T.ShipToWarehouse, 
			 T.SourceWarehouse,
			 W.WarehouseName,
			 T.ShipToLocation,
			 WC.TaskOrderAttachmentEnforce,
			  (SELECT  ISNULL(SUM(TransactionQuantity),0)
              FROM    ItemTransaction P
			  WHERE   P.RequestId    = T.RequestId									
			  AND     P.TaskSerialNo = T.TaskSerialNo			  
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
			 Warehouse W ON T.ShipToWarehouse = W.Warehouse INNER JOIN
			 Warehouse WS ON T.SourceWarehouse = WS.Warehouse INNER JOIN
			 Ref_WarehouseClass WC ON WS.WarehouseClass = WC.Code
	<cfif url.action eq "add">			  
	WHERE    T.TaskId = '#url.taskid#'
	<cfelse>
	WHERE    T.TaskId = (SELECT TaskId 
	                     FROM   RequestTask R1, RequestTaskAction R2 
						 WHERE  R1.RequestId      = R2.Requestid 
						 AND    R1.TaskSerialNo   = R2.TaskSerialNo 
						 AND    R2.TaskActionId   = '#url.actionid#') 
	</cfif>
	
</cfquery>

<cfif getTask.StockOrderId eq "">
	
		<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white" class="formpadding">
		<tr><td class="labelit" align="center">No taskorder defined. Contact your administrator.</td></tr>
		</table>
	
	<cfabort>

</cfif>

<cfquery name="line" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   ItemTransaction
	 <cfif url.actionid eq "">	
	 WHERE 1=0
	 <cfelse>
	 WHERE TransactionId = '#url.actionid#'
	 </cfif>	
</cfquery> 

<cfif url.actionid neq "">

	<cfif line.recordcount eq "0">
	
		<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white" class="formpadding">
		<tr><td class="labelit" align="center">Receipt is no longer in database. Please refresh your screen.</td></tr>
		</table>
	
	<cfabort>

	</cfif>

</cfif>

 <cfquery name="param" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT    *
	   FROM      Ref_ParameterMission
	   WHERE     Mission = '#getTask.mission#'  
   </cfquery>

<cfquery name="get" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   ItemTransactionShipping
	 <cfif url.action eq "add">	
	 WHERE 1=0
	 <cfelse>
	 WHERE TransactionId = '#url.actionid#'
	 </cfif>	
</cfquery> 

<cfif getTask.PickedQuantity neq "">
	<cfset qty = getTask.TaskQuantity - getTask.PickedQuantity>
<cfelse>
    <cfset qty = getTask.TaskQuantity>
</cfif>	
  
<cf_screentop height="100%" layout="webapp" 
	    banner="green" 
		bannerforce="Yes"
		user="yes" 
		close="ColdFusion.Window.hide('dialogprocesstask')" 
		bannerheight="55" validateSession="No" line="no"
		label="Confirmation">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white" class="formpadding">
	
	<tr><td height="2" class="xxxhide" id="processtask"></td></tr> 	
	
	<td valign="top" height="100%" style="padding-top:6px">
	
	<cfform method="POST" name="formtask">
	
	<table width="92%" height="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="white" align="center" class="formpadding">
	
		<cfoutput>
		
			
	    <tr>
		   <td width="20%" class="labelit"><cf_tl id="Receiving facility/unit">:</td>		  
		   <td class="labelmedium">#getTask.WarehouseName# </td>
		</tr>   
		   
	   <tr>
	    <td width="20%" class="labelit">Request:</td>
		   <td class="labelmedium" style="cursor:pointer">
		   <b><a href onclick="javascript:mail2('0','#getTask.reference#')"><font color="0080C0">#getTask.Reference#</font></a></b>
		   </td>		    
	   </tr>
	   
	   <!--- ----------------------------------------- --->
	   <!--- ---------------show actors--------------- --->
	   <!--- ----------------------------------------- --->
		
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
	  	  				   
		<cfloop query="Actors">
		
		 <cfquery name="getActor" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT    *
		   FROM      WarehouseBatchActor
		   WHERE     BatchNo  = '#Line.TransactionBatchno#'  
		   AND       Role     = '#Role#'		   
	   </cfquery>
		
		<tr>
		  <td style="padding-left:10px" class="labelit">#Description#:</td>		  
		  <td style="padding-left:10px" class="labelit"><cfif getActor.ActorFirstName neq "">#getActor.ActorFirstName# #getActor.ActorLastName#<cfelse>n/a</cfif></td>	
		</tr>	
		
		</cfloop>		   
	   	
		<tr><td colspan="2">
		
		<!--- -------------------------------------------------- --->
		<!--- special code for UN to show the seals of a receipt --->
		<!--- -------------------------------------------------- --->
						
		<cfquery name="getTaskDetail" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT * 
		  FROM  TaskOrderDetail
		  WHERE StockOrderId = '#getTask.stockorderid#'
		  AND   TransactionId is NULL
		  ORDER BY DetailNo
		</cfquery>
		
		<table width="100%" style="border-top:0px dotted silver" cellspacing="0" cellpadding="0">
		
		<cfif getTaskDetail.recordcount gte "1">
		
			<tr>
				<td height="24" class="labelit" colspan="4" bgcolor="EBF7FE" style="padding:4px">Seals applied at Loading of Truck</td>							
			</tr>		
			<tr><td colspan="4" class="linedotted"></td></tr>	   
		
		    <tr bgcolor="F5FBFE">
				<td width="32" style="padding-left:3px" align="center"></td>
				<td style="padding:2px;" align="center">Top Hatch</td>
				<td style="padding:2px;" align="center">Issue Valves</td>
				<td style="padding:2px;" align="center">Foot Valves</td>				
			</tr>		
				
			<cfloop query="getTaskDetail">
			
				<tr>
					<td style="padding:1px;padding-left:10px" align="center">#DetailNo#.</td>
					<td style="padding:1px;" align="center">#Reference1#</td>
					<td style="padding:1px;" align="center">#Reference2#</td>
					<td style="padding:1px;" align="center">#Reference3#</td>
				</tr>
		
			</cfloop>	
			
			<cfquery name="getTaskDetailActual" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT * 
			  FROM  TaskOrderDetail
			  WHERE StockOrderId = '#gettask.stockorderid#'
			  AND   TransactionId = '#url.actionid#'
			  ORDER BY DetailNo
			</cfquery>
			
			<tr>
				<td bgcolor="f1f1f1" class="labelit" height="24" style="padding:4px" colspan="4">Seals recorded upon receipt</td>							
			</tr>
			<tr><td colspan="4" class="line"></td></tr>
			
			 <tr bgcolor="f8f8f8">
				<td width="32" style="padding-left:3px" align="center"></td>
				<td style="padding:2px;" align="center">Top Hatch</td>
				<td style="padding:2px;" align="center">Issue Valves</td>
				<td style="padding:2px;" align="center">Foot Valves</td>				
			</tr>		
						
			<cfloop query="getTaskDetailActual">
			
				<tr bgcolor="ffffff">
					<td style="padding:1px;padding-left:10px" align="center">#DetailNo#.</td>
					<td style="padding:1px;" align="center">#Reference1#</td>
					<td style="padding:1px;" align="center">#Reference2#</td>
					<td style="padding:1px;" align="center">#Reference3#</td>
				</tr>
		
			</cfloop>	
		
		</cfif>
		
		</table>
		
		</td>
		</tr>
		
		<!--- -------------------------------------------------- --->
		<!--- ---- END special code for UN to show the seals --- --->
		<!--- -------------------------------------------------- --->
		
		 <tr><td colspan="2" class="linedotted"></td></tr>  		   		
			
		<tr>   
		
		   <td class="labelit">Date:</td>	
		   
		   <td>
		   		 			 	  
			 <table cellspacing="0" cellpadding="0">
				<tr>				
				
				<td>
								
				<cfif get.recordcount eq "0">
				   <cfset dt = now()>
				<cfelse>
				   <cfset dt = get.ConfirmationDate>
				</cfif>
				
				<cfset hr = "#timeformat(dt,'HH')#">
				<cfset mn = "#timeformat(dt,'MM')#">
								
				<cf_intelliCalendarDate8
					FieldName="TransactionDate" 
					Default="#dateformat(dt,CLIENT.DateFormatShow)#"
					Class="regularxl"
					AllowBlank="false"> 	
					
			    </td>
											
				<td style="padding-left:3px">					
				
				<select name="Transaction_hour" id="Transaction_hour" class="regularxl">
				
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
				
				<select name="Transaction_minute" id="Transaction_minute" class="regularxl">
					
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
		  <td width="10%" style="height:22" class="labelit">Product:</td>
		  
		  <td>
		   <table width="100%" cellspacing="0" cellpadding="0">
		      <tr>
			  <td class="labelit">#getTask.ItemDescription# (#getTask.UoMDescription#)</td>	
			  <td class="labelit" align="right" bgcolor="ffffef" style="padding:2px;border:1px solid silver" width="80" align="center">
			      <cf_precision precision="#getTask.ItemPrecision#">			  										
			      <font size="3" color="black">#numberformat(abs(Line.TransactionQuantity),'#pformat#')#</font></b>
			  </td>			 
			  </tr>
		  </table>
		</tr>
		
		<cfset url.batchNo = line.transactionbatchno>	
		
		<cfif url.batchno neq "">
		
			<cfquery name="getBatch" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT * 
				  FROM  WarehouseBatch
				  WHERE BatchNo = '#url.batchno#'
			</cfquery>
			
			<tr><td class="labelit">Receipt No:</td>
				<td class="labelit"><b>#getBatch.BatchReference#</b></td>				
			</tr>
					
			<tr><td colspan="2">							
				<cfset editmode = "view">
				<cfinclude template="TaskFormReceiptFuelDetail.cfm">			
			</td></tr>
			
			<tr>
			  <td class="labelit"><cf_tl id="Attachments"><cfif getTask.ShipToMode eq "Collect" or (getTask.ShipToMode eq "Deliver" and getTask.TaskOrderAttachmentEnforce eq 1)><font color="FF0000">*</font></cfif>:</td>
			  <td>
			  
			  <!---
			  <cf_filelibraryN 
				DocumentPath  = "WhsBatch" 
				SubDirectory  = "#getBatch.BatchId#" 
				Filter        = "confirm_" 
				Insert        = "yes" 
				Remove        = "yes" 
				LoadScript    = "false" 
				rowHeader     = "no" 
				ShowSize      = "yes"> 
				--->
				
				  <cf_filelibraryN 
				DocumentPath  = "WhsBatch" 
				SubDirectory  = "#getBatch.BatchId#" 			
				Filter        = ""	
				Insert        = "yes" 
				Remove        = "no" 
				LoadScript    = "false" 
				rowHeader     = "no" 
				ShowSize      = "yes"> 
			  
			  </td>		
			</tr>
					
		</cfif>
		
		<tr><td class="labelit">Remarks:</td></tr>
				
		<tr height="100%">  
		
		  <td colspan="2" style="padding:0px" valign="top">		  
		  
		  <textarea name="ActionMemo"		            
		            class="regular"
		            style="border:1px solid silver;width: 100%;padding:3px;font-size:13px;height:45; background: FfFfFf;">#get.ConfirmationMemo#</textarea>
					
		 </td>			 	
		</tr>		
		
		<tr><td colspan="2" class="linedotted"></td></tr>
		
		<tr><td colspan="2" height="37" align="center">
		
			<table cellspacing="0" cellpadding="0" class="formpadding">
			<tr>	
			
			<td>
			
				<cf_button type    = "button" 
				       name    = "Deny" 
					   id      = "Deny"
					   value   = "Reject" 					   
					   onclick = "processtaskorderreceipt('#url.taskid#','#url.actormode#','ConfirmDeny','#url.action#','#url.actionid#','#getBatch.BatchId#')">
					   
			</td>					
			<td>
			
				<cf_button type    = "button" 
				       name    = "Submit" 
					   id      = "Submit"
					   value   = "Confirm" 					   
					   onclick = "processtaskorderreceipt('#url.taskid#','#url.actormode#','Confirm','#url.action#','#url.actionid#','#getBatch.BatchId#')">
					   
			</td>
			</tr>
			
			</table>
		
		</td></tr>
				
		</cfoutput>
	
	</table>
	
	</cfform>
	
	</td>
	</tr>

</table>

<cf_screenbottom layout="webapp">


