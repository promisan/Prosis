<body>
	<div id="_ShowNavigationBarOnInit" style="display:none;"><cfoutput>#url.showNavigationOnFirstPage#</cfoutput></div>
	<div id="_SplashScreen" style="display:none;"><cfoutput>#parameterSplash#</cfoutput></div>
	<div id="_RootSite" style="display:none;"><cfoutput>#session.root#</cfoutput></div>
	<div id="_PortalId" style="display:none;"><cfoutput>#url.id#</cfoutput></div>
	<div id="_PortalGUID" style="display:none;"><cfoutput>#Main.SystemFunctionId#</cfoutput></div>
	<div id="_PortalMission" style="display:none;"><cfoutput>#vThisMission#</cfoutput></div>
	
	
	<cfdiv id="_processAjax" style="display:none;"></cfdiv>

	<!--- WAIT SCREEN --->
	<div class="clsMainMenuOverlay clsWhite" id="MainMenuWait">
		<div class="clsMainMenuOverlayContainer">
			<div class="clsLoginWait clsTopColor">
				<cfoutput>
					<table height="100%" width="100%">
						<tr>
							<td valign="middle" align="center">
								<cfif vThisMission neq "">
									<div class="clsLoginWaitLogo">
										<img src="#parameterImgLogo#" title="#parameterImgLogoTitle#" alt="#parameterImgLogoName#">
									</div>
									<div class="clsLoginWaitBusy">
										<img src="#imageDirectory#/busy.gif"> 
									</div>
									<div class="clsLoginWaitText">
										<cf_tl id="Loading">...
									</div>
								<cfelse>
									<table>
										<tr>
											<td>
												<div class="clsSelectMissionText">
													<cf_tl id="Entity">:
												</div>
											</td>
											<td style="padding-left:10px;">
												<cfset vRoot = URLEncodedFormat("#session.root#")>
												<select name="fwmission" id="fwmission" class="clsSelectMission" onchange="_changeMission('#vRoot#', this.value, '#url.id#', true);">
													<option value="">--
													<cfloop query="MissionList">
														<option value="#mission#" <cfif vThisMission eq mission>selected</cfif>>#mission#
													</cfloop>
												</select>
											</td>
										</tr>
									</table>
								</cfif>
							</td>
						</tr>
					</table>
				</cfoutput>
			</div>
		</div>
	</div>
	
	<cfif client.logoncredential neq "">
    	<cfset logon = client.logoncredential> 
	<cfelse>
		<cfset logon = "">
	</cfif>
	
	<cfif vPortalMode eq "login">
		<!--- LOGIN CONTAINER --->
			<cfoutput>
			<div class="clsLoginOverlay" id="MainMenuLogin">
				
				<div class="clsLoginOverlayContainer">
					<div class="clsLoginSide clsBottomColor">
						<div class="clsLoginSideLogo">
							<cfif qBrandLogo.recordCount eq 1>
								<img src="#parameterImgBrandLogo#" title="#parameterImgBrandLogoTitle#" alt="#parameterImgBrandLogoName#">
							</cfif>
						</div>
					</div>
					<div class="clsLoginCenter">
						<div class="clsMainMenuOverlayClose clsUnselectableImages">
							<img src="#imageDirectory#/xDark.png" id="btnMainMenuLoginHide">
						</div>
						<div class="clsLoginLogo">
							<img src="#parameterImgLogoDark#" title="#parameterImgLogoDarkTitle#" alt="#parameterImgLogoDarkName#">
						</div>
						
						<div class="clsLoginBox">
							<div class="clsLoginWelcome">
								#Portal.FunctionInfo#
							</div>
							<cfset vWaitImgURL = URLEncodedFormat("#imageDirectory#/busyW8.gif")>
																																	
							<cfform 
								name="frmLogin" 
								method="post" 
								onsubmit="_loginWait('#vWaitImgURL#');" 
								action="#session.root#/Portal/SelfService/LogonAjaxSubmit.cfm?returnValue=1&printResult=1&id=#url.id#&mission=#URL.mission#" 
								target="loginResult" 
								autocomplete="off">
									<p  <cfif SystemParameter.ApplicationLogon neq ""> style="margin-left:-85px" </cfif> >
									
										<cfif SystemParameter.ApplicationLogon neq "">
											<span style="font-size: 20px; width: 200px; display: inline-block; text-align: right;  margin-right:12px;">
											<img style="vertical-align:middle" src="#SESSION.root#/#SystemParameter.ApplicationLogon#" width="36px">
											<cfif SystemParameter.ApplicationLogonLabel neq "">
												<cf_tl id="#SystemParameter.ApplicationLogonLabel#" var="1">
											<cfelse>
												<cf_tl id="User name" var="1"> 
											</cfif>
											#lt_text# :
											</span>
										</cfif>

										<input 
											type="text" 
											class="clsTxtLogin" 
											name="Account" 
											id="Account" 
											value="#logon#" 
											placeholder="#lcase(lt_text)#" 
											onchange="document.getElementById('password').value='';" 
											onblur="document.getElementById('password').value='';" 
											onkeypress="validateKeyPress(event);"
											required>
									</p>
									<p  <cfif SystemParameter.ApplicationLogon neq ""> style="margin-left:-85px" </cfif>  >
										<cf_tl id="Password" var="1">
										<cfif SystemParameter.ApplicationLogonLabel neq "">
											<span style="font-size: 20px; width: 200px; display: inline-block; text-align: right; margin-right:12px;">
											#lt_text# :
											</span>
										</cfif>
										<input 
											type="password" 
											class="clsTxtLogin" 
											name="password" 
											id="password" 
											value="" 
											placeholder="#lcase(lt_text)#" 
											autocomplete="off" 
											onfocus="this.value=''; this.focus();" 
											onkeypress="validateKeyPress(event);" 
											required>
									</p>
									<p class="submit">
										<cf_tl id="Login" var="1">
										<input 
											type="submit" 
											class="clsBtnLogin" 
											name="submit" 
											id="submit" 
											value="#lt_text#"
											onclick="validateSpecialKeyPress(event);">
									</p>
							</cfform>
							<cfif qRequestAccess.recordCount gt 0 or qForgotPassword.recordCount gt 0 or qForgotUser.recordCount gt 0>
								<cfset vRoot = URLEncodedFormat("#session.root#")>
								<div class="clsLoginFeatures">
									<cfif qRequestAccess.recordCount eq 1>
										<a href="javascript:accountRequest('#vRoot#','#url.id#');"><cf_tl id="Request Access"></a>
									</cfif>
									<cfif qRequestAccess.recordCount eq 1 and qForgotPassword.recordCount eq 1>
									&nbsp;&nbsp;|&nbsp;&nbsp;
									</cfif>
									<cfif qForgotPassword.recordCount eq 1>
										<a href="javascript:forgotPassword('#vRoot#','#url.id#');"><cf_tl id="Forgot My Password"></a>
									</cfif>
									<cfif qForgotUser.recordCount eq 1 and (qRequestAccess.recordCount eq 1 or qForgotPassword.recordCount eq 1)>
									&nbsp;&nbsp;|&nbsp;&nbsp;
									</cfif>
									<cfif qForgotUser.recordCount eq 1>
										<a href="javascript:forgotUser('#vRoot#','#url.id#');"><cf_tl id="Forgot My User"></a>
									</cfif>
								</div>
							</cfif>
							<br>
							<div class="clsLoginResult">
								<span class="clsLoginLocalResult"></span>
								<iframe 
									name="loginResult" 
									id="loginResult" 
									frameborder="0" 
									style="display:none;" 
									onload="_login('#url.id#')"></iframe>
							</div>
						</div>
					</div>
				</div>
			</div>
		</cfoutput>
	</cfif>
	
	<!--- OPTIONS MENU CONTAINER --->
	<div class="clsMainMenuOverlay" id="MainMenuOptions">
		<div class="clsMainMenuOverlayContainer">
			<div class="clsMainMenuOverlayClose">
				<cfoutput><img src="#imageDirectory#/x.png" id="btnMainMenuOptionsHide"></cfoutput>
			</div>
			
			<div class="clsMainMenuOverlayItemContainer clsMainMenuOverlayItemContainerFull">
				<cfset vShowChangePassword = 0>
				<cfif qPreferencesPassword.recordCount eq 0>
					<cfset vShowChangePassword = 1>
				<cfelse>
					<cfif qPreferencesPassword.operational eq 1>
						<cfset vShowChangePassword = 1>
					</cfif>
				</cfif>
				
				<cfset vShowFeatures = 0>
				<cfif qPreferencesFeatures.recordCount eq 0>
					<cfset vShowFeatures = 1>
				<cfelse>
					<cfif qPreferencesFeatures.operational eq 1>
						<cfset vShowFeatures = 1>
					</cfif>
				</cfif>
				
				<cfset vShowAnnotations = 0>
				<cfif qPreferencesAnnotations.recordCount eq 0>
					<cfset vShowAnnotations = 1>
				<cfelse>
					<cfif qPreferencesAnnotations.operational eq 1>
						<cfset vShowAnnotations = 1>
					</cfif>
				</cfif>
				
				<cfset vShowLDAPMailbox = 0>
				<cfif qPreferencesLDAPMailbox.recordCount eq 0>
					<cfset vShowLDAPMailbox = 1>
				<cfelse>
					<cfif qPreferencesLDAPMailbox.operational eq 1>
						<cfset vShowLDAPMailbox = 1>
					</cfif>
				</cfif>
				
				<cfset vOptionsURL = URLEncodedFormat("#session.root#/Portal/Preferences/UserEditHTML5.cfm?webapp=#url.id#&showChangePassword=#vShowChangePassword#&iconSet=Gray&showFeatures=#vShowFeatures#&showAnnotations=#vShowAnnotations#&showLDAPMailbox=#vShowLDAPMailbox#")>
				<div class="clsMainMenuURL" id="PortalViewSrc_Options" style="display:none;"><cfoutput>#vOptionsURL#</cfoutput></div>
				<!--- Options Item --->
				<div class="clsMainMenuOverlayOptions">
				
					<cfset vClassSuffix = "">
					<cfset vAlignLanText = "right">
					<cfset vFloatLan = "float:right;">
					<cfif vPortalMode eq "login">
						<cfset vClassSuffix = "Big">
						<cfset vAlignLanText = "left">
						<cfset vFloatLan = "">
					</cfif>
				
					<cfoutput>
					<div class="clsMainMenuOverlayOptionsLanguage" style="#vFloatLan#">
						<cfset vRoot = URLEncodedFormat("#session.root#")>
						<cfset vShowMissionCondition = (Main.FunctionCondition neq vThisMission or Main.MenuClass eq "Mission")>
						<table>
							<tr>
								<td align="#vAlignLanText#">
									<cfif vShowMissionCondition>
										<span class="clsOptionsLanguageText#vClassSuffix#"><cf_tl id="Entity"></span>
									</cfif>
								</td>
								<td align="left" style="padding-left:5px; padding-right:20px;">
									<cfif vShowMissionCondition>
										<span class="clsOptionsLanguageText#vClassSuffix#">:&nbsp;&nbsp;</span>
										<select name="fmission" id="fmission" class="clsOptionsLanguageSelect#vClassSuffix#" onchange="_changeMission('#vRoot#', this.value, '#url.id#', true);">
											<option value="">--
											<cfloop query="MissionList">
												<option value="#mission#" <cfif vThisMission eq mission>selected</cfif>>#mission#
											</cfloop>
										</select>
									</cfif>
								</td>
							<cfif vPortalMode eq "login">
							</tr>
							<tr>
							</cfif>
							<cfif Language.recordcount gt "1">
								<td align="#vAlignLanText#">
									<span class="clsOptionsLanguageText#vClassSuffix#"><cf_tl id="Language"></span>
								</td>
								<td align="left" style="padding-left:5px;">
									<span class="clsOptionsLanguageText#vClassSuffix#">:&nbsp;&nbsp;</span>
									<select 
										id="LanSwitch"
										class="clsOptionsLanguageSelect#vClassSuffix#"
										onchange="_changeLanguage('#vRoot#', '#url.id#', this.value);">
										<cfloop query="Language">
											<option value="#Language.code#" <cfif client.languageid eq code>SELECTED</cfif>>
												#LanguageName#&nbsp;&nbsp;
											</option>
										</cfloop>
									</select>
								</td>
							</cfif>
							</tr>
						</table>
					</div>
					</cfoutput>
					
					<cfif vPortalMode eq "default">
						<div class="clsDataContainerFrameBusy" id="busy_Options">
							<cfoutput><img src="#imageDirectory#/busyW8.gif"></cfoutput>
						</div>
						<cfoutput>
							<iframe marginheight="0" 
								marginwidth="0" 
								frameborder="0" 
								allowTransparency="true"
								id="PortalView_Options" 
								class="clsIframeContent"
								scrolling="no"
								style="height:85%; width:96%; background-color:white; display:block; margin-top:10px; margin-left:15px;" 
								src="">
							</iframe>
						</cfoutput>
					</cfif>
					
				</div>
			
			</div>
		</div>
	</div>

	<!--- CLEARANCES MENU CONTAINER --->
	<div class="clsMainMenuOverlay" id="MainMenuClearances">
		<div class="clsMainMenuOverlayContainer">
			<div class="clsMainMenuOverlayClose">
				<cfoutput><img src="#imageDirectory#/x.png" id="btnMainMenuClearancesHide"></cfoutput>
			</div>
			
			<div class="clsMainMenuOverlayItemContainer clsMainMenuOverlayItemContainerFull" style="height:95%;">
				<cfset vClearancesURL = URLEncodedFormat("#session.root#/System/EntityAction/EntityView/MyClearances.cfm?scope=portal&ts=#getTickCount()#")>
				<div class="clsMainMenuURL" id="PortalViewSrc_Clearances" style="display:none;"><cfoutput>#vClearancesURL#</cfoutput></div>
				<!--- Clearances Item --->
				<div class="clsMainMenuOverlayClearances">
					
					<cfif vPortalMode eq "default">
						<div class="clsDataContainerFrameBusy" id="busy_Clearances">
							<cfoutput><img src="#imageDirectory#/busyW8.gif"></cfoutput>
						</div>
						<cfoutput>
							<iframe marginheight="0" 
								marginwidth="0" 
								frameborder="0" 
								allowTransparency="true"
								id="PortalView_Clearances" 
								class="clsIframeContent"
								scrolling="no"
								style="height:125%; width:98%; background-color:white; display:block; margin-top:10px; margin-left:15px;" 
								src="">
							</iframe>
						</cfoutput>
					</cfif>
					
				</div>
			
			</div>
		</div>
	</div>
	
	<!--- SITE HEADER --->
    <div class="clsHeader clsTopColor" id="pageHeader">
		<cfoutput>
            
		<div class="clsHeaderLeftContainer clsUnselectableImages" style="width: 300px;">
            <img id="mainMenuMenu" style="width:23px;height: 23px;float:left;padding:10px 4px 10px 8px;outline: 1px solid transparent;" src="<cfoutput>#imageDirectory#/MenuIcon.png</cfoutput>">
			<div class="clsHeaderLeftContainerWrapper">
				<div class="clsHeaderLogoImage">
					<img src="#parameterImgLogo#" title="#parameterImgLogoTitle#" alt="#parameterImgLogoName#" class="clsMenuButtonHome clsMenuButton">
				</div>
			</div>
		</div>
		
		<div class="clsHeaderInformation">
			<div class="clsHeaderInformationText">	
				<div class="clsHeaderInformationTextLeft">
				
					<table>
						<tr>
							<cfif vPortalMode eq "default">
								<td style="padding:4px;">
									<cf_userProfilePicture>
								</td>
							</cfif>
							<td style="padding-left:10px;">
								<cfset vInformationEntity = 0>
								<cfif qInformationEntity.recordCount eq 0>
									<cfset vInformationEntity = 1>
								<cfelse>
									<cfif qInformationEntity.operational eq 1>
										<cfset vInformationEntity = 1>
									</cfif>
								</cfif>
								<cfif vInformationEntity eq 1>
									<div>
										<cf_tl id="Entity">: 
										<b>#ucase(vThisMission)#</b>
									</div>
								</cfif>
								
								<cfif isDefined("session.acc")>
									<cfif session.acc neq "">
										<div style="<cfif vInformationEntity eq 1>padding-top:8px;</cfif>">
											<cf_tl id="Active User">: 
											<b>[#lcase(session.acc)#] #ucase(session.first)# #ucase(session.last)#</b>
										</div>
									</cfif>
								</cfif>
								
								<div style="padding-top:8px;">
									<cf_tl id="Your date and time">: <div class="clsYourDateTime" style="font-weight:bold;"></div>
								</div>
							</td>
						</tr>
					</table>

				</div>
				<div class="clsHeaderInformationTextRight" id="divCustomInformation"></div>
			</div>
		</div>
		
		<div class="clsHeaderOptionsContainer clsUnselectableImages">
		
			<cfset vShowConfigurations = 0>
			<cfif qShowConfigurations.recordCount eq 1>
				<cfif qShowConfigurations.Operational eq 1>
					<cfset vShowConfigurations = 1>
				</cfif>
			<cfelse>
				<cfset vShowConfigurations = 1>
			</cfif>
			
            <cfif MainMenu.recordCount gt 1>
				<div class="clsMainMenuContainer" id="mainMenuHome" onclick="parent.parent.carousel.showPane(0);">
					<img src="#imageDirectory#/HomeMenu.png" class="clsAnimate">
					<div class="clsMainMenuContainerText">
						<cf_tl id="Home">
					</div>
				</div>
			</cfif>    
			
			<cfif vPortalMode eq "default" and SystemParameter.SystemSupportPortalId neq "" and qShowSupportMenu.recordCount eq 1>
				<div class="clsMainMenuContainer" id="mainMenuSupport">
					<img src="#imageDirectory#/support.png" class="clsAnimate">
					<div class="clsMainMenuContainerText">
						<cf_tl id="Support">
					</div>
				</div>
			</cfif>
			
			<cfif qLanguageTopMenu.recordCount eq 1>
				<div class="clsLanguageMenuContainer" id="mainMenuLanguage">
					<cfif client.languageId eq "ENG">
						<img src="#imageDirectory#/flags/wENG.png" class="clsLanguageMenuIcon clsAnimate">
					<cfelseif client.languageId eq "ESP">
						<img src="#imageDirectory#/flags/wESP.png" class="clsLanguageMenuIcon clsAnimate">
					<cfelseif client.languageId eq "FRA">
						<img src="#imageDirectory#/flags/wFRA.png" class="clsLanguageMenuIcon clsAnimate">
					<cfelseif client.languageId eq "NED">
						<img src="#imageDirectory#/flags/wNED.png" class="clsLanguageMenuIcon clsAnimate">
					<cfelse>
						<img src="#imageDirectory#/world.png" class="clsLanguageMenuIcon clsAnimate">
					</cfif>
					<div class="clsMainMenuContainerText">
						<cf_tl id="Language">
					</div>
					<div class="clsMainMenuLanguageMenu">
						<div class="clsMainMenuLanguageMenuContainer">
						
							<cfset vShowLanguageFlag = 0>
							<cfif qShowLanguageFlag.recordCount eq 1>
								<cfif qShowLanguageFlag.Operational eq 1>
									<cfset vShowLanguageFlag = 1>
								</cfif>
							<cfelse>
								<cfset vShowLanguageFlag = 1>
							</cfif>
							
							<cfset vLangNameStyle = "padding-bottom:8px; font-size:10px;">
							<cfif vShowLanguageFlag eq 0>
								<cfset vLangNameStyle = "padding-bottom:12px; font-size:15px;">
							</cfif>
							
							<table width="100%" style="padding:3px;">
								<cfloop query="Language">
									<tr>
										<cfif vShowLanguageFlag eq 1>
											<td onclick="_changeLanguage('#vRoot#', '#url.id#', '#code#');" title="#LanguageName# - #code#" align="center" style="padding-right:2px;">
												<cfif code eq "ENG">
													<img src="#imageDirectory#/flags/fENG.png" class="clsFlagIcon">
												<cfelseif code eq "ESP">
													<img src="#imageDirectory#/flags/fESP.png" class="clsFlagIcon">
												<cfelseif code eq "FRA">
													<img src="#imageDirectory#/flags/fFRA.png" class="clsFlagIcon">
												<cfelseif code eq "NED">
													<img src="#imageDirectory#/flags/fNED.png" class="clsFlagIcon">
												</cfif>
											</td>
										</cfif>
										<td align="left" class="clsLanguageText" style="padding-bottom: 5px;font-size: 10px;" onclick="_changeLanguage('#vRoot#', '#url.id#', '#code#');" title="#LanguageName# - #code#">
											#LanguageName#
										</td>
									</tr>
								</cfloop>
							</table>
							
						</div>
					</div>
				</div>
			</cfif>
			
			<cfset vShowPublicInformation = 0>
			<cfif qShowPublicInformation.recordCount eq 1>
				<cfif qShowPublicInformation.Operational eq 1>
					<cfset vShowPublicInformation = 1>
				</cfif>
			<cfelse>
				<cfset vShowPublicInformation = 1>
			</cfif>
			
			<cfset vShowPrivateInformation = 0>
			<cfif qShowPrivateInformation.recordCount eq 1>
				<cfif qShowPrivateInformation.Operational eq 1>
					<cfset vShowPrivateInformation = 1>
				</cfif>
			<cfelse>
				<cfset vShowPrivateInformation = 1>
			</cfif>
			
			<cfif (vShowPublicInformation eq 1 and vPortalMode eq "login") or (vShowPrivateInformation eq 1 and vPortalMode eq "default")>
				<div class="clsMainMenuContainer" id="mainMenuInformation">
					<img src="#imageDirectory#/information.png" class="clsAnimate">
					<div class="clsMainMenuContainerText">
						<cf_tl id="Information">
					</div>
				</div>
			</cfif>
			
			<cfset vShowPreferences = 0>
			<cfif qPreferences.recordCount eq 0>
				<cfset vShowPreferences = 1>
			<cfelseif qPreferences.recordCount eq 1>
				<cfif qPreferences.Operational eq 1>
					<cfset vShowPreferences = 1>
				</cfif>
			</cfif>
			
			<cfif vShowPreferences eq 1>
				<cfif (qShowPublicPreferences.recordCount eq 1 and vPortalMode eq "login") or vPortalMode eq "default">
					<div class="clsMainMenuContainer" id="mainMenuPreferences">
						<img src="#imageDirectory#/preferences.png" class="clsAnimate">
						<div class="clsMainMenuContainerText">
							<cf_tl id="Preferences">
						</div>
					</div>
				</cfif>
			</cfif>

			<cfset vShowClearances = 0>
			<cfif qClearances.recordCount eq 0>
				<cfset vShowClearances = 0>
			<cfelseif qClearances.recordCount eq 1>
				<cfif qClearances.Operational eq 1>
					<cfset vShowClearances = 1>
				</cfif>
			</cfif>
			
			<cfif vShowClearances eq 1 and vPortalMode eq "default">
				<div class="clsMainMenuContainer" id="mainMenuClearances">
					<img src="#imageDirectory#/clearances.png" class="clsAnimate">
					<div class="clsMainMenuContainerText">
						<cf_tl id="Clearances">
					</div>
				</div>
			</cfif>
                
            <cfif vPortalMode eq "default" and qGetSupport.recordCount gt 0 and vShowConfigurations eq 1>
				<div class="clsMainMenuContainer" id="mainMenuConfiguration">
					<img src="#imageDirectory#/configuration.png" class="clsAnimate">
					<div class="clsMainMenuContainerText">
						<cf_tl id="Configuration">
					</div>
				</div>
			</cfif>
			
			<cfif vPortalMode eq "default">
				<div class="clsMainMenuContainer" 
					onclick="_logout('#url.id#');">
					<img src="#imageDirectory#/logout.png" class="clsAnimate">
					<div class="clsMainMenuContainerText">
						<cf_tl id="Logout">
					</div>
				</div>
			</cfif>
			
			<cfif vPortalMode eq "login" and ProcessPrivate.Total gt 0>
				<div class="clsMainMenuContainer" id="mainMenuLogin">
					<img src="#imageDirectory#/login.png" class="clsAnimate">
					<div class="clsMainMenuContainerText">
						<cf_tl id="Login">
					</div>
				</div>
			</cfif>
			
		</div>
		</cfoutput>
	</div>
	
	<!--- NAVIGATION BAR --->
	<div class="clsNavigationBar clsUnselectableImages clsBottomColor">
		<cfoutput>
			<div class="clsNavigationBarPrev" onclick="carousel.prev();">
				<cf_tl id="previous" var="1">
				<img 
					src="#imageDirectory#/left.png" 
					title="#lt_text#">
				<div class="clsNavigationBarTitlePrev"></div>
			</div>
			<div class="clsNavigationBarTitleContainer">
				<div class="clsNavigationBarTitleWrapper">
					<div class="clsNavigationBarRefresh">
						<cf_tl id="refresh" var="1">
						<img 
							src="#imageDirectory#/refresh.png" 
							title="#lt_text#">
					</div>
					<div class="clsNavigationBarTitle"></div>
				</div>
			</div>
			<div class="clsNavigationBarNext" onclick="carousel.next();">
				<cf_tl id="next" var="1">
				<img 
					src="#imageDirectory#/right.png" 
					title="#lt_text#">
				<div class="clsNavigationBarTitleNext"></div>
			</div>
		</cfoutput>
	</div>
	
	<!--- MAIN MENU CONTAINER --->
	<div class="clsMainMenuOverlay" id="MainMenu">
		<div class="clsMainMenuOverlayContainer">
			<div class="clsMainMenuOverlayClose clsUnselectableImages">
				<cfoutput>
					<img style="background: ##efefef;padding: 0;margin: 8px 0;border-radius: 5px 0 0 5px;" src="#imageDirectory#/close.png" id="btnMainMenuHide">
				</cfoutput>
			</div>
			<div class="clsMainMenuOverlayItemContainer">
				
				<cfset vCnt = 0>
				<cfset vCountGroups = 0>
				<cfset vCountItemsPerGroup = 0>
				<cfoutput query="MainMenu" group="FunctionBackground">

					<cfset vCountGroups = vCountGroups + 1>
					<cfset vCountItemsPerGroup = 0>
					<cfif trim(FunctionBackground) neq "">
						<div class="clsMainMenuOverlayGroupItemName" id="MainMenuOverlayGroupItemName_#vCountGroups#"><cf_tl id="#FunctionBackground#"></div>
					</cfif>
				
					<cfoutput>
					
						<cfinvoke component="Service.Access"  
							method="function"  
							SystemFunctionId="#SystemFunctionId#" 
							Mission="#vThisMission#"
							returnvariable="access">
						
						<cfif vPortalMode eq "login">
							<cfset access = "GRANTED">
						</cfif>
						
						<cfif access is "GRANTED">
							<cfset vCurrentRow = vCnt>
							<cfset vCnt = vCnt + 1>
							<cfset vCountItemsPerGroup = vCountItemsPerGroup + 1>
							
							<!--- Menu Item Content #FunctionMemo# --->
							<div class="clsMainMenuOverlayItem clsMenuButton clsUnselectableImages" id="btnPane#vCurrentRow#" style="padding: 3px 0;">
								<div id="menuItem_#SystemFunctionId#" style="display:none;">#vCurrentRow#</div>
								<table cellpadding="0" cellspacing="0">
									<tr>
										<td class="clsMainMenuOverlayItemSelectedBar"></td>
										<td valign="top" class="clsMainMenuOverlayOptionContainer" style="padding-top: 4px;">
											<img style="background: ##efefef;padding: 0;margin:0 8px 0 3px;border-radius: 5px;" src="#imageDirectory#/defaultOption.png">
										</td>
										<td style="padding-left:5px;">
											<table cellpadding="0" cellspacing="0">
												<tr>
													<td>
														<div class="clsMainMenuOverlayItemName">
															#replaceNoCase(functionMemo, "<br>"," ","ALL")#
														</div>
													</td>
												</tr>
												<tr>
													<td>
														<div class="clsMainMenuOverlayItemMemo">
															#replaceNoCase(functionInfo, "<br>"," ","ALL")#
														</div>
													</td>
												</tr>
												
												<cfset vShowMenuInfo = 0>
												<cfif qShowMenuInfo.recordCount eq 1>
													<cfif qShowMenuInfo.Operational eq 1>
														<cfset vShowMenuInfo = 1>
													</cfif>
												<cfelse>
													<cfset vShowMenuInfo = 1>
												</cfif>
												
												<cfif vShowMenuInfo eq 1>
													<tr>
														<td>
															<div class="clsMainMenuOverlayItemCreated">
																<cf_tl id="Published">: #OfficerUserId# @ #dateFormat(Created, client.dateFormatShow)#
																<br>
																<cf_tl id="Modified">: #dateFormat(LastModified, client.dateFormatShow)#
															</div>
														</td>
													</tr>
												</cfif>
												
											</table>
										</td>
									</tr>
								</table>
							</div>
							<!--- -------- --->
						</cfif>					
					</cfoutput>
					
					<cfif vCountItemsPerGroup eq 0>
						<script>
							$('##MainMenuOverlayGroupItemName_#vCountGroups#').remove();
						</script>
					</cfif>
					
				</cfoutput>
				
			</div>
		</div>
	</div>

	<!--- MAIN CONTAINER --->
    <div class="clsCarousel" id="mainCarousel">
        <ul>
		
			<cfset vCnt = 0>
			<cfoutput query="MainMenu">
			
				<cfinvoke component="Service.Access"  
					method="function"  
					SystemFunctionId="#SystemFunctionId#"
					Mission = "#vThisMission#"
					returnvariable="access">
					
				<cfif vPortalMode eq "login">
					<cfset access = "GRANTED">
				</cfif>
				
				<cfif access is "GRANTED">
			
					<cfset vCurrentRow = vCnt>
					<cfset vCnt = vCnt + 1>
					
					<cfif vPortalMode eq "login">
						<cfset vMenuURL = URLEncodedFormat("#SESSION.root#/Portal/SelfService/HTML5/PortalLanding.cfm?webapp=#url.id#&id=#url.id#&#functioncondition#&mission=#vThisMission#&systemFunctionId=#systemFunctionId#&menuClass=#url.menuClass#&mid=#url.mid#")>
					<cfelseif vPortalMode eq "default">
						<cfset vMenuURL = URLEncodedFormat("#SESSION.root#/#Portal.FunctionDirectory#/#Portal.FunctionPath#?webapp=#url.id#&id=#url.id#&#functioncondition#&mission=#vThisMission#&systemFunctionId=#systemFunctionId#&menuClass=#url.menuclass#")>
					</cfif>
					
					<cfset vId = replace(systemFunctionId, "-", "", "ALL")>
					
					<!--- Menu Item Content --->
		            <li>
						<div class="clsDataContainer" id="pane_#vCurrentRow#">
							<div id="mainMenuGUID_#vId#" style="display:none;">#systemFunctionId#</div>
							<div class="clsMainMenuId" style="display:none;">#vId#</div>
							<div class="clsMainMenuTitle" style="display:none;">
								<cfif trim(functionMemo) neq "">
									#replaceNoCase(functionMemo, "<br>"," ","ALL")#
								<cfelseif trim(functionInfo) neq "">
									#replaceNoCase(functionInfo, "<br>"," ","ALL")#
								<cfelse>
									#replaceNoCase(functionName, "<br>"," ","ALL")#
								</cfif>
							</div>
							<div class="clsMainMenuShowReload" style="display:none;">#url.showReload#</div>
							<div class="clsMainMenuEnforceReload" style="display:none;">#EnforceReload#</div>
							<div class="clsMainMenuURL" id="PortalViewSrc_#vId#" style="display:none;">#vMenuURL#</div>
							
							<div class="clsDataContainerFrame">
								<div class="clsDataContainerFrameBusy" id="busy_#vId#">
									<img src="#imageDirectory#/busyW8.gif"> 
								</div>									
								
								<iframe marginheight="0" 
									marginwidth="0" 
									frameborder="0"
									allowTransparency="true" 
									scrolling="no"
									id="PortalView_#vId#" 
									class="clsIframeMainContent"
									src="">
									
								</iframe>
							</div>
						</div>
					</li>
					<!--- ---- --->
				
				</cfif>
			</cfoutput>
			
        </ul>
    </div>

	<!--- BEHAVIOR --->
	<cfoutput>
					
		<script type="text/javascript" charset="utf-8" src="#session.root#/Portal/SelfService/HTML5/Scripts/carousel.js?ts=#getTickCount()#"></script>
		<script type="text/javascript" charset="utf-8" src="#session.root#/Portal/SelfService/HTML5/Scripts/init.js?ts=#getTickCount()#"></script>
		
	</cfoutput>
	
	<script>
		
		//Set menu buttons behavior
		<cfset vCnt = 0>
		<cfoutput query="MainMenu">
		
			<cfinvoke component="Service.Access"  
				method="function"  
				SystemFunctionId="#SystemFunctionId#" 
				Mission = "#vThisMission#"
				returnvariable="access">
				
			<cfif vPortalMode eq "login">
				<cfset access = "GRANTED">
			</cfif>
			
			<cfif access is "GRANTED">
			
				<cfset vCurrentRow = vCnt>
				<cfset vCnt = vCnt + 1>
			
				$('##btnPane#vCurrentRow#').on('click',function(){ 
					carousel.showPane(#vCurrentRow#); 
					/*Autohide menus*/
					<cfif qAutohideMenu.recordCount eq 1>
						setTimeout(function() { 
							toggleMenuOverlay(false, '##MainMenu', '0px', function(){}); 
						}, 1250); 
					</cfif>
				});
			
			</cfif>
			
		</cfoutput>
			
		//Show menu options with alt combinations
		
		$('html').on('keyup', function(e) {
			if (e.altKey) {
			
				<cfset vCnt = 0>
				<cfoutput query="MainMenu">
				
					<cfinvoke component="Service.Access"  
						method="function"  
						SystemFunctionId="#SystemFunctionId#" 
						Mission = "#vThisMission#"
						returnvariable="access">
						
					<cfif vPortalMode eq "login">
						<cfset access = "GRANTED">
					</cfif>
					
					<cfif access is "GRANTED">
				
						<cfset vCurrentRow = vCnt>
						<cfset vCnt = vCnt + 1>
					
						<cfif vCurrentRow lte 9>
							if(e.keyCode === #48+vCurrentRow#) {
							 carousel.showPane(#vCurrentRow#);
							}
						</cfif>
					
					</cfif>
					
				</cfoutput>
			}
		});
		
		//Default tab
		carousel.showPane(0);
		
		//Hide menus
		toggleMenuOverlay(false, '#MainMenu, #MainMenuOptions, #MainMenuClearances, #MainMenuLogin', '0px', function(){ 
			//Show main menu
			<cfif vPortalMode eq "default">
				<cfset vInitShowMenu = 0>
				<cfif qInitShowMenu.recordCount eq 0>
					<cfset vInitShowMenu = 1>
				<cfelseif qInitShowMenu.recordCount eq 1>
					<cfif qInitShowMenu.Operational eq 1>
						<cfset vInitShowMenu = 1>
					</cfif>
				</cfif>
				<cfif vInitShowMenu eq 1>
					toggleMenuOverlay(true, '#MainMenu', '-40%', function(){}); 
				</cfif>
			</cfif>
		});
		
		<!--- <cfif isDefined("client.mission") and trim(client.mission) neq ""> --->
		<cfif vThisMission neq "">
		//Hide loading message
		$(document).ready(function() {
			setTimeout(function(){
				toggleMenuOverlay(false, '#MainMenuWait', '0px', function(){});
			}, 750);
		});
		</cfif>
		
		//Set user date and time
		setInterval(function(){ 
			$('.clsYourDateTime').html(getTextDate('<cfoutput>#application.dateFormat#</cfoutput>', ' - '));
		}, 1000);
		
		//set password blank
		setTimeout(function(){ $('password').value = ''; }, 100);
		
		//Log
		<cfoutput>
			_logActivity('#session.root#', '#Main.SystemFunctionId#', '#vThisMission#');
		</cfoutput>
		
		//Show Login On Init
		<cfif vPortalMode eq 'login' and (qShowLoginOnInit.recordCount eq 1 or url.showLogin eq 1)>
			showLogin();
		</cfif>
		
	</script>
	
	<!--- check the browser version --->
	<cf_validateBrowser minIE="12" setDocumentMode="1">

	<cfif clientbrowser.pass eq 0>
		<cfoutput>
			<script>
				parent.window.location = "#session.root#/Portal/SelfService/HTML5/NotSupported.cfm?id=#url.id#&mission=#vThisMission#";
			</script>
		</cfoutput>
	<cfelse>
		<cfset client.browser = clientBrowser.name>
	</cfif>
	
	<cfoutput>
		<script>
			//Set custom Information
			ptoken.navigate('#session.root#/Portal/SelfService/HTML5/getCustomInformation.cfm?id=#url.id#&mission=#vThisMission#','divCustomInformation');
		</script>
	</cfoutput>

</body>