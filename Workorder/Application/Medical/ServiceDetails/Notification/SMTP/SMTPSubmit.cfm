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
<cfparam name="URL.dts"     default="">

<cfset dateValue = "">
<CF_DateConvert Value="#url.dts#">
<cfset DTS = dateValue>

<cfoutput>

<cfset vMessageOriginal = FORM.end_text>
<cfset SESSION.SMTP = FORM.end_text>

	
<cfset vResponse = "">

<cfset SESSION.csmtp = 	Form.csmtp>

<cfquery name="qMission" datasource="AppsOrganization">
	SELECT * FROM Ref_Mission
	WHERE Mission='#URL.Mission#'
</cfquery>	


<cfloop from="1" to=#ListLen(Form.csmtp)# index="i"> 
	
		<cfset To_Send = "">
		<cfset workorder = ListGetAt(Form.csmtp, i)> 
		<cfset WorOrder = Replace(WorkOrder,"{","","all")>
		<cfset WorOrder = Replace(WorkOrder,"}","","all")>		
		
		<cfset WorkOrderId   = ListGetAt(workOrder, 1,"|")> 
		<cfset WorkOrderLine = ListGetAt(workOrder, 2,"|")> 
		<cfset veMailAddress = ListGetAt(workOrder, 3,"|")> 
					
		<cfquery name="qMessage" datasource="AppsWorkOrder">
		
		SELECT  A.WorkActionId,
				WL.WorkOrderLine,   
				AP.FirstName, 
				AP.LastName,
				AP.Gender,
				SI.Description as ItemDescription,
				SDC.Description as ClassDescription,
				C.PostalCode, 
				C.Address,
				AP.emailAddress, 
				C.PhoneNumber,
				C.MobileNumber, 
				C.City, 
				PL.DateTimePlanning,
				convert(varchar(8), convert(time, PL.DateTimePlanning)) as TimePlanning, 
				PL.LastName, 
				PL.PlanOrderCode,
				PL.PlanOrderDescription,
				W.WorkOrderId, 
				O.OrgUnitName, 				
				W.Reference,
				(
				SELECT count(1) 
				FROM   WorkOrderLineTopic
				WHERE   WorkOrderId   = WL.WorkOrderId
				AND     WorkOrderLine = WL.WorkOrderLine
				AND    Topic  = 'f010' 
				AND    Operational = 1
				) as NotificationEnabled,				
				
				(
				SELECT  COUNT(1)
				FROM    WorkOrderLineAction
				WHERE   WorkOrderId   = WL.WorkOrderId
				AND     WorkOrderLine = WL.WorkOrderLine
				AND     ActionClass IN (
							SELECT Code
							FROM Ref_Action
							WHERE ActionFulfillment = 'Message'
						)
				) as Notifications		
		
		FROM   WorkOrder AS W 
		       INNER JOIN WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId
			   INNER JOIN Customer AS C ON W.CustomerId = C.CustomerId
			   INNER JOIN Applicant.dbo.Applicant AP ON AP.PersonNo = C.PersonNo 
			   INNER JOIN WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine 			    		   
			   LEFT OUTER JOIN  Organization.dbo.Organization AS O ON W.OrgUnitOwner = O.OrgUnit
			   INNER JOIN ServiceItem SI ON SI.Code = W.Serviceitem
			   INNER JOIN Ref_ServiceItemDomainClass SDC ON SDC.Code = WL.ServiceDomainClass AND SDC.ServiceDomain = WL.ServiceDomain
			   <!--- actions that were put into a workplan; then we show them for the SMS --->
			    			   				 
			   INNER JOIN
								 
				 	(
				 
				    SELECT  W.WorkPlanId, D.WorkActionId, D.PlanOrder, D.PlanOrderCode, PO.Description as PlanOrderDescription,W.PersonNo, P.LastName, P.FirstName, D.DateTimePlanning
				    FROM    WorkPlan AS W INNER JOIN
                            WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId INNER JOIN
                            Employee.dbo.Person AS P ON W.PersonNo = P.PersonNo LEFT OUTER JOIN Ref_PlanOrder PO ON PO.Code= D.PlanOrderCode
					WHERE   W.Mission = '#url.mission#' 
					AND     D.WorkActionId IS NOT NULL ) PL ON A.WorkActionId = PL.WorkActionId
			   			   			  
		WHERE   W.Mission = '#url.mission#'	
		AND     A.ActionClass IN (
					SELECT Code
					FROM Ref_Action
					WHERE ActionFulfillment = 'Schedule'
				)
			

		AND     WL.Operational = '1'			  	   
	    AND     W.ActionStatus != 9
		AND     W.Mission        = '#url.mission#'					
		AND     W.WorkOrderId    = '#WorkOrderId#'
		AND     WL.WorkOrderLine = '#WorkOrderLine#'
	    </cfquery>		
		
			
		<cfif qMessage.recordcount neq 0>			

				<cfif IsValid("email", veMailAddress)>
				
					<cfif qMessage.Gender eq "M">
						<cfset vCustomerName = "Estimado #qMessage.FirstName# #qMessage.LastName#">
					<cfelse>
						<cfset vCustomerName = "Estimada #qMessage.FirstName# #qMessage.LastName#">
					</cfif> 
					<cfset vDate         = DateFormat(qMessage.DateTimePlanning,CLIENT.DateFormatShow)>
					<cfset vTime         = qMessage.TimePlanning>
					
					<cfset To_Send = Replace(vMessageOriginal, "@CNAME@", vCustomerName )>
					<cfset To_Send = Replace(To_Send, "@DELIVERYDATE@",vDate)>
					<cfset To_Send = Replace(To_Send, "@DELIVERYTIME@",vTime)>
					<cfset To_Send = Replace(To_Send, "@ITEM@",qMessage.ItemDescription)>
					<cfset To_Send = Replace(To_Send, "@CLASS@",qMessage.ClassDescription)>
	
					<cfquery name="Logo" datasource="AppsInit">
					  SELECT * FROM Parameter
					  WHERE  HostName  = '#CGI.HTTP_HOST#' 
					</cfquery>					


					<cfset mailatt = arrayNew(1)>
					
					<cfset mailatt[1] =  arrayNew(1)>
					<cfset mailatt[1][1]="#SESSION.root#/Images/Logos/Medical/Profile.png">
					<cfset mailatt[1][2]="inline">
					<cfset mailatt[1][3]="profile">
					
					<cfset mailatt[2] =  arrayNew(1)>								
					<cfset mailatt[2][1]="#SESSION.root#/Images/Logos/Medical/Address.png">
					<cfset mailatt[2][2]="inline">
					<cfset mailatt[2][3]="address">
					
					<cfset mailatt[3] =  arrayNew(1)>
					<cfset mailatt[3][1]="#SESSION.root#/Images/Logos/Medical/Complaints.png">
					<cfset mailatt[3][2]="inline">
					<cfset mailatt[3][3]="complaints">
					
					<cfset mailatt[4] =  arrayNew(1)>
					<cfset mailatt[4][1]="#SESSION.root#/Images/Logos/Medical/MedicalHistory.png">
					<cfset mailatt[4][2]="inline">
					<cfset mailatt[4][3]="medical">
													
					<cfsavecontent variable="bemail">	
						<?xml version="1.0" encoding="UTF-8">
						<!DOCTYPE html>
						<html>
						<head>
							<title>Recordatorio</title>
							<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
							<style>
							table {
								font-family:		Verdana;
								font-size:			12px;
								border-collapse: 	collapse;
								border-spacing:		0px;
								border:				1px;
								
							}
							
							.today {
								background-color:	##FCD1A7;
								font-weight:		bold;
							}
								
							</style>	
									
						</head>
						
						<body leftmargin="3" topmargin="3" rightmargin="3" bottommargin="3">
						<html>
							
								<table width="96%" align="center" style="font-family: Verdana; 	font-size:12px;">
								<tr>
								<td>
									<h2 align="center">
										Amable recordatorio	
									</h2>
								</td>
								</tr>
								<tr height="20px"><td></td></tr>
								<tr height="20px"><td></td></tr>	
								<tr>
									<td>
									#To_Send#
									</td>
								</tr>
								
								<tr>
								<td>	
								Reciba un cordial saludo,
								</td>
								</tr>
								
								<tr height="20px"><td></td></tr>
								
								<tr>
								<td align="center">
								Dr. Manuel A S&aacute;enz
								</td>
								</tr>
								
								<tr>
								<td align="center">
								Centro de Rodilla & Hombro de Guatemala
								</td>
								</tr>
							</table>
						
							
							<table style="font-family: Verdana; font-size:9px;">
								<tr height="20px"><td></td></tr>		
								<tr>
									<td style="font-weight:bold">
										Informaci&oacute;n sobre est&aacute;ndares de seguridad:
									</td>
								</tr>		
								<tr>
									<td>
										Nuestro Portal para Pacientes est&aacute; soportado por los navegadores Internet Explorer, Chrome, Edge desde diversos dispositivos; cuenta con una serie de medidas de seguridad para proteger los datos y la forma en que los equipos que acceden a nuestro sistema.  Estas medidas de seguridad proporcionan los siguientes beneficios:
									</td>
								</tr>		
								<tr>
									<td>
									a.	La conexi&oacute;n entre su equipo hacia nuestros servidores estar&aacute; encriptada (https).
									</td>
								</tr>		
								<tr>
									<td>
									b.	Cada p&aacute;gina de nuestro portal no puede ser compartida, evitando que los usuarios accedan a informaci&oacute;n confidencial que no les pertenezca a su propio perfil.
									</td>
								</tr>		
								<tr>
									<td>
									c.	Mayor informaci&oacute;n en la bit&aacute;cora de las acciones que los usuarios realizan en nuestro sistema.
									</td>
								</tr>		
							</table>
						</html>					
						</body>		

					</cfsavecontent>		
				
				
		
				<cfset sendTo = "#veMailAddress#">
				<cfset From   = "#SESSION.FROM#">		
						
					<cfmail
						FROM        = "#from#"
						TO          = "#sendTo#"			
						subject     = "#qMission.MissionName# - Amable recordatorio" 
						replyto     = "#from#"
						FAILTO      = "#Logo.SystemContactEMail#"
						mailerID    = "Messenger"
						TYPE        = "html"
						spoolEnable = "No"                                        
						wraptext    = "100">					
						#bemail#	
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
	ColdFusion.Window.create('bb_response', 'PROSIS eMail Service','../Notification/SMTP/SMTPProcessingResponse.cfm?txt=',{height:590,width:350,modal:true,closable:true,draggable:true,resizable:true,center:true,initshow:true })
	ColdFusion.navigate('../Notification/SMTP/SMTPProcessingResponse.cfm?txt=display','bb_response');
	notification('smtp');
</script>

</cfoutput>
