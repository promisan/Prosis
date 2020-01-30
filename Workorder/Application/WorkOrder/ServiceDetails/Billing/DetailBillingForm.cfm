
<cfinclude template="DetailBillingFormScript.cfm">

<cfquery name="WorkOrder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrder
	 WHERE   WorkOrderId     = '#url.workorderid#'		
</cfquery>

<cfquery name="WorkOrderLine" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrderLine WL 
	         INNER JOIN WorkOrderService WS ON WL.ServiceDomain = WS.ServiceDomain AND WL.Reference = WS.Reference 
	 WHERE   WL.WorkOrderId     = '#url.workorderid#'	
	 AND     WL.WorkOrderLine   = '#url.workorderline#'
</cfquery>

<cfquery name="Class" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    #CLIENT.lanPrefix#Ref_ServiceItemDomainClass
	 WHERE   ServiceDomain = '#WorkOrderLine.ServiceDomain#'
	 AND     Code          = '#WorkOrderLine.ServiceDomainClass#'	
</cfquery>


<cfquery name="BillingOrgUnit" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    ServiceItemMissionOrgUnit
	 WHERE   ServiceItem   = '#WorkOrder.ServiceItem#'		
	 AND     Mission       = '#workOrder.Mission#'
	 AND     OrgUnitImplementer = '#workorderline.OrgUnitImplementer#' 
</cfquery>

<cfif BillingOrgUnit.OrgUnitBilling neq "">

	<cfquery name="Implementer" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    Organization.dbo.Organization
		 WHERE   OrgUnit = '#BillingOrgUnit.OrgUnitBilling#'	
	</cfquery>
	

<cfelse>
	
	<cfquery name="Implementer" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    Organization.dbo.Organization
		 WHERE   OrgUnit = '#workorderline.OrgUnitImplementer#'	
	</cfquery>

</cfif>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_Mission
	 WHERE   Mission = '#workorder.Mission#'	
</cfquery>

<cfquery name="Customer" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Customer
	 WHERE   CustomerId     = '#workorder.customerid#'	
</cfquery>

<cfquery name="CustomerPayer" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    CP.PayerId, O.OrgUnitName, CP.AccountNo
	FROM      CustomerPayer CP INNER JOIN
	          Organization.dbo.Organization O ON CP.OrgUnit = O.OrgUnit
	WHERE     CP.Status <> '9' 
	AND       (CP.DateExpiration IS NULL OR CP.DateExpiration >= GETDATE())
	AND 	  CustomerId     = '#workorder.customerid#'	
	ORDER BY  CP.DateEffective	
</cfquery>

<cfquery name="Item" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    #CLIENT.lanPrefix#ServiceItem
	 WHERE   Code   = '#workorder.serviceitem#'	
</cfquery>

<cfquery name="Domain" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ServiceItemDomain
	 WHERE   Code   = '#item.servicedomain#'	
</cfquery>

<cfif Domain.AllowConcurrent eq "1">

    <!--- each billing stands on itself --->
	
	<cfif url.billingid neq "">
	
		<cfquery name="LastBilling" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT  *	
			     FROM    WorkOrderLineBilling
				 WHERE   WorkOrderId     = '#url.workorderid#'	
				 AND     WorkOrderLine   = '#URL.workorderline#'
				 AND     BillingId       = '#URL.BillingId#'									 
		</cfquery>
					
	<cfelse>
	
		<cfquery name="LastBilling" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    TOP 1 *	
	     FROM      WorkOrderLineBilling
		 WHERE     WorkOrderId     in (
			 SELECT workOrderId
			 FROM WorkOrder.dbo.WorkOrder WHERE CustomerID in (
				SELECT CustomerID FROM WorkOrder.dbo.WorkOrder WHERE WorkOrderId = '#url.workorderid#'
			 )
		 )
		 ORDER BY BillingEffective DESC
		
		 
		</cfquery>	
		
	</cfif>
	
<cfelse>
	
	<cfquery name="LastBilling" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT    *	
	     FROM      WorkOrderLineBilling
		 WHERE     WorkOrderId     = '#url.workorderid#'	
		 AND       WorkOrderLine   = '#URL.workorderline#'
		 ORDER BY  BillingEffective DESC
	</cfquery>

</cfif>

<cf_screentop height="100%" scroll="Yes" html="No" label="Provisioning" line="no" jquery="Yes"
   option="#Customer.customerName# : #Item.Description#" close="parent.ProsisUI.closeWindow('myprovision',true)" layout="webapp" banner="gray">
   
<!--- ------------------------ --->
<!--- add a new billing record --->
<!--- ------------------------ --->

<cf_calendarscript>
<cf_dialogOrganization>
<cf_dialogMaterial>

<cfoutput>

	 <script language="JavaScript">
	 
		function  selectrates(argObj) {	                	 	
		     ptoken.navigate('#SESSION.root#/workorder/Application/workorder/servicedetails/billing/detailbillingScript.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#','dateeffective_trigger')					  						
		}
					
		function formvalidate() {
		     
			 document.getElementById('billingform').onsubmit() 			 
			 if( _CF_error_messages.length == 0 ) {			
			  Prosis.busy('yes')
			  ptoken.navigate('#SESSION.root#/workorder/Application/workorder/servicedetails/billing/DetailBillingSubmit.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&billingid=#url.billingid#','ajaxbox','','','POST','billingform')		
		     }			
		}   
		
		function processaction() {
		    ptoken.navigate('#SESSION.root#/workorder/Application/workorder/servicedetails/billing/setProvisioning.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#','processworkaction','','','POST','billingform')
		}	
		
	  </script>	
			
</cfoutput>	

<table width="100%" align="center" height="100%">
	
<tr><td>

<cfform style="height:98%" id="billingform" name="billingform"  onsubmit="return false">

<table width="100%" align="center" height="99%" cellspacing="0" cellpadding="0">
	
	<tr class="hide"><td colspan="5" id="ajaxbox"></td></tr>
	<tr class="hide"><td colspan="5" id="process"></td></tr>
	
	<cfoutput>
	
	<tr class="line"><td  style="height:28px;padding-left:17px">
	<table width="99%" align="center">
	<tr class="labelmedium">
	<td>#Customer.CustomerName#  <cfif customer.city neq ""><font size="2">(#customer.city#)</cfif></td>
	
	<cfif customerpayer.recordcount gte "1">
	
			<td style="width:80px;padding-left:20px;height:40px" class="labelmedium"><cf_tl id="Payer">:</td>		
			<td style="padding-left:10px;height:40px">		
				<select name="PayerId" class="regularxl">
						<option value="None" selected>None</option>
					<cfloop query="CustomerPayer">
						<option value="#PayerId#" <cfif lastBilling.PayerId eq PayerId>selected</cfif>>#OrgUnitName# (#AccountNo#)</option>		
					</cfloop>
				</select>		
			</td>
		
		<cfelse>
		
			<input type="hidden" name="PayerId" value="">	
			
		</cfif>
	
	<td align="right" style="padding-right:10px">#Item.Description# <cfif class.description neq "">: #Class.Description#</cfif></td>
	</tr>
	</tr></table>	
	
	</cfoutput>
	
	<tr><td height="5"></td></tr>
		
	<tr>
	<td height="10" colspan="5" class="labellarge" style="height:30px;padding-left:20px;padding-right:10px">
	
		<table width="100%">
		
		   <tr class="labelmedium" style="height:35px">	
		   
			  <cfquery name="check" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">						
					SELECT    COUNT(*) as Total
					FROM      WorkOrderServiceMissionItem P
					WHERE     ServiceDomain = '#item.servicedomain#'								
					AND       Mission       = '#workorder.mission#'
					AND       ServiceItem   = '#workorder.serviceItem#'
			  </cfquery>			
			  			 			  
			  <cfif check.total gte "1">
			  			  
			  	  <td style="padding-left:7px"><cf_tl id="Activity">:<cf_space spaces="36"></td>
			  
				  <td style="width:90%;padding-left:7px">
				  
					  <!--- domain activity ---> 
					  	  					  
					  <cfquery name="ServiceArea" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
						SELECT    TOP 20 *
						FROM      WorkOrderService P
						WHERE     ServiceDomain = '#item.servicedomain#'
						AND       EXISTS (SELECT 'X'
						                  FROM   WorkOrderServiceMissionItem
										  WHERE  ServiceDomain = P.ServiceDomain
										  AND    Reference     = P.Reference
										  AND    Mission       = '#workorder.mission#'
										  AND    ServiceItem   = '#workorder.serviceItem#')
						ORDER BY  ListingOrder,Reference 						
						
					  </cfquery>		
					
					<cfif serviceArea.recordcount eq "0">
					
						<cfquery name="ServiceArea" 
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							
							SELECT    TOP 20 *
							FROM      WorkOrderService P
							WHERE     ServiceDomain = '#item.servicedomain#'								      		
							ORDER BY  ListingOrder,Reference 						
							
						</cfquery>							
			
					</cfif>
					
					<!--- select the reference of service --->
					
					<select name="ServiceReference" id="ServiceReference" class="regularxl enterastab">
					<option value="">---<cf_tl id="All features">---</option>
					<cfoutput query="ServiceArea">
					   <cf_tl id="#Description#" var="1">
					   <option value="#Reference#" <cfif LastBilling.Reference eq Reference>selected</cfif>>#lt_text#</option>
					</cfoutput>					
					</select>
								  
				  </td>
				  
			  <cfelse>
			  			  			  			  
			  	 <input type="hidden" name="ServiceReference" id="ServiceReference" value="">
			  
			  	  <td style="font-size:20px;height:40px"><font color="0080C0">
				   <cfoutput>
				   <cf_stringtoformat value="#workorderline.reference#" format="#domain.DisplayFormat#">	
				   #val#
				   </cfoutput>
				   <cfoutput>&nbsp;#WorkorderLine.Description#</cfoutput>
			       </td>		  
			  
			  </cfif>
			  
			   <td align="right" style="padding-right:15x">
			   
				   <table>
				   
			   	   <tr class="labelmedium">
				   
				   <cfif customerpayer.recordcount gte "0">
				   
				   <td style="padding-left:10px;padding-right:4px">				   
				      <cf_tl id="Owner">:<cf_space spaces="50">					  
				   </td>	
				   			   
				   <td style="padding-right:10px">				   				   		
				      		
				   		 <cfif lastBilling.OrgUnit neq "">					 
												 	
							<cfquery name="Org" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								 SELECT  *	
							     FROM    Organization.dbo.Organization
								 WHERE   OrgUnit = '#lastBilling.OrgUnit#'	
							</cfquery>				 	
						 
						    <cfoutput>		
							 
							 	<table>
								    <tr>
									<td>									       
									 <input type="text" name="orgunitname" id="orgunitname" value="#Org.OrgUnitName#" message="No unit selected" required="No" class="regularxl" size="30" maxlength="80" readonly>					  						 
									</td>
									<td style="padding-left:2px">
									 							 
								     <img src="#SESSION.root#/Images/search.png" alt="Select authorised unit" name="img0" 
										  onMouseOver="document.img0.src='#SESSION.root#/Images/contract.gif'" 
										  onMouseOut="document.img0.src='#SESSION.root#/Images/search.png'"
										  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
										  onClick="selectorgN('#workorder.mission#','administrative','orgunit','applyorgunit','','1','modal')">
									  	     
										 <input type="hidden" name="orgunit"      id="orgunit" value="#lastBilling.OrgUnit#"> 
										 <input type="hidden" name="mission"      id="mission"> 
										
									</td>
								    </tr>			 
				                </table>
							
							</cfoutput>
						 
						 <cfelse>
												   
						      <table>
							    <tr>
								<td>
								
								 <cfoutput>
								
									<input type="text" name="orgunitname" id="orgunitname"
								    value="#implementer.OrgUnitName#"
									message="No unit selected" 
									required="No" 
									class="regularxl" 
									size="40" 
									maxlength="80" 
									readonly>
									
								</td>
								<td style="padding-left:2px">
								 								 
							     <img src="#SESSION.root#/Images/search.png" alt="Select authorised unit" name="img0" 
									  onMouseOver="document.img0.src='#SESSION.root#/Images/contract.gif'" 
									  onMouseOut="document.img0.src='#SESSION.root#/Images/search.png'"
									  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
									  onClick="selectorgN('#workorder.mission#','administrative','orgunit','applyorgunit','','1','modal')">
								  	     
									 <input type="hidden" name="orgunit"      id="orgunit" value="#implementer.OrgUnit#"> 
									 <input type="hidden" name="mission"      id="mission"> 
															 
								 </cfoutput>
								 
								 </td>
							  </tr>			 
				            </table>
					  
					    </cfif>						 
					
					   </td>   
					   
		   			<cfelse>
					
						<td style="padding-left:10px;padding-right:4px">
						 	<table>
							    <tr><td><input type="hidden" name="orgunitname" id="orgunitname" value=""><td></tr>
							</table>	
		   				</td>
						
					</cfif>

				   </tr>
				   </table>
			   		  
			  	 </td>  
			   
		   </tr>	   
		</table>
	
	</td>
	</tr>
	
	<tr><td colspan="5">
	
		<table>	
			
		<tr class="labelmedium" style="height:1px">		
									
		<cfif Domain.AllowConcurrent eq "0">
		  
			<td align="right" style="padding-left:10px;height:35px;width:100"><cf_tl id="Effective">:</td>
		    <td style="padding-left:6px;font-size:16px">
						
				  <cf_space spaces="30">
						
				  <cfset sc = 0>
				  								
				  <!--- preset the effective to the line effective date --->
				  <cfif LastBilling.recordcount eq "0">
				  				  	
					  <cfoutput>
						  #dateformat(workorderline.dateeffective,CLIENT.DateFormatShow)#
						  <input type="hidden" name="dateeffective" id="dateeffective" value="#dateformat(workorderline.dateeffective,CLIENT.DateFormatShow)#">
					  </cfoutput>
					  <cfset date = dateformat(now(),CLIENT.DateFormatShow)>
					 		  
				  <cfelse>	
				  		  				  		  
				  
				  	<cfif url.billingid neq "">
													
						<cfquery name="Billing" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							 SELECT  *	
						     FROM    WorkOrderLineBilling
							 WHERE   WorkOrderId     = '#url.workorderid#'	
							 AND     WorkOrderLine   = '#URL.workorderline#'
							 AND     BillingId       = '#URL.BillingId#'					
						</cfquery>
						
						<cfset date =  dateformat(Billing.BillingEffective,CLIENT.DateFormatShow)>								
						<cfoutput>#date#</cfoutput>				
						<input type="hidden" name="dateeffective" id="dateeffective" value="#date#">				
								
					<cfelse>	
										
						<cfif now() lt LastBilling.BillingEffective>			
							<cfset date = dateformat(LastBilling.BillingEffective+1,CLIENT.DateFormatShow)>							
						<cfelse>			
							<cfset date = dateformat(now(),CLIENT.DateFormatShow)>						
						</cfif>
						
						<cfset sc = "1">
						
						<cf_space spaces="40">
						
						<cf_intelliCalendarDate9
								FieldName="dateeffective" 					
								class="regularxl"	
								Default="#date#"		
								scriptdate="selectrates"	
								AllowBlank="False">						
						
					</cfif>
				  		
				  </cfif>		
					
				</td>
				
			<cfelse>
			
				<cfquery name="getLast" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT MAX(TransactionDate) as TransactionDate
					FROM   WorkOrderLineCharge
					WHERE  WorkOrderId   = '#url.WorkOrderId#'
					AND    WorkOrderLine = '#url.WorkOrderLine#'	
					AND    Journal is NOT NULL	
				</cfquery>
				
				<cfif getLast.TransactionDate eq "">	
						
					<cfset date = dateformat(now(),CLIENT.DateFormatShow)>					
					
				<cfelse>	
									
					<cfset date = dateAdd("d","1",getLast.TransactionDate)>												
					<cfset date = dateformat(date,CLIENT.DateFormatShow)>		
												
				</cfif>
				
				<!--- Force this date as for concurrent =1 , better to use the current date , by Armin, Jan 8 2019---->
				<cfset date = dateformat(now(),CLIENT.DateFormatShow)>
				
				<cfset sc = "0">
									
			</cfif>
						  						  			 	
				 <cfif Domain.AllowConcurrent eq "0"> 		
				 
				    <td style="padding-left:21px;height:35px;width:120"><cf_tl id="Expiration">:<cf_space spaces="20"></td>
				    <td style="padding-left:6px">	 
					
					      <cf_space spaces="40">	
			
				 		 <cfif url.billingid eq "">
						 
						  <cf_intelliCalendarDate9
							FieldName="dateexpiration" 					
							class="regularxl enterastab"	
							Default=""		
							AllowBlank="True">	
						 
						 <cfelse> 
			
				 		 <cf_intelliCalendarDate9
							FieldName="dateexpiration" 					
							class="regularxl enterastab"	
							Default="#dateformat(LastBilling.BillingExpiration,CLIENT.DateFormatShow)#"		
							AllowBlank="True">	
							
						  </cfif>	
							
					 </td>		
					
				 <cfelse>	
				 
				 	<td class="labelmedium" style="padding-left:6px">																
										
					<cfif getLast.TransactionDate eq "">	
					
						 <cf_intelliCalendarDate9
							FieldName="dateexpiration" 					
							class="regularxl enterastab"	
							Default="#dateformat(now(),CLIENT.DateFormatShow)#"								
							AllowBlank="True"
							calendar ="noShow">										
					
					<cfelse>
															
						 <cf_intelliCalendarDate9
							FieldName="dateexpiration" 					
							class="regularxl enterastab"	
							Default="#date#"	
							DateValidStart="#Dateformat(dateformat(date,CLIENT.DateFormatShow), 'YYYYMMDD')#"		
							AllowBlank="True"
							calendar ="noShow">					
							
					</cfif>		
					
					</td>							
									
				 </cfif>
								
			<cfoutput>
			
			<cfif lastbilling.BillingReference neq "">
			
					<cfset bref = lastBilling.BillingReference>
					<cfset bnme = lastBilling.BillingName>
					<cfset refn = lastBilling.ReferenceNo>
					<cfset badd = lastBilling.BillingAddress>
					
			<cfelse>
			
				    <cfset bref = customer.Reference>
					<cfset bnme = customer.CustomerName>
					<cfset refn = "">
					<cfset badd = "#Customer.Address#">
			
			</cfif>
			
			<cfif Domain.AllowConcurrent eq "1">
			
				<td style="padding-left:21px;height:35px;width:137px;" class="labelmedium"><cf_tl id="Billing">:</td>
				
				<td class="labelmedium" style="padding-left:6px">
				
				  <table>
				  <tr>
				  
				  <td id="payerbox"></td>
			
				  
				  <td class="labelmedium" style="padding-left:3px">		
				  <input type="text" name="BillingName" id="BillingName" value="#bnme#" size="40" maxlength="80" class="regularxl enterastab">					
				  </td>			  			  
				  <td style="padding-left:2px"><input type="text" class="regularxl enterastab" name="BillingReference" id="BillingReference"  size="12" maxlength="20"   value="#bref#"></td>			
				  
				  <td style="padding-right:3px">
				  																			
						<cf_tl id="TaxCode" var="1">
						
						<cfset link = "#SESSION.root#/Workorder/Application/Workorder/ServiceDetails/Billing/setTax.cfm?1=1">
						   		
						<cf_selectlookup
						    box          = "payerbox"
							title        = "#lt_text#"
							link         = "#link#"
							filter1      = "country"
							filter1value = "#mission.countrycode#"						
							button       = "No"
							icon         = "search.png"
							iconheight   = "25"
							iconwidth    = "25"
							close        = "Yes"
							class        = "tax"
							des1         = "taxcode">	
												
				  </td>
				  
				  <td style="padding-left:2px"><input type="text" class="regularxl enterastab" name="BillingAddress" 	id="BillingAddress"   size="50" maxlength="100"  value="#badd#"></td>			
				  
				  
				  </tr>
				  </table>
						
				</td>
			
			<cfelse>
			
				<!--- for consequitive services for now disabled --->
			
			</cfif>
			
		
			<!---
			
			<td style="padding-left:21px;height:40px" class="labelmedium"><cf_tl id="External Reference">:</td>
			
			<td class="labelmedium" style="padding-left:6px">
			
			  <table>
			  <tr>
			  <td><input type="text" class="regularxl enterastab" name="ReferenceNo" size="12" maxlength="20"  value="#refn#"></td>			   			  
			  </tr>
			  </table>
					
			</td>
			
			--->
								
			</cfoutput>
	
		</tr>
		
		</table>
		
	</td></tr>
		
	<cfif Item.ServiceMode eq "WorkOrder">
	
	    <cfif url.billingid eq "">
				
			<cfquery name="Actions" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			
					SELECT    W.WorkActionId,
					          W.ActionClass, 
					          R.Description, 
							  W.DateTimePlanning,
			                  (SELECT   DateTimePlanning
			                   FROM     WorkPlanDetail
			                   WHERE    WorkActionId = W.WorkActionId AND Operational = '1' <!----avoid more than 1 results ----->) AS DateTimeScheduled, 
							  W.DateTimeActual
					FROM      WorkOrderLineAction W INNER JOIN
			                  Ref_Action R ON W.ActionClass = R.Code
					WHERE     W.WorkOrderId   = '#url.workorderid#' 
					-- AND       W.WorkOrderLine = '#url.workorderline#' 
					AND       W.ActionStatus NOT IN ('9' ,'8')
					AND       R.EntryMode != 'System'
					AND       NOT EXISTS
			                          (SELECT  'X' 
									    FROM   WorkOrderLineBillingAction
			                            WHERE  WorkOrderId   = W.WorkOrderid 
										AND    WorkOrderLine = W.WorkOrderLine
										AND    WorkActionId  = W.WorkActionId)
					ORDER BY  DateTimeScheduled,DateTimePlanning
										
			</cfquery>	
					
		<cfelse>		
								
			<cfquery name="Actions" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			
					SELECT   TOP 10  W.WorkActionId,
					          W.ActionClass, 
					          R.Description, 
							  W.DateTimePlanning,
			                  (SELECT   DateTimePlanning
			                   FROM     WorkPlanDetail
			                   WHERE    WorkActionId = W.WorkActionId AND Operational = '1' <!----avoid more than 1 results ----->) AS DateTimeScheduled, 
							  W.DateTimeActual,							  
							  ( SELECT  BillingId 
						        FROM   WorkOrderLineBilling WB INNER JOIN WorkOrderLineBillingAction WBS 
										ON     WB.WorkOrderId      = WBS.WorkOrderid
										AND    WB.WorkorderLine    = WBS.WorkOrderLine
										AND    WB.BillingEffective = WBS.BillingEffective
										AND    WB.WorkOrderId      = W.WorkOrderid 
										AND    WB.WorkOrderLine    = W.WorkOrderLine
										AND    WBS.WorkActionid    = W.WorkActionId
								AND    BillingId           = '#url.billingid#' ) as Selected							  
							 							  
							  
					FROM      WorkOrderLineAction W INNER JOIN
			                  Ref_Action R ON W.ActionClass = R.Code
					WHERE     W.WorkOrderId   = '#url.workorderid#' 
					AND       W.WorkOrderLine = '#url.workorderline#' 
					AND       W.ActionStatus NOT IN ('9' ,'8')
					AND       R.EntryMode != 'System'
					
					AND       NOT EXISTS
			                          (SELECT  'X' 
									    FROM   WorkOrderLineBilling WB, WorkOrderLineBillingAction WBS
										WHERE  WB.WorkOrderId      = WBS.WorkOrderid
										AND    WB.WorkorderLine    = WBS.WorkOrderLine
										AND    WB.BillingEffective = WBS.BillingEffective
										AND    WB.WorkOrderId      = W.WorkOrderid 
										AND    WB.WorkOrderLine    = W.WorkOrderLine
										AND    WBS.WorkActionid    = W.WorkActionId
										AND    BillingId          != '#url.billingid#')
										
					ORDER BY  DateTimeScheduled,DateTimePlanning
															
			</cfquery>		
		
		</cfif>					
		
		<!--- show actions --->
		<tr><td style="padding-left:18px" colspan="4">
			<table>
			<tr class="labelmedium">
			<td class="hide" id="processworkaction"></td>
			
			<cfoutput query="Actions">			
		
				 <td valign="top" style="padding-top:4px;padding-left:5px">
								
				 				 				 
				 <cfif url.billingid eq "">
				 
				 	<cfif Actions.recordcount eq "1" or currentrow eq "1">
						<input type="checkbox" class="radiol" checked name="workactionid" value="#workactionid#" onclick="processaction()">
					<cfelse>
				 		<input type="checkbox" class="radiol" name="workactionid" value="#workactionid#" onclick="processaction()">
					</cfif>
					
				 <cfelse>
				    <input type="checkbox" class="radiol" <cfif selected neq "">checked</cfif> name="workactionid" value="#workactionid#" onclick="processaction()">
				 </cfif>	
												 
				 </td>	
			     <td style="padding-left:8px;padding-right:10px">
				      <table>
				      <tr style="height:15px" class="labelmedium">
				 	     <td>#Description#</td>
					  </tr>
					  
					  <tr style="height:15px" class="labelmedium">
						 <td>				 												   
						 <cfif DateTimeScheduled neq "">
						   <font color="F24F00">#dateformat(DateTimeScheduled,client.dateformatshow)# <font size="2">#timeformat(DateTimeScheduled,"HH:MM")#</font> 
						 <cfelse>
						   <font color="0080C0">#dateformat(DateTimePlanning,client.dateformatshow)# <font size="2">#timeformat(DateTimePlanning,"HH:MM")#</font>
						 </cfif>					 
						 </td>						
					 
					 </tr>
				 </table>
				 </td>
			
			</cfoutput>
			
			</tr>
					 
		 </table>
		 </td>		
		
		</tr>
			
	</cfif>
	
	<tr><td width="100%" style="padding-left:25px">	
	
		<table width="97%" border="0" cellspacing="0" cellpadding="0" align="left">	  
		
			<!--- Header --->

		  
		   <tr bgcolor="e1e1e1" style="border-top:1px solid silver" class="labelmedium line">
		       <td height="30" width="1"></td>
		       <td width="99%" style="padding-left:4px">
			   	<cf_space spaces="1">
			    <cf_tl id="Item">
			   </td>
			   <td>
			     <cf_space spaces="10">
			     <cf_tl id="Freq">
			   </td>
			   <td align="right">
			   <cf_space spaces="15">
			   <cf_tl id="Qty">
			   </td>
			   
			   <td><cf_space spaces="10"></td>
			   
			   <cfif url.context neq "portal">
			   <td align="right">
			   		<cf_space spaces="30">
				    <cf_tl id="Cost">
				</td>		  
			   <td align="right">
				   <cf_space spaces="30">
				   <cf_tl id="Rate">
			   </td>
			   <td align="right">
			   		<cf_space spaces="30">	
				    <cf_tl id="Charge">
			   </td>
			   <td align="right" style="padding-right:9px">
			   <cf_space spaces="30">	
			   <cf_tl id="Total">
			   </td>
			   </cfif>
			  
		   </tr>
		   
		    <tr bgcolor="E3E8C6" class="line">
			   <td colspan="3"></td>		      
			   <td>
				   <table>
				   <tr class="labelit">
				   <td style="padding-right:10px">
				   	<cf_tl id="Out"><cf_space spaces="11">
				   </td>
				   <td style="padding-right:18px">
				   	<cf_tl id="Usage"><cf_space spaces="11">
				   </td>
				   </tr>
				   </table>			   
			   </td>
			   <td colspan="5"></td>	  
		   </tr>
		   
		   <tr><td height="3"></td></tr>
		   
		   </table>
	
	</td></tr>
			
	<tr><td height="99%" valign="top" colspan="5" width="100%" style="padding-bottom:4px;padding-left:25px;padding-right:15px">		
			
		<cf_divscroll style="width:100%" overflowy="Scroll">	
						
		<cfif check.total gte "1">
		
			<cfdiv bindOnLoad="Yes" id="billingselect"
			bind="url:DetailBillingFormEntry.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&serviceitem=#workorder.serviceitem#&BillingId=#url.billingid#&operational=#workorderline.operational#&context=#url.context#&date=#date#&ServiceReference={ServiceReference}">									
			
		<cfelse>
				
			<cfdiv bindOnLoad="Yes" id="billingselect"
			bind="url:DetailBillingFormEntry.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&serviceitem=#workorder.serviceitem#&BillingId=#url.billingid#&operational=#workorderline.operational#&context=#url.context#&date=#date#">												
		
		</cfif>	
						
		</cf_divscroll>			
						
		</td>
	</tr>
	
	<tr><td colspan="5" height="1" class="line"></td></tr>

	<cfoutput>	
	
	<tr>
		<td colspan="5" height="40" style="padding-bottom:5px;padding-top:5px" align="center">
		
		   <table>
		   <tr>
		   <td>
		
			<cf_tl id="Save Billing Information" var="vSaveBilling">

			<input type="button" 
			       value="#vSaveBilling#" 
				   onclick="formvalidate()"
			       class="button10g"
				   style="height:30;width:250px;font-size:15px">
				   
			</td>
			
			<cfif Domain.AllowConcurrent eq "0">
			
				<!--- option to replicate provisioning to all lines --->
				<td style="padding-left:4px"><input type="checkbox" id="ApplyAll" name="ApplyAll" class="radiol" value="1"></td>
				<td style="padding-left:5px"><cf_tl id="Apply to all"></td>
			
			</cfif>
						
			</tr>
			</table>	
			
		</td>
	</tr>
	
	</cfoutput>

</table>
	 	    
</cfform>

</td></tr>	

</table>

<cfif sc eq "1">

	<cfinclude template="DetailBillingScript.cfm">
	
</cfif>
