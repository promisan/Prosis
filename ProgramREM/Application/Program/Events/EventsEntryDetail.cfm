
<cfform method="POST" name="entry">

<cfparam name="url.action" default="">
<cfparam name="url.mode" default="edit">
<cfparam name="url.portal" default="">

<cfif url.action eq "delete">
	
	<cfquery name="ProgramEvent" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM  ProgramEvent
		WHERE  ProgramCode  = '#URL.ProgramCode#'	
		AND    ProgramEvent = '#URL.ProgramEvent#'		 
	</cfquery>

</cfif>

<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Program 
		WHERE  ProgramCode = '#URL.ProgramCode#'			 
</cfquery>

<cfquery name="ProgramPeriod" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   ProgramPeriod
		WHERE  ProgramCode = '#URL.ProgramCode#'	
		AND    Period = '#url.period#'		 
</cfquery>
			
<table align="center" width="99%" border="0" bordercolor="silver">
			
	<tr><td>
	
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding navigation_table">		
						
		<tr><td height="10"></td></tr>
				
		<cfquery name="EntityClassList" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   * 
			FROM     Ref_EntityClass C
			WHERE    EntityCode = 'EntProjectEvent'
			
			<!---
			AND      EntityClass IN (SELECT EntityClass 
			                         FROM   Ref_EntityClassOwner
			                         WHERE  EntityClass = C.EntityClass
									 AND    EntityCode = 'EntProjectEvent'
									 AND    (
									           EntityClassOwner = (SELECT MissionOwner 
                                     		   					   FROM   Ref_Mission 
                   												   WHERE  Mission = '#Program.Mission#')
           									   OR 
									           EntityClassOwner IS NULL     
									         )      
									 )		
									 
									
			--->									 
		 
		</cfquery>
		
		<!--- check if this program is enabled for one or more categories --->
		
		<cfquery name="getClass" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			  SELECT * 
	          FROM   ProgramCategory 
	    	  WHERE  ProgramCode = '#Program.ProgramCode#'
			  AND    ProgramCategory IN (SELECT ProgramCategory FROM Ref_ProgramEventCategory)
			                       
		</cfquery>							 
		
		<cfquery name="EventsAll" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT F.Code, 
			       F.Description, 
				   F.Listingorder, 
				   S.EntityClass,				
				   S.OfficerFirstName, 
				   S.OfficerLastName, 
				   S.ActionStatus,		
				   S.ProgramEvent,		  
				   S.Created, 
				   S.DateEvent, 
				   S.Remarks, 
				   S.ProgramCode as Selected
			FROM   ProgramEvent S RIGHT OUTER JOIN
		           Ref_ProgramEvent F ON S.ProgramEvent = F.Code AND S.ProgramCode = '#URL.ProgramCode#'
			WHERE  F.Code IN (SELECT ProgramEvent
			                  FROM   Ref_ProgramEventMission	   
							  WHERE  Mission = '#Program.Mission#') 
			<cfif getClass.recordcount gte "1">				  
			AND    F.Code IN (
			                  SELECT ProgramEvent
			                  FROM   Ref_ProgramEventCategory   
							  WHERE  ProgramCategory IN (SELECT ProgramCategory 
							                             FROM   ProgramCategory 
														 WHERE  ProgramCode = '#Program.ProgramCode#')
							 ) 			  
			</cfif>				 
		    ORDER By ListingOrder, Description
									
		</cfquery>			
		
		<cfif EventsAll.recordcount neq "0">
		
		<TR>		   
		    <td height="20" class="labelit"><cf_tl id="Event"></td>  
			<td height="20" class="labelit"><cf_tl id="Date"></td>
			<td width="30%" class="labelit"><cf_tl id="Memo"></td>
			<td class="label"><cf_tl id="Officer"></td>
			<td></td>			
		</TR>
						
		<tr><td colspan="6" height="1" class="linedotted"></td></tr>
		
		<cfoutput query="EventsAll">
			
			<TR class="navigation_row linedotted">
			   				
			    <TD height="20" 
				    width="160"
					class="labelmedium" 
					style="padding-left:4px">
				<cf_space spaces="68">
				#Description#:
				<input type="hidden" name="Code_#CurrentRow#" id="Code_#CurrentRow#" value="#Code#" size="4" maxlength="4"></td>
				</TD>
				
				<cfif url.mode eq "edit">
				
				<TD style="z-index:#10-currentrow#; position:relative;padding:2px">	
				
				<table cellspacing="0" cellpadding="0">
				
				    <tr>
					 <td>
					 
						<cf_space spaces="38">				
						
						<cf_intelliCalendarDate9
							FieldName="DateEvent_#CurrentRow#" 
							Default="#DateFormat(DateEvent, '#CLIENT.DateFormatShow#')#"
							AllowBlank="True"
							Class="regularxl">
					
					</td>
					
					<td>
					
					<cfset cl = entityclass>
					
					<select name="EntityClass_#CurrentRow#" class="regularxl">
						<option value="">No Workflow</option>
						<cfloop query="EntityClassList">
						<option value="#EntityClass#" <cfif entityclass eq cl>selected</cfif> >#EntityClassName#</option>
						</cfloop>					
					</select>
										
					</td>
					</tr>
					
				</table>					
					
				</TD>
				<td class="regular" width="30%">
				
				<input type="text"
				     style="width:99%" class="regularxl" name="Remarks_#CurrentRow#" value="#Remarks#" width="50"></td>
							
				<cfelse>				
				
					<cfif dateevent gt "">
					   
						<td>
						
						<cf_space spaces="45">
						
						<table cellspacing="0" cellpadding="0">
						
							<tr>
							<td width="30" class="labelmedium">#dateformat(dateevent,'DDD')#</td>
							<td class="labelmedium">#dateformat(dateevent,'DD MMMM YYYY')#<td>
							<td style="padding-left:4px">
							
								<cfif actionStatus eq "0">
								
								    <cf_img icon="delete" onclick="ColdFusion.navigate('EventsEntryDetail.cfm?action=delete&programcode=#programcode#&period=#url.period#&programevent=#programevent#','eventdetail')">
																		 			
								</cfif>
							
							</td>
							
							<cfif entityclass neq "">
							
							  <td><img src="#SESSION.root#/Images/workflow2.gif" alt="" width="15" height="15" border="0"></td>
							  
							</cfif>
							
							</tr>
						</table>
						
					<cfelse>
					
						<td>--</td>
					
					</cfif>
				
				<td class="labelit">#remarks#</td>
				
				</cfif>
				
				<td width="200" class="labelit">#officerfirstName# #officerLastName#</td>	
				<td width="10"></td>	
							
			</TR>		
									
			<cfif dateevent lte now() and EntityClass neq "">			
						
				<cfquery name="Check" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     ProgramEventAction
					WHERE    ProgramCode  = '#URL.ProgramCode#'
					AND      ProgramEvent = '#Code#'
					ORDER BY EventDate DESC				
				</cfquery>
																				
				<cfif check.recordcount eq "0">
				
					<cf_assignid>
					
					<cfquery name="Insert" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						INSERT INTO ProgramEventAction
							( ProgramCode, 
							  ProgramEvent, 
							  EventId, 
							  EventDate, 
							  EventReference, 
							  OfficerUserId, 
							  OfficerLastName, 
							  OfficerFirstName )
							  
							VALUES (
							 '#URL.ProgramCode#',
							 '#Code#',
							 '#rowguid#',
							 '#dateformat(dateevent,client.dateSQL)#',
							 '#programPeriod.Reference#-1',
							 '#SESSION.acc#',
							 '#SESSION.last#',
							 '#SESSION.first#'
							 )		
							 							
					</cfquery>
					
					<cfset id = rowguid>					
					
				<cfelse>				
				
					<cf_wfactive entitycode="EntProjectEvent" objectkeyvalue4="#check.eventid#">
						 
					<cfif wfstatus eq "open">
					 
					    <cfset id = check.eventid>
						   
					<cfelse>
					
						<cfset no = check.recordcount+1>
					 
					    <!--- check if last workflow is equal or later than the requested --->
						
						<cfquery name="Last" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   TOP 1 *
							FROM     ProgramEventAction
							WHERE    ProgramCode  = '#ProgramCode#'
							AND      ProgramEvent = '#Code#'
							ORDER BY Created DESC						
						</cfquery>
																																			
						<cfif Last.EventDate neq DateEvent>
																				 
						    <cf_assignid>
							
							<cfif programPeriod.Reference eq "">
							
							   <cfset reference = "#programPeriod.Reference#-#No#">
							   
							<cfelse>
							
							   <cfset reference = "#programcode#-#No#">
							  
							</cfif>
				
							<cfquery name="Insert" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								INSERT INTO ProgramEventAction
									( ProgramCode, 
									  ProgramEvent, 
									  EventId, 
									  EventDate, 
									  EventReference, 
									  OfficerUserId, 
									  OfficerLastName, 
									  OfficerFirstName)
								VALUES
									('#URL.ProgramCode#',
									 '#Code#',
									 '#rowguid#',
									 '#dateformat(dateevent,client.dateSQL)#',
									 '#programPeriod.Reference#-#No#',
									 '#SESSION.acc#',
									 '#SESSION.last#',
									 '#SESSION.first#')									
							</cfquery>
							
							 <cfset id = rowguid>		
						 
						</cfif>						 	   
																		 
					</cfif>						
					
				</cfif>		
								   
			 </cfif>  		
			
			<cfquery name="get" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   *
				FROM     ProgramEventAction
				WHERE    ProgramCode  = '#URL.ProgramCode#'
				AND      ProgramEvent = '#Code#'
				ORDER BY EventDate DESC				
			</cfquery>
							
			<cfloop query="get">			
			
			<input type="hidden" 
			   name="workflowlink_#eventid#" 
			   id="workflowlink_#eventid#" 			   
			   value="EventsWorkflow.cfm">	
			   
			<cf_wfactive entitycode="EntProjectEvent" objectkeyvalue4="#eventid#">  			 
			
			<tr><td colspan="6" class="linedotted"></td></tr>   
			
			<tr>
			<td style="border-left:solid silver 0px" colspan="6" align="left">
			
				<table cellspacing="0" cellpadding="0">
				<tr><td>
					<img src="#SESSION.root#/images/join.gif" alt="" align="absmiddle" border="0">
					</td>
					<td width="22" style="cursor:pointer" align="center" onclick="workflowdrill('#eventid#','box_#eventid#')">
					
					  <cfif wfstatus eq "closed"> 
				
					  <img name="exp#eventid#" id="exp#eventid#" 
						     class="regular" 
							 src="#SESSION.root#/Images/arrowright.gif" 
							 align="absmiddle" 
							 alt="Expand" 						
							 border="0"> 	
										 
					   <img name="col#eventid#" id="col#eventid#" 
						     class="hide" 
							 src="#SESSION.root#/Images/arrowdown.gif" 
							 align="absmiddle" 						
							 alt="Hide" 			
							 border="0"> 
						 
					</cfif>	 
				
					</td>					
					<td height="25" class="labelmedium">				
				        <font color="gray">#EventReference#  <font size="1" color="0080FF">Effective:</font> #dateformat(eventdate,CLIENT.DateFormatShow)#</b></td>										
				     </td>
					 </tr>
				 </table>				 
				
			</tr>  
			
			<cf_wfactive entitycode="EntProjectEvent" objectkeyvalue4="#eventid#">
						
			<cfif wfstatus eq "open"> 
			
			<tr>			 
			    <td colspan="6" style="padding-left:10px">								   
			        <table width="97%" cellspacing="0" cellpadding="0" align="right"><tr><td>					
					<cfdiv id="#eventid#" 
					    bind="url:#SESSION.root#/programrem/application/program/events/EventsWorkflow.cfm?ajaxid=#eventid#"/>      
					</td></tr></table>	 															
				</td>
			</tr>	
			
			<cfelse>
			
			<tr id="box_#eventid#" class="hide">
			 
			    <td colspan="6" style="padding-left:10px">								   
			        <table width="97%" align="right"><tr><td>					
					<cfdiv id="#eventid#">      
					</td></tr></table>	 															
				</td>
			</tr>	
						
			</cfif>			
			
			</cfloop>	 
					
		</CFOUTPUT>
						
		</cfif>
					
		</table>		

</td></tr>

<cfoutput>

<cfif url.mode eq "Edit">
	
	<tr><td height="34" align="center" colspan="2">
		 <input type="button"
		   name="Submit" 
		   value="Save" 
		   style="width:120" 
		   class="button10g" 
		   onclick="ColdFusion.navigate('#SESSION.root#/programrem/application/program/events/EventsEntrySubmit.cfm?portal=#url.portal#&programcode=#url.programcode#&period=#url.period#','eventdetail','','','POST','entry')">
		 </td>
	</tr>
		
<cfelse>	
	
	<cfinvoke component="Service.Access"
		Method="program"
		ProgramCode="#URL.ProgramCode#"
		Period="#URL.Period#"
		ReturnVariable="ProgramAccess">	
	
	<cfif ProgramAccess eq "ALL"> 
	
	<tr>
	    <td height="28" align="center" colspan="2">
						
				<cf_tl id="Edit" var="1">
				<input type="button" 
				  name="Submit" 
				  onclick="ColdFusion.navigate('#SESSION.root#/programrem/application/program/events/eventsentrydetail.cfm?mode=edit&portal=#url.portal#&programcode=#url.programcode#&period=#url.period#','eventdetail')"
				  value="#lt_text#" 
				  class="button10g">
				  
		</td>
	</tr>
	</cfif>

</cfif>	

</cfoutput>

</table>
    
</cfform>

<cfset ajaxonload("doHighlight")>
<cfset ajaxOnLoad("doCalendar")>
