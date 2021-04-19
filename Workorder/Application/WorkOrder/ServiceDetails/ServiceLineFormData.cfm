
<table width="100%" class="formpadding formspacing">

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrder
		WHERE   WorkorderId   = '#url.workorderid#'		
</cfquery>		

<cfquery name="Prior" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT     WL.OrgUnitImplementer, 
	           WL.PersonNo,
			   S.ServiceMode
	FROM       WorkOrderLine WL INNER JOIN
	           WorkOrder W ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
			   ServiceItem S ON W.ServiceItem = S.Code
	WHERE      W.CustomerId  = '#get.Customerid#' 
	AND        W.ServiceItem = '#get.ServiceItem#'	
	ORDER BY   WL.Created DESC								
</cfquery>	
	
<cfquery name="checkopen" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    RequestWorkOrder WO INNER JOIN
	            Request R ON WO.RequestId = R.RequestId
		WHERE   WorkorderId   = '#url.workorderid#'
		AND     WorkorderLine = '#url.workorderline#'			  
		AND     R.ActionStatus IN ('0', '1', '2')
</cfquery>		

<cfquery name="checkitem" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrderLineItem
		WHERE   WorkorderId   = '#url.workorderid#'
		AND     WorkorderLine = '#url.workorderline#'			  		
</cfquery>		
	
<cfoutput>
		
		<tr><td height="4"></td></tr>		
		
		<cfif item.servicemode eq "WorkOrder">
				
			<cfif url.mode eq "View">
			
				<tr><td width="20%" class="labelmedium2"><cfif domain.description neq "">#Domain.description#<cfelse><cf_tl id="Id"></cfif>: <font color="FF0000">*</font></td>
				    <td class="labelmedium2">#line.reference# <cfif line.description eq ""><font color="808080">[n/a]</font><cfelse>#line.Description#</cfif></td>
				</tr>						
			
			<cfelse>
			
				<tr>
				<td valign="top" style="padding-top:4px" width="20%" class="labelmedium2"><cfif domain.description neq "">#Domain.description#<cfelse><cf_tl id="Id"></cfif>: <font color="FF0000">*</font></td>
												
				<cfquery name="domainreference" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">						
					SELECT     *
					FROM       WorkOrderService
					WHERE      ServiceDomain = '#Item.ServiceDomain#'
					ORDER BY   Reference, Description
				 </cfquery>
				 
				 <td>
								 
					 <table cellspacing="0" cellpadding="0" class="navigation_table formspacing formpadding">
						 <cfloop query="domainreference">
						 	<tr class="labelmedium2" class="navigation_row">
							 <td><input type="radio" class="radiol enterastab" name="Reference" value="#Reference#" <cfif Line.reference eq "" and currentrow eq "1">checked<cfelseif Line.Reference eq Reference>checked</cfif>><td>
							 <td style="padding-left:4px">#Reference#</td>
							 <td style="padding-left:4px">#Description#</td>
							</tr>			 
						 </cfloop>
					 </table>					 	 
				 
				 </td>
				 </tr>
				 
				 <tr>
				  <td valign="top" style="padding-top:4px" width="20%" class="labelmedium"><cf_tl id="Status">:</td>				
				  <td class="labelmedium" style="padding:2px;">		
					   
					    <cfif url.mode eq "View">
						
							<cfif line.Operational eq "1"><cf_tl id="Active"><cfelse><cf_tl id="Deactivated"></cfif>
						
						<cfelse>
						
							<cfif checkOpen.recordcount gte "1" or checkitem.recordcount gte "1">
							
								<cfif line.Operational eq "1"><cf_tl id="Active"><cfelse><cf_tl id="Deactivated"></cfif>
							
								<input type="hidden" name="Operational" value="#Line.Operational#">
							
							<cfelse>
								
							<input type="radio" class="radiol" name="Operational" id="Operational" value="1" <cfif line.Operational eq "1"or line.Operational eq "">checked</cfif>><cf_tl id="Active">
							<input type="radio" class="radiol" name="Operational" id="Operational" value="0" <cfif line.Operational eq "0">checked</cfif>><cf_tl id="Deactivate"> (<cf_tl id="disables all billing info">)					
							
							</cfif>
							
						</cfif>	
			    	   </td>
			 			
			</cfif>
				
		<cfelse>
				
			<!--- line reference --->
			
			<tr><td width="20%" class="labelmedium"><cfif domain.description neq "">#Domain.description#<cfelse><cf_tl id="Id"></cfif>: <font color="FF0000">*</font></td>
			
				<td width="80%">	
									
				<table cellspacing="0" cellpadding="0">
						
					<tr>
						<td class="labelmedium" style="padding:2px;">	
						
						<cfif url.mode eq "View">
						
							#line.reference#
						
						<cfelse>
						
						 <cfif line.parentworkorderLine eq "">
													 
						 <cfinput type   = "Text"
						       name      = "reference"					  
						       required  = "Yes"
						       visible   = "Yes"
							   value     = "#line.reference#"
						       enabled   = "Yes"				     
						       size      = "1"
						       maxlength = "20"
						       class     = "regularxxl"
						       style     = "width:100">
							   
						  <cfelse>
						  
						  	#line.reference#
						  
						    <input type="hidden" name="reference" value = "#line.reference#">
							
						  </cfif>	   
						   
						 </cfif>  
						   
					   </td>
					   <td>&nbsp;</td>	   
					   <td>&nbsp;</td>
					   <td class="labelmedium" style="padding:2px;">		
					   
					    <cfif url.mode eq "View">
						
							<cfif line.Operational eq "1"><cf_tl id="Active"><cfelse><cf_tl id="Deactivated"></cfif>
						
						<cfelse>
						
							<cfif checkOpen.recordcount gte "1" or Line.DateExpiration neq "">
							
								<cfif line.Operational eq "1"><cf_tl id="Active"><cfelse><cf_tl id="Deactivated"></cfif>
							
								<input type="hidden" name="Operational" value="#Line.Operational#">
							
							<cfelse>
								
							<input type="radio" class="radiol" name="Operational" id="Operational" value="1" <cfif line.Operational eq "1"or line.Operational eq "">checked</cfif>><font face="Calibri" size="2"><cf_tl id="Active">
							<input type="radio" class="radiol" name="Operational" id="Operational" value="0" <cfif line.Operational eq "0">checked</cfif>><font face="Calibri" size="2"><cf_tl id="Deactivate"> (<cf_tl id="disables all billing info">)					
							
							</cfif>
							
						</cfif>	
			    	   </td>
					
					</tr>
				
				</table>
					   
			</tr>
		
			<tr><td class="labelmedium2" valign="top" style="padding-top:3px"><cf_tl id="Descriptive">:</td>
			
				<td class="labelmedium2" style="padding:2px;">	
				
				<cfif url.mode eq "View">
						
					<cfif line.description eq ""><font color="808080">[n/a]</font><cfelse>#line.Description#</cfif>
					
				<cfelse>
				
					<textarea name="Description" style="width:90%;height:40px;font-size:14px;padding:4px" totlength="100" class="regular" onkeyup="return ismaxlength(this)">#line.Description#</textarea>		
				
				</cfif>
				
										
				</td>
			
			</tr>	
		
		</cfif>
				
		<cfif Item.EnableOrgUnit eq "1">
		
			<!--- the customer orgunit associated to this line --->
								
			<cfquery name="Customerorgunit" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				 SELECT  *	
			     FROM    Organization
				 WHERE   OrgUnit = '#Customer.OrgUnit#'	
			</cfquery>		
					
			<cfif CustomerOrgunit.recordcount eq "1">
				
			<tr><td class="labelmedium2"><cf_tl id="Serviced in">:</td>
			
				<td class="labelmedium" style="padding:2px;">	
				
				<cfif url.mode eq "View">
				
					<cfquery name="orgunit" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						 SELECT  *	
					     FROM    Organization
						 WHERE   OrgUnit    = '#Line.OrgUnit#'	
					</cfquery>	
					
					<cfif orgunit.recordcount eq "0">[none]<cfelse>#OrgUnit.OrgUnitName#</cfif>
												
				<cfelse>
							
					<cfset link = "ServiceLineNode.cfm?workorderline=#url.workorderline#&workorderid=#URL.workorderid#">	
						
						<table cellspacing="0" cellpadding="0">
							<tr>
																
							<td><cf_securediv bind="url:#link#" id="organization"></td>
							<td style="width:5px"></td>		
							<td width="20">
															
							   <cf_selectlookup
							    box           = "organization"
								link          = "#link#"
								button        = "No"
								close         = "Yes"		
								iconheight    = "25"
								iconwidth     = "25"		
								filter1       = "Mission"
								filter1value  = "#CustomerOrgUnit.Mission#"	
								filter2       = "WorkOrder"	
								filter2value  = "#customer.orgunit#"
								icon          = "search.png"
								class         = "organization"
								des1          = "OrgUnit">
									
							</td>	
							
							</tr>
						</table>	
						
				</cfif>				
							
				</td>
			
			</tr>	
			
			</cfif>
		
		</cfif>
			
								
		<cfquery name="DomainClass" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    * 
			FROM      Ref_ServiceItemDomainClass
			WHERE     ServiceDomain = '#item.servicedomain#'	
			AND       Operational = 1
			ORDER BY  ListingOrder
		</cfquery>			
		
		
		<cfif DomainClass.recordcount gte "1">
		
				<tr><td class="labelmedium"><cf_tl id="Class">:</td>		
				<td class="labelmedium" style="padding:2px;">	
				
					<cfif url.mode eq "View">
					
						<cfquery name="DomainClass" 
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   * 
							FROM     Ref_ServiceItemDomainClass
							WHERE    ServiceDomain    = '#line.servicedomain#'	
							AND      Code             = '#line.servicedomainclass#'
						</cfquery>			
					
						#domainClass.description#
									   	
					<cfelse>
					
						<cfquery name="DomainClass" 
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   * 
							FROM     Ref_ServiceItemDomainClass
							WHERE    ServiceDomain = '#item.servicedomain#'	
							AND      Operational = 1
							ORDER BY ListingOrder
						</cfquery>			
													
						<select name="ServiceDomainClass" id="ServiceDomainClass" class="regularxxl enterastab">
						<cfloop query="DomainClass">
						   <option value="#Code#" <cfif line.servicedomainclass eq Code>selected</cfif>>#Description#</option>
						</cfloop>					
						</select>
										
					</cfif>
										
				</td>	
					
		</cfif>	
		
		<cfif Item.EnableOrgUnitWorkOrder eq "1">
			<tr>
				<td class="labelmedium">
					<cf_tl id="Implementer">:
				</td>
				<td class="labelmedium" style="padding:2px;">
				
					<cfif url.mode eq "View">
				
						<cfquery name="orgunitI" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							 SELECT  *	
						     FROM    Organization
							 WHERE   OrgUnit    = '#Line.OrgUnitImplementer#'	
						</cfquery>	
						
						<cfif orgunitI.recordcount eq "0">[none]<cfelse>#OrgUnitI.OrgUnitName#</cfif>
													
					<cfelse>
					
							<!--- provision in case the line has already an implementer --->
					
							<cfquery name="setImplementer" 
								datasource="AppsWorkOrder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">							
								INSERT INTO WorkOrderImplementer
								(WorkOrderId, OrgUnit,OfficerUserId, OfficerLastName, OfficerFirstName)
								SELECT  W.WorkOrderId, 
								        OrgUnitImplementer, 
										'#session.acc#','#session.last#','#session.first#'
								FROM    WorkOrderLine AS W
								WHERE   WorkOrderId = '#url.workOrderId#' 
								AND     OrgUnitImplementer is not NULL
								AND     NOT EXISTS
					                             (SELECT   'X' AS Expr1
                    					          FROM     WorkOrderImplementer
					                              WHERE    WorkOrderId = W.WorkOrderId 
												  AND      OrgUnit = W.OrgUnitImplementer)
							</cfquery>		
											
												
							<cfquery name="ImplementerUnits" 
								datasource="AppsWorkOrder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT   O.*
									FROM     WorkOrderImplementer I INNER JOIN 
									         Organization.dbo.Organization O ON I.OrgUnit = O.OrgUnit
									WHERE    I.WorkOrderId = '#url.workOrderId#'
									ORDER BY O.HierarchyCode ASC 
							</cfquery>	
							
							<cfif line.OrgUnitImplementer eq "">						
							    <cfif prior.OrgUnitImplementer neq "">
									<cfset sel = prior.OrgUnitImplementer>
								<cfelse>
									<cfset sel = ImplementerUnits.OrgUnit>
								</cfif>
							<cfelse>									
								<cfset sel = line.OrgUnitImplementer>							
							</cfif>								
							
							<cfselect name="OrgUnitImplementer" 
								id="OrgUnitImplementer" 
								query="ImplementerUnits" 
								display="OrgUnitName" 
								value="OrgUnit" 
								selected="#sel#" 
								required="no" 
								queryposition="below" 
								class="regularxl enterastab">
								<option value=""></option>
							</cfselect>
							
					</cfif>
				</td>
			</tr>
		<cfelse>
			<input type="hidden" name="OrgUnitImplementer" id="OrgUnitImplementer" value="#line.OrgUnitImplementer#">
		</cfif>						
		
		
		<cfif Item.EnablePerson eq "1">
		
		<tr>
			<td height="20" class="labelmedium"><cf_tl id="Assigned to">:</td>
			<td class="labelmedium" style="padding:2px;">
						
			
				<cfif url.mode eq "View">
				
					<cfquery name="person" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						 SELECT  *	
					     FROM    Person
						 WHERE   PersonNo = '#Line.PersonNo#'	
					</cfquery>	
			
					<cfif person.recordcount eq "0">[none]<cfelse>#person.FirstName# #Person.LastName#</cfif>
								
				<cfelse>	
														
					<cfset link = "ServiceLinePerson.cfm?workorderline=#url.workorderline#&workorderid=#URL.workorderid#">
																					
					<table cellspacing="0" cellpadding="0">
						<tr>
										
						<cfif prior.personNo neq "" and prior.serviceMode eq "WorkOrder">				
										
							<td><cf_securediv bind="url:#link#&personno=#prior.personno#" id="employee"></td>
						
						<cfelse>
						
							<td><cf_securediv bind="url:#link#" id="employee"></td>
						
						</cfif>
						
						<td width="20">

						   <cf_selectlookup
							    box          = "employee"
								link         = "#link#"
								button       = "Yes"
								close        = "Yes"												
								icon         = "search.png"
								iconheight   = "25"
								iconwidth    = "24"
								class        = "employee"
								des1         = "PersonNo"
								filter1		 = "OrgUnitTree"
								filter1Value = "#url.workorderid#"
								filter2Value = "#Item.EnableOrgUnitWorkOrder#">
								
						</td>					
						</tr>
					</table>
					
				</cfif>	
				
			</td>
		</tr>		
		</cfif>		
		
		<tr><td class="labelmedium"><cf_tl id="Source Reference">:</td>
		
			<td class="labelmedium" style="padding:2px;">		
			
			<cfif url.mode eq "View">
			
				<cfif line.source eq ""><font color="808080">[n/a]</font><cfelse>#line.source#</cfif>
			
			<cfelse>	
						 
			 <cfinput type="Text"
			       name="source"					  
			       required="No"
			       visible="Yes"
				   value="#line.source#"
			       enabled="Yes"				     
			       size="1"
			       maxlength="10"
			       class="regularxxl enterastab"
			       style="text-align:left;width:100">
				   
			</cfif>	   
						
			</td>
		
		</tr>	
		
		
				
		<tr><td class="labelmedium"><cf_tl id="Effective">: <font color="FF0000">*</font></td>
		    <td class="labelmedium" style="padding:2px;">	
			
			<cfif url.mode eq "View">
			
				#Dateformat(Line.DateEffective, CLIENT.DateFormatShow)# - <cfif Line.DateExpiration eq "">[<cf_tl id="undefined">]<cfelse>#Dateformat(Line.DateExpiration, CLIENT.DateFormatShow)#</cfif>
			
			<cfelse>
			
				<table cellspacing="0" cellpadding="0">				
				<tr>
					<td>										 
						  <cf_intelliCalendarDate9
							FieldName="dateeffective" 
							class="regularxxl"										
							Default="#Dateformat(Line.DateEffective, CLIENT.DateFormatShow)#"		
							AllowBlank="False">								
					</td>					
				    <td style="padding-left:20px" class="labelmedium"><cf_tl id="Expiration">:</td>
					
			        <td style="padding-left:10px">						
						  <cf_intelliCalendarDate9
							FieldName="dateexpiration" 					
							class="regularxxl"	
							Default="#Dateformat(Line.DateExpiration, CLIENT.DateFormatShow)#"		
							AllowBlank="True">							
			        </td>
				</tr>
				</table>
				
			</cfif>	
			
			</td>
			
		</tr>	
		
		<tr><td class="labelmedium" valign="top" style="padding-top:3px"><cf_tl id="Memo">:</td>
		
			<td class="labelmedium" style="padding:2px;">	
			
			<cfif url.mode eq "View">
					
				<cfif line.WorkOrderLineMemo eq ""><font color="808080">[n/a]</font><cfelse>#line.WorkOrderLineMemo#</cfif>
				
			<cfelse>
			
				<textarea name="WorkOrderLineMemo" style="width:90%;height:40;font-size:14px;padding:3px" 
				  totlength="100" class="regular" onkeyup="return ismaxlength(this)">#line.WorkOrderLineMemo#</textarea>		
			
			</cfif>
			
									
			</td>
		
		</tr>	
			
	</cfoutput>	
		
	<cfquery name="WorkOrder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrder
		 WHERE   WorkOrderId     = '#url.workorderid#'	
	</cfquery>
		
	<tr>
		<td style="padding-right:15px;padding-left:1px">	
		
		<cfset url.mission     = "#workorder.mission#">
		<cfset url.serviceitem = "#workorder.serviceitem#">
		<cfset ass = "Field">		
		<cfset url.inputclass  = "regularxl">
		<cfset url.style = "padding-left:2px">	
		<cfinclude template    = "../Create/CustomFields.cfm">		
			
		</td>
	</tr>
			
</table>

<cfset ajaxOnload("doHighlight")>
