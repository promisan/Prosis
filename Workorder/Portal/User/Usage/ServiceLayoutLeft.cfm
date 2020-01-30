
<!--- Burned this to make the Portal Work without being Mission Sensitive in the Portal Configuration, otherwise it would receive url.mission eq "" --->
<cfset url.mission = "OICT">

<cfparam name="client.selectedmonth" default="">
<cfset client.selectedmonth = "0">

<table cellspacing="0" border="0" width="100%">
  				 			 									
	<cfquery name="List" 
	datasource="AppsWorkOrder"
     username="#SESSION.login#"
     password="#SESSION.dbpw#">							
	  SELECT     TOP 1000 W.Reference as OrderNo,
	             WL.Reference, 
				 C.Description as DescriptionClass,
				 D.DisplayFormat,
	             S.Description, 	
				 CU.CustomerName, 								 			
				 WL.DateEffective, 
				 WL.DateExpiration, 								
				 WL.WorkOrderId, 
				 WL.WorkOrderLine,
				 WL.WorkorderLineId,
				 WL.ServiceDomainClass 
	  FROM       ServiceItemClass C INNER JOIN
	             ServiceItem S ON C.Code = S.ServiceClass INNER JOIN
				 Ref_ServiceItemDomain D ON D.Code = S.ServiceDomain INNER JOIN
                 WorkOrder W ON S.Code = W.ServiceItem INNER JOIN
                 WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
				 ServiceItemMission M ON M.ServiceItem = S.Code AND M.Mission = W.Mission INNER JOIN 
				 Customer CU ON W.CustomerId= CU.CustomerId
      WHERE      WL.PersonNo = '#client.personno#' AND 
	  			 WL.Operational = '1' AND
				 S.Operational = 1 AND
				 S.Selfservice = 1 AND
				 ((WL.DateExpiration is NULL) or (DateExpiration > getDate()) or (M.SettingShowExpiredLines = 1 AND DateExpiration > getDate()-M.SettingDaysExpiration)) AND
				 W.Mission = '#url.mission#'
	  ORDER BY   C.Description, S.Description, WL.ServiceDomainClass, WL.Reference, WL.DateEffective DESC, WL.DateExpiration DESC						  
	</cfquery>	
	
	<!--- 2015-07-23. Safeguard. Insert missing Charge records to make sure all transactions are tagged at least as business  --->
	 <cfquery name="Safeguard" 
	datasource="AppsWorkOrder"
     username="#SESSION.login#"
     password="#SESSION.dbpw#">	
	 
		INSERT INTO WorkOrderLineDetailCharge (
				ChargeId, 
				TransactionId, 
				DetailReference, 
				WorkOrderId, 
				WorkOrderLine, 
				ServiceItem, 
				ServiceItemUnit, 
				Reference, 
				TransactionDate,
				Charged,
				OfficerUserId, 
				OfficerLastName, 
				OfficerFirstName, 
				Created		
			)
		

		SELECT 	NEWID() as ChargeId, 
				D.TransactionId, 
				NULL, 
				D.WorkOrderId, 
				D.WorkOrderLine, 
				D.ServiceItem, 
				D.ServiceItemUnit, 
				D.Reference, 
				D.TransactionDate,
				'1' AS Charged,
				D.OfficerUserId, 
				D.OfficerLastName, 
				D.OfficerFirstName, 
				D.Created
		FROM vwWorkOrderLine L
		INNER JOIN WorkOrderLineDetail D ON D.WorkOrderId=L.WorkOrderId AND D.WorkOrderLine=L.WorkOrderLine
		WHERE L.PersonNo='#client.personno#'
		AND L.Operational = 1
		AND D.Source != 'Manual' 
		AND NOT EXISTS (
			SELECT 1
			FROM WorkOrderLineDetailCharge C 
						WHERE  D.WorkOrderId     = C.WorkOrderId 
						AND D.WorkOrderLine   = C.WorkOrderLine 
						AND D.ServiceItem     = C.ServiceItem 
						AND D.ServiceItemUnit = C.ServiceItemUnit 
						AND D.Reference       = C.Reference 
						AND D.TransactionDate = C.TransactionDate )
								 
	</cfquery> 
	
	 <tr>
		 <td style="padding:6px">
				
			 <select name="mode" id="mode" class="regularxl" style="font-size:25px;height:35px"
			  onchange="showservice(document.getElementById('selectlineid').value,this.value)">
				 <option value="usage">Usage</option>
				 <option value="provisioning">Plans</option>
			 </select>		
			 </td>
	 </tr>
	 
	<tr><td class="line"></td></tr> 
					
	<tr><td style="padding-left:4px;padding-right:4px;padding-top:8px">				
					
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table" navigationhover="#c4e1ff" navigationselected="#cccccc">
				   				
			<cfoutput query="List" group="DescriptionClass">
								
			<tr>
				<td colspan="2" style="padding:1px;" class="labellarge"><b>#DescriptionClass#</b></td>
			</tr>
									
			<cfoutput group="Description">
			
			<tr>
				<td colspan="2" style="padding:2px;" align="left" class="labelmedium">#Description#</td>
			</tr>
			
			<cfquery name="Subtotal" dbtype="query">
			  SELECT    *	 
			  FROM       List
			  WHERE      Description = '#Description#'
			  </cfquery>	
			
			<cfset cnt = 0>
			
				<cfoutput group="ServiceDomainClass">				

						<cfif ServiceDomainClass neq "">
							<tr>
								<td colspan="2" style="padding:2px;" align="leftmedium" class="labelit"><font color="gray">[#ServiceDomainClass#]</font></td>
							</tr>
						</cfif>
						
					<cfoutput>					
					
						<cfset cnt = cnt + 1>
									
					    <!--- click loads top calendar and center --->
						<tr style="cursor:pointer" class="navigation_row">
														 
							 <td width="4%">
							 
							 <!---
							 <cfif cnt lt subtotal.recordcount>
							    <img src="#SESSION.root#/images/joinbottom.gif" align="absmiddle" alt="" border="0">
							 <cfelse>
							    <img src="#SESSION.root#/images/join.gif" align="absmiddle" alt="" border="0">
							 </cfif>
							 --->
							 
							 </td>
							 														 
							 <td width="90%" class="navigation_action labelmedium" align="left"
							      onclick="showservice('#workorderlineid#',document.getElementById('mode').value)" 
								  style="height:17;color: ##4f4f4f; padding-left:20px;padding-top:0px; padding-bottom:0px">
							      <cf_stringtoformat value="#reference#" prefix="-" format="#DisplayFormat#">
							 	  <cfif DateExpiration neq "" and DateExpiration lt now() >
									  <font color="silver" title="Expired Service">#val#</font> <font size="1">[#CustomerName#]</font>
								  <cfelse>	
									#val# <font size="1">[#CustomerName#]</font>
								  </cfif>
							 </td>
							
							
						</tr>
										
					</cfoutput>	
				</cfoutput>
			</cfoutput>	
			
			<tr><td height="4"></td></tr>					
			
			</cfoutput>
			
			 <!--- save the value of the line id --->
			 <input type="hidden" name="selectlineid" id="selectlineid" value="">
											 
	    </table>

		</td>	
	</tr>
	
</table>

<cfset ajaxonload("doHighlight")>
	