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

<cfparam name = "URL.Source"           default="">
<cfparam name = "URL.Location"         default="">
<cfparam name = "URL.ItemNo"           default="">
<cfparam name = "URL.UoM"              default="">
<cfparam name = "URL.SystemFunctionId" default="00000000-0000-0000-0000-000000000000">
<cfparam name = "URL.TransactionId"    default="00000000-0000-0000-0000-000000000000">
<cfparam name = "URL.details"          default="0">


<cfset tableName = "StockTransaction#URL.Warehouse#_#url.mode#"> 
<cf_getPreparationTable warehouse="#url.warehouse#" mode="#url.mode#"> <!--- adjusts #tableName# i.e. preparation can be per user or per warehouse --->

<cfif URL.mode eq "sale" or URL.Mode eq "workorder" or URL.Mode eq "disposal" or url.Mode eq "Initial">	  
     <cfset presentation = "price">
<cfelseif URL.mode eq "issue">
     <cfset presentation = "log">
<cfelse>
	 <cfset presentation = "standard">
</cfif>

<cfquery name="getFunction"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT 	*
		FROM 	Ref_ModuleControl
		WHERE	SystemFunctionId = '#URL.SystemFunctionId#'
		
</cfquery>

<!--- ------------------------------------------- --->
<!--- retrieve the lines of the transaction batch --->
<!--- ------------------------------------------- --->

<cfif presentation eq "log">
	
	<cfquery name="getLocation"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM WarehouseLocation
		WHERE   Warehouse    = '#url.warehouse#'
		AND     Location     = '#url.location#' 
	</cfquery>
	
	<cfset showreference = getLocation.enableReference> 

<cfelse>

	<cfset showreference = "0">

</cfif>

<cfquery name="Line"
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT   *, 
	
			 (SELECT FirstName+' '+LastName FROM System.dbo.UserNames WHERE Account = T.OfficerUserid) as OfficerName,
	
	         <cfif presentation eq "log">					  
			 
				( SELECT  S.SupplyCapacity
	              FROM    Materials.dbo.AssetItemSupply S
				  WHERE   S.AssetId       = T.AssetId 
                  AND     S.SupplyItemNo  = '#url.itemNo#' 
 			      AND     S.SupplyItemUoM = '#url.uom#'
				) as Capacity,							
			 
			 </cfif>
			 
	         U.UoMDescription, 
			 R.Description as TransactionTypeName,
			 S.Description as LocationName,
			 			 
			 <!--- asset --->
			 AI.Make,
			 AI.Model,
			 AI.AssetBarCode,
			 AI.AssetDecalNo,
			 AI.SerialNo,
			 AI.ItemNo as AssetItemNo,
			 AI.Description as AssetDescription,
			 
			 <!--- only if the reference is to be show we do the validation and query --->
			 
			 <cfif showreference eq "1">
			 
			 (	 SELECT   TOP 1 TransactionReference
				 FROM     #tableName# TT
				 WHERE    Warehouse             = T.Warehouse	
				 AND      TransactionId        != T.TransactionId <!--- exclude the same transaction --->				
				 AND      TransactionReference  = T.TransactionReference )  as VoucherThisBatch,
			 
			 (   SELECT   TOP 1 TransactionReference
				 FROM     Materials.dbo.ItemTransaction TP
				 WHERE    Warehouse             = T.Warehouse 					
				 AND      TransactionReference  = T.TransactionReference ) as VoucherOtherBatch, 
				 
			 </cfif>	 
			 
			 (
			 
			 SELECT   ISNULL(SUM(TransactionQuantity),0)
			 FROM     #tableName#  TT
			 WHERE    AssetId         = T.AssetId					
			 AND      ItemNo          = T.ItemNo
			 AND      TransactionUoM  = T.TransactionUoM
			 AND      TransactionId  != T.TransactionId  <!--- exclude the same transaction --->
			 AND      CONVERT(VARCHAR(10),TransactionDate,101) = CONVERT(VARCHAR(10),T.TransactionDate,101) ) as IssuedThisBatch,
				
			 (
			 
			 <!--- added an index for this combination --->
			 			
			 SELECT   ISNULL(SUM(TransactionQuantity),0)
			 FROM     Materials.dbo.ItemTransaction TP
			 WHERE    AssetId         = T.AssetId					
			 AND      ItemNo          = T.ItemNo
			 AND      TransactionUoM  = T.TransactionUoM
			 AND      CONVERT(VARCHAR(10),TransactionDate,101) = CONVERT(VARCHAR(10),T.TransactionDate,101) ) as IssuedOtherBatch, 			 			 
			 
			 <!--- person --->
			 T.PersonNo, 
			 P.FirstName,
			 P.LastName,
			 P.Reference,
				   
			 T.CustomerId,	
			 T.WorkorderId			 
			 
	FROM     #tableName# T 
	         INNER JOIN      Materials.dbo.ItemUoM U             ON T.ItemNo = U.ItemNO AND T.TransactionUoM = U.UoM			
			 INNER JOIN      Materials.dbo.Ref_TransactionType R ON T.TransactionType = R.TransactionType
			 LEFT OUTER JOIN Materials.dbo.WarehouseLocation S   ON T.Warehouse = S.Warehouse AND T.Location = S.Location
			 LEFT OUTER JOIN Materials.dbo.AssetItem AI          ON AI.AssetId = T.AssetId
			 LEFT OUTER JOIN Employee.dbo.Person P               ON T.PersonNo = P.PersonNo
			 
	WHERE    1=1
	<cfif presentation eq "log">
	AND      T.Warehouse      = '#url.warehouse#'
	AND      (T.Location      = '#url.location#' OR T.LocationTransfer = '#url.location#')
	AND      T.ItemNo         = '#url.itemNo#'
	AND      T.TransactionUoM = '#url.uom#'	
	<cfelse>
	AND      T.TransactionType  = '#URL.tratpe#'   
	</cfif>
	<cfif url.source eq "Device">
	AND      T.Source = 'Device'
	</cfif>
	ORDER BY T.OfficerUserId, T.Created DESC
</cfquery>		

<table width="100%" height="100%" class="navigation_table formpadding">

<tr><td valign="top">

<cfif Line.recordcount gte "0">

<table width="99%" align="center">

    <cfif URL.tratpe eq "2" or URL.tratpe eq "9">
	   <cfset cols = "15">
	<cfelse>
	   <cfset cols = "13">
	</cfif> 
	
	<tr class="xxxhide"><td height="4" id="processlines"></td></tr>
	
	<tr class="labelmedium fixrow line fixlengthlist">
	  <td width="1"></td>
	  <td></td>
      <TD></TD>	 
	 	  
		  <cfif showreference eq "1">
		  <td width="80">
			  <cf_tl id="Receipt">
		   </td>
		   <cfelse>
		   <td></td>	  
		  </cfif>
	  	   
	  <cfif presentation eq "log">	
	  	  <TD><cf_tl id="Make/Barcode"></TD>
  	      <td><cf_tl id="Project"></td>		
	      <td><cf_tl id="Date/Time"></td>			     
	      <TD><cf_tl id="Unit"></TD>		     	      
	  <cfelse>
	  	  <TD><cf_tl id="Location"></TD>
	  	  <td colspan="2"><cf_tl id="Product"></td>		         
	      <td><cf_tl id="Category"></td>			 
	  </cfif>	 	 
	  <td colspan="3"><cf_tl id="Quantity"></td>	 	  
	  <cfif presentation eq "price">	 
	    <TD align="right"><cf_tl id="Cost"></TD>   
    	<TD align="right" style="padding-right:4px"><cf_tl id="Total"></TD>	 	   
	    <TD align="right"><cf_tl id="Charge"></TD>
	  	<TD align="right" style="padding-right:2px"><cf_tl id="Total"></TD>		
	  </cfif>   	  
	</tr>  
	
	<cfset submitgo  = TRUE>	
	
	<cfif Line.recordcount eq "0">
		<tr><td colspan="<cfoutput>#cols#</cfoutput>" style="padding-top:70px" align="center" class="labelmedium">
			<cf_tl id = "There are no more lines pending submission" var = "1" class = "message">
		    <cfoutput>#lt_text#</cfoutput>
			</td>
		</tr>
		<cfset submitgo = FALSE>
	</cfif>        
 		
	
    <cfoutput query="Line" group="OfficerUserid">
	
	<tr class="line"><td colspan="#cols#" style="height:25;padding-top:4px;padding-left:4px" class="labelmedium">#OfficerName# (#OfficerUserid#)</td></tr>
	
	<cfoutput>
				
	<cfif (transactionClass eq "Transfer" and TransactionQuantity gt 0) or transactionType eq "2" or transactionType eq "9">
		
		    <!--- only issueance lines --->
				
			<cfif assetid eq "" and URL.Location neq "" and transactionType neq "8" and transactionType neq "6">
				<cfset color = "FABEBE">      
			 	<cfset submit_allowed  = FALSE >				
			<cfelse>
				<cfif transactiontype eq "8">   	   
				   <cfset color = "EBF7FE">      
				<cfelse>
				   <cfset color = "ffffff">
		 	    </cfif>
			</cfif>	
									
			<cfif transactionid eq url.transactionid>
				<cfset color = "A5FF4A">
			</cfif>
					    
		   <input type="hidden" name="assetid" id="assetid" size="4" value="" readonly style="text-align: center;">	
		   
		   <cfif transactionid eq url.transactionid>
		   
		   		<tr><td colspan="#cols#" class= "clsTransaction labelit" align="center" style="height:20" bgcolor="green"><font color="FFFFFF">Amended transaction</td></tr>
				<tr><td colspan="#cols#" class= "clsTransaction" style="border-top:1px solid gray"></td></tr>
		   
		   </cfif>
		   
		   <tr bgcolor   = "#color#"
		      style      = "cursor : pointer;"
			  id         = "line_#transactionid#"
			  name       = "line_#transactionid#"
			  class      = "clsTransaction labelmedium navigation_row fixlengthlist">
			  			  
			   <td style="width:20px">			
			  
			    <cfif url.mode eq "workorder" or mode eq "sale" or URL.mode eq "ExternalSale" or transactiontype eq "9">
			 
				     <cf_img icon="delete" 
					     onClick="delete_tmp_transaction('#transactionid#','#URL.Warehouse#','#url.mode#')">
					 
				</cfif>	 
				
			   </td>				  			  
			   <td style="padding-left:3px">#recordcount-currentrow+1#.</td>		
			         
			   <td style="height:20px">		       
			   			 
				 <table class="formpadding"><tr>
				 
				    <cfif url.mode neq "workorder" and mode neq "sale" and URL.mode neq "ExternalSale"> 
												 
					 	<td style="width:20px;padding-top:1px">
						
						<cfset vTemplate = "Warehouse/Inquiry/Print/Issue/Issue.cfr">
						<cfset vTable = "#tableName#"> 
					 
					    <cfif (transactionClass eq "Transfer" and TransactionQuantity gt 0) or transactionType eq "2" or transactiontype eq "9">
					   					  
					      <cf_img icon="print" onclick = "issuelineprint('#transactionid#', '#vTable#', '#vTemplate#', '#getFunction.FunctionName#');" >
						
						</cfif>
						   
						</td>
					
					</cfif>
				 
				    <cfif url.mode neq "workorder" and mode neq "sale" and mode neq "disposal" and URL.mode neq "ExternalSale"> 
				  
					  	<td style="padding-top:3px;padding-left:5px">
						
						<cfif (transactionClass eq "Transfer" and TransactionQuantity gt 0) or transactionType eq "2">
						
						    <cf_img icon="edit" navigation="Yes" onclick="editdetailline('#url.mode#','#transactionid#','#url.warehouse#','#url.location#','#transactiontype#');">
															   
						 </cfif>
						   
						</td>   
					   
				    </cfif>	 
				 
				 <td style="padding-top:3px;padding-left:5px">
				 
				   <cfif URL.mode neq "issue">
				    	<cfset link = "../Transaction/TransactionDetailDelete.cfm?systemfunctionid=#url.systemfunctionid#&mode=#url.mode#&id=#transactionid#&warehouse=#url.warehouse#">
				   <cfelse>
			   		    <cfset link = "../Transaction/TransactionDetailDelete.cfm?systemfunctionid=#url.systemfunctionid#&mode=#url.mode#&id=#transactionid#&warehouse=#url.warehouse#&location=#url.location#&itemno=#url.itemno#&uom=#url.uom#">
				   </cfif>
				   
				   <cfif (transactionClass eq "Transfer" and TransactionQuantity gt 0) 
				        or (transactionType eq "2" and mode neq "sale" and mode neq "workorder" and URL.mode neq "ExternalSale")>
				
					   <cf_img icon="delete" onclick="ptoken.navigate('#link#','processlines')">
				   
				   </cfif>
			    				   
				  </td>
				  
				   <cfif assetid neq "">
				   						
						<cfquery name="get"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT R.distributionAttachment
							FROM   Item I, Ref_Category R
							WHERE  I.ItemNo = '#AssetItemNo#'
							AND    I.Category = R.Category							
						</cfquery>	
					  
					    <td style="padding-top:1px;padding-left:5px">
					  
					    <cfif get.distributionAttachment eq "1">
											  
						  	<img src="#SESSION.root#/images/attachment.png" 
							   height="12" width="12" onclick="document.getElementById('att_#transactionid#').className='regular'" alt="" border="0" align="absmiddle">
							   
						 </cfif>   
						
					    </td>
				  
				  </cfif>				  
				  
				  </tr>
				  </table>   				 	   
							   		    
			   </td>			   
			  			   
			   <cfif transactiontype eq "2" and URL.Mode neq "Disposal">
			 
				   <cfset qty = -TransactionQuantity>
				   <cfset val = -TransactionValue>
			   
			   <cfelse>
			   
				   <cfset qty = TransactionQuantity>
				   <cfset val = TransactionValue>
			   
			   </cfif>			   
			  
			   <td class="ccontent"><cfif showreference eq "1">#TransactionReference#</cfif></td>			   
			   <td>
				   <cfif presentation eq "log">
				      <a href="javascript:AssetDialog('#assetid#')">
					  <font color="0080C0"><cfif make neq "">#Make#<cfelse>#Model#</cfif>/
					  <cfif AssetDecalNo neq "">#AssetDecalNo#<cfelse>#AssetBarCode#</cfif>
					  </a>
				   <cfelse>
				      #LocationName#				 
				   </cfif>
			   </td>
			   
			   <cfif presentation eq "log">	 
			   
				   <td>
				   
					   	<cfif ProgramCode neq "">
							<cfquery name = "qProgram" datasource = "AppsProgram">
								SELECT * FROM Program WHERE ProgramCode = '#ProgramCode#'
							</cfquery>
							#qProgram.ProgramName#
						</cfif>
					
				   </td>		   
				   
				   <td>#dateformat(TransactionDate,CLIENT.DateFormatShow)#&nbsp;#timeformat(TransactionDate,"HH:MM")#</td>		   
				   
				   <td>
				   
					   <cfif transactiontype eq "8">
					   					   
							<cfquery name="Transfer"
							datasource="AppsTransaction" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT   S.*
								FROM     #tableName#  T,
										 Materials.dbo.WarehouseLocation S
								WHERE    T.TransactionId  = '#transactionid#'	
								AND      T.Location      != '#url.location#'
								AND      T.Warehouse      = '#url.warehouse#'	
								AND      T.ItemNo         = '#url.itemNo#'
								AND      T.TransactionUoM = '#url.uom#'							
								AND      T.Warehouse        = S.Warehouse
								AND      T.Location         = S.Location 
							</cfquery>		
					   
					   		#Transfer.Description#
							
					   <cfelse>	
					   
					   		#OrgUnitName#
							
					   </cfif>
				   
				   </td>		  		   
			   
			   <cfelse>
			   		   
				   <td colspan="2">#ItemDescription#</td>				    		   
				   <td>#ItemCategory#</td>
			   
			   </cfif>
			   
			   <td align="right"><cfif qty lt 0><font color="FF0000"></cfif>#NumberFormat(qty,'(,__._)')#</td>
			   <td align="right"  style="padding-left:4px;padding-right:4px">#UoMDescription#</td>
			   <td align="center" style="padding-top:2px">
			   
				   <cfif billingmode eq "external">
				     <img src="#SESSION.root#/images/money.png" height="10" width="12" alt="External Billing" border="0">
					<cfelse>
					-- 
				   </cfif>
			   
			   </td>
			   
			   <cfif presentation eq "price">	
				   <td align="right">#NumberFormat(TransactionCostPrice,',.__')#</td>
				   <td align="right">#NumberFormat(val,',.__')#</td>	
				   <cfif salesprice eq "">	
				   <td align="right" style="padding-right:2px">--</td>
				   <td align="right" style="padding-right:4px">--</td>  
				   <cfelse>				   
				   <td align="right" style="padding-right:2px">#NumberFormat(SalesPrice,',.__')#</td>
				   <td align="right" style="padding-right:4px">#NumberFormat(SalesPrice*qty,',.__')#</td>
				   </cfif>
			   </cfif>
			   
		   </tr>		    
		   		   
		   <cfif url.details eq "1">
		   
		   	   <!--- ---------------- --->
		   	   <!--- line for remarks --->
			   <!--- ---------------- --->	 	
		   		   
			   <CFIF remarks neq "">
				   <tr bgcolor="#color#" name= "line_#transactionid#" id="line_#transactionid#_remarks" class="clsTransaction navigation_row_child">
					   <td colspan="6"></td>
					   <td class="labelit" colspan="<cfoutput>#cols#</cfoutput>">#Remarks#</td>
					   <td></td>
					   <td></td>
					   <td></td>
					   <td></td>
				   </tr>		   
			   </CFIF>
		   		  		
			   <!--- ---------------- --->
		   	   <!--- line for asset-- --->
			   <!--- ---------------- --->	 	
			   		   
			   <cfif assetid neq "">
			   				   								
					   <tr bgcolor="#color#" name= "line_#transactionid#" id="line_#transactionid#_asset" class="clsTransaction navigation_row_child">	   
					   
					       <td></td>
						   <td></td>
						   <td></td>			  	  
						   <td colspan="#cols-3#" style="padding-top:1px;padding-left:3px">
						   
							   <table cellspacing="0" cellpadding="0">
							   
							   <tr>							  
								   <!--- <td style="padding-left:4px">#AssetDescription#</td>--->	   
								   <td style="width:80;padding-left:5px" class="labelsmall"><font color="808080"><cf_tl id="Receiver">:</td>
								   <td style="width:200;padding-left:4px" class="labelit"><cfif lastname eq "">n/a<cfelse>#FirstName# #LastName# (#Reference#)</cfif></td>													   
														 			   
							   </tr>
							   
							   <!--- metrics and events --->
							   
							   <tr>
							   
							       <td colspan="2">
							   
									    <table width="100%">
										
										   <cfloop from="1" to="5" index="k">
										   		<cfset vMetric 		= Evaluate("AssetMetric#k#")>
										   		<cfset vMetricValue = Evaluate("AssetMetricValue#k#")>
												<cfif vMetric neq "">
													<cfset pos = Find(".",vMetric)>
												   <tr>													  												  		   
													   <td style="width:80;padding-left:5px" width="20%" class="labelit"><font color="808080">#Mid(vMetric,pos+1,Len(vMetric))# :</font></td>															   
													   <td width="10%" class="labelit" style="padding-left:3px">#vMetricValue#</td>			   
													   <td></td>	   			   
												   </tr>
												 </cfif>	 
										   </cfloop>	
										   
										   <cfloop from="1" to="5" index="k">
										   		<cfset vEvent 		= Evaluate("Event#k#")>
												<cfif vEvent neq "">
												
													<cfquery name="qEvent" 
													datasource="AppsMaterials"  
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
														SELECT Description
														FROM   Ref_AssetEvent							
														WHERE  Code = '#vEvent#'
													</cfquery>
													
											   		<cfset vEventDate    = Evaluate("EventDate#k#")>
											   		<cfset vEventDetails = Evaluate("EventDetails#k#")>								
												   <tr>													  														  		   
													   <td width="10%" class="labelsmall" style="width:80;padding-left:5px"><font color="808080">#qEvent.Description# :</font></td>															  			   
													   <td width="20%" class="labelit" style="padding-left:3px">#DateFormat(vEventDate,CLIENT.DateFormatShow)#&nbsp;&nbsp;#TimeFormat(vEventDate,"HH:MM")#</td>	   			   													 	   
													   <td align="left" style="padding-left:3px" class="labelit">#vEventDetails#</td>										   
												   </tr>
												 </cfif>	 
										   </cfloop>		
										   						   					   
										   </table>
							   					   
									</td>		   
							 	</tr>  
								
							   </table>
						   </td>
					   </tr>								   
				  			  		   
			  <cfelseif URL.Location neq "" and transactiontype eq "2">
			  
				  <tr bgcolor="#color#" height="20" name="line_#transactionid#" id="line_#transactionid#_location" class="clsTransaction navigation_row_child">	   
				       <td></td>
					   <td></td>				  
					   <td colspan="4">
					   
					       <cfset link = "#SESSION.root#/warehouse/application/stock/Transaction/ChangeAsset.cfm?row=#currentrow#&transactionId=#transactionId#&Warehouse=#URL.Warehouse#&Mode=#URL.Mode#&tratpe=#URL.tratpe#&location=#URL.Location#&itemNo=#URL.ItemNo#&UoM=#URL.UoM#">								   
						   <cf_selectlookup
							    box          = "assetbox_#currentrow#"
								link         = "#link#"
								title        = "Item Selection"
								icon         = "add.png"
								button       = "No"
								close        = "Yes"	
								filter1      = "mission"
								filter1value = "#mission#"				
								class        = "Asset"
								des1         = "AssetId">		
								Asset Item not found! please select an Asset item							   			   
					   </td>
					   <td colspan="#cols-6#"></td>	   
					   <td colspan="5" id="assetbox_#currentrow#"></td>   
				   </tr>		
			   </cfif>
		   
		</cfif>
		
		<!--- ---------------- --->
   	    <!--- line for spacing --->
	    <!--- ---------------- --->	 	
		
		<!---
		<tr class="navigation_row_child"><td height="1" colspan="2"></td></tr>
		--->
		
		<cfquery name="get"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT R.distributionAttachment
			FROM   Item I, Ref_Category R
			WHERE  I.ItemNo = '#AssetItemNo#'
			AND    I.Category = R.Category							
		</cfquery>	
		
		<!--- -------------------- --->
   	    <!--- line for attachment --->
	    <!--- -------------------- --->	 	
		
		<cfif get.distributionAttachment eq "1">
			   
		   <tr name="line_#transactionid#" id="att_#transactionid#" class="hide clsTransaction navigation_row_child">
		   
			  <td class="labelit" colspan="3" valign="top" align="right" style="padding:2px"><cf_tl id="Attachment">:</td>
			  <td colspan="#cols-8#">				  
			  				  
				  <cf_filelibraryN 
					DocumentPath="WhsTransaction" 
					SubDirectory="#transactionid#" 
					Filter="" 		
					width="100%"			
					Insert="yes" 
					Remove="yes" 
					LoadScript="false" 
					rowHeader="no" 
					ShowSize="yes"> 
			  
			  </td>		
			  <td></td>
			  
		    </tr>
			  		   
	    </cfif>			
				
		
		<!--- ----------------- --->
		<!--- validation lines- --->
		<!--- ----------------- --->
		
		<cfif showReference eq "1">
		   
		    <cfif VoucherThisBatch neq "" or VoucherOtherBatch neq "">
		      
			   <tr name="line_#transactionid#" class="clsTransaction navigation_row_child">			      		  
				   <td colspan="2"></td><td colspan="8" bgcolor="FF8040" class="labelit" style="height:23;padding-left:10px;border:1px solid silver">							     
						 <b>Attention</b> : Voucher #TransactionReference# has been used already.  						 
				   </td>				 
			   </tr>
			  		   
		   </cfif>  
	   
	   </cfif>
	  	   
	   <cfif IssuedThisBatch lt "0" or IssuedOtherBatch lt "0">
	   	   	 
		   <tr name="line_#transactionid#" class="clsTransaction navigation_row_child">
		      			  
			   <td colspan="2"></td>
			   <td colspan="8" bgcolor="yellow" class="labelit" style="height:23;padding-left:10px;border:1px solid silver">							     
					 <b>Attention</b> : Asset was issued already #numberformat(abs(IssuedThisBatch-IssuedOtherBatch),",._")# for the same day.  						 
			   </td>
			   <td></td>   
			   
		   </tr>
		 
	   </cfif>  
	   		   
	   <!--- -----------check if capacity is exceeded--------- --->
	   
	   <cfif presentation eq "log">	
	   		   
		   <cfif Capacity lt qty and Capacity gte "1">
	  	  		   
		   <tr name="line_#transactionid#" class="clsTransaction navigation_row_child">		     			
			   <td colspan="2"></td>
			   <td height="18" 
			       colspan="8" 
				   align="center" 
				   bgcolor="FF8080" 
				   class="labelit" 
				   style="height:23;padding-left:10px;border:1px solid silver">		
			     <font color="FFFFFF">
					 <b>Attention</b> : Issued quantity of #qty# exceeds the capacity (#Capacity#) defined for this item. 
				 </font>
			   </td>
			   <td colspan="1" id="assetbox_#currentrow#"></td>   
		   </tr>		 
	   
		   </cfif>  
	   
	   </cfif>   			   		 
	   
		<cfif PersonNo eq "" and presentation eq "log">			
			
			<tr name="line_#transactionid#" class="clsTransaction navigation_row_child">
			       <td colspan="2">				  				
				   <td colspan="8" class="labelit" bgcolor="yellow" style="padding-left:10px;border:1px solid silver">
						<b>Attention</b> : Recipient's name has not been found please check the transaction
					</td>							  
				   <td colspan="1"></td>   
			</tr>				
								
		</cfif>		 	
					   
	</cfif>
	
	  
	<cfif url.mode eq "Disposal">			   
						   
		    <tr name= "line_#transactionid#" id="line_#transactionid#_attach" class="clsTransaction navigation_row_child">
			 
			   <td colspan="#cols#" style="padding-top:3px;padding-left:3px">				  
			  				  
				  <cf_filelibraryN 
					DocumentPath="WhsTransaction" 
					SubDirectory="#transactionid#" 
					Filter="" 
					Insert="yes" 
					Remove="yes" 
					LoadScript="false" 
					rowHeader="no" 
					ShowSize="yes"> 
			  
			  </td>		
		   </tr>
				   
	</cfif>		
			
	<!--- divider --->
	
	<tr class="clsTransaction navigation_row_child"><td style="padding-top:2px" colspan="#cols#" class="line"></td></tr>   
   			  			
   </cfoutput>		
		
</cfoutput>      
   
<cfoutput>
	
	<cfif presentation eq "log">
						
		<!--- we show this in the total bottom banner --->	
		<script language="JavaScript">
		   if (document.getElementById("logtotals")) {
		   ptoken.navigate('../Transaction/TransactionLogSheetTotal.cfm?systemfunctionid=#url.systemfunctionid#&tratpe=#url.tratpe#&mode=#url.mode#&warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemno#&UoM=#url.uom#','logtotals')			
		   }
		</script>
			
	<cfelse>
	
		<!--- THIS PORTION YOU WILL NEED to move into another template --->
	
		<!--- ------------- --->
		<!--- final summary --->
		<!--- ------------- --->
	
		 <cfquery name="Total" 
		     datasource="AppsTransaction" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				SELECT  count(*) as Lines,
				        SUM(TransactionQuantity) as Quantity,
				        SUM(TransactionValue) as Cost,
					    SUM(SalesValue) as Sales
				FROM    #tableName# T
				WHERE  1=1
				<cfif presentation eq "log">
				AND     T.Warehouse      = '#url.warehouse#'
				AND     T.Location       = '#url.location#'
				AND     T.ItemNo         = '#url.itemNo#'
				AND     T.TransactionUoM = '#url.uom#'	
				<cfelse>
				AND     T.TransactionType  = '#URL.tratpe#'
				</cfif>
	    </cfquery>
	
		<cfif Line.recordcount gte "2">  		 
		 
		  <tr class="labelit">
		      
			<td height="20" align="center" valign="middle"></td>
							
			<cfif URL.tratpe eq "2" and URL.Mode neq "Disposal">
			
			     <cfset qty = -total.quantity>
			     <cfset cst = -total.cost>
				 <cfset sal = -total.sales>
				 
			<cfelse>
					
			     <cfset qty = total.quantity> 
			     <cfset cst = total.cost>
				 <cfset sal = total.sales>
				 
			</cfif> 	
			
			<cfif presentation eq "price">	
			
			<td colspan="11" align="right">#Total.Lines#</td>			 
			<td align="right" style="padding-right:4px">#NumberFormat(cst,',.__')#</td>
			<td></td>
			<td align="right" style="padding-right:4px">#NumberFormat(sal,',.__')#</td>
			
			<cfelseif presentation eq "log">	
			
			<td colspan="5"></td>		
				<td colspan="1" align="right">(#Total.Lines#)</td>				
				<td align="right">#NumberFormat(qty,',._')#</td>
			<td></td>
							
			<cfelse>
					 
			<td colspan="7" align="right">(#Total.Lines#)</td>		
			<td align="right" style="padding-right:2px">#NumberFormat(qty,',.__')#</td>		
					
			</cfif>
	
		  </tr> 	
		  
		  <cfquery name="get"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM   Warehouse
				WHERE  Warehouse = '#url.warehouse#'
		  </cfquery>	
		 	 
		  <cfif url.systemfunctionid neq "undefined" and url.systemfunctionid neq "">
		  	   	  
		    <cfinvoke component = "Service.Access"  
		     method             = "WarehouseProcessor"  
			 role               = "'WhsPick'"
			 mission            = "#get.mission#"
			 warehouse          = "#url.warehouse#"		
			 SystemFunctionId   = "#url.SystemFunctionId#" 
			 returnvariable     = "access">	 	
			 						 
			 <cfif access neq "ALL">
			 
			 	<cfset submitgo  = FALSE>		
			 
			 </cfif>
			 
		  </cfif>	 
		  
		  </cfif>
			 
		  <cfif submitgo or url.mode eq "workorder">	 
		  
		  <!--- submission is only allows if the user has access rights = all --->
		  				   	  
		     <tr><td colspan="#cols#" align="center" height="28" style="padding-top:7px">
			 	   	   
			    <cf_tl id="Submit Transactions for Clearance" var="1">
												
				<input type     = "button"
					value       = "#lt_text#" 				
					onclick		= "processStockIssue('#url.mode#','#url.warehouse#','#url.tratpe#','#url.location#','#url.itemno#','#url.uom#','','#url.systemfunctionid#');"
					id          = "Save"	
					class       = "button10g"				
					style       = "font-size:12px;height:27;width:290">
						
			  </td>
			
		      </tr>	 
		  
		  </cfif>
		
		
	</cfif>	   
	  
   </cfoutput>	  
	
 </table> 
 
</cfif> 

</td></tr>

<!--- transaction mode --->

<cfquery name="sourcemode" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   ItemWarehouseLocationTransaction
	WHERE  Warehouse = '#url.warehouse#'	
	AND    Location  = '#url.location#'	
	AND    ItemNo    = '#url.itemno#'
	AND    UoM       = '#url.UoM#' 	
	AND    TransactionType = '#url.tratpe#'			
</cfquery>

<cfif sourcemode.source eq "1">

	<script>
	   try {
	    document.getElementById('entrymode1').className = "regular"
		document.getElementById('entrymode2').className = "hide"
		document.getElementById('entrymode3').className = "hide"
		} catch(e) {}
	</script>

<cfelseif sourcemode.source eq "2">

	<script>	
		try {	
		document.getElementById('entrymode1').className = "regular"
		document.getElementById('entrymode2').className = "regular"
		document.getElementById('entrymode3').className = "hide"
		} catch(e) {}
	</script>

<cfelseif sourcemode.source eq "3">

	<script>	
		try {	
		document.getElementById('entrymode1').className = "regular"
		document.getElementById('entrymode2').className = "hide"
		document.getElementById('entrymode3').className = "regular"
		} catch(e) {}
	</script>

</cfif>	

</table>

<cfset AjaxOnLoad("doHighlight")>	
