
<!--- close line and open the dialog --->

<!---this is to avoid having many trash in this table, each time user voids an invoice, changes something and creates the charges and bill again---- ---->

<cfquery name="get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   WorkOrder W 
		       INNER JOIN WorkOrderLine WL ON W.WorkOrderId  = WL.WorkOrderId 
		       INNER JOIN Customer C ON C.CustomerId         = W.CustomerId
		WHERE  WorkOrderLineId = '#url.workorderlineid#'						
</cfquery>	

<cfquery name="resetdata" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM WorkOrderLineCharge 
		WHERE       WorkOrderId   = '#get.WorkOrderid#'
		AND         WorkOrderLine = '#get.WorkOrderLine#'
		<!--- if the charge is already billed we are NOT removing it 
		      until a user resets it and thus the charles can be redone --->
		AND         Journal is NULL	
</cfquery>		

<cfquery name="workorder" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   WorkOrder  		
		WHERE  WorkOrderId = '#get.WorkOrderId#'					
</cfquery>	

<cfquery name="close" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE  WorkOrderLine  
		SET     ActionStatus = '1'
		WHERE   WorkOrderLineId = '#url.workorderlineid#'					
</cfquery>	

<!--- create an action for closing --->

<cfquery name="getLast" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

SELECT    MAX(TransactionDate) as TransactionDate
FROM      WorkOrderLineCharge
WHERE     WorkOrderId = '#get.WorkOrderId#'
AND       WorkOrderLine = '#get.WorkOrderLine#'
 
AND       Journal is not NULL
 
</cfquery>

<!--- logging as this is considered an action taken on the line that is worth tracking 
similar to opening the FEL for example --->

<cfquery name="Insert" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    INSERT INTO WorkOrderLineAction
			(WorkOrderId, 
			 WorkOrderLine,					
			 ActionClass, 					
			 DateTimeActual,					
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
		VALUES
		   ('#get.WorkOrderId#',
		    '#get.WorkOrderLine#',					
			'Closing',
			#now()#,					
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#')			
</cfquery>

<cfif url.workorderlineid neq "">	
					
	<cfquery name="Billing" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			SELECT	L.WorkOrderId,
					L.WorkOrderLine,
					L.WorkOrderlineId,		
					B.BillingExpiration,			
					B.OrgUnit,				
					B.BillingReference,
					B.BillingName,
					B.BillingAddress,	
					P.PayerId,
					P.OrgUnit as PayerOrgUnit,
					UM.CostId,
					UM.Warehouse,
					UM.ItemNo,
					UM.ItemUoM,
					UM.StandardCost,
					D.ServiceItemUnit,					
					U.UnitDescription,
					U.UnitClass,					
					C.Description AS ClassDescription,
					UM.TaxCode,
					UM.GLAccount,
					D.Currency,
					D.QuantityCost,
					D.Quantity,
					D.Rate,
					SUM(D.Amount) as Amount
					
			FROM 	WorkOrderLine L
	
				INNER JOIN WorkOrderLineBilling B       ON B.WorkOrderId = L.WorkOrderId AND B.WorkOrderLine = L.WorkOrderLine
				INNER JOIN WorkOrderLineBillingDetail D ON D.WorkOrderId = L.WorkOrderId AND D.WorkOrderLine = L.WorkOrderLine AND D.BillingEffective = B.BillingEffective
				INNER JOIN WorkOrder W                  ON W.WorkOrderId = L.WorkOrderId
				INNER JOIN ServiceItemUnit U            ON U.ServiceItem = D.ServiceItem AND U.Unit = D.ServiceItemUnit
				INNER JOIN ServiceItemUnitMission UM    ON UM.ServiceItem = D.ServiceItem AND UM.ServiceItemUnit = D.ServiceItemUnit AND UM.Mission = W.Mission
				INNER JOIN Ref_UnitClass C              ON C.Code = U.UnitClass
				INNER JOIN ServiceItem S                ON S.Code = D.ServiceItem
				
				LEFT OUTER JOIN CustomerPayer P         ON P.CustomerId = W.CustomerId AND P.PayerId = B.PayerId
					
			WHERE    L.WorkOrderLineId = '#url.workorderlineid#'
			
			<!--- only provisioing which is not reflected yet in the charges --->
									
			AND      NOT EXISTS (SELECT  'X'
			                     FROM    WorkOrderLineCharge
			                     WHERE   WorkOrderId     = B.WorkOrderId
								 AND     WorkOrderLine   = B.WorkOrderLine
								 AND     TransactionDate = B.BillingExpiration
								 AND     OrgUnit         = B.OrgUnit )								
						
			<!--- rates --->
			AND      UM.DateEffective <= '#get.DateEffective#' and (UM.DateExpiration is NULL or UM.DateExpiration >= '#get.DateEffective#')	
			
			AND      D.Frequency    = 'Once'
			AND      D.BillingMode  = 'Line'			
			AND      D.Charged      = 1
			
			AND      UM.Operational = 1
			AND      D.Operational  = 1
			
			GROUP BY L.WorkOrderId,
					 L.WorkOrderLine,
					 L.WorkOrderlineId,		
					 B.BillingExpiration,			
					 B.OrgUnit,	
					 B.BillingReference,
					 B.BillingName,		
					 B.BillingAddress,			
					 P.PayerId,
					 P.OrgUnit,
					 UM.CostId,
					 UM.Warehouse,
					 UM.ItemNo,
					 UM.ItemUoM,
					 UM.StandardCost,
					 D.ServiceItemUnit,					
					 U.UnitDescription,
					 U.UnitClass,					
					 C.Description,
					 UM.TaxCode,
					 UM.GLAccount,
					 D.Currency,
					 D.QuantityCost,
					 D.Quantity,
					 D.Rate  
					 					
	</cfquery>	
	
	
	<cfif billing.recordcount gte "0">	
					
		<cfquery name="clear" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM WorkOrderLineCharge
			WHERE       WorkorderId      = '#get.WorkOrderid#'
			AND         WorkorderLine    = '#get.WorkOrderLine#'	
			<cfif getLast.TransactionDate neq "">
			AND         TransactionDate > '#getLast.TransactionDate#'			
			</cfif>
		</cfquery>	
			
	</cfif>		
			
	<cfloop query="Billing">
			
		<cfif BillingExpiration eq "">
			<cfset tradte = dateformat(now(),client.dateformatshow)>
		<cfelse>
		    <cfset tradte = dateformat(BillingExpiration,client.dateformatshow)>
		</cfif>
		
		<CF_DateConvert Value="#tradte#">
	    <cfset DTE = dateValue>

	    <!-----adding the time ---->
	    <cfset hour = Hour(billing.BillingExpiration)>
		<cfset minute = Minute(billing.BillingExpiration)>
		<cfset second = Second(billing.BillingExpiration)>
		<cfif hour lt 10>
			<cfset hour ="0#hour#">
		</cfif>
		<cfif minute lt 10>
			<cfset minute ="0#minute#">
		</cfif>
		<cfif second lt 10>
			<cfset second = "0#second#">
		</cfif>
		<cfset DTE = replace(DTE,"{d ","{ts ","all")>
		<cfset DTE = replace(DTE,"'}"," #hour#:#minute#:#second#' }","all")>
			
		<!--- obtain the owner from the orgunit is owner drives the financials aspects here --->
		
		<cfquery name="org" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      Organization
			WHERE     OrgUnit = '#orgunit#'
		</cfquery>
		
		<cfquery name="parent" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      Organization
			WHERE     Mission    = '#org.mission#'
			AND       MandateNo  = '#org.MandateNo#'			
			AND       OrgUnitCode = '#Org.HierarchyRootUnit#'
		</cfquery>			
			
		<cfif parent.recordcount eq "1">		
			<cfset orgunitowner = parent.orgunit>
		<cfelse>
			<cfset orgunitowner = orgunit>
		</cfif>				
	
		<cfquery name="Tax" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   Ref_Tax 
			WHERE  TaxCode = '#taxcode#'
		</cfquery>
		
		<cfif tax.percentage eq "">
			<cfset percent = "0">
		<cfelse>
			<cfset percent = tax.percentage>
		</cfif>
		
		<!--- normal price value --->
		<cfset pricevalue = StandardCost * Quantity>
		
		<cfif currency eq workorder.currency>
		
			<cfset exc = 1>
			<cfset amt = amount>
			<cfset cst = pricevalue>
										
		<cfelse>
		
			<cf_exchangerate currencyfrom="#Currency#" currencyto="#workorder.currency#" 
		                 datasource="AppsWorkOrder">
			<cfset amt = round(amount / exc * 100) / 100>
			<cfset cst = round(pricevalue / exc * 100) / 100>
											
		</cfif>		
		
		<!--- conversion of the amount based on the currency of the workorder which drives the billing --->
					
		<cfif PayerOrgUnit neq "">
				
			<cfquery name="Insurance" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT     *
				FROM       ServiceItemUnitMissionCharge
				WHERE      CostId        = '#costid#'
				AND        PayerOrgUnit  = '#PayerOrgUnit#' 
				AND        Destination   IN ('OrgUnit','Insurance')
			</cfquery>	
		
			<!--- check if the billing has a rate defined for the insurerer and a copago --->
			
			<cfset cstp = standardcost / exc>
			<cfset cost = (standardcost * quantity) / exc>
			
			<cfif Insurance.amount neq "">
			
				<cfset insurer = round(Insurance.amount / exc * 100) / 100>						
			
				<cfif Tax.TaxCalculation eq "Exclusive">				
					
					<cfset iamt = insurer>
					<cfset itax = insurer*percent>		
					<cfset mde = "0">	
					
				<cfelse>
					
					<cfset iamt = insurer * (1/(1+percent))>
					<cfset itax = insurer * (percent/(1+percent))>	
					<cfset mde = "1">	
					
				</cfif>		
				
				<cfquery name="getCustomer" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
							SELECT   S.*
							FROM     WorkOrder.dbo.Customer S, 
					                 WorkOrder.dbo.WorkOrder W
							WHERE    W.WorkOrderId = '#workorderid#' 
							AND      S.CustomerId = W.CustomerId							
				</cfquery>
						
				<cfif getCustomer.TaxExemption eq "1">				
					<cfset itax = 0>
				</cfif>
				
				<!--- insurer --->
									
				<cfquery name="Charge" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				
					INSERT INTO WorkOrderLineCharge 
					
						(WorkOrderId, 
						 WorkOrderLine,
						 TransactionDate,
						 OrgUnit,OrgUnitOwner,OrgUnitCustomer,
						 Unit,UnitDescription,UnitClass,GLAccountCredit,
						 Warehouse,ItemNo,ItemUoM,Quantity,QuantityCost,
						 CostPrice, CostAmount,
						 BillingReference, BillingName,BillingAddress,
						 Currency,SalePrice,SaleTax,TaxCode,TaxIncluded,TaxExemption,
						 SaleAmountIncome,SaleAmountTax,
						 OfficerUserId,OfficerLastName,OfficerFirstName)
			
					VALUES
					
						('#WorkOrderId#','#workorderline#',#dte#,
						'#OrgUnit#','#OrgUnitOwner#','#PayerOrgUnit#',				
						'#ServiceItemUnit#','#UnitDescription#','#UnitClass#','#GLAccount#',
						'#Warehouse#','#itemNo#','#ItemUoM#','#Quantity#','#QuantityCost#',						
						'#cstp#','#cost#',												
						'#BillingReference#','#BillingName#','#BillingAddress#',
						'#workorder.Currency#','#Rate#','#percent#','#taxcode#','#mde#','0',
						ROUND(#iamt#,2),ROUND(#amt -iamt#,2),
						'#session.acc#','#session.last#','#session.first#')
									
				</cfquery>								
							
				<!--- insert billing record for insurance A --->	
				
			<cfelse>
			
				<cfset insurer = 0>	
			
			</cfif>
			
			<cfquery name="getPersonal" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT     *
					FROM       ServiceItemUnitMissionCharge
					WHERE      CostId       = '#costid#'
					AND        PayerOrgUnit = '#PayerOrgUnit#'
					AND        Destination  = 'Patient'
			</cfquery>	
			
			<cfif getPersonal.amount neq "">			
			
				<cfset personal = round(getPersonal.amount / exc * 100) / 100>	
			
				<cfif Tax.TaxCalculation eq "Exclusive">
					
					<cfset pamt = Personal>
					<cfset ptax = Personal*percent>		
					<cfset mde = "0">	
					
				<cfelse>
					
					<cfset pamt = Personal * (1/(1+percent))>
					<cfset ptax = Personal * (percent/(1+percent))>	
					<cfset mde = "1">	
					
				</cfif>		
				
				<cfset discount = cst - Insurer - Personal>			
							
			<cfelse>
			
				<cfif Insurance.amount eq "">
					<cfset tmp = amt>
				<cfelse>
					<cfset tmp = amt - Insurer>	
				</cfif>		
			
				<cfif Tax.TaxCalculation eq "Exclusive">
					
					<cfset pamt = tmp>
					<cfset ptax = tmp*percent>		
					<cfset mde = "0">	
					
				<cfelse>
					
					<cfset pamt = (tmp) * (1/(1+percent))>
					<cfset ptax = (tmp) * (percent/(1+percent))>	
					<cfset mde = "1">	
					
				</cfif>		
				
				<cfset discount = cst - Insurer - tmp>	
			
				<!--- insert billing record for difference between main rate and insurance A --->		
			
			</cfif>		
			
			<cfquery name="getCustomer" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				SELECT   S.*
				FROM     WorkOrder.dbo.Customer S, 
		                 WorkOrder.dbo.WorkOrder W
				WHERE    W.WorkOrderId = '#workorderid#' 
				AND      S.CustomerId = W.CustomerId							
			</cfquery>
						
			<cfif getCustomer.TaxExemption eq "1">				
				<cfset ptax = 0>
			</cfif>
			
			<cfquery name="Charge" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO WorkOrderLineCharge 
					
						(WorkOrderId, WorkOrderLine,TransactionDate,OrgUnit,OrgUnitOwner,OrgUnitCustomer,				
					 	Unit,UnitDescription,UnitClass,GLAccountCredit,Warehouse,ItemNo,ItemUoM,Quantity,QuantityCost,						
						<cfif insurer eq 0>
						CostPrice, CostAmount,
						</cfif>
						BillingReference, BillingName,BillingAddress,
						Currency,SalePrice,SaleTax,TaxCode,TaxIncluded,TaxExemption,
						SaleAmountIncome,SaleAmountTax,SaleAmountDiscount,
						OfficerUserId,OfficerLastName,OfficerFirstName)
			
					VALUES
						('#WorkOrderId#','#workorderline#',#dte#,'#OrgUnit#','#OrgUnitOwner#','0',				
						'#ServiceItemUnit#','#UnitDescription#','#UnitClass#','#GLAccount#','#Warehouse#','#itemNo#','#ItemUoM#','#Quantity#','#QuantityCost#',
						<cfif insurer eq 0>
						'#cstp#','#cost#',	
						</cfif>	
						'#BillingReference#','#BillingName#','#BillingAddress#',
						'#workorder.Currency#','#Rate#','#percent#','#taxcode#','#mde#','0',
						ROUND(#pamt#,2),ROUND(#amt-pamt#,2),ROUND(#discount#,2),
						'#session.acc#','#session.last#','#session.first#')
											
				</cfquery>	
			
		<cfelse>
		
			<!--- insert billing record --->
			
			<!--- function determine the price annd the tax based on the tax code --->
			
				<cfif Tax.recordcount eq "0">
				
					<cfset pamt = amt>
					<cfset ptax = "0">
					
				<cfelse>
				
					<cfif Tax.TaxCalculation eq "Exclusive">
					
						<cfset pamt = amt>
						<cfset ptax = amt*percent>		
						<cfset mde   = "0">	
					
					<cfelse>
					
						<cfset pamt  = amt * (1/(1+percent))>
						<cfset ptax  = amt * (percent/(1+percent))>	
						<cfset ptax  = int(ptax*100)/100>	
						<cfset pamt  = int((amt-ptax)*100)/100>
						<cfset mde = "1">	
					
					</cfif>			
				
				</cfif>	
				
				<cfset cstp = standardcost / exc>
				<cfset cost = (standardcost * quantity) / exc>
				
				<cfquery name="getCustomer" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
						SELECT   S.*
						FROM     WorkOrder.dbo.Customer S, 
				                 WorkOrder.dbo.WorkOrder W
						WHERE    W.WorkOrderId = '#workorderid#' 
						AND      S.CustomerId = W.CustomerId							
				</cfquery>
						
				<cfif getCustomer.TaxExemption eq "1">				
					<cfset tax = 0>
				</cfif>
				
				<cfset discount = cst - amt>	
			
				<cfquery name="Charge" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO WorkOrderLineCharge 
						(WorkOrderId, WorkOrderLine,TransactionDate,OrgUnit,OrgUnitOwner,OrgUnitCustomer,
						Unit,UnitDescription,UnitClass,GLAccountCredit,Warehouse,ItemNo,ItemUoM,Quantity,QuantityCost,
						CostPrice, CostAmount,
						BillingReference,BillingName,BillingAddress,
						Currency,SalePrice,SaleTax,TaxCode,TaxIncluded,TaxExemption,
						SaleAmountIncome,SaleAmountTax,SaleAmountDiscount,
						OfficerUserId,OfficerLastName,OfficerFirstName)			
					VALUES
						('#WorkOrderId#','#workorderline#',#dte#,'#OrgUnit#','#OrgUnitOwner#','0',					
						'#ServiceItemUnit#','#UnitDescription#','#UnitClass#','#GLAccount#','#Warehouse#','#itemNo#','#ItemUoM#','#Quantity#','#QuantityCost#',
						'#cstp#','#cost#',	
						'#BillingReference#','#BillingName#','#BillingAddress#',
						'#workorder.Currency#','#Rate#','#percent#','#taxcode#','#mde#','0',
						ROUND(#pamt#,2),ROUND(#Amount-pamt#,2),ROUND(#discount#,2),
						'#session.acc#','#session.last#','#session.first#') 
					
				</cfquery>	
				
		</cfif>		
	
	</cfloop>	
	
	
	<!--- ---------------------------------------------------------------------------------- --->
	<!--- direct supply charges has been superseded this is now embedded in the provisioning --->
	<!--- --------------------- 
	
	Attention : if we are going to retake this at some point as to be added to the provsioning	
	make sure we put the right effective date to be taken 
	
	<cfquery name="Mandate" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM       Ref_Mandate
		WHERE      Mission       = '#workorder.mission#'
		AND        DateEffective   <= '#get.DateEffective#'
		AND        DateExpiration  >= '#get.DateEffective#'				
	</cfquery>	
		
	<cfquery name="ItemCharge" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
			SELECT   T.WorkOrderId, 
			         T.WorkOrderLine, 
					 T.BillingUnit, 
					 TS.SalesCurrency, 
					 TS.SalesPrice,
					 TS.TaxCode, 
					 TS.TaxPercentage, 
					 TS.TaxExemption, 
					 TS.TaxIncluded, 
					 TS.TaxPercentage, 
					 TS.SalesAmount,
					 TS.SalesTax, 
		             TS.SalesTotal, 
					 SI.UnitCode, 
					 SI.UnitDescription, 
					 SI.UnitClass, 
					 SI.GLAccount, 
					 O.HierarchyRootUnit, 
					 O.MandateNo, 
					 PAR.OrgUnit AS OrgUnitOwner, 
		             O.OrgUnit AS OrgUnit
					 
			FROM     Materials.dbo.ItemTransaction T INNER JOIN
	                 WorkOrder.dbo.WorkOrder W        ON T.WorkOrderId = W.WorkOrderId INNER JOIN
	                 Materials.dbo.ItemTransactionShipping TS       ON T.TransactionId = TS.TransactionId INNER JOIN
	                 WorkOrder.dbo.ServiceItemUnit SI ON W.ServiceItem = SI.ServiceItem AND T.BillingUnit = SI.Unit INNER JOIN
	                 WorkOrder.dbo.WorkOrderLine WL   ON T.WorkOrderId = WL.WorkOrderId AND T.WorkOrderLine = WL.WorkOrderLine  INNER JOIN
	                 Organization.dbo.Organization O  ON T.OrgUnit = O.OrgUnit INNER JOIN
	                 Organization.dbo.Organization PAR ON O.Mission = PAR.Mission AND O.MandateNo = PAR.MandateNo AND O.HierarchyRootUnit = PAR.OrgUnitCode
					 
			WHERE    T.WorkOrderId = '#get.workorderid#' 
			
			AND      T.WorkOrderLine = '#get.workorderline#'		
			AND      O.Mission       = '#workorder.Mission#'
			AND      O.MandateNo     = '#mandate.MandateNo#'		
		
	</cfquery>	
	
	<!--- obtain transaction date --->
	
	<cfloop query = "ItemCharge">
	
		<cfquery name="getDate" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       WorkOrderLineCharge
			WHERE      WorkOrderId   = '#get.workorderid#' 
			AND        WorkOrderLine = '#get.workorderline#'		
			AND        OrgUnit       = '#orgunit#'
			AND        OrgUnitOwner  = '#OrgUnitOwner#'					
	</cfquery>					
	
		<cfif getDate.recordcount eq "0">
		     <cfset tradte = dateformat(now(),client.dateformatshow)>
		<cfelse>
		     <cfset tradte = dateformat(getDate.TransactionDate,client.dateformatshow)>
		</cfif>
		<CF_DateConvert Value="#tradte#">
    	<cfset DTE = dateValue>
	
		<cfquery name="Charge" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO WorkOrderLineCharge (
			      WorkOrderId, 
				  WorkOrderLine,
				  TransactionDate,
				  OrgUnit,OrgUnitOwner,OrgUnitCustomer,
				  Unit,UnitDescription,UnitClass,GLAccountCredit,
				  BillingReference,BillingName,
				  Currency,SalePrice,SaleTax,TaxCode,TaxIncluded,TaxExemption,SaleAmountIncome,SaleAmountTax,
				  OfficerUserId,OfficerLastName,OfficerFirstName)
			 	
			VALUES (
				    '#WorkOrderId#',
					'#workorderline#',
					#dte#,
					'#OrgUnit#',
					'#OrgUnitOwner#',
					
					'0', <!--- patient billing --->			
					
					'#BillingUnit#',
					'#UnitDescription#',
					'#UnitClass#',
					'#GLAccount#',					
					'#getDate.BillingReference#',
					'#getDate.BillingName#',					
					'#workorder.Currency#',
					'#SalesPrice#',
					'#TaxPercentage#',
					'#TaxCode#',
					'#TaxIncluded#',
					'#TaxExemption#',
					ROUND(#SalesAmount#,2),
					ROUND(#SalesTax#,2),
					
					'#session.acc#',
					'#session.last#',
					'#session.first#'
				)
			
		</cfquery>		
	
	</cfloop>
	
	--->
					
	<!--- now we collect items that were issued to this billing table --->	
	
	<script>	
		document.getElementById('applycharges').className = "xhide"					
	</script>
	
		<table width="100%">
		
			<!---
		
			<tr><td>
				<table><tr><td>
				<img src="<cfoutput>#session.root#</cfoutput>/images/go.png" height="23" width="25px" alt="" border="0">
				</td>
				<td style="padding-left:10px;padding-top:3px;height:50px;font-size:25px" class="labellarge"><font color="0080C0"><cf_tl id="Charges"><cf_tl id="in"><cfoutput>#workorder.Currency#</cfoutput></td>
				</tr>
				</table>
			</td>
			</tr>	
			
			--->
						
			<!---
			
			Loop through the table and group by owner and then group by customerorgunit : insurer / patient --->
				
			<tr><td class="labelmedium" style="padding-left:20px">	
			
				<table width="100%" align="center">
				
					<tr>
					   <td colspan="3" style="height:40px;padding-bottom:5px">
					   						  
						   <cfinclude template="doCOGS.cfm">			
						   <cfset post = "1">			   				   				
						   <cfinclude template="WorkOrderLinePosting.cfm">
											   
					   </td>
				    </tr>	
					
					<cfif toPost eq "1">				
										
					<tr>
							<td style="padding-right:2px" align="center" colspan="2">
								
								<cfoutput>		
								
								<cf_tl id="Close and Post Receivable" var="1">
													
								<input type="button"
						      		onclick="Prosis.busy('yes');ptoken.navigate('doPosting.cfm?workorderlineid=#url.workorderlineid#','posting','','','post','BillingForm')" 
							  		style="font-size:14px;width:450;height:35px;border:1px solid silver" 
							  		name="Post Income" 
							  		value="#lt_text#" 
							  		class="button10g">
									
								</cfoutput>						  		
		
							</td>
					</tr>
					
					</cfif>	
					
					<tr style="height:10px"><td class="labelmedium" id="cposting"></tr>				
				
				</table>
			
			</td></tr>	
			
		</table>

</cfif>

<cfset ajaxOnLoad("scrollbottom")>

<script>
Prosis.busy('no')
</script>