
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<cfparam name="url.filter" default="">

<!--- End Prosis template framework --->

<cfquery name="Invoiced" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   InvoicePurchase 
		WHERE  PurchaseNo ='#URL.Id1#'		
</cfquery>	

<cfquery name="Lines" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    Q.*, 
	          R.RequestDescription AS RequestDescription, 
			  		  	  
			  (SELECT count(*)
			   FROM   RequisitionLineTopic T, Ref_Topic S
			   WHERE  T.Topic = S.Code				 
			   AND    T.RequisitionNo = R.RequisitionNo
			   AND    S.Operational   = 1) as Topics,	
			  
			  (
			  SELECT   count(*)
			  FROM     PurchaseLineReceipt 
		   	  WHERE    RequisitionNo = R.RequisitionNo 
		   	  AND      ActionStatus != '9'	
			  ) as Receipts,			 
			  
			  Job.JobNo, 
			  Job.CaseNo AS CaseNo
	FROM      PurchaseLine Q INNER JOIN
              RequisitionLine R ON Q.RequisitionNo = R.RequisitionNo LEFT OUTER JOIN
              Job ON R.JobNo = Job.JobNo
	WHERE     Q.PurchaseNo = '#URL.ID1#' 
	-- AND       Q.ActionStatus != '9'  
	<cfif url.filter neq "">
	AND       (
	          R.RequisitionNo LIKE '%#url.filter#%' OR
	          R.RequestDescription LIKE '%#url.filter#%' OR
			  Q.OrderItem LIKE '%#url.filter#%' OR
			  Q.OrderItemNo        LIKE '%#url.filter#%'				  
			  )
	</cfif>		
	ORDER BY Q.ListingOrder, Q.OrderItemNo, R.Created
</cfquery>  

<!--- showing the cancelled lines --->

<cfoutput>

<table width="100%" align="center" class="navigation_table">
  
    <TR bgcolor="white" class="labelmedium fixrow2">
	   <td height="19" width="24" style="width:20px;top:32px"></td>
	   <cfif URL.Mode eq "Edit" and PO.ActionStatus eq "0">
	   <td colspan="2" style="width:20px;top:32px"></td>
	   <cfelse>
	   <td colspan="2" style="width:20px;top:32px"></td>
	   </cfif>
	   <td style="width:20px;top:32px"></td>
	   <td style="top:32px" width="40%" style="top:40px"><cf_tl id="Description"></td>
	   <td style="top:32px"><cf_tl id="Job"></td>
	   <td style="top:32px" align="right"><cf_tl id="Qty"></td>
       <td style="top:32px" align="center"><cf_tl id="UoM"></td>
	   <td style="top:32px" align="center"><cf_tl id="Volume"></td>
	   <td style="top:32px" align="center"><font size="1">#Lines.Currency#</font><cf_tl id="UoM"></td>
	   <td style="top:32px" align="center"><font size="1">#Lines.Currency#</font><cf_tl id="Unit"></td>
       
	   <td style="top:32px" align="right"><font size="1">#Lines.Currency#</font><cf_tl id="Ext Price"></td>
	   <td style="top:32px" align="right"><cf_tl id="Tax"></td>
	   <td style="top:32px" align="right"><cf_tl id="Payable"></td>
	   <cfif APPLICATION.BaseCurrency neq lines.currency>
	   <td style="top:32px" align="right" style="padding-right:4px"><cfoutput>#APPLICATION.BaseCurrency#</cfoutput></td>	 
	   <cfelse>
	   <td style="top:32px"></td> 	  
	   </cfif>	   
     </TR> 
	 
	 <cfset delete = "0">
	 
	 <cfif Lines.recordcount eq "0">
	 
		 <tr><td height="1" colspan="13" class="line"></td></tr>  
		 <tr><td colspan="13" align="center" class="labelmedium" style="padding-top:4px"><cf_tl id="No lines found"></td></tr>
		 
	 <cfelse>	
						
		<cfloop query="Lines">			
			
			<cfif OrderAmountBase lte "0">
							
			<tr bgcolor="gray" id="#requisitionno#_1" style="height:20px;<cfif actionstatus eq '9'>background-color:##FEC5B880</cfif>" class="labelmedium line navigation_row">
			
			<cfelse>
									
			<cfif deliverystatus eq "3">
				<cfset cls = "FFFFaF">							
			<cfelseif deliveryStatus eq "2">
				<cfset cls = "FFFFAF">				
			<cfelse>
				<cfset cls = "FFFFFF">		
			</cfif>
			
			<tr bgcolor="#cls#" id="#requisitionno#_1" style="height:20px;border-top:1px solid silver;<cfif actionstatus eq '9'>background-color:##FEC5B880</cfif>" class="labelmedium line navigation_row">
			
			</cfif>			
						
			<td style="height:23px" width="10" align="center">#CurrentRow#.</td>
			
						
			<cfif (URL.Mode eq "Edit" AND PO.ActionStatus eq "0") 
			      or
				  (Parameter.EditPurchaseAfterIssue eq "1" AND PO.ActionStatus eq "3" and DeliveryStatus eq "0" and URL.Mode eq "Edit")>
				  
				  <td align="center" style="width:20px;padding-top:2px">					  
				  	<cf_img icon="open" onclick="ProcReqEdit('#RequisitionNo#','dialog')">	  							  
			  		</td>	
				  													
			        <td align="center" style="width:20px;padding-top:1px">					
					<cf_img icon="edit" onclick="ProcLineEdit('#requisitionno#','edit');">										 
					</td>
				
			<cfelse>
			
			<td align="center" style="width:20px;padding-top:2px">					  
				  	<cf_img icon="open" onclick="ProcReqEdit('#RequisitionNo#','dialog')">	  							  
			  </td>	
			
			  <td align="center" style="width:20px;padding-top:2px">					  
				  	<cf_img icon="edit" onclick="ProcLineEdit('#requisitionno#','view');">	  							  
			  </td>				  
				
			</cfif> 
			
			<td align="left" style="width:10px;padding-top:2px">
														
			<cfif Receipts eq "0">
			
				<cfif (URL.Mode eq "Edit" 
				    and PO.ActionStatus lte "1" 
					and Invoiced.recordcount eq "0") 
				    or getAdministrator("*") eq "1">
					
					<cf_img icon="delete" onclick="deleteline('#RequisitionNo#','#lines.recordcount#')">
								 	 														
				  <cfset delete = "0">				
				  
				</cfif>
				
			</cfif>
			
		    </td>  
			
			<td>
			
				<cfif OrderItemNo neq "">
				#OrderItemNo#:
				</cfif>
				<cfif OrderItem eq "">				
					<cfset des = RequestDescription>				
				<cfelse>				
					<cfset des = OrderItem>				
				</cfif>
				
				<cfif len(des) gte "60">
					<a href="javascript:ProcReqEdit('#RequisitionNo#','dialog')" title="#des#">#left(des,60)#..</a>
				<cfelse>
				    #des#
				</cfif>
			
			</td>
			
			<td><a href="javascript:job('#JobNo#')"><U><font color="gray"><cfif caseno neq "">#CaseNo#<cfelse>#JobNo#</cfif></font></a>
			<cfif lineReference neq ""><cfif CaseNo neq "">/</cfif>#LineReference#</cfif>
			</td>
			
   		    <td style="border-left:1px solid gray;padding-right:4px;border-right:1px solid silver" align="right">#OrderQuantity#</td>
		    <td  style="border-left:1px solid gray;padding-right:4px;border-right:1px solid silver;padding-left:4px">#OrderUoM#</td>
			<td  style="border-left:1px solid gray;padding-right:4px;border-right:1px solid silver;padding-left:5px">
			<cfif OrderUoMVolume neq "">#OrderUoMVolume*OrderQuantity# <!---(#OrderUoMVolume#)---></cfif></td>
			 <td  style="border-left:1px solid gray;padding-right:4px;border-right:1px solid silver" align="right">
			<cfif Lines.OrderQuantity lte 0>
				<cfset Lines.OrderQuantity = 1>
			</cfif>
			<cfset prc = OrderAmountCost/OrderQuantity>
			<cfif prc lte "0.01">
			#NumberFormat(prc,",.______")#
			<cfelse>
			#NumberFormat(prc,",.__")#			
			</cfif>			 
			</td>
			
			<td  style="border-left:1px solid gray;padding-right:4px;border-right:1px solid silver" align="right">
			
			<cfif Orderwarehouse gt "0">
				<cfset prc = OrderAmountCost/OrderWarehouse>
				<cfif prc lte "0.01">
				#NumberFormat(prc,",.______")#
				<cfelse>
				#NumberFormat(prc,",.__")#			
				</cfif>		
			</cfif>
			
			</td>
	       
			<td  style="border-left:1px solid gray;padding-right:4px;border-right:1px solid silver" align="right">#NumberFormat(OrderAmountCost,",.__")#</td>
			<td  style="border-left:1px solid gray;padding-right:4px;border-right:1px solid silver" align="right">#NumberFormat(OrderAmountTax,",.__")#</td>
			<td  style="background-color:ffffaf;border-left:1px solid gray;padding-right:4px;border-right:1px solid silver" style="padding-right:4px" align="right">#NumberFormat(OrderAmount,",.__")#</td>
			<cfif APPLICATION.BaseCurrency neq lines.currency>
				<td  style="background-color:f1f1f1;border-left:1px solid gray;padding-right:4px;border-right:1px solid silver;padding-left:8px" align="right">#NumberFormat(OrderAmountBase,",__.__")#</td>
			<cfelse>
				<td  style="border-left:1px solid gray;padding-right:4px;border-right:1px solid silver;padding-left:8px"></td>
			</cfif>			
           	</tr>		
			
			<cfif topics gte "1" and Parameter.PurchaseTopic eq "1">
			
			<tr>
				<td colspan="2"></td><td colspan="12">								
					<cf_getRequisitionTopic RequisitionNo="#RequisitionNo#" TopicsPerRow="3">
				</td>
			</tr>	
			
			</cfif>
			
			<!--- Make a provision that you can not delete a requisition if there is a receipt 
			also tune for warehouse receipts which can be against a different UoM
			--->			
			
			<cfif receipts gt "0">			
			
				<cfquery name="ReceiptList" 
				 datasource="AppsPurchase" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				  SELECT   *
				  FROM     PurchaseLineReceipt 
			   	  WHERE    RequisitionNo = '#RequisitionNo#' 
			   	  AND      ActionStatus != '9'	
				  ORDER BY ReceiptNo
			  	</cfquery>
				
				<cfinclude template="POViewLines_Receipt.cfm">	
			
			</cfif>								
									
		</cfloop>
				
			<cfif lines.recordcount gte "1">
		
			<tr><td height="4"></td></tr>		
			
				<cfquery name="getReceipt" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    Currency, 
						          SUM(ReceiptAmountCost) AS Receipt, 
								  SUM(ReceiptAmountTax) AS Tax, 
								  SUM(ReceiptAmount) AS Payable
						FROM      PurchaseLineReceipt
						WHERE     ActionStatus <> '9' 
						AND       RequisitionNo IN
			                          (SELECT   RequisitionNo
			                            FROM    PurchaseLine
			                            WHERE   PurchaseNo = '#url.id1#')
						GROUP BY Currency
				</cfquery>	
				
				<cfif getReceipt.recordcount gte "1">
					<tr><td valign="top" style="padding-top:5px" colspan="6" align="right" class="labelmedium"><cf_tl id="Receipt Summary"></td><td colspan="7" align="right" style="padding-right:10px">
				</cfif>
				
				<cfif getReceipt.currency neq "">
				
					<table width="300" style="border:0px solid silver">
					<tr class="labelit line">
						<td style="font-size:12px" align="right"></td>
						<td align="right"><cf_tl id="Value"></td>
						<td align="right"><cf_tl id="Tax"></td>
						<td align="right" style="padding-right:5px"><cf_tl id="Total"></td>
					</tr>
					<cfloop query="getReceipt">
					<tr class="labelmedium">
					    <td style="width:50px;font-size:13px" align="right"><font color="408080">#Currency#</td>
					    <td align="right"><font color="408080">#numberformat(Receipt,',.__')#</td>
						<td align="right"><font color="408080">#numberformat(Tax,',.__')#</td>
						<td align="right" style="padding-right:5px"><font color="408080">#numberformat(Payable,',.__')#</td>
					</tr>
					</cfloop>
					</table>
				
				</cfif>
				
			</td>
			</tr>
			
			</cfif>		
				 
	 </cfif>				
		
</table>

</cfoutput>

<cfset AjaxOnLoad("doHighlight")>		