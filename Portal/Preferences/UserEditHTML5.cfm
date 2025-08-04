<!--
    Copyright © 2025 Promisan

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

<cfparam name="url.webapp" 				default="">
<cfparam name="url.showChangePassword" 	default="0">
<cfparam name="url.showFeatures" 		default="1">
<cfparam name="url.showAnnotations" 	default="1">
<cfparam name="url.showLDAPMailbox"		default="1">

<cfquery name="Standard" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemModule   = 'SelfService'
	AND    FunctionClass  = '#url.webapp#'
	AND    MenuClass      = 'function'	
	AND    FunctionName   = 'standards'	
	AND    Operational    = 1
	ORDER BY FunctionName
</cfquery>

<cf_screentop html="No" jquery="Yes">

<cfinclude template="UserEditScript.cfm">
<cf_textareascript>

<cf_listingscript> 
<cf_menuscript>

<cfajaximport tags="CFFORM">

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   UserNames 
	WHERE  Account = '#SESSION.acc#'
</cfquery>

<cfquery name="AccountGroup" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_AccountGroup 
	WHERE  AccountGroup = '#Get.AccountGroup#'
</cfquery>

<cfparam name="url.iconSet"	default="Gray">
<cfset baseImageDirectory = "HTML5/#url.IconSet#">
<cfset imageDirectory     = "#baseImageDirectory#/Preferences">

<cfset fullBaseImageDirectory = "#SESSION.root#/Images/#baseImageDirectory#">
<cfset fullImageDirectory = "#SESSION.root#/Images/#imageDirectory#">

<cfoutput>
	<table height="1%" width="100%" cellspacing="0" cellpadding="0">
	
			<tr class="hide"><td id="process"></td></tr>
			
			<tr>
			<td colspan="1" class="labellarge" valign="top">
				<table>
					<tr>
						<td width="1%" style="padding-right:5px;">
							<img src="#fullBaseImageDirectory#/preferences.png" height="70" align="absmiddle" alt="" border="0">
						</td>
						<td>
							<table cellpadding="0" cellspacing="0">
								<tr>
									<td class="labellarge" style="font-size:25px;">
										<cf_tl id="My Preferences" var="1"> 
										<span style="font-weight: 200;text-transform: capitalize;color: ##3498db;">#lcase(lt_text)#</span>
									</td>
								</tr>
								<tr>
									<td class="labelit">
										<span style="color: ##52565B;">#ucase(session.acc)#
									</td>
								</tr>
							</table>
							
						</td>
					</tr>
				</table>
			</td>
			<td colspan="2"></td>	
			<tr><td height="2"></td></tr>
			<tr><td class="line"></td></tr>
		</tr>
	</table>
</cfoutput>

<cf_divScroll height="100%" width="99%" overflowy="auto" overflowx="auto">

	<table height="100%" width="100%" cellspacing="0" cellpadding="0" align="center"> 
	
	<tr>
		<td valign="top" height="100%">
			
			<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0" align="center" style="margin:0;">
		
				<tr>
							
					<td valign="top" style="height:100%; width:120px; padding:0; display: block;border-right: 1px solid #eeeeee!important;">
						<div style="height:92%; width:100%;">
						
							<table>
						
								<tr class="sit-mnu-left">
									<cfset ht = "52">
									<cfset wd = "52">
										
									<cfset itm = 0>
									
									<cfset itm = itm + 1>
									<cf_tl id="Identification" var="1">
									
									<cf_menutab item       = "#itm#" 
									        targetitem = "1"
									        iconsrc    = "#imageDirectory#/Identification.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											class      = "highlight"
											name       = "#lt_text#"
											source     = "javascript:pref('UserIdentification.cfm?showLDAPMailbox=#url.showLDAPMailbox#')">		
								</tr>		
										
								<cfif standard.recordcount gte "1">
								<tr class="sit-mnu-left">
									<cfset itm = itm + 1>	
									<cf_tl id="Default Criteria" var="1">
									<cf_menutab item       = "#itm#" 
									        targetitem = "1"
									        iconsrc    = "#imageDirectory#/Criteria.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 				
											name       = "#lt_text#"
											source     = "../../#standard.functiondirectory#/#standard.functionpath#?#standard.functionCondition#">		
								</tr>		
								</cfif>			
								
								<tr class="sit-mnu-left">
									<cfset itm = itm + 1>
									<cf_tl id="Signature" var="1">			
									<cf_menutab item       = "#itm#" 
									        targetitem = "1"
									        iconsrc    = "#imageDirectory#/Signature.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											name       = "#lt_text#"
											source     = "javascript:pref('UserSignature.cfm')">	
								</tr>
								
								<tr class="sit-mnu-left">
									<cfset itm = itm + 1>
									<cf_tl id="Mail Signature" var="1">			
									<cf_menutab item       = "#itm#" 
									        targetitem = "1"
									        iconsrc    = "#imageDirectory#/Mail.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											name       = "#lt_text#"
											source     = "javascript:pref('UserMail.cfm')">	
								</tr>
								
								<cfif url.showFeatures eq 1>
								<tr class="sit-mnu-left">
									<cfset itm = itm + 1>			
									<cf_tl id="Features" var="1">
									
									<cf_menutab item       = "#itm#" 
									        targetitem = "1"
									        iconsrc    = "#imageDirectory#/Features.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											name       = "#lt_text#"
											source     = "javascript:pref('UserPresentation.cfm')">		
								</tr>	
								</cfif>
								
								<cfif url.showAnnotations eq 1>
								<tr class="sit-mnu-left">
									<cfset itm = itm + 1>			
									<cf_tl id="Annotation" var="1">
											
									<cf_menutab item       = "#itm#" 
									        targetitem = "1"
									        iconsrc    = "#imageDirectory#/Annotation.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											name       = "#lt_text#"
											source     = "javascript:pref('UserAnnotation.cfm')">		
								</tr>
								</cfif>
								
								<cfif url.showChangePassword eq 0>
								<tr class="sit-mnu-left">
									<cfset itm = itm + 1>
									<cf_tl id="Password&nbsp;and&nbsp;roles" var="1">
									 			
									<cf_menutab item       = "#itm#" 
									        targetitem = "1"
									        iconsrc    = "#imageDirectory#/Password.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											name       = "#lt_text#"
											source     = "javascript:pref('UserPassword.cfm')">			
								</tr>
								<cfelse>
								<tr class="sit-mnu-left">
									<cfset itm = itm + 1>
									<cf_tl id="Change Password" var="1">
									 			
									<cf_menutab item       = "#itm#" 
									        targetitem = "1"
									        iconsrc    = "#imageDirectory#/Password.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											name       = "#lt_text#"
											source     = "javascript:pref('#SESSION.root#/Portal/SelfService/SetInitPassword.cfm?window=no&showPicture=no&showBack=no&id=ajax&portalid=#url.webapp#')">			
								</tr>
								</cfif>
								
										
								<cfif url.webapp eq "">	
								
								<tr class="sit-mnu-left">	
									<cfset itm = itm + 1>
									<cf_tl id="Reports" var="1">
												
									<cf_menutab item       = "#itm#" 
									        targetitem = "1"
									        iconsrc    = "#imageDirectory#/Report.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											name       = "#lt_text#"
											source     = "javascript:pref('ListingReport.cfm')">		
								</tr>										
								
								<tr class="sit-mnu-left">	
									<cfset itm = itm + 1>
									<cf_tl id="Mail" var="1">			
									
									<cf_menutab item       = "#itm#" 
									        targetitem = "1"
									        iconsrc    = "#imageDirectory#/Mail.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 				
											name       = "#lt_text#"
											source     = "javascript:pref('ListingMail.cfm')">		
								</tr>		
								</cfif>								
							
							</table>
							
						</div>
					
					</td>
					
					
						
					<td valign="top" height="100%" width="90%" style="padding-left:20px;"> 
					 						
						<table width="100%" height="100%">							
							<cf_menucontainer item="1" class="regular">														   
							   <cf_securediv bind="url:UserIdentification.cfm?showLDAPMailbox=#url.showLDAPMailbox#">
							</cf_menucontainer>							
						</table>
						
					</td>
				
				</tr>
			
			</table>
			
		</td>
	</tr>
	
	</table>	

</cf_divScroll>

