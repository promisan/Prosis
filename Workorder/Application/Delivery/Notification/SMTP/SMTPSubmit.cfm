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
<cfparam name="URL.Txt"     default="">
<cfparam name="URL.Mission" default="Kuntz">

<cfinclude template="../../../../../Tools/EntityAction/Report/strFunctions.cfm">

<cfset fname = "#DateFormat(now(),"dd-mm-yyyy")#-#TimeFormat(Now(), 'hh-mm-ss')#.txt">

<cfset dateValue = "">
<CF_DateConvert Value="#url.dts#">
<cfset DTS = dateValue>

<cfoutput>

<cfset vMessageOriginal = URL.Txt>
<cfset CLIENT.SMS = URL.Txt>
	
<cfset vResponse = "">

<cfset SESSION.csmtp = 	Form.csmtp>

<cfloop from="1" to=#ListLen(Form.csmtp)# index="i"> 
	
		<cfset To_Send = "">
		<cfset workorder = ListGetAt(Form.csmtp, i)> 
		<cfset WorOrder = Replace(WorkOrder,"{","","all")>
		<cfset WorOrder = Replace(WorkOrder,"}","","all")>		
		
		<cfset WorkOrderId   = ListGetAt(workOrder, 1,"|")> 
		<cfset WorkOrderLine = ListGetAt(workOrder, 2,"|")> 
		<cfset veMailAddress = ListGetAt(workOrder, 3,"|")> 
					
		<cfquery name="qMessage" datasource="AppsWorkOrder">
		
			SELECT  			        
					A.WorkActionId, 
					WL.WorkOrderLine,   
					C.CustomerName, 
					C.PostalCode, 
					C.Address, 
					C.MobileNumber,
					C.emailAddress, 
					C.City, 
					PL.DateTimePlanning, 
					PL.LastName, 
					PL.PlanOrderCode,
					PL.PlanOrderDescription,
					W.WorkOrderId, 
					O.OrgUnitName, 				
					W.Reference
					
			FROM    WorkOrder AS W 
					INNER JOIN WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId 
					INNER JOIN Customer AS C ON W.CustomerId = C.CustomerId 
					INNER JOIN WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine 
					LEFT OUTER JOIN	Organization.dbo.Organization AS O ON W.OrgUnitOwner = O.OrgUnit 
					
					INNER JOIN
								 
				 	(
				 
				    SELECT  W.WorkPlanId, D.WorkActionId, D.PlanOrder, D.PlanOrderCode, PO.Description as PlanOrderDescription, W.PersonNo, P.LastName, P.FirstName, D.DateTimePlanning
				    FROM    WorkPlan AS W INNER JOIN
                            WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId INNER JOIN
                            Employee.dbo.Person AS P ON W.PersonNo = P.PersonNo INNER JOIN Ref_PlanOrder PO ON PO.Code= D.PlanOrderCode
					WHERE   W.Mission = '#url.mission#' 
					AND     W.DateEffective  <= #dts# 
					AND     W.DateExpiration >= #dts# 					
					AND     D.WorkActionId IS NOT NULL ) PL ON A.WorkActionId = PL.WorkActionId
									
					  
			WHERE   A.ActionClass    = 'Delivery' 		
			AND     W.Mission        = '#url.mission#'					
						
			AND     W.WorkOrderId    = '#WorkOrderId#'
			AND     WL.WorkOrderLine = '#WorkOrderLine#'
				
	    </cfquery>		
		
		<cfquery name="three" datasource="AppsWorkOrder">
			SELECT    WT.TopicValue
			FROM      WorkPlanDetail AS WD INNER JOIN
        	          WorkPlanTopic AS WT ON WD.WorkPlanId = WT.WorkPlanId
			WHERE     WD.WorkActionId = '#qMessage.WorkActionId#'    
		</cfquery>			
			
		<cfif qMessage.recordcount neq 0 and three.recordcount neq 0>			
			
				<cfif IsValid("email", veMailAddress)>
				
					<cfset vCustomerName = TCase(qMessage.CustomerName)> 
					<cfset vCustomerName = Replace (vCustomerName, "Van", "van")>
			
					<cfset vDriverTel    = Replace (Three.TopicValue," ","","ALL")>
					<cfset vTime         = qMessage.PlanOrderDescription>
					<cfset vDate         = DateFormat(qMessage.DateTimePlanning,CLIENT.DateFormatShow)>
					
					<cfset To_Send = Replace(vMessageOriginal, "@CNAME@", vCustomerName )>
					<cfset To_Send = Replace(To_Send, "@BRANCH@", qMessage.OrgUnitName)>			
					<cfset To_Send = Replace(To_Send, "@DELIVERYTIME@",#vTime#)>
					<cfset To_Send = Replace(To_Send, "@DRIVER@", qMessage.Lastname)>
					<cfset To_Send = Replace(To_Send, "@DRIVERTEL@", #vDriverTel#)>
	
					<cfquery name="Logo" datasource="AppsInit">
					  SELECT * FROM Parameter
					  WHERE  HostName  = '#CGI.HTTP_HOST#' 
					</cfquery>					
													
					<cfsavecontent variable="bemail">	
						<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
						<html xmlns="http://www.w3.org/1999/xhtml">
						<head>
							<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
							<title>#url.mission#- Delivery Scheduler</title>
						</head>
						<cfset language = "NED">
						
						<body>
												
						<div style="width:95%px;margin:auto">
						<table width="600" border="0" cellspacing="0" cellpadding="0" background="cid:back" style="background-position: left bottom;">
						  <tr valign="top">
						  	<td width="100%">
						  		<table width="100%" border="0" cellpadding="0" cellspacing="0">
						  		<tr valign="top">
						  			<td style="padding-left:4px">
										<table>
										<tr><td style="padding-top:10px;padding-left:10px"><img style="margin:auto;" src="cid:logo"  width="175" height="45" /></td></tr>
										<tr><td style="padding-left:10px">
								  		<p style="font-family: Calibri;text-align:left;font-size:16px;color:##144260;">
										<cfquery name="address" datasource="AppsWorkOrder">
											SELECT   OA.OrgUnit, 
											         OA.AddressId, 
													 OA.AddressType, 
													 OA.TelephoneNo, 
													 OA.MobileNo, 
													 OA.webURL, 
													 OA.Contact, 
													 OA.ContactDOB, 							
													 A.Address, 
													 A.Address2, 
									                 A.AddressCity, 
													 A.AddressRoom, 
													 A.State, 
													 A.Country, 
													 A.AddressPostalCode
											FROM     Organization.dbo.OrganizationAddress AS OA INNER JOIN
								            	     System.dbo.Ref_Address AS A ON OA.AddressId = A.AddressId
											WHERE    OA.OrgUnit =
									                          (SELECT   TOP (1) OrgUnit
									                            FROM    Organization.dbo.Organization
									                            WHERE   Mission = '#url.mission#' 
															    AND     TreeUnit = '1')
										</cfquery>		
										<br>		
										#address.address#
										<br>
										#address.AddressPostalCode# #Address.AddressCity#
										<br>
										#address.TelephoneNo#
										<br>
										<a href="#address.weburl#">#address.weburl#</a>		
										<br>
										<cf_tl language="#language#" id="Our number">:&nbsp;#qMessage.reference#												
								  		</p>	
										</td></tr>
										</table>
							  		</td>		  		
						  		</tr> 
						  		</table>
						  	</td>
						  </tr>
						  <tr>
						    <td>
						    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
						      <tbody>
						        <tr height="40" valign="top" style="padding-top:50px">         
						          <td><p style="font-family: Calibri;padding-left:15px;font-size:18px;margin:0;color:##333333;">#Address.AddressCity#, #vDate#</p></td>
						        </tr>
						        <tr valign="top">         
						          <td><p style="padding-top:20px;font-family: Calibri;padding-left:15px;font-size:18px;margin:0;color:##333333;">#To_Send#</p></td>
						        </tr>
						        <tr>        
						          <td align="left"><p style="padding-top:40px;padding-left:15px;font-family: Calibri;font-size:18px;margin:0;color:##333333;">#url.mission# <cf_tl language="#language#" id="Administration"></p></td>
						        </tr>		
						        <tr>
						          <td colspan="3" style="padding-top:50px">
								    <cf_maildisclaimer language="#language#" context="Delivery" id="#qMessage.WorkActionId#">			     
						          </td>
						        </tr>             
						      </tbody>
						    </table>
						    </td>
						  </tr>
						</table>
						</div>
						</body>
						</html>
					</cfsavecontent>		
				
				<cfset from   = "#Logo.SystemContact# (#Logo.SystemContactEMail#)">		
				<cfset sendTo = "dev@email">		
						
				<cf_tl id="Delivery" var="qdelivery" languagecode="#language#">
								
					<cfmail
						FROM        = "#from#"
						TO          = "#sendTo#"			
						subject     = "#ucase(qdelivery)# #ucase(qMessage.OrgUnitName)#" 
						replyto     = "#from#"
						FAILTO      = "#Logo.SystemContactEMail#"
						mailerID    = "Messenger"
						TYPE        = "html"
						spoolEnable = "No"                                        
						wraptext    = "100">					
						#bemail#	
						<cfmailparam file="#SESSION.root#/#Logo.LogoRoot#/#Logo.LogoFileName#" contentid="logo" disposition="inline"/>		
						<cfmailparam file="#session.root#/workorder/application/delivery/Notification/SMTP/background.png" contentid="back" disposition="inline"/>				
					</cfmail>	
					
					<cf_getLocalTime Mission="#url.mission#">				
					<cfset vNotification = localtime>
							
					<cfquery name="qOrder" datasource="AppsWorkOrder">
						INSERT INTO WorkOrderLineAction 
						     (WorkOrderId, 
							  WorkOrderLine, 
							  ActionClass,
							  DateTimePlanning, 
							  DateTimeActual, 
							  ActionMemo,
							  OfficerUserId,
							  OfficerLastName, 
							  OfficerFirstName)
						VALUES  ('#WorkOrderId#',
						         '#WorkOrderLine#',
								 'Notification',
								 #vNotification#,
								 #vNotification#,
								 '#To_Send#',
								 '#session.acc#',
								 '#session.last#',
								 '#session.first#')
					</cfquery>					
							
			</cfif>
			
		</cfif>			
			
</cfloop>


<script>
	ColdFusion.Window.hide('bb_wait');
	ColdFusion.Window.create('bb_response', 'PROSIS eMail Service','Notification/SMTP/SMTPProcessingResponse.cfm?txt=',{height:590,width:350,modal:true,closable:true,draggable:true,resizable:true,center:true,initshow:true })
	ColdFusion.navigate('Notification/SMTP/SMTPProcessingResponse.cfm?txt=display','bb_response');
	notification('smtp');
</script>

</cfoutput>
