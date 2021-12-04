<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">

<cfparam name="url.scope"        default="backoffice">
<cfparam name="url.action"       default="">
<cfparam name="url.operational"  default="0">
<cfparam name="billingedit"      default="1">

<cfif url.action eq "delete">

	<!--- servicelinesbilling submission --->
	
	<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  * 
		 FROM    WorkOrderLineBilling
		 WHERE   WorkOrderId     = '#url.workorderid#'	
		 AND     WorkOrderLine   = '#url.workorderline#'
		 AND     BillingId       = '#url.billingid#'
	</cfquery>
	
	<cfquery name="cleanWorkOrderFunding1" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 DELETE  FROM WorkOrderFunding
		 WHERE   WorkOrderId       = '#url.workorderid#'	
		 AND     WorkOrderLine     = '#url.workorderline#'
		 AND     BillingEffective  = '#get.BillingEffective#'
	</cfquery>
	
	<cfquery name="cleanWorkOrderFunding2" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 DELETE  FROM WorkOrderFunding
		 WHERE   WorkOrderId       = '#url.workorderid#'	
		 AND     BillingDetailId IN  (
		 
						 SELECT     BillingDetailId
						 FROM       WorkOrderLineBillingDetail
						 WHERE      WorkOrderId      = '#url.workorderid#'	
						 AND        WorkOrderLine    = '#url.workorderline#'
						 AND        BillingEffective = '#get.BillingEffective#'
						 
									 )		 
	</cfquery>

	<cfquery name="cleanWorkOrderBilling" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 DELETE  FROM WorkOrderLineBilling
		 WHERE   WorkOrderId     = '#url.workorderid#'	
		 AND     WorkOrderLine   = '#url.workorderline#'
		 AND     BillingId       = '#url.billingid#'
	</cfquery>
	
	<cfoutput>
	
	<script>
	try {	        
	    lineactionrefresh('#url.workorderId#','#url.workorderline#')    							
		} catch(e) {}
	</script>	
	
	</cfoutput>		

</cfif>

<cfquery name="WorkOrder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrder
	 WHERE   WorkOrderId     = '#url.workorderid#'	
</cfquery>

<cfquery name="WorkOrderFunding" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrderFunding
	 WHERE   WorkOrderId     = '#url.workorderid#'	
</cfquery>
	
<cfquery name="Param" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	      SELECT *
	      FROM   Ref_ParameterMission
	   	  WHERE  Mission = '#workorder.Mission#' 	 
</cfquery>	

<cfquery name="ServiceItem" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    #CLIENT.lanPrefix#ServiceItem
	 WHERE   Code = '#workorder.serviceitem#'	
</cfquery>

<cfquery name="Domain" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ServiceItemDomain
	 WHERE   Code   = '#ServiceItem.servicedomain#'	
</cfquery>

<cfquery name="ServiceItemMission" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT *
	  FROM   ServiceItemMission
	  WHERE  Mission     = '#workorder.Mission#' 	 
	  AND    ServiceItem = '#workorder.serviceitem#'
</cfquery>	

<cfquery name="WorkOrderLine" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrderLine
	 WHERE   WorkOrderId     = '#url.workorderid#'	
	 AND     WorkOrderLine   = '#url.workorderline#'
</cfquery>

<cfif WorkOrderLine.dateExpiration neq "">

	<cfquery name="ClearFunding" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 DELETE FROM WorkOrderFunding
		 WHERE   WorkOrderId     = '#url.workorderid#'	
		 AND     WorkOrderLine   = '#url.workorderline#'
		 AND     BillingEffective > '#workorderline.dateExpiration#'
	</cfquery>

	<!--- reset invalid billing --->

	<cfquery name="Clear" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 DELETE FROM WorkOrderLineBilling
		 WHERE   WorkOrderId     = '#url.workorderid#'	
		 AND     WorkOrderLine   = '#url.workorderline#'
		 AND     BillingEffective > '#workorderline.dateExpiration#'
	</cfquery>
		
	<cfquery name="Last" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT TOP 1 * FROM WorkOrderLineBilling
		 WHERE   WorkOrderId     = '#url.workorderid#'	
		 AND     WorkOrderLine   = '#url.workorderline#'
		 ORDER BY BillingEffective DESC
	</cfquery>
	
	<cfif Last.recordcount neq "0">
		<cfquery name="update" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 UPDATE WorkOrderLineBilling
			 SET    Billingexpiration = NULL
			 WHERE  BillingId = '#last.billingid#'		
		</cfquery>	
	</cfif>

</cfif>

<cfquery name="Customer" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Customer
	WHERE CustomerId = '#workorder.customerid#'	
</cfquery>

<cfif customer.orgunit eq "">

	<cfset access       = "ALL">
	<cfset accessfunder = "ALL">

<cfelse>

	<!--- define access --->

	<cfinvoke component = "Service.Access"  
	   method           = "WorkorderProcessor" 
	   mission          = "#workorder.mission#" 
	   serviceitem      = "#workorder.serviceitem#"
	   returnvariable   = "access">	
	   	
	<cfinvoke component = "Service.Access"  
	   method           = "WorkorderFunder" 
	   mission          = "#param.TreeCustomer#" 
	   orgunit          = "#Customer.OrgUnit#"
	   serviceitem      = "#workorder.serviceitem#"  
	   returnvariable   = "accessfunder">	    
	   
</cfif>	  

<!--- verify the expiration date --->

<cfquery name="Billing" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		 SELECT   *
	     FROM     WorkOrderLineBilling
		 WHERE    WorkOrderId   = '#url.workorderid#'
		 AND      WorkOrderLine = '#url.workorderline#'					 
		 ORDER BY BillingEffective 		 
</cfquery>

<!--- only relevant if not concurrent --->

<cfquery name="EditableLine" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		 SELECT   TOP 1 BillingId
	     FROM     WorkOrderLineBilling
		 WHERE    WorkOrderId   = '#url.workorderid#'
		 AND      WorkOrderLine = '#url.workorderline#'					 
		 ORDER BY BillingEffective DESC		 
</cfquery>

<cfquery name="First" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		 SELECT   *
	     FROM     WorkOrderLineBilling
		 WHERE    WorkOrderId   = '#url.workorderid#'
		 AND      WorkOrderLine = '#url.workorderline#'					 
		 ORDER BY BillingEffective 		 
</cfquery>

<cfset prior = "#Billing.BillingId#">

<cfif Domain.AllowConcurrent eq "0">
	
	<cfloop query="Billing" startrow="2">
	
		<cfset date = DateAdd("d", "-1", "#Billing.BillingEffective#")> 
			
		<cfquery name="Update" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			 UPDATE WorkOrderLineBilling
			 SET    BillingExpiration = #date#
			 WHERE  WorkOrderId   = '#url.workorderid#'
			 AND    WorkOrderLine = '#url.workorderline#'					 
			 AND    BillingId = '#prior#'		
		</cfquery>
		
		<cfset prior = billingid>
	
	</cfloop>

<cfelse>

	<!---

	<cfloop query="Billing">
						
		<cfquery name="Update" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			 UPDATE WorkOrderLineBilling
			 SET    BillingEffective = BillingExpiration
			 WHERE  WorkOrderId   = '#url.workorderid#'
			 AND    WorkOrderLine = '#url.workorderline#'					 
			 AND    BillingEffective > BillingExpiration	
		</cfquery>
			
	</cfloop>
	
	--->

</cfif>	

<cfquery name="Billing" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		 SELECT   *
	     FROM     WorkOrderLineBilling
		 WHERE    WorkOrderId   = '#url.workorderid#'
		 AND      WorkOrderLine = '#url.workorderline#'		
		 <cfif Domain.AllowConcurrent eq "1">
		 ORDER BY OrgUnit, BillingEffective DESC
		 <cfelse>		 		 
		 ORDER BY BillingEffective DESC
		 </cfif>
</cfquery>

<cfset row = 0>

<cfoutput>

<cfif workorderline.dateeffective lt first.billingeffective and Domain.allowconcurrent eq "0">

	<cfif url.scope neq "portal">
		
		<tr><td colspan="10" class="line"></td></tr>
		<tr><td height="30" bgcolor="ffffef" colspan="10" class="labelmedium" align="center"><font color="red"><b><cf_tl id="Attention">:</b> <cf_tl id="No billing lines found for period starting" class="message"> #dateformat(workorderline.dateeffective,CLIENT.DateFormatShow)#</td></tr>
		<tr><td colspan="10" class="line"></td></tr>
			
	</cfif>

</cfif>

<tr class="labelmedium2 line fixlengthlist">
<td></td>
	<td><cf_tl id="Service"></td>
	<td><cf_tl id="Frequency"></td>
	<td><cf_tl id="Charge"></td>
	<td align="center"><cf_tl id="Quantity"></td>	
	<td align="right" colspan="2"><cf_tl id="Rate"></td>	
	<td align="right"><cf_tl id="Total"></td>	
	<td align="right" class="clsNoPrint">
	
		<cfif billingedit eq "1" and  (access eq "EDIT" or access eq "ALL")>
		<a href="javascript:linebillingdetail('#url.workorderid#','#url.workorderline#','')">[<cf_tl id="add">]</a>
		</cfif>
	
	</td>
	<td></td>
</tr>

<tr class="labelmedium2 line fixlengthlist">
<td></td>
	<td width="20%"></td>
	<td></td>
	<td></td>
	<td align="center"><cf_tl id="Stock">|<cf_tl id="Usage"></td>	
	<td align="right" colspan="2"></td>	
	<td align="right"></td>	
	<td align="right"></td>
	<td></td>
</tr>

</cfoutput>

<!--- ----------------------------- --->
<!--- show existing billing records --->

<cfloop query="Billing">

  <cfoutput>       
	
	<!--- check if the billing line has been posted already --->
	
	<cfquery name="checkPosting" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT    *
		FROM      WorkOrderLineCharge
		WHERE     WorkOrderId     = '#workorderid#' 
		AND       WorkOrderLine   = '#workorderline#'
		AND       TransactionDate = '#BillingExpiration#' 
		AND 	  Orgunit 		  = '#orgunit#'
		AND       Journal IS NOT NULL
	</cfquery>	
  
  	<tr><td height="6"></TD></TR>
	
	  <tr class="line fixlengthlist">	  
	  
	  <cfif Domain.AllowConcurrent eq "0">
	  	  
	  	 <cfif billingeffective lte now() and (billingexpiration eq "" or billingexpiration gte now())>
		 
		 	<td colspan="7" class="labellarge" style="font-size:23px;padding-left:17px;height:25px">
		 
			 <font size="1" color="0080C0">&nbsp;<cf_tl id="As per">:</font>
			  <font color="0080C0">#dateformat(billingeffective,CLIENT.DateFormatShow)#			  
			  <cfif billingexpiration eq "">
			  - <font size="1" color="0080C0"><cf_tl id="end of service line"></font>
			  <cfelse>
				  <cfif billingeffective gt billingexpiration>
				  <font color="0080C0"> 
				   - #dateformat(billingexpiration,CLIENT.DateFormatShow)# <cf_tl id="Incorrect date">
				  </font>
				  <cfelse>
				  <font color="0080C0">
				   - #dateformat(billingexpiration,CLIENT.DateFormatShow)#
				  </cfif>		  
			   </cfif>			   
			  </font>
			  
			 </td> 
		 
		 <cfelse>
				 
		 	<td colspan="7" class="labelmedium" style="font-size:20px;padding-left:17px;height:25px">
	  
			  <font size="1" color="808080">&nbsp;<cf_tl id="As per">:</font>
			  #dateformat(billingeffective,CLIENT.DateFormatShow)#		  
			  <cfif billingexpiration eq "">
			  - <font size="1" color="808080"><cf_tl id="end of service line"></font>
			  <cfelse>
			  <cfif billingeffective gt billingexpiration><font color="FF0000"> 
			  - #dateformat(billingexpiration,CLIENT.DateFormatShow)# <cf_tl id="Incorrect date">
			  <cfelse>
			   - #dateformat(billingexpiration,CLIENT.DateFormatShow)#
			  </cfif>		
			  </cfif>  
			  
			 </td> 
		 
		  </cfif>		
	  
	  <cfelse>
	  
	  	  <td colspan="7" class="labelmedium" style="padding-left:17px;height:25px">
	  	      	 
	      <table width="100%">
		  		  
		  <tr class="labelmedium fixlengthlist">
		  		  		  	  
		  <cfif OrgUnit neq "">
		  
				<cfquery name="Org" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
					 SELECT   *
				     FROM     Organization
					 WHERE    orgUnit = '#orgunit#'
				</cfquery>
				
				<cfquery name="Parent" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
					 SELECT   *
				     FROM     Organization
					 WHERE    Mission = '#Org.Mission#'
					 AND      MandateNo = '#Org.MandateNo#'
					 AND      OrgUnitCode = '#Org.HierarchyRootUnit#'
				</cfquery>
				
				<td style="width:480px;padding-left:5px">
					<b>#Org.OrgUnitName# <cfif org.OrgUnitName neq parent.OrgUnitName>/ #parent.OrgUnitName#</cfif></b>
					<font size="2" color="808080">#dateformat(billingexpiration,CLIENT.DateFormatShow)#</font>

					<cfquery name="Encounters" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
						SELECT DISTINCT	WPD.*, RA.Description as ActionDescription
						FROM	WorkOrderLineBillingDetail WB
								INNER JOIN WorkOrderLineBillingAction WA ON WB.WorkOrderid = WA.WorkOrderid
									AND WB.WorkOrderLine = WA.WorkOrderLine
									AND WB.BillingEffective = WA.BillingEffective
								INNER JOIN WorkPlanDetail WPD			 ON WA.WorkActionId = WPD.WorkActionId
								INNER JOIN WorkOrderLineAction A    	 ON WA.WorkActionId = A.WorkActionId
								INNER JOIN Ref_Action RA				 ON A.ActionClass = RA.Code
						WHERE	WB.WorkOrderid       = '#url.workorderid#'
						AND  	WB.WorkOrderLine     = '#url.workorderline#'
						AND  	WB.BillingEffective  = '#BillingEffective#'
						AND		WPD.Operational      = 1
					</cfquery>

					<cfif Encounters.recordCount gt 0>
						<br>
						<font size="2" color="808080">
							<cfset vCountEncounters = 0>
							<cfloop query="Encounters">
								#ActionDescription#: #dateformat(DatetimePlanning, client.dateformatshow)# - #timeformat(DatetimePlanning, "hh:mm tt")#<cfif vCountEncounters neq Encounters.recordCount-1>, </cfif>
								<cfset vCountEncounters = vCountEncounters + 1>
							</cfloop>
						</font>
					</cfif>

				</td>
		  
		  </cfif>
		  
		  <cfif PayerId neq "" or ReferenceNo neq "">
		  		    
			  <td style="padding-left:10px;min-width:100px"><cf_tl id="Bill to">:</td>
			  
			  <cfif PayerId neq "">
			  
				<cfquery name="Payer" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
				 SELECT   C.*,O.OrgUnitName
			     FROM     CustomerPayer C, Organization.dbo.Organization O
				 WHERE    C.OrgUnit = O.OrgUnit
				 AND      PayerId = '#PayerId#'
				</cfquery>
				
				<td style="padding-left:5px"><b>#Payer.OrgUnitName#&nbsp;</b>#BillingReference# #BillingName#</td>
				
			  <cfelse>
			  
			  	<td style="padding-left:5px"><b>#BillingReference# #BillingName#</td>
			  
			  </cfif>			  
			  
			  <cfif ReferenceNo neq "">
			  <td style="padding-left:5px">| <font color="0080C0">#referenceNo#</font></td>		  
			  </cfif>		
			  
		   </cfif>	  
		  
		  </tr>
		  		  
		  </table> 
		  
		  </td>   
		  		  
		</cfif>  		  
	
	  <td colspan="1"></td>
	  
	  <cfset row = row+1>
	  
	  <td align="right" class="clsNoPrint">
	  	 	  
	      <cfif billingedit eq "1">
		  		  
		  <table cellspacing="0" cellpadding="0">
		  
		  	<tr>
			
			   <td>
			   
				   <cfif accessfunder eq "ALL" and ServiceItemMission.ModeGLAccount eq "1">			
				    			   
				   		<img src="#SESSION.root#/images/fund1.gif" 
							  name="img2_#currentrow#"
							  height="13" width="13"
							  style="cursor:pointer"
							  onclick="ptoken.navigate('#SESSION.root#/workorder/application/workorder/Funding/FundingLine.cfm?tabno=1&row=#row#&WorkOrderId=#URL.WorkOrderId#&billingdetailid=#billingid#&ID2=new','funding_#row#')"
						      onMouseOver="document.img2_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
	    				      onMouseOut="document.img2_#currentrow#.src='#SESSION.root#/Images/fund1.gif'"
						      alt="Funding" align="absmiddle" border="0">
							  
				   </cfif>			
			   
			   </td>
			   
			   <td align="right" style="padding-top:2px;padding-right:2px">		
			   
			   	<cfif serviceitem.servicemode eq "Service" or 
					  (serviceitem.servicemode eq "WorkOrder" and checkPosting.recordcount eq "0")>						
											
					 <cfif domain.allowconcurrent eq "0">
					 		   							
			   			<cfif access eq "EDIT" or access eq "ALL" and editableLine.billingid eq BillingId>   										
					    	 <cf_img icon="edit"  onclick="linebillingdetail('#url.workorderid#','#url.workorderline#','#billingid#')">														
						</cfif>				 
						
					<cfelse>
					
						<cfif access eq "EDIT" or access eq "ALL">   										
					    	 <cf_img icon="edit"  onclick="linebillingdetail('#url.workorderid#','#url.workorderline#','#billingid#')">														
						</cfif>		
					
					</cfif>	
						
				</cfif>	
											 
			   </td>			    
						   
			   <td align="left" style="padding-left:1px;padding-right:4px">
			   
			   	<cfif serviceitem.servicemode eq "Service" or 
						  (serviceitem.servicemode eq "WorkOrder" and checkPosting.recordcount eq "0")>		
					   
					<cfif domain.allowconcurrent eq "0">
					   			   										
			   			<cfif access eq "ALL" and editableLine.billingid eq BillingId> 					
						    <cf_img icon="delete" onclick="linebillingdelete('#url.workorderid#','#url.workorderline#','#billingid#')">												  
						 </cfif> 
						 
					<cfelse>
					
						<cfif access eq "ALL"> 					
						    <cf_img icon="delete" onclick="linebillingdelete('#url.workorderid#','#url.workorderline#','#billingid#')">												  
						 </cfif> 
					
					</cfif>	 
					
				</cfif>	
									 
			  </td>
			  
			  <td>
			  		<cfoutput>
						<span id="printTitle" style="display:none;"><cf_tl id="Provisioning"> - #Customer.CustomerName#</span>
						<cf_tl id="Print" var="1">
						<cf_button2 
							mode		= "icon"
							type		= "Print"
							title       = "#lt_text#" 
							id          = "Print"					
							height		= "15px"
							width		= "17px"
							imageHeight = "15px"
							printTitle	= "##printTitle"
							printContent = ".clsPrintProvisioning">
					</cfoutput>
			  </td>
			  
		   </tr>
		  </table>
		  
		  </cfif>
	  
	  </td>
	</tr>	
		
	<!--- funding on the billing level --->
	
	<cfif url.scope eq "backoffice" and WorkOrderFunding.recordcount gte "1">
		<tr><td colspan="9" style="height:0px;border:0px solid silver">
				<table width="96%" align="right">
					<tr><td>	
					<cf_securediv id="funding_#row#" 
					      bind="url:#SESSION.root#/workorder/application/workorder/Funding/Fundingline.cfm?tabno=1&row=#row#&WorkOrderId=#url.workorderid#&billingdetailid=#billingid#">	
					</td></tr>
				</table>	  
		</td></tr>
	</cfif>
		
	</cfoutput>

	<cfquery name="Details" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			SELECT   W.BillingDetailId,
			         W.ServiceItem, 
					 R.UnitParent,
			         W.ServiceItemUnit, 
					 W.Reference,
					 W.Frequency, 
					 F.Description as FrequencyDescription,
					 W.BillingMode, 
					 R.UnitDescription, 
					 R.UnitClass,
					 C.Description as ClassDescription,
					 C.ListingOrder,
					 W.Charged,		
					 (
					 SELECT TOP 1 ItemNo
					 FROM  ServiceItemUnitMission 
					 WHERE Mission         = '#workorder.Mission#'
					 AND   ServiceItem     = W.ServiceItem				 
					 AND   ServiceItemUnit = W.ServiceItemUnit
					 AND   Warehouse is not NULL
					 ) as Stock,
					 
					 (
					 SELECT count(*)
					 FROM  ServiceItemUnitMission 
					 WHERE Mission         = '#workorder.Mission#'
					 AND   ServiceItem     = W.ServiceItem				 
					 AND   ServiceItemUnit = W.ServiceItemUnit
					 AND   DateEffective <= '#workorderline.DateEffective#' 
					 AND   (DateExpiration is NULL or DateExpiration >= '#workorderline.DateEffective#')					 
					 ) as Active,
					 
					 W.QuantityCost,		
					 W.Quantity, 
					 W.Currency, 
					 W.Rate, 
	                 W.Amount
			FROM     WorkOrderLineBillingDetail AS W 
					 INNER JOIN #CLIENT.lanPrefix#ServiceItemUnit AS R ON W.ServiceItem = R.ServiceItem AND W.ServiceItemUnit = R.Unit 
					 INNER JOIN #CLIENT.lanPrefix#Ref_UnitClass C ON C.Code = R.UnitClass 
					 INNER JOIN Ref_Frequency F ON  F.Code = W.Frequency
			 WHERE   W.WorkOrderId      = '#url.workorderid#'
			 AND     W.WorkOrderLine    = '#url.workorderline#'				 
			 AND     W.BillingEffective = '#BillingEffective#'
			 ORDER BY C.ListingOrder, UnitParent, R.ListingOrder
			 
	</cfquery>

	<cfset prior = "">
		
	<cfoutput query="Details" group="ListingOrder">
		
		<!--- hidden 25/10/2016 
		
		<tr>
			<td colspan="6" class="labelmedium" style="height:27px;padding-left:25px"><font color="gray"><cf_tl id="#classDescription#"></font></td>
					
				<td colspan="3" align="right" style="padding-right:11px;font-size:18px" class="labelmedium">
				
				<cfquery name="Subtotal" dbtype="query">
					SELECT SUM(Amount) as Amount
					FROM   Details
					WHERE  UnitClass = '#unitclass#'
				</cfquery>	
				
				#numberformat(subtotal.Amount,',.__')#
				
				</td>	
			
		</tr>
		
		--->
	
		<cfoutput>	
				
			<cfset row = row+1>
			
			<tr class="labelmedium2 line fixlengthlist">
			
			    <td width="20" valign="top" style="padding-left:20px">	
				    &nbsp;				
				</td>
				
				<td style="padding-left:8px" width="50%">	
					<cfif unitparent neq "">. . .</cfif>				
					<cfif stock neq ""><a href="javascript:item('#stock#','#workorder.mission#')"><font color="black"></cfif>
					#UnitDescription# 
				</td>
				
				<cfif amount eq "0" and quantity eq "0">
				
					<td colspan="6"></td>
						
				<cfelse>
				
					<td height="20">#FrequencyDescription#</td>
					<td align="center"><cfif charged eq "0">No<cfelse><cf_tl id="Yes"></cfif></td>
					<td align="center"><cfif Stock gte "1">#QuantityCost#|</cfif>#Quantity#</td>			
					<td align="center">#Currency#</td>							
					<td align="right"><cfif active eq "0"><cf_uitooltip tooltip="No rate defined for this date"><font color="FF0000">#numberformat(Rate,',.__')# *</cf_uitooltip><cfelse>#numberformat(Rate,',.__')#</cfif></td>
					<td align="right">#numberformat(Amount,',.__')#</td>		
					<td align="right">
					
				 	<cfif serviceitem.fundingmode eq "1">			 
						<cfif access eq "ALL">
						  <a href="javascript:ptoken.navigate('#SESSION.root#/workorder/application/workorder/Funding/FundingLine.cfm?tabno=1&row=#row#&WorkOrderId=#URL.WorkOrderId#&billingdetailid=#billingdetailid#&ID2=new','funding_#row#')"><cf_tl id="funding"></a>		
						</cfif>					  
					</cfif>
					
					</td>
				
				</cfif>		
				
			</tr>		
				
			<cfif Reference neq "">
			<tr><td></td>
			    <td colspan="6">
				<font color="808080">
					<cfif unitparent neq "">	
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<cfelse>&nbsp;
					</cfif><i>#Reference#
				</font>
				</td>
			</tr>	
			</cfif>	
			
			<!--- show detail funding for the level only if this is enabled --->
			
			<cfif serviceitem.fundingmode eq "1">
				
				<tr><td colspan="9">
					<table width="100%" cellspacing="0" cellpadding="0" align="right">
						<tr><td>	
						<cf_securediv id="funding_#row#" 
						      bind="url:#SESSION.root#/workorder/application/workorder/Funding/Fundingline.cfm?tabno=1&row=#row#&WorkOrderId=#url.workorderid#&billingdetailid=#billingdetailid#">	
						</td></tr>
					</table>	  
				</td></tr>
			
			</cfif>	
			
		</cfoutput>		
		
	</cfoutput>	
		
	<cfquery name="Total" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			SELECT   Currency, count(*) as Lines,
			         SUM(Amount) AS Total
			FROM     WorkOrderLineBillingDetail
			WHERE    WorkOrderId      = '#url.workorderid#'
			AND      WorkOrderLine    = '#url.workorderline#'		
			AND      BillingEffective = '#BillingEffective#'
			AND      Frequency        = 'Once' 
			AND      Operational      = 1 
			AND      Charged          = 1
			GROUP BY Currency			
	</cfquery>		
		
	<cfif Total.recordcount gte "1" and Total.lines gt "1">
	
	<tr class="line"><td style="padding-left:20px" class="labelmedium2"></td>
	    <td colspan="7" align="right">
			<table>
			<cfoutput query="Total">
			<tr>	    
				<td align="right" class="labelmedium2" style="padding-right:0px"><font size="2" color="008040">#currency# #numberformat(Total,",.__")#</font> </td>	
			</tr>
			</cfoutput>
			</table>
	   </td>
	   <td></td>
	   </tr>
	</cfif>
				
</cfloop>

<!--- 24/9/2016 added a summary in case the billing mode is ONCE --->

<cfquery name="Total" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT   Currency, 
		         SUM(Amount) AS Total
		FROM     WorkOrderLineBillingDetail
		WHERE    WorkOrderId      = '#url.workorderid#'
		AND      WorkOrderLine    = '#url.workorderline#'			
		AND      Frequency = 'Once' 
		AND      Operational = 1 
		AND      Charged = 1
		GROUP BY Currency
		
</cfquery>		
	
<cfif Total.recordcount gte "1">
<tr><td style="padding-left:20px" class="labelmedium2"><cf_tl id="Total"></td>
    <td colspan="7" align="right">
		<table>
		<cfoutput query="Total">
		<tr>	    
			<td align="right" class="labellarge" style="padding-right:0px"><font size="2">#currency#</font> #numberformat(Total,",.__")#</td>	
		</tr>
		</cfoutput>
		</table>
   </td>
   </tr>
</cfif>
   
</table>
