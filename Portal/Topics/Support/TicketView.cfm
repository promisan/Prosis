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

<cfset list = "##5DB7E8,##E8875D,##E8BC5D,##E85DA2,##5DE8D8,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA">
<cfset listar = listtoArray(list)>		

<table style="width:99%" align="center" class="formpadding">

<tr>

    <td valign="top" style="height:290px;width:100%">
	
	<cf_divscroll>
	
	    <table width="100%" align="right">
	  				
			 <tr class="labelmedium2 fixlengthlist fixrow line">
					
				<td style="background-color:white"></td>			
				<td style="background-color:white"><a href="javascript:amendmentticket('','System')"><cf_tl id="New Request"></a></td>
				<td style="background-color:white"></td>
				<td style="background-color:white"></td>
				<!--- disabled --->
				<td align="right" style="padding-right:18px;background-color:white">
				<!---
				<cfoutput>			
					<a disabled href="javascript:ptoken.open('#SESSION.root#/System/AccessRequest/DocumentEntry.cfm?context=status&ts='+new Date().getTime(), '_blank');"><font color="gray"><i>[<cf_tl id="Request Access">]</font></a>
				</cfoutput>
				--->
				</td>									
				<td style="background-color:white"><cf_tl id="Tasked officer"></td></td>
				<td style="background-color:white"><cf_tl id="Last Comment Posted"></td></td>
			 </tr>
			 		
			   <cfif get.recordcount eq "0">
			   
				   <tr>
					<td class="labelmedium" colspan="7" align="center"  width="100%" style="padding-top:40px;padding-left:2px;padding-right:2px;border-radius:2px">
				    No tickets found to show in this view !		   
				    </td>		   
				   </tr>
			   
			   <cfelse>   
					
						<cfset row = 0>
												  										
						<cfoutput query="get" group="EntityStatus">
						
						<cfset row = row+1>
						
						<tr class="line">
						<td colspan="6">
						
							<table width="300">					
							<tr style="height:30px"><td align="center" class="labelmedium" 
							    style="background-color:#listar[row]#;font-size:18px">#StatusDescription#</td></tr>
							</table>
						
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
													
							<tr class="navigation_row labelmedium2 line fixlengthlist" title="#vTitle#">
								
								<td style="padding-left:4px"><cfif EntityStatus eq "3"><img src="#session.root#/images/check_icon.gif" alt="" border="0"></cfif></td>
								
								<td colspan="2" style="height:23px">#ObservationNo# #RequestName#</td>
								
								<td bgcolor="#vColor#" align="center" style="color:<cfif vColor neq "">ffffff<cfelse>##gray</cfif>;">#lsDateFormat(ObservationDate , client.dateFormatShow)#</td>
								
								<td style="height:17px;padding-left:10px;">
								
									<cf_img	icon="open" 
										navigation="yes"
										buttonClass="clsNoPrint"
										onclick="javascript:supportticketedit('#ObservationId#')">
										
								</td>
																						
								<cfif getFlyActors.recordcount gte "1">
									<cfset cl = "80FF80">
								<cfelse>
									<cfset cl = "d0d0d0">	
								</cfif>	
								
								<td bgcolor="#cl#" height="100%">
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
								
								<td bgcolor="#cl#" height="100%" style="border-left:1px solid silver;color:##FFFFFF;">
								
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
			
			  </cfif>	
		  
	       </table>	   
	  	   
	   </cf_divscroll>
	  	   
	   </TD>	  	 		 
		 
		 <cfif get.recordcount gte "1">
				 
			 <td valign="top" align="center" class="clsGraphSupportTicketContainer">
			 
				<table width="100%" align="center">
					<tr class="labelmedium2 line"><td align="center" style="font-size:18px"><cf_tl id="Pending Tickets by Status"></td></tr>
									
					<tr>
						<td align="center" style="padding-right:13px">
						
							<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
													
							<cfchart 
								name="TicketSupportChart"
								style="#chartStyleFile#" 
								format="png"
								fontsize="13" 		
								show3d="no"					
								chartheight="300" 
								chartwidth="360">
								
									<cfchartseries type="pie"
							             query="getGraph"
						    	         itemcolumn="EntityStatusName"
						        	     valuecolumn="Total"
										 datalabelstyle="columnlabel"
									     colorlist="#list#"
						        	     markerstyle="circle">
									</cfchartseries>		
							
							</cfchart>
							
							<cfset vImagePath = "#session.rootpath#\CFRStage\user\#session.acc#\_ticketSupportWidgetGraph">
							<cfset vImageURL  = "#session.root#/CFRStage/user/#session.acc#/_ticketSupportWidgetGraph">
							
							<cffile action="WRITE" file="#vImagePath#1.png" output="#TicketSupportChart#" nameconflict="OVERWRITE">
							
							<cfoutput><img src="#vImageURL#1.png?id=#now()#"></cfoutput>
							
						</td>
					</tr>
				</table>
				
			</td>
				
			<cfoutput>
				<cf_tl id="Toggle Graph" var="1">
				<td align="center" class="clsNoPrint" style="width:50px; background-color:##EDEDED; cursor:pointer;" title="#lt_text#" 
				   onclick="$('.clsGraphSupportTicketContainer').toggle(); if($('.clsGraphSupportTicketContainer').is(':visible')){ $('.twistieGraphSupportTicket').attr('src','#session.root#/Images/HTML5/Gray/right.png'); }else{ $('.twistieGraphSupportTicket').attr('src','#session.root#/Images/HTML5/Gray/left.png'); };">
					<img class="twistieGraphSupportTicket" src="#session.root#/Images/HTML5/Gray/right.png" height="25px">
				</td>
			</cfoutput>		
		
		</cfif>
				
		</TR>
			   
</TABLE>	   

<cfset AjaxOnLoad("doHighlight")>