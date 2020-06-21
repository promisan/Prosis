			
	<cfparam name="color"          	default="white">
	<cfparam name="align"         	default="center">
	<cfparam name="displayMode" 	default="1"> <!--- 1=horizontal, 2=vertical --->
	<cfparam name="showSupport"    	default="1">
	<cfparam name="showRequest"    	default="1">
	<cfparam name="showForgot"    	default="1">
	<cfparam name="linksAlign"    	default="center">
	<cfparam name="submitAlign"    	default="right">
	<cfparam name="showLine"    	default="1">
	
	<cfparam name="client.logoncredential" default="#session.acc#">
	
	<cfif client.logoncredential neq "">
	    <cfset logon = client.logoncredential> 
	<cfelse>
		<cfset logon = "">
	</cfif>
					
	<cfinvoke component = "Service.Process.System.Client"  
	   method           = "getBrowser"
	   browserstring    = "#CGI.HTTP_USER_AGENT#"	  
	   returnvariable   = "thisbrowser"
	   minIE            = "7">	      
	
	<cfif thisbrowser.pass eq "0">	
	
		<cfoutput>
		<table><tr><td class="labelmedium" style="padding-top:4px"><b>
		The backoffice ERP modules are not supported under #thisbrowser.name# #thisbrowser.release#. <br><br>Please use IE10+.</cfoutput>	
		</td></tr></table>
		
	<cfelse>		
		
		<cfif displayMode eq "1">
				
		    <cfoutput>
			<table cellspacing="0" cellpadding="0" align="<cfoutput>#align#</cfoutput>" border="0" class="formpadding">		
				<tr>		
					<td class="labelit" style="color:<cfoutput>#color#</cfoutput>; font-size:13px">
					    <cf_space spaces="34">						
						<cf_tl id="User name">:
					</td>			
					<td style="padding-left:10px;">
						<input name="account" id="account" required="yes" class="regularxl enterastab" style="text-align: center;" type="text" value="<cfoutput>#logon#</cfoutput>" size="18"  maxlength="30" onchange="document.getElementById('password').value='';" onblur="document.getElementById('password').value='';">
					</td>					                  
					<td class="labelit" style="padding-left:20px; color:<cfoutput>#color#</cfoutput>; font-size:13px">
						<cf_tl id="Password">:
					</td>			  
					<td style="padding-left:10px;">
					
						<input type="password" 
						   name="password" 
						   required="yes" 
						   id="password" 
						   size="18" 
						   maxlength="50" 
						   class="passwordxl" 
						   autocomplete="off" 
						   onKeyUp="go(event)"
						   style="text-align: center;" 
						   onfocus="this.value=''; this.focus();">
					</td>			             
					<td style="padding-left:10px;">			
					
						<input type="button" style="height:25px;width:100px" class="button10g" name="Submit" id="Submit" value="Login"
						  onclick="openmenu('acc','pwd')">
						  
					</td>		
				</tr>		
				<tr>
					<td colspan="5" align="right" style="padding-left:70px; padding-top:6px">		
						<table cellspacing="0" cellpadding="0" align="right">
							<tr>
								<cfif Parameter.SystemSupportPortalId neq "" and ShowSupport eq 1>
									<td>
										<cfquery name="Link" 
											datasource="AppsSystem">
											SELECT    *
											FROM      PortalLinks
											WHERE     PortalId = '#Parameter.SystemSupportPortalId#'
										</cfquery>		
										<cfoutput>		 
											<a href="support.cfm?id=#Parameter.SystemSupportPortalId#" style="color:<cfoutput>#color#</cfoutput>" target="_new">
												#Link.Description#
											</a>
										</cfoutput>		
									</td>
									
									<cfif showRequest eq 1>
										<td style="color:<cfoutput>#color#</cfoutput>">
											&nbsp;&nbsp;|&nbsp;&nbsp;
										</td>
										
										<td>		
											<cfoutput>		 
												<a href="#session.root#/Portal/SelfService/Extended/Account/AccountRequestForm.cfm?showClose=0&id=support" style="color:<cfoutput>#color#</cfoutput>" target="_new">
													<cf_tl id="Request Access">
												</a>
											</cfoutput>		
										</td>
									</cfif>
									
								
								<td style="color:<cfoutput>#color#</cfoutput>">
									&nbsp;&nbsp;|&nbsp;&nbsp;
								</td>
								
								</cfif>
								
								
								<td>
									<a href="PasswordAssist.cfm" target="_top" style="color:<cfoutput>#color#</cfoutput>">
										Forgot password
									</a>
								</td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
			</cfoutput>
		
		</cfif>	
		
		<cfif displayMode eq "2">
		
			<cfoutput>
			<table cellspacing="0" cellpadding="0" border="0" class="formpadding"  width="320">		
				<tr>		
					
					<cfif Parameter.ApplicationLogon neq "">
						<td>		
							<table width="100%">
								<tr>
									<td>
										<img style="vertical-align:middle" src="#Parameter.ApplicationLogon#" width=24px">
									</td>
									<td class="labelit"  style="color:<cfoutput>#color#</cfoutput>; font-size:14px;" align="right">
										<cfif Parameter.ApplicationLogonLabel neq "">
											#Parameter.ApplicationLogonLabel#
										<cfelse>
							  				<cf_tl id="User name">
							  			</cfif>
							  			:
							  		</td>
							  	</tr>
							</table>
						</td>
					<cfelse>
						<td class="labelit" style="color:<cfoutput>#color#</cfoutput>; font-size:14px" align="right">
							<cf_space spaces="34">
							<cfif Parameter.ApplicationLogonLabel neq "">
								#Parameter.ApplicationLogonLabel#
							<cfelse>
								<cf_tl id="User name">
							</cfif>
							:
						</td>	
					</cfif>
						

					<td style="padding-top:5px;" align="right">					
						<input name="account" 
							   id="account" 
							   class="regularxl enterastab" 
							   style="width:200px; height:30px; font-size:18px; padding:0px; padding-left:6px; padding-right:10px; border:1px solid ##C0C0C0;" 
							   type="text" 
							   value="<cfoutput>#logon#</cfoutput>" 
							   maxlength="30" 
							   onchange="document.getElementById('password').value='';" 
							   onblur="document.getElementById('password').value='';">
					</td>		
				</tr>
				<tr><td height="3" colspan="2"></td></tr>
				<tr>
					<td class="labelit" style="color:<cfoutput>#color#</cfoutput>; font-size:14px" align="right">
						<cf_tl id="Password">:
					</td>			  
					<td style="padding-top:5px;" align="right">
					
						<input type="password" 
						  name="password" 
						  id="password" 
						  maxlength="50" 
						  class="regularxl passwordxl" 
						  autocomplete="off" 
						  onKeyUp="go(event)"
						  style="width:200px; height:30px; font-size:18px; padding-left:6px; padding-right:10px; border:1px solid ##C0C0C0;" 
						  onfocus="this.value=''; this.focus();">
						  
					</td>			             
				</tr>
				<tr><td height="3" colspan="2"></td></tr>
				<tr>
					<td style="padding-left:10px; padding-top:5px;" align="center" colspan="2">
					
						<input style="height: 36px; border:none; border-radius: 5px; padding: 5px; background: ##1a73e8; color: ##ffffff; text-transform: uppercase; font-weight: 600; font-size:14px; font-family: -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif,'Raleway', sans-serif !important" type="button" 
						  class="button10g" name="Submit" id="Submit" value="Login"   onclick="openmenu('acc','pwd')">
						
						<!--- google sign-in --->
						<cfinclude template="Logon/ThirdParty/Google/gSigninButton.cfm">
						  
					</td>		
				</tr>		
				<tr><td height="12" colspan="2"></td></tr>
				<cfif showLine eq 1>
				<tr>
					<td colspan="2" style="margin-top:10px;" class="linedotted"></td>
				</tr>
				</cfif>
				<tr><td height="3" colspan="2"></td></tr>
				<tr>
					<td colspan="2" align="#linksAlign#">		
						<table cellspacing="0" cellpadding="0" align="center">
							<tr>
								<cfif Parameter.SystemSupportPortalId neq "">
									
									<cfif showSupport eq 1>
											
										<td>
													
												<cfquery name="Link" 
													datasource="AppsSystem">
													SELECT    *
													FROM      PortalLinks
													WHERE     PortalId = '#Parameter.SystemSupportPortalId#'
												</cfquery>		
												<cfoutput>		 
													<a href="support.cfm?id=#Parameter.SystemSupportPortalId#" style="color:<cfoutput>#color#</cfoutput>" target="_new">
														#Link.Description#
													</a>
												</cfoutput>		
											
										</td>
										<td style="color:<cfoutput>#color#</cfoutput>">
											&nbsp;&nbsp;|&nbsp;&nbsp;
										</td>
									</cfif>
									
									<cfif showRequest eq 1>
										
										<td style="cursor:pointer" onclick="requestacc()">		
											<cfoutput>		 
												<a style="color:<cfoutput>#color#</cfoutput>">
													<cf_tl id="Request Access">
												</a>
											</cfoutput>		
										</td>
										
										<td style="color:<cfoutput>#color#</cfoutput>">
											&nbsp;&nbsp;|&nbsp;&nbsp;
										</td>
										
									</cfif>
									
								</cfif>

								<cfif showForgot eq 1>
								<td>
									<a href="PasswordAssist.cfm" target="_top" style="color:<cfoutput>#color#</cfoutput>">
										<cf_tl id="Forgot Password">
									</a>
								</td>
								</cfif>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
			</cfoutput>
		
		
		</cfif>
	
	</cfif>		  
