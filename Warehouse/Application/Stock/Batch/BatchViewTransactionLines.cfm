
<!--- show the line of the batch transaction --->

<cfset st = now()>

<cfparam name="FullAccess"          default="NONE">
<cfparam name="EditAccess"          default="NONE">
<cfparam name="ClearMode"           default="1">

<cfparam name="URL.Mode"            default="Standard">
<cfparam name="URL.Id"              default="">
<cfparam name="URL.ItemNo"          default="">
<cfparam name="URL.Group"           default="TransactionDate">
<cfparam name="URL.warehouse"       default="">
<cfparam name="URL.height"          default="9999">
<cfparam name="URL.stockorderid"    default="">
<cfparam name="url.modality"        default="9">

<!--- make sure it has a value --->
<cf_precision number="0">

<cfquery name="Batch"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     WarehouseBatch B,
	         Ref_TransactionType R 
	WHERE    B.TransactionType = R.TransactionType
	AND      BatchNo           = '#URL.BatchNo#'
</cfquery>

<cfset enforcelines = "0">
							
<cfquery name="Check"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     WarehouseTransaction 
		WHERE    Warehouse       = '#Batch.warehouse#'					
		AND      TransactionType = '#Batch.TransactionType#' 
</cfquery>
	
<cfif check.clearancemode gte "2">
			
	<!--- we enforce individual clearance based on the deeper level --->							
	<cfset enforcelines = "1">

</cfif>

<cfquery name="Param"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission	      
	WHERE    Mission = '#Batch.Mission#'
</cfquery>

<cfquery name="Location"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     WarehouseLocation 
	WHERE    Warehouse = '#Batch.Warehouse#'
	AND      Location  = '#Batch.Location#'
</cfquery>

<cfquery name="SearchResult"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

	     SELECT    T.TransactionId, 
		           T.Mission, 
				   T.Warehouse, 
				   T.TransactionType, 
				   R.Description, 
				   R.TransactionClass,
				   T.TransactionDate, 
				   T.ItemNo, 
				   I.ItemBarCode,
				   T.ItemDescription, 
				   M.ItemNoExternal,
				   T.ItemCategory, 
				   T.BillingMode,
				   T.ItemPrecision,
	               T.Location, 	
				   W.LocationClass,
				   W.ListingOrder,	
				   W.Description as LocationDescription,		
				   
				   <cfif url.modality eq "1">
				   
			       ( SELECT Journal 
				     FROM   Accounting.dbo.TransactionHeader R
					 WHERE  R.ReferenceId = T.TransactionId) as JournalCOGS,	
					 
				   ( SELECT JournalSerialNo 
				     FROM   Accounting.dbo.TransactionHeader R
					 WHERE  R.ReferenceId = T.TransactionId) as JournalSerialNoCOGS,		 	 		    
					 
				   </cfif>	 
				  
				   ( SELECT Reference 
				     FROM   Request R
					 WHERE  R.RequestId = T.RequestId) as RequestReference,		 
					 
				   T.TransactionQuantity, 
				   T.TransactionUoM, 
				   I.UOMDescription, 
				   T.TransactionUoMMultiplier, 
				   T.TransactionQuantityBase, 
				   T.TransactionCostPrice, 
	               T.TransactionValue, 
				   T.TransactionBatchNo, 
				   T.TransactionLot,
				   T.TransactionOnHand,
				   T.TransactionReference,
				   T.ParentTransactionId,
				   
				   <!--- check for transaction details like meter readings --->
				   
				   (SELECT TOP 1 TransactionId
				    FROM  ItemTransactionDetail 
					WHERE TransactionId = T.TransactionId) as DetailId,			  
				   
				   <!--- check for other quantity issued on the same day --->
				   
				   <cfif batch.actionStatus neq "9">
				   
				   (SELECT SUM(TransactionQuantity)
				    FROM     ItemTransaction
					WHERE    Mission         = T.Mission
					AND      AssetId         = T.Assetid
					AND      ItemNo          = T.ItemNo
					AND      TransactionUoM  = T.TransactionUoM
					AND      TransactionId   != T.TransactionId
					AND      CONVERT(VARCHAR(10),TransactionDate,101) = CONVERT(VARCHAR(10),T.TransactionDate,101)) as OtherQuantity,
					
				   </cfif>	
				   
				   (SELECT TransactionId 
				    FROM   ItemTransaction 
					WHERE  ParentTransactionId = T.TransactionId) as ChildId,
					
				   (SELECT TransactionId 
				    FROM   ItemTransactionShipping 
					WHERE  TransactionId = T.TransactionId) as Shipping,
					
				   (SELECT SalesTotal 
				    FROM   ItemTransactionShipping 
					WHERE  TransactionId = T.TransactionId) as Sales,
					
				   (SELECT Journal 
				    FROM   ItemTransactionShipping 
					WHERE  TransactionId = T.TransactionId) as Journal,
					
				   B.BillingStatus,
				   B.TransactionType as BatchTransactionType,
									 
				   ( SELECT  S.SupplyCapacity
		              FROM    Materials.dbo.AssetItemSupply S
					  WHERE   S.AssetId       = T.AssetId 
	                  AND     S.SupplyItemNo  = T.ItemNo 
	 			      AND     S.SupplyItemUoM = T.TransactionUoM
					) as Capacity,		
					
				   T.ReceiptId, 									 
							  			   
				   ( SELECT P.ReceiptNo 
				     FROM   Purchase.dbo.PurchaseLineReceipt P WHERE T.ReceiptId = P.ReceiptId
				   ) as ReceiptNo,	
				   
				   ( SELECT O.ObjectId 
				     FROM   Organization.dbo.OrganizationObject O
					 WHERE  O.EntityCode = 'WhsTransaction'
					 AND    O.Operational = 1				
					 AND    O.ObjectKeyValue4 = T.TransactionId
				   ) as WorkflowId,	 
				   		 
				   T.RequestId, 
				   T.WorkOrderId,
				   
				   <!--- unit --->
				   T.OrgUnit, 
				   T.OrgUnitCode, 
				   T.OrgUnitName, 
				   
				   <!--- asset --->
				   T.AssetId,
				   AI.Make,
				   AI.Model,
				   AI.AssetBarCode,
				   AI.AssetDecalNo,
				   AI.SerialNo,
				   
				   T.CustomerId,	
				   T.WorkorderId,	 
				   
				   <!--- check for metrics --->
				   
				   (SELECT TOP 1 Metric
					FROM    AssetItemAction AI INNER JOIN
					        AssetItemActionMetric AAM ON AI.AssetActionId = AAM.AssetActionId
					WHERE   TransactionId = T.Transactionid) as Metric,
					
				   (SELECT TOP 1 MetricValue
					FROM    AssetItemAction AI INNER JOIN
					        AssetItemActionMetric AAM ON AI.AssetActionId = AAM.AssetActionId
					WHERE   TransactionId = T.Transactionid) as MetricValue,
				   
				   <!--- person --->
				   T.PersonNo, 
				   P.FirstName,
				   P.LastName,
				   P.Reference,
				   
				   T.Remarks, 
				   T.ActionStatus,				  				  
				   T.Created
				   
		FROM      <cfif batch.actionStatus neq "9">ItemTransaction<cfelse>ItemTransactionDeny</cfif> T 
		          INNER JOIN Ref_TransactionType R ON T.TransactionType = R.TransactionType
				  INNER JOIN Item M ON M.ItemNo = T.ItemNo 
				  INNER JOIN ItemUoM I ON T.ItemNo = I.ItemNo AND T.TransactionUoM = I.UoM 
				  INNER JOIN WarehouseBatch B ON B.BatchNo = T.TransactionBatchNo 
				  INNER JOIN WarehouseLocation W ON T.Warehouse = W.Warehouse AND T.Location = W.Location
				  LEFT OUTER JOIN AssetItem AI ON AI.AssetId = T.AssetId
				  LEFT OUTER JOIN Employee.dbo.Person P ON T.PersonNo = P.PersonNo
  		WHERE     T.TransactionBatchNo  = '#URL.BatchNo#'  	
		
		<cfif url.itemNo neq "">
		AND        I.ItemNo = '#url.itemno#'
		</cfif>
		
		<cfif batch.actionStatus eq "9">
		AND        T.Source = 'Manual'
		</cfif>		
		ORDER BY   T.Warehouse,W.LocationClass,T.Location,T.ItemNo,T.Created DESC			
				

</cfquery>	

<table style="height:100%;width:100%" align = "center">	
	   					
    <TR>
	
	<td height="100%" colspan="2" valign="top">
	  
		<table width="100%" height="100%" align="center" class="navigation_table">
		
		<cfoutput>
				
		<tr class="hide"><td height="1" id="process"></td></tr>
					
		</cfoutput>
					
		  <cfif enforcelines eq "0">
		
			  <!--- prechecking to make each line to be cleared --->
			
			  <cfloop query="SearchResult"> 
			
					<cfquery name="Check"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     ItemWarehouseLocationTransaction 
						WHERE    Warehouse       = '#warehouse#'
						AND      Location        = '#Location#'
						AND      ItemNo          = '#Itemno#'
						AND      UoM             = '#TransactionUom#'
						AND      TransactionType = '#TransactionType#' 
					</cfquery>
										
					<cfif check.clearancemode gte "2">
										
						<!--- we enforce individual clearance based on the deeper level --->							
						<cfset enforcelines = "1">
				
					</cfif>
											
			   </cfloop>
			   
		   </cfif>	   
		   
		   <cfif searchresult.recordcount gte "1">
		   		  	  		  
			   <cfif url.mode eq "process" or url.mode eq "undefined" or url.mode eq "" or getAdministrator("*") eq "1">
			   			   			   
				   <tr class="line"><td colspan="12">
				   
					   	  <table>
						  
						  	<tr class="labelmedium">
							<td>
					   						   
					   		<cfinvoke component = "Service.Presentation.TableFilter"  
							   method           = "tablefilterfield" 
							   filtermode       = "direct"
							   name             = "filtersearch"
							   style            = "font:13px;height:21;width:120"
							   rowclass         = "clsTransaction"
							   rowfields        = "ccontent,cbarcode,cdecal,cserialno,cofficer">					  
							   
							</td>				 
							 
							<cfoutput>		
							
							<cfinvoke component = "Service.Access"  
							   method           = "Journal" 
							   journal          = "#SearchResult.Journal#"
							   returnvariable   = "access">	  
														   
							<!--- we showuld margin information only to finance officers --->   
												
							<cfif SearchResult.Journal neq "" and access neq "NONE">  
														
								<td style="padding:4px">|</td>		
																						
								<td>		
								<input type="radio" class="radiol" name="modality" value="9" <cfif url.modality eq "9">checked</cfif> onclick="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('BatchViewTransactionLines.cfm?systemfunctionid=#url.systemfunctionid#&batchno=#url.batchno#&mode=process&modality=9','main')">
								</td>		
								<td style="font-size:15px;padding-left:3px"><cf_tl id="Hide Sales Margin"></td>	
								<td style="padding-left:7px">		
								<input type="radio" class="radiol" name="modality" value="1" <cfif url.modality eq "1">checked</cfif> onclick="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('BatchViewTransactionLines.cfm?systemfunctionid=#url.systemfunctionid#&batchno=#url.batchno#&mode=process&modality=1','main')">
								</td>
								<td style="font-size:15px;padding-left:3px"><cf_tl id="Show Sales Margin"></td>			
								<td style="padding:4px">|</td>	
								
							<cfelseif access neq "NONE">
							
							    <td style="padding:4px">|</td>		
																						
								<td>		
								<input type="radio" class="radiol" name="modality" value="9" <cfif url.modality eq "9">checked</cfif> onclick="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('BatchViewTransactionLines.cfm?systemfunctionid=#url.systemfunctionid#&batchno=#url.batchno#&mode=process&modality=9','main')">
								</td>		
								<td style="font-size:15px;padding-left:3px"><cf_tl id="Quantities"></td>	
								<td style="padding-left:7px">		
								<input type="radio" class="radiol" name="modality" value="1" <cfif url.modality eq "1">checked</cfif> onclick="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('BatchViewTransactionLines.cfm?systemfunctionid=#url.systemfunctionid#&batchno=#url.batchno#&mode=process&modality=1','main')">
								</td>
								<td style="font-size:15px;padding-left:3px"><cf_tl id="Quantities and Value"></td>			
								<td style="padding:4px">|</td>	
																							
							</cfif>
							
							<cfif url.mode neq "embed" and searchresult.recordcount gte "30">																
												  
								<td class="labelmedium" style="font-size:16px">				
									<a href="javascript:Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('BatchViewTransactionListing.cfm?systemfunctionid=#url.systemfunctionid#&batchno=#url.batchno#','main')"><font color="0080C0"><cf_tl id="Show as grid"></font></a>																		
								</td>
								</cfif>
							
							</cfoutput>
																											  
							</tr>
																		  
						  </table> 
									
					</td>
					</tr>	
									
				</cfif>
		   
		    </cfif>			
						
			<cfset rcl = "E6F2FF">
			
			<cfset prior = "">
			<cfset priorRemarks = "">
			<cfset row = 0>
			
			<cfset tot = 0>
			
			<tr>
			<td colspan="16" style="<cfif url.mode eq 'embed'>height:180px<cfelse>height:100%</cfif>;border:0px solid silver;padding-bottom:4px">
								
			<cf_divscroll id="main" style="padding:8px;height:100%">	
						
			<table width="99%">
			
			<cfoutput>
			
			<tr class="labelmedium line fixrow fixlengthlist">
			    <td></td>
			    <td></td>  				
					 
				<cfif URL.id neq "">
				
				    <TD><cf_tl id="Type"></TD>				
					<TD><cf_tl id="Reference"></TD>
					<TD><cf_tl id="Voucher"></TD>			
					<TD><cfif searchresult.assetid neq ""><cf_tl id="Make">/<cf_tl id="Id"><cfelseif searchresult.workorderid neq ""><cf_tl id="Workorder"><cfelse><cf_tl id="Beneficiary"></cfif></TD>
					
				<cfelseif Batch.BatchDescription eq "Receipt Distribution">
							   
				    <TD colspan="4"><cf_tl id="Product"></TD>				
					
				<cfelse>	
										
					<cfif batch.transactiontype eq "9">
					<TD colspan="3"><cf_tl id="Product"></TD>
					<td></td>
					<cfelse>	
					<TD colspan="2"><cf_tl id="Product"></TD>
					<TD><cf_tl id="Voucher"></TD>			
					<TD><cfif searchresult.assetid neq ""><cf_tl id="Make">/<cf_tl id="Id"><cfelseif searchresult.workorderid neq ""><cf_tl id="Workorder"><cfelse><cf_tl id="Beneficiary"></cfif></TD>
					</cfif>
				   				
				</cfif>	  				
				
				<cfif Batch.TransactionType neq "5">
				<td>
					<cfif param.LotManagement eq "1">
						<cf_tl id="Lot">
					<cfelse>
						<cf_tl id="Metric">
					</cfif>
				</td>		
				<TD><cf_tl id="Request"></TD>			
				<cfelse>
				<TD colspan="2"><cf_tl id="Stock amendment"></TD>					
				</cfif>
				<TD><cf_tl id="Date"></TD>						
				<TD align="right"><cf_tl id="UoM"></TD>
			    <TD align="right"><cf_tl id="Quantity"></TD>				
				<TD>
					<cf_UIToolTip tooltip="Accounts Payable for outsourced transaction"><cf_tl id="AP"></cf_UIToolTip>
				</TD>	
			
			</tr>
			
			</cfoutput>		
			
			<cfif url.modality eq "1">
			
				<tr  class="labelmedium">
						<td></td>
						<td></td>						
												
						<td colspan="9" bgcolor="DAF9FC" align="right">
							<table height="100%">
							<tr class="labelmedium">
							    <td style="min-width:12px"></td>
							    <td style="border-right:1px solid silver;padding-right:4px" align="right"></td>
								<td style="min-width:90px;border-right:1px solid silver;padding-right:4px" align="right"><cf_tl id="Price"></td>															
								<td style="min-width:90px;border-right:1px solid silver;padding-right:4px" align="right"><cf_tl id="Net Sale"></td>								
								<td style="min-width:90px;border-right:1px solid silver;padding-right:4px" align="right"><cf_tl id="Tax"></td>
								<td style="min-width:90px;border-right:1px solid silver;padding-right:4px" align="right"><cf_tl id="Receivable"></td>
								<td style="min-width:90px;border-right:1px solid silver;padding-right:4px" align="right" bgcolor="f1f1f1"></td>
								<td style="min-width:110px;border-right:1px solid silver;padding-right:4px" align="right" bgcolor="f1f1f1"><cf_tl id="COGS"></td>
								<td style="min-width:110px;border-right:1px solid silver;padding-right:4px" align="right" bgcolor="f1f1f1"><cf_tl id="Sale"></td>
								<td style="min-width:110px;border-right:1px solid silver;padding-right:4px" align="right" bgcolor="f1f1f1"><cf_tl id="Margin"></td>							
							</tr>
							</table>
						</td>
						<td style="width:23px"></td>
				</tr>
			
			</cfif>
			
			<!--- no longer needed 	
						
			<tr style="height:1px">
			    <td style="min-width:20px"></td>
			    <td style="min-width:20px"></td>  					 
				<cfif URL.id neq "">			
				    <TD style="min-width:100px"></TD>				
					<TD style="min-width:80px"></TD>
					<TD style="min-width:100px"></TD>			
					<TD style="min-width:150px"></TD>				
				<cfelseif Batch.BatchDescription eq "Receipt Distribution">						   
				    <TD style="width:100%" colspan="4"></TD>								
				<cfelse>										
					<cfif batch.transactiontype eq "9">
					<TD style="width:100%" colspan="3"></TD>
					<td style="min-width:100px"></td>
					<cfelse>	
					<TD style="width:100%" colspan="2"></TD>
					<TD style="min-width:100px"></TD>			
					<TD style="min-width:150px"></TD>
					</cfif>			   				
				</cfif>	  				
				
				<cfif Batch.TransactionType neq "5">
				<td style="min-width:60px"></td>		
				<TD style="min-width:150px"></TD>			
				<cfelse>
				<TD style="min-width:150px" colspan="2"></TD>					
				</cfif>
				<TD style="min-width:100px"></TD>								
				<TD style="min-width:70px"></TD>
			    <TD style="min-width:100px"></TD>				
				<TD style="min-width:35px"></TD>				
		    </tr>
			
			--->
						
			<!--- ---------------------------------------- --->
			<!--- ------------- LISTING ------------------ --->
			<!--- ---------------------------------------- --->
																									
		   	<cfoutput query="SearchResult" Group="Warehouse"> 	
			
				<!--- ---------------------------------------- --->
				<!--- ------------- WAREHOUSE----------------- --->
				<!--- ---------------------------------------- --->					
					
				  <cfoutput Group="LocationClass">
					
					<!--- ---------------------------------------- --->
					<!--- --------------- LOCATION --------------- --->
					<!--- ---------------------------------------- --->
					
					<tr class="fixrow2">
							<td class="labellarge" style="font-size:20px;height:33px;padding-left:4px" colspan="12">
														
							<cfif warehouse neq Batch.Warehouse>
																					
									<cfquery name="Warehouse"
										datasource="AppsMaterials" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT   *
											FROM     Warehouse 
											WHERE    Warehouse       = '#warehouse#'									
										</cfquery>
			
										#Warehouse.WarehouseName#
										
							<cfelse>	
							
							     <cfquery name="Warehouse"
										datasource="AppsMaterials" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT   *
											FROM     Warehouse 
											WHERE    Warehouse       = '#Batch.warehouse#'									
										</cfquery>
			
										#Warehouse.WarehouseName#		
													
							</cfif>		
							
							#LocationClass#
																					
							</td>	
						</tr>								
						
						<cfset workflowcheck = "1">
						<cfset prioritemno   = "">
				
					<cfoutput>
					
						<!--- ---------------------------------------- --->
						<!--- --------------- LINES -- --------------- --->
						<!--- ---------------------------------------- --->
									
						<!--- we better define this if a transaction is a parent we hide the parent which is negative --->
						
						<cfif batch.warehouse neq warehouse>
						
							<!--- check if the person has access to this warehouse --->
													
							<cfinvoke component = "Service.Access"  
							     method             = "function"  
								 role               = "'WhsPick'"
								 mission            = "#batch.mission#"
								 warehouse          = "#warehouse#"
								 SystemFunctionId   = "#url.SystemFunctionId#" 
								 returnvariable     = "access">	 	
																												
						
						<cfelse>
						
							<cfset access = "GRANTED">
						
						</cfif>
									
						<cfif (TransactionType eq "8" and TransactionQuantity lt 0) 
						     and access neq "GRANTED" 
							 and url.stockorderid eq "">
						   <cfset cl = "hide">								   					   				   
						<cfelseif url.modality eq "9">
						   <cfset cl = "hide">	
						   <cfset row = row+1>	
						<cfelse>
						   <cfset cl = "regular">	
						   <cfset row = row+1>					   
						</cfif>
						
						<cfif batch.transactiontype eq "8">
						    <cfset tot = tot + round(TransactionQuantity*10000)/10000>
						<cfelseif TransactionType eq "8" and TransactionQuantity lt "0">
						<cfelse>
							<cfset tot = tot + TransactionQuantity>						
						</cfif>
						
						<!--- ----------------------- --->
						<!--- ------- Main line ----- --->
						<!--- ----------------------- --->	
						
				  		<cf_precision number="#ItemPrecision#">
																													
						<tr id="r#currentrow#" class="clsTransaction navigation_row line labelmedium fixlengthlist" style="height:20px;cursor:pointer;">							
							
									<td width="1%">
									
										<table>
										<tr class="labelmedium" style="height:20px">		
											<td style="padding-left:5px;height:20px;width:30px;">#row#.</td>							
											<td align="center" style="padding:2px">
											<img onclick="batchtransaction('#transactionid#','#url.systemfunctionid#','process')" 
											  height="15" width="16" 
											  src="#session.root#/images/TransactionType/#transactionType#.png" alt="" border="0">
										</td>
										    
										</tr>
										</table>
									
									</td>	
									
									<td class="hide ccontent">#Description# #ItemNoExternal# #ItemBarcode# #ItemDescription# #Make# #Model# #TransactionReference# #RequestReference# #assetBarcode# #serialNo# #AssetDecalNo#</td>
														
									<td id="status_#transactionid#">
									
									    <!--- ------------------------------------ --->
									    <!--- defined the process mode to be shown --->
										<!--- ------------------------------------ --->
										
										<cfif url.mode eq "process" and Batch.ActionStatus neq "9">
										
											 <cfif itemno neq priorItemno or workflowcheck eq "1">
											 																																																																																
												<cfquery name="Check"
												datasource="AppsMaterials" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT   *
													FROM     ItemWarehouseLocationTransaction 
													WHERE    Warehouse       = '#warehouse#'
													AND      Location        = '#Location#'
													AND      ItemNo          = '#itemno#'
													AND      UoM             = '#transactionuom#'
													AND      TransactionType = '#TransactionType#'
												</cfquery>
												
												<cfset workflowcheck = "0">
												<cfset prioritemno = itemno>	
												
												<cfif Check.recordcount eq "0">
																								
													<cfquery name="Check"
													datasource="AppsMaterials" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
														SELECT   *
														FROM     WarehouseTransaction 
														WHERE    Warehouse       = '#warehouse#'													
														AND      TransactionType = '#TransactionType#'
													</cfquery>
												
												</cfif>																																						
											
											</cfif>
											
											<cfset clearmode = check.clearancemode>											
											
											<cfif clearmode eq "3">		
																		
												<cfquery name="Object"
												datasource="AppsOrganization" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT   *
													FROM     OrganizationObject
													WHERE    ObjectKeyValue4 = '#transactionid#'										
												</cfquery>
												
												<cfif Object.recordcount eq "0">
												
													<!--- if not object exists reset to status = 2 as it was not needed --->									
													<cfset clearmode = "2">		
													
												</cfif>											
											
											</cfif>								
																		
											<cfif clearmode eq "2" or (enforcelines eq "1" and clearmode neq "3")>
																																												 
												<cfif ActionStatus eq "0">
																										 
												  <img src="#SESSION.root#/Images/button.jpg"
												      border="0" 
												 	  onclick="setlinestatus('#transactionid#','1')" height="14" width="16"
													  align="absmiddle" style="cursor: pointer;">
									 
									 			<cfelse>												
											
												   <cfif batch.actionStatus eq "0">								   
												   
													   <img src="#SESSION.root#/Images/TransactionType/validate.png" border="0" 
													   height="16" width="14" onclick="setlinestatus('#transactionid#','0')"
													   align="absmiddle" style="cursor: pointer;">
												   
												   <cfelse>
												   								   
													   <img src="#SESSION.root#/Images/TransactionType/validate.png" border="0" 
													   height="16" width="14" align="absmiddle" style="cursor: pointer;">
									 								   
												   </cfif>
									 
									 			</cfif>		
												
											<cfelse>
											
												<cfif ActionStatus eq "1">
												
												 <img src="#SESSION.root#/Images/TransactionType/validate.png" border="0" height="16" width="14"								  
													 align="absmiddle">
													 
												<cfelse>
												
													<cfif clearmode eq "1" or clearmode eq "">
													
													 <img src="#SESSION.root#/Images/pending.gif" border="0" height="16" width="14"							  
														 align="absmiddle" alt="Batch clearance">	 
													
													<cfelse>
													
													 <img src="#SESSION.root#/Images/pending2.gif" border="0" height="16" width="14"							  
														 align="absmiddle" alt="Process workflow">									
													
													</cfif>	 
													 
												</cfif>	 														
																		
											</cfif>
											
										</cfif>	
									</td>										
																													
									<cfif Batch.BatchDescription eq "Receipt Distribution">
									
									<td style="background-color:e1e1e1;border-left:1px solid silver">#LocationDescription#</td>		
									
									<TD colspan="2" title="#LocationDescription# #ItemDescription#">
										<a class="navigation_action" href="javascript:item('#itemno#','','#mission#')">#ItemDescription#</a>																												
									</TD>			
									<td>#ItemBarCode#</td>							
									
									<cfelse>
									
									<cfif batch.transactiontype eq "9">
									
									        <td style="background-color:e1e1e1;border-left:1px solid silver">#LocationDescription#</td>		
									
											<TD colspan="2">
												<a class="navigation_action" href="javascript:item('#itemno#','','#mission#')">																						
												#ItemNo# #ItemDescription#												
												</a>																				
											</TD>												
											<td>#ItemBarCode#</td>
									
									<cfelse>	
									
									    	<td class="fixlength" style="width:100px;background-color:e1e1e1;border-left:1px solid silver">#LocationDescription#</td>										
																				
											<TD colspan="1">
											
												<table align="left" style="width:100%;height:100%">
													<tr class="labelmedium fixlengthlist" style="height:20px">													    
														<td align="left" title="#itemDescription# #ItemNoExternal#">														   
														   <a class="navigation_action" href="javascript:item('#itemno#','','#mission#')">		
														    <b>#ItemNoExternal#</b> #ItemDescription#  <!--- <cfif itembarcode neq "">-&nbsp;#ItemBarCode#</cfif> --->															
														   </a>														   
														</td>
													</tr>
													
													<!--- show collection actions --->
													
													<cfquery name="qActions"
														datasource="AppsMaterials" 
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
															SELECT  I.ActionCode, I.OfficerUserId, I.ActionDate, I.ActionMemo
															FROM    ItemTransactionAction I INNER JOIN 
																		(SELECT	ActionCode, MAX(ActionDate) as ActionDate
																		FROM	ItemTransactionAction
																		WHERE	TransactionId = '#transactionid#'
																		AND     ActionMemo IS NOT NULL 
																		AND     ActionMemo !=''
																		GROUP BY ActionCode) M	ON     I.ActionCode = M.ActionCode AND I.ActionDate = M.ActionDate
															WHERE	 I.TransactionId = '#transactionid#'
															AND      I.ActionMemo IS NOT NULL 
															AND      I.ActionMemo !=''
															ORDER BY I.ActionDate DESC														
													</cfquery>
													
													<cfif qActions.recordcount neq 0>
													
														<tr style="height:20px">
															<td colspan="2">
															
															<table width="100%" style="background-color:ffffcf">														
															<cfloop query="qActions">
																<tr class="labelmedium" style="height:20px">
																	<td style="border:1px solid silver;border-bottom:0px;padding-left:3px">#qActions.ActionCode#</td>
																	<td style="border:1px solid silver;border-bottom:0px;padding-left:3px">#qActions.OfficerUserId#</td>	
																	<td style="border:1px solid silver;border-bottom:0px;padding-left:3px">#qActions.ActionMemo#</td>	
																	<td style="border:1px solid silver;border-bottom:0px;padding-left:3px">#DateFormat(qActions.ActionDate, client.dateformatshow)# - #timeFormat(qActions.ActionDate, "hh:mm tt")#</td>	
																</tr>	
															</cfloop>
															</table>	
															
															</td>	
														</tr>	
													
													</cfif>
													
												</table>	
											</TD>	
											
											<td style="border-left:1px solid silver" id="reference_#transactionid#">
											
												<cfif batch.actionStatus eq "0" or 
												   (batch.actionstatus eq "1" and getAdministrator(batch.mission) eq "1")>
												
												<table width="100%">
												<tr class="labelmedium" style="height:20px">
											    	
													<td style="padding-left:3px">#TransactionReference#</td>
													
													<cfif (TransactionType eq "2" and FullAccess eq "GRANTED")>
													
														<td align="right" style="padding-right:6px">																							
													    <cf_img icon="edit"
														    onclick="ptoken.navigate('#SESSION.root#/warehouse/application/stock/batch/setTransactionEdit.cfm?field=reference&systemfunctionid=#url.systemfunctionid#&transactionid=#transactionid#','reference_#transactionid#')">																									
														</td>
													
													</cfif>
													
												</tr>
												</table>
												
												<cfelse>
												
													<cfif len(TransactionReference) gt 10>#left(TransactionReference,10)#..<cfelse>#TransactionReference#</cfif>
												
												</cfif>
																				
											</td>											
												
											<TD style="border-left:1px solid silver">	
																				
												<cfif assetid neq "">
												
												    <table width="95%">
													<tr class="labelmedium" style="padding-right:6px"><td width="100%" id="asset_#transactionid#">
														<cfif Make neq "">#Make#<cfelse>#Model#</cfif>/		
														<a href="javascript:AssetDialog('#assetid#')">																									
														<cfif assetdecalNo neq "">#AssetDecalNo#<cfelse>#AssetBarCode#</cfif>															
														</a>		
													</td>
													<cfif (batch.actionStatus eq "0" and FullAccess eq "GRANTED") or (batch.actionstatus eq "1" and getAdministrator(batch.mission) eq "1")>
														<td style="padding-left:5px">
													    <cf_img icon="edit" onclick="lineassetedit('#systemfunctionid#','#transactionid#')">																									
														</td>
													</cfif>
													</tr>
													</table>	
																		
												<cfelseif customerid neq "">												
												
												<cfquery name="getCustomer"
													datasource="AppsMaterials" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
														SELECT   *
														FROM     Customer C
														WHERE    CustomerId = '#customerid#'
													</cfquery>
													
													#getCustomer.CustomerName#
																						
													<!--- pending for customer --->
													
												<cfelseif workorderid neq "">
																																	
													<cfquery name="getWorkOrder"
													datasource="AppsWorkOrder" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
														SELECT   *
														FROM     WorkOrder W, Customer C
														WHERE    WorkOrderId = '#workorderid#'
														AND      W.CustomerId = C.CustomerId
													</cfquery>
													
													#getWorkOrder.CustomerName#
																							
													<!--- pending for workorder ---> 
													
												<cfelse>
												
												    <!--- we keep it blank here --->
												
												</cfif>
												
											</TD>
											
										</cfif>	
									
									</cfif>
									
									<cfif Batch.TransactionType neq "5">
									
										<td id="metric_#transactionid#">
										  <cfif Param.LotManagement eq "1">
										  	#TransactionLot#									 
										  <cfelseif MetricValue neq "0">										  
											 #numberformat(MetricValue,",._")#									 
										  </cfif>									 
										</td>																				
										<td id="person_#transactionid#" style="min-width:120px">
										
											<cfif RequestReference neq "">
											<a href="javascript:mail2('print','#RequestReference#')">#RequestReference#</a>
											<cfelseif Personno neq "">										
											#LastName# <cfif reference neq "">(#Reference#)</cfif>																		
											<cfelseif workorderid neq "">
											
												<cfparam name="wprior" default="">
												
												<cfif workorderid neq wprior>
												
													<cfquery name="workorder"
														datasource="AppsWorkOrder" 
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
														SELECT   *
														FROM     WorkOrder
														WHERE    WorkOrderId  = '#WorkOrderId#'					
													</cfquery>
												
												</cfif>
												
												<cfset  wrefer = workorder.reference>
												<cfset  wprior = workorderid>
												#wrefer#												
											
											</cfif>
										
										</td>		
									
									<cfelse>
									
										<td colspan="2">
											<cfif TransactionOnHand neq "">
										    <font color="6688aa">#numberformat(TransactionOnHand,pformat)#</font>
											-> 
											<font color="008000"><b>#numberformat(TransactionOnHand+TransactionQuantity,pformat)#</font>		
											</cfif>
										</td>
																		
									</cfif>							
																						
									<TD class="cdate">
									
										<cfif dateformat(Batch.TransactionDate,CLIENT.DateFormatShow) neq Dateformat(TransactionDate,"#CLIENT.DateFormatShow#")>
											#Dateformat(TransactionDate,"DD/MM/YY")#
										<cfelse>
											<font size="1" color="808080">Ibid.</font>
										</cfif>
																			
									</TD>																
									
									<td align="right" class="cuom">#UoMDescription#</td>			
									
									<td id="quantity_#transactionid#" align="right">
									
									    <table width="100%" height="100%">
										
										<tr>																			
										
										<td width="100%" bgcolor="ffffaf" align="right" style="padding-left:3px; padding-right:3px;border-left:1px solid silver;border-right:1px solid silver">
			
											<cfif transactionQuantity eq "0" and TransactionType neq "5">											
												<font color="FF0000"><cf_tl id="voided"></font>						
											<cfelseif TransactionQuantity eq "0">
												<font  color="green"><cf_tl id="Matches"></font>																		
											<cfelse>																				
																					   
												<cfif TransactionQuantity lt "0" and Batch.transactiontype neq "2">
													<font color="FF0000">
												</cfif>
												<cfif transactiontype eq "2">
													#NumberFormat(-TransactionQuantity,'#pformat#')#
												<cfelse>
													#NumberFormat(TransactionQuantity,'#pformat#')#
												</cfif>
																							
											</cfif>
										
										</td>		
										
										<td>
																		
										<!--- allow editing --->
										
										<cfif batch.actionStatus eq "0" and url.mode neq "embed">										
																				
										    <cfif TransactionType eq "2" and FullAccess eq "GRANTED">
											
											    <table width="100%">
												
													<tr>	
													
													<td style="padding-left:2px;width:30;padding-right:1px" align="right">																					
													    <cf_img icon="edit" onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/warehouse/application/stock/batch/setTransactionEdit.cfm?field=quantity&systemfunctionid=#url.systemfunctionid#&transactionid=#transactionid#','quantity_#transactionid#')">															
													</td>												
													
													<cfif workflowid eq "">		
													
													    <!--- ----------------------------------------------------------------------------- --->													
													    <!--- 15/4/2013 we only check for the transaction mode is the location/item changes --->
														<!--- ----------------------------------------------------------------------------- --->
														
													    <cfif itemno neq prioritemno or workflowcheck eq "1">
																																																																																
															<cfquery name="Check"
															datasource="AppsMaterials" 
															username="#SESSION.login#" 
															password="#SESSION.dbpw#">
																SELECT   *
																FROM     ItemWarehouseLocationTransaction 
																WHERE    Warehouse       = '#warehouse#'
																AND      Location        = '#Location#'
																AND      ItemNo          = '#itemno#'
																AND      UoM             = '#transactionuom#'
																AND      TransactionType = '#TransactionType#'
															</cfquery>
															
															<cfset workflowcheck = "0">
															<cfset prioritemno = itemno>																															
														
														</cfif>
														
														<cfif check.entityclass neq "">
																										
															<td style="padding-left:5px" id="workflow_#transactionid#">
															
																<img src="#SESSION.root#/images/workflow_task.gif" 
																     alt="Submit an observation" 
																	 height="12" width="12"
																	 border="0" 
																	 onclick="transactionobservation('#transactionid#')">
																	 
															</td>
														
														</cfif>
																											
													</cfif>
													
													</tr>
													
												</table>
																			
											<cfelseif TransactionClass eq "Transfer" and BatchTransactionType neq "3"> 
																													
												<cfquery name="get"
												datasource="AppsMaterials" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT   *
													FROM     ItemTransaction 
													WHERE    ParentTransactionId = '#transactionid#'								
												</cfquery>
												
												 <table width="100%">
												
													<tr>
													<td style="width:30px">	
												
														<!--- only allowed if the transfer has just one counter transaction --->																																																			
													    <cfif get.recordcount eq "1" and FullAccess eq "GRANTED" and batch.actionstatus eq "0">												
																										
															<cfif transactionquantity lt "0">																													
																 <cf_img icon="edit" 
																   onclick="ptoken.navigate('#SESSION.root#/warehouse/application/stock/batch/setTransactionEdit.cfm?field=quantity&transactionid=#transactionid#&systemfunctionid=#url.systemfunctionid#','quantity_#transactionid#')">																																								 
															</cfif>
														
														</cfif>
														
														<cf_space spaces="4">
													
													</td>													
													</tr>
													
												   </table>	
												
											</cfif>	
										
										</cfif>
										
										</td>										
										
										</tr>
										</table>									
										
									</td>																										
																		
									<TD>		
									
									    <cfif url.mode neq "embed" and url.stockorderid eq "">			
									
											<cfif (EditAccess eq "GRANTED" or FullAccess eq "GRANTED") and location.BillingMode eq "External" and TransactionQuantity lt "0" and BillingStatus eq "0">
											
												<cfif BillingMode eq "External">
												     <input type="checkbox" name="BillingMode_#transactionid#" value="External" checked onclick="ColdFusion.navigate('StockTransactionBillingMode.cfm?transactionid=#transactionid#&selected='+this.checked,'process')">
												<cfelse>
												     <input type="checkbox" name="BillingMode_#transactionid#" value="External" onclick="ColdFusion.navigate('StockTransactionBillingMode.cfm?transactionid=#transactionid#&selected='+this.checked,'process')">						
												</cfif>
												
											<cfelse>
											
												<cfif billingmode eq "External">Yes<cfelse>No</cfif>
											
											</cfif>
											
										<cfelse>
										
											<cfif billingmode eq "External">Yes<cfelse>No</cfif>
										
										</cfif>						
														
									</TD>
									
						</TR>	
																		
						<cfif shipping neq "" and Batch.Warehouse eq Warehouse>
						
							<cfquery name="Shipping"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">						
								SELECT * FROM ItemTransactionShipping 
								WHERE  TransactionId = '#transactionid#'
							</cfquery>
							
							<tr class="#cl# clsTransaction line" style="height:20px">
							<td class="hide ccontent">#ItemBarcode#  #ItemDescription# #Make# #Model# #TransactionReference# #RequestReference# #assetBarcode# #serialNo# #AssetDecalNo#</td>							
							<td></td>	
							<td></td>						
													
							<td colspan="9" align="right">
							
								<table height="100%">
								
								<tr class="labelmedium" style="height:20px">								    								    
								    <td style="width:100%;border-right:1px solid silver;padding-right:4px" align="right">#shipping.salesCurrency#</td>
									<td align="right" style="background-color:DAF9FC;min-width:90px;border-right:1px solid silver;padding-right:4px">#numberformat(shipping.salesPrice,",.__")#</td>
									<td align="right" style="background-color:DAF9FC;min-width:90px;border-right:1px solid silver;padding-right:4px">#numberformat(shipping.SalesAmount,",.__")#</b></td>																											
									<td align="right" style="background-color:DAF9FC;min-width:90px;border-right:1px solid silver;padding-right:4px">#numberformat(shipping.SalesTax,",.__")#</td>
									<td align="right" style="background-color:DAF9FC;min-width:90px;border-right:1px solid silver;padding-right:4px">#numberformat(shipping.SalesTotal,",.__")#</td>
									<td bgcolor="f1f1f1" style="min-width:90px;border-right:1px solid silver;padding-right:4px" align="right">#Application.BaseCurrency#</td>
									<td bgcolor="f1f1f1" style="min-width:110px;border-right:1px solid silver;padding-right:4px" align="right">
									<cfif url.modality eq "1" and journalCOGS neq "">
									<a href="javascript:ShowTransaction('#JournalCOGS#','#JournalSerialNoCOGS#','','tab','')">#numberformat(TransactionValue*-1,",.__")#</a>									
									<cfelse>
									#numberformat(TransactionValue*-1,",.__")#
									</cfif>
									</td>
									<td bgcolor="f1f1f1" style="min-width:110px;border-right:1px solid silver;padding-right:4px" align="right">#numberformat(shipping.SalesBaseAmount,",.__")#</b></td>
									<cfset margin = shipping.SalesBaseAmount + TransactionValue>
									<cfif margin gte "0">									
									    <cfset cl = "lime">
									<cfelse>
										<cfset cl = "FF8080">
									</cfif>
									<cfif shipping.SalesBaseAmount neq "0">
										<cfset ratio = (margin*100 / shipping.SalesBaseAmount)>
										<td bgcolor="#cl#" style="min-width:110px;color:black;padding-right:4px" align="right">(#numberformat(ratio,"_._")#%) #numberformat(margin,",.__")#</b></td>							
									<cfelse>
										<td bgcolor="#cl#" style="min-width:110px;color:black;padding-right:4px" align="right">#numberformat(margin,",.__")#</b></td>
							
									</cfif>
								</tr>
								
								</table>
								
							</td>
							<td></td>
							</tr>
						
						</cfif>
						
									
						<!--- ------------------------------------ --->	
						<!--- --------ADDITIONAL DETAIL 1-4 ------ --->
						<!--- ------------------------------------ --->
							
						<cfif Remarks neq "" and Remarks neq priorRemarks>
							
							<tr class="clsTransaction #cl# navigation_row_child">
							    <td colspan="2"></td>
							    <td class="hide ccontent">#ItemDescription# #Make# #Model# #TransactionReference# #RequestReference#</td>
							    <td class="labelit" style="color:gray;padding-left:0px" colspan="12">#Remarks#</td>
							</tr>
							
							<cfset priorRemarks = Remarks>
								
						</cfif>
							
						<!--- ------------------------------------ --->	
						<!--- --------ADDITIONAL DETAIL 2-4 ------ --->
						<!--- ------------------------------------ --->
							
						<cf_fileexist 
							DocumentPath="WhsTransaction" 
							SubDirectory="#transactionid#" 
							Filter=""> 
																		
						<cfif files gte "1">	
							 	
							 <tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('#rcl#'))#" class="navigation_row_child labelmedium">
							 
							  <td colspan="3" align="right" style="padding:4px"><cf_tl id="Attachment">:</td>
							  <td colspan="8">				  
							  				  
								  <cf_filelibraryN 
										DocumentPath="WhsTransaction" 
										SubDirectory="#transactionid#" 
										Filter="" 
										Insert="yes" 
										Remove="no" 
										LoadScript="false" 
										rowHeader="no" 
										ShowSize="yes"> 
							  
							  </td>		
							  
						     </tr>
						   
						</cfif>
						   
						<!--- ------------------------------------ --->	
						<!--- --------ADDITIONAL DETAIL 3-4 ------ --->
						<!--- ------------------------------------ --->	
						  
						<cfif detailid neq "">
						   
							  <cfquery name="getCategory"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT *
										FROM   Ref_Category
										WHERE  Category = '#ItemCategory#'	
							  </cfquery>		
						  									
							  <cfif getCategory.DistributionMode eq "Meter">
								
									<cfquery name="getDetail"
										datasource="AppsMaterials" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										    SELECT *
											FROM   ItemTransactionDetail
											WHERE  TransactionId = '#transactionid#'	
									</cfquery>																
									
									<cfloop query="getDetail">	
															
									  <tr class="clsTransaction #cl# navigation_row_child">
									  
									      <td class="hide ccontent">#SearchResult.ItemDescription# #SearchResult.Make# #SearchResult.Model# #SearchResult.TransactionReference# #SearchResult.RequestReference#</td> 
										  
										  <td colspan="5"></td>
									      <td colspan="5" style="padding-bottom:2px;padding-top:1px;">
									  
										  <table width="200" bgcolor="ffffdf" border="0" style="border:1px solid silver" cellspacing="0" cellpadding="0" class="formpadding">
										  
											  <tr class="line">	   
											       <td style="padding-left:5px" width="100" class="labelit"><cf_tl id="Meter">:</td>										   
												   <td style="padding:2px"><cfif getDetail.Reference1 eq "">n/a<cfelse>#getDetail.Reference1#</cfif></td>
											  </tr>	
											 
											  <tr class="line">
											       <td style="padding-left:5px" class="labelit"><cf_tl id="Reading Initial">:</td>			    
												   <td style="padding:2px">#getDetail.MeterReadingInitial#</td>
											  </tr>
											  
											  <tr class="line"> <td style="padding-left:5px" class="labelit"><cf_tl id="Reading Final">:</td>   
												   <td style="padding:2px">#getDetail.MeterReadingFinal#</td>
											  </tr>	
											 										  
										  </table>
										  
									  </td></tr>   
									
									</cfloop>
								
								</cfif>
								
							</cfif>	
							
						<!--- ------------------------------------ --->	
						<!--- --------ADDITIONAL DETAIL 4-4 ------ --->
						<!--- ------------------------------------ --->																		   							   						   
						  								  					
						<cfif AssetId neq "">
						
							   <!--- disabled 		
																											   
							   <tr class="clsTransaction #cl#" bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('#rcl#'))#">	 
							   
							   	   <td class="ccontent hide">#ItemDescription# #Make# #Model# #TransactionReference# #RequestReference#</td>
								   
								   <td></td>
							     									      										   	  
								   <td colspan="9" style="padding-left:10px">
								   
									   <table cellspacing="0" cellpadding="0">
									       <tr><td colspan="10" class="linedotted"></td></tr>
										   <tr>
										   
											   <td width="20" style="padding-left:8px" class="labelsmall"><font color="808080"><img src="#SESSION.root#/images/join.gif" align="absmiddle" alt="" border="0"></td>
																						   	  												  
											   <td style="width:50;padding-left:2px" class="labelsmall"><font color="808080"><cf_tl id="BarCode">:</td>
											   <td style="width:140;padding-left:2px" class="labelit cbarcode">
											   <a href="javascript:AssetDialog('#assetid#')"><font color="0080C0">#AssetBarCode#</font></a></td>													   
											  													   
											   <cfif AssetDecalNo neq "" and AssetDecalNo neq "0">
												   <td style="width:50;padding-left:2px" class="labelsmall"><font color="808080"><cf_tl id="DecalNo">:</td>
												   <td style="width:140;padding-left:1px" class="labelit cdecal"><cfif AssetDecalNo neq "">
												   <a href="javascript:AssetDialog('#assetid#')"><font color="0080C0">#AssetDecalNo#<cfelse>n/a</cfif></a></td>
											   <cfelse>
												   <td style="width:50;padding-left:2px" class="labelsmall"><font color="808080"><cf_tl id="SerialNo">:</td>
												   <td style="width:140;padding-left:1px" class="labelit cserialno"><cfif SerialNo neq "">#SerialNo#<cfelse>n/a</cfif></td>
											   </cfif>
											  												  
											   <td style="width:80;padding-left:8px" class="labelsmall"><font color="808080"><cf_tl id="Receiver">:</td>
											   <td style="width:200;padding-left:1px" class="labelit cofficer"><cfif lastname eq "">n/a<cfelse>#FirstName# #LastName# (#Reference#)</cfif></td>													   
											  														
											   <cfif Metric neq "">
												     <td style="width:80;padding-left:8px" class="labelsmall"><font color="808080">#Metric#:</td>
												     <td style="width:90;padding-left:1px" class="labelit">#numberformat(MetricValue,"__,__._")#</td>			
											   </cfif>															
												
										   </tr>	
									   </table>
									   
								   </td>
								 
								   <td></td>
								   <td></td>
								   										   			   
							   </tr>
							   
							   --->
							   
						<cfelseif customerid neq "">
						
																				
						<cfelseif workorderid neq "">
														  									  																	
						</cfif>													
																
						<!--- ------------------------------------------- --->	
						<!--- --------ADDITIONAL DETAIL 5-5 Fuel only---- --->
						<!--- ------------------------------------------- --->
																										
						<cfif batch.actionStatus neq "9" and AssetId neq "">
												
						       <!--- ----------- --->
							   <!--- validations --->
							   <!--- ----------- --->								   
							  										   
							   <cfif otherQuantity gte "1">
							   
								   <tr class="clsTransaction">
								   							   
								       <td class="ccontent hide">#ItemDescription# #Make# #Model# #TransactionReference# #RequestReference#</td>
									   
									   <td></td>											      
									   <td height="20" class="labelit" style="padding:4px" colspan="11" align="center" bgcolor="ffffaf">		
									     <font color="FFFFFF">
											 <b>Alert</b> : this Item was issued already #numberformat(abs(TransactionQuantity),",__")# for this day.  
										 </font>
									   </td>
								   </tr>
							   
							   </cfif>  
							   		   
							   <!--- -----------check if capacity is exceeded--------- --->
							 						   		   
							   <cfif Capacity lt (TransactionQuantity*-1) AND Capacity gte "1">
						  	 
								   <tr class="clsTransaction">
								       <td class="ccontent hide">#ItemDescription# #Make# #Model# #TransactionReference# #RequestReference#</td>
									   <td></td>										      
									   <td bgcolor="yellow" class="labelit" style="padding:4px" colspan="11" height="20" align="center">		
									     <font color="black">
											 <b>Alert</b> : Issued quantity of #TransactionQuantity*-1# exceeds the capacity (#Capacity#) defined for this item . 
										 </font>
									   </td>
								   </tr>
						   
							   </cfif>  
								  					
							
						</cfif>		
														
						<!--- ----------------------------------------------------------- --->
						<!--- workflow for the transaction : like inventory or correction --->
						<!--- ----------------------------------------------------------- --->	
						
						<cfif workflowid neq "">	
															
							<tr class="clsTransaction">
								<td class="ccontent hide">#ItemDescription# #Make# #Model# #TransactionReference# #RequestReference#</td>
							    <td></td>
							    <td colspan="10" id="#transactionid#">
													
															
								   <cf_wfActive Objectid="#workflowid#">																																				   
								 										   
								   <cfif wfstatus eq "open">										   								   										  								   
								   	  <cfset pendingworkflow = "1">
								   </cfif>
																						   
								   <cfset url.ajaxid = transactionid>
								   <cfinclude template="BatchViewTransactionLineWorkflow.cfm">							    
									   									
								
							
							</td>
							</tr>
						
						</cfif>	
							
						<cfset prior = ItemDescription>
													 									
					</cfoutput>
					
				  </cfoutput>	
				
				</cfoutput>
				
								
				</table>
				
				</cf_divscroll>
				
				<!--- bottom line --->
				
				<cfoutput>		
					
				<cfif url.mode neq "embed">
																
					<tr bgcolor="fafafa" style="border-top:1px solid silver">
						  	<td align="center"></td>
							<td colspan="10" align="right"  style="padding-right:30px;padding-top:4px">
							    <table style="background-color:yellow;border:1px solid silver">
								<tr class="labelmedium2">
								<td style="padding-left:10px;font-size:14px">
							    <cf_tl id="Lines">
								</td>
								<td style="padding-left:5px;font-size:14px;padding-right:4px;border-right:1px solid silver">#searchresult.recordcount#</td>
								
								<td style="padding-left:10px;font-size:14px">
							    <cf_tl id="Quantity">
								</td>
								<td style="padding-left:5px;font-size:14px;padding-right:4px;border-right:1px solid silver">								    						        								
								<cfif searchresult.transactiontype eq "2">
									#NumberFormat(-tot,'#pformat#')#
								<cfelseif batch.transactiontype eq "8">		
								    <cfset tot = round(tot*10000)/10000>							
								    <cfif tot neq "0"><font color="FF0000"><cf_tl id="Not in balance"></font><cfelse><font color="green"><cf_tl id="In balance"></cfif>
								<cfelse>
									#NumberFormat(tot,'#pformat#')#
								</cfif>
								</td>
								<cfif url.modality eq "1">
								
								 <cfquery name="getTotal" dbtype="query">
								 		SELECT sum(Sales) as Total, sum(TransactionValue*-1) as COGS
										FROM   SearchResult</cfquery>		
								
								<td style="padding-left:5px;font-size:14px;padding-right:5px"><cf_tl id="COGS"></td>
								<td style="padding-left:5px;padding-right:4px;border-right:1px solid silver">#numberformat(getTotal.COGS,",.__")#</td>
								<td style="padding-left:5px;font-size:14px;padding-right:5px"><cf_tl id="Sale"></td>
								<td style="padding-left:5px;padding-right:5px">#numberformat(getTotal.total,",.__")#</td>
								</cfif>
								</tr></table>
																
							</td>									
							<td></td>								
					</tr>	
									
				</cfif>
				
				</cfoutput>
				
			</TABLE>
						
		</td>
	</tr>
	
</table>


<cfset AjaxOnLoad("doHighlight")>	
<script>
	Prosis.busy('no')
</script>
