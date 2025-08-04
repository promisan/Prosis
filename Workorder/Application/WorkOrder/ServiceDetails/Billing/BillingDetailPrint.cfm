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
<cfoutput>
<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 		
</cfoutput>

<cfparam name="url.workorderid"    default="">
<cfparam name="url.workorderline"  default="">

<cfset date = dateformat(now(),"mm/dd/yy")>


<cfquery name="OrganizationAction" 
   datasource="AppsOrganization"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
  	SELECT *
	FROM Organization.dbo.OrganizationObjectAction
	WHERE Objectid='#Object.ObjectId#'
	<cfif IsDefined("Object.ActionId")>		
		AND Actionid = '#Object.ActionId#'
	<cfelse>
		AND Actionid = '#Action.ActionId#'
	</cfif>
</cfquery>



<cfif url.workorderid neq "">

	<!--- take passed values froma direct print option --->

<cfelse>
	
	<cfparam name="object.ObjectKeyValue4" default="00000000-0000-0000-0000-000000000000">
	
	<!--- check if this is a workorder action --->
	
	<cfquery name="workAction" 
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">   
		SELECT	*
		FROM    WorkOrderLineAction
		WHERE   WorkActionId = '#object.ObjectKeyValue4#'	
	</cfquery>   
	
	<cfset url.workorderid   = workaction.workorderid>
	<cfset url.workorderline = workaction.workorderline>
	
	<cfif workAction.DateTimePlanning neq "">
		<cfset date              = dateformat(workAction.DateTimePlanning,"mm/dd/yy")>
	</cfif>
	
	<cfset isRequest = "0">
	<cfset vDateEffective = "">
	
	<cfif workAction.recordcount eq "0">
	
		<!--- now check if this is a service request --->
	
		<cfquery name="getRequest"
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	      SELECT   	W.*, R.Reference as RFSNo,
		  			RR.Description as RequestType,
					ISNULL(PR.LastName,'') as RequesterLastName,
					ISNULL(PR.FirstName,'') as RequesterFirstName,
					R.DateExpiration as RequestExpiration,
					R.DateEffective as RequestEffective
		  FROM     RequestWorkOrder W
		  INNER JOIN Request R ON W.RequestId = R.RequestId 
		  INNER JOIN Ref_Request RR ON R.RequestType = RR.Code
    	  LEFT OUTER JOIN Employee.dbo.Person PR ON R.PersonNo = PR.PersonNo		
		  WHERE    W.RequestId     = '#Object.ObjectKeyValue4#' 
		</cfquery>  
	
		<cfif getRequest.workorderidTo neq ''>
			<cfset url.workorderid   = getRequest.workorderidTo>
			<cfset url.workorderline = getRequest.workorderlineTo>
		<cfelse>
			<cfset url.workorderid   = getRequest.workorderid>
			<cfset url.workorderline = getRequest.workorderline>				
		</cfif>
		
		<cfset vDateEffective = getRequest.RequestEffective>
		<cfset date = dateformat(getRequest.RequestEffective,"mm/dd/yy")>
		<cfset isRequest = "1">
	
	<cfelse>
	<!--- get the latest request --->

		<cfquery name="getLastRequest"
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		      SELECT   	W.*, R.Reference as RFSNo,
			  			RR.Description as RequestType
			  FROM     RequestWorkOrder W
			  INNER JOIN Request R ON W.RequestId = R.RequestId 
			  INNER JOIN Ref_Request RR ON R.RequestType = RR.Code
			  WHERE    W.WorkOrderId  = '#url.WorkOrderId#'
			  AND     W.workorderline = #url.workorderLine#	
			  ORDER BY R.RequestDate DESC
		</cfquery>  
	</cfif>	
</cfif>

<cfquery name="Header" 
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#"> 
	SELECT	C.CustomerName,
			S.Code as ServiceItem,
			S.Description as ServiceItemDescription,			
			L.Reference,			
			ISNULL(P.LastName,'') as LastName,
			ISNULL(P.FirstName,'') as FirstName,
			D.Description as DomainClassDescription,
			
			(SELECT TOP 1 ISNULL(Address2,'') + ' ' + ISNULL(AddressRoom,'') 
				FROM Employee.dbo.PersonAddress A
				INNER JOIN System.dbo.Ref_Address R ON A.AddressId = R.AddressId
				WHERE AddressType='Office'
				AND L.PersonNo = A.PersonNo) as Address,

			(SELECT Top 1 A.Reference
				FROM WorkOrderLine A
				INNER JOIN Workorder B ON A.WorkorderId = B.Workorderid 
				WHERE B.serviceItem = (SELECT Code FROM ServiceItem WHERE ServiceDomain = 'Extension' AND operational = 1)
				AND A.PersonNo = L.PersonNo
				AND ((dateexpiration is null) or (dateexpiration > getdate()))) as Extension
				
							
	FROM  WorkOrder W INNER JOIN WorkOrderLine L ON W.WorkOrderId = L.WorkOrderID 
		  INNER JOIN Customer C ON W.CustomerId = C.CustomerId
		  INNER JOIN #CLIENT.lanPrefix#ServiceItem S ON W.ServiceItem = S.Code
		  LEFT OUTER JOIN Ref_ServiceItemDomainClass D on L.ServiceDomain = D.ServiceDomain and L.ServiceDomainClass=D.Code
		  LEFT OUTER JOIN Employee.dbo.Person P ON L.PersonNo = P.PersonNo
		WHERE	L.WorkOrderid = '#url.WorkOrderId#'
		AND     L.workorderline = #url.workorderLine#		
   
</cfquery>   


<cfquery name="BillingDetail" 
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">   

	SELECT	C.CustomerName,
			S.Description as ServiceItemDescription,
			D.WorkOrderId,
			L.Reference,
			L.ServiceDomainClass,
			L.Source,
			SD.Description as ServiceDomain,
			SD.DisplayFormat,
			D.WorkOrderLine,
			B.BillingEffective,
			B.BillingExpiration,
			L.DateEffective,
			L.DateExpiration,
			U.UnitParent,
			U.UnitClass,
			UC.Description as UnitClassDescription,
			D.ServiceItemUnit,
			U.UnitDescription as ServiceItemUnitDescription,	
			U.UnitSpecification,		
			(
				SELECT COUNT(1)
				FROM ServiceItemUnit CU
				WHERE CU.ServiceItem=D.ServiceItem
				AND CU.UnitParent = U.Unit
			) AS ChildUnits,			
			D.Frequency,
			D.billingMode,
			D.Currency,
			D.Quantity,
			D.Rate,
			D.Amount,
			D.Reference as Memo,
			ISNULL(P.LastName,'') as LastName,
			ISNULL(P.FirstName,'') as FirstName,
			ISNULL(L._Name,'') as FixedName,
			ISNULL((SELECT TOP 1 EnableEditQuantity FROM ServiceItemUnitMission SU 
				WHERE SU.Mission = W.Mission and SU.ServiceItem = W.ServiceItem and SU.ServiceItemUnit = U.Unit 
					and SU.DateEffective <= getdate() and SU.DateExpiration > getdate()), 0) AS EnableEditQuantity


<!---			,(SELECT TOP 1 period + '-'+ fund + '-' + orgunitcode + '-' + programcode + '-' + objectcode--->
			,(SELECT TOP 1 fund + '-' + orgunitcode + '-' + programcode + '-' + objectcode
				FROM WorkOrderFunding WF
				INNER JOIN Ref_Funding F ON WF.FundingId = F.FundingId
				WHERE WF.WorkOrderId = L.WorkOrderId
				AND WF.WorkOrderLine IS NULL
				AND WF.ServiceItemUnit IS NULL
				AND WF.BillingDetailId IS NULL
				AND WF.DateEffective <= getdate()
				AND ((WF.DateExpiration IS NULL) OR (WF.DateExpiration > getdate()))
				AND WF.Operational=1
				) as FundingWorkorder

<!---			,(SELECT TOP 1 period + '-'+ fund + '-' + orgunitcode + '-' + programcode + '-' + objectcode--->
			,(SELECT TOP 1 fund + '-' + orgunitcode + '-' + programcode + '-' + objectcode
				FROM WorkOrderFunding WF
				INNER JOIN Ref_Funding F ON WF.FundingId = F.FundingId
				WHERE WF.WorkOrderId = L.WorkOrderId
				AND WF.WorkOrderLine = L.WorkOrderLine
				AND WF.DateEffective <= getdate()
				AND ((WF.DateExpiration IS NULL) OR (WF.DateExpiration > getdate())) 
				AND WF.Operational=1				
				) as FundingWorkOrderLine

<!---			,(SELECT TOP 1 period + '-'+ fund + '-' + orgunitcode + '-' + programcode + '-' + objectcode--->
			,(SELECT TOP 1 fund + '-' + orgunitcode + '-' + programcode + '-' + objectcode
				FROM WorkOrderFunding WF
				INNER JOIN Ref_Funding F ON WF.FundingId = F.FundingId
				WHERE WF.WorkOrderId = L.WorkOrderId
				AND WF.WorkOrderLine IS NULL
				AND WF.BillingDetailId = D.BillingDetailId
				AND WF.DateEffective <= getdate()
				AND ((WF.DateExpiration IS NULL) OR (WF.DateExpiration > getdate()))
				AND WF.Operational=1				
				) as FundingWorkOrderLineDetail				

	FROM    WorkOrderLineBillingDetail D
		INNER JOIN WorkOrderLineBilling B ON D.WorkOrderId = B.WorkOrderID and D.WorkOrderLine = B.WorkOrderLine and D.BillingEffective = B.BillingEffective
		INNER JOIN #CLIENT.lanPrefix#ServiceItemUnit U ON D.ServiceItemUnit = U.Unit and D.ServiceItem = U.ServiceItem
		INNER JOIN #CLIENT.lanPrefix#Ref_UnitClass UC ON U.UnitClass = UC.Code
		INNER JOIN WorkOrder W ON D.WorkOrderId = W.WorkOrderID
		INNER JOIN WorkOrderLine L ON W.WorkOrderId = L.WorkOrderID and D.WorkOrderLine = L.WorkOrderLine
		INNER JOIN Customer C ON W.CustomerId = C.CustomerId
		INNER JOIN #CLIENT.lanPrefix#ServiceItem S ON W.ServiceItem = S.Code
		INNER JOIN Ref_ServiceItemDomain SD ON L.ServiceDomain = SD.Code
		LEFT OUTER JOIN Employee.dbo.Person P ON L.PersonNo = P.PersonNo
		WHERE	D.WorkOrderid = '#url.WorkOrderId#'
		AND     D.workorderline = #url.workorderLine#
		AND		D.BillingEffective <= getdate()	
		AND		((B.BillingExpiration > getdate()) or (B.BillingExpiration is null))

<!---
		AND		D.BillingEffective <= '#date#'	
		AND		((B.BillingExpiration > '#date#') or (B.BillingExpiration is null))
--->		
	ORDER BY U.UnitClass,UnitParent
   
</cfquery>   

<cfquery name="Assets" 
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
   
	SELECT   	A.ItemNo,
			    A.SerialNo,
			    A.Make,
			    A.Model,
			    A.Description,
			    LA.DateEffective,
				A.AmountValue
	FROM       WorkOrderLineAsset LA
	INNER JOIN Materials.dbo.AssetItem A ON LA.AssetId = A.AssetId
	WHERE WorkOrderid = '#url.WorkOrderId#'
	AND   Workorderline = #url.workorderLine#
	AND LA.DateEffective <= getdate()
	AND ((LA.DateExpiration is null) or (LA.DateExpiration > getdate()))	
	AND LA.Operational=1	
   
</cfquery>   

<cfquery name="Supplies" 
   datasource="AppsMaterials"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">

		SELECT   T.TransactionDate,
                 T.ItemNo, 
				 U.UoMDescription,
                 ItemDescription, 
                 abs(TransactionQuantityBase) as TransactionQuantityBase, 
                 TransactionCostPrice,
                 abs(TransactionValue) as TransactionValue, 
                 Remarks, 
                 Warehouse,
				 S.SalesPrice,
				 S.SalesAmount				 
		FROM     Materials.dbo.ItemTransaction AS T
		INNER JOIN Materials.dbo.ItemUoM U ON T.TransactionUoM = U.UoM and T.ItemNo = U.ItemNo
		INNER JOIN Materials.dbo.ItemTransactionShipping S ON	T.TransactionId = S.TransactionId
		WHERE WorkOrderid = '#url.WorkOrderId#'
		AND workorderline = #url.workorderLine#
   		AND T.TransactionDate <= '#date#'
</cfquery>   

<cfset td01 = "border:1px solid b0b0b0">
<cfset td02 = "border-left:1px solid b0b0b0">
<cfset td03 = "border-right:1px solid b0b0b0">
<cfset td04 = "border-top:1px solid b0b0b0">
<cfset td05 = "border-bottom:1px solid b0b0b0">


<cfoutput> 
<table width="100%" cellspacing="0" cellpadding="0" align="center" >
	<tr>
		<td style="#td01#">
		
				 <table width="100%" cellspacing="0" cellpadding="0" align="center" border="0">
					 <tr>
						 <td width="65%" style="#td03#" style="#td05#" align="left"  valign="middle">
							<img align="center" border="0" src="#SESSION.root#/Custom/OICT/images/logo.png" >
						 </td>			 
						 <td width="35%" style="#td05#" rowspan="2">
						 	<table width="100%" cellspacing="0" cellpadding="0" align="center" >
					 			<tr><td width="50%" face="Verdana" height="25" align="center"><font size="2"><b>Service Contract</b></font></td></tr>
					 			<tr><td width="50%" face="Verdana" height="15" align="center"><font size="1">#Header.ServiceItemDescription# - <b><cf_stringtoformat value="#Header.Reference#" format="#BillingDetail.DisplayFormat#"> #val#</b></td></tr>							
								<cfif Header.Firstname neq "" or Header.LastName neq "">
									<tr><td width="50%" face="Verdana" height="15" align="center"><font size="1">#Header.FirstName# #Header.LastName# [#Header.DomainClassDescription#]</td></tr>
								<cfelse>
									<tr><td width="50%" face="Verdana" height="15" align="center"><font size="1">#BillingDetail.FixedName#</font><br><font size="2" color="red">No Index Number associated. Please contact your Focal Point</font></td></tr>
								</cfif>								
								
								<tr><td width="50%" face="Verdana" height="15" align="center"><font size="1">#Header.Address#</td></tr>
								<tr><td width="50%" face="Verdana" height="15" align="center"><font size="1"><cfif Header.Extension neq "">Ext - #Header.Extension#</cfif></td></tr>
								<!--- <tr><td width="50%" face="Verdana" height="15" align="center"><font size="2"><cfif Header.Extension neq "">#Header.CustomerName#</cfif></td></tr> --->
							</table>
						 </td>
						 
					 </tr>
				 </table>
				<br>
				<br>
				<table cellspacing="0" cellpadding="0" align="center"  width="95%">
					<tr>
						<td width="25%"><b>RFS No.</b></td>

						<cfif isRequest eq "1">
								<td width="25%" align="left">#getRequest.RFSNo#</td>		
						<cfelse>
								<td width="25%" align="left">#BillingDetail.Source#</td>
						</cfif>
						<td width="25%"><cfif BillingDetail.ServiceDomainClass neq ""><b>Service Type</b></cfif></td><td width="25%" >#BillingDetail.ServiceDomainClass#</td>
					</tr>
					<tr>
						<td width="25%"><b>Customer</b></td><td width="25%" >#Header.CustomerName#</td>		
						<td width="25%"><b>Effective</b></td><td width="25%" ><cfif vDateEffective eq "">#dateformat(BillingDetail.DateEffective,CLIENT.DateFormatShow)#<cfelse>#dateformat(vDateEffective,CLIENT.DateFormatShow)#</cfif></td>
					</tr>
					<tr>
					<!---
						<td width="25%"><b>User</b></td><td width="25%" >#Header.FirstName# #BillingDetail.LastName#</td>								--->
						<cfif isRequest eq "1">
							<td width="25%"><cfif getRequest.RequestType neq ""><b>Request Type</b></cfif></td><td width="25%">#getRequest.RequestType#</td>
							<td width="25%"><b>Expiration</b></td><td width="25%" >#dateformat(getRequest.RequestExpiration,CLIENT.DateFormatShow)#</td>
							</tr>
							<tr>
								<td width="25%"><b>Requested by</b></td><td width="25%" >#getRequest.RequesterFirstName# #getRequest.RequesterLastName#</td>
							</tr>
						<cfelse>
							<td width="25%"><cfif getLastRequest.RequestType neq ""><b>Request Type</b></cfif></td><td width="25%">#getLastRequest.RequestType#</td>
							<td width="25%"><b>Expiration</b></td><td width="25%" >#dateformat(BillingDetail.DateExpiration,CLIENT.DateFormatShow)#</td>
							</tr>
						</cfif>	
																
					
				</table>
</cfoutput>	
			<br>
			<br>
			
			<table width="97%" cellspacing="0" cellpadding="0" align="center">
			
			<tr><td colspan="12" class="line"></td></tr>
			
			<tr bgcolor="#75A2FE">
			   <td width="25"></td>	
			   <td><font color="#FFFFFF" align="right"><b>Item</b></font></td>
			   <td><font color="#FFFFFF" align="right"><b>Funding</b></font></td>
			   <td><font color="#FFFFFF" align="left"><b>Remarks</b></font></td>
			   <td><font color="#FFFFFF" align="left"><b>Effective</b></font></td>
			   <td><font color="#FFFFFF" align="left"><b>Expiration</b></font></td>
			   <td align="center" colspan="4"><font color="#FFFFFF"><b>Rate /  Unit</b></font></td>   		
			   <td align="right"><font color="#FFFFFF"><b>Qty</b></font></td>   			      			   
			   <td align="right"><font color="#FFFFFF"><b>Amount</b></font></td>   
			</tr>
			<tr><td colspan="12" class="line"></td></tr>   

			<cfset vServiceTotal = "0">			
			<cfset vClassTotal = "0">			
			<cfoutput query="BillingDetail"  group="UnitClass">
								
				<tr><td colspan="12" height="20"><b>#UnitClassDescription#</b></td></tr>
					
				<cfoutput  >					
					
				<tr>
					<td ></td>
					<td ><cfif UnitParent neq "">&nbsp;&nbsp;&nbsp;&nbsp;</cfif> #ServiceItemUnitDescription#</td>
					<td >
						<cfif ChildUnits eq "0">
							<cfif BillingDetail.FundingWorkOrderlineDetail neq "">
								#BillingDetail.FundingWorkOrderlineDetail#
							<cfelseif BillingDetail.FundingWorkOrderline neq "">
								#BillingDetail.FundingWorkOrderline#
							<cfelseif BillingDetail.FundingWorkOrder neq "">
								#BillingDetail.FundingWorkOrder#						
							</cfif>
						</cfif>
					</td>
					<td>#Memo#</td>
					<td><cfif ChildUnits eq "0">#dateformat(BillingDetail.BillingEffective,CLIENT.DateFormatShow)#</cfif></td>
					<td><cfif ChildUnits eq "0">#dateformat(BillingDetail.BillingExpiration,CLIENT.DateFormatShow)#</cfif></td>
					<td align="right" width="30"><cfif ChildUnits eq "0">#Currency#</cfif></td>
					<td align="right" width="40"><cfif ChildUnits eq "0">#numberformat(rate,"__,__.__")#</cfif></td>
					<td align="center" width="20"><cfif ChildUnits eq "0">/</cfif></td>
					<td align="left" width="30"><cfif ChildUnits eq "0">#Frequency#</cfif></td>								
					<td align="right"><cfif ChildUnits eq "0">#numberformat(Quantity,",")#</cfif></td>											    											
					<td align="right"><cfif ChildUnits eq "0">#numberformat(amount,"__,__.__")#</cfif></td>					
				</tr>
				
				<cfif UnitSpecification neq "">
				<tr>
					<td ></td>
					<td colspan="11"><font color="##CCCCCC" size="1">#UnitSpecification#</font></td>
				</tr>
				</cfif>
				
				<tr><td colspan="12" class="line"></td></tr>
				<cfset vServiceTotal = vServiceTotal + amount>		
				<cfset vClassTotal = vClassTotal + amount>	
				
				</cfoutput>
				
					<tr >
				   		<td colspan="11" align="right"></td>	
				   		<td align="right" ><b>#numberformat(vClassTotal,"__,__.__")#</b></td>   
					</tr>			
					
					<cfset vClassTotal = "0">
			</cfoutput>
			<tr><td colspan="12" class="line"></td></tr>
			<tr><td colspan="12" ><br></td></tr>
			<tr >
				  <td colspan="11" align="right"><font size="2"><b>Total</b></font></td>	
				  <td align="right" ><font size="2"><b><cfoutput>#numberformat(vServiceTotal,"__,__.__")#</cfoutput></b></font></td>   
			</tr>
			</table>
			
			<cfif Assets.recordcount neq "0">
				<br><br>
				<table width="90%" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td align="center"><b>Wireless Devices</b></td>
					</tr>
				</table>
				<br>
				<table width="90%" cellspacing="0" cellpadding="0" align="center">
				
				<tr><td colspan="8" class="line"></td></tr>
				
				<tr bgcolor="#75A2FE">
				   <td width="15"></td>	
				   <td><font color="#FFFFFF" size="1"><b>Serial No./SIM</b></font></td>
				   <td><font color="#FFFFFF" size="1"><b>Description</b></font></td>			   
				   <td width="10"></td>	
				   <td><font color="#FFFFFF" size="1"><b>Model</b></font></td>
				   <td width="10"></td>	
				   <td><font color="#FFFFFF" size="1"><b>Provider</b></font></td>
				   <td width="10"></td>	
				   <td><font color="#FFFFFF" size="1"><b>Effective</b></font></td>
					<td align="right"><font color="#FFFFFF"><b>Price</b></font></td>			   
				</tr>
				<tr><td colspan="10" class="line"></td></tr>   
				
				<cfoutput query="Assets" >
				
					<tr>
					   <td width="15"></td>	
					   <td ><font size="1">#SerialNo#</font></td>
					   <td><font size="1">#Description#</font></td>				   
					   <td width="10"></td>	
					   <td><font size="1">#Model#</font></td>
					   <td width="10"></td>	
					   <td><font size="1">#Make#</font></td>
					   <td width="10"></td>	
					   <td><font size="1">#dateformat(DateEffective,CLIENT.DateFormatShow)#</font></td>
					   <td align="right"><font size="1">#numberformat(AmountValue,"__,__.__")#</font></td>
					</tr>
					<tr><td colspan="10" class="line"></td></tr>	
				
				</cfoutput>
				</table>
			</cfif>
			
						
			
			<cfif Supplies.recordcount neq "0">	
				<br><br>		
				<table width="90%" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td align="center"><b>Accesories</b></td>
					</tr>
				</table>
				<br>
				<table width="90%" cellspacing="0" cellpadding="0" align="center">
				
				<tr><td colspan="9" class="line"></td></tr>
				
				<tr bgcolor="#75A2FE">
				   <td width="15"></td>	
				   <td><font color="#FFFFFF"><b>Item</b></font></td>
				   <td><font color="#FFFFFF"><b>Description</b></font></td>
				   <td><font color="#FFFFFF"><b>Unit of Measure</b></font></td>
				   <td align="left"><font color="#FFFFFF"><b>Date</b></font></td>
				   <td align="right"><font color="#FFFFFF"><b>Quantity</b></font></td>
				   <td width="10"></td>	
				   <td align="right"><font color="#FFFFFF"><b>Cost</b></font></td>
				   <td width="10"></td>	
				   <td align="right"><font color="#FFFFFF"><b>Amount</b></font></td>							   
				</tr>
				<tr><td colspan="10" class="line"></td></tr>   
				
				<cfoutput query="Supplies" >
				
					<tr>
					   <td width="15"></td>	
					   <td>#ItemNo#</td>
					   <td>#ItemDescription#</td>
					   <td>#UoMDescription#</td>
					   <td>#dateformat(TransactionDate,CLIENT.DateFormatShow)#</td>
					   <td align="right">#numberformat(TransactionQuantityBase,"__,__.__")#</td>	   
					   <td width="10"></td>	
					   <td align="right">#numberformat(SalesPrice,"__,__.__")#</td>	   
					   <td width="10"></td>	
					   <td align="right">#numberformat(SalesAmount,"__,__.__")#</td>	   
					   <tr><td colspan="10" class="line"></td></tr>	
					</tr>
				
				</cfoutput>
				</table>
			</cfif>
			
			<br><br>
			<cfif Header.serviceItem neq "CU001" and Header.serviceItem neq "CU002">
			<table width="100%" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td>
						<table width="100%" cellspacing="0" cellpadding="0" align="center">
							
							<tr>
								<td width="5%" align="center"></td>
								<td width="40%" align="center">
									<table width="100%" cellspacing="0" cellpadding="0" align="center">
										<tr>
											<td align="center"><font size="1">
												<b>Conditions of Agreement</b><br>
												By Accepting and/or using this Wireless IT Service(s) and/or Device(s), you agree to the following:	
												</font>
												<br>
											</td>																					
										</tr>										
										<tr>								
											<td><font size="1">
												<ul>
													<li>Log-in to MyUNCalls.un.org on a monthly basis.</li>
													<li>Acknowledge and Authorize both fixed and usage charges.</li>
													<li>Check your charges for accuracy</li>
													<li>Identify Business and Personal charges (Mark Calls).</li>
												</ul>									
												By accepting and/or using this Wireless IT Service(s) and/or Device(s) you understand and agree that IT Services(s) and/or Device(s) 
												are issued solely for official UN business under the 'Fair Use" or "Responsible Use" policy, i.e.: Business use. 
												<br><br>
												You are responsible for all charges resulting from any use outside of UN business needs. Please consult with your executive office 
												regarding specific departmental policies.
												</font>
											</td>
										</tr>	
										
									</table>
								</td>
								<td width="5%" align="center"></td>
								<td width="40%"  align="center">
									<table width="100%" cellspacing="0" cellpadding="0" align="center">
										<tr>
											<td align="center"><font size="1">
												<b>Important Links, Policies and Guidelines</b><br>
												Wireless Services and Support:
												</font>
												<br>
											</td>
										</tr>
										<tr>								
											<td><font size="1">
												<ul>
													<li>Iseek Wireless Webpage <a href="https://iseek-newyork.un.org/webpgdept2152_1">https://iseek-newyork.un.org/webpgdept2152_1</a></li>
													<li>Wireless Support <a href="mailto:Wireless@un.org">Wireless@un.org</a></li>
													<li>Service Support <a href="mailto:ITServices@un.org">ITServices@un.org</a></li>
													<li>Technical Support <a href="mailto:HelpdeskOICT@un.org">HelpdeskOICT@un.org</a></li>
												</ul>
												</font>
												<br>
											</td>
										</tr>	
										<tr>
											<td align="center"><font size="1">
												<b>Documents:</b>
												</font>
												<br>
											</td>
										</tr>
										<tr>								
											<td><font size="1">
												<ol>
													<li>Use of Information Technology Resources and Data - ST/SGB/2004/15</li>
													<li>Mobile Communications for Official Work - ST/IC/2005/11</li>
													<li>Technology Policies - <a href="https://iseek-newyork.un.org/webpgdept1630_10">https://iseek-newyork.un.org/webpgdept1630_10</a></li>
												</ol>									
												</font>
												<br><br>
											</td>
										</tr>														
									</table>
								
								</td>
								<td width="5%" align="center"></td>
							</tr>							
						</table>
					</td>
				</tr>
			
				<tr>
					<td><br></td>
				</tr>
				<tr><td class="line"></td></tr>
				<tr>
					<td><br><br><br></td>
				</tr>
				<tr>
					<td>
						<table width="100%" cellspacing="0" cellpadding="0" align="center">
							<tr>
								<td width="15%"></td>
								<td width="30%">
									<table  width="100%" cellpadding="0" cellspacing="0"  align="0">
										<tr><td class="line"></td></tr>
										<tr><td align="center"><b>User Signature</b></td></tr>
									</table>
								</td>
								<td width="10%"></td>
								<td width="30%">
									<table  width="100%" cellpadding="0" cellspacing="0"  align="0">
										<tr>
											<td align="center">
												<cfif OrganizationAction.ActionCode neq "REQW025">
													<cfoutput>#dateformat(now(),CLIENT.DateFormatShow)#</cfoutput>
												</cfif>
											</td>
										</tr>
										<tr><td class="line"></td></tr>
										<tr><td align="center"><b>Date Issued</b></td></tr>				
									</table>		
			
								</td>
								<td width="15%"></td>
							</tr>				
						</table>
						<br><br><br>
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%" cellspacing="0" cellpadding="0" align="center">
							<tr>
								<td width="15%"></td>
								<td width="30%">
									<table  width="100%" cellpadding="0" cellspacing="0"  align="0">
										<tr><td class="line"></td></tr>
										<tr><td align="center"><b>Return Signature</b></td></tr>
									</table>
								</td>
								<td width="10%"></td>
								<td width="30%">
									<table  width="100%" cellpadding="0" cellspacing="0"  align="0">
										<cfif OrganizationAction.ActionCode eq "REQW025">
										<tr>
											<td align="center"> 
											<cfoutput>#dateformat(now(),CLIENT.DateFormatShow)#</cfoutput>
											</td>
										<tr>													
										</cfif>
									
										<tr><td class="line"></td></tr>
										<tr><td align="center"><b>Date Returned</b></td></tr>				
									</table>		
								</td>				
								<td width="15%"></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td align="center"><font size="1"><br>Office of Information and Communications Technology - United Nations Secretariat - New York</font></td></tr>
			</table>
			
			</cfif>
		</td>
	</tr>
</table>
