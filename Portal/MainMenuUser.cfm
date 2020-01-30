<cfif backOfficeStyle eq "HTML5">
	
	<div id="header">

				<cfset vLogoPath = "#session.root#/#parameter.AppLogoPath#/#parameter.AppLogoFileName#">
				<cf_tl id="Home" var="1">
                
                
   				<cfoutput><div><a><img class="logo" onclick="gohome();" title="#lt_text#" src="#vLogoPath#" width="auto" height="60" /></a></div></cfoutput>

				
				<div id="user-main">
				
                    <div class="user-top">
					
						<div id="sign-out"><a href="javascript:exit()"><cf_tl id="Sign out"></a></div> 

						<cfloop index="itm" list="Reference">
							
							<cf_tl id="#itm#" var="1">
	
							<cfquery name="Links" 
								datasource="AppsSystem" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT * 
									FROM   PortalLinks 
									WHERE  Class = '#itm#'
									AND    (HostNameList is NULL or HostNameList = '' OR HostNameList LIKE '%#CGI.HTTP_HOST#%')
									ORDER BY ListingOrder
							</cfquery>
							
							<cfoutput>
							<cfif links.recordcount gte "1"> 
								<div id="refoptions">									
									<ul>
								        <li>
								            #lt_text#
								            <ul class="sub-levelout">
												<cfloop query="Links">
													<cfif locationString eq "">
														<li class="lisub-levelout">
															<a href="#LocationURL#" target="#LocationTarget#">
																#Description#
															</a>
														</li>
													<cfelse>
														<li class="lisub-levelout">
															<a onclick="milload()" href="#LocationURL#?#LocationString#" target="#LocationTarget#">
																#Description#
															</a>
														</li>
													</cfif>
												</cfloop>
								            </ul>
								        </li>
								    </ul>
								</div>
							</cfif>
							</cfoutput>
						
						</cfloop>
						
                        <!--- Language --->
                        <div id="opts">
								
								<cfquery name="Language" 
									datasource="AppsSystem"
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT *
									FROM   Ref_SystemLanguage	 
									WHERE  Operational IN ('1','2')	 
									AND    Interface = 1
								</cfquery> 
								
								<!--- check if the user preference default is a valid selection --->
								
								<cfquery name="check" 
										datasource="AppsSystem"
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT *
										FROM   Ref_SystemLanguage	 									
										WHERE  Operational IN ('1','2')	 									
										AND    Interface = 1
										AND    Code = '#CLIENT.LanguageId#'
									</cfquery> 		
								
								<cfif check.recordcount eq "0">
								
										<cfquery name="check" 
										datasource="AppsSystem"
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT *
										FROM   Ref_SystemLanguage	 									
										WHERE  SystemDefault = '1'	 																			
									</cfquery> 		
									
									<cfset CLIENT.LanguageId = check.code>														
								
								</cfif>
								
								<cfif Language.recordcount gt "1">
													
								<div>
									<div class="menuheader" ></div>
									<select class="regularxl lang-menu" style="height:24px" id="language" onChange="languageswitch(this.value)">
										<cfoutput query="Language">
										<option value="#Code#" <cfif Code eq CLIENT.LanguageId>selected</cfif>>#LanguageName#</option>
										</cfoutput>
									</select>
                                    <i class="icon-down-dir"></i>
								</div>
								
								</cfif>
							
							</div>
                           <!--- Language ---> 
                            
						<div id="user-settings"><cfoutput><a onclick="milload()" href="javascript:ptoken.location('#SESSION.root#/Portal/Preferences/UserEdit.cfm?ID=#SESSION.acc#','portalright');"><i class="icon-cog-line"></i></cfoutput></a></div>
						<div id="toggleusermenu"><a href="javascript:usermenu()"><cfoutput>#lcase(SESSION.first)# #lcase(SESSION.last)#</cfoutput></a></div>
						<div id="usermenu" class="usermenuhide" onmouseout="$(this).children('ul').stop().fadeOut('fast');"></div>
                        <div id="home-link">
                        	<a onclick="gohome();"><i class="icon-home"></i>
</a>
                        </div>
                    </div>	

				</div>			
			</div>
	
<cfelseif backOfficeStyle eq "Standard">
	
	<div id="header">
				
				<div id="user">
	
					<div id="sign-out">
						<a href="javascript:exit()"><cf_tl id="Sign out"></a>
					</div>
					
					<div id="userhome">
						<a href="javascript:gohome()"><cf_tl id="Home"></a>							
					</div>
							
					<cfif Parameter.SystemSupportPortalId neq "">		
							
						<div id="supportme">
							<a href="javascript:supporttickets()"><cf_tl id="Support"></a>							
						</div>
					
					</cfif>

					<div id="userprofile">	
						
						<div id="toggleusermenu" onclick="usermenu()"><img src="<cfoutput>#SESSION.root#</cfoutput>/images/arrowdown1.gif" style="display:block" width="11px" height="7px"></div>
						
						<div id="username">
							<cfoutput>#lcase(SESSION.first)# #lcase(SESSION.last)#</cfoutput>
						</div>
						
						<div id="usermenu" class="usermenuhide" onmouseout="$(this).children('ul').stop().fadeOut('slow');"></div>

						<cfloop index="itm" list="Reference">
						
						<cf_tl id="#itm#" var="1">

						<cfquery name="Links" 
							datasource="AppsSystem" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT *
								FROM   PortalLinks 
								WHERE  Class = '#itm#'
								AND    (HostNameList is NULL or HostNameList = '' OR HostNameList LIKE '%#CGI.HTTP_HOST#%')
								ORDER BY ListingOrder
						</cfquery>
						
						<cfoutput>
						<cfif links.recordcount gte "1"> 
							<div id="refoptions">									
								<ul>
							        <li style="border:1px solid transparent; height:18px; font-size:15px; font-family:Calibri,Helvetica">
							            #lt_text#
							            <ul class="sub-levelout">
											<cfloop query="Links">
												<cfif locationString eq "">
													<li class="lisub-levelout">
														<a href="#LocationURL#" target="#LocationTarget#">
															<img src="#SESSION.root#/Images/bullet.png">
															#Description#
														</a>
													</li>
												<cfelse>
													<li class="lisub-levelout">
														<a onclick="milload()" href="#LocationURL#?#LocationString#" target="#LocationTarget#">
															<img src="#SESSION.root#/Images/bullet.png">
															#Description#
														</a>
													</li>
												</cfif>
											</cfloop>
							            </ul>
							        </li>
							    </ul>
							</div>
						</cfif>
						</cfoutput>
						
						<!--- TEMP for Nova deploy
						<div style="cursor:pointer; font-size:15px; color:white; float:right; line-height:12px; width:auto; padding-top:1px; padding-right:35px; font-family:calibri, trebuchet MS; text-transform: capitalize;" onclick="$('#helpwizarddialog').fadeIn(600); ColdFusion.navigate('widgets/HelpWizard/HelpWizard.cfm','helpwizarddialog')">
							What's new?
						</div>
						 TEMP for Nova deploy--->
						
					</div>	
					</cfloop>

				</div>			
				
				<div id="userPic">
					<div id="Pic">
						<cf_userProfilePicture height="45px" width="55px">
					</div>
				</div>
			</div>
			
</cfif>