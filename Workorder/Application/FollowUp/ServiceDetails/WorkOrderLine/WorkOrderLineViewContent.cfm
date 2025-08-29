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
<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *, 
				 C.PersonNo      as CustomerPersonNo, 
				 WL.ActionStatus as BillingStatus
		FROM     WorkOrderLine WL INNER JOIN
		         WorkOrder W ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
		         Customer C ON W.CustomerId = C.CustomerId
		WHERE    WorkOrderLineId = '#url.drillid#'		
		AND      WL.Operational  = 1
</cfquery>		

<cfquery name="getwol" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM 	WorkOrderLine
		WHERE 	WorkOrderLineId = '#url.drillid#'
</cfquery>		

<cfparam name="url.mission"         default="#get.Mission#">
<cfparam name="url.workorderlineid" default="#url.drillid#"> 

 <cfset accessreset 	= "READ">

 <cfinvoke component = "Service.Access"  
	   method           = "WorkorderBiller" 
	   mission          = "#get.mission#" 
	   orgunit          = "#get.orgunitimplementer#"
	   serviceitem      = "#get.serviceitem#"  
	   returnvariable   = "accessreset">

<cfinvoke component  = "Service.Access"  
	method           = "WorkOrderProcessor" 
	mission          = "#get.mission#"  
	orgunit          = "#get.orgunitimplementer#"
	serviceitem      = "#get.serviceitem#"
	returnvariable   = "access">
	
<cfif access eq "EDIT" or access eq "ALL">
	<cfset editmode = "Edit">
<cfelse>
	<cfset editmode = "View">	
</cfif>	
						
<table width="100%">

	<tr><td style="padding-left:10px;padding-right:10px;padding-bottom:20px">
	
	<table width="100%">
		
	<!--- preparing the data 

	<cfquery name="ARSearchResult"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Accounting.dbo.TransactionHeader
		WHERE     TransactionCategory = 'Receivables' 
		AND       TransactionSource IN ('WorkOrderSeries','SalesSeries') 
		AND       ReferenceId IN ( SELECT   CustomerId
								   FROM     Customer
								   WHERE    PersonNo = '#get.CustomerPersonNo#'
								   UNION
								   SELECT   CustomerId
								   FROM     Materials.dbo.Customer
								   WHERE    PersonNo = '#get.CustomerPersonNo#' )										
	    AND       AmountOutstanding > 0.05
		AND       ActionStatus IN ('0','1') 
		AND       RecordStatus != '9'
		ORDER BY  Created DESC 	
		
	</cfquery>								  
	
	<cfif ARSearchResult.recordcount gte 1>
	
		<cfset StringToShow = "">
	
		<cfoutput query="ARSearchResult" group="currency">
    		<cfset totalOutStanding = 0>
    		<cfset thisCurrency = ARSearchResult.Currency>
    			<cfoutput>
					<cfset totalOutStanding = totalOutStanding+ARSearchResult.AmountOutStanding>
    			</cfoutput>
    		<cfset StringToShow = "#StringToShow##thisCurrency# #NumberFormat(totalOutStanding,',.__')#">
			
		</cfoutput>

		<tr><td class="labelmedium" style="padding-left:16px;cursor:pointer;font-size:22px">						
				<a href="javascript:$('.clsReceivablesDetail').toggle()"><cf_tl id="Outstanding"></a>
				<font color = "red"><cfoutput>#StringToShow#</cfoutput></font>
			</td>
		</tr>
		<tr class="clsReceivablesDetail" style="display:none;">
		    <td style="padding-left:6px;padding-top:1px"><cfinclude template="WorkOrderReceivable.cfm"></td>
		</tr>
		
	</cfif>			
	
	---->
	
	<cfquery name="line" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   WL.*,  
			         S.Description, 
					 SC.Description AS ServiceItemClass, 
			         (SELECT LastName FROM Employee.dbo.Person WHERE PersonNo = WL.PersonNo) as LastName
			FROM     WorkOrderLine WL INNER JOIN
		             WorkOrder W ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
	                 ServiceItem S ON W.ServiceItem = S.Code INNER JOIN
	                 Ref_ServiceItemDomainClass SC ON WL.ServiceDomain = SC.ServiceDomain AND WL.ServiceDomainClass = SC.Code
			WHERE    WorkOrderLineId = '#url.drillid#'		
		</cfquery>	
		
		
		
	<tr><td style="padding-left:15px;padding-right:15px">
	
	<table width="100%">
				
	<tr class="fixrow"><td>
		<table width="100%"><tr><td style="width:20px;padding-top:5px">
		<img src="<cfoutput>#session.root#</cfoutput>/images/go.png" height="23" width="25" alt="" border="0">
		</td>
		<td style="padding-left:10px;padding-top:3px;height:50px;font-size:30px;font-weight:200" class="labellarge">
		<cf_tl id="Observation for follow-up">
		</td>
		<td align="right" class="labelmedium">
			<table><tr><td style="padding-right:7px">
			<img src="<cfoutput>#session.root#</cfoutput>/images/addlarge.png" height="21" width="21" alt="" border="0">
			</td>
			<td class="labelmedium" style="padding-right:10px;padding-top:3px;height:50px;font-size:16px">
			<cfif editmode eq "Edit">
				<cfoutput>
				<a href="javascript:addworkorder('#get.mission#','#get.customerid#','#line.workorderid#','#line.workorderline#','embed')"><cf_tl id="Add Successive Observation"></a>
				</cfoutput>
			</cfif>
			</td></tr>
			</table>
		</td>		
		</tr>
		</table>
	</td></tr>				
						
	<tr class="labelmedium"><td style="padding-top:2px;padding-left:10px">
		 	
	<table width="100%" class="navigation_table">
	
		<tr class="labelmedium fixlengthlist">
		    <td style="width:1%">&nbsp;</td>
			<td><cf_tl id="StartDate"></td>
			<td><cf_tl id="Responsible"></td>
			<td width="55%"><cf_tl id="Service"></td>
			<td><cf_tl id="Recorded By"></td>					
		</tr>
		
		<cfset prior = "1">
		<cfset row = 0>
				
		<!--- ---------------------------------- --->
		<!--- ----------- EARLIER--------------- --->
		<!--- ---------------------------------- --->
		
		<cfloop condition="#prior# eq 1">
		
			<cfset row = row+1>			
			
			<cfif row gte "5">
				<cfset prior = "0">
			</cfif>
		
			<cfquery name="getChild" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     WorkOrderLine WL 
					WHERE    WL.ParentWorkOrderId   = '#Line.WorkOrderId#'		
					AND      WL.ParentWorkOrderLine = '#Line.WorkOrderLine#'
			</cfquery>	
			
				
			<cfif getChild.recordcount eq "0">
			
				<cfset prior = "0">
				
			<cfelse>
						
				<cfquery name="Line" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   WL.*, S.Description, 
							 SC.Description AS ServiceItemClass, 
							 WS.Description as ReferenceName,
					         (SELECT LastName FROM Employee.dbo.Person WHERE PersonNo = WL.PersonNo) as LastName
					FROM     WorkOrderLine WL INNER JOIN
				             WorkOrder W ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
							 WorkOrderService WS ON WL.ServiceDomain = WS.ServiceDomain AND WL.Reference = WS.Reference INNER JOIN
			                 ServiceItem S ON W.ServiceItem = S.Code INNER JOIN
	    		             Ref_ServiceItemDomainClass SC ON WL.ServiceDomain = SC.ServiceDomain AND WL.ServiceDomainClass = SC.Code
					WHERE    WL.WorkOrderId   = '#getChild.WorkOrderId#'		
					AND      WL.WorkOrderLine = '#getChild.WorkOrderLine#'
				</cfquery>	
				
				<cfif line.recordcount eq "0">
				
					<cfset prior = "0">
					
				<cfelse>
				
				<cfoutput>
				
				<cfif Line.Operational eq "1">
				
					<tr class="labelmedium2 navigation_row fixlengthlist">
					    <td width="20" align="right" style="height:20px;border-bottom:0px">								
						<cfif editmode eq "Edit">
							<cf_img icon="select" navigation="Yes"  onclick="lineopen('#line.workorderlineid#')">
						</cfif>
						</td>
					    <td style="color:gray;padding-left:3px">#dateformat(line.DateEffective,client.dateformatshow)#</td>
					    <td style="color:gray">#line.LastName#</td>
						<td style="color:gray">#Line.ReferenceName#: #line.serviceItemClass# </td>
						<td style="color:gray">#line.OfficerLastName# (#dateformat(line.Created,client.dateformatshow)#)</td>												
					</tr>	
				
				</cfif>	
								
				</cfoutput>
				
				</cfif>				
			
			</cfif>			
		
		</cfloop>
						
		<!--- ---------------------------------- --->
		<!--- ----------- THIS LINE ------------ --->
		<!--- ---------------------------------- --->
		
		<cfquery name="line" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   WL.*,  
			         S.Description, 
					 WS.Description as ReferenceName,
					 SC.Description AS ServiceItemClass, 
			         (SELECT LastName FROM Employee.dbo.Person WHERE PersonNo = WL.PersonNo) as LastName,
					 W.Mission,
					 A.PersonNo as ApplicantPersonNo
			FROM     WorkOrderLine WL INNER JOIN
		             WorkOrder W ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
					 WorkOrderService WS ON WL.ServiceDomain = WS.ServiceDomain AND WL.Reference = WS.Reference INNER JOIN
	                 ServiceItem S ON W.ServiceItem = S.Code INNER JOIN
	                 Ref_ServiceItemDomainClass SC ON WL.ServiceDomain = SC.ServiceDomain AND WL.ServiceDomainClass = SC.Code
					 LEFT OUTER JOIN Customer AS C
							ON W.CustomerId = C.CustomerId
						 LEFT OUTER JOIN Applicant.dbo.Applicant AS A
							ON C.PersonNo = A.PersonNo
			WHERE    WorkOrderLineId = '#url.drillid#'		
			AND      WL.Operational = 1
		</cfquery>	
				
				
		<cfoutput>		
					   			
			<tr class="labelmedium fixlengthlist">	
					
			    <td style="height:26px;padding-left:7px">	
		
					<table>
					<tr class="labelmedium">		
						<td>
							<cfset fields[1] = {criterianame = "mission",   criteriavalue = "#line.mission#" }>
							<cfset fields[2] = {criterianame = "patient",   criteriavalue = "#line.applicantPersonno#" }>  
							<cfset fields[3] = {criterianame = "reference",	criteriavalue = "#dateformat(Line.DateEffective,client.dateSQL)#" }>
							<cf_rptVariant SystemModule="WorkOrder"
			               		LayoutCode="Agenda" 
						   		ListCriteria="#fields#"
								Icon="Report/report.png"
								IconStyle="height:20px;">			
						</td>	
					<cfif Line.actionStatus lt "4" and editmode eq "Edit">
						<td style="padding-left:4px;padding-right:4px"><cf_img icon="edit" onclick="editForm('#line.workorderlineid#')"></td>
					</cfif>		
					
					<cfif Line.actionStatus lt "3" and editmode eq "Edit">
						<td><cf_img icon="delete" tooltip="Deactivate line" onclick="if (confirm('Remove line ?\n\nAttention this request can not be reversed!')) {ptoken.navigate('#session.root#/workorder/application/Medical/ServiceDetails/WorkOrderLine/deleteWorkOrderLine.cfm?drillid=#url.drillid#','process')}"></td>
					</cfif>		
					</td></tr>
					</table>	
						
				</td>
			    <td bgcolor="yellow" style="border-left:1px solid gray; border-top:1px solid gray; border-bottom:1px solid gray;padding-left:8px">#dateformat(Line.DateEffective,client.dateformatshow)#</td>
			    <td bgcolor="yellow" style="border-left:0px solid gray; border-top:1px solid gray; border-bottom:1px solid gray;padding-left:4px">#Line.LastName#</td>
				<td bgcolor="yellow" style="border-left:0px solid gray; border-top:1px solid gray; border-bottom:1px solid gray;padding-left:4px">#Line.Description# - #Line.ReferenceName#: #line.serviceItemClass#</td>
				<td bgcolor="yellow" style="border-right:1px solid gray; border-top:1px solid gray; border-bottom:1px solid gray;padding-left:4px" style="font-size:13px">#Line.OfficerLastName# (#dateformat(Line.Created,client.dateformatshow)#)</td>									
				
			</tr>	
			
			<tr><td height="4"></td></tr>					
								
			<!--- --------------------------------- --->
			<!--- show information from dbo.request --->
			<!--- --------------------------------- --->
			
			<cfset domainclass = line.servicedomainclass>
			
			<cfquery name="topics" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">				
				SELECT    TOP 200 R.Description, R.ListOrder, T.Topic, T.ListCode, T.TopicValue
				FROM      RequestTopic AS T INNER JOIN
				          RequestWorkOrder AS RW ON T.RequestId = RW.RequestId INNER JOIN
				          #Client.LanPrefix#Ref_Topic AS R ON T.Topic = R.Code
				WHERE     RW.WorkOrderId   = '#Line.WorkOrderid#' 
				AND       RW.WorkOrderLine = '#Line.WorkOrderLine#'
				ORDER BY  R.ListOrder				
			</cfquery>	
			
			<cfif topics.recordcount gte "1">
			
				<tr>		
				    <td></td>				   
					<td colspan="5" height="4">					
						<table width="100%" border="0" cellspacing="0" cellpadding="0">						
							<cfset row = 0>							
							<cfloop query="Topics">							
								<cfset row = row+1>
								<cfif row eq "1"><tr></cfif>						
									<td bgcolor="e4e4e4" class="labelmedium2" style="border:1px solid silver;padding-left:7px;padding-right:5px">#Description#:</td>
								    <td bgcolor="white" class="labelmedium2" style="border:1px solid silver;height:20px;padding-left:20px;padding-right:40px">#TopicValue#</td>										
								<cfif row eq "2"></tr><cfset row="0"></cfif>													
							</cfloop>
						</table>						
					</td>
				</tr>	
			
			</cfif>
							
			<!--- ------------------------------------- --->
			<!--- ------------------------------------- --->
			
			<cfset url.embed = "yes">
			<cfset url.workorderid   = Line.WorkOrderId>
			<cfset url.workorderline = Line.WorkOrderLine>
						
			<tr>
			  <td></td>
			  <td colspan="5" style="padding-left:0px;padding-right:0px">	
			     <!--- access is controlled already --->
				 
			     <cfset url.header = "No">
			     <cfinclude template="../../../WorkOrder/ServiceDetails/Action/WorkAction.cfm">
				 
			  </td>
			</tr>				
				
			<!--- ------------------------------------- --->
					
		</cfoutput>
												
		<!--- ---------------------------------- --->
		<!--- ----------- BEFORE --------------- --->
		<!--- ---------------------------------- --->
		
		<cfset next = "1">
		
		<cfloop condition="#next# eq 1">
				
			<cfif line.parentworkorderid eq "">
			
				<cfset next = "0">
				
			<cfelse>
			
				<cfquery name="line" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   WL.*, S.Description, 
							 SC.Description AS ServiceItemClass, 
					         (SELECT LastName FROM Employee.dbo.Person WHERE PersonNo = WL.PersonNo) as LastName
					FROM     WorkOrderLine WL INNER JOIN
				             WorkOrder W ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
			                 ServiceItem S ON W.ServiceItem = S.Code INNER JOIN
	    		             Ref_ServiceItemDomainClass SC ON WL.ServiceDomain = SC.ServiceDomain AND WL.ServiceDomainClass = SC.Code
					WHERE    WL.WorkOrderId   = '#Line.ParentWorkOrderId#'		
					AND      WL.WorkOrderLine = '#Line.ParentWorkOrderLine#'
				</cfquery>	
				
				<cfif line.recordcount eq "0">
				
					<cfset next = "0">
					
				<cfelse>
				
				<cfoutput>
				
					<cfif line.operational eq "1">
					
						<tr class="labelmedium2 navigation_row fixlengthlist">
						    <td align="right" width="20" style="height:20px;padding-top:3px;border-bottom:0px"><cf_img icon="select" navigation="Yes" onclick="lineopen('#Line.workorderlineid#')"></td>
						    <td style="color: gray; padding-left: 3px;">#dateformat(Line.DateEffective,client.dateformatshow)#</td>
						    <td style="color: gray; padding-left: 3px;">#Line.LastName#</td>
							<td style="color: gray; padding-left: 3px;">#Line.Description# #Line.serviceItemClass#</td>
							<td style="color: gray; padding-left: 3px;">#Line.OfficerLastName# (#dateformat(Line.Created,client.dateformatshow)#)</td>													
						</tr>	
						
						<!--- show information from request --->
						<cfquery name="topics" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">				
							SELECT    R.Description, R.ListOrder, T.Topic, T.ListCode, T.TopicValue
							FROM      RequestTopic AS T INNER JOIN
							          RequestWorkOrder AS RW ON T.RequestId = RW.RequestId INNER JOIN
							          #Client.LanPrefix#Ref_Topic AS R ON T.Topic = R.Code
							WHERE     RW.WorkOrderId = '#Line.WorkOrderid#' AND RW.WorkOrderLine = '#Line.WorkOrderLine#'
							ORDER BY R.ListOrder				
						</cfquery>	
						
						<cfif topics.recordcount gte "1">
						<tr bgcolor="FDFEDE" class="line">
						    <td></td>
							<td colspan="4" height="4" style="padding-left:2px">
						
							<table>						
								<cfset row = 0>
								
								<cfloop query="Topics">
								
									<cfset row = row+1>
									<cfif row eq "1"><tr class="labelmedium"></cfif>						
										<td>#Description#:</td>
									    <td style="padding-left:20px;padding-right:40px"><b>#TopicValue#</td>										
									<cfif row eq "2"></tr><cfset row="0"></cfif>	
													
								</cfloop>
							</table>		
						
						</td>
						</tr>	
						</cfif>
					
					</cfif>	
				
				</cfoutput>
				
				</cfif>				
			
			</cfif>	
				
		</cfloop>
	
	</table>
					
	</td></tr>
	
	<!--- this postion of the code
	that captures topics on the workorderline is going to be taken by the Composition object 31/12/2019 
	Hanno --->

	
	<tr><td height="10"></td></tr>			
				 
	<cfquery name="GetTopics" 
	  datasource="AppsWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT    *
	  FROM      Ref_Topic			 
	  WHERE     Code IN (SELECT Code 
	                     FROM   Ref_TopicServiceItem
					     WHERE  ServiceItem = '#get.ServiceItem#'
					     AND    ShowInContext IN ('Any','backoffice')
					  )
	  AND       (Mission = '#url.Mission#' or Mission is NULL)	   
	 		    			 
	  AND       Operational = 1   
	  AND       TopicClass = 'request'  
	  ORDER BY  ListingOrder   
	</cfquery>
	
	<cfif getTopics.recordcount gte "1">
									
	<tr class="fixrow"><td>
		<table><tr><td style="padding-top:5px">
		<img src="<cfoutput>#session.root#</cfoutput>/images/go.png" height="23" width="25px" alt="" border="0">
		</td>
		<td style="font-weight:200;padding-left:10px;padding-top:3px;height:45px;font-size:30px" class="labellarge"><cf_tl id="Subjective Information"></td>
		</tr>
		</table>
	</td></tr>	
	
	<!--- custom fields and saving --->			
		
	<tr><td height="30" style="padding-left:4px; padding-right:20px">
	
		<cfoutput>
	
		<cfform method="POST" name="customform">
		
		<table width="100%">	
				
			<tr><td style="padding-top:10px">
			<table width="100%" border="0" class="formpadding">
														
			    <cfset url.mode = editmode>
				<cfset url.inputclass = "regularxxl">
				<cfset url.topicclass = "request">
				<cfset url.style      = "min-width:400px;padding-left:65px;height:28px">
				<cfset url.serviceitem = get.ServiceItem>
				<cfset url.domainclass = DomainClass>
				<!--- Custom classification fields --->
				<cfinclude template="../../../WorkOrder/Create/CustomFields.cfm">	
			
			</table>	
			</td></tr>
			
			<cfif editmode eq "EDIT">
						
			<tr><td align="center" style="padding-top:10px;height:33px" id="custom">
			
			   <input type="button" 
				      style="font-size:15px;width:320;height:30px" 
					  name="close" 
					  value="Save" 
					  class="button10g" 
					  onclick="updateTextArea();Prosis.busy('yes');ptoken.navigate('setWorkOrderTopic.cfm?topicclass=request&workorderid=#url.workorderid#&workorderline=#url.workorderline#&domainclass=#domainclass#','custom','','','POST','customform')">
					  
			   </td>
		    </tr>  
			</cfif>
			
		</table>
		
		</cfform>	
		
		</cfoutput>
	
	</td></tr>  
	
	</cfif>
	
	<!---		
		
	<cfinvoke component  = "Service.Access"  
		method           = "WorkOrderBiller" 
		mission          = "#get.mission#"  
		orgunit          = "#get.orgunitimplementer#"
		serviceitem      = "#get.serviceitem#"
		returnvariable   = "accessbiller">	
		
	<cfset billingStatus = get.BillingStatus>	
							
	<cfif get.BillingStatus lt "3">
						
		<tr><td id="billing" colspan="2">
						
			<table width="100%">
			
				<tr class="fixrow">
					<td width="10" style="padding-top:5px"><img src="<cfoutput>#session.root#</cfoutput>/images/go.png" height="23" width="25px" alt="" border="0"></td>
					<td colspan="2" style="font-weight:200;padding-left:10px;padding-top:3px;height:40px;font-size:30px" class="labellarge"><cf_tl id="Provisioning"></td>					
				</tr>				
				
				<tr><td colspan="3" style="padding-left:35px;"><cfinclude template="WorkOrderPayer.cfm"></td></tr>			
						
				<tr class="clsPrintProvisioning">
					<td height="30" colspan="3" class="labelmedium" style="padding-left:25px;">
					<table width="100%"><tr><td style="border:0px solid silver;padding-right:2px;padding-left:10px;padding-bottom:6px">
					<!--- access in controlled in this subfunction, processor and funding --->					
					<cfinclude template="../../../WorkOrder/ServiceDetails/Billing/DetailBilling.cfm">						
					</td></tr></table>	
					</td>
				</tr>
								
			</table>
			
		</td></tr>					
							
		<!--- ------------------------------------- --->
		<!--- ------------------------------------- --->
		<!--- ------------------------------------- --->	
		
					
		<!--- access inherited from the above --->				
									
		<cfif accessbiller eq "EDIT" or accessbiller eq "ALL">
				
			<tr>	
			   <td align="center" style="padding-top:7px;padding-bottom:4px" class="labelmedium" id="applycharges">
			  				  			
			   <cf_tl id="Prepare Charges and Post Stock Consumption" var="1">
			
			   <cfoutput>	
			   				   
			   		  				   
			   		<input type="button"
					      onclick="_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('setCharges.cfm?workorderlineid=#url.drillid#','posting')" 
						  style="font-size:14px;width:470;height:30px;border:1px solid silver" 
						  name="close" 								  
						  value="#lt_text#" 
						  class="button10g">							  						
						  
			   </cfoutput>
			   
			   						  
			   </td>
		    </tr>    
		
		</cfif>
						
	</cfif>	
	
	--->
	
	<!--- show already posted amounts 
	
	<cfif accessbiller eq "EDIT" or accessbiller eq "ALL">
	
		<cfquery name="GetCharge" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT    *
			FROM      WorkOrderLineCharge
			WHERE     WorkOrderId   = '#get.WorkOrderid#'
			AND       WorkOrderLine = '#get.WorkOrderLine#'
			AND       Journal IS NOT NULL
		</cfquery>	
				
		<cfif getCharge.recordcount gte "0">
		
			<tr class="fixrow"><td class="labelmedium">	
							
			   <table>
			    <tr><td style="padding-top:5px">
					<img src="<cfoutput>#session.root#</cfoutput>/images/go.png" height="23" width="25px" alt="" border="0">
					</td>
					<td style="font-weight:200;padding-left:10px;padding-top:3px;height:45px;font-size:28px" class="labellarge">
						<cf_tl id="Charges"><span style="font-size:13px"><cf_tl id="in"><cfoutput>#get.Currency#</cfoutput></span>
					</td>
				</tr>
				</table>
				
				</td>
			</tr>
			
			<tr><td colspan="2" style="padding-left:30px;"><cfinclude template="WorkOrderPayer.cfm"></td></tr>			
				
			<tr>
				<td colspan="2" id="posting" style="padding-left:20px;padding-right:1px">		
				    <table width="100%"><tr><td style="border:0px solid silver;padding-top:0px;padding-left:8px">	
					<cfset post = "0">					
					<cfinclude template="WorkOrderLinePosting.cfm">
					</td></tr>	
					</table>
				</td>
			</tr>										
					
		</cfif>
		
	</cfif>	
	
	--->
	
	<!--- ------------------------------------- --->
	<!--- ------------------------------------- --->
	<!--- ------------------------------------- 	
					
	<cfif accessbiller eq "ALL" and BillingStatus gte "3">
		<table width="100%">
				<tr align="left">
				<div id="resetlinebill" name="resetlinebill"></div>
				<cfoutput>
				<td height="7" style="padding-left:38px" class="labellarge"><a href="javascript:resetlinebillingdetail('#getwol.workorderid#','#getwol.workorderline#','')"><font color="008000"><cf_tl id="Reopen for Billing"></font></a></td>
				</cfoutput>
			</tr>
		</table>					
	</cfif>	
		
	--->	
	
	<tr><td id="mybottom"></td></tr>	
					
	</table>
	</td></tr>	
	
	</table>

</td></tr>	
	
</table>
		