
<!--- billing and charges per line of service --->

<cfparam name="url.personno"      default="">
<cfparam name="url.serviceitem"   default="">
<cfparam name="url.scope"         default="backoffice">
<cfparam name="url.workorderid"   default="{00000000-0000-0000-0000-000000000000}">
<cfparam name="url.workorderline" default="0">

<cfparam name="url.year"          default="#year(now())#">
<cfparam name="url.prior"         default="#year(now()-365)#">

<cfquery name="WorkOrder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   Wo.*, 	
	         SI.Description AS ServiceItemDescription, 			
			 C.OrgUnit,
			 C.CustomerName AS CustomerName, 
             C.Reference AS CustomerReference, 
			 C.PhoneNumber AS CustomerPhoneNo
    FROM     WorkOrder Wo INNER JOIN
             ServiceItem SI ON Wo.ServiceItem = SI.Code INNER JOIN
             Customer C ON Wo.CustomerId = C.CustomerId	
	WHERE    Wo.WorkOrderId = '#URL.workorderid#' 
	
</cfquery>
		
<cfquery name="Param" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	      SELECT *
	      FROM   Ref_ParameterMission
	   	  WHERE  Mission = '#workorder.Mission#' 	 
</cfquery>	

<!--- define access --->
	
<cfinvoke component = "Service.Access"  
   method           = "WorkorderFunder" 
   mission          = "#param.TreeCustomer#" 
   orgunit          = "#workorder.OrgUnit#"
   serviceitem      = "#workorder.serviceitem#"  
   returnvariable   = "accessfunder">	

<table width="100%" cellspacing="0" cellpadding="1">

<cfoutput>

<tr><td height="7"></td></tr>

<!--- this is on the workorder level

<cfif url.scope eq "backoffice">
	
	<cfif accessFunder eq "EDIT" or accessFunder eq "ALL">
		
		<tr><td colspan="2"><font face="Verdana" size="3"><cf_tl id="Threshold"></td></tr>
		<tr><td height="4"></td></tr>
		<tr><td colspan="2" class="line"></td></tr>
		
		<cfform method="POST" name="workorderform">
		
		<tr><td height="4"></td></tr>
		<tr><td colspan="2" style="padding-left:40px"><cfinclude template="../../Threshold/ThresholdGet.cfm"></td></tr>
		<tr><td height="4"></td></tr>
		
		</cfform>
		
		<tr><td colspan="2" class="line"></td></tr>
	
	</cfif>

</cfif>
--->


<tr><td colspan="2" style="height:30px">

<!---
<cfloop index="yr" from="#year(now())#" to="#year(Param.DateChargesCalculate)#" step="-1">
--->
<cfloop index="yr" from="#year(now())#" to="#year(now())-2#" step="-1">
	<font size="2">
	<cfif yr eq url.year><b><font size="4"><cfelse><font size="2"></b></cfif>
	&nbsp;
	<a href="javascript:ptoken.navigate('#SESSION.root#/workorder/application/workorder/servicedetails/Charges/ChargesWorkorderLine.cfm?scope=#url.scope#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#&year=#yr#','contentbox1')">
	<font color="0080FF">#yr#</font></a>
	&nbsp;	
</cfloop>
</td></tr>

<tr><td colspan="2" class="line"></td></tr>

<cfloop index="itm" list="Line,Usage">

    <cfif itm eq "Line">
	
		<tr><td width="50%" valign="top" style="border-right:1px solid gray">
					
		<cfquery name="Billing"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
		
			SELECT    B.BillingEffective, 
			          B.BillingExpiration, 
					  BD.ServiceItem, 
					  BD.ServiceItemUnit, 
					  BD.Frequency, 
					  BD.Currency,			 		
					  BD.Amount, 
					  BD.BillingMode,
					  B.WorkOrderId, 
		              B.WorkOrderLine
					  
			FROM      WorkOrderLineBillingDetail BD INNER JOIN
		              WorkOrderLineBilling B ON BD.WorkOrderId = B.WorkOrderId AND BD.WorkOrderLine = B.WorkOrderLine AND 
		              BD.BillingEffective = B.BillingEffective INNER JOIN
		              WorkOrderLine L ON B.WorkOrderId = L.WorkOrderId AND B.WorkOrderLine = L.WorkOrderLine		  
		     		   				
		    WHERE     L.WorkOrderId   = '#url.workorderid#' 
				<cfif url.workorderline neq "0">
				AND   L.WorkOrderLine = '#url.workorderline#'	  
				</cfif>		  
			
			  <!---  does not matter for planned 
			  AND     BD.Charged = 1
			  --->
			AND     L.Operational = 1		
						 
			</cfquery>
			
			<table width="96%" cellspacing="0" cellpadding="0" align="center">
			
			<tr><td height="30"  align="center" colspan="4"><b><font face="Verdana" size="2"><u><cf_tl id="Planned"></u> <cf_tl id="Charges for"> #year#</font></td></tr>
			<tr><td colspan="4" class="line"></td></tr>
			
	<cfelse>
	
	     <!--- usage --->
	     
		 <td width="50%" valign="top">
		 					
		
		<!--- TUNE query to have less records returned --->
		
		<cfquery name="Billing"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
		   
		   <!--- provisioning --->
		   
		   SELECT   BD.WorkOrderId, 
	                BD.WorkOrderLine,
				    BD.SelectionDate AS BillingEffective, 
				    BD.SelectionDate AS BillingExpiration, 
		            BD.ServiceItem, 
				    BD.ServiceItemUnit, 
					'' as Reference,
					0 as ThresholdProvision,
				    U.UnitClass,
				    'Once' AS Frequency, 
				    'Line' AS BillingMode,
				    BD.Currency, 
				    BD.Amount 					  		   
		   FROM     skWorkOrderCharges BD INNER JOIN		  
				    ServiceItemUnit U ON BD.ServiceItem = U.ServiceItem AND BD.ServiceItemUnit = U.Unit		
		   WHERE    WorkOrderId   = '#url.workorderid#'
		   <cfif url.workorderline neq "0">
	       AND      WorkOrderLine = '#url.workorderline#'	
		   </cfif> 	
		   AND      BD.BillingMode = 'Line'
		   	
		   UNION ALL
		   			   
			   SELECT  BD.WorkOrderId, 
			           BD.WorkOrderLine,
					   BD.TransactionDate AS BillingEffective, 
					   BD.TransactionDate AS BillingExpiration, 
					   BD.ServiceItem, 
					   BD.ServiceItemUnit, 
					   BD.Reference,
					   U.ThresholdProvision,
					   U.UnitClass,
					   'Once' AS Frequency, 
					   'Detail' as BillingMode,
					   BD.Currency, 
					   BD.Amount 							   
			   FROM    WorkOrderLineDetail AS BD INNER JOIN
					   ServiceItemUnit U ON U.ServiceItem = BD.Serviceitem AND U.Unit = BD.ServiceItemUnit			   			   
			   WHERE  BD.WorkOrderId   = '#url.workorderid#'	
			   <cfif url.workorderline neq "0">
			   AND    BD.WorkOrderLine = '#url.workorderline#'	
			   </cfif>		
			   AND    BD.ActionStatus != '9'	   		   		  
			   
			   <!--- disabled for better performance 
			   
			  UNION ALL
			  
			   SELECT  BD.WorkOrderId, 
			           BD.WorkOrderLine,
					   BD.TransactionDate AS BillingEffective, 
					   BD.TransactionDate AS BillingExpiration, 
					   BD.ServiceItem, 
					   BD.ServiceItemUnit, 
					   BD.Reference,
					   U.ThresholdProvision,
					   U.UnitClass,
					   'Once' AS Frequency, 
					   'Detail' as BillingMode,
					   BD.Currency, 
					   BD.Amount 							   
			   FROM    WorkOrderLineDetailNonBillable AS BD INNER JOIN
					   ServiceItemUnit U ON U.ServiceItem = BD.Serviceitem AND U.Unit = BD.ServiceItemUnit			   			   
			   WHERE  BD.WorkOrderId   = '#url.workorderid#'	
			   <cfif url.workorderline neq "0">
			   AND    BD.WorkOrderLine = '#url.workorderline#'	
			   </cfif>		
			   
			   --->
			   			   	   		   		  			  
	    </cfquery>	
		  
		
		<cfquery name="workorder" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT    * 
			FROM      Workorder 
			WHERE     WorkorderId = '#url.workorderid#'
		</cfquery>  		  
				  
		<cfquery name="hasPlannedUnits"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#"> 						  
			  SELECT  DISTINCT U.Unit		
			  FROM    WorkOrderLineBillingDetail BD INNER JOIN
		              WorkOrderLineBilling B
						  ON BD.WorkOrderId      = B.WorkOrderId 
						 AND BD.WorkOrderLine    = B.WorkOrderLine 
						 AND BD.BillingEffective = B.BillingEffective 
					  INNER JOIN WorkOrderLine L 
					      ON B.WorkOrderId    = L.WorkOrderId 
						 AND B.WorkOrderLine  = L.WorkOrderLine 
					  INNER JOIN ServiceItemUnit U 
					      ON BD.ServiceItem     = U.ServiceItem 
						 AND BD.ServiceItemUnit = U.Unit					  		   
			  WHERE   L.WorkOrderId   = '#url.workorderid#'	 
		      <cfif url.workorderline neq "0">			  	  
			  AND     L.WorkOrderLine = '#url.workorderline#'	
			  </cfif> 	
			  
			  UNION
				
			  SELECT  DISTINCT U.Unit
			  FROM    ServiceItemUnit U, Ref_UnitClass R
			  WHERE   U.ServiceItem = '#workorder.serviceitem#'
			  AND     R.Code = U.UnitClass
			  AND     R.isPlanned = 1  <!--- even if provisionin = 0, it is considered as planned --->						  		   						  	  
		</cfquery>			
				
		<!--- get a list of all items to be shown under planned --->
		<cfset plannedunits = quotedvaluelist(hasPlannedUnits.unit)>				
		 		  		 		
		<table width="96%" cellspacing="0" cellpadding="0" align="center">
		
		  <tr><td height="30" align="center" colspan="6"><b><font face="Verdana" size="2"><u><cf_tl id="Actual"></u> <cf_tl id="Charges for"> #year#</font></td></tr>	
		  <tr><td colspan="6" class="line"></td></tr>
			
	</cfif>
	
	<tr class="labelit line">
	   <td style="padding-left:4px"><cf_tl id="Month"></td>
	   <td><cf_tl id="Currency"></td>
	   <cfif itm eq "Line">
	   <td align="right"><cf_tl id="Charges"></td>
	   <cfset col = "4">
	   <cfelse>
	   <td align="right"><cf_tl id="Provision"></td>
	   <td align="right"><cf_tl id="Planned"></td>
	   <td align="right"><cf_tl id="Other">/<cf_tl id="Usage"></td>	
	   <cfset col = "6">  
	   </cfif>
	   <td align="right" style="padding-right:3px"><cf_tl id="Cumulative"></td>
	</tr>
			
	<cfif Billing.recordcount eq "0">
		
	<tr>
	   <td colspan="#col#" height="40" align="center"><font color="gray"><cf_tl id="No records found"></td>	
	</tr>
	
	<cfelse>
		
		<cfquery name="CurrencyList" dbtype="query">
			SELECT DISTINCT Currency
			FROM   Billing				
		</cfquery>  
		
			<cfloop query="currencyList">
			
			<!--- cumulative charges --->
			
			<cfset cum = 0>
			<cfset lincount = 0>
			
			<cfloop index="month" from="1" to="12"> 	 
						
				<cfset lin = 0>
				<cfset pln = 0>
				<cfset usg = 0>
						
			    <!--- define valid rates for that month --->
				
				<cfif itm eq "Line">
								
					<cfset sel = CreateDate(year, month, "1")>
				
					<cfquery name="Rates"       
				         dbtype="query">
							SELECT *
							FROM  Billing
							WHERE BillingEffective <= #sel#
							AND   (BillingExpiration >= #sel# or BillingExpiration is NULL)				
							AND   Currency = '#currency#' 
					</cfquery> 
					
					<cfset lincount = Rates.recordcount>
													
					<cfloop query="Rates">
								
						<cfswitch expression="#frequency#">
						
							<cfcase value="Once">
											
								<cfif year(BillingEffective) eq year>
							
									<cfif month(BillingEffective) EQ month>
									
										<cfset lin = lin + amount>				
										<cfset cum = cum + amount>
									
									</cfif>
								
								</cfif>
						
							</cfcase>
							
							<cfcase value="Day">	
							
									<cfset lin = lin + amount*daysinmonth(sel)>	
									<cfset cum = cum + amount*daysinmonth(sel)>
										
							</cfcase>
							
							<cfcase value="Month">	
														
									<cfset lin = lin + amount>	
									<cfset cum = cum + amount>
										
							</cfcase>
							
							<cfcase value="Quarter">	
							
									<cfset lin = lin + amount/3>	
									<cfset cum = cum + amount/3>
						
							</cfcase>
							
							<cfcase value="Year">	
							
									<cfset lin = lin + amount/12>			
									<cfset cum = cum + amount/12>
						
							</cfcase>
						
						</cfswitch>
												
					</cfloop> 
													
				<cfelse>
				
					<cfset sel = CreateDate(year, month, "1")>
					<cfset end = CreateDate(year,month,daysinmonth(sel))>
					<cfset end = DateAdd("d","1", end)>
										
					<cfquery name="Rates"       
				         dbtype="query">
							SELECT *
							FROM  Billing
							WHERE BillingEffective  >= #sel#
							AND   BillingExpiration <= #end#			
							AND   Currency = '#currency#' 
					</cfquery> 
					
					<cfset lincount = Rates.recordcount>
																				
					<cfloop query="Rates">
										        					
							<cfif billingmode eq "line">													
								<cfset lin = lin + amount>								
							<cfelseif find(serviceitemunit,plannedunits) AND
							    (amount gt ThresholdProvision or Reference is '')>																							
								<cfset pln = pln + amount>
							<cfelse>
							    <cfset usg = usg + amount>
							</cfif>					
							<cfset cum = cum + amount>
							
					</cfloop>		
				 
				</cfif> 
				
				<tr class="labelmedium line">
				
					<td style="height:20px;padding-left:4px">#MonthAsString(month)#</td>
					<TD>#currency#</TD>
										
					<cfif itm eq "line">
					
						<td align="right">#numberformat(lin,",.__")#</td>
					
					<cfelse>
					
						<td align="right">
						#numberformat(lin,"__,__.__")#
						</td>	
						
						<cfif lincount gt "0">
							<td align="right">
							<a href="javascript:chargedetail('#url.workorderid#','#url.workorderline#','#year(sel)#','#month(sel)#','planned',#pln#)">
							#numberformat(pln,",.__")#</font>
							</a>
							</td>	
							
							<td align="right">
							<a href="javascript:chargedetail('#url.workorderid#','#url.workorderline#','#year(sel)#','#month(sel)#','unplanned',#usg#)">					
							#numberformat(usg,",.__")#</font></a> 
							</td>						
						<cfelse>						
							<td align="right">#numberformat(pln,",.__")#</td>	
							<td align="right">#numberformat(usg,",.__")#</td>						
						</cfif>
												
						
					</cfif>
					
					<td align="right" style="padding-right:3px">#numberformat(cum,"__,__.__")#</td>		
				</tr>
				
		   </cfloop>	
		   
		   </cfloop>	
		   
		</cfif>   
		
		</table>
		</td>
		
		<cfif itm eq "Usage">
		 </tr>		
		</cfif> 
   
</cfloop>   
	
</table>	

</cfoutput>
	

