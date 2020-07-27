<cfparam name="url.action" default="">
<cfparam name="url.mode"  default="view">

<cfquery name="qEvents" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PersonEventMission				
</cfquery>

 <cfquery name="OnBoard" 
 datasource="AppsEmployee"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   P.*
	 FROM     PersonAssignment PA, Position P
	 WHERE    PersonNo           = '#URL.id#'
	 AND      PA.PositionNo      = P.PositionNo
	 AND      PA.DateEffective   <= getdate()	 
	 <!--- limit access by mission --->		 
	 <!---
	 AND      PA.DateExpiration  >= getDate()
	 --->
	 AND      PA.AssignmentStatus IN ('0','1')
	 <!---
	 AND      PA.AssignmentClass = 'Regular'
	 --->
	 AND      PA.AssignmentType  = 'Actual'
	 ORDER BY Incumbency DESC						
 </cfquery>  
		
<table align="center" style="height:100%;width:99%" border="0">

	<tr>
	<td style="height:60px">
		<table width="100%">
			<tr>
			
			<td style="padding-left:10px;width:66px">
			<img src="../../../../Images/Logos/Staffing/action.png" height="62" alt="" border="0">			
			</td>
				    <td style="padding-left:6px;padding-right:10px;padding-top:10px;font-size:34px" class="labellarge" colspan="2">						
							<cf_tl id="Document Self service">						
					</td>
					
					<td align="right" style="padding-top:26px;padding-right:10px">
					    <!---
						<cfif qEvents.recordcount gt 0 and OnBoard.recordcount gt 0>
						--->
						<cfif qEvents.recordcount gt 0>
						
							  <cf_tl id="New Request" var="1">		   
							  <cfoutput>
						    	<input type="button" 
									value="#lt_text#" 
									class="button10g" 
									style="width:190;height:25px" 
									onclick="javascript:eventadd('#URL.id#','portal');">
							</cfoutput>
							
						</cfif>
					</td>
			</tr>
		</table>
	</td>
	</tr>

	<tr><td style="padding-left:10px;padding-right:10px;height:100%;padding-top:20px">
	
		<cf_divscroll>	

		<table width="100%" align="center" class="formpadding navigation_table"">
					
		<TR class="line labelmedium fixrow">
			<td></td>
			<td></td>
  		    <td><cf_tl id="Entity"></td>  		     
		    <td><cf_tl id="Group">|<cf_tl id="Request"></td> 
			<td><cf_tl id="Process"></td>  
			<td><cf_tl id="Effective"></td>  			
			<td><cf_tl id="Expiration"></td>
			<td><cf_tl id="Requested"></td>
			<td width="5%"></td>			
		</TR>
		
		<!--- define mission --->
		
		<cfquery name="Mis" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT Mission			
			FROM   Ref_ParameterMission RM
			WHERE  EXISTS (
					SELECT DISTINCT Mission
					FROM   PersonEvent PE
					WHERE  PersonNo = '#url.id#'
					AND    RM.Mission = PE.Mission )
		</cfquery>
		
		<cfoutput query="Mis">
		
			<!--- check if person has access to this mission to view --->
			
			<cfinvoke component = "Service.Access"  
			   method           = "staffing" 
			   mission          = "#Mission#" 			  			  
			   returnvariable   = "accessStaffing">	   
			
			<cfif accessStaffing neq "NONE">
			
				<cfquery name="EventsAll" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT ET.Description    as TriggerDescription,
					       RefPE.Description as EventDescription, 
						   RefPE.ListingOrder, 
						   RefPE.EntityClass,
						   PE.PersonNo,
						   PE.EventId,
						   PE.Mission,
						   PE.PositionNo,
						    (   SELECT SourcePostNumber
							    FROM   Position
							    WHERE  PositionNo = Pe.PositionNo					   
						   ) as SourcePostNumber,	
						   (   SELECT PositionParentId
							    FROM   Position
							    WHERE  PositionNo = Pe.PositionNo					   
						   ) as PositionParentId,	
						   PE.DocumentNo,
						   Pe.ContractNo,				  
						   PE.OfficerFirstName, 
						   PE.OfficerLastName, 
						   PE.ActionStatus,		
						   PE.EventCode,		  
						   PE.EventTrigger,
						   PE.ReasonCode,
						   PE.ReasonListCode,
						   (   SELECT GroupListCode+' '+Description 
							   FROM   Ref_PersonGroupList
							   WHERE  GroupCode = Pe.ReasonCode
							   AND    GroupListCode = Pe.ReasonListCode
						   ) as ReasonDescription,	
						   ET.EntityCode,			   			   
						   PE.Created, 
						   PE.DateEvent, 
						   PE.DateEventDue,
						   PE.ActionDateEffective,
						   PE.ActionDateExpiration,
						   PE.Remarks, 
						   PE.PersonNo as Selected
					FROM   PersonEvent PE 
						   INNER JOIN Ref_PersonEvent RefPE ON PE.EventCode = RefPE.Code 
				           INNER JOIN Ref_EventTrigger ET ON ET.Code = PE.EventTrigger
				    WHERE  PE.ActionStatus != 9			
					AND    PE.Mission = '#Mis.mission#' 
					AND    PE.Personno = '#URL.ID#'
					<!--- only his/her own --->
					AND    PE.OfficerUserId = '#session.acc#'
				    ORDER BY PE.Created DESC		
				    	
				</cfquery>
			
				<cfif EventsAll.recordcount neq "0">
					 		 		
					<cfloop query="EventsAll">
					
						<TR class="labelmedium navigation_row line">		   
											
							   <td style="padding-top:0px;padding-left:2px">
							   
							   		<cfif ActionStatus eq "0" or ActionStatus eq "1">
									
							   		<cf_img icon="edit" 
			   							navigation="Yes" 
			   							onClick="eventedit('#eventid#','portal')">
											
									<cfelseif ActionStatus eq "3">
																	
									    <cfif getAdministrator("#mission#")>
										
										<cf_img icon="open" 
				   							navigation="Yes" 
				   							onClick="eventedit('#eventid#','portal')">
											
										<cfelse>
										
										<img src="#session.root#/Images/check.gif" 
										   alt="" width="15" height="20" border="0">
										</cfif>   
									<!--- closed --->		
								    </cfif>
							   </td>
							
							   <td style="width:10px;padding-top:8px">
							   
							    <!---
							   	<cfif EntityClass neq "">
							   			
							   		<cfif ActionStatus eq "0">
									    <cfset vMode = "selected">
			  						<cfelse>
			     						<cfset vMode = "">
			  						</cfif> 
							   		<cf_img icon="expand" toggle="Yes" 
									 onclick="workflowdrill('#eventid#','box_#eventid#')" mode="#vMode#">
										
							   	</cfif>
								--->
													   
							   </td>
							   
							   <td>#Mission#</td>						   
							   
				               <TD width="50%" colspan="1">
				               		<font color="808080">#TriggerDescription#:&nbsp;</font>#EventDescription#
				               		<cfif ReasonDescription neq "">
										&nbsp;-&nbsp;#ReasonDescription#									               			
				               		</cfif>	
									<cfif EntityCode eq "VacCandidate" and documentNo neq "0">
									<a href="javascript:showdocument('#documentno#')">(#DocumentNo#)</a></font>
									</cfif>
				               	</TD>
								
								<td style="min-width:100px;padding-right:10px">						   
							   
								   <cfif EntityClass neq "">
							
										<input type	= "hidden" 
										   	name 	= "workflowlink_#eventid#" 
										   	id   	= "workflowlink_#eventid#"
										   	value	= "#client.root#/Staffing/Application/Employee/Events/SelfserviceWorkflow.cfm">	
																									   
										<cf_securediv id="#eventid#" bind="url:#client.root#/Staffing/Application/Employee/Events/SelfserviceWorkflow.cfm?ajaxid=#eventid#">       															
														
				
									<cfelse>
														
									</cfif>				 						   
								   
							   </td>
							   
							   <td></td>
							   <td></td>
							   
								<td>#dateformat(created,client.dateformatshow)# #timeformat(created,"HH:MM")#<!--- officerLastName#---> </td>		               	
								<td width="5%">
				
									<cfinvoke component="Service.Access"  
								      method="org" 
									  mission="#Mission#" 
									  returnvariable="access">
									 
									<cfif access eq "ALL"> 
														
										<table>
											<tr>
												
												<cfif ActionStatus eq "0" or ActionStatus eq "1">
												
									   				<td style="padding-left:5px">
									   					<cf_img icon="delete" 					   						
									   						onClick="javascript:eventdelete('#eventid#','portal')">
									   				</td>
													
									   			</cfif>
												
									   		</tr>
									   	</table>
									   
									</cfif>
				
								</td>	
			
						</TR>		
					
					<!---
				
				    <cfif ActionDateEffective neq "" or ActionDateExpiration neq "" or remarks neq "">			
						<tr class="labelmedium line" style="height:20px"><td colspan="2"></td>
							<td colspan="3">#remarks#</font></td>					
							<td style="padding-left:4px" valign="top">
								#dateformat(ActionDateEffective,client.dateformatshow)#	
							</td>				
							<td style="padding-left:4px" valign="top">
								<cfif actionDateExpiration gt ActionDateEffective>
								#dateformat(ActionDateExpiration,client.dateformatshow)#	
								</cfif>
							</td>	
							<td></td>			
							<td></td>
						</tr>	
					</cfif>
					
					--->
					
					<cf_filelibraryCheck
							DocumentPath="PersonEvent"
							SubDirectory="#PersonNo#" 
							Filter="#left(eventid,8)#">
							
					<cfif files gte "1">		
					
					<tr style="height:1px">
					    <td colspan="2"></td>
						<td colspan="6">
										
						<cf_filelibraryN
							DocumentPath="PersonEvent"
							SubDirectory="#PersonNo#" 
							Filter="#left(eventid,8)#"			
							box="eventview"		
							Insert="no"
							Remove="no"					
							Listing="yes">
							
						</td>			
						<td></td>			
					</tr>
					
					</cfif>
					
					<!---
										
					<cfif ActionStatus eq "0" and EntityClass neq "">
					
						<input type	= "hidden" 
						   	name 	= "workflowlink_#eventid#" 
						   	id   	= "workflowlink_#eventid#"
						   	value	= "#client.root#/Staffing/Application/Employee/Events/EventWorkflow.cfm">	
						
						<tr id="box_#eventid#">
						    <td></td>
							<td colspan="9">								   
								<cfdiv id="#eventid#" bind="url:#client.root#/Staffing/Application/Employee/Events/EventWorkflow.cfm?ajaxid=#eventid#"/>       															
							</td>
						</tr>				
		
					<cfelse>
		
						<tr id="box_#eventid#" class="hide"> 
						    <td>
							<td colspan="9" id="#eventid#"></td>	
						</tr>
		
					</cfif>
					
					<tr style="height:1px"><td colspan="10" class="line"></tr>
					
					--->
							
					</cfloop>		
				
				</cfif>
						
			</cfif>
			
		</CFOUTPUT>
									
		</table>	
		
		</cf_divscroll>	

</td></tr>

</table>

<script>
	Prosis.busy('no')
</script>

<cfset ajaxonload("doHighlight")>
<cfset ajaxOnLoad("setSelected")>