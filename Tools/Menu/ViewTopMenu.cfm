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
<cfparam name="url.menuaccess" default="No">
<cfparam name="url.mission"    default="">

<cfparam name="attributes.background"   	default="">
<cfparam name="attributes.backgroundColor"  default="DDDDDE">
<cfparam name="attributes.textColorLabel" 	default="white">
<cfparam name="attributes.textColorName"  	default="white">
<cfparam name="attributes.textColorClose" 	default="white">
<cfparam name="attributes.textColorOption" 	default="white">
<cfparam name="attributes.label"        	default="#SESSION.welcome# application">
<cfparam name="attributes.icon"         	default="">
<cfparam name="attributes.option"       	default="">
<cfparam name="attributes.user"          	default="Yes">
<cfparam name="attributes.bannerheight" 	default="52px">
<cfparam name="attributes.systemmodule"  	default="">
<cfparam name="attributes.Close"	        default="window.close()">
<cfparam name="attributes.ValidateSession"	default="Yes">
<cfparam name="attributes.MenuAccess"   	default="#url.menuaccess#">
<cfparam name="systemfunctionid" 			default="">

<cfif isDefined("Module") and Module neq "">
	
	<cfquery name="getModule" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			SELECT 	*
			FROM 	Ref_ModuleControl
			WHERE	MenuClass = 'mission'
			AND		SystemModule = '#module#'
			
	</cfquery>
	
	<cfif getModule.recordCount gt 0>
		<cfset idMenu = getModule.SystemFunctionId>
		<cfset SystemFunctionId = getModule.SystemFunctionId>
	</cfif>
	
</cfif>

<cfoutput>

	<cfset vTakeBackgroundColorCriteria = 0>
	
	<cfif isDefined("SystemFunctionId") or isDefined("idMenu")>
				
		<cfif isDefined("idMenu")>
			<cfif idMenu neq "">
				<cfset SystemFunctionId = idMenu>
			</cfif>	
		</cfif>	
						
		<cfif SystemFunctionId neq "" and attributes.background eq "">
			
			<cfquery name="get" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT DISTINCT  
							A.Code, 
							A.Description, 
							A.ListingOrder
					FROM    Ref_Application A 
							INNER JOIN Ref_ApplicationModule M 
								ON A.Code = M.Code 
								AND A.Usage = 'System'	 													 
					WHERE	M.SystemModule IN (SELECT SystemModule 
					                           FROM   Ref_ModuleControl 
											   WHERE  SystemFunctionId = '#SystemFunctionId#')
					AND		A.Operational = '1'	
			</cfquery>
			
			<cfif get.recordCount gt 0>
										
				<cfif get.code eq "AD">
					<cfset background = "Images/Logos/Banners/AdministrationGray.jpg">
					<cfset attributes.textColorLabel   = "FFFFFF">
					<cfset attributes.textColorName    = "FFFFFF">
					<cfset attributes.textColorClose   = "FFFFFF">
					<cfset attributes.textColorOption  = "FFFFFF">
				<cfelseif get.code eq "HR">	
					<cfset background = "Images/Logos/Banners/HumanResourcesYellow.jpg">
					<cfset attributes.textColorLabel   = "FFFFFF">	
					<cfset attributes.textColorName    = "000000">
					<cfset attributes.textColorClose   = "000000">
					<cfset attributes.textColorOption  = "000000">	
				<cfelseif get.code eq "FI">	
					<cfset background = "Images/Logos/Banners/FinancialsGreen.jpg">
					<cfset attributes.textColorLabel   = "FFFFFF">
					<cfset attributes.textColorName    = "FFFFFF">
					<cfset attributes.textColorClose   = "FFFFFF">
					<cfset attributes.textColorOption  = "FFFFFF">
				<cfelseif get.code eq "PR">	
					<cfset background = "Images/Logos/Banners/ProgramRed.jpg">
					<cfset attributes.textColorLabel   = "FFFFFF">
					<cfset attributes.textColorName    = "FFFFFF">
					<cfset attributes.textColorClose   = "FFFFFF">
					<cfset attributes.textColorOption  = "FFFFFF">
				<cfelseif get.code eq "OP">	
					<cfset background = "Images/Logos/Banners/OperationsBlue.jpg">
					<cfset attributes.textColorLabel   = "FFFFFF">
					<cfset attributes.textColorName    = "FFFFFF">
					<cfset attributes.textColorClose   = "FFFFFF">
					<cfset attributes.textColorOption  = "FFFFFF">			
				<cfelse>
					<cfset background = "Images/Logos/Banners/OperationsBlue.jpg">
					<cfset attributes.textColorLabel   = "FFFFFF">
					<cfset attributes.textColorName    = "FFFFFF">
					<cfset attributes.textColorClose   = "FFFFFF">
					<cfset attributes.textColorOption  = "FFFFFF">
				</cfif>
				
			<cfelse>
				
				<cfset vTakeBackgroundColorCriteria = 1>
				
			</cfif>
		
		<cfelse>
			
			<cfset vTakeBackgroundColorCriteria = 1>
		
		</cfif>
		
	<cfelse>
		
		<cfset vTakeBackgroundColorCriteria = 1>
		
	</cfif>		
	
	<cfif vTakeBackgroundColorCriteria eq 1>
		
		<cfif attributes.background eq "gray">
			<cfset background = "Images/logos/Banners/AdministrationGray.jpg">	
			<cfset attributes.textColorLabel = "ffffff">
			<cfset attributes.textColorName = "ffffff">
			<cfset attributes.textColorClose = "ffffff">
			<cfset attributes.textColorOption = "000000">
		<cfelseif attributes.background eq "yellow">	
			<cfset background = "Images/logos/Banners/HumanResourcesYellow.jpg">
			<cfset attributes.textColorLabel = "523900">	
			<cfset attributes.textColorName = "523900">
			<cfset attributes.textColorClose = "523900">
			<cfset attributes.textColorOption = "000000">
		<cfelseif attributes.background eq "green">	
			<cfset background = "Images/logos/Banners/FinancialsGreen.jpg">
			<cfset attributes.textColorLabel = "FFFFFF">
			<cfset attributes.textColorName = "000000">
			<cfset attributes.textColorClose = "000000">
			<cfset attributes.textColorOption = "000000">
		<cfelseif attributes.background eq "red">	
			<cfset background = "Images/logos/Banners/ProgramRed.jpg">
			<cfset attributes.textColorLabel = "FFFFFF">
			<cfset attributes.textColorName = "FFFFFF">
			<cfset attributes.textColorClose = "FFFFFF">
			<cfset attributes.textColorOption = "FFFFFF">
		<cfelseif attributes.background eq "blue" or attributes.background eq "linesBlue">	
			<cfset background = "Images/logos/Banners/OperationsBlue.jpg">
			<cfset attributes.textColorLabel = "FFFFFF">
			<cfset attributes.textColorName = "FFFFFF">
			<cfset attributes.textColorClose = "FFFFFF">
			<cfset attributes.textColorOption = "FFFFFF">		
		<cfelse>
			<cfset background = "Images/logos/Banners/OperationsBlue.jpg">
			<cfset attributes.textColorLabel = "FFFFFF">
			<cfset attributes.textColorName = "FFFFFF">
			<cfset attributes.textColorClose = "FFFFFF">
			<cfset attributes.textColorOption = "FFFFFF">
		</cfif>		
		
	</cfif>
		
	<table width="100%" height="100%" border="0" bordercolor="black" cellspacing="0" cellpadding="0">
	<tr><td style="" valign="top">
		
	<table width="100%" height="100%" border="0" bordercolor="black" cellspacing="0" cellpadding="0" background="#SESSION.root#/#background#" 
		style="background-repeat:no-repeat; background-image:url(#SESSION.root#/#background#); background-position:left top; -webkit-background-size:100% 100%; -moz-background-size:100% 100%; -o-background-size:100% 100%; background-size:100% 100%; background-color:###attributes.backgroundColor#;">		
				
	  <tr>
		  <td valign="middle" style="height:#attributes.bannerheight#; min-height:#attributes.bannerheight#;">
		  		  		  	  
			  <table width="100%" cellspacing="0" cellpadding="0">
			  
				<tr>
					<cfif attributes.icon neq "">
						<td><img src="#SESSION.root#/#attributes.icon#" alt="" border="0"></td>
						<td>&nbsp;</td>
					</cfif>
				
					<td>						
						<table width="100%" cellspacing="0" cellpadding="0">
							<tr>
                                <td align="center" class="labelmedium drk-hover" style="background:##033F5D;width:32px;border-right:1px solid rgba(255,255,255,0.2);padding:10px 10px 10px 10px;height:55px;">
						   <img src="#session.root#/images/logos/menu/prosis-icon.png" style="cursor:pointer" height="24" width="24" title="Function" border="0" onclick="##">						 
						</td>
								<td class="labellarge fixlength" id="screentoplabel" style="font-size:18px;padding-left:20px;color:##FFFFFF;">
									#attributes.label#
								</td>
							</tr>
						</table> 
					</td>
				</tr>	  				  				  
			  
			  </table>
		  	  
		  </td>
		  
		  <cfset vPaddingOption = "">
		  <cfif attributes.option neq "">
		  	  <cfset vPaddingOption = "padding-top:5px;">
		  </cfif>
		  
		  <td align="right" valign="top" style="border:0px solid silver; #vPaddingOption#">
		  				
				<table align="right" border="0" cellspacing="0" cellpadding="0" class="formpadding">
								
				    <cfif attributes.user eq "Yes">
				
					<tr>
					
						<cfif attributes.option neq "">
						
							<td class="labelit fixlength" style="padding-top:11px;padding-right:10px; color:###attributes.textColorName#;">
								<span style="font-size:11px;">#attributes.option#</span>
							</td>
							
							<td style="padding-top:21px;padding-left:1px;padding-right:5px"><font color="###attributes.textColorClose#">|</font></td>	
						
						</cfif>	
					
						<td class="labelmedium drk-hover fixlength" style="border-left:1px solid rgba(255,255,255,0.2);border-right:1px solid rgba(255,255,255,0.2);padding:17px 18px;color:##FFFFFF;" align="right">
							#SESSION.first# #SESSION.last#
																											
						<cfif systemfunctionid neq "" && find(systemfunctionid,"-") gt 0> 
										
							<cfquery name="HelpTopic" 
								datasource="AppsSystem"
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT *
									FROM  HelpProjectTopic
								    WHERE SystemFunctionId = '#systemfunctionid#'			
							</cfquery>
														
							<cfif helptopic.recordcount gte "1">
						
								<td class="labelmedium drk-hover" align="center" style="border-left:1px solid rgba(255,255,255,0.2);border-right:1px solid rgba(255,255,255,0.2);padding:12px 18px;">	    																																			
									<cf_helpfile systemfunctionid="#systemfunctionid#" styleclass="labelmedium" color="###attributes.textColorClose#" Display="Icon" IconFile="logos/menu/help.png">																						
								</td>								
							
							</cfif>
							
							<cfif getAdministrator('*') eq "1">
							
								<td align="center" class="labelmedium drk-hover" style="width:32px;border-left:1px solid rgba(255,255,255,0.2);border-right:1px solid rgba(255,255,255,0.2);padding:12px 12px;">							
								   <img src="#session.root#/images/logos/menu/config.png" style="cursor:pointer" height="24" width="24" title="<cf_tl id='Configuration'>" border="0" onclick="supportconfig('#systemfunctionid#')">						     
								</td>
							
							</cfif>
																		
							<cfquery name="Parameter" 
							datasource="AppsInit">
								SELECT * 
								FROM Parameter
								WHERE HostName = '#CGI.HTTP_HOST#'
							</cfquery> 
							
							<cfif Parameter.SystemSupportPortalId neq "">
														
								<td  align="center" class="labelmedium drk-hover" style="width:32px;border-left:1px solid rgba(255,255,255,0.2);border-right:1px solid rgba(255,255,255,0.2);padding:12px 12px;">							
								   <img src="#session.root#/images/logos/menu/support.png" style="cursor:pointer" height="24" width="24" title="<cf_tl id='Submit Support Ticket'>" border="0" onclick="supportticket('#systemfunctionid#','','#url.mission#')">						     
								</td>
							
							</cfif>
							
						<cfelseif attributes.systemmodule neq "">
						
						<!--- can be removed --->
														
							<cfquery name="Parameter" 
							datasource="AppsInit">
								SELECT * 
								FROM Parameter
								WHERE HostName = '#CGI.HTTP_HOST#'
							</cfquery> 
							
							<cfif Parameter.SystemSupportPortalId neq "">
												
								<td  align="right" class="labelmedium drk-hover" style="width:32px;border-left:1px solid rgba(255,255,255,0.2);border-right:1px solid rgba(255,255,255,0.2);padding:12px 12px;">								
								   <img src="#session.root#/images/logos/menu/support.png" style="cursor:pointer" height="24" width="24" alt="" border="0" onclick="supportticket('','#attributes.systemmodule#','#url.mission#')">                                     
								</td>															
							
							</cfif>	
						
						</cfif>		
												
						<td style="border-left:1px solid rgba(255,255,255,0.2);border-right:1px solid rgba(255,255,255,0.2);padding:12px 12px;color:#attributes.textColorClose#;">
								    <cfif systemfunctionid neq "">
										<CF_uitooltip tooltip="This function is controlled by the menu framework">
										<img src="#session.root#/images/logos/menu/time.png" style="cursor:pointer" height="12" width="12" border="0">
										</cf_uitooltip>	
									<cfelseif Attributes.MenuAccess eq "Context">
										<CF_uitooltip tooltip="Access to this screen is granted contextual">
										<img src="#session.root#/images/logos/menu/context.png" style="cursor:pointer" height="12" width="12" border="0">
										</cf_uitooltip>	
									</cfif>
									<cfif Attributes.ValidateSession eq "Yes">
										<CF_uitooltip tooltip="Session validation is turned on and will alert you once the session is lost">
										<img src="#session.root#/images/logos/menu/connected.png" style="cursor:pointer" height="12" width="12" border="0">
										</cf_uitooltip>									
									</cfif>
                            </td>
															
						</td>		
							
						<td align="center" class="labelmedium drk-hover" style="width:32px;border-left:1px solid rgba(255,255,255,0.2);border-right:1px solid rgba(255,255,255,0.2);padding:12px 12px;">
						   <img src="#session.root#/images/logos/menu/close.png" style="cursor:pointer" height="24" width="24" title="Close" border="0" onclick="javascript:#attributes.close#">						 
						</td>
						
					</tr>
					</cfif>				
					
				</table>					
											
		  </td>		  
	  </tr>
	  
	</table>
	
	</td></tr>
	</table>	

</cfoutput>
	