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
<cfparam name="url.source" default="">

<cfparam name="url.mid"    default="">

<cfquery name="Parameter" 
datasource="AppsInit">
	SELECT * 
	FROM   Parameter
	WHERE  HostName = '#CGI.HTTP_HOST#'
</cfquery>

<!--- determined the browser accessing the template --->
<cfparam name="client.browser" default="">
<cf_ClientCheck>

<!--- Development mode to edit labels --->
<cfparam name="client.editing" default="0">

	<cf_LabelEditing>
	<cf_tl id="Configuration" var="lt_configuration">

	<cfparam name="Attributes.stylesheet"        default="PKDB.css">
	<cfparam name="Attributes.HTML"              default="Yes">
	<cfparam name="Attributes.jQuery"            default="No">
	<cfparam name="Attributes.bootstrap"         default="No">	
	<cfparam name="Attributes.blur"              default="No">
	<cfparam name="Attributes.busy"              default="busy10.gif">	
	<cfparam name="Attributes.SystemModule"      default="">	
	<cfparam name="Attributes.functionClass"     default="Support">
	<cfparam name="Attributes.FunctionName"      default="">	
	<cfparam name="Attributes.scroll"            default="No">
	<cfparam name="Attributes.overflow"          default="hidden">
	<cfparam name="Attributes.favicon"           default="yes"> <!--- show browser icon --->
	<cfparam name="Attributes.blockEvent"        default="">	<!--- rightclick --->	
	<cfparam name="Attributes.focuson"           default="window">	
	<cfparam name="Attributes.onfocus"           default="">
	<cfparam name="Attributes.onclose"           default="">
		
	<cfparam name="Attributes.doctype"           default="HTML">	
	<cfparam name="Attributes.doctypePortal"     default="No">
	<cfparam name="Attributes.Signature"     	 default="No">

	<!--- ---------------------------- --->   
	<!--- only relevant of HTML = YES  --->
	<!--- ---------------------------- --->
	
	<cfparam name="Attributes.Layout"            default="Default">	
	<cfparam name="Attributes.Margin"            default="0">	
	<cfparam name="Attributes.User"              default="Yes">		
	<cfparam name="Attributes.Mail"              default="No">
	
	<cfparam name="Attributes.alias"             default="appsSystem">
	<cfparam name="Attributes.icon"              default="">
	<cfparam name="Attributes.label"             default="">
	<cfparam name="Attributes.band"              default="Yes">
	<cfparam name="Attributes.title"             default="#attributes.label#">
	<cfparam name="Attributes.option"            default="">  <!--- reserve text --->	
	<cfparam name="Attributes.banner"            default="Black">
	<cfparam name="Attributes.bannerheight"      default="50">
	<cfparam name="Attributes.bannerforce"       default="No">
	<cfparam name="Attributes.line"              default="Yes">	
	<cfparam name="Attributes.width"             default="100%">
	<cfparam name="Attributes.height"            default="">	
		
	<!--- to be validated Dev 1/8/2013 --->
	
	<cfparam name="Attributes.bstyle"            default="">	
	<cfparam name="Attributes.border"            default="1">	
	<cfparam name="Attributes.bgcolor"           default="ffffff">
	<cfparam name="Attributes.bgimage"           default="">
	<cfparam name="Attributes.Mode"              default="solidcolor">
			
	<cfparam name="attributes.background"   	default="blue">
	<cfparam name="attributes.backgroundColor"  default="DDDDDE">
	<cfparam name="attributes.textColorLabel" 	default="white">
	<cfparam name="attributes.textColorName"  	default="000000">
	<cfparam name="attributes.textColorClose" 	default="white">
	<cfparam name="attributes.textColorOption" 	default="white">
			
	<!--- ---------------------------- --->   
	<!--- ---------------------------- --->
	<!--- ---------------------------- --->
	
	<cfif attributes.HTML eq "Yes">
		<cfparam name="Attributes.ValidateSession"   default="Yes">			
	<cfelse>
	    <cfparam name="Attributes.ValidateSession"   default="No">			
	</cfif>	
			
	<cfparam name="Attributes.MenuAccess"            default="No">		
	<cfparam name="url.IdMenu"                       default="00000000-0000-0000-0000-000000000000">
	<cfparam name="url.SystemFunctionId"             default="#url.idmenu#">
	<cfparam name="Attributes.SystemFunctionId"      default="#url.systemfunctionid#">	
	<cfparam name="Attributes.Mission"           	 default="">	
	<cfparam name="attributes.ActionObject"          default = "">
	<cfparam name="attributes.ActionObjectKeyValue1" default = "">
	<cfparam name="attributes.ActionObjectKeyValue2" default = "">
	<cfparam name="attributes.ActionObjectKeyValue3" default = "">
	<cfparam name="attributes.ActionObjectKeyValue4" default = "">
	
	<!--- variable used to detect if the pages has to be shown or printed --->
	<cfparam name="url.print"                    default="0">
	
	<cfparam name="attributes.menuClose"       	 default="yes">
	<cfparam name="attributes.menuBack"       	 default="no">
	<cfparam name="attributes.menuCopy"       	 default="no">
	<cfparam name="attributes.menuPrint"         default="no">
	<cfparam name="attributes.menuPrintIcon"     default="print_white.png">
	<cfparam name="attributes.TreeTemplate"      default="No">
	
	<!--- provision for CFM rending to DFP, Excel used in reporting framework to prevent it to be show ---> 
	<cfparam name="URL.FileFormat"               default="HTM">
	
	<cfif URL.FileFormat neq "HTM">
		<cfset attributes.HTML   = "No">
		<cfset attributes.Scroll = "No">
	</cfif>

	<cfif attributes.HTML eq "No">
		<cfparam name="Attributes.color"        default="white">
	<cfelseif attributes.banner eq "Black">
		<cfparam name="Attributes.color"        default="d0d0d0">
	<cfelse>
		<cfparam name="Attributes.color"        default="white">
	</cfif>

	<cfinclude template="HTMLHead.cfm">
	<cfinclude template="HTMLBody.cfm">
	<cfinclude template="AccessCheck.cfm">
	
	<cfif Attributes.MenuAccess eq "Context">
		<cfset url.menuaccess = attributes.MenuAccess>
	</cfif>
		
	<!--- used for an overlayer in case of busy screen --->

	<style>
			
		#page-cover {
		    display: none;
		    position: fixed;
		    width: 100%;
		    height: 100%;
		    background-color: b0b0b0;
		    z-index: 9999999;
		    top: 0;
		    left: 0;
		}
	
		li {
    		list-style: inherit;
		}
	
	</style>

	<div id="page-cover"></div>		
	
	<div class="prosisHelpContainer prosisHelpContainerDefaultColor prosisHelpContainerTOP prosisHelpUndock">
		<div class="prosisHelpOptionsContainer">
		
			<div class="prosisHelpOption">
			    <!---
				<div class="prosisHelpCenter prosisHelpLabel">
					<cf_tl id="Pin">
				</div>
				--->
				<div class="prosisHelpCenter">
					<input type="Checkbox" id="cbProsisHelpPin" class="prosisHelpPin" onchange="pinUnpinProsisHelp(this.checked)">
				</div>
			</div>
			
		</div>
		<div id="prosisHelpPresenter"></div>
	</div>
			
	<cfif attributes.scroll eq "Yes">			
		<div class="screen" valign="top" id="div_container_screen"> 	
	<cfelseif attributes.scroll eq "Horizontal">		
		<div class="screen" valign="top" style="overflow-y:hidden" id="div_container_screen">								
	<cfelseif attributes.scroll eq "Vertical">		
		<div class="screen" valign="top" style="overflow-x:hidden" id="div_container_screen">
	<cfelseif attributes.scroll eq "Verticalshow">		
		<div class="screen" valign="top" style="overflow-x:hidden; overflow-y:scroll" id="div_container_screen">  	
	</cfif>	
			
	<cfif attributes.band eq "No">
		<cfset bh = "0">
		<cfset bv = "0">
		<cfset bg = "0">		
	<cfelse>
		<cfset bh = "2">
		<cfset bv = "15">
		<cfset bg = "7">
		
	</cfif>	
				
	<cfoutput>
			
	<!--- -------------------------------------------------------------------------- --->
	<!--- this is generate the top HTML portion of the page with 4 different layouts --->
	<!--- -------------------------------------------------------------------------- --->
	
			
	<cfif attributes.systemmodule neq "" 
	    and attributes.functionname neq "" 
	    and (Attributes.SystemFunctionId eq ""  
		              or Attributes.SystemFunctionId eq "undefined" 
					  or Attributes.SystemFunctionId eq "00000000-0000-0000-0000-000000000000")>
							
	    <!--- we generate a system function id --->
		
		<cf_ModuleInsertSubmit
		   SystemModule   = "#attributes.SystemModule#" 
		   FunctionClass  = "#attributes.FunctionClass#"
		   FunctionName   = "#attributes.FunctionName#" 
		   MenuClass      = "Dialog"
		   MenuOrder      = "1"
		   MainMenuItem   = "0"
		   FunctionMemo   = "#attributes.FunctionName#"
		   ScriptName     = ""> 
		   
		   <cfset url.systemfunctionid        = rowguid>
		   <cfset attributes.systemfunctionid = rowguid>
		   
				   		   
   </cfif>
        
   <cfif attributes.mission neq "" or attributes.systemfunctionid neq "">
         
   		<!--- added 1/12/2016 to log also from valid system function to capture
		the mission etc.the action being loaded --->
						
		<cf_submenuLog systemfunctionid = "#attributes.systemfunctionid#"
		      mission               = "#attributes.mission#"
			  actionObject          = "#attributes.ActionObject#"
			  actionObjectKeyValue1 = "#attributes.ActionObjectKeyValue1#"
			  actionObjectKeyValue2 = "#attributes.ActionObjectKeyValue2#"
			  actionObjectKeyValue3 = "#attributes.ActionObjectKeyValue3#"
			  actionObjectKeyValue4 = "#attributes.ActionObjectKeyValue4#">				
   
   </cfif>

    <cfif attributes.HTML eq "Label">

		<!--- put the header in a label object to be show --->
		
		<cfif url.systemfunctionid neq "">
				
			<cf_LanguageInput
				TableCode       = "Ref_ModuleControl" 
				Mode            = "get"
				Name            = "FunctionName"
				Key1Value       = "#url.SystemFunctionId#"				
				Label           = "Yes">
							
			<cfsavecontent variable="labelcontent">
			
				<cfoutput>
				
					<table>				
					<tr><td class="labellarge">#lt_content#</td>				
					<cfif getAdministrator("*") eq "1">										
				        <td style="color:black;padding-left:5px;padding-right:5px">|</td>
						<td align="center" class="labelmedium">		
					     <img src="#session.root#/images/logos/System/Maintain.png" 
						  style="cursor:pointer" height="21" width="21" 
						  title="#lt_configuration#" 
						  border="0" 
						  onclick="supportconfig('#systemfunctionid#')">						     
						</td>
					</cfif>								
					</tr>				
					</table>
				
				</cfoutput>
			
			</cfsavecontent>	
			
			<cfset caller.screentoplabel = labelcontent>
		
		</cfif>				
  	
	<cfelseif attributes.HTML eq "Yes">

		 <cfparam name="attributes.close" default="returnValue=1;parent.window.close()">	
		
		   <!--- part of the framework for session enforced closing --->	
		   <table class="hide">
		
			   <tr>
			   		<td class="hide">
	
					<input type = "button" 
					    id      = "applicationclosebutton" 
						style   = "visibility:hidden" 
						onclick = "javascript:try {opener.parent.right.history.go()} catch(e){};#attributes.close#">  
			
					</td>
				</tr>
			</table>	
								
		<cfif attributes.layout eq "WebApp">

			<cfinclude template="HeaderBackground.cfm">				
						
			<cfset bg = background>		
			<cf_assignId>
			<cfset vScreenId = rowGuid>
																								
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	
				<tr bgcolor="white">
		
					<td width="100%" height="100%" align="right" valign="top">
							
						<table width="100%" height="100%">
						
							<tr id="screentopbox">
													
								<td width="100%" align="right">		
																	
									<table width="100%" border="0"
									background="<cfif attributes.mail eq 'yes'>#SESSION.root#/#bg#</cfif>"
									style="background-repeat:no-repeat; background-image:url(#SESSION.root#/#bg#); background-position:left top; -webkit-background-size:100% 100%; -moz-background-size:100% 100%; -o-background-size:100% 100%; background-size:100% 100%; background-color:###attributes.backgroundColor#;">
	
										<cfif attributes.option neq "">
											<cfset ht = "60">
										<cfelse>
											<cfset ht = attributes.bannerheight>
										</cfif>		
										
										<cfif ht lt 50>
										  <cfset ht = 50>
										</cfif>		
										
										<cfset ich = ht - 20>															
										<cfset icw = ht - 15>
										
										<tr>
										
										<cfif attributes.icon neq "">	
											<td valign="top" style="width:50px;padding-top:4px;padding-left:4px">											   
												<img src="#SESSION.root#/images/#attributes.icon#" alt="" height="#ich#" width="#icw#" border="0" align="absmiddle">									
											</td>																	
											</cfif>			
											
											<td rowspan="<cfif attributes.option eq ''>1<cfelse>2</cfif>" height="#ht#">
	
												<table width="100%" cellspacing="0" cellpadding="0" border="0">													
													<tr>													
														<td colspan="2">
															<table width="100%" cellspacing="0" cellpadding="0">
																<tr>
																	<td align="center" class="labelmedium drk-hover" style="width:50px;background:##033F5D;width:32px;border-right:1px solid rgba(255,255,255,0.2);padding:10px 10px 10px 10px;height:50px;">
																	   <img src="#session.root#/images/logos/menu/prosis-icon.png" style="cursor:pointer" height="24" width="24" title="Function" border="0" onclick="##">						 
																	</td>											
																	<td>
																	<table width="100%" cellspacing="0" cellpadding="0">
																		<tr style="height:22px">
																		<td class="fixlength labellarge" style="padding-left:17px;color:#attributes.textColorClose#;">																																				
																			<span id="screentoplabel" style="font-size:20px;">#Attributes.label#  <cfif url.print eq "1"><font size="2"><i><cf_tl id="Print Version" class="message"></i></font></cfif></span>																		
																		</td>
																		</tr>
																		<cfif attributes.option neq "">
																		<tr style="height:23px">																																									
																			<td class="fixlength labelit" id="screentopoption" style="padding-left:26px;color:#attributes.textColorClose#">#attributes.option#</td>
																		</tr>	
																	    </cfif>
																	</table>
																	</td>
																	
																	<!--- container for show of interval check in workflow --->	
																	<span class="hide" id="communicate"></span>
																	
																</tr>
																																
															</table>
														</td>
													</tr>
													
												</table>
											</td>											
	
											<cfif attributes.user neq "No">
											
												<cfparam name="url.mission" default="">
												
												<cfset pad = attributes.bannerheight - 42>
																																															
												<cfset vPaddingOption = "">
											  											
												<td align="right" valign="top" style="#vPaddingOption#">
																																																										
												<cf_space spaces="60">												
																								
												<cfif CGI.HTTPS eq "off">
													<cfset tpe = "http">
												<cfelse>	
													<cfset tpe = "https">
												</cfif>
												
												<table height="100%" border="0" cellspacing="0" cellpadding="0">
												
													<tr>
													    <cfif attributes.menucopy eq "Yes">
                                                        <td class="fixlength labelmedium drk-hover" style="border-left:1px solid rgba(255,255,255,0.2);padding:12px 18px;color:#attributes.textColorClose#;"
														 align="right" onclick="ptoken.open('#tpe#://#SERVER_NAME#/#SCRIPT_NAME#?#cgi.query_string#','_blank')">														 
														 #SESSION.first# #SESSION.last#														 													
													     <cfif session.isAdministrator eq "yes">*</cfif></td>
														 <cfelse>
														  <td class="fixlength labelmedium drk-hover" style="border-left:1px solid rgba(255,255,255,0.2);padding:12px 18px;color:#attributes.textColorClose#;"
														 align="right">														 
														 #SESSION.first# #SESSION.last#														 													
													     <cfif session.isAdministrator eq "yes">*</cfif></td>
														 </cfif>
                                                    </td>											
														<td class="labelit" align="right">
														
														<table border="0" cellspacing="0" cellpadding="0">
														<tr>
														
														<!--- -------------- --->
														<!--- -- print icon- --->
														<!--- -------------- --->
														
														<cfif attributes.menuPrint eq "yes">
																						
															<td align="right" width="1%" class="fixlength labelmedium drk-hover" align="center" style="border-left:1px solid rgba(255,255,255,0.2); font-size:11px; color:#attributes.textColorClose#; padding-top:3px; padding-right:15px; padding-left:15px;">										
																<div class="clsScreenTopPrintTitle" style="display:none;">#Attributes.title#</div>
																
																<cf_tl id="Print Screen Content" var="1">
																
																<cf_button2
																	type="print"
																	mode="icon"
																	imageHeight="22px"
																	height="auto"
																	width="auto"
																	title="#lt_text#"
																	image="#attributes.menuPrintIcon#"
																	printTitle=".clsScreenTopPrintTitle"
																	printContent=".clsScreenTopPrintContent_#vScreenId#"
																	printCallback="$('.clsCFDIVSCROLL_MainContainer').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','height:100%;');">
																	
															</td>
														
														</cfif>
														
														<!--- -------------- --->
														<!--- -support icon- --->
														<!--- -------------- --->
																												
														<cfif (url.systemfunctionid neq "" 
														    and systemfunctionid neq "" 
															and systemfunctionid neq "00000000-0000-0000-0000-000000000000"
															and systemfunctionid neq "undefined")> 	

															<cfquery name="getFunction" 
																datasource="AppsSystem"
																username="#SESSION.login#" 
																password="#SESSION.dbpw#">
																	SELECT *
																	FROM  Ref_ModuleControl
																	WHERE SystemFunctionId  = '#systemfunctionid#'				
															</cfquery>
																																
															<cfquery name="HelpTopic" 
																datasource="AppsSystem"
																username="#SESSION.login#" 
																password="#SESSION.dbpw#">
																	SELECT *
																	FROM  HelpProjectTopic
																	WHERE SystemFunctionId  = '#systemfunctionid#'				
															</cfquery>
															
															<cfif helptopic.recordcount gte "1">
																
																<td align="center" class="labelmedium drk-hover" style="width:32px;border-left:1px solid rgba(255,255,255,0.2);border-right:1px solid rgba(255,255,255,0.2);padding:12px 12px;color:#attributes.textColorClose#;">										
																	<a style="color:###attributes.textColorClose#;">													
																	<cf_helpfile systemfunctionid="#url.systemfunctionid#" styleclass="labelit" Display="Icon" IconFile="logos/menu/help.png">							
																	</a>							
																</td>
															
															</cfif>
																														
															<cfif getAdministrator('*') eq "1" and getFunction.FunctionClass neq "System" 
															                                   and getFunction.FunctionClass neq "Maintain" 
																							   and getFunction.FunctionClass neq "Utility">
							
													        <td align="center" class="labelmedium drk-hover" style="width:32px;border-left:1px solid rgba(255,255,255,0.2);border-right:1px solid rgba(255,255,255,0.2);padding:12px 12px;">
														     <img src="#session.root#/images/logos/menu/config.png" style="cursor:pointer" height="24" width="24" title="#lt_configuration#" border="0" onclick="supportconfig('#systemfunctionid#')">						     
															</td>
						
															</cfif>
															
															<cfquery name="Parameter" 
															datasource="AppsInit">
																SELECT * 
																FROM Parameter
																WHERE HostName = '#CGI.HTTP_HOST#'
															</cfquery> 
																																													
															<cfif Parameter.SystemSupportPortalId neq "">
				
															<td align="center" class="labelmedium drk-hover" style="width:32px;border-left:1px solid rgba(255,255,255,0.2);border-right:1px solid rgba(255,255,255,0.2);padding:12px 12px;">						
																   <img src="#session.root#/images/logos/menu/support.png" style="cursor:pointer" height="24" width="24" alt="" border="0" onclick="supportticket('#systemfunctionid#','','#url.mission#')">						                                       
															</td>															
															
															</cfif>
															
														<cfelseif attributes.systemmodule neq "">
														
															<cfquery name="Parameter" 
															datasource="AppsInit">
																SELECT * 
																FROM Parameter
																WHERE HostName = '#CGI.HTTP_HOST#'
															</cfquery> 
															
															<cfif Parameter.SystemSupportPortalId neq "">
															
															<td align="center" class="labelmedium drk-hover" style="width:32px;border-left:1px solid rgba(255,255,255,0.2);border-right:1px solid rgba(255,255,255,0.2);padding:12px 12px;">																
															   <img src="#session.root#/images/logos/menu/support.png" style="cursor:pointer" height="24" width="24" alt="" border="0" onclick="supportticket('','#attributes.systemmodule#')">						                                       
															</td>															
															
															</cfif>																											
															
														</cfif>
														
														<!--- -------------- --->
														<!--- ---back icon- --->
														<!--- -------------- --->
														
														<cfif attributes.menuBack eq "yes">
														<cf_tl id="Go back" var="1">
														<td style="color:#attributes.textColorClose#;padding-left:5px;padding-right:5px">|</td>																																												
														<td align="center" class="labelmedium drk-hover" style="width:32px;border-left:1px solid rgba(255,255,255,0.2);border-right:1px solid rgba(255,255,255,0.2);padding:12px 12px;color:#attributes.textColorClose#;" title="#lt_text#">													
													
															 <img src="#session.root#/images/logos/menu/back.png" style="cursor:pointer" height="24" width="24" alt="" 
																     border="0" onclick="javascript:window.history.back();">													
														
														</td>
														
														</cfif>
														
														
														<!--- -------------- --->
														<!--- ---close icon- --->
														<!--- -------------- --->
														
														<cfif attributes.menuClose eq "yes">
														
														<td class="labelmedium"  align="right" style="color:#attributes.textColorClose#;">													
													
															<!--- ----- help --- --->											
															
															<cfif url.print neq "1">	
															
															     <table cellspacing="0" cellpadding="0">
																 <tr>
																 
																 <td style="border-left:1px solid rgba(255,255,255,0.2);border-right:1px solid rgba(255,255,255,0.2);padding:12px 12px;color:#attributes.textColorClose#;">	
																	<cfif Attributes.MenuAccess      eq "Context"><img src="#session.root#/images/logos/menu/context.png" style="cursor:pointer" height="12" width="12" title="Context" border="0"></cfif>
																	
																</td>
																
																<td align="center" class="labelmedium drk-hover" style="width:32px;border-left:1px solid rgba(255,255,255,0.2);border-right:1px solid rgba(255,255,255,0.2);padding:12px 12px;">
																 
																 <img src="#session.root#/images/logos/menu/close.png" style="cursor:pointer" height="24" width="24" alt="" 
																     border="0" onclick="javascript:#attributes.close#">															
																							
																</td>
																</tr></table>
																
															</cfif>														
														
														</td>
														
														</cfif>
														
														</tr>
														</table>
														
														</td>												
													
													</tr>
												
												</table>
												
												</td>					
											
											</cfif>
											
										</tr>																			
																														
									</table>		
											
								</td>
							</tr>										
											
							<cfif attributes.line eq "Yes">											
							<tr>
								<td class="linedotted"></td>
							</tr>													
							</cfif>
	
							<tr bgcolor="#attributes.bgcolor#">		
							
							<!--- height="100%" removed for IE10 --->
							
								<!--- kherrera(20170207): removed style="padding-top:10px" --->
								<td colspan="2" height="100%" valign="top" class="clsScreenTopPrintContent_#vScreenId#">
								
																
								
		<cfelseif attributes.layout eq "Self">
			<cfset AjaxOnLoad("function(){window.parent.ProsisUI.setWindowTitle('#Attributes.label#','#Attributes.banner#','#Attributes.textColorLabel#');}")>
			
		<cfelseif attributes.layout eq "WebDialog">

			<cfparam name="url.mission" default="">
			<cfparam name="attributes.close" default="returnValue=1;window.close()">
			<table  width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">	
				<tr bgcolor="white">
										
					<td width="100%" height="100%" align="right" valign="top">
										
						<cfinclude template="HeaderBanner.cfm">
						<cfif bg neq "">
								<table cellpadding="0" 
								cellspacing="0" 
								border="0" 
								width="100%" 
								height="100%" 
								background="<cfif attributes.mail eq 'yes'>#SESSION.root#/images/logos/#bg#</cfif>"
								style="padding-right:3px; background-position:100% 0%; background-image:url(#SESSION.root#/images/logos/#bg#); background-repeat:no-repeat">
								
								<cfif attributes.option neq "">
									<cfset ht = "75">													
								<cfelse>
									<cfset ht = "#attributes.bannerheight#">
								</cfif>
						</cfif>
						
							<tr>							
								<td width="100%" align="right">	
									<table cellpadding="0" cellspacing="0" width="100%" border="0">									
										<tr>
											<td height="#ht#" style="padding-top:4px">
												<table cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden">
													<tr>
														<td colspan="2" style="padding-left:10px">
															<cf_tableround mode="custom" wd ="6px" ht="6px" path="#SESSION.root#/Images/Logos/border/">	
															<table cellpadding="0" cellspacing="0" border="0">
																<tr>
																	<cfif attributes.icon neq "">	
																	<td>											   
																		<img src="#SESSION.root#/images/#attributes.icon#" alt="" height="28" width="28" border="0" align="absmiddle">									
																	</td>
																	<td width="6"></td>
																	</cfif>
                                                                    
																	<td id="screentoplabel" style="padding-left:20px;padding-right:20px;padding-top:0px;padding-bottom:3px;line-height: 17px; font-size: 18px; font-family: Calibri;">#Attributes.label# <cfif url.print eq "1"><font size="2"><i><cf_tl id="Print Version" class="message"></i></font></cfif></td>
																</tr>
															</table>
															</cf_tableround>
														</td>
													</tr>
													<!---<cfif attributes.option neq "">--->
													<tr>
														<td colspan="2" height="5"></td>
													</tr>
													
													<cfif attributes.option neq "">
													<tr>
														<td style="padding-left:7px"></td>
														<td width="100%" align="right">#attributes.option#</td>
													</tr>	
													</cfif>				
													<!---</cfif>--->
												</table>
											</td>
											
											<cfif attributes.user neq "No">
											
												<td align="right" style="padding-right:6px">	
												
												<cf_space spaces="60">	
												
												<table height="100%" cellspacing="0" cellpadding="0" class="formpadding">
												
													<tr><td class="labelit">#SESSION.first# #SESSION.last#</td>
												    	<td style="color:#attributes.textColorClose#;padding-left:5px;padding-right:3px">|</td>																	 
													
														<td class="labelit" align="right" style="padding-bottom:5px">
														
														<table cellspacing="0" cellpadding="0">
														<tr>
														
														<cfif url.systemfunctionid neq ""> 	
																		
															<cfquery name="HelpTopic" 
																datasource="AppsSystem"
																username="#SESSION.login#" 
																password="#SESSION.dbpw#">
																	SELECT *
																	FROM  HelpProjectTopic
																	WHERE SystemFunctionId  = '#systemfunctionid#'				
															</cfquery>
																														
															<cfif helptopic.recordcount gte "1">
														
																<td class="labelit" style="color:#attributes.textColorClose#;" align="right">										
																	<a style="color:#attributes.textColorClose#;"><i>														
																	<cf_helpfile systemfunctionid="#url.systemfunctionid#" styleclass="labelit" Display="Text" DisplayText="Help">							
																	</a>							
																</td>
																<td style="color:#attributes.textColorClose#;padding-left:5px;padding-right:3px">|</td>		
															
															</cfif>
															
														</cfif>
														
														<td style="color:#attributes.textColorClose#;">
													
														<!--- ----- help --- --->											
														
														<cfif url.print neq "1">		
																			
															<a style="color:#attributes.textColorClose#;" href="javascript:try {opener.parent.right.history.go()} catch(e){};#attributes.close#">
															 <cf_tl id="Close">
														    </a>	
																										
															<cfif Attributes.MenuAccess      eq "Context">[-]</cfif>
															<cfif Attributes.ValidateSession eq "Yes">[!]</cfif>
															
														</cfif>
														
														
														</td>
														</tr>
														</table>
														
														</td>
													</tr>
												
												</table>
																								 
												</td>
											
											</cfif>
											
											<td width="4" id="xsessionvalid"      style="width:0px; height:0px; line-height:0px; font:0px;"></td>
											<td width="0" id="xsessionvalidcheck" style="width:0px; height:0px; line-height:0px; font:0px;"></td>
											
										</tr>
									</table>
								</td>
							</tr>
														
							<cfif attributes.line eq "Yes">
														
								<tr><td class="linedotted"></td></tr>
																		
							</cfif>
			
							<tr bgcolor="#attributes.bgcolor#">		
														
								<td height="100%" colspan="2" style="padding:2px" valign="top">
																
		
		<cfelseif attributes.layout eq "InnerBox">

			<cfparam name="Attributes.close" default="">
			
			<table width="#attributes.width#" 
				bordercolor="0057b9" 
				border="0" 
				height="#attributes.height#" 
				cellspacing="0" 
				cellpadding="0"
				class="formpadding"
				style="overflow-x:hidden">
				<tr>
					<td>
						<table width="100%" bordercolor="black" border="0" height="#attributes.height#" cellspacing="0" cellpadding="0" style="overflow-x:hidden">

							<cfif attributes.label neq "">		
							<tr>
								<td height="#Attributes.bannerheight#"
								background="#SESSION.root#/Images/BG_Header.jpg" 
								style="border: 1px solid a0a0a0; background-repeat:repeat-x">
								
									<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">										
										<tr><td height="5"></td></tr>		
										<tr>
											<td>&nbsp;&nbsp;<font size="2" color="808080">#Attributes.label# <cfif url.print eq "1"><font size="2"><i><cf_tl id="Print Version" class="message"></i></font></cfif></td>
											<td align="right">
												<cfif attributes.close neq "">
													<cfif url.print neq "1">
														<button name="Close" id="Close"
															value="Close"
															class="button10s"
															style="width: 80px; background-color: dadada;"
															onClick="#attributes.close#">Close</button>
													</cfif>												
												</cfif>
									
											</td>  
											<td width="2"></td>
										</tr>												
									</table>
								</td>
							</tr>																
							</cfif>
							
							<tr>
								<td style="width:0px; height:0px; line-height:0px; font:0px;">
									<table cellspacing="0" cellpadding="0" style="width:0px; height:0px; line-height:0px; font:0px;">
										<tr>
											<td id="xsessionvalid" style="width:0px; height:0px; line-height:0px; font:0px;"></td>
											<td id="xsessionvalidcheck" style="width:0px; height:0px; line-height:0px; font:0px;"></td>
										</tr>
									</table>
								</td>
							</tr>				
											
							<tr>
								<td style="border: #attributes.border#px solid a0a0a0;" bgcolor="white" valign="top">
								
		
		<cfelseif attributes.layout eq "None">

		<cfelse>
			<!--- It seems this part is for the login in selfservice (comment by dev 8/8/2013)--->
			<cfset row = "9">	
			<cfset image = "#SESSION.root#/tools/selfservice/LoginImages">			
														
			<cfif Parameter.ApplicationTheme eq "Classic">
				<cfset customimage ="#SESSION.root#/Portal/Logon/black.jpg">			
			<cfelseif Parameter.ApplicationTheme eq "DarkBlue">
				<cfset customimage ="#SESSION.root#/Portal/Logon/black.jpg">			
			<cfelseif Parameter.ApplicationTheme eq "BlueGreen">
				<cfset customimage ="#SESSION.root#/Portal/Logon/black.jpg">				
			<cfelse>			  
				<cfset customimage ="#SESSION.root#/Custom/Logon/#Parameter.ApplicationServer#">						
			</cfif>		
																	
			<table border="0" height="#attributes.height#" cellpadding="0" cellspacing="0" width="#attributes.width#">
			
				<tr>
					<td><img src="#image#/spacer.gif" width="10" height="5" border="0" alt=""/></td>
					<td><img src="#image#/spacer.gif" width="#bv#" height="1" border="0" alt=""/></td>
					<td><img src="#image#/spacer.gif" width="30" height="1" border="0" alt=""/></td>
					<td><img src="#image#/spacer.gif" width="16" height="1" border="0" alt=""/></td>
					<td><img src="#image#/spacer.gif" width="15" height="1" border="0" alt=""/></td>
					<td><img src="#image#/spacer.gif" width="10" height="1" border="0" alt=""/></td>
					<td><img src="#image#/spacer.gif" width="10" height="1" border="0" alt=""/></td>
					<td><img src="#image#/spacer.gif" width="#bv#" height="1" border="0" alt=""/></td>
					<td><img src="#image#/spacer.gif" width="10" height="1" border="0" alt=""/></td>

				</tr>  
				
				<cfif attributes.banner eq "Hide">
				
				<tr>
					<td rowspan="#row#" background="<cfif attributes.banner eq 'black'>#image#/inside01_r1_c1a.jpg</cfif>"></td>
					<td rowspan="2" colspan="5" height="2" background="#customimage#/#attributes.banner#.jpg"></td>
					<td colspan="2" background="#customimage#/#attributes.banner#.jpg"></td> 
					<td rowspan="#row#" background="<cfif attributes.banner eq 'black'>#image#/inside01_r1_c9a.jpg</cfif>"></td>
					<td></td>
				</tr>
				
				<tr>
					<td colspan="2" background="#customimage#/#attributes.banner#.jpg"></td>
					<td><img src="#image#/spacer.gif" width="1" height="#bh#" border="0" alt="" /></td>
				</tr>
				
				<tr>
					<td colspan="7" background="#image#/inside01_r4_c2a.jpg"></td>
					<td><img src="#image#/spacer.gif" width="1" height="#bh#" border="0" alt="" /></td>
				</tr>
	
				<cfelse>	
					
					
					<cfif FileExists("#SESSION.rootpath#\custom\logon\#Parameter.ApplicationServer#\header.cfm")>
						<cfset logo = "custom/logon/#Parameter.ApplicationServer#/header.cfm">
					<cfelse>
						<cfset logo = "tools/selfservice/loginimages/Promisan.jpg">						
					</cfif>
					
				<tr>						
					<td rowspan="#row#" background="<cfif attributes.banner eq 'black'>#image#/inside01_r1_c1a.jpg</cfif>"></td>
					<td colspan="7" height="25">
					
					<cfparam name="client.browser" default="Explorer">
					
					<cfif client.browser eq "Explorer">
						<cfset pd = "5px">
					<cfelse>
						<cfset pd = "6px">
					</cfif>
	
					<cfoutput>
						
						<!--- allow for a flash loading in the above graphic --->
						<iframe marginheight="0px" marginwidth="0px" 
						src="#SESSION.root#/#logo#" 
						style="height:25px; width:100%; " 
						title="Header" 
						scrolling="no" 
						frameborder="no" 
						allowtransparency="yes"></iframe>						
							
					</cfoutput>										
	
					</td>
					<cfif FileExists("#SESSION.rootpath#\custom\logon\#Parameter.ApplicationServer#\header.cfm")>
					
					<cfelse>
						<div style="position:absolute; top:8px; color:1a2962; font-family:calibri; font-size:16px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#SESSION.welcome#</div>							
					</cfif>
					<td rowspan="#row#" background="<cfif attributes.banner eq 'black'>#image#/inside01_r1_c9a.jpg</cfif>">&nbsp;</td>
					
				</tr>					
	
				</cfif>
	
				<tr>
					<td colspan="7" height="1" bgcolor="aeb8c2"></td>
					<td><img src="#image#/spacer.gif" width="0" height="#bh#" border="0" alt=""/></td>
				</tr>	  
								
				<tr>
					<td><img src="#image#/spacer.gif" width="1" height="#bh#" border="0" alt=""/></td>
				</tr>
				
				<tr>
					<td><img src="#image#/spacer.gif" width="1" height="#bh#" border="0" alt=""/></td>
				</tr>
											
				<tr>
					<td bgcolor="#attributes.bgcolor#"></td>
					<td colspan="5" bgcolor="#attributes.bgcolor#" valign="top" width="100%" height="#attributes.height#">   
	
		</cfif>

	</cfif>

	<!---
	Removed by dev on 29/Jan/2020
	<cfif attributes.HTML eq "No" and attributes.mail eq "No">
		<cf_waitend>
	</cfif>
	--->
		
	</cfoutput>
