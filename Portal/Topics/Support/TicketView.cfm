
<cfquery name="param" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Parameter
</cfquery>	

<cfquery name="get" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	O.ObservationId,
				O.ObservationNo,
				O.Reference, 
				O.RequestName, 
				O.ObservationDate, 
				O.ObservationId,
				R.EntityStatus,
				R.StatusDescription,
				(	SELECT TOP 1 Created
					FROM	[#param.databaseserver#].Organization.dbo.OrganizationObjectActionMail
					WHERE   ObjectId = O.ObservationId 
					<cfif getAdministrator("*") eq "0">
					AND     MailScope = 'All'
					</cfif>
					AND		MailType = 'Comment'
					ORDER BY Created DESC
				) AS LastMessage,
				(	SELECT TOP 1 OfficerUserId
					FROM	[#param.databaseserver#].Organization.dbo.OrganizationObjectActionMail
					WHERE	ObjectId = O.ObservationId 
					AND		MailType = 'Comment'
					<cfif getAdministrator("*") eq "0">
					AND     MailScope = 'All'
					</cfif>
					ORDER BY Created DESC
				) AS LastMessageByAcc,
				(	SELECT TOP 1 OfficerLastName
					FROM	[#param.databaseserver#].Organization.dbo.OrganizationObjectActionMail
					WHERE	ObjectId = O.ObservationId 
					AND		MailType = 'Comment'
					<cfif getAdministrator("*") eq "0">
					AND     MailScope = 'All'
					</cfif>
					ORDER BY Created DESC
				) AS LastMessageBy,
				(	SELECT 	MAX(ActionTimeStamp) 
					FROM 	[#param.databaseserver#].Organization.dbo.UserActionEntity 
					WHERE 	ObjectId = O.ObservationId 
					AND 	Account = O.OfficerUserId) as LastAccess
		FROM	 Observation O 
				 INNER JOIN Organization.dbo.Ref_EntityStatus R ON O.ActionStatus = R.EntityStatus
		WHERE	 R.EntityCode       = 'SysTicket'
	---	AND		 O.ObservationClass = 'Inquiry'
		AND		 (O.ActionStatus     != '3' OR (ObservationId IN (SELECT OO.ObjectId 
		                                                        FROM   Organization.dbo.OrganizationObject OO, 
																       Organization.dbo.OrganizationObjectAction OOA
																WHERE  OO.ObjectKeyValue4 = O.ObservationId		
																AND    OO.ObjectId = OOA.ObjectId
																AND    OfficerDate > getDate() - 3) AND O.ActionStatus = '3'))
																
		AND		 O.Requester        = '#session.acc#' 
		ORDER BY O.ActionStatus, O.Created DESC
		
</cfquery>

<cfquery name="getGraph" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	 R.EntityStatus, R.StatusDescription as EntityStatusName, COUNT(*) AS Total
		FROM	 Observation O INNER JOIN Organization.dbo.Ref_EntityStatus R ON O.ActionStatus = R.EntityStatus
		WHERE	 R.EntityCode = 'SysTicket'
		<cfif get.recordcount neq "0">
		AND      ObservationId IN (#quotedvalueList(get.ObservationId)#)			
		<cfelse>
		AND      1=0
		</cfif>		
		GROUP BY R.EntityStatus,
				 R.StatusDescription
</cfquery>


<table width="99%" align="right">
   
   <tr><td height="7"></td></tr>
	<tr>
		<td style="border-bottom:1px solid silver">
		<table width="100%">
				
		 <tr class="labelmedium">
			<td width="100%" style="padding-left:20px">
		
			<table width="100%">
			<tr class="labelmedium">
			<td style="font-weight:200"><cf_tl id="Support or Amendment Tickets"></td>
			<td align="right" style="font-weight:200">
			<!--- <a href="javascript:supportticket('','System')">[<cf_tl id="Add Ticket">]</font></a> --->
			</td>
			<td align="right">
			<a href="javascript:amendmentticket('','System')"><cf_tl id="New Amendment Request"></a>
			</td>
			<!--- disabled --->
			<td align="right" style="padding-right:18px">
			<!---
			<cfoutput>			
				<a disabled href="javascript:ptoken.open('#SESSION.root#/System/AccessRequest/DocumentEntry.cfm?context=status&ts='+new Date().getTime(), '_blank');"><font color="gray"><i>[<cf_tl id="Request Access">]</font></a>
			</cfoutput>
			--->
			</td></tr>
			</table>
			
			</td>
						
			<td style="min-width:100px"><cf_tl id="Tasked officer"></td></td>
			<td style="min-width:170px"><cf_tl id="Last Comment Posted"></td></td>
		 </tr>
		 
		 </table>
		 </td>		
		 
		 <cfset list = "##5DB7E8,##E8875D,##E8BC5D,##E85DA2,##5DE8D8,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA">
		 <cfset listar = listtoArray(list)>		 
		 
		 <cfif get.recordcount gte "1">
				 
		 <td rowspan="2" valign="top" align="center" class="clsGraphSupportTicketContainer">
		 
			<table width="100%" align="center">
				<tr>
					<td align="center" class="labelmedium" style="color:#A6A6A6;"><cf_tl id="Pending Tickets by Status">					
					</td>
				</tr>
								
				<tr>
					<td align="center" style="padding-right:13px">
					
						<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
												
						<cfchart 
							name="TicketSupportChart"
							style="#chartStyleFile#" 
							format="png"
							fontsize="13" 							
							chartheight="270" 
							chartwidth="300">
							
								<cfchartseries type="pie"
						             query="getGraph"
					    	         itemcolumn="EntityStatusName"
					        	     valuecolumn="Total"
								     colorlist="#list#"
					        	     markerstyle="circle">
								</cfchartseries>		
						
						</cfchart>
						
						<cfset vImagePath = "#session.rootpath#\CFRStage\user\#session.acc#\_ticketSupportWidgetGraph">
						<cfset vImageURL  = "#session.root#/CFRStage/user/#session.acc#/_ticketSupportWidgetGraph">
						
						<cffile action="WRITE" file="#vImagePath#1.png" 
						      output="#TicketSupportChart#" nameconflict="OVERWRITE">
						
						<cfoutput><img src="#vImageURL#1.png?id=#now()#"></cfoutput>
						
					</td>
				</tr>
			</table>
		</td>
				
		<cfoutput>
			<cf_tl id="Toggle Graph" var="1">
			<td rowspan="2"  align="center" class="clsNoPrint" style="width:50px; background-color:##EDEDED; cursor:pointer;" title="#lt_text#" 
			   onclick="$('.clsGraphSupportTicketContainer').toggle(); if($('.clsGraphSupportTicketContainer').is(':visible')){ $('.twistieGraphSupportTicket').attr('src','#session.root#/Images/HTML5/Gray/right.png'); }else{ $('.twistieGraphSupportTicket').attr('src','#session.root#/Images/HTML5/Gray/left.png'); };">
				<img class="twistieGraphSupportTicket" src="#session.root#/Images/HTML5/Gray/right.png" height="25px">
			</td>
		</cfoutput>		
		
		</cfif>
				 
	</tr>
	
	<tr>
		<td valign="top" class="labelmedium" align="center"  width="100%" style="padding-left:2px;padding-right:2px;border-radius:2px">
		
		   <cfif get.recordcount eq "0">
		   
		   <font color="808080">No tickets found to show in this view<br><br></font>
		   
		   <cfelse>   		   
		 
			<cf_divScroll width="100%" height="300px" id="ticketViewWidgetContainer">
			
				<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
				
					<cfset row = 0>
											  										
					<cfoutput query="get" group="EntityStatus">
					
					<cfset row = row+1>
					
					<tr><td height="10"></td></tr>
										
					<tr>
					<td colspan="8">
					
					<table width="300">
					<tr style="height:30px"><td align="center" class="labelmedium" style="background-color:#listar[row]#;border:1px solid gray;font-size:18px;font-weight:200">#StatusDescription#</td></tr></table>
					
					</td></tr>
					
					<cfoutput>
					
						<cfset vColor = "">
						<cfset vTitle = "">
						
						<cfif LastAccess lt LastMessage and LastMessageByAcc neq session.acc>
							<cfset vColor = "color:##F62459;">
							<cf_tl id="You have unread comments" var="1">
							<cfset vTitle = lt_text>
						</cfif>
																		
						<cfquery name="getFlyActors" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT DISTINCT 
									OAS.UserAccount, 
									U.FirstName, 
									U.LastName
							FROM   	OrganizationObjectActionAccess OAS 
									INNER JOIN System.dbo.UserNames U 
									ON OAS.UserAccount = U.Account
							WHERE 	OAS.ObjectId = '#observationId#'
						</cfquery>
												
						<tr class="navigation_row labelmedium line" title="#vTitle#">
							<td style="width:30px;padding-top:3px;height:17px;padding-left:10px;">
							
								<cf_img	icon="select" 
									navigation="yes"
									buttonClass="clsNoPrint"
									onclick="javascript:supportticketedit('#ObservationId#')">
									
							</td>
							<td style="padding-left:4px"><cfif EntityStatus eq "3"><img src="#session.root#/images/check_icon.gif" alt="" border="0"></cfif></td>
							<td style="min-width:50px;height:23px;padding-left:10px;">#ObservationNo#</td>
							<td style="width:100%;height:23px;padding-left:5px;">#RequestName#</td>
							<td bgcolor="#vColor#" align="center" style="min-width:90;padding-right:10px;padding-left:5px;color:<cfif vColor neq "">ffffff<cfelse>##gray</cfif>;">#lsDateFormat(ObservationDate , client.dateFormatShow)#</td>
																					
							<cfif getFlyActors.recordcount gte "1">
								<cfset cl = "80FF80">
							<cfelse>
								<cfset cl = "d0d0d0">	
							</cfif>	
							
							<td bgcolor="#cl#" height="100%" style="min-width:100px;padding-left:10px;">
								<cfif getFlyActors.recordcount gte "1">
									<cfset vActorList = "">
									<cfloop query="getFlyActors">
										<cfset vActorList = vActorList & LastName & ", ">
									</cfloop>
									<cfif vActorList neq "">
										<cfset vActorList = mid(vActorList, 1, len(vActorList) - 2)>
									</cfif>
									#vActorList#
								<cfelse>
									<font color="808080">[<cf_tl id="unassigned">]</font>	
								</cfif>
							</td>
							
							<cfif LastMessage neq "">
								<cfset cl = "34A2D9">
							<cfelse>
								<cfset cl = "d0d0d0">	
							</cfif>	
							
							<td bgcolor="#cl#" height="100%" style="min-width:170px;border-left:1px solid silver;padding-left:10px; color:##FFFFFF;">
							
								<cfif LastMessage neq "">
									<cfif dateformat(now(),client.dateformatshow) eq dateformat(LastMessage,client.dateformatshow)>
									#LastMessageBy# TODAY @ #lsTimeFormat(LastMessage, 'HH:mm')# 
									<cfelse>
									#LastMessageBy# #lsDateFormat(LastMessage ,"DD/MM")# #lsTimeFormat(LastMessage, 'HH:mm')# 
									</cfif>
								<cfelse>
										
								</cfif>	
							</td>
						</tr>
								
						
					</cfoutput>
					
					</cfoutput>
				</table>
			</cf_divScroll>
			
		  </cfif>	
		  
		</td>
		
	</tr>
</table>

<cfset AjaxOnLoad("doHighlight")>