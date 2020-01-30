
<cfparam name="URL.systemfunctionid"   default = "">
<cfparam name="URL.rctid"              default = "">
<cfparam name="URL.taskid"             default = "">
<cfparam name="URL.reqno"              default = "">
<cfparam name="URL.presentation"       default = "0">
<cfparam name="URL.purchase"           default = "">
<cfparam name="URL.select"             default = "">
<cfparam name="URL.id1"                default = "">
<cfparam name="URL.mode"               default = "edit">
<cfparam name="URL.action"             default = "">

<cfif url.reqno neq "">

	<cfquery name="Get" 
	    datasource="AppsPurchase" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	     SELECT * FROM PurchaseLine
		 WHERE RequisitionNo = '#URL.reqno#'
	</cfquery>
		
   <cfset url.purchase = get.PurchaseNo>
   
<cfelseif URL.Mode eq "RI">   

	<cfquery name="Get" 
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT    PL.PurchaseNo
		FROM      PurchaseLineReceipt PR INNER JOIN
                  PurchaseLine PL ON PR.RequisitionNo = PL.RequisitionNo
		WHERE     PR.ReceiptNo = '#URL.rctid#'
       </cfquery>
	
	 <cfset url.purchase = get.PurchaseNo>

</cfif>

<cfif URL.Mode eq "Entry">
  <!--- save the info in a temp table --->
  <cfset tbl = "stPurchaseLineReceipt">    
<cfelse>
  <cfset tbl = "PurchaseLineReceipt">
</cfif>  

<cfif url.action eq "delete">

	<cfquery name="Get" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT * 
		 FROM   #tbl#
		 WHERE  ReceiptId = '#URL.rctid#'
	</cfquery>
		
	<cfset url.taskid = get.warehousetaskid>	

	<cfquery name="Check" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		  DELETE  FROM #tbl# 
		  WHERE   ReceiptId = '#URL.Rctid#'                                           			   
	</cfquery>

</cfif>

<cftry>

	<cfquery name="Check" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		  SELECT  * 
		  FROM    PurchaseLineReceipt PR 
		  WHERE   ReceiptId = '#URL.Rctid#'                                           			   
	</cfquery>

	<cfset rc = Check.receiptNo>
	
	<cfcatch>
	
		<cfset rc = "">
		
	</cfcatch>

</cftry>
 
<cfquery name="Receipts" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	  SELECT  PR.*, 
	          (SELECT UoMDescription
			   FROM   Materials.dbo.ItemUoM U
			   WHERE  ItemNo = PR.warehouseitemno
			   AND    UoM    = PR.WarehouseUoM) as UOMDescription,
	          PL.OrderUoMVolume, 
			  RL.CaseNo,
			  (SELECT   count(*)
			   FROM     Materials.dbo.ItemTransaction R INNER JOIN
	                    Materials.dbo.ItemTransactionValuation Used ON R.TransactionId = Used.TransactionId
			   WHERE    R.ReceiptId = PR.ReceiptId) as Posted
			  
	  FROM    #tbl# PR 
	          INNER JOIN RequisitionLine RL ON PR.RequisitionNo = RL.RequisitionNo 
			  INNER JOIN PurchaseLine PL ON PL.RequisitionNo = RL.RequisitionNo
	  <cfif URL.Mode eq "RI">
	  WHERE   (ReceiptNo = '#URL.rctid#' or ReceiptNo = '#rc#')
	  <cfelseif URL.Mode eq "Receipt">
	  WHERE   ReceiptNo IN (SELECT ReceiptNo 
	                        FROM   PurchaseLineReceipt 
							WHERE  ReceiptId = '#URL.rctid#') 	  
	  <cfelse>
	  WHERE   RL.RequisitionNo = '#URL.reqno#' 	  
	  </cfif>
	  <!---  AND     ActionStatus != '9' --->
	  <cfif URL.select eq "Equipment">	  
	  AND   ReceiptId NOT IN
             		(SELECT ReceiptId
		              FROM  Materials.dbo.AssetItem
					  WHERE ReceiptId = PR.ReceiptId) 
					  
	  AND   PR.WarehouseItemNo IN (SELECT ItemNo 
	                            FROM   Materials.dbo.Item I, Materials.dbo.Ref_Category R
								WHERE  I.Category = R.Category
								AND    I.ItemClass = 'Asset') 
	                                          			   
	  </cfif>	
	  
	  <!--- added to prevent PO-receipts are mixed for open contracts --->
	  <cfif tbl eq "stPurchaselineReceipt" and url.mode eq "entry">
	  AND   PR.OfficerUserId = '#session.acc#'
	  </cfif>	
	  
	  <cfif url.taskid neq "">	 
	  AND    WarehouseTaskId = '#url.taskid#' 
	  <cfelseif url.mode eq "entry">
	  AND    WarehouseTaskId is NULL
	  <cfelse>
	  <!--- no filtering --->
	  </cfif>
	  ORDER BY PR.ReceiptItemNo, PR.Created DESC	 	 	 
</cfquery>

  
<cfquery name="POInfo" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	  SELECT  *
	  FROM    Purchase P,  Ref_OrderType R
	  WHERE   P.PurchaseNo = '#url.purchase#'
	  AND     P.OrderType   =  R.Code	  
</cfquery>

<cfquery name="param" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT    *
   FROM      Ref_ParameterMission
   WHERE     Mission = '#POInfo.mission#'  
</cfquery>

<cfquery name="cost" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT    *
   FROM     ReceiptCost
   <cfif URL.Mode eq "RI" or URL.Mode eq "Receipt">
   WHERE    ReceiptNo = '#Receipts.ReceiptNo#'  
   <cfelse>
   WHERE    1=0  
   </cfif>
</cfquery>

<cfset rows = POInfo.ReceiptEntryLines>
 
<cfinvoke component   = "Service.Access"
	   Method         = "procRI"
	   OrgUnit        = "#POInfo.OrgUnit#"
	   OrderClass     = "#POInfo.OrderClass#"
	   ReturnVariable = "ReceiptAccess">	
    
 <table width="100%">
 
 <tr><td>
 
 <table width="100%" border="0" class="navigation_table"> 
  
 <cfif Receipts.recordcount gte "1">
 	  
	 <cfif url.mode eq "direct">
	 
	 <tr>	 
	 	 <td width="1%"></td>
		 <td width="4%"></td>		
		 <td width="25%"></td>
		 <td width="80"></td>	
		 <td width="10%"></td>				
		 <td width="10%"></td>		
		 <td width="10%"></td>		
		 <td width="5%"></td>		
		 <td colspan="2"></td>	   	   
		 <td width="8%"></td>	
		 <td width="8%"></td>		
		 <cfloop query="Cost">	
		 <td style="width:4px"></td>						
		 </cfloop>
      </tr>	 
	 	 
	 <cfelse>
	   	    		  
		 <cfif URL.Mode eq "Entry">
		   <tr bgcolor="f5f5f5" class="line labelmedium">	  
		 <cfelse>
		   <tr class="line labelmedium">
		 </cfif>
	  
		 <td width="1%">&nbsp;</td>
		 <td style="width:40px;padding-right:4px"></td>		
	     <td width="35%"><cf_tl id="Product"></td>
		 
		 <td width="80" style="padding-right:3px">
		     <cfif url.mode neq "direct"><cf_tl id="Item"></cfif>
		 </td>	
		 
		 <cfif URL.Mode eq "Entry" or url.mode eq "Receipt">
			 <td width="10%"><cf_tl id="Facility"></td>
		 <cfelse>
			 <td width="10%"><cf_tl id="Reference"></td>	
		 </cfif>
			 
		 <cfif url.mode neq "receipt">
		     <!--- otherwise it will show double --->
		     <td width="13%"><cf_tl id="PurchaseNo"></td>
		 <cfelse>
		     <td width="1%"></td>	 
		 </cfif>
			 		
		 <td style="width:140px"><cf_tl id="Date"></td>		
		 <td style="min-width:80px"><cf_tl id="Ordered"></td>	
		 <td style="min-width:80px"><cf_tl id="Volume"></td>	
		 
		 <cfif url.mode neq "direct">
		 	<td style="min-width:100px" align="right"><cf_tl id="Quantity"></td>
		    <td style="width:6%;min-width:100px" align="right"><cf_tl id="UoM"></td>		 	
	   	    <td colspan="2" style="min-width:100px;padding-right:4px" align="right"><cf_tl id="Amount"></td>
			<td style="min-width:80px;border-left:1px solid silver;padding-right:3px" align="right"><cf_tl id="Tax"></td>
			<td style="min-width:80px;border-left:1px solid silver;padding-right:3px" align="right"><cf_tl id="Cost"></td>	
		 <cfelse>			
		 	<td colspan="2"><cf_tl id="Receiver"></td>	   	   
			<td width="8%" align="right"><cf_tl id="Qty"></td>
		    <td style="width:6%;min-width:120px" align="right"><cf_tl id="UoM"></td>			
		 </cfif>
		 <cfoutput query="Cost">	
		 <td align="right" style="min-width:80px;border-left:1px solid silver;padding-right:4px">#Description#</td>						
		 </cfoutput>	
		 <td align="right" style="min-width:4px;border-left:1px solid silver"></td>		 		
	     </tr>
		 
		  <cfif url.mode neq "direct">
			  <cfset cols = "#14+cost.recordcount#">		  	
		  <cfelse>
		  	  <cfset cols = "#12+cost.recordcount#">		  
		  </cfif>
	  		  
	 </cfif>	  
 
 </cfif>
 
 <cfset pen = "0">
      
 <cfoutput query="Receipts">
 	 
     <cfif ActionStatus eq "0">
	   <cfif url.mode eq "direct">	
	      <cfset color = "ffffaf">
	   <cfelse>	  
	      <cfset color = "transparent">
	   </cfif>
	   <cfset pen = "1">
	   <cfset stl = "">	   	   
	 <cfelseif ActionStatus eq "9">  
	   <cfset color = "FFD5D5">
	    <cfset stl = "">		
	 <cfelse>	 
	    <cfif url.mode eq "direct">	
	      <cfset color = "ffffef">
	   <cfelse>	  
	      <cfset color = "transparent">
	   </cfif>
	    <cfset stl = "">		
	 </cfif>
 
 	 <tr bgcolor="#color#" class="labelmedium line navigation_row" style="border-top:1px solid silver;height:22px">
	 
	   <td align="center" style="width:20;padding-left:5px;padding-top:1px;padding-right:9px">
	   
	   <cfif url.mode neq "direct">
	   
		   <cfif WarehouseItemNo neq "">
		   	   		 
				 <cfquery name="Asset" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Item I, Ref_Category R
					WHERE  I.Category = R.Category
					AND    I.ItemClass = 'Asset'
					AND    I.ItemNo = '#WarehouseItemNo#' 
				</cfquery>
													
				<cfif Asset.recordcount eq "1" 
				    and ActionStatus gte "1" 
					and ActionStatus lt "9" 
					and URL.ID1 eq "Equipment">
					
					  <cf_img icon="open" onclick="equipmententry('#ReceiptId#')">				
					 					  			  
				<cfelse>
				
					<cfif url.mode eq "Entry">
					
						  <cf_img icon="delete" 
							     onclick="ProcRcptLineDelete('#ReceiptId#','#Receipts.RequisitionNo#','#URL.Mode#','delete','#url.box#')">
																		
					<cfelse>
					
					     <cfif ActionStatus eq "0">
						 
						      <cf_img icon="edit" 
							     onclick="ProcRcptLineEdit('#ReceiptId#','#Receipts.RequisitionNo#','#URL.Mode#','edit','#url.box#','')">
						
						 </cfif>
						 
					</cfif>	 
				  
				</cfif>  
				
			<cfelse>
			
			    <cfif url.mode neq "Prior">
				
					<cfif url.mode eq "Entry">
					
						 <cf_img icon="delete" 
						    onclick="ProcRcptLineDelete('#ReceiptId#','#Receipts.RequisitionNo#','#URL.Mode#','delete','#url.box#')">
													
					<cfelse>
					
					     <cf_img icon="edit" 
						    onclick="ProcRcptLineEdit('#ReceiptId#','#Receipts.RequisitionNo#','#URL.Mode#','edit','#url.box#','')">											
					 							 
					</cfif>	 
				
				</cfif>
				 		  		 
		   </cfif>
	   
	   </cfif>
	 			  	 
	   </td>
	   
	   <td height="14" style="padding-right:6px">
	   
	   <cfswitch expression="#ActionStatus#">
		   <cfcase value="0"><font color="gray"><cf_tl id="PE"></cfcase>
		   <cfcase value="1"><font color="00BB00"><cf_tl id="CL"></cfcase>
		   <cfcase value="2"><font color="blue"><cf_tl id="MA"></cfcase>
		   <cfcase value="9"><font color="FF0000"><cf_tl id="CA"></font></cfcase>
	   </cfswitch>
	   
	   </td>
	   
	   <!--- product or warehouse --->
	   
	   <td style="#stl#">
		 <cfif ReceiptItemNo neq "">
				 <font color="008000">#ReceiptItemNo#:</font>
		 </cfif>#ReceiptItem#
		 <cfif transactionlot gte "1">:
			 #transactionlot#
		 </cfif>
		 <cfif CaseNo neq "">
				 (#CaseNo#)
		 </cfif>
		 </td>
	   <td style="#stl# padding-right:4px">  
   	   
	   <cfif url.mode neq "direct">
		   <cfif WarehouseItemNo neq "">	
		   <a title="View Item" href="javascript:item('#WarehouseItemNo#','#POInfo.mission#','#url.systemfunctionid#')">#WarehouseItemNo#</a>
		   <cfelse>
		   #ReceiptItemNo#
		   </cfif>
	   </cfif>
	   	   
	   </td>	  
	   
	   <cfif URL.Mode eq "Entry" or url.mode eq "Receipt">	  
	   		   
		   <cfif Warehouse eq ""> 
		   
		   	  <td style="#stl#">N/A</td>
		   
		   <cfelse>
		   
		      <cfquery name="Whs" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">	   
			   SELECT   *
			   FROM     Warehouse
			   WHERE    Warehouse = '#warehouse#'             
	          </cfquery>		   
		      			   
			    <cfif WarehouseTaskId eq "">
					 
					 <td>#Whs.WarehouseName#</td>
					 					 
				<cfelse>				
			  
				   <cfquery name="Ref" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">	 
							  SELECT  R.Reference
							  FROM    RequestTask T INNER JOIN Request R ON R.RequestId = T.RequestId
		                      WHERE   T.TaskId = '#WarehouseTaskId#'
					</cfquery>	  
					
					<td style="#stl#" style="cursor:pointer" onclick="window.open('#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id=print&ID1=#Ref.Reference#&ID0=#Param.RequisitionTemplate#','_blank', 'left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no')">					
					 #Whs.WarehouseName# (<font color="6688aa">#Ref.Reference#</font>)					
					</td>
			   
			   </cfif>
			   			   
		    </cfif>		   
		  
	   <cfelse>
	     
		   <td><a title="View R&I" href="javascript:receipt('#receiptNo#','receipt')"><font style="#stl#">#ReceiptNo#</font></a></td>
	     
	   </cfif>
	   
	   <td style="#stl#">	
	     

		   <cfif url.mode neq "receipt">
		   
			   <cfinvoke component = "Service.Access"  
						   method           = "RoleAccess" 
						   mission          = "#POInfo.Mission#" 
						   Function         = "Procurement"				   
						   returnvariable   = "access">
					 
			   <cfif Access eq "GRANTED">
			   	   			   
			   	<a title="View Purchase" href="javascript:ProcPOEdit('#POInfo.PurchaseNo#','view')">				    
					 <cf_getPurchaseNo purchaseNo="#POInfo.PurchaseNo#" mode="only">					
				</a>
			   
			   <cfelse>
			   
				   <cf_getPurchaseNo purchaseNo="#POInfo.PurchaseNo#" mode="only">
			   				   
			   </cfif>
					   
		</cfif>
		   
	   </td>
	   
	   <td style="#stl#;padding-right:4px">#DateFormat(DeliveryDate, CLIENT.DateFormatShow)#</td>    
	  	      
	   <!--- ------------------------------- ---> 
	   <!--- portal access we show different --->	  
	   <!--- ------------------------------- --->   
	   <td align="right" style="background-color:##e6e6e6B3;#stl#;padding-right:3px">#NumberFormat(ReceiptOrder,",._")#</td>
	   <td align="right" style="background-color:##ffffafB3;#stl#;padding-right:3px"><cfif ReceiptVolume neq "">#NumberFormat(ReceiptVolume,",.__")#</cfif> </td>
	   	   
	   <cfif url.mode neq "direct">	   
		   
		    <cfif WarehouseItemNo neq "">	    			 
				  
				  <td align="right" style="background-color:##DAF9FCB3;#stl#;wmin-width:80px;width:80px;padding-left:4px;padding-right:3px">#NumberFormat(ReceiptWarehouse,",._")#</td>				  
				  <td align="right" style="background-color:##DAF9FCB3;#stl#;padding-left:3px;padding-right:3px">#left(UoMDescription,10)# <!--- <cfif uom.ItemBarcode neq "">(#UoM.ItemBarCode#)</cfif> ---></td>
				  
		   <cfelse>		  
		   
		   	    <td align="right" style="#stl#;padding-right:3px">#NumberFormat(ReceiptQuantity,",._")#</td>		   
			    <td align="right" style="#stl#;padding-left:3px;padding-right:3px">#left(ReceiptUoM,10)#</td>
		   
		   </cfif>
		   		   
		   <td align="right" colspan="2" style="#stl#;padding-right:4px"><font size="1">#Currency#</font>&nbsp;#NumberFormat(ReceiptAmountCost,",.__")#</td>
		   <td align="right" style="background-color:##DDFBE2B3;padding-right:2px;border-left:1px solid silver;padding-left:8px #stl#">#NumberFormat(ReceiptAmountBaseTax,",.__")#</td>
		   <td align="right" style="background-color:##DDFBE2B3;padding-right:2px;border-left:1px solid silver;padding-left:8px #stl#">#NumberFormat(ReceiptAmountBaseCost,",.__")#</td>
		   		   
	   <cfelse>
	   
		  <td colspan="2">
			 
			 <cfif PersonNo neq "">		 
			 
			    <cfquery name="Person" 
					  datasource="AppsEmployee" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">	   
					   SELECT   *
					   FROM     Person
					   WHERE    PersonNo = '#PersonNo#'				              
			          </cfquery>
					  
					  <cfif Person.recordcount eq "0">
					  --
					  <cfelse>
					  #Person.FirstName# #Person.LastName#
					  </cfif>
					  
			 <cfelse>
			 --					 		 
			 </cfif>
			 
		  </td>
	    	   
	      <td align="right" style="#stl#">#NumberFormat(ReceiptQuantity,",._")#</td>
		   
		  <cfif WarehouseItemNo neq "">		   		    				  
		  <td align="right" style="#stl#">#UoMDescription#</td>				  
		  <cfelse>		  		   
		  <td align="right" style="#stl#">#ReceiptUoM#</td>		   
		  </cfif>	      
	   
	   </cfif>
	   
	   <cfloop query="Cost">	  
	  
		 <td  align="right" style="background-color:##FFCAFFB3;min-width:80px;border-left:1px solid silver;padding-right:4px">
		 
		 		<cfquery name="costdetail" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">	   
				   SELECT   *
				   FROM     PurchaseLineReceiptCost
				   WHERE    receiptId = '#receipts.receiptid#'
				   AND      CostId    = '#costid#'             
	          </cfquery>
									  
			  #numberformat(costdetail.AmountCost,',.__')#
		 
		 </td>						
	   </cfloop>	
	   
	   <td align="center" style="#stl#;padding-left:8px;padding-right:4px;padding-top:1px;width:10">
	   
		   <cfif (ActionStatus eq "0" and url.mode eq "Edit") or (ReceiptAccess eq "ALL" and ActionStatus eq "1")>
		   
		     <!--- do not allow to remove if receipt has been processed already --->
		  						 	 
			 <cfif posted eq "0">		
			 
				 <cf_img icon="delete" 
				    onclick="ptoken.navigate('#SESSION.root#/procurement/application/receipt/receiptentry/ReceiptPurge.cfm?box=#url.box#&reqno=#URL.reqno#&Mode=#URL.Mode#&rctid=#receiptid#','#url.box#')"> 			 
			  			   
			 </cfif> 
			   
		   </cfif>	
		   
	   </td>	
	   	 
	 </tr>
	 	 	 
	 <!--- not much value to show them here.--->
	 	 	
	 <cfif url.mode neq "entry" and url.mode neq "receipt">
	 
	 	 <cf_getRequisitionTopic RequisitionNo="#Receipts.RequisitionNo#" show="No">
	 	 
	 	 <cfif requisition gte "1"> 
	 
		 <tr style="height:0px">
		    <td style="height:0px"></td>
			<td style="height:0px" colspan="12">
		      <cf_getRequisitionTopic RequisitionNo="#Receipts.RequisitionNo#" TopicsPerRow="5">
		    </td>
	     </tr>
	 
		 </cfif>
	 
	 </cfif>
	 	
		 
	 <cfif WarehouseItemNo neq "" and ReceiptId neq "00000000-0000-0000-0000-000000000000">
	 
	 	<cfquery name="Asset" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	  
				SELECT    *
				FROM      AssetItem
				WHERE     ReceiptId = '#ReceiptId#'	 
		</cfquery>
	
	 <!--- ------------------------------------- --->	
	 <!--- show the asset details of the receipt --->
	 <!--- ------------------------------------- --->	
	 
	 <cfif Asset.recordcount gte "1">
	 
		 <tr>	
		 
			 <td></td>	
			 <td colspan="13">		  		
					
				 <table width="94%" style="border:1px dotted silver" class="navigation_table" align="right" cellspacing="0" cellpadding="0">
				 
				     <tr class="line"><td colspan="10" class="labelit" style="padding-left:10px;font-weight:200"><cf_tl id="Assets recorded"></td></tr>
					 <tr class="labelmedium">
					  <td width="20"></td>
						 <td width="20"></td>
						 <td width="100"><cf_tl id="Make"></td>
						 <td width="120"><cf_tl id="MakeNo"></td>
						 <td width="100"><cf_tl id="Model"></td>
						 <td width="150"><cf_tl id="Officer"></td>
						 <td width="100"><cf_tl id="Received"></td>
						 <td width="100"><cf_tl id="Inspection"></td>
						 <td width="100" align="right"><cf_tl id="Book value"></td>
						 <td width="6"></td>
					 </tr>					 
					 
				 	<cfloop query="Asset">
					
				 	<tr bgcolor="ffffcf" class="labelit navigation_row linedotted">
					     <td style="padding-left:7px" class="labelit linedotted">#currentrow#.</td>
						 <td align="center"><cf_img icon="open" navigation="Yes" onclick="AssetDialog('#AssetId#')"></td>
						 <td>#Make#</td>
						 <td>#MakeNo#</td>
						 <td>#Model#</td>
						 <td>#OfficerFirstName# #OfficerLastName#</td>
						 <td>#DateFormat(receiptDate,CLIENT.DateFormatShow)#</td>
						 <td>#DateFormat(InspectionDate,CLIENT.DateFormatShow)#</td>
						 <td style="padding-left:4px" align="right">#numberformat(DepreciationBase,"__,__.__")#</td>
						 <td></td>
					 </tr>					
					 </cfloop>
				 </table>		 
			 
			 </td>
		 
		 </tr>
		 
	 <cfelse>	 
	 
		 <cfquery name="Transaction" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	  
				SELECT    *
				FROM      ItemTransaction T, ItemUoM U
				WHERE     T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM
				AND       ReceiptId = '#ReceiptId#'	 
				AND       TransactionType = '1' <!--- to hide the moved transactions --->
		</cfquery>
		
		<cfif transaction.recordcount gte "1">
	 
	 	<tr>	
		 
			 <td></td>
			 
			 <td colspan="15" style="padding-bottom:7px">		  		
					
				 <table width="97%" class="navigation_table" align="right">
				 				   				 
				     <tr class="labelit line" style="height:15px">
					     <td width="20"></td>						 
						 <td width="30%"><cf_tl id="Unit"></td>
						 <td width="100"><cf_tl id="Location"></td>
						 <td width="25%"><cf_tl id="UoM"></td>
						 <td width="100" align="right"><cf_tl id="Ordered"></td>
						 <td width="100" align="right"><cf_tl id="Paid"></td>
						 <td width="80"  align="right"><cf_tl id="Quantity"></td>						 	
						 <td width="100" align="right"><cf_tl id="Cost Value"></td>												 
						 <td width="150" align="right"><cf_tl id="Stock value"></td>
						 <td width="6"></td>
					 </tr>					 
					 
				 	<cfloop query="Transaction">
					
					 	<tr bgcolor="ffffcf" class="labelmedium navigation_row line">
						   <td style="width:30px;height:25px;padding-left:7px">#currentrow#.</td>						 
						   <td style="width:30%">#OrgUnitName#</td>
						   <td style="width:100px">#Location#</td>
						   <td style="width:15%">#UOMDescription#</td>
						    <td style="width:100px" align="right">
						   <cfif ReceiptCostPrice gte 0.1>
						   #numberformat(ReceiptCostPrice,",.____")#
						   <cfelse>
						   #numberformat(ReceiptCostPrice,",._____")#
						   </cfif>						   
						   </td>
						   <td style="width:100px" align="right">
						   <cfif ReceiptPrice gte 0.1>
						   #numberformat(ReceiptPrice,",.____")#
						   <cfelse>
						   #numberformat(ReceiptPrice,",._____")#
						   </cfif>						   
						   </td>
						   <td style="width:100px" align="right">#TransactionQuantity# <cfif transactionQuantityBase neq TransactionQuantity><font size="1">(#TransactionQuantityBase#)</cfif> </td>
						   <td style="width:100px" align="right">
						   <cfif TransactionCostPrice gte 0.1>
						   #numberformat(TransactionCostPrice,",.____")#
						   <cfelse>
						   #numberformat(TransactionCostPrice,",._____")#
						   </cfif>						   
						   </td>
						   <td style="width:100px;padding-right:3px" align="right">#numberformat(TransactionValue,",.__")#</td>						
						   <td></td>
						 </tr>		
									
						 						  
						 <cfif receipts.actionstatus gte "1" and receipts.actionstatus lte "2" and url.presentation eq "1">							 
						 					
							  <cfquery name="Posting" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">	  
								SELECT     TL.Journal, TL.JournalSerialNo, TL.GLAccount, R.AccountLabel, R.Description, TL.ExchangeRate, TL.Currency, TL.AmountDebit, TL.AmountCredit, 
		                                   TL.AmountBaseDebit, TL.AmountBaseCredit
								FROM       Accounting.dbo.TransactionHeader AS TH INNER JOIN
								           Accounting.dbo.TransactionLine AS TL ON TH.Journal = TL.Journal AND TH.JournalSerialNo = TL.JournalSerialNo INNER JOIN
								           Accounting.dbo.Ref_Account AS R ON TL.GLAccount = R.GLAccount
								WHERE      TH.ReferenceId = '#TransactionId#'
							</cfquery>
																									
							<tr><td></td><td colspan="8">
							
							<table width="100%">
							
							<cfloop query="Posting">
							
							<tr class="labelit line" style="height:15px">
							
								<td style="min-width:60px">#Journal#</td>
								<td style="min-width:60px">#JournalSerialNo#</td>
								<td style="min-width:80px"><cfif AccountLabel neq "">#GLAccount#<cfelse>#AccountLabel#</cfif></td>
								<td style="width:100%">#Description#</td>
								<td style="min-width:60px">#Currency#</td>
								<td style="min-width:100px;padding-right:3px" align="right">#numberformat(AmountDebit,",.__")#</td>
								<td style="min-width:100px;padding-right:3px" align="right">#numberformat(AmountCredit,",.__")#</td>
								<td style="min-width:100px;padding-right:3px" align="right" bgcolor="DDFBE2">#numberformat(AmountBaseDebit,",.__")#</td>
								<td style="min-width:100px;padding-right:3px" align="right" bgcolor="DDFBE2">#numberformat(AmountBaseCredit,",.__")#</td>
							
							</tr>
													
							</cfloop>
							
							</table>
							</td>
							</tr>
						
						</cfif>
																								 
					 			
					 </cfloop>
				 </table>		 
			 
			 </td>
		 
		 </tr>	 
		 
		 </cfif>
	 
	 </cfif>
	 
	 </cfif>	 
	  
	 <cfif url.mode neq "direct">
	 	 			
		 <cfif POInfo.ReceiptEntryForm eq "Fuel">	
		 		 
		 	<tr>
			<td colspan="2" valign="top"></td>
			<td colspan="13" align="right" style="padding:3px;padding-right:35px;">	
		
				<cfset url.detailmode = "view">
				<cfset url.rctid      = receiptid>
				<cfinclude template="ReceiptEntryContentLinesFuel.cfm">
			
			</td></tr> 
					 
		 </cfif>	 
	 
	 </cfif>	
	 
	 	 
 </cfoutput> 
  
 <cfif POInfo.ReceiptEntry eq "1">
     
 <!---	 
 <cfif POInfo.ReceiptEntryForm eq "Standard" or POInfo.ReceiptEntryForm eq "Fuel">
 --->
		  
	 <cfoutput> 	
	 	
		 <cfif URL.Mode eq "Entry">		 
		 
		     <tr><td colspan="13" align="left">
			 
			  <cf_verifyOperational module="WorkOrder" Warning="No">				
				
		  	  <cfif Operational eq "0">			  
			  
			        <cfset insert = "1">
										
				    <table  cellspacing="0" cellpadding="0">			   
				     <tr>
					 				 
						  <td style="padding-top:3px;padding-left: <cfif url.taskid eq "">5<cfelse>100</cfif>px;padding-top:3px">
					         <cf_img icon="add" onClick="ProcRcptLineEdit('#URL.rctid#','#URL.reqno#','#url.mode#','new','#url.box#','',document.getElementById('receiptdate').value)">		
						  </td>				  				 
						  <td class="labelmedium" style="padding-top:3px;padding-left:4px">
							 <a href="javascript:ProcRcptLineEdit('#URL.rctid#','#URL.reqno#','#url.mode#','new','#url.box#','',document.getElementById('receiptdate').value)">					
							 <font color="6688aa"><cfif url.taskid neq ""> <cf_tl id="Add a taskorder receipt"> <cfelse> <cf_tl id="Add a receipt"> </cfif> </font></a>						
						  </td>				  
					  
					  </tr>				  
					</table>	
			
			  <cfelse>
			 								
				<!--- we check if this request is from a workorder which has one or more BOM items earmarked --->
				
				<cfquery name="WorkOrderBOM" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">	
				     
				  SELECT RequisitionNo,		
				  		  
				         <!--- has BOM earmarked or consumed for this ordered item which is outsourced
						  since it was produced produced with materials materials provided --->						 
				         (
						  SELECT     COUNT(*) AS Expr1
                          FROM       Materials.dbo.ItemTransaction AS T INNER JOIN
                                     Workorder.dbo.WorkOrderLineResource AS R ON T.RequirementId = R.ResourceId
                          WHERE      T.WorkOrderId   = D.WorkorderId 
						  AND        T.WorkOrderLine = D.WorkOrderLine 
						  AND        T.ActionStatus  = '1' 						 
						  AND        T.TransactionType IN ('8','2')
						  ) AS BOMEarmarked
				      
				  FROM   RequisitionLine AS D
				  WHERE  RequisitionNo = '#URL.reqno#' 
				  
				  <!--- sales workorder --->
				  AND    RequirementId IN
                             (SELECT    WorkOrderItemId
                              FROM      Workorder.dbo.WorkOrderLineItem AS I
                              WHERE     D.RequirementId = WorkOrderItemId)
							  
				  <!--- has bom defined --->			  
				  AND  	 EXISTS
                             (SELECT    'X' AS Expr1
                              FROM      Workorder.dbo.WorkOrderLineResource AS T
                              WHERE     WorkOrderId = D.WorkorderId 
							  AND       WorkOrderLine = D.WorkOrderLine
							  AND       ResourceItemNo IN (SELECT ItemNo 
							                               FROM   Materials.dbo.Item 
														   WHERE  ItemNo = T.ResourceItemNo 
														   AND    ItemClass = 'Supply')) 	
				</cfquery>		
				
				<cfif workOrderBOM.recordcount eq "0">
					
					 <cfset insert = "1">
					 
				<cfelseif workorderBOM.BOMEarmarked gte "1">	 
				
					 <cfset insert = "1">
					 
				<cfelse> 
				
					 <cfset insert = "0">
								
				</cfif>				
								
				<cfif insert eq "1" or 1 eq 1>
				
				     <!--- hanno no need to show the entry hare as it shows as part of the line 
					 ReceiptEntryContentLines.cfm line 245 --->
					 
				     <cfif url.taskid eq "">
					 
					 <table>			   
				     <tr style="height:10px">
					 			 
						  <td style="padding-top:3px;padding-left: <cfif url.taskid eq "">16<cfelse>100</cfif>px;">
					         <cf_img icon="add" onClick="ProcRcptLineEdit('#URL.rctid#','#URL.reqno#','#url.mode#','new','#url.box#','',document.getElementById('receiptdate').value)">		
						  </td>				  				 
						  <td class="labelmedium" style="padding-left:4px">
							 <a href="javascript:ProcRcptLineEdit('#URL.rctid#','#URL.reqno#','#url.mode#','new','#url.box#','',document.getElementById('receiptdate').value)">					
							 <cfif url.taskid neq ""> <cf_tl id="Add a taskorder receipt"> <cfelse> <cf_tl id="Add a receipt"> </cfif></a>						
						  </td>				  
					  
					  </tr>				  
					</table>	
					
					</cfif>
					
				<cfelse>
				
					 <table  cellspacing="0" cellpadding="0" width="100%">			   
				     <tr><td class="labelmedium" align="center">					 				
						<font color="FF0000"><cf_tl id="No BOM consumption recorded for this item">	
						</td>
					 </tr>
					 </table>			
				
				</cfif>
				
				</cfif>
				
			 </td></tr>		 
		 </cfif>
		 
	 </cfoutput>
 
 </cfif>
   
</table>
 
</td></tr>

<tr><td style="height:5px"></td></tr>

</table>

<cfset AjaxOnLoad("doHighlight")>	

<cfif url.mode eq "Receipt">
	<script>
	    if (document.getElementById('settotal')) {
			receiptcost(); 	}	
	</script>	
</cfif>	
