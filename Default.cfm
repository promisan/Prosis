
<!--- important to reset --->

<cfparam name="URL.ID"                    default="">	
<cfparam name="URL.refer"                 default="">

<cfparam name="CLIENT.context"            default="main">	
<cfparam name="SESSION.Refer"             default="">
<cfparam name="CLIENT.MenuSelection"      default="">    
<cfparam name="CLIENT.MenuDescription"    default=""> 
<cfparam name="CLIENT.MandateFilter"      default=""> 

<cfparam name="CLIENT.acc"                default="">
<cfparam name="SESSION.acc"               default="#CLIENT.acc#">
<cfparam name="SESSION.logon"             default="">
<cfparam name="SESSION.last"              default="">
<cfparam name="SESSION.first"             default="">

<cf_setRelease version="8.92.00743" release="20210414">

<cfquery name="Get" 
datasource="AppsSystem">
	SELECT * 
	FROM   Parameter 
</cfquery>

<cfquery name="Parameter" 
datasource="AppsInit">
	SELECT * 
	FROM Parameter
	WHERE HostName = '#CGI.HTTP_HOST#'
</cfquery> 

<!---- checking for HTTPS  

<cfif Parameter._forceHTTP eq 0>
	<cfif CGI.HTTPS eq "off">
		<CFLOCATION URL="https://#CGI.HTTP_HOST#/#Get.VirtualDirectory#/default.cfm" addtoken="no">
	</cfif>
<cfelse>
	<cfif CGI.HTTPS eq "on">
		<CFLOCATION URL="http://#CGI.HTTP_HOST#/#Get.VirtualDirectory#/default.cfm" addtoken="no">
	</cfif>
</cfif>
--- --->

<cfset CLIENT.LanguageId = Get.LanguageCode>

<!--- define language framework --->
<cfquery name="Language" 
datasource="AppsSystem">
	SELECT  * 
	FROM    Ref_SystemLanguage 
	WHERE   Code = '#get.languageCode#'  
</cfquery>

<cfset SESSION.path = CGI.SCRIPT_NAME>

<!--- ---seliberate to blank---- --->
<cfset SESSION.authent              = "">
<cfset SESSION.root                 = Parameter.ApplicationRoot>
<!--- temporary measurement only --->
<cfset CLIENT.root                  = Parameter.ApplicationRoot>
<!--- -------------------------- --->

<cfset SESSION.rootPath             = Parameter.ApplicationRootPath>
<cfset SESSION.protectionmode       = Parameter.SessionProtectionMode>

<!--- ----------------------------------------------- --->
<!--- ---------- check coldfusion version ----------- --->
<!--- ----------------------------------------------- --->

<cfif Server.Coldfusion.ProductVersion lte "16,0,0">						
		
		<cfoutput>						
		<table align="center"><tr><td class="labelmedium" align="center" style="font-size:25px;padding-top:40px">		
                 #Parameter.SystemTitle# is no longer supported under Adobe ColdFusion 16,0,0 <br> Please contact your administrator
		</td></tr></table>	
		</cfoutput>
			
		<cfabort>
			
</cfif>			
						

<!--- ----------------------------------------------- --->
<!--- ---------- check browser version -------------- --->
<!--- ----------------------------------------------- --->
	
<cfset vMinChrome = 50>

<cf_validateBrowser minIE="#get.MinIE#" minChrome="#vMinChrome#" minEdge="#get.MinEdge#" setDocumentMode="1">

<cfset CLIENT.browser = clientbrowser.name>

<cfif clientbrowser.pass eq 0>
	<cfoutput>
		<script>
			parent.window.location = "#session.root#/tools/control/notSupported.cfm?name=#clientbrowser.name#&release=#clientbrowser.release#&minIE=#get.MinIE#&minChrome=#vMinChrome#";
		</script>
	</cfoutput>
</cfif>
	
<cfif find("Windows","#CGI.HTTP_USER_AGENT#")>
	<cfset client.os = "Windows">
<cfelse>
	<cfset client.os = "Other">
</cfif> 	

<!--- ----------------------------------------------- --->
<!--- ------------- apply IP routing ---------------- --->
<!--- ----------------------------------------------- --->

<cfinclude template="Tools/Control/IPRouting.cfm">

<!--- ----------------------------------------------- --->
<!--- ---------- apply language interface ----------- --->
<!--- ----------------------------------------------- --->

<!--- we just do this as part of the enforce of the login process --->
<cfset CLIENT.Init       = "Yes">
<!--- ----------------------------------------------------------- --->

<cfif Language.SystemDefault eq "1" or Language.Operational eq "1">
	<cfset CLIENT.LanPrefix     = "">
<cfelse>   
	<cfset CLIENT.LanPrefix     = "xl"&#Get.LanguageCode#&"_">
</cfif>


<cfif Get.LanguageInit eq "0">		

	<cfinclude template="System/Language/View/GenerateViews.cfm">  
	<cfinclude template="System/Modules/Functions/ModuleControl/ModuleLanguage.cfm"> 	
		
	<cfquery name="Update" 
	datasource="AppsSystem">
		UPDATE Parameter
		SET    LanguageInit = 1 
	</cfquery>
	
</cfif>

<cfif Get.VirtualDirectory neq "">
	<cfset CLIENT.VirtualDir  = "/#Get.VirtualDirectory#">
<cfelse>
	<cfset CLIENT.VirtualDir  = "">
</cfif>
	
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

	<HTML>
	<head>
				
		<cf_systemscript>
		<script src="Scripts/jQuery/jquery.js" type="text/javascript"></script>
		<cfoutput>
		<script>
			var hostname = "#client.root#";
		</script>
		</cfoutput>			
		<script src="Scripts/jQuery/jquery.prosis.js" type="text/javascript"></script>

		<!--- Third-Party Authentication --->
		<!--- google sign-in --->
		<cfinclude template="Portal/Logon/ThirdParty/Google/gSigninValidation.cfm">
		
		<cfoutput>
		
			<cfif FileExists ("#SESSION.rootPath#/custom/logon/#Parameter.ApplicationServer#/favicon.ico")>
				<LINK REL="SHORTCUT ICON" HREF="#client.virtualdir#/custom/logon/#Parameter.ApplicationServer#/favicon.ico">
			<cfelse>
				<LINK REL="SHORTCUT ICON" HREF="#SESSION.root#/Images/favicon.ico">
			</cfif>
			
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		
			<!--- prevent caching --->
			<meta http-equiv="Pragma" content="no-cache"> 
			<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
		
		</cfoutput>
						
		<script language="JavaScript">
		javascript:window.history.forward(1);		
		</script>

		<cfif findNoCase(".com",session.root)> 	
		<TITLE><cfoutput>#SESSION.welcome#</cfoutput>&#8482 || |   |      |    |      ||  |</TITLE>
		<cfelse>
		<TITLE><cfoutput>#SESSION.welcome#</cfoutput>  || |   |      |    |      ||  |</TITLE>
		</cfif>
		<base target="main">
		
		<style>
			td,div,font { font-family:Calibri, Trebuchet MS, Helvetica;}			
			html { overflow-y:auto; overflow-x:hidden;	margin:0px; padding:0px; border:0px; width:100%; height:100% }			
			body { overflow:hidden;margin:0px; padding:0px; border:0px; width:100%; height:100% }			
			#wrapper { width:100%; height:100% }			
			#content { width:100%; height:97%; overflow:hidden }
			div {width:100%}
		</style>
		
	</head>
	
	<body style="height:100%" onload="document.forms.loginform.<cfif client.acc eq "">account<cfelse>password</cfif>.focus();">

		<cf_notificationviewdisplay authentication="false">		
		
		<cfif url.refer eq "">
			<cfset Session.Refer = "">
		</cfif>
		
		<cfif url.id neq "">
			<cfset lid = "?id=#url.id#">
		<cfelse>
			<cfset lid = "">  
		</cfif>		
				
		<cfoutput>	
		
		<cfajaximport tags="cfwindow">
										
		<script language="JavaScript">
		
		function openmenu() {
				
				var _vAcc = document.getElementById('account');
				var _vPWD = document.getElementById('password');
				if (_vAcc.value != '' &&  _vPWD.value!='') {					    
					ptoken.submit('Portal/MainMenuOpen.cfm#lid#','_top','loginform')		
				}	
			}
			
		function requestacc() {		    
			ProsisUI.createWindow('mydialog', 'Access', '',{x:100,y:100,height:600,width:730,modal:true,center:true})    					
			ptoken.navigate('#session.root#/Portal/SelfService/Extended/Account/AccountRequest.cfm?showClose=0&id=support','mydialog') 		
			
		}	
			
		function go(e) {
	  	  		
			 keynum = e.keyCode ? e.keyCode : e.charCode					
	  		 if (keynum == 13) {
			      openmenu()
		     }		
			 
		}	 
		
		</script>	
		
		</cfoutput>	

		<cfinclude template="Portal/Logon/ThirdParty/ValidationContainer.cfm">

		<div id="wrapper" style="height:100%">		
		
			<div id="content" style="height:100%">
			
				<cfoutput>
				
				<form style="height:100%" target="_top" method="post" id="loginform" name="loginform" autocomplete="off">
																	
					<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">				
						<tr>
							<td valign="top" height="100%">						
								
								<cfset path = "custom/logon/#Parameter.applicationServer#/">
																
								<cfif directoryexists("#session.rootpath#\#replace(path,"/","\","ALL")#")>								
									<cfset found = "Yes">
								<cfelse>
									<cfset found = "No">
								</cfif>
								
								<cfset client.googleMAPId = Parameter.GoogleMAPId>								
																	
								<table width="100%" height="100%" cellspacing="0" cellpadding="0">
								
								   <tr>
								   <cfif Parameter.ApplicationTheme eq "Standard" or found eq "No">
								   								   								   
									    <cfset custom = 0> 
									    <td width="331" height="100%" bgcolor="FF8000">
										    <cfinclude template="Portal/Provider.cfm">
										</td>
										<td id="logonbox" height="100%">
										    <cfinclude template="Portal/Logon.cfm"> 																		
										</td>	 
										
								   <cfelseif Parameter.ApplicationTheme eq "Cloud" and found eq "Yes">
								   							   
									    <cfset custom = 0> 
									   	<td height="100%" width="330" bgcolor="f9601c">
											<cfinclude template="Portal/Provider.cfm">
										</td>
										<td id="logonbox" height="100%">
										    <cfinclude template="Custom/Logon/#Parameter.ApplicationServer#/Index.cfm">																				
										</td>	
									
								   <cfelseif Parameter.ApplicationTheme eq "Extended" and found eq "Yes">
								   
								   		<td id="logonbox" height="100%">
											<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">											
												<tr><td valign="top" height="100%"><cfinclude template="Custom/Logon/#Parameter.ApplicationServer#/Index.cfm">												
												</td></tr>
											</table>
										</td>
										
								   <cfelse>	
								   						   
								    <td height="100%" id="logonbox" style="background-image:url('<cfoutput>#path#</cfoutput>loginbg.jpg'); background-repeat:no-repeat">										
									    
										<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">										
										<tr><td valign="top" style="padding-top:20px" height="95%"><cfinclude template="Custom/Logon/#Parameter.ApplicationServer#/Index.cfm"></td></tr>										
										<tr><td height="36" valign="top">																				
											<table width="95%" cellspacing="0" cellpadding="0" align="center">																
												<tr>													
													<td align="left" style="font-family:calibri, Trebuchet MS; color:black; font-size:12px">
														ColdFusion: <strong>#Server.Coldfusion.ProductVersion#</strong>
													</td>													
													<td align="right" style="font-family:calibri, Trebuchet MS; color:black; font-size:12px">
														<cf_tl id="Browser">: <strong>														
														#clientbrowser.name# #clientbrowser.release# <cfif clientbrowser.pass eq "0"><cf_tl id="Not supported"></cfif>																				
														</strong>
													</td>
												</tr>
											</table>											
										</td></tr>
										</table>								
									</td>	
								   </cfif>	
								   </tr>	
								</table>													
										
							</td>
						</tr>
					</table>
					
					<input type="hidden" name="width"       id="width"       value="">
					<input type="hidden" name="height"      id="height"      value="">
					<input type="hidden" name="innerheight" id="innerheight" value="">	
					
				</form>				
				
				</cfoutput>
				
			</div>			
			
		</div>	
		
		<!--- capture the size of the screen to be used --->
					
		<script>		
			
			var _vPWD = document.getElementById('password');
			var _vAcc = document.getElementById('account');
			
			if (_vAcc) { 
				_vAcc.focus();
				if (_vAcc.value != '') {
					_vPWD.focus();
				}
			}
		
			if (screen) {					
				document.getElementById('width').value    = screen.width
				document.getElementById('height').value   = screen.height								
			}						
			if (window.innerHeight){ 						
				document.getElementById('innerheight').value = window.innerHeight 							
			} else { 						
				document.getElementById('innerheight').value = document.body.clientHeight 							
			}				
					
		</script>			
		
	</body>
	</html>
	