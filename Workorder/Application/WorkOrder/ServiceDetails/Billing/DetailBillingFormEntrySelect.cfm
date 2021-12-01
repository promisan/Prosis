 
<cfoutput>


<cfquery name="getUnitClass" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   #CLIENT.lanPrefix#Ref_UnitClass 
		WHERE  Code = '#unitclass#'
</cfquery>		

<cfquery name="UnitDetail" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		 SELECT   R.Unit,
		          R.UnitClass, 
		          R.ListingOrder, 
				  
				  <cfif url.serviceReference neq "">
					
						 
					(    SELECT EnableSetDefault
					     FROM   ServiceItemUnitWorkorderService
						 WHERE  ServiceItem   = '#url.serviceitem#'
						 AND    ServiceDomain = '#url.servicedomain#'
						 AND    Reference     = '#url.serviceReference#'
						 AND    Mission       = '#url.mission#'
						 AND    Unit = R.Unit) as ServiceEnableSetDefault,		
						 
					<cfelse>
										
					0 as ServiceEnableSetDefault,	 
						 
					</cfif>	 	 	
				  
				  R.UnitDescription,
				  R.UnitSpecification,
				  R.PricePrecision
				
	     FROM     #CLIENT.lanPrefix#ServiceItemUnit R
		 WHERE    R.ServiceItem  = '#url.serviceitem#'		
		 <cfif url.billingid eq "00000000-0000-0000-0000-000000000000" or url.billingid eq "" or url.operational eq "1">			 
		 AND      R.Operational = 1
		 <cfelseif url.operational eq "1" or url.billingid neq "">	
		 
		
		 							 
		  AND    (
		          R.Operational = 1 OR R.Unit IN (SELECT DISTINCT BWD.ServiceItemUnit 
				                                  FROM   WorkorderLineBilling BW, WorkorderLineBillingDetail BWD
												  WHERE  BW.workorderid      = BWD.workorderid
												  AND    BW.workorderline    = BWD.workorderline
												  AND    BW.BillingEffective = BWD.BillingEffective
												  AND    BW.BillingId        = '#url.billingid#')
				 )			
				 
				 
				 					  
		 </cfif>
		 

				 	
		 AND    R.UnitClass = '#unitclass#'
		
		 		 
		 <!--- filter only on units that have a service class defined --->
		 <cfif url.servicedomainclass neq "">			
			 
			 AND     (R.ServiceDomainClass is NULL or (R.ServiceDomain = '#url.servicedomain#' AND R.ServiceDomainClass = '#url.servicedomainclass#'))
			 
		 </cfif>	
		 
				 		 
		 AND      (
		           R.UnitParent is NULL
		                or 
						(
						R.UnitParent NOT IN (SELECT Code FROM Ref_UnitClass WHERE Code = R.UnitParent)
						and 
						R.UnitParent NOT IN (SELECT Unit FROM ServiceItemUnit WHERE ServiceItem = '#url.serviceitem#')	
						)					
				  )
				  
				  				  
		 <!--- has indeed a potential rate assigned --->		  
				 
		 AND      Unit IN (
		 				   SELECT ServiceItemUnit 
		                   FROM   ServiceItemUnitMission M
		 				   WHERE  M.Mission       = '#url.mission#'
						   AND    M.ServiceItem   = '#url.serviceitem#'
						   AND    M.DateEffective <= #str# 
						   AND    (M.DateExpiration >= #str# or M.DateExpiration is NULL)
						   AND    M.BillingMode   != 'Supply'
						  )							  
					 			 
		 ORDER BY R.ListingOrder, 
				  R.UnitDescription		
				 
				  
</cfquery>	

<!--- ------------------------------------------------------------------------------------ --->
<!--- retrieve the correct rate card id for each of the topics to be shown in the dropdown --->
<!--- ------------------------------------------------------------------------------------ --->

<!--- disabled 16/9/2016 for Karin, as some units did not show 		
					
<cfif QuotedValueList(UnitDetail.Unit) eq "">
	
	    <cfoutput>
			
	    <tr><td style="padding:10px" colspan="8" align="center" class="labelmedium"><font color="FF0000">
		
		<cf_tl id="Problem">, <cf_tl id="no valid service provision units found for effective date"> #dateformat(str,CLIENT.DateFormatShow)#</font></td></tr>
		</cfoutput>
			
<cfelse>	

--->
						 		
		<cfif url.mode eq "workorder">				
									
				<cfquery name="UnitUsed" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					 SELECT   TOP 1 *
					 FROM     WorkOrderLineBilling B,
					          WorkOrderLineBillingDetail BD				
					 WHERE    B.WorkOrderid      = BD.WorkOrderid
					 AND      B.WorkOrderLine    = BD.WorkOrderLine
					 AND      B.BillingEffective = BD.BillingEffective	
					 AND      B.WorkOrderId      = '#url.workorderid#'
					 AND      B.WorkOrderLine    = '#url.workorderline#'
					 
					 <cfif url.billingid neq "00000000-0000-0000-0000-000000000000" and url.billingid neq "">	
					 AND      B.BillingId        = '#url.billingid#'
					 <cfelse>
					 AND      BD.BillingEffective = #str#
					 </cfif>					
					 AND      BD.ServiceItem     = '#url.serviceitem#'
					 <cfif UnitDetail.Unit eq "">
					 AND    1=0
					 <cfelse>
					 AND      BD.ServiceItemUnit IN (#QuotedValueList(UnitDetail.Unit)#)								
					 </cfif>
					 ORDER BY B.BillingEffective DESC
				</cfquery>		
											
		<cfelse>
			
				<cfquery name="UnitUsed" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					 SELECT  R.*, M.Frequency, M.BillingMode
					 FROM    RequestLine R INNER JOIN ServiceitemUnitMission M  ON R.CostId = M.CostId
					<cfif url.requestid eq "">
					 WHERE   1 = 0 
					<cfelse>					
					 WHERE   R.RequestId       = '#url.requestid#'						
					 AND     R.ServiceItem     = '#url.serviceitem#'
					 AND     R.ServiceItemUnit IN (#QuotedValueList(UnitDetail.Unit)#)		
					</cfif>								
				</cfquery>							
			
		</cfif>	
	
	<!--- initial value --->
	<cfif unitUsed.recordcount eq 1>	
		<cfset sel = UnitUsed.ServiceItemUnit>
		<cfset cl  = "label">	
	<cfelse>	
	    <cfset sel = UnitDetail.Unit>		
	    <cfset cl  = "hide">			
	</cfif>		
	
	<!--- initial value --->	
	<cfquery name="UnitSelect"         
        dbtype="query">
			SELECT   * 
			FROM     UnitDetail
			WHERE    Unit = '#sel#'			
	</cfquery>		
	 	
	<!--- determine the initial rate --->
			
	<cfinvoke component = "Service.Process.WorkOrder.Provisioning"  
	   method           = "getRate" 
	   Mission          = "#url.mission#"
	   OrgUnitOwner     = "#url.orgunitowner#"
	   ServiceItem      = "#url.serviceitem#"
	   Unit             = "#sel#"
	   SelectionDate    = "#dateformat(str,client.dateformatshow)#"   
	   returnvariable   = "Rate">	
	
		   
	<cfif UnitSelect.ServiceEnableSetDefault eq "1" and 
	        unitUsed.recordcount eq "0" and  
	        (url.billingid eq "00000000-0000-0000-0000-000000000000" or url.billingid eq "")>	
			
		  <!--- we enforce the initial value is shown as nothing was ever selected here, once something is selected, this is dropped --->
		  <cfset cl  = "label">				  				
	   	   	
	<cfelseif url.serviceReference eq ""   and
	          unitUsed.recordcount eq "0"  and 
			  Rate.enableSetDefault eq "1" and 
	        (url.billingid eq "00000000-0000-0000-0000-000000000000" or url.billingid eq "")>
			
	    <!--- we enforce the initial value is shown as nothing was ever selected here, once something is selected, this is dropped --->
		<cfset cl  = "label">		
		
	</cfif> 	
		
	<cfif UnitUsed.recordcount gte "1">				
	     <cfset qt = unitused.quantity>
	<cfelse>					
		 <cfset qt = "1">
	</cfif>		
		
	<tr style="border-top:1px solid silver" class="fixlengthlist">
	
		<td style="padding-left:3px">	
														
			<input type="checkbox" 
				   name="#UnitClass#_unit_0" 
	               id="#UnitClass#_unit_0"
				   style="background-color:yellow"
				   class="enterastab radiol"
				   onkeydown="if (event.keyCode==13) {event.keyCode=9; return event.keyCode}"
				   onclick="toggledetail('#unitClass#',this.checked,'#getUnitClass.entrymode#')"
				   value="1" <cfif UnitUsed.recordcount gte "1" or cl eq "label">checked</cfif> <cfif url.accessmode eq "view">disabled</cfif>>			
				
		</td>		   
				   
		<td style="padding-left:8px;padding-top:2px;padding-bottom:2px;cursor:pointer" 
		    class="labelmedium" colspan="8"
			onclick="document.getElementById('#UnitClass#_unit_0').click()">#ClassDescription#</td>
		
	</tr>
			
	<tr class="fixlengthlist">	
		
	<td width="32"></td>	  

	<td id="#UnitClass#_unit" style="padding-left:20px" class="#cl# labelit fixlength">			
	
		<cfif url.accessmode eq "view">
			
			<cfloop query="UnitDetail">
				<cfif sel eq unit>#UnitDescription#</cfif>
			</cfloop>
			
		<cfelse>		
				
		    <cfif getUnitClass.entrymode eq "0">	
						
			    <!--- no ratets for itself only for the children --->
																						
			    <select name  = "#UnitClass#_costid_0" 
				   id         = "#UnitClass#_costid_0"
				   class      = "provision regularxl enterastab" 
				   style      = "width:300;border-radius:3px" 
				   onkeydown="if (event.keyCode==13) {event.keyCode=9; return event.keyCode}"
				   onchange   = "showfeature('#unitclass#',this.value,'#url.workorderid#','#url.workorderline#','#url.requestid#','#url.mode#','#url.billingid#','#url.orgunitowner#','#url.date#')">			   
				   <cfloop query="UnitDetail">
				   
				    <!--- determine the correct rate card to be used --->
					
					<cfinvoke component = "Service.Process.WorkOrder.Provisioning"  
					   method           = "getRate" 
					   Mission          = "#url.mission#"
					   OrgUnitOwner     = "#url.orgunitowner#"
					   ServiceItem      = "#url.serviceitem#"
					   Unit             = "#Unit#"
					   SelectionDate    = "#dateformat(str,client.dateformatshow)#"   
					   returnvariable   = "getRate">	   
				   				   				   
					    <!--- map on the unit and then used the cost id for deeper --->
						<option value="#getRate.CostId#" <cfif sel eq unit>selected</cfif>>#UnitDescription#</option>
						
				   </cfloop>	
				   		
				</select>
			
			<cfelse>

				<cfset qSelect=QueryNew("CostId,UnitDescription","varchar,varchar")>
				<cfset vSelect = "">
				<cfloop query="UnitDetail">
						<cfinvoke component = "Service.Process.WorkOrder.Provisioning"
								method           = "getRate"
								Mission          = "#url.mission#"
								OrgUnitOwner     = "#url.orgunitowner#"
								ServiceItem      = "#url.serviceitem#"
								Unit             = "#Unit#"
								SelectionDate    = "#dateformat(str,client.dateformatshow)#"
								returnvariable   = "getRate">
					<!--- map on the unit and then used the cost id for deeper --->
					<cfset vRow=StructNew()>
					<cfset vRow={CostId=getRate.CostId,UnitDescription=UnitDescription}>
					<cfset QueryAddRow(qSelect,vRow)>
					<cfif sel eq unit>
						<cfset vSelect = getRate.CostId>
					</cfif>
				</cfloop>
				
				<cf_uiselect name  = "#UnitClass#_costid_0"
						id         = "#UnitClass#_costid_0"
						style      = "width:180px;border-radius:3px"
						query 	   = "#qSelect#"
						value      = "CostId"
						selected   = "#vSelect#"
						display    = "UnitDescription"
						filter     = "contains"
						class      = "provision regularxl enterastab"
						onchange   = "unitshow('#unitclass#',this.value(),'#qt#');showfeature('#unitclass#',this.value(),'#url.workorderid#','#url.workorderline#','#url.requestid#','#url.mode#','#url.billingid#','#url.orgunitowner#','#url.date#')">
						
				</cf_uiselect>
			
			</cfif>
			
		</cfif>   
					
	</td>		
	
	<cfif getUnitClass.entrymode eq "0">		
	    <cfset cl = "hide">			
	</cfif>
			
	<td id="#UnitClass#_frequency" class="labelit #cl#">
	
		<cf_space spaces="20">
		
	    <cfif UnitUsed.recordcount gte "1">				
		     <cfset fq = unitused.frequency>
		<cfelse>					
		     <cfset fq = rate.frequency>
		</cfif>   
		
		<cfquery name="Frequency" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Ref_Frequency 
				WHERE  Code = '#fq#'
	    </cfquery>
		
		<cfif fq neq "Once">#fq#</cfif>
		
	</td>			
	
	<td id="#UnitClass#_quantity" align="right" style="width:65px;min-width:65px;" class="labelit #cl#">
	
		<cfif UnitUsed.recordcount gte "1">				
		
		   <cfset qt = unitused.quantity>	
		   
		   <!--- save guuard --->
		   <cfif qt eq "0">
			   <cfset qt = "1">
		   </cfif>		   
		   	  
		<cfelse>	
				
		   <cfset qt = "1">
		   
		</cfif>   
	
		<cfif url.accessmode eq "edit">
		
			<table width="100%">
			
			<cfif rate.enableEditQuantity eq "1">
			      <cfset cla = "regular">
			<cfelse>
			      <cfset cla = "hide">
			</cfif> 
			
			<tr>
			<td id="#UnitClass#_quantity_box" align="right" class="#cla#">
			
			    <table>
				<tr>
				<td>
												   		
				<input type   = "text" 
				    style     = "width:25px;text-align:center" 
					name      = "#UnitClass#_unitquantity_0"
                    id        = "#UnitClass#_unitquantity_0" 
					onkeydown = "if (event.keyCode==13) {event.keyCode=9; return event.keyCode}"
					onchange  = "calc('#unitclass#','0',this.value,document.getElementById('#UnitClass#_standardcost_0').value)"
					value     = "#qt#" 
					class     = "regularxl enterastab">
										
					</td>
					
					<td style="padding-left:3px;padding-right:3px">								
						<cf_inputInteger id="#UnitClass#_unitquantity_0" height="10" width="16">							
			        </td>
					
      			</tr>
			    </table>
			
			 </td>
      			</tr>
			</table>
			
		<cfelse>
		
			#qt#
		
		</cfif>	
		
	</td>	
	
	<cfif url.context eq "portal">
		   <cfset clu = "hide">
	<cfelse>
		   <cfset clu = cl>
	</cfif>	
	
	<td id="#UnitClass#_currency" class="labelit #clu#" style="width:60px;min-width:60px;">
	
		<cfif UnitUsed.recordcount gte "1">				
		   <cfset cu = unitused.currency>
		<cfelse>					
		   <cfset cu = rate.currency>
		</cfif>   						
		#cu#
	
	</td>
			
	<td id="#UnitClass#_stdprice" align="right" style="width:100px;min-width:100px;padding-top:1px" class="labelit #clu#">
			  
		<cfif UnitUsed.recordcount gte "1">	
		
			<!--- no value --->
		
		<cfelse>
							
			<cfif Rate.standardcost eq "0">
				 n/a
			<cfelse>			
				 <cfset qt = "#numberformat(Rate.StandardCost,',.__')#">
		 		 #qt#
			</cfif>	 
			
		</cfif>	
	
	</td>	
		
	<td id="#UnitClass#_price" style="width:100px;min-width:100px;" class="#clu#" align="right">
		
	    <table cellspacing="0" cellpadding="0">
		<tr>
		<td class="labelmedium">
		
		<cfif UnitUsed.recordcount gte "1">			
					  
		   <cfset qt = "#numberformat(unitused.rate,',.__')#">		   
		   
		<cfelseif Rate.Price gt "0">
								  
		   <cfset qt = "0.00">		
		   <cfset qt = "#numberformat(Rate.price,',.__')#">  
		   
		<cfelse>	
				
		   <!--- retrieve default value --->		   					  
		   <cfset qt = "0.00">				  	  		   			   
		   <cfset qt = "#numberformat(Rate.StandardCost,',.__')#">
		   		   
		</cfif>   			
			
		<cfif url.accessmode eq "edit">
																				
			<input type="text" <cfif Rate.enableEditRate eq "0">readonly</cfif>
			    style="width:70px;text-align:right" 				
				id="#UnitClass#_standardcost_0" 
				name="#UnitClass#_standardcost_0" 
				onkeydown="if (event.keyCode==13) {event.keyCode=9; return event.keyCode}"
				onchange="calc('#unitclass#','0',document.getElementById('#UnitClass#_unitquantity_0').value,this.value)"
				value="#qt#" 
				class="regularxl enterastab">				
							
		<cfelse>
		
			#qt#
		
		</cfif>	
		
		</td>
		</tr>
		</table>
												
	</td>	
	
	<td id="#UnitClass#_charged" style="width:100px;min-width:100px;" align="right" class="labelit #clu#">
	
	<cfif url.accessmode eq "edit">	
		
		<cfif rate.enableEditCharged eq "1">
						
		<select name="#UnitClass#_charged_0" id="#UnitClass#_charged_0" class="regularxl enterastab">
		    <cfif url.mode eq "workorder">
			<option value="0" <cfif unitused.charged eq "0">selected</cfif>><cf_tl id="No"></option>
			</cfif>
			<option value="1" <cfif unitused.charged eq "1" or unitused.charged eq "">selected</cfif>><cf_tl id="Customer"></option>
			<option value="2" <cfif unitused.charged eq "2">selected</cfif>><cf_tl id="Person"></option>
		</select>				
		
		<cfelse>
		
		    <cf_tl id="Customer">
			<input type="hidden" width="20" readonly name="#UnitClass#_charged_0" id="#UnitClass#_charged_0" value="1" class="regularh">
				
		</cfif>			
	
	<cfelse>
	
		<cfif unitused.charged eq "0"><cf_tl id="No"></cfif>
		<cfif unitused.charged eq "1"><cf_tl id="Customer"></cfif>
		<cfif unitused.charged eq "2"><cf_tl id="Person"></cfif>
	
	</cfif>
	
	</td>	
		
	<td align="right" style="width:100px;min-width:100px;" id="#UnitClass#_total" class="#clu#">
		
		<table>
			<tr>
			
			<td id="total_#UnitClass#_0" class="labelmedium" style="font-size:14px" align="right">
																											
			<cfif UnitUsed.recordcount gte "1" and unitused.amount neq "">					
			    <cf_precision number="#unitdetail.priceprecision#" amount="#unitused.amount#">	
				#numberformat("#unitused.amount#","#pformat#")#					
			<cfelse>				
			    <cf_precision number="#unitdetail.priceprecision#" amount="#Rate.StandardCost#">		
				#numberformat("#rate.StandardCost#","#pformat#")#						  	
			</cfif>	
									
			</td>
			</tr>
		</table>
	
	</td>	
	
			
</tr>

<tr class="#cl#" id="#UnitClass#_specification" style="height:1px;padding:2px">
   <td></td>
   <td colspan="8" style="height:0px;padding-left:25px;padding-top:2px;padding-bottom:2px;color:gray" id="#UnitClass#_specification_content" class="labelmedium">  
   <cfif unitselect.unitspecification neq "">
   #unitselect.unitspecification#
   </cfif>
   </td>				
</tr>	


<!---
</cfif>	
--->

</cfoutput> 
