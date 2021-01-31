

<cfajaximport tags="cfdiv">

<cfset CLIENT.init = "No">	
		
<cfinvoke component = "Service.Process.System.Client" method= "getBrowser" returnvariable = "thisbrowser">	

	<cfif thisbrowser.name neq "Explorer">
				
		<!DOCTYPE html>
		<cfset client.compatmode = "no">
						
	<cfelseif thisbrowser.name eq "Explorer" and (thisbrowser.release eq "10" or thisbrowser.release eq "11")>	
		
		<!DOCTYPE html>
		<cfset client.compatmode = "no">
		
	<cfelse>
		
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
		<cfset client.compatmode = "yes">
	
	</cfif>		
	
	<cfset client.browser = thisbrowser.name>		
	
<html><head>

		<cfif not isDefined("stylePath")>
			<cfif thisbrowser.name eq "Explorer" and thisbrowser.release LT "10">
				<cfset stylePath = "BackOffice/Standard">
				<cfset backOfficeStyle = "Standard">
			<cfelse>
				<cfset stylePath = "BackOffice/HTML5">
				<cfset backOfficeStyle = "HTML5">
			</cfif>
		</cfif>
			
	    <cfif thisbrowser.name eq "Explorer" and (thisbrowser.release eq "10" or thisbrowser.release eq "11")>
			<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10">
		<cfelse>
			<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">			
		</cfif>
			
		<title><cfoutput>#SESSION.welcome#  |  |||  |  |   | </cfoutput></title>
			
		<cfquery name="Get" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   UserNames 
			WHERE  Account = '#SESSION.acc#'
		</cfquery>		

		<cfif Get.Recordcount neq 0>
			
			<cfquery name="CreateWidgets" 
			    datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">										
				INSERT INTO UserModule (Account, SystemFunctionId, Status)
				
				SELECT   '#SESSION.acc#', 
				         M.SystemFunctionId,
						 '1'
				FROM     Ref_ModuleControl M
				WHERE    MenuClass = 'widget' 
				AND      Operational = '1'
				AND   	 M.SystemFunctionId NOT IN (
										   SELECT U.SystemFunctionId
										   FROM   UserModule U
										   WHERE  U.Account = '#SESSION.acc#'
											)										
			</cfquery>				
			
		</cfif>				
			
		<cfquery name="Widgets" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				SELECT    M.FunctionName, M.SystemFunctionId, M.FunctionDirectory, M.FunctionPath
				FROM      Ref_ModuleControl M INNER JOIN UserModule U ON  M.SystemFunctionId = U.SystemFunctionId
				AND       U.Account = '#SESSION.acc#'
				WHERE     M.SystemModule = 'Portal'
				AND       M.Operational IN ('1') AND FunctionName != 'FileShelf' <!--- security breach --->
				AND       M.MenuClass = 'Widget' 
				AND       U.Status    = '1'
				ORDER BY  M.MenuOrder

		</cfquery>

		<cfset versioncss = RandRange(1, 100, "SHA1PRNG")>
		
		<cfoutput>
				
			<link id="mainsystemcss" rel="stylesheet" href="#stylePath#/css/sys_style.css?v=<cfoutput>#versioncss#</cfoutput>" type="text/css"/>
			<link id="mainmenucss"   rel="stylesheet" href="#stylePath#/css/menustyle.css?v=<cfoutput>#versioncss#</cfoutput>" type="text/css"/>
					
			<cfif get.pref_color neq "">
				<link id="csstheme" rel="stylesheet" href="#stylePath#/css/#Get.Pref_Color#.css" type="text/css"/>
			<cfelse>
				<link id="csstheme" rel="stylesheet" href="#stylePath#/css/Orange.css" type="text/css"/>
			</cfif>		
			
			<cfloop query="Widgets">
				<cfif Widgets.FunctionName eq "Calculator">
					<link id="cssCalculator" rel="stylesheet" href="Widgets/Calculator/calcstyle.css" type="text/css"/>
				</cfif>
			</cfloop>
		
		</cfoutput>		
					
		<cfquery name="Parameter" 
			datasource="AppsInit">
			SELECT * 
			FROM   Parameter
			WHERE  HostName = '#CGI.HTTP_HOST#'
		</cfquery>
		
		<cfif FileExists ("#SESSION.rootPath#/custom/logon/#Parameter.ApplicationServer#/favicon.ico")>
			<cfoutput>
			<link rel="shortcut icon" type="image/x-icon" HREF="#SESSION.root#/custom/logon/#Parameter.ApplicationServer#/favicon.ico">
			</cfoutput>
		</cfif>

		<script src="../Scripts/jQuery/jquery.js" type="text/javascript"></script>
		<script src="../Scripts/jQuery/jquery.easing.1.3.js" type="text/javascript"></script>
		<script src="../Scripts/jQuery/jqueryeffects.js" type="text/javascript"></script>
		
		<!--- brought to local folder and loaded manually because cfajaximport gives issues in ie9, for compatibility mode meta tag --->
		<script src="../Scripts/cfmessage.js" type="text/javascript"></script>
		<script src="../Scripts/cfajax.js" type="text/javascript"></script>
		<cf_UIGadgets>

		<!--- ADDED BY HANNO TO PREVENT RIGHT-CLICK --->
		<cfif getAdministrator("*") eq "0">		
			<script>
				document.oncontextmenu=new Function("return false")
			</script>
		</cfif>
		
		<cfif thisbrowser.name eq "Explorer" and thisbrowser.release lte "10">				
			<!--- Hanno : TEMP measurement only.
			    we force the disabled mode as otherwise we have a ajax called superseding the IE9 - IE8 settings for the menu --->								
			<cf_SystemScript force="1">
		<cfelse>
			<cf_SystemScript>				
		</cfif>
		
		<cf_pictureProfileStyle>

		<cfinclude template="MainMenuViewScript.cfm">
		
		<cf_SessionValidateScript doctypemode="doctype">


	</head>			
		
	<body onLoad="<cfif SESSION.authent lte "4">sessionvalidatestart()</cfif>">		
	
				
		<!--- main container to be controlled for the look and feel --->
				
		<div id="mainwrapper">		
		
			<div id="sessionvalidcheck" style="width:0px; height:0px; line-height:0px; font:0px; position:absolute; top:0px left:0px"></div>	
			<div id="sessionvalid"      style="width:100%; height:100%; position:absolute; z-index:99999; display:none"></div>
					
			<!---Hidden dialog until fileShelf Upload is clicked --->
			<div id="fileuploaddialog"></div>					
			<div id="widmodalbg"></div>					
			
			<cfoutput>
			
				<cfif Get.recordcount neq 0>
				
					<cfquery name="CreateNotifications" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
														
						INSERT INTO UserModule (Account, SystemFunctionId, Status)
						SELECT     '#SESSION.acc#', M.SystemFunctionId,'1'
						FROM       Ref_ModuleControl M
						WHERE      (MenuClass = 'notifier') AND (Operational = '1')
						AND 		M.SystemFunctionId NOT IN (
										SELECT U.SystemFunctionId
										FROM   UserModule U
										WHERE  U.Account = '#SESSION.acc#'
							)										
					</cfquery>							
				</cfif>	
				
				<cfquery name="HelpWizard" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						
						SELECT    M.FunctionName, M.SystemFunctionId, U.Status
						FROM      Ref_ModuleControl M INNER JOIN UserModule U ON  M.SystemFunctionId = U.SystemFunctionId
						WHERE     M.SystemModule = 'Portal'
						AND       M.Operational IN  ('1')
						AND       M.MenuClass = 'notifier' 
						AND       M.FunctionName = 'HelpWizard'
						AND       U.Status = '1'
						AND       U.Account = '#SESSION.acc#'
	
				</cfquery>
			
			</cfoutput>				
			
			<cfif stylePath eq "BackOffice/Standard">

				<cfif FileExists("#SESSION.rootpath#\custom\logon\#Parameter.ApplicationServer#\header.cfm")>
					<cfset logo = "../custom/logon/#Parameter.ApplicationServer#/header.cfm">
				<cfelse>
					<cfset logo = "#stylePath#/Images/Header.png">		
				</cfif>


				<cfif find(".cfm",logo)>
					<iframe marginheight="0px" marginwidth="0px" 
						src="<cfoutput>#logo#</cfoutput>" style="height:505px; width:100%; position:absolute; top:0px; left:0px; display:block; background-color:transparent " 
						id="iheader" name="iheader" scrolling="no" frameborder="no" allowTransparency="true">
					</iframe>				
				<cfelse>
				    <!--- banner --->
				    <img src="<cfoutput>#logo#</cfoutput>" style="display:block; position:absolute; top:0px; left:0px">
				</cfif>
			
			</cfif>
						
			<cfif SESSION.authent  eq "1">		
			
			<cf_notificationviewdisplay>

			<!---Hidden help wizard for new users --->
			<div id="helpwizarddialog" <cfif HelpWizard.recordcount neq "1">style="display:none"</cfif>>
				<cfif HelpWizard.recordcount eq "1">
					<!--- <cfinclude template="widgets/HelpWizard/HelpWizard.cfm"> --->
				</cfif>						
			</div>	
			
			<!--- top menu banner --->				
			
			<cfquery name="Parameter" 
				datasource="AppsInit">
					SELECT * 
					FROM Parameter
					WHERE HostName = '#CGI.HTTP_HOST#' 
			</cfquery>		
						
			<cfinclude template="MainMenuUser.cfm">

			<!--- main menu column  --->		
								
			<div id="wrapper">	
								
				<div id="leftpanelmaximize"></div>
				<div class="menuheader main" id="ajaxsubmit"></div>
				<div id="leftpanel">								
					<div id="menu">
					
					    <!--- container for the menu --->
						   
						
						<cfif backOfficeStyle eq "HTML5">
						
						<cfelse>
							<cfoutput>
								<div class="menuheader"><cf_tl id="Main Menu"> <img src="#stylePath#/images/Maximize_maincontent.png" class="imgfullscreenmenu"></div>
							</cfoutput>
							
						</cfif>

						<cfinclude template="MainMenuContent.cfm">

					</div>											
                    
					<div id="quicklinks">
						<div class="menuheader"><cf_tl id="Quick Links"></div>
						<ul class="ql-ca-menu">
							
							<li class="qlmenutitle" onclick="toggleqlmenu(this); favorite()">
								<cf_tl id="My Favorite Applications">					
							</li>
							
							<!--- disabled for now --->										
							<li class="qlmenutitle" onclick="toggleqlmenu(this); favoritereport()">
								<cf_tl id="Launch Popular Reports">
							</li>			
							
							<cfquery name="Parameter" 
							datasource="AppsInit">
								SELECT * 
								FROM Parameter
								WHERE HostName = '#CGI.HTTP_HOST#'
							</cfquery> 
							
							<cfif Parameter.SystemSupportPortalId neq "">		
							
							<li class="qlmenutitle" onclick="toggleqlmenu(this); supporttickets('')">
								<cf_tl id="Support Ticket Center">					
							</li>
							
							</cfif>					

							<li class="qlmenutitle" onclick="toggleqlmenu(this); clearance()">
								<cf_tl id="Pending for Action"> <span id="myclearancescount"></span>		
							</li>
							
							<li class="qlmenutitle" onclick="toggleqlmenu(this); report()">
								<cf_tl id="Report Subscription">					
							</li>		
																					
							<cfif getAdministrator("*") eq "1">
									
							<li class="qlmenutitle" onclick="toggleqlmenu(this); notification()">
								<cf_tl id="System Notification">
							</li>									
							</cfif>
								
							<li class="qlmenutitle" onclick="toggleqlmenu(this); broadcast()">
								<cf_tl id="Broadcast Mail">					
							</li>
							
							<!--- covered in portal 
							
							<cf_verifyOperational module="Attendance">	  

							<cfif ModuleEnabled eq "1">
	
								<li class="qlmenutitle" onclick="toggleqlmenu(this); leaveRequest()">
									<cf_tl id="Leave Request">					
								</li>
							
							</cfif>
							
							--->
						</ul>
					</div>

					<cfif backOfficeStyle eq "Standard">
					
						<div id="opts">
							
							<cfquery name="Language" 
								datasource="AppsSystem"
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT *
								FROM   Ref_SystemLanguage	 
								<cfif Get.Pref_SystemLanguage neq "">	 
								WHERE  Code = '#Get.Pref_SystemLanguage#'	 
								<cfelse>
								WHERE  Operational IN ('1','2')	 
								</cfif>
							</cfquery> 
												
							<div style="margin-right:10px;">
								<div class="menuheader" ><cf_tl id="Language"></div>
								<select class="regularxl" id="language" onChange="languageswitch(this.value)" style="border-left:1px solid silver;border-right:1px solid silver;border-bottom:1px solid silver;;border-top:1px solid white;font-size:13px;padding:4px; width:107px; height:30px" >
									<cfoutput query="Language">
									<option value="#Code#" <cfif Code eq "#CLIENT.LanguageId#">selected</cfif>>#LanguageName#</option>
									</cfoutput>
								</select>
							</div>
						
						</div>
					
					</cfif>

				</div>

	
				<div id="dtopics" style="margin-top:0%">
				
					<cfif client.compatmode eq "yes" or thisbrowser.name eq "Explorer">
						<div style="position:absolute; top:0px; left:0px; z-index:2"></div>
						<div style="position:absolute; top:0px; left:10px; right:0px; z-index:2"></div>
						<div style="position:absolute; left:0px; top:10px; z-index:2"></div>	
					<cfelse>
						<!--- Chrome, FF and Safari supports this ONLY--->
						<div class="portalrightmask" id="itopicsviewmask" style="display:block"></div>
					</cfif>							
					
					<cf_getMID>

					<iframe
						name="itopics"
						id="itopics"
						src="<cfoutput>#SESSION.root#/Portal/Topics/PortalTopics.cfm?mid=#mid#</cfoutput>"
						width="100%"
						height="100%"
						scrolling="no"
						frameborder="0" style="background-color:white; display:block;">								
					</iframe>
					
				</div>


				<div id="contentviewmaximize">
					<cfoutput>
						<img src="#stylePath#/images/Maximize_maincontent.png">
					</cfoutput>
				</div>
				<div id="contentview">					
												
					<cfoutput>
					
						<cfif client.compatmode eq "yes" or client.browser eq "Explorer">
							<div style="position:absolute; top:0px; left:0px; z-index:2"><img src="#SESSION.root#/Images/Portal/top_left.png" alt="" width="10px" height="10px"></div>
							<div style="position:absolute; top:0px; left:10px; right:0px; z-index:2"><img src="#SESSION.root#/Images/Portal/top_v2.png" alt="" width="100%" height="6px"></div>
							<div style="position:absolute; left:0px; top:10px; z-index:2"><img src="#SESSION.root#/Images/Portal/left_big.png" alt="" height="535px" width="10px" ></div>	
						<cfelse>
							<!--- Chrome, FF and Safari supports this ONLY--->
							<div class="portalrightmask" id="contentviewmask"></div>
						</cfif>
						
						<div id="contentviewtoggle">
							<div class="cvt">
								<cfoutput>
									<img width="21" height="21" class="cvt" src="#stylePath#/images/hide_content.png">
								</cfoutput>
							</div>
						</div>		
						
						<!---THIS IS WHERE THE APPLICATION, INQUIRY, ETC OPTIONS WILL APPEAR --->
						
						<div id="contentoptions"></div>
						
						<iframe name="portalright"
								id="portalright"
								width="100%"
								height="97%"
								scrolling="no"
								frameborder="0" 
								style="background-color:white; display:block; padding-top:20px;">							
											
						</iframe>
						
					</cfoutput>	
						
				</div>			
			</div>		
			
			<cfelse>
											
				<cfif SESSION.authent eq "9">
				
					<!--- we check if the user has ldap enforced and thus if maybe he was recording his native account/password --->							
																		
					<div style="position:absolute; top:50%; left:50%; margin-left:-200px; margin-top:-75px; width:500px; height:150px; ">
					
					       <table>
						 
							<cfif Account.enforceLDAP eq "0">		
							
							  <tr><td bgcolor="#808080" class="labellarge" style="font-size: 23px; font-family:'Montserrat', Arial, Helvetica, sans-serif;">
							
							  <b><cf_tl id="You have entered an incorrect account/password"> 
														
							      </td>
								</tr>
							
								<tr><td class="labelmedium" style="padding-left:10px;padding-top:8px;font-size: 18px; font-family:'Montserrat', Arial, Helvetica, sans-serif;">
								
									<cf_tl id="Forgot your password">?
									<cf_tl id="Please use the forgot password link in the home page to reset your password">
									
									<cfif client.attempts gte "2">
									<cf_tl id="You have #client.attempts# attempts left">. 
									<cfelseif client.attempts eq "1">							
									<cf_tl id="You have #client.attempts# attempt left">. 
									<cfelse>
									<cf_tl id="You have no attempts left">.
									</cfif>
									
							<cfelse>
							
							<cfset grantedmode = "Prosis">
																						
							<cfinvoke component = "Service.Authorization.Password"  
							   method           = "Prosis" 
							   acc              = "#EnteredAccount#"
							   pwd              = "#form.password#" 	 
							   returnvariable   = "searchresult">		
							
								<cfif searchresult.recordcount eq "1">
																					
								 <tr><td bgcolor="#808080" class="labellarge" style="font-size: 23px; font-family:'Montserrat', Arial, Helvetica, sans-serif;">							
									  <b><cf_tl id="Attention"> 														
								      </td>								
								 </tr>	
								 
								 <tr><td class="labelmedium" style="padding-left:10px;padding-top:8px;font-size: 18px; font-family:'Montserrat', Arial, Helvetica, sans-serif;">															
									
									<br>						
									<b><cf_tl id="You are required to use your mail address and password to log in to #session.welcome#."></b>
									<br><br>
									
									<cfif client.attempts gte "2">
										<cf_tl id="You have #client.attempts# attempts left">. 
									<cfelseif client.attempts eq "1">							
										<cf_tl id="You have #client.attempts# attempt left">. 
									<cfelse>
										<cf_tl id="You have no attempts left">.
									</cfif>	
									  
									<cfquery name="LDAP" 
										datasource="AppsSystem"
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT     TOP 1 *
										FROM       ParameterLDAP
										WHERE      Operational = 1
										ORDER BY   ListingOrder 
									</cfquery> 
																  									
									<cfif LDAP.FieldLogon eq "AccountNo">
									
										<cfset client.logoncredential = get.AccountNo>								  											
									<cfelseif LDAP.FieldLogon eq "eMailAddress">
									  
									    <cfset client.logoncredential = get.eMailAddress>				  				
									<cfelse>
									
									    <cfset client.logoncredential = get.MailServerAccount>	
									
									</cfif>  
								
								<cfelse>
								
								  <tr><td bgcolor="#808080" class="labellarge" style="font-size: 23px; font-family:'Montserrat', Arial, Helvetica, sans-serif;">							
								       <b><cf_tl id="You have entered an incorrect account/password"> 														
								      </td>								
								  </tr>
								
								  <tr><td class="labelmedium" style="padding-left:10px;padding-top:8px;font-size: 18px; font-family:'Montserrat', Arial, Helvetica, sans-serif;">							
								
									    <cf_tl id="Forgot your password">?
										<cf_tl id="Please use the forgot password link in the home page to reset your password">
										<br>
										<cfif client.attempts gte "2">
											<cf_tl id="You have #client.attempts# attempts left">. 
										<cfelseif client.attempts eq "1">							
											<cf_tl id="You have #client.attempts# attempt left">. 
										<cfelse>
											<cf_tl id="You have no attempts left">.
										</cfif>							
								
								</cfif>
														
							</cfif>													
							
							</td></tr>
							
							<tr><td style="padding-top:30px" align="center">
								<input type="button" style="border-radius:5px;border:1px solid silver!important; background-color:##f0f0f0; width:120px; height:38px" value="Back" onclick="window.location = '../Default.cfm'">							
							</td></tr>
							</table>
						
					</div>									

				<cfelseif SESSION.authent eq "8" or SESSION.authent eq "7">
				
					<div style="position:absolute; top:50%; left:50%; margin-left:-200px; margin-top:-75px; width:500px; height:150px; ">
					
					       <table>
						   <tr>
						   <td bgcolor="#808080" class="labellarge" style="font-size: 23px; font-family:'Montserrat', Arial, Helvetica, sans-serif;">
							
							  <b><cf_tl id="Access Denied"> 
														
							</td>
							</tr>
							
							<cfoutput> 
														
								<tr>
								<td align="center" class="labelmedium" style="padding-left:10px;padding-top:8px;font-size: 18px; font-family:'Montserrat', Arial, Helvetica, sans-serif;">
								<cfif SESSION.authent eq "8">								
								
									Your account [#SESSION.acc#] was <font color='FF0000'><b>disabled</b></font>. <br>Please contact: #Parameter.SystemContact# [#Parameter.SystemContactEMail#]
									
								<cfelse>
								
									<cf_tl id="Your account"> [#SESSION.acc#] <cf_tl id="is"> <font color='FF0000'><b><cf_tl id="temporarily blocked"></b></font>
									<br>
									<cf_tl id="Reason">: <b>#system.BruteForce#</b> <cf_tl id="failed attempts"></b></font>. 
									<br>
									<cf_tl id="Please contact">: #Parameter.SystemContact# [#Parameter.SystemContactEMail#]
									<br>
									
								</cfif>								
								</td>
								</tr>
							
							</cfoutput>
														
							<tr><td style="padding-top:30px" align="center">
								<input type="button" style="border-radius:5px;border:1px solid silver!important; background-color:##f0f0f0; width:120px; height:38px" value="Back" onclick="window.location = '../Default.cfm'">							
							</td></tr>
							
							
							</table>
						
					</div>				
									
				<cfelseif SESSION.authent eq "6">
				
				    <div style="position:absolute; top:50%; left:50%; margin-left:-200px; margin-top:-75px; width:500px; height:150px; ">
					
					       <table>
						   <tr>
						   <td bgcolor="#808080" class="labellarge" style="font-size: 23px; font-family:'Montserrat', Arial, Helvetica, sans-serif;">
							
							  <b><cf_tl id="Application server is not accepting your session"> 
														
							</td>
							</tr>
							
							<cfoutput> 
														
								<tr>
								<td align="center" class="labelmedium" style="padding-left:10px;padding-top:8px;font-size: 18px; font-family:'Montserrat', Arial, Helvetica, sans-serif;">
								<cfif Parameter.OperationalMemo eq "">
									 <cf_tl id="Please contact">#Parameter.SystemContact# [#Parameter.SystemContactEMail#]
								<cfelse>
									 #Parameter.OperationalMemo# (#Parameter.SystemContact#)
								</cfif>								
								</td>
								</tr>
							
							</cfoutput>
							
							
							</table>
						
					</div>
								
					<!--- system is not accessible y administrator action and will not allow new sessions --->	
				
				</cfif>		
										
			</cfif>			
			
			<div id="footer"></div>
			
		</div>
		</div>
	</body>
	</html>