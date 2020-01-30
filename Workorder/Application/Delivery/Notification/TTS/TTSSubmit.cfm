<cfparam name="URL.Txt" default="">
<cfparam name="URL.Mission" default="Kuntz">

<cfinclude template="../../../../../Tools/EntityAction/Report/strFunctions.cfm">

<cfset fname = "#DateFormat(now(),"dd-mm-yyyy")#-#TimeFormat(Now(), 'hh-mm-ss')#.txt">

<cfset dateValue = "">
<CF_DateConvert Value="#url.dts#">
<cfset DTS = dateValue>


<cfif not DirectoryExists("#SESSION.rootPath#\CFRStage\user\#SESSION.acc#\Logs\")>
  	<cftry>
	   <cfdirectory 
	     action="CREATE" 
	           directory="#SESSION.rootPath#\CFRStage\user\#SESSION.acc#\Logs\">
	<cfcatch></cfcatch>
	</cftry>
</cfif>

<cffile action = "write" file = "#SESSION.rootPath#\CFRStage\user\#SESSION.acc#\Logs\#fname#" attributes = normal output = "TTS tool, #DateFormat(now(),CLIENT.DateFormatShow)# , #TimeFormat(Now(), 'medium')# <br><br>">  


<cfoutput>

	<cfset vMessageOriginal = URL.Txt>
	<cfset CLIENT.SMS = URL.Txt>
	
	<cfset vResponse = "">
	
	<cfloop from="1" to = "#ListLen(Form.CTTS)#" index="i"> 
	
		<cfset To_Send = "">
		<cfset workorder = ListGetAt(Form.CTTS, i)> 
		<cfset WorOrder = Replace(WorkOrder,"{","","all")>
		<cfset WorOrder = Replace(WorkOrder,"}","","all")>		
		
		<cfset WorkOrderId   = ListGetAt(workOrder, 1,"|")> 
		<cfset WorkOrderLine = ListGetAt(workOrder, 2,"|")> 
		<cfset Mobile        = ListGetAt(workOrder, 3,"|")> 
					
		<cfquery name="qMessage" datasource="AppsWorkOrder">
		SELECT  TOP 10 
				A.WorkActionId,
				WL.WorkOrderLine,   
				C.CustomerName, 
				C.PostalCode, 
				C.Address, 
				C.MobileNumber, 
				C.City, 
				A.DateTimePlanning, 
				Drv.LastName, 
				PL.PlanOrderCode,
				PL.PlanOrderDescription,				
				W.WorkOrderId, 
				O.OrgUnitName, 				
				W.Reference
				FROM  WorkOrder AS W INNER JOIN
				WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
				Customer AS C ON W.CustomerId = C.CustomerId INNER JOIN
				WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine LEFT OUTER JOIN
				Organization.dbo.Organization AS O ON W.OrgUnitOwner = O.OrgUnit 
				
				INNER JOIN
								 
				 	(
				 
				    SELECT  W.WorkPlanId, D.WorkActionId, D.PlanOrder, D.PlanOrderCode,PO.Description as PlanOrderDescription,  W.PersonNo, P.LastName, P.FirstName, D.DateTimePlanning
				    FROM    WorkPlan AS W INNER JOIN
                            WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId INNER JOIN
                            Employee.dbo.Person AS P ON W.PersonNo = P.PersonNo INNER JOIN Ref_PlanOrder PO ON PO.Code= D.PlanOrderCode
					WHERE   W.Mission = '#url.mission#' 
					AND     W.DateEffective  <= #dts# 
					AND     W.DateExpiration >= #dts# 					
					AND     D.WorkActionId IS NOT NULL ) PL ON A.WorkActionId = PL.WorkActionId
				
				WHERE   A.ActionClass = 'Delivery' 		
				AND     W.Mission     = '#url.mission#'									
				AND     W.WorkOrderId    = '#WorkOrderId#'
				AND     WL.WorkOrderLine = '#WorkOrderLine#'
		    </cfquery>		
		
			<cfquery name="three" datasource="AppsWorkOrder">
				SELECT TopicValue 
				FROM   WorkOrderLineTopic
				WHERE  WorkOrderId   = '#workOrderId#'
				AND    WorkOrderLine = '#WorkOrderLine#'
				AND    Topic='f004' 
				AND    Operational = 1
			</cfquery>
			
	
		<cfif qMessage.recordcount neq 0 and three.recordcount neq 0>
			
			<cfset Mobile = Replace (Mobile," ","","ALL")>
			<cfset Mobile = Replace (Mobile,"-","","ALL")>
			<cfset Mobile = Replace (Mobile,"_","","ALL")>
			<cfset Mobile = Replace (Mobile,"(0)","","ALL")>
			<cfset Mobile = Replace (Mobile,"(","","ALL")>					
			<cfset Mobile = Replace (Mobile,")","","ALL")>		
			<cfset Mobile = Replace (Mobile,"+","","ALL")>				
			<cfset Mobile = REReplace(Mobile,"[#chr(10)#|#chr(13)#]","","ALL")>
   			<cfset Mobile = REReplace(Mobile,'<[^>]*>','','all')>				
			
			<cfset add = 0>
			
			<!--- ORIGINAL : 003106,03106,3106,00316,0316,316 
			<cfset ToRemove = "003106,00316,316,3106">
			<cfloop list="#ToRemove#" index="series">
				#series#<br>
				<cfif Find(series,Mobile) neq 0 and Find(series,Mobile) lte 3>
					<cfset Mobile = Replace (Mobile,series,"","")>						
					<cfset add = 1>
					<cfbreak>
				</cfif>
			</cfloop>
						
			<cfif add>
                <cfset Mobile = "00316" & Mobile>                       
            </cfif>      

			<cfset Mobile = Replace (Mobile," ","","ALL")>					
			--->		
			
			<cfif Len(Mobile) gt 10>
				<cfset vCustomerName = TCase(qMessage.CustomerName)> 
				<cfset vCustomerName = Replace (vCustomerName, "Van", "van")>
		
				<cfset vDriverTel = Replace (Three.TopicValue," ","","ALL")>
				<cfset vTime = qMessage.PlanOrderDescription>
				
				<cfset To_Send = Replace(vMessageOriginal, "@CNAME@", vCustomerName )>
				<cfset To_Send = Replace(To_Send, "@BRANCH@", qMessage.OrgUnitName)>			
				<cfset To_Send = Replace(To_Send, "@DELIVERYTIME@",#vTime#)>
				<cfset To_Send = Replace(To_Send, "@DRIVER@", qMessage.Lastname)>
				<cfset To_Send = Replace(To_Send, "@DRIVERTEL@", #vDriverTel#)>
				<!---  Now it is time to invoke the HTTP REQUESTER a la Xythos mode--->
								
				<cfset objHttpSession = CreateObject( 
					"component", 
					"Service.ServerDocument.CFHTTPSession" 
					).Init() 
				/>			
									
				<cfset objHttpSession = objHttpSession
					.NewRequest( "api.messagebird.com/xml/sms" )
					.AddUrl("username", "kuntzbv" )		
					.AddUrl("password", "kuntzbv" )						
					.AddUrl("originator", "KuntzBV" )	
					.AddUrl("recipients", Mobile )					
					.AddUrl("message", Left(to_Send,160))				
					.AddUrl("gateway", 8)	
					.AddUrl("responsetype", "xml")																						
					.Get()/>					


				<cftry>
						<cfset soapResponse = xmlParse(objHttpSession.fileContent) />
						
						<cfset responseNodes = xmlSearch(
						soapResponse,
						"//*[ local-name() = 'response' ]"
						) />			
						
						<cfset Provider_Response_Code = xmlParse(ResponseNodes[1].item.resultcode)>			
						<cfset Provider_Response_Text = xmlParse(ResponseNodes[1].item.resultmessage)>						
						
						<cfset vResultCode = Provider_Response_Code[1].XmlRoot.XmlText>
						<cfset vResultMessage = Provider_Response_Text[1].XmlRoot.XmlText>
		
						<cfif Find("200",objHttpSession.StatusCode) neq 0>
							<cfif vResultCode eq 10>
								<cfset vResponse = "(#vResultCode#) TTS sent succesfully to #Mobile#">		
								
								<cf_getLocalTime Mission="#url.mission#">				
								<cfset vNotification = localtime>
												
								<cfquery name="two" datasource="AppsWorkOrder">
								
								INSERT INTO WorkOrderLineAction
									     (WorkOrderId, 
										  WorkOrderLine, 
										  ActionClass,
										  DateTimePlanning, 
										  DateTimeActual, 
										  ActionMemo,
										  OfficerUserId,
										  OfficerLastName, 
										  OfficerFirstName )
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
								
								<cfelseif vResultCode eq 25>	
								<cfset vResponse =  "Failed: (#vResultCode#) Nmr onjuist! in sending to #Mobile#">
							<cfelseif vResultCode eq 27 >	
								<cfset vResponse =  "Failed: (#vResultCode#) Msg Fout! in sending to #Mobile#">
							<cfelseif vResultCode eq 31>	
								<cfset vResponse =  "Failed: (#vResultCode#) Credits op! in sending to #Mobile#">
							<cfelseif vResultCode eq 98>	
								<cfset vResponse =  "Failed: (#vResultCode#) Mollie down! in sending to #Mobile#">
							<cfelse>
								<cfset vResponse = "Failed: (#vResultCode#) #vResultMessage# #Mobile#">
							</cfif>
						<cfelse>
							<cfset vResponse = "Server seems unavailable">		
						</cfif>
					<cfcatch>
						<cffile action = "append" file = "#SESSION.rootPath#\CFRStage\user\#SESSION.acc#\Logs\#fname#" attributes = normal output = "Error connecting<br>">	
						<cfset vResponse = "">
					</cfcatch>	
					</cftry>	
			<cfelse>
				<cfset vResponse = "Skipped #Mobile#">		
			</cfif>

		</cfif>	
				
		<cffile action = "append" file = "#SESSION.rootPath#\CFRStage\user\#SESSION.acc#\Logs\#fname#" attributes = normal output = "#vResponse#<br>">	
		<cfset vResponse = "">
			
	</cfloop>

</cfoutput>

<cfoutput>
<script>
	ColdFusion.Window.hide('bb_wait');
	ColdFusion.Window.create('bb_response', 'PROSIS TTS','TTS/TTSProcessingResponse.cfm?txt=',{height:555,width:310,modal:true,closable:true,draggable:true,resizable:true,center:true,initshow:true })
	ColdFusion.navigate('TTS/TTSProcessingResponse.cfm?txt=#fname#','bb_response');
	notification('tts');
</script>
</cfoutput>


<!---- 
Armin 0050258747823
Ferry 0310651587561
--->