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

<!--- --------CUSTOM FORM DATA ENTRY ----------- --->
<!--- ------------------------------------------ --->
<!--- --Consult service for Medical data entry-- --->
<!--- ------------------------------------------ --->
<!--- ------------------------------------------ --->

<cfparam name="url.requestid"     default="">
<cfparam name="url.workorderid"   default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.workorderline" default="1">
<cfparam name="url.orgunit"       default="">
<cfparam name="url.scope"         default="entry">
<cfparam name="url.serviceitem"   default="#type.code#">
<cfparam name="url.mode"          default="edit">

<cfset LastWorkOrderId        = "">
<cfset LastWorkOrderLine      = "">		

<cfquery name="Customer" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	 
		SELECT     *
		FROM        Customer C
		WHERE       CustomerId = '#url.Customerid#'			 
</cfquery>	

<cfif url.requestid neq "">
	
	<cfquery name="Request" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
		 SELECT    *
		 FROM      Request
		 WHERE     RequestId = '#url.requestid#'
	  
	</cfquery>
	
	<cfquery name="RequestLine" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
		 SELECT    *
		 FROM      RequestLine
		 WHERE     RequestId = '#url.requestid#'
	  
	</cfquery>
		
	<cfset LastReference          = request.DomainReference>
		
	<cfset lastServiceDomainClass = request.ServiceDomainClass>
		
	<!--- obtain any last --->
	
	<cfquery name="Last" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
		 SELECT     TOP 1 *, 
		            ADM.OrgUnitName AS OrgUnitOwnerName, 
					IMP.OrgUnitName AS OrgUnitImplementerName, 
					PER.FullName AS PersonNoName
		FROM        WorkOrder W INNER JOIN
	                WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
	                Organization.dbo.Organization ADM ON W.OrgUnitOwner = ADM.OrgUnit INNER JOIN
	                Organization.dbo.Organization IMP ON WL.OrgUnitImplementer = IMP.OrgUnit LEFT OUTER JOIN
	                Employee.dbo.Person PER ON WL.PersonNo = PER.PersonNo
		WHERE       W.CustomerId = '#url.Customerid#'
		ORDER BY    W.Created DESC
	 
	</cfquery>	
	
	<cfset orgunitowner           = last.OrgUnitOwner>
	<cfset orgunitownername       = last.orgUnitOwnerName>
	<cfset orgunitimplementer     = last.OrgUnitImplementer>
	<cfset orgunitimplementername = last.OrgUnitImplementerName>
	
	

<cfelse>
	
	<cfquery name="Last" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
		 SELECT     TOP 1 *, 
		            ADM.OrgUnitName AS OrgUnitOwnerName, 
					IMP.OrgUnitName AS OrgUnitImplementerName, 
					PER.FullName AS PersonNoName,
					ISNULL((Select PersonNo from Employee.dbo.Person WHERE PersonNo ='#url.personNo#'),WL.PersonNo) as PersonNo1,
					ISNULL((Select FullName from Employee.dbo.Person WHERE PersonNo ='#url.personNo#'),PER.FullName) as PersonNoName1
		FROM        WorkOrder W INNER JOIN
	                WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
	                Organization.dbo.Organization ADM ON W.OrgUnitOwner = ADM.OrgUnit INNER JOIN
	                Organization.dbo.Organization IMP ON WL.OrgUnitImplementer = IMP.OrgUnit LEFT OUTER JOIN
	                Employee.dbo.Person PER ON WL.PersonNo = PER.PersonNo
		WHERE       W.CustomerId = '#url.Customerid#'
		ORDER BY    W.Created DESC
	 
	</cfquery>	
	
	<cfif Last.recordcount eq "1">
	
		<cfset LastWorkOrderId        = last.WorkOrderId>
		<cfset LastWorkOrderLine      = last.WorkOrderLine>
		
		<cfset orgunitowner           = last.OrgUnitOwner>
		<cfset orgunitownername       = last.orgUnitOwnerName>
		<cfset orgunitimplementer     = last.OrgUnitImplementer>
		<cfset orgunitimplementername = last.OrgUnitImplementerName>
		<cfset lastReference          = Last.Reference>
		<cfset lastServiceDomainClass = Last.ServiceDomainClass>
	
	<cfelse>
	
		<cfquery name="Last" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">	
		
		 SELECT     TOP 1 *, 
			            ADM.OrgUnitName AS OrgUnitOwnerName, 
						IMP.OrgUnitName AS OrgUnitImplementerName, 
						PER.FullName AS PersonNoName,
						ISNULL((Select PersonNo from Employee.dbo.Person WHERE PersonNo ='#url.personNo#'),WL.PersonNo) as PersonNo1,
						ISNULL((Select FullName from Employee.dbo.Person WHERE PersonNo ='#url.personNo#'),PER.FullName) as PersonNoName1
			FROM        WorkOrder W INNER JOIN
		                WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
		                Organization.dbo.Organization ADM ON W.OrgUnitOwner = ADM.OrgUnit INNER JOIN
		                Organization.dbo.Organization IMP ON WL.OrgUnitImplementer = IMP.OrgUnit LEFT OUTER JOIN
		                Employee.dbo.Person PER ON WL.PersonNo = PER.PersonNo
			WHERE       W.Mission = '#customer.Mission#'
			ORDER BY    W.Created DESC
			</cfquery>	
			
			<cfset orgunitowner           = last.OrgUnitOwner>
			<cfset orgunitownername       = last.orgUnitOwnerName>
			<cfset orgunitimplementer     = last.OrgUnitImplementer>
			<cfset orgunitimplementername = last.OrgUnitImplementerName>
			<cfset lastReference          = Last.Reference>
			<cfset lastServiceDomainClass = Last.ServiceDomainClass>
			
		</cfif>	
		
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

<cfform name="orderform" onsubmit="return false">
	
	<cfoutput>
		<input type="hidden" name="ParentWorkOrderid"   value="#LastWorkOrderId#">
		<input type="hidden" name="ParentWorkOrderLine" value="#LastWorkOrderLine#">
	</cfoutput>
	
	<!--- there can be different rates basedon the topic + unit combinations --->
	
	<table width="100%" class="formspacing">
	
	<tr class="hide"><td id="process"></td></tr>
	
	<cfif url.requestid neq "">
		
		<cfset url.mode = "view">
				
		<!--- the core of the core --->
		<cfinclude template="../../../Medical/Complaint/Create/DocumentFormRequestType.cfm">					
		
	    <!--- support the view mode here as well --->				
		<cfset url.inputclass = "regularxl">
		<cfset url.style      = "padding-left:16px">
		<cfinclude template="../../../Medical/Complaint/Create/DocumentFormTopic.cfm">			
		
		<cfset url.mode = "edit">
	
	</cfif>
	
	<tr>
		<td  style="padding-left:16px" height="34" class="labelmedium" width="25%"><cf_tl id="Request date">:</td>
		<td>
		
			 <cf_intelliCalendarDate9
				FieldName="OrderDate" 
				class="regularxl"
				Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
				DateValidEnd="#Dateformat(now()+60, 'YYYYMMDD')#"
				AllowBlank="False">				
		
		</td>
	</tr>
	
	<tr>
		<td  style="padding-left:16px" height="34" class="labelmedium" width="15%"><cf_tl id="Administrating Unit">:</td>
		<td>
			
	         <table>
				 <tr><td>
				       
					 <cfinput type="text" name="orgunitname1" id="orgunitname1" value="#OrgUnitOwnerName#" message="No unit selected" required="Yes" class="regularxl" size="40" maxlength="80" readonly>					  
					 
					 </td>
					 
					 <td style="padding-left:2px">
					 
					 <cfoutput>		 
					 
				     <img src="#SESSION.root#/Images/search.png" alt="Select authorised unit" name="img0" 
						  onMouseOver="document.img0.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img0.src='#SESSION.root#/Images/search.png'"
						  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
						  onClick="selectorgN('#url.mission#','administrative','orgunit','applyorgunit','1','1','modal')">
					  	     
						 <input type="hidden" name="orgunit1"      id="orgunit1" value="#OrgUnitOwner#"> 
						 <input type="hidden" name="mission1"      id="mission1"> 
						 <input type="hidden" name="orgunit1code"  id="orgunit1code">
					   	 <input type="hidden" name="orgunit1class" id="orgunit1class"> 
					 
					 </cfoutput>
					 
					 </td>
				  </tr>			 
	          </table>
			
		</td>
	</tr>
	
	<cfif line.recordcount eq "0">
	
	<tr>
		<td style="padding-left:16px" class="labelmedium"><cf_tl id="Currency">:</td>
		<td colpsan="4" class="labelmedium">
		
		<cfquery name="qCurrency" 
		 datasource="AppsLedger" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
			 SELECT    *
			 FROM      Currency			
		</cfquery>
			
		<select name="Currency" class="regularxl">
		<cfoutput query="qCurrency">
		    <option value="#Currency#" <cfif application.basecurrency eq currency>selected</cfif>>#Currency#</option>
		</cfoutput>
		</select>
		
		</td>
	</tr>
	
	</cfif>
	
		
	<cfif url.orgunit eq "">
	
		<tr>
			<td  style="padding-left:16px" height="34" class="labelmedium" width="15%"><cf_tl id="Executing Unit">:</td>
			<td>
			
				<table><tr><td>
				       
					 <cfinput type="text" name="orgunitname2" id="orgunitname2" value="#OrgUnitImplementerName#" message="No unit selected" required="Yes" class="regularxl" size="40" maxlength="80" readonly>					  
					 
					 </td>
					 		 
					 <td style="padding-left:2px">
					 
					 <cfoutput>
					 
				     <img src="#SESSION.root#/Images/search.png" alt="Select authorised unit" name="img0" 
						  onMouseOver="document.img0.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img0.src='#SESSION.root#/Images/search.png'"
						  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
						  onClick="selectorgN('#url.mission#','administrative','orgunit','applyorgunit','2','1','modal')">
					  	     
						 <input type="hidden" name="orgunit2"      id="orgunit2" value="#OrgUnitImplementer#"> 
						 <input type="hidden" name="mission2"      id="mission2"> 
						 <input type="hidden" name="orgunitcode2"  id="orgunitcode2">
					   	 <input type="hidden" name="orgunitclass2" id="orgunitclass2"> 
					 
					 </cfoutput>
					 
					 </td>
					 </tr>
					 
		          </table>
			
			</td>
		</tr>
	
	<cfelse>
	
		<tr>
			<td  style="padding-left:16px" height="34" class="labelmedium" width="15%"><cf_tl id="Executing Unit">:</td>
			<td>
							
							
				<cfquery name="Org" 
				 datasource="AppsOrganization" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					SELECT *
					FROM   Organization
					WHERE  OrgUnit   = '#URL.OrgUnit#'		  					  
				</cfquery>	
				
				<cfoutput>
				
				<input type="hidden" name="orgunit2"  id="orgunit2" value="#url.orgunit#">				
				
				<table>
				<tr class="labelmedium"><td>#Org.OrgUnitName#</td></tr>
				</table>
				
				</cfoutput>
			
			</td>
		</tr>			
	
	</cfif>
	
	<tr>
		<td  style="padding-left:16px" height="34" class="labelmedium" width="15%"><cf_tl id="Responsible Specialist">:</td>
		<td>
		
		      <table cellspacing="0" cellpadding="0">
					<tr>
					
					<td id="member">
					
						<cfoutput>															
							<input type="text"   value="#last.PersonNoName1#" name="name" value="" size="40" maxlength="40" class="regularxl enterastab" readonly style="padding-left:4px">				
							<input type="hidden" value="#last.PersonNo1#" name="personno" id="personno" value="" size="10" maxlength="10" readonly>					
						</cfoutput>
					
					</td>
					<td>
					
					<cfset link = "#SESSION.root#/WorkOrder/Application/WorkOrder/Create/Medical/setEmployee.cfm?workorderid=#url.workorderid#">	
								
					 <cf_selectlookup
						    class      = "Employee"
						    box        = "member"
							button     = "yes"
							icon       = "search.png"
							iconwidth  = "29"
							iconheight = "29"
							title      = "#lt_text#"
							link       = "#link#"						
							close      = "Yes"
							des1       = "PersonNo">
							
					</td>
					</tr>
				</table>		
			
		</td>
	</tr>
	
	<tr><td  style="padding-left:16px" height="34" class="labelmedium" width="15%"><cf_tl id="Service">:</td>
	
		<cfquery name="ServiceArea" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			SELECT    *
			FROM      WorkOrderService
			WHERE     ServiceDomain = '#type.servicedomain#'
			ORDER BY  ListingOrder,Reference 						
			
		</cfquery>		
		
		<td class="labelmedium">	
								
			<cfif url.mode eq "View">
			
			    <!--- 
				<cfquery name="Service" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
					SELECT    *
					FROM      WorkOrderService
					WHERE     ServiceDomain = '#type.servicedomain#'
					AND       Reference = '#line.reference#'
					
				</cfquery>			
							
				#service.description#
				
				--->
							   	
			<cfelse>
																					
				<select name="ServiceReference" id="ServiceReference" class="regularxl">
				<cfoutput query="ServiceArea">
				   <cf_tl id="#Description#" var="1">
				   <option value="#Reference#" <cfif lastReference eq Reference>selected</cfif>>#lt_text#</option>
				</cfoutput>					
				</select>
											
			</cfif>
																		
		</td>			
	
		<td></td>
	
	</tr>
	
	<tr>
		<td  style="padding-left:16px" height="34" class="labelmedium" width="15%"><cf_tl id="Class">:</td>
			
		<cfquery name="DomainClass" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    * 
				FROM      Ref_ServiceItemDomainClass
				WHERE     ServiceDomain = '#Type.servicedomain#'	
				AND       Operational = 1
				ORDER BY  ListingOrder
			</cfquery>				
			
			<cfif DomainClass.recordcount gte "1">
						
				<td class="labelmedium">	
								
					<cfif url.mode eq "View">
					
					<!---
					
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
						
						--->
									   	
					<cfelse>
																							
						<select name="ServiceDomainClass" id="ServiceDomainClass" class="regularxl">
						<cfoutput query="DomainClass">
						   <option value="#Code#" <cfif lastServiceDomainClass eq code>selected</cfif>>#Description#</option>
						</cfoutput>					
						</select>
													
					</cfif>
																				
				</td>	
						
			</cfif>	
			
	</tr>
	
	<tr>	
		<td style="padding-left:16px" height="34" class="labelmedium" width="15%"><cf_space spaces="46"><cf_tl id="ReferenceNo">:</td>
		<td>
		<input type="text" class="regularxl" name="Reference" id="Reference" maxlength="20" style="width:100">	
		</td>
	</tr>
	
	<tr>	
	<td colspan="2">
	
	    <cfdiv bind="url:#session.root#/WorkOrder/Application/WorkOrder/Create/Medical/getCustomField.cfm?mission=#url.mission#&serviceitem=#url.serviceitem#&domainclass={ServiceDomainClass}">
		
	</td>
	</tr>
		
	<tr>
		<td  style="padding-left:16px" class="labelmedium" width="15%"><cf_tl id="Memo">:</td>
		<td>		
		<input type="text" class="regularxl" name="OrderMemo" id="OrderMemo" style="width:80%">
		</td>
	</tr>
			
	<cfset url.inputclass = "regularxl">
	<cfset url.style      = "padding-left:16px;height:25px">
	<!--- Custom classification fields --->
	<cfinclude template   = "../CustomFields.cfm">		
	
	<tr class="line">
		<td  height="34" colspan="2" style="font-weight:200;height:60px;padding-top:20px;font-size:27px" class="labelmedium" width="15%"><cf_tl id="Planned actions"></td>
	</tr>
	
	<cfif url.context eq "Schedule">
				
		<cfset datemode = "Planning">
				
		<cf_WorkOrderActionFields
	       mission           = "#url.mission#" 
	       serviceitem       = "#url.serviceitem#" 
		   workorderid       = "#url.workorderid#" 
		   workorderline     = "#url.workorderline#"
		   customerid        = "#url.customerid#"
		   OrgUnit           = "#url.orgunit#"
		   PersonNo          = "#url.personno#"
		   mode              = "edit"
		   calendar          = "9"	
		   time				 = "Yes"	
		   date              = "#url.date#"	
		   padding           = "20"		
		   actionfulfillment = "Schedule"	<!--- filters on a certain action only --->  
		   actiondatemode    = "#datemode#">		
		   
	<cfelse>
	
		<cfset datemode = "Request">	
	
		<cf_WorkOrderActionFields
	       mission        = "#url.mission#" 
	       serviceitem    = "#url.serviceitem#" 
		   workorderid    = "#url.workorderid#" 
		   workorderline  = "#url.workorderline#"
		   OrgUnit        = "#url.orgunit#"
		   PersonNo       = "#url.personno#"
		   mode           = "edit"
		   calendar       = "9"		
		   padding        = "20"					  
		   actiondatemode = "#datemode#">		
	
	</cfif>	   
		   
	<tr><td height="1"></td></tr>	   
	
	</table>

</cfform>

<cfset ajaxonload("doCalendar")>
