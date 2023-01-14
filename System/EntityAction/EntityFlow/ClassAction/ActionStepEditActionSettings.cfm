
<cfoutput>

	<table width="97%" align="center" class="formpadding">
		
	<tr><td colspan="2" style="padding-top:2px;font-size:18px;height:30px;font-weight:bold" class="labelmedium2">Workflow Action <u>Listing</u></td></tr>
			
	<input type="hidden" name="ActionType" id="ActionType" value="#Get.ActionType#">
							
	<cfif Get.ActionType eq "Action" or Get.ActionType eq "Decision">		
	
		<cfquery name="CheckDialog" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM Ref_EntityDocument
				WHERE EntityCode = '#URL.EntityCode#'
				AND DocumentType = 'Dialog'
				AND  DocumentCode = '#get.actiondialog#'	
			</cfquery>			
													
		<TR>
		<TD style="padding-left:10px" class="labelmedium"><cf_tl id="Quick process">:</b></TD>
		<TD>
			<table border="0" cellspacing="0" cellpadding="0">
			<tr><td>
			<input type="checkbox" class="radiol" onClick="javascript:quick(this.checked)" <cfif Get.ActionDialog neq "" and  checkdialog.documentmode neq "Popup">disabled</cfif> name="enablequickprocess" id="enablequickprocess" value="1" <cfif #Get.enableQuickProcess# eq "1">checked</cfif>>
			</td>
			<td class="labelit" style="color:gray;padding-left:5px">= Action may be confirmed by one click from the workflow listing</td>
			</tr>
			</table>
		</TD>
		</TR>
	
	</cfif>
					
	<tr>
	    <td class="labelmedium" style="padding-left:10px"><a href="##" title="Show additional information for this step in the workflow base screen">URL detail template:</b></TD>
	    <td>
		<cfinput type="Text" value="#Get.ActionURLDetails#"  name="ActionURLDetails" class="regularxl" required="No" size="77" maxlength="80">
		</td>
	</tr>
				
	<tr><td colspan="2" style="font-size:18px;height:30px;font-weight:bold" class="labellarge">Workflow <u>Process Dialog</u></td></tr>	
	
	<tr>				
	   	 <TD class="labelmedium" style="padding-left:10px;cursor:pointer" title="Open dialog if active">Dialog open mode:</TD>
		 <TD width="80%">
		   <table>
		   <tr><td>
		   <INPUT type="radio" class="radiol" name="ActionDialogOpen" id="ActionDialogOpen" value="Manual" <cfif Get.ActionDialogOpen eq "Manual" or Get.ActionDialogOpen eq "">checked</cfif>>
		   </td>
		   <td style="padding-left:4px"><cf_tl id="Manually"></td>
		   <td style="padding-left:10px">
		   <INPUT type="radio" class="radiol" name="ActionDialogOpen" id="ActionDialogOpen" value="Auto" <cfif Get.ActionDialogOpen eq "Auto">checked</cfif>>
		   </td>
		   <td style="padding-left:4px"><cf_tl id="Auto open"></td>
		   </tr>
		   </table>
		 </td>					
	</tr>	
	
	<tr>				
	   	 <TD class="labelmedium" style="padding-left:10px;cursor:pointer" title="Allow actor to enter the processing date">Enable Process date:</TD>
		 <TD width="80%">
		   <INPUT type="checkbox" class="radiol" name="ActionDateInput" id="ActionDateInput" value="1" <cfif Get.ActionDateInput eq "1">checked</cfif>>
		 </td>			
	</tr>		
		
	<cfif Get.ActionType eq "Decision">	
				
			<TR>
		    <TD colspan="2" style="padding-left:10px;" height="25" class="labelmedium">Descriptive decision legs:</b></TD>		    
			</tr>
									
			<tr><td style="padding-left:14px" colspan="2">
						
				<cfif URL.PublishNo eq "">	
						
			    	<table cellspacing="0" cellpadding="0">
					
					<tr id="yesno" class="regular"><td></td>
					    <td><table>
							<tr><td height="1"></td></tr>
							<tr bgcolor="CEFFCE"><td width="40%"  height="28" style="padding-left:6px">
								<img src="#SESSION.root#/images/status_ok1.gif" 
							      alt="Yes, approved" border="0" 
								  onclick="stepedit(ActionGoToYes.value)"
							      align="absmiddle">
							</td>
							<td style="height:35px;padding-left:6px">Label:</td>
							<td style="padding-left:6px">
							      <input type = "text" 
							       name       = "ActionGoToYesLabel" 
								   id         = "ActionGoToYesLabel"
								   value      = "#Get.ActionGoToYesLabel#" 
			     				   size       = "25" 
								   class      = "regularxxl"
								   maxlength  = "40">
						    </td>
							<td style="padding-left:6px" class="fixlength labelmedium"><cf_tl id="Action">:</td>
							<td style="padding-left:6px;padding-right:4px">
							<select style="width:270px" name="ActionGoToYes" id="ActionGoToYes" class="regularxxl">
							<option value="" selected>Undefined</option>
							<cfloop query="GoTo">
						    	<option value="#GoTo.ActionCode#"
								 <cfif ActionCode eq Get.ActionGoToYes>selected</cfif>>
								 <cfif ActionType eq "Action">A<cfelse>D</cfif>: #ActionCode# #ActionDescription#</option>
							</cfloop>
							</select>
							</td></tr>
							<tr><td height="1"></td></tr>
							<tr bgcolor="FDDFDB"><td  height="28" style="padding-left:6px">
							
								<img src="#SESSION.root#/images/status_alert1.gif"
								   onclick="stepedit(ActionGoToNo.value)" 
								   alt="No, denied" border="0" align="absmiddle">
								   
							</td>
							<td style="height:35px;padding-left:6px" class="labelmedium">Label:</td>
							<td style="padding-left:6px">
							
							      <input type  = "text"				       
							       name        = "ActionGoToNoLabel" 
								   id          = "ActionGoToNoLabel"
								   value       = "#Get.ActionGoToNoLabel#" 
			     				   size        = "25" 
								   class       = "regularxxl"
								   maxlength   = "40">								  					  
								   
						    </td>
							<td style="padding-left:6px" class="fixlength labelmedium"><cf_tl id="Action">:</td>
							<td style="padding-left:6px;padding-right:4px">
							<select style="width:270px"  name="ActionGoToNo" id="ActionGoToNo" class="regularxxl">
							<option value="" selected>Undefined</option>
							<cfloop query="GoTo">
						    	<option value="#ActionCode#" <cfif ActionCode eq Get.ActionGoToNo> selected </cfif>>
								<cfif ActionType eq "Action">A<cfelse>D</cfif>: #ActionCode# #ActionDescription#</option>
				   			</cfloop>
							</select>
							</td></tr>
					        </table>
						</td></tr>
					</table>
					
					<cfelse>			
				
					<table>
						
						<tr id="yesno" class="regular"><td></td>
						    <td>
							
							<table>
							
								<tr><td height="1"></td></tr>
								<tr bgcolor="CEFFCE">
									
									<td width="40%" class="labelmedium" style="height:35px;padding-left:6px">Approve</td>
									<td height="24" class="labelmedium" style="padding-left:6px">Label:</td>
									<td style="padding-left:8px"><input type="text" 
									       name="ActionGoToYesLabel" 
										   id="ActionGoToYesLabel"
										   value="#Get.ActionGoToYesLabel#" 
					     				   size="30" 
										   width="90%"  class="regularxl"
										   maxlength="40">
										   
										   <input type="hidden" name="ActionGoToYes" value="#Get.ActionGoToYes#">
								    </td>
									<td style="padding-left:4px">
									<cfif Get.ActionGoToYes eq "">
									<cfelse>
									<img src="#SESSION.root#/images/status_ok1.gif" onclick="stepedit('#Get.ActionGoToYes#')"
										   alt="Go To" border="0" style="cursor: pointer;" align="absmiddle">
									</cfif>
									</td>
								</tr>
								
								<tr><td height="1"></td></tr>						
								<tr bgcolor="FDDFDB">
									<td height="24" class="labelmedium" style="height:35px;padding-left:6px">Deny</td>
									<td style="padding-left:6px" class="labelmedium">Label:</td>
									<td style="padding-left:8px">
									
									      <input type="text" 
									       name="ActionGoToNoLabel" 
										   id="ActionGoToNoLabel"
										   value="#Get.ActionGoToNoLabel#" 
					     				   size="30"  class="regularxl"
										   maxlength="40">
										   
										    <input type="hidden" name="ActionGoToNo" value="#Get.ActionGoToNo#">
								    </td>
									<td style="padding-left:4px">
									<cfif Get.ActionGoToNo eq "">
									<cfelse>
									<img src="#SESSION.root#/images/status_alert1.gif" 
									   style="cursor: pointer;"
									   onclick="stepedit('#Get.ActionGoToNo#')"
									   alt="Go To" border="0" align="absmiddle">
									</cfif>
									</td>
								</tr>
								
						        </table>
								
							</td></tr>
							
					</table>
									
				</cfif>
				
			</td>
			</tr>
									
		<cfelse>						
			
			<TR>
			    <TD width="180" style="padding-left:10px;cursor:pointer" class="labelmedium"><a href="##" title="Label for the forward action">Action Submit Label:</TD>
			    <TD>
				<table width="100%" cellspacing="0" cellpadding="0">
				<tr><td>
				<cfinput type="Text" value="#Get.ActionGoToYesLabel#"  name="ActionGoToYesLabel" class="regularxxl" required="No" size="40" maxlength="40">
				</td>
				</tr>
				</table>
			</TR>	
			
			
		</cfif>
			
	<!--- check if workflow itself is not already an embedded workflow. No recursive embedding --->
		
	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
		SELECT *
		FROM   Ref_EntityClass
		WHERE  EntityCode  = '#URL.EntityCode#'
		AND    EntityClass = '#URL.EntityClass#'
	</cfquery>
		
	<cfquery name="ActionMode" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityAction
		WHERE  ActionCode  = '#URL.ActionCode#'
	</cfquery>
			
	<!--- retrieve from script table --->	
	
	<cfif Embed.recordcount gte "1" and Check.EmbeddedFlow eq "0">
	
		<cfif get.Embeddedclass neq "">
		 	<cfset cl = "regular">
		<cfelse>
		 	<cfset cl = "hide"> 
		</cfif>
		
		<tr id="embeddedscript" class="#cl#">
		
		 <td valign="top" style="cursor:pointer">
		 <table cellspacing="0" cellpadding="0">
		 <tr><td height="3"></td></tr>
		 <tr><td style"padding-left:10px" class="labelmedium" tooltip="Write a SELECT query that should have at least one record as a result in order to trigger the embedded workflow:">		 
		 Condition for Embedding:		 
		 </td></tr></table>
		 </td>
		
		 <td>
		
			<cf_WorkflowScript
				name        = "embed" 
				class       = "#cl#"
				actionCode  = "#URL.ActionCode#"
				entityClass = "#URL.EntityClass#"
				entityCode  = "#URL.EntityCode#" 
				publishNo   = "#URL.PublishNo#"
				method      = "Embed">
		
		</td>
		
	   </tr>					
					
	<cfelse>
	
		<!--- not relevant --->
	
	</cfif>		
	
	<TR>
		<TD style="cursor:pointer;padding-left:10px" class="labelmedium" title="Show the standard document reference in the process dialog">		
		Object Reference:		
		</TD>
		<TD class="labelmedium">
		<table>
			<tr>
				<td style="padding-left:4px"><INPUT type="radio" class="radiol" name="ActionReferenceShow" id="ActionReferenceShow" value="0" <cfif Get.ActionReferenceShow eq "0">checked</cfif>></td>
				<td class="labelmedium" style="padding-left:4px">Hide</td>
				<td class="labelmedium" style="padding-left:8px"><INPUT type="radio" class="radiol" name="ActionReferenceShow" id="ActionReferenceShow" value="1" <cfif Get.ActionReferenceShow eq "1">checked</cfif>></td>
				<td class="labelmedium" style="padding-left:4px">Show</td>
			</tr>
		</table>
		</td>
	</TR>			
	
	<cfif Get.ActionType eq "Action" or Get.ActionType eq "Decision">
	
	<TR>
    <TD class="labelmedium" style="cursor:pointer;padding-left:10px" title="Select a custom dialog which will be loaded once the step is processed">	
	
	[TAB] Custom Dialog:
		
	</TD>
    <td>
	     <table>
		 <tr><td>
		    
			<select name="ActionDialog" id="ActionDialog" class="regularxl" style="width:180px" onChange="standard(this.value)">
						
				<option value="">Standard</option>
				<cfloop query="Dialog">
			    	<option value="#DocumentCode#"
					 <cfif DocumentCode eq Get.ActionDialog>selected</cfif>>
					 #DocumentDescription# [#DocumentMode#]</option>
				</cfloop>
				
			</select>
						
			</td>
			
			<td class="labelmedium" style="padding-left:5px"><cf_uitooltip  tooltip="Parameter to be passed (url.wparam) to the process in order to trigger a predefined behavior for the dialog.<br><b>Example</b> HRAP to show certain data for entry">&wparam=</cf_uitooltip></td>
			<td style="padding-left:5px">
			
			<cfif Get.actionDialog eq "">
			     <cfset cl = "hide">
			<cfelse>
			     <cfset cl = "regular">
			</cfif> 
								
			<!--- select a parameter value to be passed to the dialog EO/Account --->
			
			<!--- krw: 04/03/08 added bind to initialize value --->
			<cf_securediv id="parameter" tagname="td" 
				bind="url:ActionStepEditActionParam.cfm?EntityCode=#URL.EntityCode#&Dialog=#Get.ActionDialog#&dialogparameter=#get.actionDialogParameter#">
																				
			</td>
																		
			<td id="standard" class="#cl# labelit" style="padding-left:5px">
			
			<a href="##"
			   title="Check this option ONLY in case your Custom Action is defined as POPUP and ALSO processes the workflow step status.">
			   Disable dialog:</a>
			</td>
			<td style="padding-left:4px">		
			
			<input type="checkbox" class="radiol" <cfif Get.ActionDialog eq "" >disabled</cfif> 
			       name="disablestandarddialog" id="disablestandarddialog"
				   value="1" <cfif Get.disableStandardDialog eq "1">checked</cfif>>
			
		</td>
		</tr>
		</table>
							
	</td>
	</TR>
	
	</cfif>		
							
	<TR>
    <TD height="25" class="labelmedium" valign="top" style="padding-top:4px;padding-left:10px">[TAB] Process Action</TD>	
	<td>
	
		<table width="450" style="border:0px dotted silver" cellspacing="0" cellpadding="0" class="formpadding">
		
		<TR>
			<TD width="30%" style="padding-left:4px;padding-right:10px;cursor:pointer"
			 title="Allow Processor to record a reference date and referenceNo" class="labelit">Reference/Date:</TD>
			<TD>
			<table cellspacing="0" cellpadding="0">
			<tr>
			<td><INPUT type="radio" class="radiol" name="ActionReferenceEntry" id="ActionReferenceEntry" value="0" <cfif Get.ActionReferenceEntry eq "0">checked</cfif>></td>
			<td class="labelit" style="padding-left:2px">No</td>
			<td style="padding-left:5px"><INPUT type="radio" class="radiol" name="ActionReferenceEntry" id="ActionReferenceEntry" value="1" <cfif Get.ActionReferenceEntry eq "1">checked</cfif>></td>
			<td class="labelit" style="padding-left:2px">Yes</td>
			</tr>
			</table>
			</td>
		<TR>	
		
		<!--- prevent embed within an embed --->
					
		<tr>				
	   	 <TD style="padding-left:4px;cursor:pointer" title="Memo entry box" class="labelit">Memo/Notes:</TD>
		 <TD>
		 
		 <table>
		   <tr>
		   	  <td>
			  <table cellspacing="0" cellpadding="0">
				<tr>
				<td>
				 <INPUT type="radio" class="radiol" onclick="html('0')" name="enableTextArea" id="enableTextArea" value="0" <cfif Get.enableTextArea eq "0">checked</cfif>>
				 </td>
				 <td class="labelit" style="padding-left:2px">No</td>
				 <td class="labelit" style="padding-left:5px">
			   <INPUT type="radio" class="radiol" onclick="html('1')" name="enableTextArea" id="enableTextArea" value="1" <cfif Get.enableTextArea eq "1">checked</cfif>>
				  </td><td class="labelit" style="padding-left:2px">Yes</td>
				  <td class="labelit" style="padding-left:5px">
			   <INPUT type="radio" class="radiol" onclick="html('1')" name="enableTextArea" id="enableTextArea" value="2" <cfif Get.enableTextArea eq "2">checked</cfif>>
			      </td><td class="labelit" style="padding-left:2px">Enforce</td>		   
		    	  <TD style="padding-left:10px" class="labelit">Rich Text:</TD>
		          <TD style="padding-left:4px">
			      <INPUT type="checkbox" class="radiol" name="enableHTMLEdit" id="enableHTMLEdit" value="1" <cfif Get.enableHTMLEdit eq "1">checked</cfif>>
			      </td>		
		   	   </tr>
			   </table>
			   </td>
			   </tr>
		   </table>
		 </td>			
		</tr>	
		
		<tr>				
	   	 <TD style="padding-left:4px;" class="labelit"><cf_tl id="Attachments">
		 <img src="#SESSION.root#/images/paperclip2.gif" align="absmiddle" alt="Attachment enable" border="0">:
		 </TD>
		 <TD>
		   <INPUT type="checkbox" class="radiol" name="enableAttachment" id="enableAttachment" value="1" <cfif Get.enableAttachment eq "1">checked</cfif>>
		 </td>			
		</tr>
		
		<TR>
		    <TD style="cursor:pointer;padding-left:4px;padding-top:2px" class="labelit">			
			
			<cf_uitooltip tooltip="Select an embedded workflow which needs to be completed before this step can be processed">
			  Embedded flow:
			</cf_uitooltip>
			
			</td>
			
			<td class="labelit">
			
			 <cfif Embed.recordcount gte "1" and Check.EmbeddedFlow eq "0" and (ActionMode.ProcessMode eq "1" or ActionMode.ProcessMode eq "2"  or ActionMode.ProcessMode eq "3")>
											   
					   <select class="regularxl" name="EmbeddedClass" id="EmbeddedClass">
					    <option value=""  <cfif Get.EmbeddedClass eq "">selected</cfif>>N/A</option>
					   					    					
					    <cfloop query="Embed">
						 <option value="#EntityClass#" <cfif Get.EmbeddedClass eq entityclass>selected</cfif>>#EntityClassName#</option>
						  </cfloop>
					
			  <cfelseif ActionMode.ProcessMode eq "0">
			  
			  	<font color="green" face="Calibri" size="2">Option not available for this action (mode)</font>		  	
				
			  <cfelse>
			  
			  	<font color="gray" face="Calibri" size="2">&nbsp;No embedded workflows configured for this entity.</font>
				
			  </cfif>
			  
			</td>	
		</tr>	
		
		</table>
	
	</td>
	</tr>
	
					
	<TR>
    <TD class="labelmedium" height="25" style="padding-right:15px;padding-left:10px;cursor:pointer" title="Present generate content from previously completely step into this step for reference">
	  [TAB]&nbsp;Prior&nbsp;Document:</b>
    </TD>
	<TD>
	  <table cellspacing="0" cellpadding="0">
	   <tr><td>
		<select name="ActionViewMemo" id="ActionViewMemo" class="regularxl">  <!--- onChange="inherit()" --->
		    <option value="" selected></option>
			<option value="Prior" <cfif Get.ActionViewMemo eq "Prior">selected</cfif>>Prior action</option>
			<cfloop query="Access">
				  <cfif len(Access.ActionDescription) gt 40>
				    <cfset nm = left(Access.ActionDescription,40)>
				  <cfelse>
				     <cfset nm = Access.ActionDescription>	
				  </cfif>
			       <option value="#Access.ActionCode#" <cfif Access.ActionCode eq Get.ActionViewMemo>selected</cfif>>#Access.ActionCode# #nm#</option>
			</cfloop>
		</select>
		</td>
						
		<!--- hidden for cf8 mode --->
		
		<cfset cl = "hide">							
		
		<TD class="#cl#" id="inherit1"><cf_uitooltip tooltip="Merge the [Text Input] from previously completely step into the text input for this step">Inherit text:</cf_uitooltip></TD>
		<TD class="#cl#" id="inherit2">
			<INPUT type="checkbox" name="ActionViewMemoCopy" id="ActionViewMemoCopy" value="1" <cfif Get.ActionViewMemoCopy eq "1">checked</cfif>>
		</td>
						
		</tr>
			
		</TD>
		</TR>
		</table>
	</TD>
	</tr>		
		
	<tr><td style="font-size:18px;height:30px;font-weight:bold" class="labellarge">Ticklers/Notification</td></tr>
	
	<tr>				
   	 <TD class="labelmedium" style="padding-left:10px;cursor:pointer" title="Once this action is due, the action will be presented for the actor under the [My Clearances] function">My Clearances</td>
	 <TD>
	   <INPUT type="checkbox" class="radiol" name="EnableMyClearances" id="EnableMyClearances" value="1" <cfif Get.EnableMyClearances eq "1">checked</cfif>> 
	 </td>			
	</tr>
	
	<cfif Get.enableNotification eq "1">
	     <cfset cl = "regular">
	<cfelse>
	     <cfset cl = "hide">
	</cfif> 
	
	<tr>				
   	 <td class="labelmedium" style="padding-top:4px;padding-left:10px;cursor:pointer" valign="top" title="Actor Mail. Mail or Exchange Task Action will not be sent once the user disabled mail and/or exchange notification in his/her preferences">
	  Mail / Exchange Task	
	 </td>
	 	 
	 <td valign="top">
	    <table cellspacing="0" cellpadding="0">
		<tr>
		<td style="padding-top:1px" valign="top" ><input onClick="javascript:show('email',this.checked)" style="padding-left:8px;" class="radiol" type="checkbox" name="enableNotification" id="enableNotification" value="1" <cfif Get.enableNotification eq "1">checked</cfif>></td>	
		<td class="#cl#" style="padding-left:3px;" id="email" valign="top">
		
		<table>
		
			<tr>	
					
					<td colspan="2" width="100%">
						<table>
							<tr>
								<!--- <td class="labelmedium" style="min-width:70px;padding-top:2px;padding-left:9px" valign="top"></td> --->
								<td class="labelmedium fixlength" style="min-width:80px;padding-left:3px;padding-right:5px">Actors On-the-fly:</td>
								<td style="padding-left:0px;"><input type="checkbox" class="radiol" name="NotificationFly" id="NotificationFly" value="1" <cfif Get.NotificationFly eq "1">checked</cfif>></td>											
								<td class="labelmedium fixlength" style="min-width:80px;padding-left:13px;padding-right:5px" title="Users that have been preset with access to this step">Role enabled actors:</td>
								<td><input type="checkbox" class="radiol" name="NotificationGlobal" id="NotificationGlobal" value="1" <cfif Get.NotificationGlobal eq "1">checked</cfif>> </td>
							</tr>	
						</table>
					</td>	
			</tr>
			
			<tr>
	 			<td class="labelmedium fixlength" style="padding-left:3px;">Apply Step jump:</TD>
				<td style="padding-left:3px">
				
					<table cellspacing="0" cellpadding="0">
					
					<tr>
					    <td><input type="checkbox" class="radiol" name="notificationondue" id="notificationondue" value="1" <cfif Get.NotificationDueOnJump eq "1">checked</cfif>></td>	 
				
			 			<td class="labelmedium fixlength" style="padding-left:3px">Show explicit dialog:</TD>
						<td style="padding-left:6px;"><input type="checkbox" class="radiol" <cfif Get.enableQuickProcess eq "1">disabled</cfif> name="notificationmanual" id="notificationmanual" value="1" <cfif Get.NotificationManual eq "1">checked</cfif>></td>	 
					</tr>
					
					</table>
					
				</td>	
			</tr>	
						
			<tr>
				<td class="labelmedium" style="padding-left:3px;" width="10%"><cf_tl id="Content"></td>
				<td style="padding-left:6px">
				
					<table cellspacing="0" cellpadding="0">
						<tr>
				        <td>
						<select name="DueMailCode" id="DueMailCode" style="width:100px" class="regularxxl">
			     			<option value="">Default</option>
						 	<cfloop query="Mail">
						 		<option value="#DocumentCode#"
						 		<cfif DocumentCode eq Get.DueMailCode>selected</cfif>>
								 	#DocumentDescription#
								</option>
				 			</cfloop>
						</select>				
						</td>
						<td class="labelmedium fixlength" style="padding-left:5px"><cf_tl id="Open step"></td>
							
						<td style="padding-left:4px">
						  <input type="checkbox" class="radiol" name="NotificationTarget" id="NotificationTarget" value="1" <cfif Get.NotificationTarget eq "1">checked</cfif>> </td>								
						</td>
						
						<cfif entity.DocumentPathName neq "">
							<td width="10%" class="labelmedium" style="padding-left:13px" title="Include source object attachments"><cf_tl id="Attachment"></td>
							<td width="5%"><input type="checkbox" class="radiol" name="NotificationAttachment" id="NotificationAttachment" value="1" <cfif Get.NotificationAttachment eq "1">checked</cfif>> </td>		
						</cfif>
						
						</tr>
					  </table>	
						
				</td>		
	
				
			</tr>		
			
			</tr>				
			
	    </table>
		
		</td></tr>
		</table>
		
  	 </td>
	 		
	</tr>
		
	<tr><td height="1" class="line" colspan="2"></td></tr>
		
	<tr><td colspan="2">
	
			<cfif URL.PublishNo eq "">
			<input class="button10g"  style="width:120;height:25" type="button" name="Delete" id="Delete" value="Remove" onClick="removeaction()">
			</cfif>
		
			<input class="button10g"  style="width:120;height:25" type="button" name="Update" id="Update" value="Apply" onClick="savequick('')">
			<cfparam name="url.action" default="flow">
		
	</td></tr>	
		
	</table>
					
</cfoutput>		