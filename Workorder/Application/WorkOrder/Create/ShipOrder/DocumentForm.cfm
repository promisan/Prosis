
<!--- --------CUSTOM FORM DATA ENTRY --------- --->
<!--- ---------------------------------------- --->
<!--- --Deliver service for Kuntz data entry-- --->
<!--- ---------------------------------------- --->
<!--- ---------------------------------------- --->

<cfparam name="url.workorderid"   default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.workorderline" default="1">
<cfparam name="url.requestid"     default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.billingid"     default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.customerid"    default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.context"       default="backoffice">
<cfparam name="url.scope"         default="entry">

<cfparam name="url.serviceitem"   default="#type.code#">

<cfform name="orderform" onsubmit="return false">
		
		<input type="hidden"  name="serviceitem"  id="serviceitem" value="<cfoutput>#url.serviceitem#</cfoutput>">		
		<input type="hidden"  name="country"      id="country"     value="NET">
		<input type="hidden" name="scope" id="scope" value="<cfoutput>#url.scope#</cfoutput>">
				
		<cfquery name="WorkOrder" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM   WorkOrder
			WHERE  WorkOrderId   = '#URL.workorderid#'						  
		</cfquery>					
		
		<cfif workorder.recordcount eq "1">
		
			<cfset date  = "#dateformat(Workorder.OrderDate,CLIENT.DateFormatShow)#">
		
			<cfquery name="Customer" 
			 datasource="AppsWorkOrder" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT *
				FROM   Customer
				WHERE  CustomerId   = '#workorder.customerid#'						  
			</cfquery>		
			
			<cfset lat  = "">
			<cfset lng  = "">
			<cfset row = 0>
				
			<cfloop index="itm" list="#Customer.Coordinates#" delimiters=",">
				<cfset row = row+1>
				<cfif row eq "1">
				   <cfset  lat = itm>
				<cfelse>
				   <cfset  lng = itm>  		
				</cfif>
			</cfloop>			
			
			<cfoutput>
			<input type="hidden"  name="cLatitude"    id="cLatitude"   value="#lat#" size="18" maxlength="20">
			<input type="hidden"  name="cLongitude"   id="cLongitude"  value="#lng#" size="18" maxlength="20">
			</cfoutput>
			
			<cfinvoke component = "Service.Access"  
				method           = "WorkorderProcessor" 
				mission          = "#workorder.mission#" 
				serviceitem      = "#workorder.serviceitem#"
				returnvariable   = "access">	
				   					   
														   
			<cfif access eq "EDIT" or access eq "ALL" or workorder.ActionStatus eq "0">	   	   		
			 
			     <cfset url.mode = "edit">
				 
			<cfelse>	 
			 
			 	 <cfset url.mode = "view">
			 
			</cfif>	
		
		<cfelse>
		
			<cfset url.mode = "edit">
			
			<input type="hidden"  name="cLatitude"    id="cLatitude"   size="18" maxlength="20">
			<input type="hidden"  name="cLongitude"   id="cLongitude"  size="18" maxlength="20">
		
			<cfset date  = "#dateformat(now(),CLIENT.DateFormatShow)#">
		
			<cfquery name="Customer" 
			 datasource="AppsWorkOrder" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT *
				FROM   Customer
				WHERE  CustomerId   = '#url.customerid#'						  
			</cfquery>		
			
			<cfset access = "EDIT">
		
		</cfif>
		
		<cfquery name="Line" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM   WorkOrderLine
			WHERE  WorkOrderId   = '#URL.workorderid#'		  
			AND    WorkOrderLine = '#url.workorderline#'					  
		</cfquery>		
		
	
		<cfquery name="Person" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT  *
			FROM   Person	
			WHERE  ( PersonNo IN (SELECT PersonNO 
			                   FROM   vwAssignment
							   WHERE  DateEffective < getdate() and DateExpiration > getDate() 
							   AND    AssignmentStatus IN ('0','1'))
			AND    PersonStatus = '1'
			
			)
			
			OR 	  PersonNo IN ( SELECT PersonNo 
							    FROM   WorkOrder.dbo.WorkOrderLine
								WHERE WorkOrderId = '#url.workorderid#'															
							   )
			
		</cfquery>				
				
		<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
		<tr><td height="4"></td></tr>
		
		<!--- Line fields --->		
			
		<cfif url.context eq "backoffice">
		
			<cfquery name="Org" 
			 datasource="AppsOrganization" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT *
				FROM   Organization
				WHERE  Mission      = '#url.Mission#'						  
				AND    OrgUnitClass != 'Administrative'
				ORDER BY OrgUnitName ASC
			</cfquery>			
			
			<tr>
			    <td style="height:33px" class="labellarge"><b><cf_tl id="Branch">:<font color="FF0000">*)</font></td>
				<td>
				
				<!--- today's date --->
				<cfset date = dateformat(now(),client.dateformatshow)>
												
				<cfselect name="OrgUnitOwner" id="OrgUnitOwner" class="regularxl enterastab" 
				    onchange="provisionload('#url.mission#','#url.workorderid#','#url.workorderline#','#url.serviceitem#','#url.requestid#','#url.billingid#',this.value,'#date#','#url.context#','workorder')">
				    <cfoutput query="Org">
					<option value="#OrgUnit#" <cfif WorkOrder.OrgUnitOwner eq OrgUnit>selected</cfif>>#OrgUnitName#</option>
					</cfoutput>
				</cfselect>
								
				</td>
			</tr>		
		
		<cfelse>
		
			<!--- limit by access of the user to show only relevant units --->
			
			<tr>
			    <td style="height:33px" class="labellarge"><b><cf_tl id="Branch">:<cfif mode eq "edit"><b><font color="FF0000">*</font></cfif></td>
				<td class="labelmedium">
				
				<cfif mode eq "edit">
				
					<cfquery name="Org" 
					 datasource="AppsOrganization" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						SELECT   *
						FROM     Organization
						WHERE    Mission  = '#URL.Mission#'	
						
						<cfif getAdministrator(url.mission) eq "1">
	
						<!--- no filtering --->
						
						<cfelse>									
						
						AND      OrgUnit IN (SELECT OrgUnit FROM System.dbo.UserMission WHERE Account = '#SESSION.acc#')
						
						</cfif>		  
						
						AND      OrgUnitClass != 'Administrative'
						ORDER BY OrgUnitName ASC
					</cfquery>		
					
					<select name="OrgUnitOwner" id="OrgUnitOwner" class="regularxl enterastab">
					    <cfoutput query="Org">
						<option value="#OrgUnit#" <cfif WorkOrder.OrgUnitOwner eq OrgUnit>selected</cfif>>#OrgUnitName#</option>
						</cfoutput>
					</select>
				
				<cfelse>
				
					 <cfquery name="Org" 
					 datasource="AppsOrganization" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						SELECT *
						FROM   Organization
						WHERE  OrgUnit = '#WorkOrder.OrgUnitOwner#'				
					</cfquery>		
					
					<cfoutput>#org.OrgUnitName#</cfoutput>
								
				</cfif>
				
				</td>
			</tr>
			
		</cfif>
				
		<!--- ------------- --->
		<!--- -- Customer-- --->
		<!--- ------------- --->	
		
		<!---
			
		<tr>		
			<td colspan="1" style="height:40px;padding-top:3px" class="labellarge"><b><cf_tl id="Customer"></td>		
		</tr>
		
		--->
														
		<cfoutput>
				
		<tr><td height="25" class="labelmedium" style="padding-left:15px"><cf_tl id="Customer"> <cf_tl id="Name">:  <cfif mode eq "edit"><font color="FF0000">*</font></cfif></td>
		    <td width="80%" class="labelmedium">	
			 <cfif mode eq "edit">					
			 <cfinput type="text" name="CustomerName" message="Please enter a Customer Name" required="Yes" value="#Customer.CustomerName#" style="width:70%" maxlength="80" class="regularxl enterastab">
			 <cfelse>
			 #Customer.CustomerName#
			 </cfif>
		   </td>
	    </tr>
		
		<tr><td valign="top" class="labelmedium" style="padding-left:15px;padding-top:3px" height="20">
		<cf_tl id="Address">: <cfif mode eq "edit"><font color="FF0000">*</font></cfif></td>				
		   <td colspan="1">
										
				<cf_inputPostalCode required="Yes"
			          length            = "6" 
					  inputmask         = "9999AA"
					  box               = "order" 
					  accessmode        = "#mode#"
					  labelwidth        = "120"
					  labelclass        = "labelmedium" 
					  inputclass        = "regularxl"
					  mission           = "#url.mission#" 
					  country           = "NET" 							  
					  InputMode         = "Manual"
					  selectedpostal    = "#Customer.PostalCode#" 
					  selectedCity      = "#Customer.City#"
					  selectedAddress   = "#Customer.Address#"
					  selectedAddressNo = "#Customer.AddressNo#">							
		</td>
		</tr>
					
		<tr>
		
			<td height="25" class="labelmedium" style="padding-left:15px"><cf_tl id="Mobile Number">:</td>			
		    <td>
			<table cellspacing="0" cellpadding="0">
			<tr><td class="labelmedium">
			
			<cfif mode eq "edit">
			<cfinput type="text" name="MobileNumber" id="MobileNumber" value="#Customer.MobileNumber#" mask="31 (0)6 9999 9999" style="width:160" maxlength="17" class="regularxl enterastab">
			<cfelse>
			<cfif Customer.MobileNumber eq "">N/A<cfelse>#Customer.MobileNumber#</cfif>
			</cfif>
			
			</td>
			
			<td height="25" class="labelmedium" style="padding-left:20px;padding-right:14px"><cf_tl id="Phone">:</td><td class="labelmedium">
		    <cfif mode eq "edit">
			<cfinput type="text" name="PhoneNumber" id="PhoneNumber" value="#Customer.PhoneNumber#" mask="31 (0) 999999999" style="width:160" maxlength="20" class="regularxl enterastab">
			<cfelse>
			<cfif Customer.PhoneNumber eq "">N/A<cfelse>#Customer.PhoneNumber#</cfif>					
			</cfif>
			</td>
			
			<cfquery name="Protocol"
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT Protocol
				FROM   Ref_Action R, Ref_ActionNotification P
				WHERE  R.Code = P.Code
				AND    R.Mission = '#url.mission#'		
				AND    Protocol = 'SMTP'								
			</cfquery>	
			
			<cfif Protocol.recordcount eq "0">
			
				<input type="hidden" name="eMailAddress" value="#Customer.eMailAddress#">
			
			<cfelse>
			
				<td height="25" class="labelmedium" style="padding-left:20px;padding-right:14px"><cf_tl id="eMail">:</td><td class="labelmedium">
			    <cfif mode eq "edit">
				<cfinput type="Text" name="eMailAddress" value="#Customer.eMailAddress#" validate="email" required="No" visible="Yes" maxlength="30" id="eMailAddress" style="width:180" class="regularxl enterastab">
				<cfelse>
				<cfif Customer.eMailAddress eq "">N/A<cfelse>#Customer.eMailAddress#</cfif>					
				</cfif>
				</td>
			
			</cfif>
			
			</tr></TABLE>
		    
		</td>
		</tr>
				
		</cfoutput>			
					
		<tr><td colspan="5" class="line"></td></tr>
			
		<!--- ------------ --->
		<!--- -- Details-- --->
		<!--- ------------ --->	
		
		<cfif url.context neq "backoffice">
				
		<tr>
		<td colspan="2" style="font-size:15px;height:20px;padding-left:15px" class="label"><font color="6688aa"><cf_tl id="Delivery Details"></font></b></td>
		</tr>
		
		
		</cfif>
				
		<!--- ------------ --->
		<!--- Provisioning --->
		<!--- ------------ --->
				
		<tr>		
		
		<td colspan="2" style="padding-left:40px">		
		
			<cfset url.orgunitowner = WorkOrder.OrgUnitOwner>	
				
			<cfif url.mode eq "edit">
					
				<table width="100%" cellspacing="0" cellpadding="0" align="center">
				<tr>
				<td style="padding-bottom:5px;padding-left:0px;padding-right:10px" style="border:0px dashed silver" id="boxprovision">
				<cfset url.mode = "workorder">					
				<cfinclude template="../../ServiceDetails/Billing/DetailBillingFormEntry.cfm">	
				<cfset url.mode = "edit">		
				</td>
				</tr>
				</table>	
									
			<cfelse>
			
				<cfset url.accessmode = "view">				
				<table width="100%" cellspacing="0" cellpadding="0" align="center">
				<tr>
				<td style="padding-bottom:5px;padding-left:0px;padding-right:10px" style="border:0px dashed silver">
				<cfset url.mode = "workorder">			
				<cfinclude template="../../ServiceDetails/Billing/DetailBillingFormEntry.cfm">	
				<cfset url.mode = "view">		
				</td>
				</tr>
				</table>	
									
			</cfif>
			
		</td>		
		</tr>
		
		<tr><td height="4"></td></tr>
				
		<cfset url.inputclass = "regularxl">
		<cfset url.style      = "padding-left:15px;height:28px">
		<!--- Custom classification fields --->
		<cfinclude template="../CustomFields.cfm">			
									
		<tr class="hide"><td colspan="5" id="ajaxbox"></td></tr>
						
		<!--- ------------------- --->
		<!--- -- Delivery Date--- --->
		<!--- ------------------- --->
		
		<tr><td height="8"></td></tr>		
		<tr><td colspan="5" class="line"></td></tr>		
						
			<cfif url.context eq "Portal">	
			
			<tr>
				<td colspan="1" style="padding-right:4px" class="labellarge"><font color="6688aa"><b><cf_tl id="Schedule">:
				     <cf_space spaces="35">
				</td>
						
				<td height="35">		
				
				<table cellspacing="0" cellpadding="0">															
				<cfinclude template="DocumentFormDelivery.cfm">						
				</table>
											
				</td>
		
			</tr>	
				
			<cfelseif url.context eq "Backoffice" and access eq "Edit">	   
			
				<tr>
				<td colspan="5">
			
				<cf_WorkOrderActionFields
			       mission        = "#url.mission#" 
			       serviceitem    = "#url.serviceitem#" 
				   workorderid    = "#url.workorderid#" 
				   workorderline  = "#url.workorderline#"
				   mode           = "edit"
				   calendar       = "9"
				   actiondatemode = "Planning">
				   
				  </td>
				 </tr>  
						
			<cfelseif url.context eq "Backoffice" and access eq "All">	
			
				<tr>
				<td colspan="5">	
							
				<cf_WorkOrderActionFields
			       mission        = "#url.mission#" 
			       serviceitem    = "#url.serviceitem#" 
				   workorderid    = "#url.workorderid#" 
				   workorderline  = "#url.workorderline#"
				   mode           = "edit"
				   calendar       = "9"
				   actiondatemode = "Actual">			
				   
				 </td>
				 </tr>  
							
			</cfif>		
		
								
</table>

</cfform>

<cfset AjaxOnLoad("doCalendar")>	