<!--
    Copyright © 2025 Promisan B.V.

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
<cfset client.veffects = "1">

<!--- nova framework embedding header --->
<cfparam name="client.Mission"      default="">
<cfparam name="URL.ID"              default="">
<cfparam name="url.header"          default="yes">

<cfset CLIENT.LayoutMode = "none">

<cfquery name="Main" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemModule   = 'SelfService'
	AND    FunctionClass  = 'SelfService'
	AND    FunctionName   = '#url.id#'
	AND    (MenuClass     = 'Mission' or MenuClass = 'Main')
	ORDER BY MenuOrder
</cfquery>

<cfif Main.SystemFunctionId eq "">

	 <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		 <tr><td align="center" height="40" class="labelmedium">
		   <font color="FF0000">
			   <cf_tl id="Portal does not exist or has not been configured"  class="Message">
		   </font>
			</td>
		 </tr>
	</table>	
    <cfabort>	
		
</cfif>

<!--- removed with code from HTML5 

<cfquery name="Language" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT  *
	 FROM    Ref_SystemLanguage
	 WHERE   Operational IN  ('1','2') 
	 AND     Code IN (SELECT LanguageCode
	                  FROM   Ref_ModuleControl_Language
        		      WHERE  Operational = 1  
			          AND    SystemFunctionId = '#Main.SystemFunctionId#')
	 ORDER BY SystemDefault DESC				  
						  
</cfquery>

<!--- 
Provision to prevent Client.Languageid from other session;, when it does not exist in current context 
--->

<cfset cntx = "0">
<cfloop query="Language">	
	<cfif Language.code eq client.Languageid>
		<cfset cntx = cntx+1>
	</cfif> 
</cfloop>

<cfif cntx eq "0">

       <cfset client.Languageid = Language.Code>
		 
	   <cfif Language.SystemDefault eq "1">
		   <cfset CLIENT.LanPrefix     = "">
	   <cfelse>   
		   <cfset CLIENT.LanPrefix     = "xl#Language.Code#_">
	   </cfif>	
	   		
</cfif>		


--->


<!--- ---------------------------------------------- --->
<!--- -------------- SET LANGUAGE ------------------ --->
<!--- ---------------------------------------------- --->

<!--- we obtain the default language within the scope of what is enabled --->

<cfquery name="BaseLanguage" 
	 datasource="AppsSystem">
		 SELECT  *
		 FROM    Ref_SystemLanguage
		 WHERE   Operational IN  ('1','2') 		 
		 AND 	SystemDefault = '1'
</cfquery>

<cfset BaseLanguage = BaseLanguage.code>

<cfquery name="ApplyLanguage" 
	 datasource="AppsSystem">
		 SELECT  *
		 FROM    Ref_SystemLanguage
		 WHERE   Operational IN  ('1','2') 
		 AND     Code IN (SELECT LanguageCode
		                  FROM   Ref_ModuleControl_Language
	        		      WHERE  Operational = 1  
				          AND    SystemFunctionId = '#Main.SystemFunctionId#')
		 AND 	SystemDefault = '1'
</cfquery>

<!--- if we do not find the base language within the enabled language scope for the functionid we apply
the first 9random) value of the enabled scope languages for the portal instead as the default --->

<cfif ApplyLanguage.recordcount eq "0">
	
	<cfquery name="ApplyLanguage" 
		 datasource="AppsSystem">
			 SELECT  TOP 1 *
			 FROM    Ref_SystemLanguage
			 WHERE   Operational IN  ('1','2') 	
			 AND     Code IN (SELECT LanguageCode
		                      FROM   Ref_ModuleControl_Language
	        		          WHERE  Operational = 1  
				              AND    SystemFunctionId = '#Main.SystemFunctionId#')				 
	</cfquery>
	
</cfif>

<!--- this one has the base language that contains the text in the normal tables --->

<cfset ApplyLanguage = ApplyLanguage.Code>


<!--- ------ now we obtain the language variables that are used for the query --- --->

<cfquery name="Language" 
	 datasource="AppsSystem">
		 SELECT  *
		 FROM    Ref_SystemLanguage
		 WHERE   Operational IN  ('1','2') 
		 AND     Code IN (SELECT LanguageCode
		                  FROM   Ref_ModuleControl_Language
	        		      WHERE  Operational = 1  
				          AND    SystemFunctionId = '#Main.SystemFunctionId#') 
		 ORDER BY SystemDefault DESC				  		  
</cfquery>


<!--- we initiatialise the query language prefix --->
<cfset CLIENT.LanPrefix = "">
<cfset found = 0>
<cfloop query="Language">	
	<cfif Code eq CLIENT.Languageid> <!--- user selected language matches one of the languages of the portal --->	    
		<cfif Code neq BaseLanguage> 
			  <cfset CLIENT.LanPrefix     = "xl#Code#_"> <!--- drives the query from the database, if base then it take standard --->
		</cfif>
		<cfset found = 1>
	</cfif> 
</cfloop>

<cfif found eq "0">  

	<!--- no prior user preference is found and/or was not matched with acceptable values for this function/portal; 
		     so we set it based on the first found scoped language in value applyLanguge --->
			 
	<cfset CLIENT.Languageid = ApplyLanguage>
	<cfif ApplyLanguage eq BaseLanguage>
		<cfset CLIENT.LanPrefix = "">	
	<cfelse>
		<cfset CLIENT.LanPrefix     = "xl#ApplyLanguage#_">
	</cfif>	
	
</cfif>

<!--- ------------------------------------ --->
<!--- ------------------------------------ --->
<!--- ------------------------------------ --->

	
<cfquery name="LayoutFavIcon"
	datasource="AppsSystem"
	username="#SESSION.login#"
	Password="#SESSION.dbpw#">
	SELECT	*
	FROM	Ref_ModuleControl
	WHERE	SystemModule	= 'SelfService'	
	AND		MenuClass		= 'Layout'
	AND		FunctionName	= 'FavIcon'
	AND		Functionclass	= '#URL.ID#'
</cfquery>	

<cfif Main.Menuclass eq "Main">
	<cfset Client.Mission = ""> 
</cfif>			
								
													
<cfif main.accessdatasource neq "">

	<cfquery name="MissionData" 
		 datasource="#Main.AccessDataSource#"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT   *
		 FROM     Ref_ParameterMission R		 
		 <cfif url.id eq "EFMS">
		 WHERE R.Mission IN (SELECT Mission FROM Organization.dbo.Ref_Mission WHERE MissionStatus = '0')
		 <cfelse>
		 WHERE R.Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE Mission = R.Mission) 
		 </cfif>		
	</cfquery>	
	
	<cfquery name="MData" 
		 datasource="#Main.AccessDataSource#"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT   *
		 FROM     Ref_ParameterMission R
		 <cfif client.mission neq "">
		 WHERE    Mission = '#client.mission#'
		 <cfelse>		 
			 <cfif url.id eq "EFMS">
			 WHERE R.Mission IN (SELECT Mission FROM Organization.dbo.Ref_Mission WHERE MissionStatus = '0')
			 <cfelse>
			 WHERE R.Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE Mission = R.Mission) 
			 </cfif>
		 </cfif>
	</cfquery>
	
</cfif>

<cfoutput>

	<cfset vlist = "Logo,Item,Header,Footer,Banner,Background,Widgets">

	<cfloop list="#vlist#" index="i">	
	
			<cfquery name="Layout#i#"
				datasource="AppsSystem"
				username="#SESSION.login#"
				Password="#SESSION.dbpw#">
				SELECT	FunctionDirectory, 
                		FunctionCondition,
				        FunctionPath, 
						Operational, 
						ScreenHeight, 
						ScreenWidth
				FROM	Ref_ModuleControl
				WHERE	SystemModule	= 'SelfService'	
				AND		MenuClass		= 'Layout'
				AND		FunctionName	= '#i#'
				AND		Functionclass	= '#URL.ID#'
			</cfquery>	
				
	</cfloop>
	
</cfoutput>

<cfquery name="Login" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT   *
	  FROM     Ref_ModuleControl
	  WHERE    SystemModule   = 'SelfService'
	  AND      FunctionClass  = '#url.id#'
	  AND      FunctionName   = 'Login' 
	  AND      MenuClass      = 'Function'
	  ORDER BY MenuOrder
</cfquery>

<!--- check status of logon --->

<cfoutput>	
	<cfparam name="SESSION.acc"    default="">

	<cfquery name="Logon" 
	datasource="AppsSystem">
		SELECT *
		FROM   UserStatus
		WHERE  Account   = '#SESSION.acc#'  
		AND    HostName  = '#CGI.HTTP_HOST#' 
		AND    NodeIP    = '#CGI.Remote_Addr#' 
	</cfquery>
	
	<cfif Logon.recordcount eq "0">	
	
		<cfset SESSION.authent = "0">
  
	<cfelse>	
		<cfset diff = DateDiff("n", "#Logon.ActionTimeStamp#", "#now()#")>		
		<cfif diff gte 40>		
			 <cfset SESSION.authent = "0">		   

		</cfif>	
	</cfif>	
</cfoutput>

<cfquery name="GetP" 
datasource="AppsSystem">
	SELECT * 
	FROM   Parameter 
</cfquery>

<cf_validateBrowser minIE="#getP.MinIE#">
<cfset CLIENT.browser = clientbrowser.name>

<cfif client.browser eq "Explorer">	

	<cfif Main.BrowserSupport eq "2">
		<cfset Main.BrowserSupport = "1">
	</cfif>		
	<cfset browser = "1">
	
<cfelseif client.browser eq "Firefox" or client.browser eq "Chrome" or client.browser eq "Safari">
	<cfset browser = "2">		
<cfelse>
	<cfset browser = "0">		
</cfif>

<cfset path = "#SESSION.root#/Portal/SelfService/Extended">
	
<!DOCTYPE html>

<cfset client.compatmode = "no">

<html>
	
	<head>
	
		<!--- bug in internet explorer 9 native mode --->
	
		<cfif Find("MSIE 9",cgi.http_user_agent)>
			<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">							
		</cfif>

		<title><cfoutput>#client.mission# #Main.FunctionMemo#</cfoutput></title>
		<link rel="stylesheet" href="extended/css/systemstyle.css" type="text/css"/>
		
		<cfoutput>

			<link rel="StyleSheet" href="#SESSION.root#/Portal/Selfservice/extended/style.css" type="text/css">
			
			<cfif FileExists ("#SESSION.rootpath##LayoutFavIcon.FunctionDirectory##LayoutFavIcon.FunctionPath#") and LayoutFavIcon.Operational eq "1">
				<link href="#SESSION.root#/#LayoutFavIcon.FunctionDirectory##LayoutFavIcon.FunctionPath#" rel="shortcut icon" type="image/x-icon"/>
			</cfif>
			
			<script src="#SESSION.root#/Scripts/jQuery/jquery.js" type="text/javascript"></script>
			<script src="#SESSION.root#/Scripts/jQuery/jquery.easing.1.3.js" type="text/javascript"></script>
			<script src="#SESSION.root#/Scripts/jQuery/jqueryeffects.js" type="text/javascript"></script>
				
			<!--- brought to local folder and loaded manually because cfajaximport gives issues in ie9, for compatibility mode meta tag ---->
			<script src="#SESSION.root#/Scripts/cfmessage.js" type="text/javascript"></script>
			<script src="#SESSION.root#/Scripts/cfajax.js" type="text/javascript"></script>		

			<script type="text/javascript" src="#SESSION.root#/Scripts/Drag/draggable.js"></script>
			<!--- contains a mix of NEEDED scripts at this level, from various Portals --->				
			<script type="text/javascript" src="#SESSION.root#/Portal/selfservice/Extended/script.js"></script>		
	
		</cfoutput>
		
		<cfinclude template="DefaultScript.cfm">				
		<cf_pictureScript>	
		<cf_PresenterScript>	
		
		<!--- we trigger the script for session controller --->			
		<cf_SessionValidateScript doctypemode="doctype">	
		
	</head>
	
	<cfset path = "#SESSION.root#/Portal/SelfService/Extended">	
	
	<body>
		
		<cf_notificationviewdisplay>
		
		<cfoutput>
		
		<div id="dcontent">
		
			<div id="panelleft"></div>
			
			<cfparam name="LayoutLogo.ScreenHeight" default="100">
			<cfparam name="LayoutLogo.ScreenWidth"  default="100">
			
			<cfif FileExists ("#SESSION.rootPATH##LayoutBackground.FunctionDirectory##LayoutBackground.FunctionPath#") and LayoutBackground.Operational eq "1">
				<cfset bg ="background-image:url('../../#LayoutBackground.FunctionDirectory##LayoutBackground.FunctionPath#'); background-position:top center; background-repeat:no-repeat">
			<cfelse>
				<cfset bg ="background-image:url('#path#/Images/bgv3.jpg'); background-position:top center; background-repeat:no-repeat">
			</cfif>
			
			<div id="panelcenter" style="#bg#">
							
				<div id="header">

						<div id="logo" onclick="toggle('logo');" style="height:#LayoutLogo.ScreenHeight#; margin-left:-#round(LayoutLogo.ScreenWidth/2)#px">
						<cfif FileExists ("#SESSION.rootPATH##LayoutLogo.FunctionDirectory##LayoutLogo.FunctionPath#") and LayoutLogo.Operational eq "1">
							<cfif find(".png",LayoutLogo.FunctionPath) gt "1" or
								  find(".jpg",LayoutLogo.FunctionPath) gt "1" or
								  find(".gif",LayoutLogo.FunctionPath) gt "1">
									<img src="../../#LayoutLogo.FunctionDirectory##LayoutLogo.FunctionPath#" alt="Click to collapse" width="#LayoutLogo.ScreenWidth#" height="#LayoutLogo.ScreenHeight#" border="0">
							<cfelseif 
								  find(".swf",LayoutLogo.FunctionPath) gt "1">
									<object width="#LayoutLogo.ScreenWidth#" height="#LayoutLogo.ScreenHeight#" style="display:block" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000">
									<param name="movie" value="../../#LayoutLogo.FunctionDirectory##LayoutLogo.FunctionPath#">
									<param name="wmode" value="transparent">
										<embed src="../../#LayoutLogo.FunctionDirectory##LayoutLogo.FunctionPath#" width="#LayoutLogo.ScreenWidth#" height="#LayoutLogo.ScreenHeight#" wmode="transparent" style="display:block" pluginspage="http://www.adobe.com/go/getflash" type="application/x-shockwave-flash">
										</embed>
									</object>
							<cfelse>
									<font color="red">Logo Object is a non allowed type.</font>
							</cfif>
						<cfelseif LayoutLogo.Operational eq "1">
							<img src="extended/Images/logo.png" alt="" width="255" height="135px" border="0">
						</cfif>
						</div>		
						
						<div id="togglelogo" title="Expand Header" onclick="toggle('togglelogo')">
							<img src="extended/Images/togglelogo.png" alt="Click to expand" width="30px" border="0">
						</div>	
						
						<div id="itemx">
							<cfif FileExists ("#SESSION.rootPATH##LayoutItem.FunctionDirectory##LayoutItem.FunctionPath#") and LayoutItem.Operational eq "1">
								<cfif find(".png",LayoutItem.FunctionPath) gt "1" or
									  find(".jpg",LayoutItem.FunctionPath) gt "1" or
									  find(".gif",LayoutItem.FunctionPath) gt "1">
									  	
										<img src="../../#LayoutItem.FunctionDirectory##LayoutItem.FunctionPath#" 
											 alt="" 
											 width="129px"
											 <cfif LayoutItem.FunctionCondition neq "">
											 	style="cursor:pointer"
											 	onclick="window.open('../../#LayoutItem.FunctionCondition#')"
											 </cfif>
											 height="53px" 
											 border="0">
								<cfelse>
										<font color="red">Item Object is a non allowed type.</font>
								</cfif>
							</cfif>
						</div>
						
						<table width="100%" height="45px" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td style="background-image:url('#path#/Images/header.png'); background-position:top center; background-repeat:repeat-x">
									<table cellpadding="0" cellspacing="0" border="0" width="100%" >
										<tr>
											<td width="350px" align="right" valign="top" onclick="toggle('logo');" style="padding-left:30px;" >
											<cfif FileExists ("#SESSION.rootPATH##LayoutHeader.FunctionDirectory##LayoutHeader.FunctionPath#") and LayoutHeader.Operational eq "1">
												<cfif find(".png",LayoutHeader.FunctionPath) gt "1" or
													  find(".jpg",LayoutHeader.FunctionPath) gt "1" or
													  find(".gif",LayoutHeader.FunctionPath) gt "1">
													  	<div style="width:350px; height:45px; overflow:hidden">										  
													  		<img src="../../#LayoutHeader.FunctionDirectory##LayoutHeader.FunctionPath#" border="0" align="left" style="display:block;">
														</div>
												
												<cfelseif 
													  find(".swf",LayoutHeader.FunctionPath) gt "1">
														<object width="466" height="45" style="display:block" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000">
														<param name="movie" value="../../#LayoutHeader.FunctionDirectory##LayoutHeader.FunctionPath#">
														<param name="wmode" value="transparent">
															<embed src="../../#LayoutHeader.FunctionDirectory##LayoutHeader.FunctionPath#" width="466" height="45" wmode="transparent" style="display:block" pluginspage="http://www.adobe.com/go/getflash" type="application/x-shockwave-flash">
															</embed>
														</object>
												<cfelse>
														<font color="red">Banner Object is a non allowed type.</font>
												</cfif>
											<cfelseif LayoutHeader.Operational eq "1">
												<img src="extended/Images/HeaderTitle.png" alt="" width="466px" height="45px" border="0"> 
											</cfif>
											</td>									
											
											<td align="right" valign="middle" style="padding-right:30px; padding-top:1px" >
												<table cellpadding="0" cellspacing="0" border="0"> 
													<tr>
														<td id="sessionvalidcheck"></td>
														<td id="sessionvalid"></td>
														<td id="balance"></td>
														<td id="mission" width="2px"></td>
														<td id="user" valign="middle" style="padding-top:3px">
														<cfif SESSION.authent  eq "1">
															<cfinclude template="LogonUser.cfm">
														</cfif>
														</td>
														<td id="misc" width="10px"></td>
														<td id="lanbox" width="5px"></td>   												
														<td width="5px" style="padding-top:3px">												
														<cfif client.mission neq "" and main.accessdatasource neq "">
															<input type="hidden" id="mmission" >
															<select id="miselect" onChange="mselectmission()" style="padding-top:0px;font-size:16px; height:23px; width:100px">
																	<option value="" style="background-color:##FF9999"></option>
																<cfloop query="MissionData">
																<cfoutput>										
																		<option value="#MissionData.mission#" <cfif #MissionData.mission# eq #client.mission#>selected="selected"</cfif>>#MissionData.mission#</option>
																</cfoutput>
																</cfloop>
															</select>
														<cfelseif main.accessdatasource eq "">
															
														</cfif>
														
														</td>
														<td width="5px"></td> 
														
														<cfif Language.recordcount gt "1">
														
															<td style="padding-top:3px">
															<select id="LanSwitch" onChange="languageswitch()" style="padding-top:0px;font-size:16px; height:23px;">							
																<cfloop query="Language">
																	<option value="#Language.code#" <cfif client.languageid eq code>SELECTED</cfif>>
																	&nbsp;#LanguageName#
																	</option>
																</cfloop>
															</select>
															</td>
															
														</cfif>
																																			
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						
				</div>	
				
				<div id="maincontentwrapper">					
								
						<cfif Main.BrowserSupport eq browser>
							<cfif client.mission neq "" or Main.Menuclass eq "Main">	
									
									<div id="MainContent">		
																						
																																												
										<cfquery name="AccessToPortal" 
											datasource="AppsSystem" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											SELECT *
											FROM   UserModule
											WHERE  Account           = '#SESSION.acc#'
											AND    SystemFunctionId  = '#Main.systemfunctionid#'			
										</cfquery>		
										
										<cfif AccessToPortal.Status eq "9">									
										
												<cfinclude template="../PortalNoAccess.cfm">									   										
											
										<cfelse>
										
											<cfinclude template="Main.cfm">	
										
										</cfif>			
									</div>						
								
							<cfelse>
							
									<div id="MainContent" align="center">	
										<cf_tableround mode="solid" totalwidth="90%" totalheight="100px">
										<cf_tableround mode="solid" totalheight="90px">
											<cfif main.accessdatasource neq "">
												<table cellpadding="" cellspacing="" width="100%" border="0" align="center">
													<tr>
														<td align="center" style="padding-top:5px">
														<table>
														<tr>
														<td valign="bottom" style="font-size:20px">
														<cf_tl id="Please select your Organization:" class="message">
														</td>
														<td style="padding-left:10px">
															<select id="mselect" name="mselect" style="width:150px;font-size:21px;height:28px" onChange="selectmission()">
																<option value=""> </option>
																<cfloop query="mdata">
																	<cfoutput>										
																		<option value="#mdata.mission#">#mdata.mission#</option>
																	</cfoutput>
																</cfloop>
															</select>
															</td></tr>
														</table>
														</td>
													</tr>
													<tr>
														<td align="center" style="padding-top:10px; font-size:16px; color:gray">													
															<cf_tl id="Note that your system credentials work only for your assigned mission." class="message">
														</td>
													</tr>
												</table>
											<cfelse>
												<table cellpadding="" cellspacing="" width="100%" border="0">
													<tr>
														<td align="center" style="padding-top:10px; color:red; font-size:16px">
															<cf_tl id="Portal DataSource has not been defined in the configuration." class="message"> <cf_tl id="Contact your IT Focal point." class="message">
														</td>
													</tr>
												</table>
											</cfif>
										</cf_tableround>
										</cf_tableround>
									</div>
							</cfif>
							
						<cfelse>

							<font style="color:red; font-size:25px">#url.id# <cf_tl id="Portal configuration does not allow content to be viewed in" class="message"> #client.browser#.</font>
							<br>
							<font style="font-size:20px; color:black"><cf_tl id="Please use Internet Explorer 8 or above" class="message"></font>

						</cfif>
				</div>

			</div>
			
			<div id="panelright"></div>
			
		</div>
		</cfoutput>
		
		<cfif url.header neq "yes">
			<script>
				$('#logo').click();
			</script>
		</cfif>
		
	</body>
</html>
