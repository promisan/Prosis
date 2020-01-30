
<cfparam name="URL.Tab" default="tab1">
<cfparam name="URL.PublishNo" default="">

<!--- retrieve data --->
<cfinclude template="ActionStepEditActionPrepare.cfm">

<cfoutput>

<table width="97%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr><td>	  
	 
<cfform action="ActionStepEditActionSubmit.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&save=2" 
		 method="POST" style="height:99%"
		 name="actionform">
		 
	<table width="97%" height="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			  
			<input type="Hidden" name="ActionCode" id="ActionCode" value="#Get.ActionCode#">
			<input type="Hidden" name="ActionCodeOld" id="ActionCodeOld" value="#Get.ActionCode#">
					
			<!--- Entry form --->
			
			<cfif get.actionType eq "Action">
			  <cfset s1 = "Reset">
			  <cfset s2 = "Submit">
			<cfelse>
			  <cfset s1 = "Denied">
			  <cfset s2 = "Agreed">
			</cfif>			
				 				 								
				<tr><td height="4"></td></tr>							   
									
						<cfif URL.PublishNo eq "">
						
							<TR>
						    <TD height="25" class="labelmedium"><cf_tl id="Parent Action">:</TD>
						    <TD class="labelmedium">
							
							<input type="hidden" name="EntityCode"  id="EntityCode" value="#URL.EntityCode#">
							<input type="hidden" name="EntityClass" id="EntityClass" value="#URL.EntityClass#">
								
							<cfif Get.ActionOrder neq "" and Get.ActionParent neq "INIT"> 
							
								<a href="stepedit('#Parent.ActionCode#')">#Parent.ActionCode# #Parent.ActionDescription#</a>
								
							    <cfif Parent.ActionType eq "Decision">
									<input type="hidden" name="ActionParent" id="ActionParent" value="">	
								<cfelse>
									<input type="hidden" name="ActionParent" id="ActionParent" value="#Parent.ActionCode#">	
								</cfif>
								
							<cfelse>	
							
								<select name="ActionParent" id="ActionParent" class="regularxl">
								<option value="INIT" selected>First step</option>
								<cfloop query="Parent">
								    <cfif Get.ActionType eq "Action" and Parent.ActionType eq "Decision">
									 <!--- not shown --->
									<cfelse>
										<cfif Get.ActionParent neq "" and Get.ActionParent neq "9999">
										  <option value="#Parent.ActionCode#" <cfif Parent.ActionCode eq Get.ActionParent> selected </cfif>>#Parent.ActionType#: #Parent.ActionCode# #Parent.ActionDescription#</option>
										<cfelseif Get.ActionParent eq "">
										  <option value="#Parent.ActionCode#" <cfif Parent.ActionOrder eq Last.ActionOrder> selected </cfif>>#Parent.ActionType#: #Parent.ActionCode# #Parent.ActionDescription#</option>
										</cfif>  
									</cfif>
									<!--- </cfif> --->
								</cfloop>
								</select>				
													
							</cfif>
							
							</TD>
														
							</TR>
									
						<cfelse>
						
							<cfif Get.ActionParent neq "">
							
								<TR>
							    <TD height="25" class="labelmedium"><cf_tl id="Parent Action">:</TD>
							    <TD colspan="2">
									<table width="100%" cellspacing="0" cellpadding="0">
									<tr><td class="labelmedium">
																
									<cfif Get.ActionParent eq "INIT">First action
										<input type="hidden" name="ActionParent" id="ActionParent" value="">	
									<cfelse>
										<a href="javascript:stepedit('#Parent.ActionCode#')">
										#Parent.ActionCode# #Parent.ActionDescription#
										</a>
										<input type="hidden" name="ActionParent" id="ActionParent" value="#Parent.ActionCode#">	
									</cfif>
									
									<cfif Get.ActionType eq "Decision">
							
									    <TD class="labelmedium">&nbsp;Show as Separate Branch:</TD>
									    <TD class="labelmedium">
										<input type="checkbox" class="radiol"  <cfif Get.ShowAsBranch eq "1">checked</cfif> name="ShowAsBranch" id="ShowAsBranch" value="1">
										</TD>
										
									</cfif>
																		
									</tr>
									</table>
								</TD>														
								</TR>
								
							<cfelse>
								<input type="hidden" name="ActionParent" id="ActionParent" value="">	
							</cfif>
						
						</cfif>
						
						<cfif url.PublishNo eq "">
						
						<TR>
					    	<TD height="25" class="labelmedium">Descriptive | Doit | <cf_UIToolTip tooltip="Descriptive of the actor for this step. <br>Has only a descriptive purpose as access is granted through the security settings">Actor</cf_UIToolTip>:</TD>
						    <TD colspan="2">
							<table>
								<tr>	
								<td>
							<cfinput  
							    type="Text" 
								value="#Get.ActionDescription#"  
								name="ActionDescription" class="regularxl"
								required="No" size="45" maxlength="80">
								</td>
																						
								<td style="padding-left:1px">
								<cfinput  
								    type="Text" 
									value="#Get.ActionProcess#"  
									name="ActionProcess" class="regularxl"
									required="No" size="10" maxlength="20">
								</td>
								
									<td style="padding-left:4px">
										<cfinput class="regularxl" type="Text" value="#Get.ActionReference#"  name="ActionReference" message="Please enter an actor reference" required="No" size="18" maxlength="20">
									</td>						
									<td class="labelmedium">
									<cf_UIToolTip tooltip="Check this box only if this action should not be availalble for interactive processing and is updated through a script or stored procedure">
									&nbsp;&nbsp;API:&nbsp;
									</cf_UIToolTip>
									</td>
							        <TD height="25" class="labelmedium">
									 <input type="checkbox" <cfif Get.ActionTrigger eq "External">checked</cfif> name="ActionTrigger" id="ActionTrigger" value="External">
															
									</td>
								
								</tr>
								</table>
							</td>
						</TR>
						
							<!--- do not allow --->
						
						<cfelse>
						
						<TR>
					    	<TD height="25" class="labelmedium">Descriptive | Doit | <cf_UIToolTip tooltip="Descriptive of the actor for this step. <br>Has only a descriptive purpose as access is granted through the security settings">Actor</cf_UIToolTip>:</TD>
						    <TD colspan="2">
							<table>
								<tr>	
								<td>
							<cfinput  
							    type="Text" 
								value="#Get.ActionDescription#"  
								name="ActionDescription" class="regularxl"
								required="No" size="45" maxlength="80">
								</td>
																						
								<td style="padding-left:1px">
								<cfinput  
								    type="Text" 
									value="#Get.ActionProcess#"  
									name="ActionProcess" class="regularxl"
									required="No" size="10" maxlength="20">
								</td>
								
									<td style="padding-left:4px">
										<cfinput class="regularxl" type="Text" value="#Get.ActionReference#"  name="ActionReference" message="Please enter an actor reference" required="No" size="18" maxlength="20">
									</td>						
									<td class="labelmedium">
									<cf_UIToolTip tooltip="Check this box only if this action should not be availalble for interactive processing and is updated through a script or stored procedure">
									&nbsp;&nbsp;API:&nbsp;
									</cf_UIToolTip>
									</td>
							        <TD height="25" class="labelmedium">
									 <input type="checkbox" <cfif Get.ActionTrigger eq "External">checked</cfif> name="ActionTrigger" id="ActionTrigger" value="External">
															
									</td>
								
								</tr>
								</table>
							</td>
						</TR>
						
						</cfif>
													
					    <TR>
					    <TD width="25%" height="25" class="labelmedium" style="padding-left:15px">Label Step Completed:</TD>
					    <TD colspan="2">
						<cfinput 
						    type="Text" 
							class="regularxl"
							value="#Get.ActionCompleted#"  
							name="ActionCompleted" 
							required="No" size="59" maxlength="80">
						</TD>
						</TR>
						
						  <TR>
					    <TD width="25%" height="25" class="labelmedium" style="padding-left:15px">Label Step Denied:</TD>
					    <TD colspan="2">
						<cfinput 
						    type="Text" 
							class="regularxl"
							value="#Get.ActionDenied#"  
							name="ActionDenied" 
							required="No" size="59" maxlength="80">
						</TD>
						</TR>
												
					   																						
					<tr><td height="5"></td></tr>
															
					<tr>
					<td colspan="3" height="100%" style="padding-bottom:1px" valign="top">
					
					<cfif url.publishno eq "">
					
						<cfquery name="Access" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM   Ref_EntityAction
							WHERE  EntityCode    = '#URL.EntityCode#'
							AND    Operational   = '1' 
							AND    ActionCode   != '#URL.ActionCode#'
							AND    ListingOrder <= (SELECT ListingOrder 
							                        FROM   Ref_EntityAction 
												    WHERE  ActionCode = '#URL.ActionCode#')
						</cfquery>
					
					<cfelse>
					
						<cfquery name="Access" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM   Ref_EntityAction
							WHERE  EntityCode    = '#URL.EntityCode#'
							AND    Operational   = '1' 
							AND    ActionCode   != '#URL.ActionCode#'
							AND    ActionCode IN (
													SELECT ActionCode
												    FROM   Ref_EntityActionPublish
													WHERE  ActionPublishNo = '#URL.PublishNo#'													
													AND    ActionOrder < '#get.ActionOrder#'
													)
						</cfquery>
										
					</cfif>					
															
					<table height="100%" width="100%">
					
					<tr>
					
						<td height="100%" valign="top" style="min-width:180px;padding-right:2px;border-right:1px solid silver">	
												
							<table>
							<tr class="line">
														
							<cfset ht = "40">			
							<cfset wd = "40">
			
							<cfset add = 1>
					
							<cfset itm = 1>
							<cf_menutab base       = "sub"
							            item       = "#itm#" 
							            iconsrc    = "Logos/System/Settings.png" 
										iconwidth  = "#wd#" 
										iconheight = "#ht#" 
										height     = "60" 
                                        width      = "60" 
										target     = "subbox"
										targetitem = "#itm#"
										class      = "highlight"
										type       = "vertical"
										name       = "Standard Settings">		
										
							</tr>
							
							<tr class="line">	
							
							<cfquery name="qLanguage"
							datasource="AppsSystem" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT Code as LanguageCode
								FROM   Ref_SystemLanguage
								WHERE  (Operational = '2') 
						    </cfquery>	
							
							<cfif qLanguage.recordcount gt 0>		
						
								<tr class="line">
								<cfset itm = itm+1>
								<cf_menutab base       = "sub"
								            item       = "#itm#" 
								            iconsrc    = "Logos/System/Language.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											height     = "60" 
                                            width      = "60"
											target     = "subbox"
											targetitem = "#itm#"
											type       = "vertical"
											name       = "Language Label">		
								</tr>		
							</cfif>								
							
							<cfif Access.recordcount gte "1" or Entity.PersonClass neq "">
							
								<tr class="line">
								<cfset itm = itm+1>
								<cf_menutab base       = "sub"
								            item       = "#itm#" 
								            iconsrc    = "Logos/System/Authorization.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											height     = "60" 
											target     = "subbox"
											targetitem = "#itm#"
											type       = "vertical"
											name       = "Authorization">	
								</tr>			
					   
						     </cfif>						
							
							<tr class="line">
													
							<cfset itm = itm+1>
								<cf_menutab base       = "sub"
								            item       = "#itm#" 
								            iconsrc    = "Logos/System/DialogsFields.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											height     = "60" 
											target     = "subbox"
											targetitem = "#itm#"
											type       = "vertical"
											name       = "Custom Dialogs and Fields"
											source     = "../../EntityObject/WorkflowElement/ClassDocument.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#">	
													
							</tr>
							
							<tr class="line">
							
								<cfset itm = itm+1>
								<cf_menutab base       = "sub"
								            item       = "#itm#" 
								            iconsrc    = "Logos/System/Mail.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											height     = "60" 
											target     = "subbox"
											targetitem = "#itm#"
											type       = "vertical"
											name       = "Mail and Performance">	
												
							</tr>
							
							<tr class="line">
							
								<cfset itm = itm+1>
								<cf_menutab base       = "sub"
								            item       = "#itm#" 
								            iconsrc    = "Logos/System/Documents.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											height     = "60" 
											target     = "subbox"
											targetitem = "#itm#"
											type       = "vertical"
											name       = "Documents">	
												
							</tr>
							
							<tr class="line">
							
								<cfset itm = itm+1>
								<cf_menutab base       = "sub"
								            item       = "#itm#" 
								            iconsrc    = "Logos/System/WorkflowMethods.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											height     = "60" 
											target     = "subbox"
											targetitem = "#itm#"
											type       = "vertical"
											name       = "Methods">	
												
							</tr>
							
							</table>				
																					
						</td>					
						<td height="100%" width="90%" valign="top" style="padding-left:10px">
						
						<table width="100%" height="100%">					
																								
						<cfset itm = 1>						
						<cf_menucontainer name="subbox" item="#itm#" class="regular">	
							<cfinclude template="ActionStepEditActionSettings.cfm">		
						</cf_menucontainer>
						
						<cfquery name="qLanguage"
							datasource="AppsSystem" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT  Code as LanguageCode
							FROM    Ref_SystemLanguage
							WHERE   Operational   = '2' 
						</cfquery>
					   
					    <cfif qLanguage.recordcount gt 0>
					   
					   	   <cfset itm = itm+1>
					   	   <cf_menucontainer name="subbox" item="#itm#" class="hide">						
								<cfinclude template="ActionStepEditActionLanguage.cfm">								
						   </cf_menucontainer>
											   					   
					    </cfif>				
						
					   
					    <cfif Access.recordcount gte "1" or Entity.PersonClass neq "">
							
							<cfset itm = itm+1>
							<cf_menucontainer name="subbox" item="#itm#" class="hide">	
								<cfinclude template="ActionStepEditActionAuth.cfm">	
							</cf_menucontainer>
													   
					    </cfif>		
						
						<!--- custom --->
						
						<cfset itm = itm+1>
						<cf_menucontainer name="subbox" item="#itm#" class="hide"/>	
											
												
						<!--- mail --->
												
						<cfset itm = itm+1>
						<cf_menucontainer name="subbox" item="#itm#" class="hide">	
							<cfparam name="url.ajax" default="No">
							
							<cfinclude template="ActionStepEditActionMail.cfm">			
						</cf_menucontainer>				
						
						<!--- docs --->
												
						<cfset itm = itm+1>
						<cf_menucontainer name="subbox" item="#itm#" class="hide">	
							<cfinclude template="ActionStepEditActionEmbed.cfm">		
						</cf_menucontainer>		
						
						<!--- methods --->
												
						<cfset itm = itm+1>
						<cf_menucontainer name="subbox" item="#itm#" class="hide">	
						
							<table width="100%" height="100%"><tr><td valign="top">
							
								<cf_divscroll>								
						
								<table width="97%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
							
									<tr><td height="0" id="verifytab"></td></tr>
									<tr><td height="4"></td></tr>
									<tr><td align="center" valign="top">
																										
										<cfinclude template="ActionStepEditActionMethod.cfm">	
																
									</td></tr>
							
								</table>	
							
								</cf_divscroll>
							
							</td></tr></table>	
							
						</cf_menucontainer>										   							
					    														
						</table>
						
						</td>
					
					</tr>				
					
					</table>
																	
					</td></tr>							
						
				</table>
				
	</CFFORM>		
	
	</td></tr>		
	</table>	
	
</cfoutput>
