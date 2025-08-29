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
<cfparam name="url.view"       default="Pending">
<cfparam name="url.editmode"   default="Edit">
<cfparam name="Form.Reference" default="">
<cfparam name="Form.datestart" default="">
<cfparam name="Form.dateend"   default="">

<cfquery name="Param" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT     *
	FROM       Ref_ParameterMission
	WHERE      Mission = '#url.mission#'	
</cfquery>

<cfset diff = (100+param.taskorderdifference)/100>   

<cfset condition = "">
  
<cfif Form.Reference neq "">
        <cfset condition  = "#condition# AND (R.Reference LIKE '%#Form.Reference#%')">
</cfif>	
  
<cfif Form.DateStart neq "">

     <cfset dateValue = "">
	 <CF_DateConvert Value="#Form.DateStart#">
	 <cfset dte = dateValue>
	 <cfset condition = "#condition# AND R.RequestDate >= #dte#">
	 
</cfif>	
  
<cfif Form.DateEnd neq "">

	 <cfset dateValue = "">
	 <CF_DateConvert Value="#Form.DateEnd#">
	 <cfset dte = dateValue>
	 <cfset condition = "#condition# AND R.RequestDate <= #dte#">
	 
</cfif>	
  
<cfparam name="url.ItemLocationId" default="">  
  
<cfif url.itemlocationid eq "">
  
	<cfquery name="Result" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     R.Reference,
		           R.RequestId,
		           R.ItemNo,
		           R.Created,
				   H.DateDue,
				   R.RequestType,
				   R.StandardCost,
				   R.UoMMultiplier,
				   R.ShipToWarehouse,
				   R.RequestedQuantity, 
				   R.Status,
				   H.ActionStatus,
		           I.ItemDescription,
			       U.UoMDescription,
			       I.Classification,
			       I.ItemClass,
				   I.ItemPrecision,
			       S.Description2 as Description,
			       S.ListingOrder,		
				   
				   (SELECT Description FROM Ref_Category WHERE Category = H.Category) as CategoryName,
				   	   
				   	 ( 
					    SELECT TOP 1 TaskId 
					    FROM   RequestTask 
						WHERE  Requestid = R.RequestId
						AND    RecordStatus = 1		
						AND    (StockOrderId is NOT NULL or ShipToMode = 'Collect')
					 ) as isTasked,	
					 											
					 ( 
					   	SELECT  ISNULL(SUM(TransactionQuantity),0) 
						FROM    ItemTransaction T
						WHERE   RequestId = R.RequestId
						AND     TransactionType IN ('1','6','8') <!--- maybe better to drop and take any positive transaction type --->
						AND     TransactionQuantity > 0			
				     ) as Received,		
					 	   
				     ( 
					   	SELECT  ISNULL(SUM(TransactionQuantity*-1),0) 
						FROM    ItemTransaction T
						WHERE   RequestId = R.RequestId
						AND     TransactionType = '2'
					 ) as Issued
											   
		FROM       RequestHeader H, 
		           Request R, 			  
			       Item I,
			       ItemUoM U,
			       Status S
				   
		WHERE      H.Reference = R.Reference
		  AND      I.ItemNo    = R.ItemNo
		  AND      U.ItemNo    = R.ItemNo
		  AND      U.UoM       = R.UoM	 
		  AND      R.ShipToWarehouse is NULL 
		  AND      H.OfficerUserId = '#SESSION.acc#'
			  
		  <cfif URL.view eq "pending">		  
		  AND      R.Status < '3' 	  
		  <cfelse>  
		  AND      R.Status = '3'
		  </cfif>
		  
		  #preservesingleQuotes(condition)#
		  		  		  
		  AND      S.Class  = 'Request'
		  AND      S.Status = R.Status
		 	 
		  ORDER BY ListingOrder, H.Reference
		  
	</cfquery>
	
<cfelse>

	<cfquery name="ItemLoc" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   ItemWarehouseLocation
			WHERE  ItemLocationId = '#url.itemlocationid#'
	</cfquery>		
	 
	<cfquery name="Result" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     R.Reference,
		           R.RequestId,
		           R.ItemNo,
		           H.DateDue,
				   R.Remarks,
				   R.RequestType,
				   R.StandardCost,
				   R.UoMMultiplier, 
				   R.ShipToWarehouse,
				   R.Status,
				   D.RequestedQuantity,
				   R.RequestedQuantity as RequestQuantityTotal,
		           I.ItemDescription,
			       U.UoMDescription,
			       I.Classification,
			       I.ItemClass,
				   I.ItemPrecision,
				   H.ActionStatus,
			       HS.Description2 as Description,
			       HS.ListingOrder,		
				  			       
				   <!--- get the category --->
				   (SELECT Description FROM Ref_Category WHERE Category = H.Category) as CategoryName,
				   	   
					 <!--- was tasked --->
					   
				   	 ( 
					    SELECT TOP 1 TaskId 
					    FROM   RequestTask 
						WHERE  Requestid = R.RequestId
						AND    RecordStatus = 1		
						AND    StockOrderId is NOT NULL 
					 ) as isTasked,	
					 					
					  ( 
					   	SELECT  ISNULL(SUM(TransactionQuantity),0) 
						FROM    ItemTransaction T
						WHERE   RequestId = R.RequestId
						AND     TransactionType IN ('1','6','8') 
						AND     TransactionQuantity > 0			
				     ) as isReceived,		
					 					 
					 <!--- was processed --->
					 
					  ( 
					    SELECT TOP 1 TransactionId 
					    FROM   ItemTransaction
						WHERE  Requestid = R.Requestid
						<!--- 
						AND    RecordStatus = 1
						--->
						
					 ) as isProcessed,	
					 						 										
					 ( 
					   	SELECT  ISNULL(SUM(TransactionQuantity),0) 
						FROM    ItemTransaction T
						WHERE   RequestId    = R.RequestId
						AND     Warehouse    = D.ShipToWarehouse						
						AND     Location     = D.ShipToLocation								
						<!--- receipt or transfer --->				
						AND     TransactionType IN ('1','6','8')  <!--- maybe better to drop and take any positive transaction type --->
						AND     TransactionQuantity > 0			
				     ) as Received,			   
					 
				     ( 
					   	SELECT  ISNULL(SUM(TransactionQuantity*-1),0) 
						FROM    ItemTransaction T
						WHERE   RequestId    = R.RequestId
						AND     Warehouse    = D.ShipToWarehouse
						AND     Location     = D.ShipToLocation
						AND     TransactionType = '2'
					 ) as Issued
											   
		FROM       RequestHeader H, 
		           Request R, 	
				   RequestDetail D,		  
			       Item I,
			       ItemUoM U,
			       Status HS
				   
		WHERE      H.Reference       = R.Reference
		  AND      I.ItemNo          = R.ItemNo
		  AND      U.ItemNo          = R.ItemNo
		  AND      U.UoM             = R.UoM
	      AND      R.ItemNo          = '#ItemLoc.ItemNo#' 
		  AND      R.UoM             = '#ItemLoc.UoM#'		  
		  AND      D.RequestId       = R.RequestId		
		  AND      D.ShipToWarehouse = '#ItemLoc.Warehouse#'
		  AND      D.ShipToLocation  = '#ItemLoc.Location#'  		  
		  
		  <cfif URL.view eq "pending">		
		  	   
		  AND      
		           (
		  
		  				( 
						
			  			    R.RequestedQuantity > 
						
							    (
								   (SELECT  ISNULL(SUM(TransactionQuantity),0)*#diff# 
									FROM    ItemTransaction T
									WHERE   RequestId  = R.RequestId
									AND     TransactionType IN ('1','6','8') <!--- maybe better to drop and take any positive transaction type --->
									AND     TransactionQuantity > 0	)
									+
																
								   (SELECT ISNULL(SUM(TaskQuantity),0)
									FROM   RequestTask
									WHERE  RequestId = R.RequestId							
									AND    RecordStatus = '3')
								)		
							
							AND  R.Status != '9'					
						
						)
		  
					   OR 
		           
					   	<!--- we temporariry show denied lines --->
			           (R.Status = '9' AND R.Created > getDate() - 7) 
					   
				   ) 
				   
				    AND      H.ActionStatus < '5'
				   
		  <cfelse>  
		  
		  AND      R.Status = '3'
		  </cfif>
		  
		  #preservesingleQuotes(condition)#
		  
		  AND      HS.Class = 'Header'
		  AND      HS.Status = H.ActionStatus
		  
		 
		 	 
		  ORDER BY ListingOrder, H.Reference		  
		  
	</cfquery>	
	

</cfif>

<cfif result.recordcount eq "0">

	<table width="100%" align="center" height="40">
		<tr><td align="center" class="label" height="40"><cf_tl id="There are no records to show in this view" class="message"></td></tr>
	</table>

<cfelse>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">

<TR>
	
	<cfif url.view eq "pending">
		<td></td>
		<TD height="20" class="labelit" width="14%"><cf_tl id="Reference"></TD>		
	<cfelse>
		<td width="2%"></td>	
	</cfif>
	
	<cfif url.itemlocationid eq "">
		<TD width="17%" class="labelit"><cf_tl id="Item"></TD>		
		<TD width="5%" class="labelit"><cf_tl id="Code"></TD>
		<TD width="21%" class="labelit"><cf_tl id="Destination"></TD>	
	<cfelse>
		<td colspan="3" width="30"><cf_tl id="Usage"></td>
	</cfif>	

	<TD width="8%" class="labelit"><cf_tl id="Date"></TD>			
	<TD align="right" class="labelit" width="8%" style="padding-right:4px"><cf_tl id="UoM"></TD>
	<TD align="right" class="labelit" width="12%"><cf_tl id="Quantity"></TD>	
	<TD width="10%" class="labelit" align="right" style="padding-right:5px"><cf_tl id="Status"></TD>	
	<TD align="right" class="labelit" width="12%" style="padding-left:6px"><cf_tl id="Ship"></TD>	
	
	<cfif Param.RequestEnablePrice eq "1">
		<TD align="right" width="12%"><cf_tl id="Price"></TD>
		<TD align="right" width="12%"><cf_tl id="Amount"></TD>
	<cfelse>
		<td width="1%"></td>
		<td width="1%"></td>
	</cfif>	
	<td></td>
	
</TR>
	
<cfoutput query="Result" group="ListingOrder">
		
	<cfif URL.view eq "Pending">	
			
		<tr>
			<td height="1" colspan="13" class="linedotted"></td></tr>
				<cfif status eq "i">
				<tr><td height="23" colspan="13" align="left">&nbsp;
				<img src="#SESSION.root#/images/status_pending.gif" alt="" align="absmiddle"  border="0">
				<cfelseif status eq "2b">
				<tr><td height="38" colspan="13" align="left">&nbsp;
				<img src="#SESSION.root#/images/backorder.gif" alt="" border="0">
				</cfif>
			</td>
		</tr>
	
	</cfif>

	<cfoutput group="Reference">
	
	<cfset total = 0>		
		
	<cfif URL.view neq "Pending">	
	
		<tr>
		
			<td colspan="13" height="20" style="padding-top:6px;padding-left:5px">
			    
				<table cellspacing="0" cellpadding="0">
				<tr>
				<td class="labelit">
				<a href="javascript:mail2('print','#Reference#')">
				  <font color="0080C0">#Reference#</font>
				</a>				
				</td>
				<td>&nbsp;</td>				
				<td>				
				<img src="#SESSION.root#/images/print_small5.gif" 
				    align="absmiddle" 
					style="cursor:pointer"
					alt="Print Requisition" 
					border="0" 
					onclick="mail2('print','#Reference#')">			
					
				</td></tr></table>						
			</td>
		
		</tr>
		
		
		<tr><td colspan="13" class="linedotted"></td></tr>
			
	</cfif>
			
	<cfset row = "0">
	
	<cfoutput>
	
		<cfif status eq "9">
		    <cfset cl = "FFA477">
		<cfelse>
			<cfset cl = "white">
		</cfif>		
		
		<cfset row = row+1>
	
		<!--- cart info --->
			
		<TR bgcolor="#cl#">
		
		<td width="3%" height="18" style="padding-left:10px;padding-right:5px">
		
				<img src="#SESSION.root#/Images/arrow.gif" alt="More details" 
					id="#requestid#Exp" border="0" class="show" 
					align="absmiddle" style="cursor: pointer;" 
					onClick="more('#requestId#')">
					
				<img src="#SESSION.root#/Images/arrowdown.gif" 
					id="#requestid#Min" alt="More details" border="0" 
					align="absmiddle" class="hide" style="cursor: pointer;" 
					onClick="more('#requestid#')">
					
		</td>	
		
		<cfif url.view eq "pending">
		
			<td>
				<a href="javascript:mail2('print','#reference#')">
				  <cf_space spaces="40">
				  <font face="Verdana" color="0080C0">#Reference#</font>
				</a>
								
			</td>	
			
		</cfif>
		
		<cfif url.itemlocationid eq "">
		
		<TD class="labelit"><a href="javascript:more('#requestId#')" title="More details">#ItemDescription#</a></TD>	
		<TD class="labelit">#ItemNo#</TD>	
		<TD onClick="more('#requestId#')" style="cursor: pointer;">		
		
		  <cfif shiptowarehouse neq "">
				
				<cfquery name="Ship" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT     Warehouse, 
				           WarehouseName 					  
				FROM       Warehouse 
				WHERE      Warehouse = '#ShipToWarehouse#' 				 
				</cfquery>
				
				#Ship.WarehouseName# 
		
		  </cfif>
			
		</TD>		
		
		<cfelse>
		
		<td colspan="3" class="labelit">#CategoryName#</td>
		
		</cfif>
					
		<td class="labelit">#Dateformat(DateDue, CLIENT.DateFormatShow)#</td>			
		
		<TD align="right" class="labelit" style="padding-right:1px">#UoMDescription#</TD>
		
		<TD align="right" class="labelit" style="padding-right:1px">
		 
		    <cfif (status eq "i" or status eq "1") and isTasked eq "" and editmode eq "edit">
			
			   <input type="text"
			       name="quantity"
				   id="quantity"
			       value="#RequestedQuantity#"
			       size="2"
				   class="regular" 
			       maxlength="5"
			       style="text-align: center;background-color : ffffdf;"
			       onchange="reqedit('#requestId#',this.value)">		 
			   
		   <cfelse>
		   
			    <cf_precision precision="#itemprecision#">
		   		#NumberFormat(RequestedQuantity,'#pformat#')#  
				 			
		   </cfif>
		   
		</TD>
		
		<td align="right" style="padding-right:5px" class="labelit">	
		   <cfif ActionStatus eq "9"><font color="FF0000">#Description#</font><cfelse>#Description#</cfif>
		</td>
		
		<cfif url.itemlocationid eq "">
				
			<td align="right" style="padding-right:4px" class="labelit">
				<cfif issued neq "0">#Issued#<cfelse>#Received#</cfif>
			</td>		
		
		<cfelse>
			
			<td align="right" style="padding-right:4px" class="labelit">					
				<cfif isReceived gt 0 and Status neq "3">Partial<cfelseif status eq "5">Complete<cfelse>--</cfif>			
			</td>	
		
		</cfif>
		
		<cfif Param.RequestEnablePrice eq "1">
		
			<td align="right" style="padding-right:4px" class="labelit">#NumberFormat(StandardCost*UoMMultiplier,'__,____.__')#</td>
			
			<cfset amt = StandardCost*UoMMultiplier*RequestedQuantity>
			
			<td align="right" id="amount_#requestId#" class="labelit">#NumberFormat(amt,'__,____.__')#</td>
			
			<cfset total = total + amt>
			
		<cfelse>
		
			<td></td>	
			<td></td>
				
		</cfif>
		
		<td width="2%" align="center">
				
		   <cfif isTasked eq "" and Issued eq "0" and Received eq "0" and editmode eq "edit">
	       
			   <cfif status eq "i"  or status eq "1"> 
			   
			       <a href="javascript:reqpurge('#requestid#','#URL.ItemLocationId#')">
				   
			           <img src="#SESSION.root#/images/delete5.gif" 
					        alt="Purge" name="Cancel" id="Cancel" width="11" 
							height="11" border="0" align="middle">
							
			       </a>
				   
			   </cfif>
		   
		   </cfif>
		   
	    </td>
		
		</TR>
				
		<tr id="b#RequestId#" class="hide"><td colspan="13" style="padding:2px" id="i#RequestId#"></td></tr>				
				
		<cfset uom = uomdescription>
		
		<cfif URL.view neq "Pending">
			
			<cfquery name="shiplist" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     IT.TransactionId,
				           IT.Warehouse, 
				           IT.ItemDescription, 
						   IT.TransactionQuantity, 
						   IT.TransactionDate,
						   IT.ItemNo,
						   IT.ItemDescription,
						   U.UoMDescription, 
						   IT.TransactionCostPrice, 
						   IT.TransactionValue, 
						   IT.Location, 
						   IT.TransactionBatchNo,
						   S.ActionStatus, 
						   S.ConfirmationDate,
						   S.ConfirmationFirstName,
						   S.ConfirmationLastName,
						   IT.OfficerUserId, 
				           IT.OfficerLastName, 
						   IT.OfficerFirstName, 					 
						   Item.ItemClass
				FROM       ItemTransaction IT INNER JOIN
				           ItemTransactionShipping S ON IT.TransactionId = S.TransactionId INNER JOIN
				           ItemUoM U ON IT.ItemNo = U.ItemNo AND IT.TransactionUoM = U.UoM INNER JOIN
				           Item ON IT.ItemNo = Item.ItemNo
				WHERE      IT.RequestId = '#RequestId#'
				<cfif url.itemlocationid neq "">
				AND        Warehouse = '#ItemLoc.Warehouse#'
	  			AND        Location  = '#ItemLoc.Location#'  
				</cfif>
			</cfquery>
			
			<tr class="hide" id="b#RequestId#">
				<td colspan="13" id="i#RequestId#"></td>
			</tr>
			
			<cfloop query="shiplist">
			
				<tr><td></td><td bgcolor="d1d1d1" colspan="12"></td></tr>
		
				<TR bgcolor="#IIf(CurrentRow Mod 2, DE('f5f5f5'), DE('f6f6f6'))#">
					<td bgcolor="white"></td>
					<td colspan="2" bgcolor="DBF9E1" class="labelit">
					&nbsp;<i><font color="B0B0B0">confirmed:</i></font>&nbsp;#ConfirmationFirstName# #ConfirmationLastName# <i><font color="b0b0b0">at:</font></i>&nbsp;#Dateformat(ConfirmationDate, CLIENT.DateFormatShow)# #timeformat(ConfirmationDate, "HH:MM")#
					</td>			
					<td bgcolor="DBF9E1" class="labelit">#Warehouse#/#TransactionBatchNo#</td>	
					<td class="labelit">#Dateformat(TransactionDate, CLIENT.DateFormatShow)#</td>
					<td align="center">
					<cfif currentrow eq recordcount>
						<img src="#SESSION.root#/images/join.gif"       alt="" border="0">
					<cfelse>
						<img src="#SESSION.root#/images/joinbottom.gif" alt="" border="0">
					</cfif>
					</td>
					<TD align="center" style="padding-left:3px" class="labelit">#TransactionQuantity*-1#</TD>	
					<TD align="right" style="padding-left:5px" class="labelit"><cfif UoMDescription neq uom>#uomdescription#</cfif></TD>	
					<cfif Param.RequestEnablePrice eq "1">		
					<td align="right" style="padding-left:5px" class="labelit">#NumberFormat(TransactionCostPrice,'__,____.__')#</td>
					<td align="right" style="padding-left:5px" class="labelit">#NumberFormat(TransactionValue*-1,'__,____.__')#</td>
					</cfif>					
				</TR>	
				
			</cfloop>	
					
		<cfelseif RequestType eq "Regular">
						
		    <cfset url.requestid = requestid>
									
			<cfif isTasked neq "">
			
			<!--- too much information here
													
			<tr style="padding-top:4px">
			   <td style="padding-top:1px"></td>	
			   <td valign="top" style="padding-top:4px">Tasked under:</td>		     			  
			   <td colspan="7" bgcolor="EBF7FE" style="border:1px dotted silver;padding:2px;width:95%;padding-bottom:2px">				 							
					<cfinclude template="../../Application/StockOrder/Request/Create/DocumentLinesTask.cfm">					
			</td>
			<td colspan="2"></td>
			</tr>	
			--->	
			
			<cfelse>
			
			<!--- show approval workflow for additional information --->						
						
			<cfquery name="Header" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * 
				FROM   RequestHeader H , Request D
				WHERE  H.Mission = D.Mission
				AND    H.Reference = D.Reference
				AND    RequestId = '#requestid#'	
			</cfquery>
			
			<input type="hidden" 
				name="workflowlink_#Header.RequestHeaderid#" 
				id="workflowlink_#Header.RequestHeaderid#"
				value="Requester/RequestWorkflow.cfm">			
								
			<tr>
			<td id="#Header.RequestHeaderid#" colspan="13">	
			    <cfset url.ajaxid = Header.RequestHeaderId>												
				 <cfinclude template="RequestWorkflow.cfm"> 
			</td>
			</tr>				
			<tr><td height="3"></td></tr>		
			</cfif>	
									
			<tr><td colspan="12" style="border-top:1px dotted e4e4e4"></td></tr>	
						
		<cfelse>	
							
		</cfif>
				
	</cfoutput>
	
	<cfif Param.RequestEnablePrice eq "1">
	
		<cfif url.view eq "pending" and row gte "2">
			<tr>			
			<td colspan="9"></td>			
			<td colspan="2" class="labelit"><cf_tl id="Total">:</td>
		    <td colspan="1" align="right" id="total_#status#" style="border-top:1px dotted silver" class="labelit"><b>#NumberFormat(total,'__,____.__')#</td>
			</tr>
			<tr><td height="3"></td></tr>
		</cfif>
		
	</cfif>	
		
	</cfoutput>

</cfoutput>

<tr><td height="2"></td></tr>

</TABLE>

</cfif>

