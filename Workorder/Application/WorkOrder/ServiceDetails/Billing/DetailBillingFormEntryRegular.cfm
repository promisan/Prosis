
<cfquery name="getUnitClass" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   #CLIENT.lanPrefix#Ref_UnitClass 
		WHERE  Code = '#unitclass#'
</cfquery>		

<cfquery name="Domain" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    Ref_ServiceItemDomain
		 WHERE   Code   = '#url.servicedomain#'	
</cfquery>

<cfparam name="url.costid"             default="">
<cfparam name="url.accessmode"         default="edit">
<cfparam name="url.servicereference"   default="">
<cfparam name="url.servicedomainclass" default="">
<cfparam name="url.context"            default="backoffice">

<cfif url.costid neq "">
	
	<!--- show only valid units for the effective dates  --->
	
   <cfquery name="getUnit" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT * 
	FROM   ServiceItemUnitMission
	WHERE  CostId = '#url.costid#'
   </cfquery>
   
   <cfset url.serviceitem = getUnit.serviceitem>
   <cfset url.mission     = getUnit.Mission>
   <cfset url.parent      = getUnit.serviceitemunit>
    
</cfif>   

<cfif url.date eq "">

	<cfif url.billingid eq "" or url.billingid eq "00000000-0000-0000-0000-000000000000">

	   <cfset dateValue = "">
	   <CF_DateConvert Value="#dateformat(now(),CLIENT.DateFormatShow)#">
	   <cfset STR = dateValue>
	
	<cfelse>
	
	   <cfquery name="getBilling" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   WorkOrderLineBilling
			WHERE  BillingId = '#url.Billingid#'
	   </cfquery>
	   
	   <cfset dateValue = "">
	   <CF_DateConvert Value="#dateformat(getBilling.BillingEffective,CLIENT.DateFormatShow)#">
	   <cfset STR = dateValue>
	
	</cfif>

<cfelse>

	 <cfset dateValue = "">
     <CF_DateConvert Value="#url.date#">
	 <cfset STR = dateValue>

	<!--- no action --->
	
</cfif>

<cfquery name="UnitDetail" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

	 SELECT R.Unit,
	        R.UnitClass, 
	        R.ListingOrder, 
			
			<cfif url.serviceReference neq "">
			<!--- alternate sorting --->
			
			(    SELECT ListingOrder
			     FROM   ServiceItemUnitWorkorderService
				 WHERE  ServiceItem   = '#url.serviceitem#'
				 AND    ServiceDomain = '#url.servicedomain#'
				 AND    Reference     = '#url.serviceReference#'
				 AND    Mission       = '#url.mission#'
				 AND    Unit = R.Unit) as ServiceListingOrder,		
				 
			(    SELECT EnableSetDefault
			     FROM   ServiceItemUnitWorkorderService
				 WHERE  ServiceItem   = '#url.serviceitem#'
				 AND    ServiceDomain = '#url.servicedomain#'
				 AND    Reference     = '#url.serviceReference#'
				 AND    Mission       = '#url.mission#'
				 AND    Unit = R.Unit) as ServiceEnableSetDefault,		
				 
			</cfif>	 	 	
				
			R.UnitDescription,
			R.UnitSpecification,
			
				(SELECT TOP 1 ItemNo 
				 FROM   ServiceItemUnitMission M
				 WHERE  M.Mission         = '#url.mission#'
			     AND    M.ServiceItem     = '#url.serviceitem#'
				 AND    M.ServiceItemUnit = R.Unit 
			     AND    M.DateEffective <= #str# 
			     AND    (M.DateExpiration >= #str# or M.DateExpiration is NULL)
				 AND    M.BillingMode    != 'Supply'
				 AND    Warehouse IS NOT NULL) as ItemWarehouse,
				 
				(SELECT TOP 1 EnableUsageEntry 
				 FROM   ServiceItemUnitMission M
				 WHERE  M.Mission         = '#url.mission#'
			     AND    M.ServiceItem     = '#url.serviceitem#'
				 AND    M.ServiceItemUnit = R.Unit 
			     AND    M.DateEffective <= #str# 
			     AND    (M.DateExpiration >= #str# or M.DateExpiration is NULL)
				 AND    M.BillingMode    != 'Supply'
				 AND    Warehouse IS NOT NULL) as  EnableUsageEntry, 
				 
			R.PricePrecision,
			R.EntryMode
	      			
     FROM   #CLIENT.lanPrefix#ServiceItemUnit R
			
	 WHERE  R.ServiceItem  = '#url.serviceitem#'	
	 
	 <cfif url.billingid eq "">			   
	 AND    R.Operational = 1
	 </cfif>
		 
	 <!--- we only show if this line has a valid rate for this period  --->
	 			 
	 AND      Unit IN (
		 				   SELECT ServiceItemUnit 
		                   FROM   ServiceItemUnitMission M
		 				   WHERE  M.Mission        = '#url.mission#'
						   AND    M.ServiceItem    = '#url.serviceitem#'
						   AND    M.DateEffective <= #str# 
						   AND    (M.DateExpiration >= #str# or M.DateExpiration is NULL)
						   AND    M.BillingMode    != 'Supply'
						  )		
						  
	<cfif url.serviceReference neq "">
		
	 AND     EXISTS (SELECT 'X' 
			         FROM   ServiceItemUnitWorkorderService
					 WHERE  ServiceItem   = '#url.serviceitem#'
					 AND    Unit          = R.Unit
					 AND    ServiceDomain = '#url.servicedomain#'
					 AND    Reference     = '#url.serviceReference#'
					 AND    Mission       = '#url.mission#') 			
						
	</cfif>					  
			 	 
	 AND    R.UnitClass = '#unitclass#'
	 
	 <!--- filter only on units that have a service class defined, this was done for maintinsa, needs to be adjusted for the request --->
	 <cfif url.servicedomainclass neq "">
	 AND     (R.ServiceDomainClass is NULL or (R.ServiceDomain = '#url.servicedomain#' AND R.ServiceDomainClass = '#url.servicedomainclass#'))
	 </cfif>	
	 
	 <cfif url.parent eq "">
	 AND    (R.UnitParent is NULL or R.UnitParent = '')
	 <cfelse>
	 <!--- either the class or the selected unit within the class --->
	 AND    (R.UnitParent = '#url.parent#' OR R.unitParent = '#url.unitclass#')	 
	 
	 </cfif>
	 
	 <cfif url.serviceReference eq "">
	 			 
	 ORDER BY R.ListingOrder, 
			  R.UnitDescription			
			  
	 <cfelse>
	 
	 ORDER BY ServiceListingOrder,
			  R.UnitDescription		
	 	 
	 </cfif>		  	

</cfquery>


<cfquery name="Parent"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   ServiceItemUnitMission
	WHERE  ServiceItem     = '#url.serviceitem#'
	AND    ServiceItemUnit = '#url.parent#'
	AND    Mission         = '#url.mission#'
</cfquery>	

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT   TOP 1 *
		 FROM     WorkOrder
		 <cfif url.workorderid neq "">
		 WHERE    WorkOrderId      = '#url.workorderid#'		
		 <cfelse>
		 WHERE  1=0
		 </cfif>
</cfquery>					

<cfoutput query="UnitDetail">

	<!--- determine the initial rate --->
	
	<cfinvoke component = "Service.Process.WorkOrder.Provisioning"  
	   method           = "getRate" 
	   Mission          = "#url.mission#"
	   OrgUnitOwner     = "#url.orgunitowner#"
	   ServiceItem      = "#url.serviceitem#"
	   Unit             = "#unit#"
	   SelectionDate    = "#dateformat(str,client.dateformatshow)#"   
	   returnvariable   = "Rate">	   	

	<cfset selected = "0">
	
	<cfif url.mode eq "workorder">		
				
			<cfquery name="UnitUsed" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT  *
				 FROM    WorkOrderLineBilling B,
				         WorkOrderLineBillingDetail	BD				
				 WHERE   B.WorkOrderid        = BD.WorkOrderid
				 AND     B.WorkOrderLine      = BD.WorkOrderLine
				 AND     B.BillingEffective   = BD.BillingEffective		 
				 AND     B.WorkOrderId        = '#url.workorderid#'
				 AND     B.WorkOrderLine      = '#url.workorderline#'
				 
				 <cfif Domain.AllowConcurrent eq "0">
				 <!--- this will enherit the provisioning from the prior --->
				 AND     B.BillingEffective  <= #str#
				 <cfelseif url.billingid eq "">
				 AND     1=0				 
				 </cfif>
				 <!--- 18/9/2015 : added by Hanno to ensure in case of edit the right selection is shown --->				 
				 <cfif url.billingid neq "00000000-0000-0000-0000-000000000000" and url.billingid neq "">
				 AND     B.BillingId = '#url.billingid#'				 
				 </cfif>				 
				 <!---
				 AND    (B.BillingExpiration >= #str# or B.BillingExpiration is NULL)				
				 --->
				 AND     BD.ServiceItem       = '#url.serviceitem#'
				 AND     BD.ServiceItemUnit   = '#unit#'	
				 ORDER BY B.BillingEffective DESC								
			</cfquery>	
						
			<cfset Reference = unitused.reference>	
									
			<cfparam name="ServiceEnableSetDefault" default="0">	
											
			<cfif UnitUsed.recordcount eq "1">	 						
			     <cfset selected = "1">		 
			<cfelseif ServiceEnableSetDefault eq "1" and 
			        (url.billingid eq "00000000-0000-0000-0000-000000000000" or url.billingid eq "")>			
			     <cfset selected = "1">					  		
			<cfelseif url.serviceReference eq "" and 
			         Rate.enableSetDefault eq "1" 
					 and (url.billingid eq "00000000-0000-0000-0000-000000000000" or url.billingid eq "")>			
			     <cfset selected = "1">					 		 
			</cfif>	 		
				
	<cfelse>
		
			<cfquery name="UnitUsed" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT      R.*, 
							0 as QuantityCost,
				            M.Frequency, 
						    M.BillingMode, 
							M.enableSetDefault,
						    M.CostId
				FROM        RequestLine R INNER JOIN ServiceitemUnitMission M  ON R.CostId = M.CostId
				<cfif url.requestid eq "">
					WHERE   1 = 0 
				<cfelse>					
					WHERE   R.RequestId       = '#url.requestid#'						
					AND     R.ServiceItem     = '#url.serviceitem#'
					AND     R.ServiceItemUnit = '#unit#'	
				</cfif>								
			</cfquery>	
						
			<cfset Reference = "">	

			<cfif UnitUsed.recordcount eq "1">	 				
			     <cfset selected = "1">		  				 
			<cfelseif requestid eq "" and UnitUsed.enableSetDefault eq "1">			
			     <cfset selected = "1">						 
			</cfif>	 	
					
	</cfif>	
		
	<cfset cl     = "regular labelmedium2 fixlengthlist">
	<cfset clline = "regular">
						
	<cfif selected eq "0" and url.parent eq "regular">			
		 <cfset cl = "hide">
	</cfif>		
	
	<cfif selected eq "0">				
		 <cfset clline = "hide">
	</cfif>		
					
	<tr id="box_#url.parent#" class="#cl#" style="height:20px;padding-left:4px">	
					
		<input type="hidden" name="#unitclass#_costid_#currentrow#" id="#unitclass#_costid_#currentrow#" value="#CostId#">					
	
		<cfif url.parent neq "">
						
			<td style="padding-left:16px;padding-right:6px;width:2%">																
			
				<input type    = "checkbox" 
				       name    = "#unitclass#_unit_#currentrow#"
                       id      = "#unitclass#_unit_#currentrow#" 
					   class   = "radiol provision enterastab"
					   style   = "color:yellow"
					   onkeydown="if (event.keyCode==13) {event.keyCode=9; return event.keyCode}"
					   onclick = "selectunit('#unitclass#','#currentrow#',document.getElementById('#unitclass#_UnitQuantity_#currentrow#').value,document.getElementById('#unitclass#_StandardCost_#currentrow#').value,this.checked)"
					   value   = "#Unit#" <cfif selected eq "1">checked</cfif> <cfif url.accessmode eq "view">disabled</cfif>>			
					
			</td>
		
		<cfelse>
		
			<td style="width:2%">				
																							
				<input type    = "checkbox" 
				       name    = "#unitclass#_unit_#currentrow#" 
					   id      = "#unitclass#_unit_#currentrow#"
					   class   = "radiol provision enterastab"
					   style   = "color:yellow"
					   onkeydown="if (event.keyCode==13) {event.keyCode=9; return event.keyCode}"
					   onclick = "selectunit('#unitclass#','#currentrow#',document.getElementById('#unitclass#_UnitQuantity_#currentrow#').value,document.getElementById('#unitclass#_StandardCost_#currentrow#').value,this.checked)"
					   value   = "#Unit#" <cfif selected eq "1">checked</cfif> <cfif url.accessmode eq "view">disabled</cfif>>		
										   
						
			</td>
		
		</cfif>
				
		<cfif ItemWarehouse neq "">
				
			<td style="font-size:13px;height:25px;min-width:240px" class="labelmedium fixlength">
			<a href="javascript:item('#itemwarehouse#','','#url.mission#')">#UnitDescription#</a></td>	
		
		<cfelse>
				
			<td style="font-size:13px;height:25px;;min-width:240px" class="labelmedium fixlength">#UnitDescription#</td>	
		
		</cfif>
				
		<td class="labelit #clline#" style="font-size:14px" id="freq_#unitclass#_#currentrow#"><cfif Rate.Frequency neq "Once">#Rate.Frequency#</cfif></td>
				
		<cfif UnitUsed.recordcount gte "1">				
		   <cfset qt = unitused.quantity>
		<cfelse>					
		   <cfset qt = "1">
		</cfif>   
		
		<cfif UnitUsed.recordcount gte "1">				
		   <cfset stock = unitused.quantitycost>
		<cfelse>					
		   <cfset stock = "0">
		</cfif>   
									
		<td style="padding-left:2px;font-size:14px;" align="right" class="#clline#" id="qty_#unitclass#_#currentrow#">
				
			<table align="right">
			<tr>
						
			<cfif ItemWarehouse neq "" and UnitDetail.EnableUsageEntry eq 1>
			
				<td style="padding-right:3px">
			
				<cfif url.accessmode eq "edit">
				
					<cfif Rate.enableEditQuantity eq "1">
					
						<table><tr>					
						<td>																																											
						<input type="text" 
						    style="width:25px;text-align:center;border-top:0px;border-bottom:0px" 
							name="#unitclass#_UnitQuantityStock_#currentrow#" 
		                    id="#unitclass#_UnitQuantityStock_#currentrow#"
							onkeydown="if (event.keyCode==13) {event.keyCode=9; return event.keyCode}"							
							value="#stock#" 
							class="regularxl enterastab">							
						</td><td style="padding-left:3px;padding-right:3px"><cf_inputInteger id="#unitclass#_UnitQuantityStock_#currentrow#" height="9" width="16"></td>				
						</tr>
						</table>	
												
					<cfelse>
					
						<!--- value is always 1 --->
						<input type="hidden" name="#unitclass#_UnitQuantityStock_#currentrow#" id="#unitclass#_UnitQuantityStock_#currentrow#" value="0">				
					
					</cfif>	
										
				<cfelse>
							
					#stock# :
				
				</cfif>	
				
				</td>
			
			</cfif>
			
			<cfif ItemWarehouse neq "" and UnitDetail.EnableUsageEntry eq 0>
			
				<!--- value is always 1 --->
				<input type="hidden" name="#unitclass#_QuantityIsStock_#currentrow#" id="#unitclass#_QuantityIsStock_#currentrow#" value="1">
				
			<cfelse>
			
				<!--- value is always 1 --->
				<input type="hidden" name="#unitclass#_QuantityIsStock_#currentrow#" id="#unitclass#_QuantityIsStock_#currentrow#" value="0">
			
			</cfif>
						
			<td style="padding-left:1px;" align="right">			
									
			<cfif url.accessmode eq "edit">
										
				<cfif Rate.enableEditQuantity eq "1">				  
				
					<table>
					<tr>					
						<td>																								
						<input type="text" 
						    style="width:25px;text-align:center;border-top:0px;border-bottom:0px" 
							name="#unitclass#_UnitQuantity_#currentrow#" 
		                    id="#unitclass#_UnitQuantity_#currentrow#"
							onkeydown="if (event.keyCode==13) {event.keyCode=9; return event.keyCode}"
							onchange="calc('#unitclass#','#currentrow#',this.value,document.getElementById('#unitclass#_StandardCost_#currentrow#').value)"
							value="#qt#" 
							class="regularxl enterastab">														
						</td><td style="padding-left:3px;padding-right:3px"><cf_inputInteger id="#unitclass#_UnitQuantity_#currentrow#" height="9" width="16"></td>		
					
					</tr>					
					</table>					
					
				<cfelse>
				
					<!--- value is always 1 --->
					<input type="hidden" name="#unitclass#_UnitQuantity_#currentrow#" id="#unitclass#_UnitQuantity_#currentrow#" value="1">				
				
				</cfif>	
				
			<cfelse>
						
				#qt#
			
			</cfif>	
			
			</td>			
			</tr>			
			</table>							
			
		</td>
						
		<cfif url.context eq "portal">
			<cfset cllineu = "hide">
		<cfelse>
			<cfset cllineu = clline>
		</cfif>	
				
		<td id="curr_#unitclass#_#currentrow#" class="#cllineu#">#Rate.currency#</font></td>
		
		<!--- cost price --->
		
		<td align="right" style="font-size:14px" id="cost_#unitclass#_#currentrow#" class="#cllineu#">
			 
		     <cfif Rate.standardcost eq "0">
			    n/a
			 <cfelse>
				<cfset qt = "#numberformat(Rate.standardcost,',.__')#">	
				#qt#
			 </cfif>	
			 
		</td>
		
		<cfif UnitUsed.recordcount gte "1">						  
		   <cfset qt = "#numberformat(unitused.rate,',.__')#">
		<cfelseif Rate.Price gt "0">						  
		   <cfset qt = "#numberformat(Rate.price,',.__')#">
		<cfelse>
		   <cfset qt = "#numberformat(Rate.standardcost,',.__')#">
		</cfif>   
				
		<!--- actual price --->
					
		<td align="right" style="font-size:14px" class="#cllineu#" id="price_#unitclass#_#currentrow#">
			
			<font face="Calibri" size="2">			  				
			<cfif url.accessmode eq "edit">
			
				<cfif Rate.enableEditRate eq "0">			
									
				<input type="hidden" 
					    style="width:70px;text-align:right;padding-right:2px;border-top:0px;border-bottom:0px" 
						name="#unitclass#_StandardCost_#currentrow#" 
	                    id="#unitclass#_StandardCost_#currentrow#"
						onchange="calc('#unitclass#','#currentrow#',document.getElementById('#unitclass#_UnitQuantity_#currentrow#').value,this.value)"
						value="#qt#" 
						class="regularxl enterastab">													
						
					#qt#	
				
				<cfelse>		
																		
				
				<input type="text" 
					    style="width:70px;text-align:right;padding-right:2px;border-top:0px;border-bottom:0px" 
						name="#unitclass#_StandardCost_#currentrow#" 
	                    id="#unitclass#_StandardCost_#currentrow#"
						onchange="calc('#unitclass#','#currentrow#',document.getElementById('#unitclass#_UnitQuantity_#currentrow#').value,this.value)"
						value="#qt#" 
						class="regularxl enterastab">		
												
				</cfif>						
								
			<cfelse>
			
				#qt#
			
			</cfif>				
			
			</font>
													
		</td>		
								
		<td align="right" style="font-size:14px;padding-top:0px" class="#cllineu#" id="charge_#unitclass#_#currentrow#">
												
			<cfif url.accessmode eq "edit">
			
				<cfif Rate.enableEditCharged eq "1">
							
					<select name="#unitclass#_charged_#currentrow#" id="#unitclass#_charged_#currentrow#" class="regularxl enterastab" style="border-top:0px;border-bottom:0px">
					    <cfif url.mode eq "workorder">
						<option value="0" <cfif unitused.charged eq "0">selected</cfif>><cf_tl id="No"></option>
						</cfif>
						<option value="1" <cfif unitused.charged eq "1" or unitused.charged eq "">selected</cfif>><cf_tl id="Customer"></option>
						<option value="2" <cfif unitused.charged eq "2">selected</cfif>><cf_tl id="Person"></option>
					</select>				
				
				<cfelse>
					
					<cf_tl id="Customer">					
					<input type="hidden" width="20" readonly name="#UnitClass#_charged_#currentrow#" id="#UnitClass#_charged_#currentrow#" value="1" class="regularh">
						
				</cfif>			
			
			<cfelse>
			
				<cfif unitused.charged eq "0"><cf_tl id="No"></cfif>
				<cfif unitused.charged eq "1"><cf_tl id="Customer"></cfif>
				<cfif unitused.charged eq "2"><cf_tl id="Person"></cfif>
			
			</cfif>
		
		</td>							
		
		<td align="right" style="font-size:14px">
				  			
			<table>
			<tr class="labelmedium2">
			<td id="total_#unitclass#_#currentrow#" class="#clline#" style="font-size:14px;padding-left:2px">
					
			<cfif UnitUsed.recordcount gte "1">
			   <cf_precision number="#priceprecision#" amount="#unitused.amount#">		
			   #numberformat("#unitused.amount#","#pformat#")#			
			<cfelseif Parent.enableEditQuantity eq "0">		
			   <cf_precision number="#priceprecision#" amount="#Rate.standardcost#">					  
			   #numberformat("#Rate.standardcost#","#pformat#")#	
			<cfelse>			
			    <cf_precision number="#priceprecision#" amount="0">					
			</cfif>	
			
			</td></tr>
			</table>
			
		</td>	
		
	</tr>	
	
	<cfif selected eq "0">		
		<cfset ref = "hide">
    <cfelse>
		<cfset ref = "regular">
	</cfif>	
	
	<cfif entrymode eq "1">
	
	    <!--- 	
			
		<tr id="reference_#unitclass#_#currentrow#" class="#ref#">
		  <td></td>
		  <td colspan="7" style="padding-left:5px;padding:2px;padding-right:0px">
		    <table width="100%" cellspacing="0" cellpadding="0">
			<tr>			  
			   <td width="99%">
			   			   
			   <!---			   
			   <textarea style="background-color:f4f4f4;width:100%;font-size:13px;height:22;border-left:1px solid silver;border-right:1px solid silver;padding:2px" 
			      name= "#UnitClass#_reference_#currentrow#" 
				  id= "#UnitClass#_reference_#currentrow#" 
				  class="regular" 
				  maxlength="200" 
				  onkeyup="return ismaxlength(this)">#Reference#</textarea>			
				  --->
			   </td>
		    </tr>
		    </table>
		  </td>
		</tr>		
		
		--->
	
	</cfif>
	
	<cfif unitspecification neq "">
				
		<tr style="border-top:1px solid silver;background-color:ffffcf">
			<td></td>
			<td colspan="8" style="padding-top:3px;padding-bottom:3px;padding-left:30px" class="labelmedium"><font size="2" color="black">#unitspecification#</font></td>				
		</tr>				
		
	</cfif>	
		
	<cfparam name="embed" default="0">
	
	<cfif currentrow neq recordcount>		
		<tr><td colspan="9" class="line"></td></tr>		
	</cfif>
		
</cfoutput>	

