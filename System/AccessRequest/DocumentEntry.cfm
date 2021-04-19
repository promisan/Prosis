
<cf_ActionListingScript>
<cf_dialogOrganization>
<cf_dialogLookup>
<cf_presentationScript>

<cfparam name="url.drillid" default="">

<cfquery name="get" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   UserRequest
	<cfif url.drillid eq "">
	WHERE 1=0
	<cfelse>
	WHERE  RequestId = '#url.drillid#' 
	</cfif>		
</cfquery>

<cfif get.recordcount eq "1">
	<cfif get.ActionStatus gte 1>
		<cfset url.mode = "view">
	<cfelse>
	  	<cfset url.mode = "edit">
	</cfif>
<cfelse>
  	<cfset url.mode = "new">  
</cfif>

<cf_tl id="Access Request" var="1">

<cf_screentop html="no" jquery="Yes" layout="webapp" label="Request for user access">

<cfset showRoleSection  = 1>
<cfset showGroupSection = 1>
<cfset showPortalSection= 1>

<cfif url.mode eq "new">
 
	 <cf_assignId>
	 <cfset RequestId = "#rowguid#">
	 
<cfelseif url.mode eq "edit" or url.mode eq "view">
 
 	<cfset RequestId = "#url.drillid#">
	 
	<cfquery name="Request" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   UserRequest
		WHERE  RequestId = '#RequestId#'
	</cfquery>
	
	<cfif url.mode eq "view">
		
			<cfquery name="Show" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 
				(SELECT COUNT (*) FROM UserRequestAccess WHERE RequestId = R.RequestId) AS Role,
				(SELECT COUNT (*) FROM UserRequestModule WHERE RequestId = R.RequestId) AS Portal,
				(SELECT COUNT (*) FROM UserRequestUserGroup WHERE RequestId = R.RequestId) AS AGroup
				FROM    UserRequest R
				WHERE   R.RequestId = '#RequestId#' 
			</cfquery>
		
			<cfset showRoleSection  = Show.Role>
			<cfset showGroupSection = Show.AGroup>
			<cfset showPortalSection= Show.Portal>
		
	</cfif>	
	 
</cfif>

<cfinclude template="AccessRequestScript.cfm">

<!---
<cfquery name="SystemModule" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	   SELECT * 
	   FROM   Ref_SystemModule S
	   WHERE  SystemModule IN 
				(
					SELECT  SystemModule
					FROM    Organization.dbo.Ref_AuthorizationRole
					WHERE   SystemModule = S.SystemModule
				)
	   AND    Operational = 1
	   
	 <!--- <cfif url.mode eq "edit" or url.mode eq "view"> --->
  	  <cfif url.mode eq "view">
	   AND    SystemModule = '#Request.SystemModule#'
	  </cfif>
	   
</cfquery>
--->

<!--- first we check the mode of the user, if this is a owner controller or a regular user --->

<cfquery name="Entity" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM    Ref_Entity
  WHERE   EntityCode  = 'AuthRequest'
</cfquery>

<cfquery name="getController" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT   R.Owner
	FROM     Organization.dbo.OrganizationAuthorization AS A INNER JOIN
	         Organization.dbo.Ref_EntityGroup AS R ON A.GroupParameter = R.EntityGroup
	WHERE    A.UserAccount   = '#SESSION.acc#' 
	AND      A.Role          = '#Entity.role#' 
	AND 	 R.EntityCode    = 'AuthRequest' 		
</cfquery>

<cfif getController.recordcount gte "1" or SESSION.isAdministrator eq "Yes">
	 <cfset controller = "1">	 	
<cfelse>
	 <cfset controller = "0">			
</cfif>

<cfform method="POST" name="requestAccessForm" onsubmit="return false">
	
    <cfoutput>  
	    <input type="hidden" value="#RequestId#" name="RequestId"   id="RequestId">    
	    <!--- To be implemented  --->    
	    <input type="hidden" value=""            name="Reference"   id="Reference">
	    <input type="hidden" value=""            name="RequestName" id="RequestName">
    </cfoutput>
  
  	<table cellpadding="0" cellspacing="0" width="100%" height="100%">
	
		<tr>
			<td height="50">
			    <cfif controller eq "1">				
					<cf_viewtopmenu label="System Access Request" option="<font color='FFFFFF'>mode: Controller</font>" layout="webapp" background="gray">					
				<cfelse>				
					<cf_viewtopmenu label="System Access Request" option="<font color='FFFFFF'>mode: End user</font>" layout="webapp" background="red">				
				</cfif>					
			</td>
		</tr>	
		
		<cfif url.drillid neq "">			
		
			<tr>
				<td height="1" align="center">
					<cf_securediv id="status" bind="url:getActionStatus.cfm?ajaxid=#url.drillid#">
				</td>
			</tr>
			<tr><td height="1" class="linedotted"></td></tr>
		
		</cfif>
		
		<tr>	
			<td style="padding-top:10px">  
			    
			<cf_divscroll>
			
				<cfquery name="Workgroup" 
					datasource="AppsSystem">
					    SELECT  *
						FROM    Ref_Application
						WHERE   HostName = '#CGI.HTTP_HOST#'
				</cfquery>
				
				<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
										
					<cfif url.mode eq "new">
					
						<cfquery name="Owner" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT   *
									FROM     Ref_AuthorizationRoleOwner				
								</cfquery>
																	
						<cfif owner.recordcount eq "1">
						
							<input type="hidden" name="owner" id="owner" value="<cfoutput>#owner.Code#</cfoutput>">
							
						<cfelse>
						
						<tr>
							<td width="20px"></td>
							<td style="padding-left:10" class="labelmedium" width="20%" align="left"><cf_tl id="Owner">:<font color="#FF0000">*</font></td>
															
							<td class="labelmedium">
										
								<cfselect name="owner" id="owner" class="regularxl">
								
								    <cfoutput query="Owner">
									
									    <cfif controller eq "1">
									
											<cfinvoke component = "Service.Access"  
												method           = "ShowEntity" 
												entityCode       = "AuthRequest"				
												Owner            = "#code#"
												returnvariable   = "access">
											
											<cfif Access eq "EDIT" or Access eq "ALL">										   
												<option value="#Code#" <cfif Workgroup.Owner eq Code>selected</cfif>>#Code#</option>
											</cfif>
										
										<cfelse>
										
											<option value="#Code#" <cfif Workgroup.Owner eq Code>selected</cfif>>#Code#</option>
										
										</cfif>
										
									</cfoutput>		
								
							    </cfselect>
								
							</td>
						</tr>	
						</cfif>
						
					<cfelse>
					
						<input type="hidden" name="owner" id="owner" value="<cfoutput>#get.Owner#</cfoutput>">
						
					</cfif>
					
					<tr>
					
						<td width="20px"></td>
					
						<td style="padding-left:10" class="labelmedium" width="20%" align="left"><cf_tl id="Application">:<font color="#FF0000">*</font></td>					
					
					    <td class="labelmedium">			

							<cfif url.mode eq "new">
							
								<cfdiv bind="url:DocumentEntryGroup.cfm?owner={owner}&workgroup=#Workgroup.code#" id="workgrp"/>		
								
							<cfelseif url.mode eq "edit">
							
								<cfdiv bind="url:DocumentEntryGroup.cfm?workgroup=#get.Application#&owner={owner}&workgroup=#Workgroup.code#" id="workgrp"/>	
									
							<cfelse>
							
								<input type="hidden" id="Workgroup" name="Workgroup" value="#get.Application#">
								<cfoutput>
									#get.Application#
								</cfoutput>
								
							</cfif>
									
						</td>
					</tr>
					<tr>
						<td width="20px"></td>
					
						<td style="padding-left:10" class="labelmedium" width="20%" align="left"><cf_tl id="Entity">:<font color="#FF0000">*</font></td>
						
						<td class="labelmedium">	
							   		
							<cfif url.mode eq "new" or url.mode eq "edit">
							
								  <cfdiv id="div_mission"/>
							   	   
							<cfelseif url.mode eq "view">
						  
								  <cfoutput>
								 	<input type="hidden" name="Mission" id="Mission" value="#Request.Mission#">
								  	#Request.Mission#
								  </cfoutput>
								
					    	</cfif>		

						</td>																					
																					
					</tr>
					
					<tr>	
					   <td width="20px"></td>
					   <td style="padding-left:10" class="labelmedium" align="left"><cf_tl id="Email notification">:</td>
					   <td class="labelmedium" width="100px">		
					   
					   <cfset emailAddress = client.Email>
					   
					   <cfif url.mode neq "new">
					   		<cfif Request.MailAddress neq "">
								<cfset emailAddress = Request.MailAddress>
							</cfif>
					   </cfif>
					   
					   <cfif url.mode neq "view">
						  
						   	<cfinput type="Text"
						       name="eMail"
						       message="Please enter a valid eMail address"	      
							   OnChange="ColdFusion.navigate('AccessRequestMail.cfm?address='+this.value,'mailfailure')"
						       required="No"
							   tooltip="please enter a valid eMail address"
						       visible="Yes"
						       enabled="Yes"
							   value="#emailAddress#"
						       size="40"
						       maxlength="100"
						       class="regularxl">
							   
					   <cfelse>
					   		
							 <cfoutput>#emailAddress#</cfoutput>
							 
					   </cfif>
					   </td>
					   <td id="mailfailure" colspan="3" align="left" width="70%" style="padding-left:15"></td>
					</tr>
					
					<tr>
						<td width="20px"></td>
						<td style="padding-top:3px;padding-left:10" class="labelmedium" valign="top">Describe access needed: <cf_space spaces="70"></td>
						<td class="labelmedium" colspan="4">
						     <cfif url.mode neq "view">
								<cfoutput>	
									<textarea style="width:97%;height:70;font-size:13px;padding:3px" 
									   class="regular"  
									   name="RequestMemo" 
									   id="RequestMemo"><cfif url.mode neq "new">#Request.RequestMemo#</cfif></textarea>
								</cfoutput>
							<cfelse>
								<cfoutput>
									#Request.RequestMemo#
								</cfoutput>
							</cfif>
						</td>
					</tr>
					
					<tr><td colspan="6" height="10px"></td></tr>
					
					<tr>
						<td colspan="6" style="padding-left:20px;padding-right:20px">
							
							<table cellpadding="0" cellspacing="0" width="100%">
								
								<!--- acc --->
								<tr valign="bottom">
									<td colspan="6">
										<table cellpadding="0" cellspacing="0" align="left" style="cursor: pointer; display:block" onClick="toggleDisplay('rowAcc','imageAcc')">
											<tr>
												<td width="20px" style="padding-left:5px">
													<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/arrowdown.gif" 
														 id="imageAcc" 
														 alt="" 
														 border="0" 
														 align="absmiddle" 
														 class="show" 
														 style="cursor: pointer; display:block">
												</td>
												
												<td style="padding-left:10px" valign="bottom" class="labelmedium">													
														<cf_tl id="Apply to the following users">													
												</td>
											</tr>
										</table>				
									</td>
								</tr>								
										
								<tr><td height="3" colspan="6"></td></tr>
								<tr><td colspan="6" height="1" class="linedotted"></td></tr>
								<tr><td height="3" colspan="6"></td></tr>
								
								<tr id="rowAcc" class="show">	
								   <td align="left" width="95%" colspan="6">		
								   
								        <table width="100%" cellspacing="0" cellpadding="0">
										<tr><td>
								   
								   		<cfset accountRequest = 0>
								   
										<table class="navigation_table" id="accTable" name="accTable" align="center" width="95%" cellpadding="0" cellspacing="0">
										
											<cfif url.mode eq "edit" or url.mode eq "view">							
											
											    <cfquery name="UserNames" 
												datasource="AppsSystem" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
														
													SELECT UN.Account, UN.LastName, UN.FirstName
													FROM   UserRequestNames URN
													INNER  JOIN UserNames   UN
														   ON  URN.Account = UN.Account
													WHERE  RequestId = '#RequestId#'
													
												</cfquery>
											
												<cfif UserNames.recordcount gt 0>
											
													<cfoutput query="UserNames">
														<tr>							
															<td width="50px" class="labelmedium" style="padding-left:3px">#currentrow#.</td>				
															<td height="20px" align="left" class="labelmedium">
																 <a style="color:##0D9FEE;" href="javascript:ptoken.open('#session.root#/System/Access/User/UserDetail.cfm?ID=#account#', 'wViewUser', 'status=yes, height=900px, width=1100px, center=yes, scrollbars=no, toolbar=no, resizable=yes');">#LastName#, #FirstName# (#Account#)</a>
																 <input type="hidden" name="user" id="user" value="#Account#">
															</td>
															
															<td style="padding-top:2px">
																<cfif url.mode eq "edit">
																   <cf_img icon="delete" script="removeAccount(this);">																   
																</cfif>
															</td>
														</tr>
														<tr class="hide">
															<td></td>
															<td id="#Account#_details"></td>
															<td></td>
														</tr>
														<tr>											
															<td class="linedotted" colspan="3"></td>
														</tr>
													</cfoutput>
													
												<cfelse> <!--- No user account means: this is an account request --->
													
													<cfquery name="NewAccount" 
													datasource="AppsSystem" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
														
														SELECT  *
														FROM    UserRequestNewAccount A
														WHERE   RequestId = '#RequestId#'
													
													</cfquery>					
													
													<cfset accountRequest = 1>
													
													<tr>			
														<td width="50px"></td>									
														<td width="90%" height="20px" align="left" class="labelmedium">
															<cfoutput>
															#NewAccount.LastName#, #NewAccount.FirstName# (#NewAccount.eMailAddress#)
															</cfoutput>
															 <input type="hidden" name="user" id="user" value="">
														</td>
														
														<td>
															
														</td>
													</tr>
													<tr>									
														<td></td>		
														<td class="linedotted" colspan="2"></td>
													</tr>
													
												</cfif>
											
											</cfif>
										
										</table>
										
										</td>
										</tr>
										
										<tr class="hide"><td id="acc_row"></td></tr>
										
										<cfif url.mode neq "view" and accountRequest  neq 1>
										
											<tr><td colspan="6" height="20" style="padding-left:40px" class="labelmedium">			
											<cf_selectlookup
												box          = "acc_row"
												title        = "Select users"
												link         = "getRequestAccount.cfm?x=1"  
												<!--- dummy param url.x eq "1" is needed for Userresult.cfm to work in FF--->
												button       = "no"
												icon         = "add.png"
												close        = "No"
												class        = "user"
												des1         = "acc">	
											</td></tr>
										
										</cfif>
										
										</table>		
							
									</td>
								</tr>
								<!--- /acc --->								
								
								<cfif url.mode neq "view" or showGroupSection gt 0>
							
								<tr valign="bottom">
									<td colspan="6" align="left" height="45">
										<table cellpadding="0" cellspacing="0" align="left" style="cursor: pointer; display:block" onClick="javascript:toggleDisplay('rowGroup','imageGroup')">
											<tr>
												<td width="20px" style="padding-left:5px">	
													<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/arrowdown.gif" 
														id="imageGroup" alt="" border="0" 
														class="show" style="cursor:pointer; display:block">
												</td>
												
												<td style="padding-left:10px" class="labelmedium">													
														<cf_tl id="Assign Usergroup">												
												</td>
												
												<cfinvoke component = "Service.Access"  
												   method           = "UserAdmin"
												   returnvariable   = "AccessRight">   
															   
												<cfif AccessRight neq "NONE" and AccessRight neq "">
												
												<td style="padding-left:10px" class="labelmedium">
													<cfoutput>
														<a style="color:##0080C0;" href="javascript:ptoken.open('#SESSION.root#/System/Access/user/UserEntry.cfm?ID=Group&ts='+new Date().getTime(), 'wAddGroup', 'status=yes, height=500px, width=550px, center=yes, scrollbars=no, toolbar=no, resizable=yes');">
															[<cf_tl id="New">]
														</a>
													</cfoutput>
												</td>
												
												</cfif>
											</tr>
										</table>
									</td>
								</tr>
								
								<tr><td colspan="6" class="line"></td></tr>
								
								<tr><td height="3" colspan="6"></td></tr>					
							
								<tr id="rowGroup" class="regular">
																	
									<td colspan="6" style="padding-left:20px;padding-right:20px">
																			  
										<cfif url.mode neq "view">
										  
										  	<cfdiv id="igroup">
											
										<cfelse>										
																				
											<cf_securediv bind="url:AccessRequestGroup.cfm?mode=view&requestid=#requestid#&mission=#request.Mission#&application=#request.Application#" id="igroup">
											
										</cfif>

									</td>
									
								</tr>
							
								</cfif>
							
								<tr>
									<td height="10" colspan="6"></td>
								</tr>													
							
								<cfif url.mode neq 'view' or showPortalSection gt 0>
								
								<tr valign="bottom">
									<td colspan="6">
										<table cellpadding="0" cellspacing="0" align="left" style="cursor: pointer; display:block" onClick="toggleDisplay('rowPortal','imagePortal')">
											<tr>
												<td width="20px" style="padding-left:5px">
													<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/arrowdown.gif" 
														id="imagePortal" alt="" border="0" 
														align="absmiddle" class="show" style="cursor: pointer; display:block">
												</td>
												
												<td style="padding-left:10px" class="labelmedium">
													Grant Portal Access
												</td>
											</tr>
										</table>				
									</td>
								</tr>
							
								<tr><td colspan="6" class="line"></td></tr>
								
								<tr>
									<td height="3" colspan="6"></td>
								</tr>
							
								<tr id="rowPortal" class="show">									
									<td colspan="5" style="padding-left:20px;padding-right:20px">
										<cfoutput>
										    <cf_securediv bind="url:AccessRequestPortal.cfm?mode=#url.mode#&requestid=#RequestId#" id="iportal">
										</cfoutput>
									</td>									
								</tr>
								
								</cfif>
								
								<tr>
									<td height="10" colspan="6"></td>
								</tr>		
								
								<cfif (url.mode neq 'view' or showRoleSection gt 0) and controller eq "1">
								
								    <cfquery name="RolesCount" 
									datasource="AppsSystem" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT *
										FROM   UserRequestAccess
										WHERE  RequestId = '#RequestId#'
									</cfquery>								
								
								<tr valign="bottom">
									<td colspan="6" valign="middle" height="45">
										<table cellpadding="0" cellspacing="0" align="left" style="cursor: pointer; display:block" onClick="javascript:toggleDisplay('rowRole','imageRole')">
											<tr>
												<td width="20px" style="padding-left:5px">
													
													<cfif RolesCount.recordcount gt 0>
														<cfset roleIcon = "arrowdown.gif">
													<cfelse>
														<cfset roleIcon = "arrowright.gif">
													</cfif>
												
													<img src="<cfoutput>#SESSION.root#/Images/#roleIcon#</cfoutput>" 
														id="imageRole" alt="" border="0" 
														 class="show" style="cursor: pointer; display:block">
												</td>
												
												<td style="padding-left:6px" class="labelmedium">													
														Role(s) to be applied for the selected user(s)													
												</td>
											</tr>
										</table>				
									</td>
								</tr>
							
								
								<tr><td colspan="6" class="line"></td></tr>
							
								<tr id="rowRole" class="<cfif RolesCount.recordcount gt 0>show<cfelse>hide</cfif>">									
									<td colspan="6" style="padding-right:20px;padding-left:20px">
									
										<cfif url.mode neq "view">
											<cfdiv id="irole">
										<cfelse>
											<cf_securediv bind="url:AccessRequestRole.cfm?mode=view&requestid=#requestid#&application=#request.application#" id="irole">
										</cfif>
									</td>									
								</tr>
								
								</cfif>		
								
								<tr>
									<td height="10" colspan="6"></td>
								</tr>	
								
							</table>
							
						</td>
					</tr>									
												
					<cfif url.mode neq "view">
					<tr>
						<td colspan="6" height="30" align="center" id="save">
							
								<table cellpadding="0" cellspacing="0" align="center">
									<tr>
									    <!---
										<td>
											<cf_button label="Close" onclick="window.close()" color="black" fontfamily="calibri" fontsize="12px" width="140" fontweight="normal">
										</td>
										--->
										<td>
											<cfoutput>
												
												<cfif url.mode eq "new">		
																		
													<cf_tl id="New Request" var="1">
													
													<cf_button id="action" 
												   label="#lt_text#" 
												   type="submit" 
												   mode="graylarge"
												   onClick="submitForm('#url.mode#');" 
												   color="black" 
												   width="170" 
												   fontfamily="calibri" 
												   fontsize="12px" 
												   fontweight="normal">
													
												<cfelseif url.mode eq "edit">
												
													<cfif getAdministrator("*") eq "1">
												   
													   <cf_tl id="Remove" var="1">
													   
													   	<cf_button id="delaction" 
														   label="#lt_text#" 
														   type="submit" 
														   mode="graylarge"
														   onClick="submitForm('purge');" 
														   color="black" 
														   width="170" 
														   fontfamily="calibri" 
														   fontsize="12px" 
														   fontweight="normal">
												   
												   </cfif>				
												
													<cf_tl id="Update" var="1">
													
													<cf_button id="action" 
													   label="#lt_text#" 
													   type="submit" 
													   mode="graylarge"
													   onClick="submitForm('#url.mode#');" 
													   color="black" 
													   width="170" 
													   fontfamily="calibri" 
													   fontsize="12px" 
													   fontweight="normal">
												   													
												</cfif>
																								
											</cfoutput>
											
											<cfdiv id="detailsubmit">
											
										</td>
									</tr>
								</table>
						</td>
					</tr>	
					</cfif>						
					
					<cfif get.Requestid neq "">
												 
						<tr>
						   <td colspan="4">
						
						   <cfset wflnk = "DocumentWorkflow.cfm">   
						   
						   <cfoutput>
						  
						    <input type="hidden" 
						     name="workflowlink_#get.RequestId#" id="workflowlink_#get.RequestId#"
						     value="#wflnk#"> 
							 
							<input type="hidden" 
						   	   name="workflowlinkprocess_#get.RequestId#" id="workflowlinkprocess_#get.RequestId#"
						       onclick="ColdFusion.navigate('getActionStatus.cfm?ajaxid=#get.RequestId#','status')">		
								 
							 </cfoutput>
							 							 
							</td>
							
						</tr>  
												
						<tr>
							<td colspan="6" style="padding-left:20px;padding-right:20px;border: 0px solid Silver;"
							id="<cfoutput>#get.RequestId#</cfoutput>">	
							
								<cfset url.ajaxid = get.RequestId>							
								<cfinclude template="#wflnk#">				
								
							</td>
						</tr>							
						<tr> <td colspan="6" height="15"> </td> </tr>
						
					</cfif>								
					
				</table>				
				
				</cf_divscroll>				
				
			</td>
		</tr>
				
	</table>
	
</cfform>

