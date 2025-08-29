<!--
    Copyright © 2025 Promisan B.V.

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
<!--- ------------------------------------------ --->
<!--- --Consult service for Medical data entry-- --->
<!--- ------------------------------------------ --->
<!--- ------------------------------------------ --->

<cfparam name="url.requestid"     default="">
<cfparam name="url.workorderid"   default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.workorderline" default="1">
<cfparam name="url.orgunit"       default="">
<cfparam name="url.date"          default="#dateformat(now(),client.dateformatshow)#">
<cfparam name="url.scope"         default="entry">
<cfparam name="url.serviceitem"   default="#type.code#">
<cfparam name="url.mode"          default="edit">
<cfparam name="url.personNo"      default="0">
<cfparam name="url.schedule"      default="1">

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
					PER.FullName AS PersonNoName,
					ISNULL((Select PersonNo from Employee.dbo.PErson WHERE PersonNo ='#url.personNo#'),WL.PersonNo) as PersonNo1,
					ISNULL((Select FullName from Employee.dbo.PErson WHERE PersonNo ='#url.personNo#'),PER.FullName) as PErsonNoName1
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

	<cfset LastWorkOrderId        = url.WorkOrderId>
	<cfset LastWorkOrderLine      = url.WorkOrderLine>
	
	<cfquery name="Last" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
		 SELECT     TOP 1 *, 
		            ADM.OrgUnitName AS OrgUnitOwnerName, 
					IMP.OrgUnitName AS OrgUnitImplementerName, 
					PER.FullName AS PersonNoName,
					ISNULL((Select PersonNo from Employee.dbo.PErson WHERE PersonNo ='#url.personNo#'),WL.PersonNo) as PersonNo1,
					ISNULL((Select FullName from Employee.dbo.PErson WHERE PersonNo ='#url.personNo#'),PER.FullName) as PErsonNoName1
		FROM        WorkOrder W INNER JOIN
	                WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
	                Organization.dbo.Organization ADM ON W.OrgUnitOwner = ADM.OrgUnit INNER JOIN
	                Organization.dbo.Organization IMP ON WL.OrgUnitImplementer = IMP.OrgUnit LEFT OUTER JOIN
	                Employee.dbo.Person PER ON WL.PersonNo = PER.PersonNo
		WHERE       W.CustomerId = '#url.Customerid#'
		ORDER BY    W.Created DESC
	 
	</cfquery>	
	
	<cfif Last.recordcount eq "1">
			
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
								
			<!--- specific for A --->
			
			<cfquery name="topic" 
			 datasource="AppsSelection" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">	
			 
				SELECT    TopicValue
				FROM      ApplicantSubmissionTopic
				WHERE     Topic = 'MED102' <!--- specific for A 7/10/2016 --->
				AND       ApplicantNo IN (SELECT ApplicantNo 
				                          FROM   ApplicantSubmission 
										  WHERE  PersonNo= '#customer.personno#')
				ORDER BY  Created DESC
				
			</cfquery>
			
			<cfset lastServiceDomainClass = topic.TopicValue>			
						
			<cfif lastServiceDomainClass eq "">			
				<cfset lastServiceDomainClass = Last.ServiceDomainClass>
			</cfif>
			
		</cfif>	
		
</cfif>

<style>
  .acell{text-align:center;border-left:1px solid silver;padding-left:2px;padding-right:2px;font-size:13px;min-width:30}
  .bcell{text-align:center;border-left:1px solid silver;padding-left:2px;padding-right:2px;font-size:14px;min-width:40}
  .ccell{min-width:20px;padding-top:2px;padding-left:2px;}
  .dcell{width:100%;padding-left:6px;padding-right:4px;font-size:13px;}
  .ecell{font-size:12px;height:20px;}
  .fcell{font-size:12px;padding-top:2px;padding-left:4px;height:20px;min-width:12px;}
  .gcell{min-width:32px;font-size:12px;padding-top:2px;height:20px;}
  .hcell{font-size:15px;padding-left:11px;min-width:70px;}
  .icell{text-align:left;font-size:15px;padding-left:11px;width:100%;}
  .jcell{min-width:500px;text-align:left;padding-left:6px}
  .kcell{padding-top:1px;padding-left:6px;padding-right:6px;}
  .lcell{height:20px;padding-right:3px;width:100%;padding-left:2px;border-right:1px solid silver;}
  .atext{height:100%;background-color:ffffcf;border-top:0px;border-bottom:0px;width:100%;}
  TR.line td{padding-top:0px !important; padding-bottom:0px !important;}
</style>

<cfquery name="Line" 
 datasource="AppsWorkOrder" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT *
	FROM   WorkOrderLine
	WHERE  WorkOrderId   = '#url.workorderid#'		  
	AND    WorkOrderLine = '#url.workorderline#'				  
</cfquery>	

<cfform name="orderform" onsubmit="return false" style="height:99%;padding-left:15px">
	
	<cfoutput>
		<input type="hidden" name="ParentWorkOrderid"   value="#LastWorkOrderId#">
		<input type="hidden" name="ParentWorkOrderLine" value="#LastWorkOrderLine#">
	</cfoutput>
	
	<!--- there can be different rates basedon the topic + unit combinations --->
		
	<table style="min-width:1000px" class="formspacing">
		
	<tr class="hide"><td id="process"></td></tr>
	
	<cfif url.requestid neq "">
		
		<cfset url.mode = "view">
				
		<!--- the core of the core --->
		<cfinclude template="../../../Medical/Complaint/Create/DocumentFormRequestType.cfm">					
		
	    <!--- support the view mode here as well --->				
		<cfset url.inputclass = "regularxl">
		<cfset url.style      = "padding-left:4px">
		<cfinclude template="../../../Medical/Complaint/Create/DocumentFormTopic.cfm">			
		
		<cfset url.mode = "edit">
	
	</cfif>
	
	<tr>
		<td  style="padding-left:4px" class="labelmedium" width="25%"><cf_tl id="Request date">:</td>
		<td>
		 <table  cellspacing="0" cellpadding="0">
				 <tr><td>
						
			 <cf_intelliCalendarDate9
				FieldName="OrderDate" 
				class="regularxl"
				Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
				DateValidEnd="#Dateformat(now()+60, 'YYYYMMDD')#"
				AllowBlank="False">				
				
				</td>
				</tr>
		  </table>		
		
		</td>
	</tr>
	
	<tr>
		<td  style="padding-left:4px" class="labelmedium"><cf_tl id="Administrating Unit">:</td>
		<td>
			
	         <table  cellspacing="0" cellpadding="0">
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

	<cfquery name="qCurrency"
			datasource="AppsLedger"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      Currency
	</cfquery>

	<cfquery name="qBaseCurrency"
			datasource="AppsLedger"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT TOP 1 DocumentCurrency
			FROM Accounting.dbo.TransactionHeader
			WHERE TransactionSource = 'WorkOrderSeries'
			ORDER BY Created Desc
	</cfquery>

	<cfif qBaseCurrency.recordcount neq 0>
		<cfset vCurrency = qBaseCurrency.DocumentCurrency>
	<cfelse>
		<cfset vCurrency = application.basecurrency>
	</cfif>


	<cfif line.recordcount eq "0">
	
	<tr>
		<td style="padding-left:4px" class="labelmedium"><cf_tl id="Currency">:</td>
		<td>
		
		   <table cellspacing="0" cellpadding="0">
					<tr>
					<td>
			
				<select name="Currency" class="regularxl">
				<cfoutput query="qCurrency">
				    <option value="#Currency#" <cfif vCurrency eq currency>selected</cfif>>#Currency#</option>
				</cfoutput>
				</select>
				
				</td>
				</tr>
			</table>	
		
		</td>
	</tr>
	
	<cfelse>
	
	<tr>
		<td style="padding-left:4px" class="labelmedium"><cf_tl id="Currency">:</td>
		<td>
		
		   <table cellspacing="0" cellpadding="0">
					<tr>
					<td>
		

				<select name="Currency" class="regularxl">
				<cfoutput query="qCurrency">
				    <option value="#Currency#" <cfif vCurrency eq currency>selected</cfif>>#Currency#</option>
				</cfoutput>
				</select>
				
				</td>
				</tr>
			</table>	
		
		</td>
	</tr>
	
	</cfif>	
			
	<cfif url.orgunit eq "">
	
		<tr class="labelmedium">
			<td  style="padding-left:4px"><cf_tl id="Executing Unit">:</td>
			<td>	
			
			   <table cellspacing="0" cellpadding="0">
					<tr>
					<td>
			
				<cfquery name="Org" 
				 datasource="AppsOrganization" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					SELECT *
					FROM   Organization
					WHERE  OrgUnit IN (SELECT OrgUnitImplementer 
					                   FROM   WorkOrder.dbo.ServiceItemMissionOrgUnit 
									   WHERE  ServiceItem = '#url.serviceitem#'
									   AND    Mission     = '#url.mission#')					
				</cfquery>								
				
				<cfif Org.recordcount eq "0">
											
					<cfquery name="Org" 
					 datasource="AppsOrganization" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						SELECT *
						FROM   Organization
						WHERE  Mission   = '#URL.Mission#'		  					  
					</cfquery>	
				
				</cfif>
								
				<select name="orgunit2" class="regularxl">
				<cfoutput query="Org">
				    <option value="#orgunit#">#OrgUnitName#</option>
				</cfoutput>
				</select>
				
				</td>
				</tr>
				</table>
								
			</td>
		</tr>	
		
	
		<!---
		
		<tr>
			<td  style="padding-left:4px" height="34" class="labelmedium" width="15%"><cf_tl id="Executing Unit">:</td>
			<td>
			
				<table><tr><td>
				       
					 <cfinput type="text" name="orgunitname2" id="orgunitname2" 
					    value="#OrgUnitImplementerName#" 
						message="No unit selected" 
						required="Yes" 
						class="regularxl enterastab" 
						size="40" 
						maxlength="80" readonly>					  
					 
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
		
		--->
		
		<cfset selorg = url.orgunit>
	
	<cfelse>
	
		<tr class="labelmedium">
			<td  style="padding-left:4px"><cf_tl id="Executing Unit">:</td>
			<td>	
			
			   <table cellspacing="0" cellpadding="0">
					<tr>
					<td>
			
				<cfquery name="Org" 
				 datasource="AppsOrganization" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					SELECT *
					FROM   Organization
					WHERE  OrgUnit IN (SELECT OrgUnitImplementer 
					                   FROM   WorkOrder.dbo.ServiceItemMissionOrgUnit 
									   WHERE  ServiceItem = '#url.serviceitem#'
									   AND    Mission     = '#url.mission#')					
				</cfquery>								
				
				<cfif Org.recordcount eq "0">
											
					<cfquery name="Org" 
					 datasource="AppsOrganization" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						SELECT *
						FROM   Organization
						WHERE  OrgUnit   = '#URL.OrgUnit#'		  					  
					</cfquery>	
				
				</cfif>
								
				<select name="orgunit2" class="regularxl">
				<cfoutput query="Org">
				    <option value="#orgunit#" <cfif orgunit eq url.orgunit>selected</cfif>>#OrgUnitName#</option>
				</cfoutput>
				</select>
				
					</td>
					</tr>
				</table>
								
			</td>
		</tr>	
		
		<cfset selorg = org.orgunit>		
	
	</cfif>
	
	<tr class="labelmedium">
		<td style="padding-left:4px"><cf_tl id="Responsible Specialist">:</td>
		
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
							iconwidth  = "24"
							iconheight = "24"
							title      = "#lt_text#"
							link       = "#link#"						
							close      = "Yes"
							des1       = "PersonNo">
							
					</td>
					
					</tr>
				</table>		
			
		</td>
	</tr>
	
	<tr class="labelmedium"><td style="padding-left:4px" height="34"><cf_tl id="Activity">:</td>
		
		<cfquery name="ServiceArea" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			SELECT    *
			FROM      WorkOrderService P
			WHERE     ServiceDomain = '#type.servicedomain#'
			AND       EXISTS (SELECT 'X'
			                  FROM   WorkOrderServiceMissionItem
							  WHERE  ServiceDomain = P.ServiceDomain
							  AND    Reference     = P.Reference
							  AND    Mission       = '#url.mission#'
							  AND    ServiceItem   = '#url.serviceItem#')
			ORDER BY  ListingOrder,Reference 						
			
		</cfquery>		
		
		<cfif serviceArea.recordcount eq "0">
		
		<cfquery name="ServiceArea" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			SELECT    *
			FROM      WorkOrderService P
			WHERE     ServiceDomain = '#type.servicedomain#'			
			ORDER BY  ListingOrder,Reference 						
			
		</cfquery>		
		
		
		</cfif>
		
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
																								
				<select name="ServiceReference" id="ServiceReference" class="regularxl enterastab">
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
		<td style="padding-left:4px;min-width:166px" class="labelmedium"><cf_tl id="ReferenceNo">:</td>
		<td style="min-width:100%">
		<input type="text" class="regularxl enterastab" name="Reference" id="Reference" maxlength="20" style="width:100">	
		</td>
	</tr>
	
	<tr>
		<td  valign="top" style="padding-left:4px;padding-top:4px" height="34" class="labelmedium"><cf_tl id="Class">:</td>
					
		<cfquery name="DomainClass" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    * 
				FROM      Ref_ServiceItemDomainClass
				WHERE     ServiceDomain = '#Type.servicedomain#'	
				AND		  Code IN (
						SELECT 	ServiceDomainClass
						FROM 	ServiceItemUnit
						WHERE	ServiceDomain = '#Type.servicedomain#'
						AND		ServiceItem   = '#Type.code#'
							)
				AND       Operational = 1
				ORDER BY  ListingOrder   
			</cfquery>		
			
			<cfif DomainClass.recordcount eq "0">
			
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
			
			</cfif>		
			
			<cfif DomainClass.recordcount gte "1">
						
				<td>	
				
				 <table  cellspacing="0" cellpadding="0">
				 <tr><td>
								
								
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
																							
						<select name="ServiceDomainClass" id="ServiceDomainClass" class="regularxl enterastab">
						<cfoutput query="DomainClass">
						   <option value="#Code#" <cfif lastServiceDomainClass eq code or lastServiceDomainClass eq Description>selected</cfif>>#Description#</option>
						</cfoutput>					
						</select>
													
					</cfif>
					
					
				 </td>
				 
				 </tr>
				 
				 <tr>
				 
				 <td style="min-width:400px">
				    <cf_securediv id="custombox" bind="url:#session.root#/WorkOrder/Application/WorkOrder/Create/Medical/getCustomField.cfm?mission=#url.mission#&serviceitem=#url.serviceitem#&domainclass={ServiceDomainClass}">		
				 </td>
				 </tr>
				 
				 </table>
																				
				</td>	
						
			</cfif>	
			
	</tr>
		
	<tr>
		<td  style="padding-left:4px" class="labelmedium"><cf_tl id="Memo">:</td>
		<td>
		<input type="text" class="regularxl enterastab" name="OrderMemo" id="OrderMemo" style="width:80%">
		</td>
	</tr>
	
	<tr class="line">
		<td  height="34" colspan="2" style="padding-left:4px;height:30px;font-size:16px;font-weight:bold" class="labelmedium2" width="15%"><cf_tl id="Planned actions"></td>
	</tr>
			
	<!--- Note for the file : Dev 10/10/2016 ------------------------------------------------------- --->
	<!--- attention : if the implementing orgunit changes 
	     we should allow here to pass a different orgunit for the action fields : this is pending here --->
	<!--- -------------------------------------------------------------------------------------------- --->	 
		
	<cfif url.schedule eq "1">	
											
		<cfset datemode = "Planning">
								
		<cf_WorkOrderActionFields
	       mission           = "#url.mission#" 
	       serviceitem       = "#url.serviceitem#" 
		   workorderid       = "#url.workorderid#" 
		   workorderline     = "#url.workorderline#"
		   OrgUnit           = "#org.orgunit#"
		   PersonNo          = "#url.personno#"
		   CustomerId        = "#url.customerid#"
		   mode              = "edit"
		   calendar          = "9"	
		   time				 = "Yes"		
		   date              = "#url.date#"
		   padding           = "0"				  
		   actionrow         = "1"
		   actionfulfillment = "Schedule"	<!--- filters on a certain action only --->  
		   actiondatemode    = "#datemode#">	
		 
				   
	<cfelse>
	
		<cfset datemode = "Request">	
				
		<cf_WorkOrderActionFields
	       mission        = "#url.mission#" 
	       serviceitem    = "#url.serviceitem#" 
		   workorderid    = "#url.workorderid#" 
		   workorderline  = "#url.workorderline#"
		   OrgUnit        = "#org.orgunit#"
		   PersonNo       = "#url.personno#"
		   CustomerId     = "#url.customerid#"
		   mode           = "edit"
		   date           = "#url.date#"
		   calendar       = "9"		
		   padding        = "0"					  
		   actiondatemode = "#datemode#">		
	
	</cfif>	   
	
	<tr><td height="10"></td></tr>	   
	
	</table>
	

</cfform>

<cfset ajaxonload("doCalendar")>
