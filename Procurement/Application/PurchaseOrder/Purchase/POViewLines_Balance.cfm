
<cfparam name="ApprovalAccess" default="NONE">

<!--- we first check if this PO is for a workorder --->

<cfquery name="getRequestType" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
 	 SELECT * 
	 FROM   RequisitionLine 
	 WHERE  RequisitionNo IN (SELECT RequisitionNo 
	                          FROM   PurchaseLine 
							  WHERE  PurchaseNo = '#URL.ID1#') 
	 AND    WorkOrderId is not NULL
</cfquery>	 

<cfparam name="url.filter" default="">

<cfquery name="Lines" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    Q.*, 
	          R.RequestDescription AS RequestDescription, 
			  R.WorkOrderId,
			  
			    (SELECT count(*)
				  FROM   RequisitionLineTopic T, Ref_Topic S
				  WHERE  T.Topic = S.Code
				  AND    S.Operational   = 1
				  AND    T.RequisitionNo = R.RequisitionNo) as Topics,	
			  
			  (
			    SELECT   count(*)
			    FROM     PurchaseLineReceipt 
		   	    WHERE    RequisitionNo = R.RequisitionNo 
		   	    AND      ActionStatus != '9'	
			  ) as Receipts,		
			  
			  ( 
			     SELECT  SUM(AmountMatched)    
				 FROM    InvoicePurchase IP, Invoice I
				 WHERE   I.InvoiceId = IP.InvoiceId
				 AND     I.ActionStatus != '9'
				 AND    (
				  		   NOT EXISTS
							(SELECT 'X'
								FROM   Organization.dbo.OrganizationObject
								WHERE  EntityCode    = 'ProcInvoice'
								AND    ObjectKeyValue4 = I.InvoiceId 
								) 
									 
							AND HistoricInvoice = 0
						)
				  AND     IP.RequisitionNo = R.RequisitionNo  	
			   ) onHold,
			   
			     (
			  	SELECT  sum(AmountMatched)    
				FROM    InvoicePurchase IP, Invoice I
			    WHERE   I.InvoiceId = IP.InvoiceId
			    AND     I.ActionStatus = '0'
			    AND    ( EXISTS
						(SELECT 'X'
							FROM   Organization.dbo.OrganizationObject
							WHERE  EntityCode    = 'ProcInvoice'
							AND ObjectKeyValue4 = I.InvoiceId 
							) 
						 OR 
						 HistoricInvoice = 1)
								 
			    AND     IP.RequisitionNo = R.RequisitionNo   	
			  ) as InProcess,			
			  
			   (
			  	SELECT  sum(AmountMatched)    
				FROM    InvoicePurchase IP, Invoice I
			    WHERE   I.InvoiceId = IP.InvoiceId
			    AND     I.ActionStatus IN ('1','2')
			    AND    ( EXISTS
						(SELECT 'X'
							FROM   Organization.dbo.OrganizationObject
							WHERE  EntityCode    = 'ProcInvoice'
							AND ObjectKeyValue4 = I.InvoiceId 
							) 
						 OR 
						 HistoricInvoice = 1)
								 
			    AND     IP.RequisitionNo = R.RequisitionNo   	
			  ) as Invoiced,				  			  
			  
			  Job.JobNo, 		  
			  Job.CaseNo AS CaseNo,
			  R.Period
			  
	FROM      PurchaseLine Q INNER JOIN
              RequisitionLine R ON Q.RequisitionNo = R.RequisitionNo LEFT OUTER JOIN
              Job ON R.JobNo = Job.JobNo
	WHERE     Q.PurchaseNo = '#URL.ID1#' 
	AND       Q.ActionStatus != '9'
	<cfif url.filter neq "">
	AND       (
	          R.RequisitionNo      LIKE '%#url.filter#%' OR
	          R.RequestDescription LIKE '%#url.filter#%' OR
			  Q.OrderItem          LIKE '%#url.filter#%' OR
			  Q.OrderItemNo        LIKE '%#url.filter#%'		 	  
			  )
	</cfif>		
	
	<cfif getRequestType.recordcount gte "1">
	ORDER BY R.WorkOrderId, Q.ListingOrder, R.Created
	<cfelse>  
	ORDER BY R.Period, Q.ListingOrder, R.Created
	</cfif>
</cfquery>  

<!--- End Prosis template framework --->

<cfquery name="Check" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   InvoicePurchase 
		WHERE  PurchaseNo ='#URL.Id1#'		
</cfquery>	

<cfoutput>


<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right">
<tr><td style="padding-top:4px;padding-left:5px;padding-right:5px"> 

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" class="navigation_table">
  
    <TR class="labelmedium line" bgcolor="white">
	   <td height="16" width="20"></td>
	   <cfif URL.Mode eq "Edit" and PO.ActionStatus eq "0">
	   <td width="20">&nbsp;</td>
	   <cfelse>
	   <td width="1">&nbsp;</td>
	   </cfif>
	   <td width="40%"> <cf_tl id="Description"></td>
	   <td width="60"> <cf_tl id="CaseNo"></td>
	   <td align="center" colspan="2"><cf_tl id="Qty"></td>
       <td width="30" align="right"><cf_tl id="Curr"></td>
       <td align="right"><cf_tl id="Amount"></td>
	   <td align="right"><cf_tl id="On Hold"></td>
	   <td align="right"><cf_tl id="In Process"></td>
	   <td align="right"><cf_tl id="Posted"></td>
	   <td align="right"><cf_tl id="Balance"></td>	
	     
	 </TR> 
		 	 
</cfoutput>	 
		 
<cfset delete = "0">
<cfset persel = "">

<cfif getRequestType.recordcount gte "1">
	<cfset group = "workorderid">
<cfelse>
    <cfset group = "period">
</cfif>
						
<cfoutput query="Lines" group="#group#">

	<cfif getRequestType.recordcount gte "1">
	
		<cfif workorderid neq "">
		
		 <cfquery name="getWorkOrder" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			  SELECT  W.*, C.CustomerName
			  FROM    WorkOrder W, Customer C 
	    	  WHERE   W.WorkOrderId  = '#workorderid#'			
			  AND     W.CustomerId   = C.CustomerId 
	     </cfquery>
		 
		 <tr class="line"><td colspan="11" style="height:25px;padding-left:4px" class="labelmedium"><b><a href="javascript:workorderview('#workorderid#')">#getWorkOrder.CustomerName# #getWorkOrder.Reference#</a></td></tr>
			 
		</cfif> 
	
	<cfelse>

		<!--- summary by period --->
		
		<cfif persel eq "">
			<cfset persel = "'#period#'">
		<cfelse>
			<cfset persel = "#persel#,'#period#'">
		</cfif>
		
		<cfquery name="sum" dbtype="query">
				SELECT SUM(OrderAmount) as OrderAmount, 
				       SUM(OnHold) as OnHold, 
					   SUM(InProcess) as InProcess,
					   SUM(Invoiced) as Invoiced
				FROM   Lines 
				WHERE  Period = '#period#'
		</cfquery>	
			
		<tr class="labelmedium line">
			<td rowspan="<cfif currentrow neq '1'>2</cfif>" colspan="5" style="padding-left:10px">#Period#</td>
			<td height="20" colspan="2"></td>
			<td align="right">#NumberFormat(sum.OrderAmount,",.__")#</td>
			<td align="right" bgcolor="e4e4e4">#NumberFormat(sum.OnHold,",.__")#</td>
			<td align="right">#NumberFormat(sum.InProcess,",.__")#</td>
			<td align="right">#NumberFormat(sum.Invoiced,",.__")#</td>
			
			<cfif sum.OnHold eq "">
			  <cfset hld = 0>
			<cfelse>
			  <cfset hld = sum.OnHold>
			</cfif>
			 
			<cfif sum.InProcess eq "">
			  <cfset prc = 0>
			<cfelse>
			  <cfset prc = sum.InProcess>
			</cfif>
										
			<cfif sum.Invoiced eq "">
			  <cfset inv = 0>
			<cfelse>
			  <cfset inv = sum.Invoiced>
			</cfif>
				
			<td align="right" style="padding-right:4px">#NumberFormat(sum.OrderAmount-prc-inv,",.__")#</td>
		</tr>
			
		<cfif currentrow neq "1">
		
			<cfquery name="csum" dbtype="query">
				SELECT SUM(OrderAmount) as OrderAmount, 
				       SUM(OnHold) as OnHold, 
					   SUM(InProcess) as InProcess,
					   SUM(Invoiced) as Invoiced
				FROM   Lines 
				WHERE  Period IN (#preservesinglequotes(persel)#)
			</cfquery>	
		
			<cfif csum.OnHold eq "">
			  <cfset hld = 0>
			<cfelse>
			  <cfset hld = csum.OnHold>
			 </cfif>
			 
			 <cfif csum.InProcess eq "">
			  <cfset prc = 0>
			<cfelse>
			  <cfset prc = csum.InProcess>
			 </cfif>
										
			<cfif csum.Invoiced eq "">
			  <cfset inv = 0>
			<cfelse>
			  <cfset inv = csum.Invoiced>
			</cfif>
	
			<tr class="labelmedium">
				<td colspan="2"><font color="green"><cf_tl id="Cumulative">:</td>
				<td height="20" align="right"><font color="808080">#NumberFormat(csum.OrderAmount,",.__")#</td>
				<td align="right" bgcolor="e4e4e4"><font color="808080">#NumberFormat(csum.OnHold,",.__")#</td>
				<td align="right"><font color="808080">#NumberFormat(csum.InProcess,",.__")#</td>
				<td align="right"><font color="808080">#NumberFormat(csum.Invoiced,",.__")#</td>
				<td align="right" style="padding-right:4px"><font color="808080">#NumberFormat(csum.OrderAmount-prc-inv,",.__")#</td>
			</tr>
		
		</cfif>
		
	</cfif>	
	
	<cfoutput>
			
			<cfif OrderAmountBase lte "0">							
				<tr bgcolor="FDFEDE" class="line labelmedium navigation_row" id="#requisitionno#_1">
			<cfelse>		
				<tr bgcolor="ffffff" id="#requisitionno#_1" class="line labelmedium navigation_row">			
			</cfif>
			
			<td height="17" width="20" align="center">#CurrentRow#</td>
			
			<cfif URL.mode eq "EDIT" or ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL">
			
				<cfif PO.ActionStatus eq "0" or PO.ActionStatus eq "2" 
				   or getAdministrator(PO.Mission) eq "1" 
				   or (PO.ActionStatus eq "3" 
				             and Parameter.EditPurchaseAfterIssue eq "1" 
							 and DeliveryStatus eq "0")>
				  													
			        <td align="center" width="30" style="padding-top:2px">
					
					 <cf_img icon="edit" onclick="ProcLineEdit('#requisitionno#','edit');"> 
										 
					</td>
				
				<cfelse>
				
				    <td></td>	
				  
				</cfif>  
				  
			<cfelse>
			
				<td></td>	  
				
			</cfif> 	
								
			<cfif OnHold eq "">
			  <cfset hld = 0>
			<cfelse>
			  <cfset hld = OnHold>
			</cfif>			
								
			<cfif InProcess eq "">
			  <cfset prc = 0>
			<cfelse>
			  <cfset prc = InProcess>
			</cfif>
									
			<cfif Invoiced eq "">
			  <cfset inv = 0>
			<cfelse>
			  <cfset inv = Invoiced>
			</cfif>
									
			<td style="padding-top:2px;padding-bottom:2px">
			
			<cfif OrderItem eq "">
				
					<cfset des = RequestDescription>
				
				<cfelse>
				
					<cfset des = OrderItem>
				
				</cfif>
				
				<cfif len(des) gte "75">
					<a href="javascript:ProcReqEdit('#RequisitionNo#','dialog')" title="#des#">#left(des,75)#..</a>
				<cfelse>
				  <a href="javascript:ProcReqEdit('#RequisitionNo#','dialog')">#des#</a>
				</cfif>
			
			</td>
			<td>
			<cfif CaseNo neq "">
				<a href="javascript:job('#JobNo#')">#CaseNo#</a>
			</cfif>
			<cfif lineReference neq "">
			<cfif CaseNo neq "">/</cfif>#LineReference#</cfif>
			</td>
   		    <td align="right">#OrderQuantity#</td>
		    <td align="center">#OrderUoM#</td>
			<td align="right">#Currency#</td>
	      	<td align="right">
				<cfif Parameter.EnablePurchaseClass eq "1">	
				<a title="Click Here to view details" href="javascript:classes('#requisitionno#')">
				</cfif>
				#NumberFormat(OrderAmount,",.__")#
				</a>
			</td>
			<td align="right" bgcolor="e4e4e4"><a title="Click Here to view details for this amount" href="javascript:detail('#requisitionno#')"><font color="0080C0">#NumberFormat(hld,",__.__")#</a></td>
			<td align="right"><a title="Click Here to view details for this amount" href="javascript:detail('#requisitionno#')"><font color="0080C0">#NumberFormat(prc,",__.__")#</a></td>			
			<td align="right"><a title="Click Here to view details for this amount" href="javascript:detail('#requisitionno#')"><font color="0080C0">#NumberFormat(inv,",__.__")#</a></td>
			<td align="right" bgcolor="ffffcf" style="padding-right:4px"><cfif OrderAmount-inv-prc lt "-0.005">
					<font color="FF0000"></cfif>
					#NumberFormat(OrderAmount-inv-prc,",__.__")#
			</td>
			<td align="left" style="padding-left:5px">
					
			  <cfif inv eq "0" and hld eq "0"> <!--- do not delete lines that have been invoiced partially already --->

			  	  <cfset delete = "1">	
				  
				  <cfif url.mode eq "edit">
				  
				  <cfif getAdministrator("*") eq "1" or PO.ActionStatus eq "0">
				      <input type="checkbox" name="RequisitionNo" id="RequisitionNo" value="'#RequisitionNo#'" onClick="javascript:hl(this,this.checked,'#RequisitionNo#')">
				  </cfif>
				  </cfif>
			 
			 </cfif>
			 
		    </td>  
           	</tr>					
			
			<cfif topics gte "1">
			
			<tr class="navigation_row_child">
				<td colspan="2"></td><td colspan="10">				
					<cf_getRequisitionTopic RequisitionNo="#RequisitionNo#" TopicsPerRow="3">
				</td>
			</tr>	
			
			</cfif>
						
			<cfif Receipts gte "1">
									
				<cfquery name="ReceiptList" 
					 datasource="AppsPurchase" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						  SELECT  *
						  FROM    PurchaseLineReceipt 
				    	  WHERE   RequisitionNo = '#RequisitionNo#'			 
				    	  AND     ActionStatus != '9'	
			     </cfquery>
				
				<cfinclude template="POViewLines_Receipt.cfm">
			
			</cfif>

			<tr class="hide navigation_row_child" id="x#requisitionno#">
			     <td colspan="2"></td><td id="xi#requisitionno#" colspan="12"></td>
			</tr>		
			<tr class="hide navigation_row_child" id="#requisitionno#">
			   <td colspan="2"></td><td id="i#requisitionno#" colspan="12"></td>
			</tr>		
						
			<cfif currentrow neq recordcount>						
			<tr><td colspan="12" class="line"></td></tr>
			</cfif>
						
		</cfoutput>
		
</cfoutput>


<cfoutput>	
		
<!--- last summary line --->
			
	<cfquery name="total" dbtype="query">
		SELECT SUM(OrderAmount) as OrderAmount, 
		       SUM(OnHold) as OnHold, 
			   SUM(InProcess) as InProcess,
			   SUM(Invoiced) as Invoiced
		FROM   Lines 				
	</cfquery>	
				
	<cfif Total.OnHold eq "">
		  <cfset hld = 0>
	<cfelse>
		  <cfset hld = Total.OnHold>
	</cfif>	
		
	<cfif Total.InProcess eq "">
		  <cfset prc = "0">
	<cfelse>
		  <cfset prc = Total.InProcess>
	</cfif>		
		
	<cfif Total.Invoiced eq "">
		  <cfset inv = "0">
	<cfelse>
		  <cfset inv = Total.Invoiced>
	</cfif>
	
	<tr><td height="5"></td></tr>
		
	<tr bgcolor="ffffaf" class="labelmedium" style="border:1px solid silver">
		<td style="height:32"></td>
		<td colspan="4">
			
		    <table>
			 <tr>
			  <td>[&nbsp;</td>
			  <td class="labelit" style="font-size:14px;padding-right:3px"><a href="javascript:clonepurchase('#url.id1#')"><u><font color="gray"><cf_tl id="Clone Purchase lines"></font></a> </td>
			 
			 <!--- check if the lines are related to a position so we can show
			 timesheet information for payment monitoring --->
			 
			 <cfquery name="getTimesheet" 
			 datasource="AppsPurchase" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				  SELECT   PL.PurchaseNo, 
				           R.RequisitionNo, 
						   R.PersonNo, 
						   PL.Created, 
						   F.PositionParentId, 
						   F.DateExpiration
				  FROM     PurchaseLine AS PL INNER JOIN
		                   RequisitionLine AS R ON PL.RequisitionNo = R.RequisitionNo INNER JOIN
		                   Employee.dbo.PositionParentFunding AS F ON R.RequisitionNo = F.RequisitionNo
				  WHERE    PL.PurchaseNo = '#url.id1#'
				  ORDER BY PL.PurchaseNo DESC		 
			 </cfquery>
			 
			 
			 <cfif getTimesheet.recordcount gt "0">	
			    <td>|</td>		 
			 	<td class="labelit" style="font-size:14px;padding-left:3px">
			 		<a href="javascript:gettimesheet('#url.id1#')"><u><font color="0080C0"><cf_tl id="Timesheet"></font></a>			 
				</td>	
			 </cfif>	  			 
			 <td>&nbsp;]</td>
			 </tr>
   		    </table> 	
		
	    </td>
		
		<td id="processrequisition"></td>
		<td></td>
		<td style="font-size:15px" align="right"><font color="gray">#NumberFormat(Total.OrderAmount,",__.__")#</b></td>
		<td style="font-size:15px" align="right" bgcolor="e4e4e4"><font color="gray">#NumberFormat(hld,",__.__")#</b></td>
		<td style="font-size:15px" align="right"><font color="gray">#NumberFormat(prc,",__.__")#</b></td>
		<td style="font-size:15px" align="right"><font color="gray">#NumberFormat(inv,",__.__")#</b></td>
		<td style="font-size:17px" align="right" style="padding-right:5px"><font color="gray">
		<cfif total.orderamount eq "">
		0
		<cfelse>
		<b>#NumberFormat(Total.OrderAmount-inv-prc,",__.__")#
		</cfif>
		</b></td>
		<td></td>
	</tr>	
	
	<cfif lines.recordcount gte "1">
	
	<tr><td height="4"></td></tr>
	
	<tr><td valign="top" style="padding-top:5px" colspan="5" align="right" class="labelmedium"><cf_tl id="Receipt Summary"></td><td colspan="7" align="right" style="padding-right:10px">
	
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
		
		<cfif getReceipt.currency neq "">
		
			<table width="300" style="border:1px solid silver">
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
		
		</cfif>
		
		</table>		
	
	</td></tr>
	
	<tr><td height="4"></td></tr>
	
	<tr><td colspan="12" class="line"></td></tr>
	
	
	
	</cfif>
		
</table>

</td></tr> 
</table>

<cfset ajaxOnLoad("doHighlight")>

</cfoutput>	