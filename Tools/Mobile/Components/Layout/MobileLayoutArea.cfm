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
<cfparam name="attributes.appId"				default="">
<cfparam name="attributes.position"				default="">
<cfparam name="attributes.id"					default="mainContainer">
<cfparam name="attributes.prosisMenu"			default="yes">
<cfparam name="attributes.showRightLink"		default="no">
<cfparam name="attributes.showPrint"			default="no">
<cfparam name="attributes.showAppLogo"			default="yes">
<cfparam name="attributes.showBrandLogo"		default="yes">
<cfparam name="attributes.showUserInfo"			default="yes">
<cfparam name="attributes.textRightLink"		default="Context Menu">
<cfparam name="attributes.footerRightText"		default="Promisan, #year(now())#">
<cfparam name="attributes.applicationLogo"		default="">
<cfparam name="attributes.brandLogo"		    default="">
<cfparam name="attributes.title"				default="">

<cfset rootMobileTag = getbasetagdata("CF_MOBILE")>
<cfset attributes.appId = rootMobileTag.attributes.appId>
<cfset vAttrAllowLogout = lcase(trim(rootMobileTag.attributes.allowLogout))>
<cfset vPosition = lcase(trim(attributes.position))>

<cfset vApplicationDefTable = "Ref_ModuleControl">

<cfset IsAnonimousContext = true>
<cfif isDefined("session.root") AND isDefined("session.rootdocumentpath") AND isDefined("session.acc") AND isDefined("session.first") AND isDefined("session.last")>
	<cfset IsAnonimousContext = false>
</cfif>

<cfif not IsAnonimousContext>
	<cfif trim(attributes.applicationLogo) eq "">
		<cfset attributes.applicationLogo = "#session.root#/images/mobileApps/MobileApplicationLogo.png">
	</cfif>
	<cfif trim(attributes.brandLogo) eq "">
		<cfset attributes.brandLogo = "#session.root#/images/mobileApps/BrandLogo.png">
	</cfif>
</cfif>

<cfset vAllowLogout = "">
<cfif trim(vAttrAllowLogout) eq "yes" or trim(vAttrAllowLogout) eq "1" or trim(vAttrAllowLogout) eq "true">
	<cfset vAllowLogout = "true">
<cfelse>
	<cfset vAllowLogout = "false">
</cfif>

<cfquery name="getApplication"
		datasource="AppsSystem">
	SELECT  *
	FROM    #vApplicationDefTable#
	WHERE	SystemModule = 'PMobile'
	AND		FunctionClass = 'PMobile'
	AND		FunctionName = '#attributes.appId#'
AND		Operational = 1
</cfquery>

<cfif trim(attributes.title) eq "">
	<cfif trim(getApplication.functionMemo) eq "">
		<cfset attributes.title = getApplication.functionName>
		<cfif trim(attributes.title) eq "">
			<cfset attributes.title = attributes.appId>
		</cfif>
	<cfelse>
		<cfset attributes.title = getApplication.functionMemo>
	</cfif>
</cfif>

<cfif thisTag.ExecutionMode is "start">

	<cfswitch expression="#vPosition#">

		<cfcase value="header">

			<!-- Header -->
			<div id="header">
				<div class="color-line"></div>

			<nav role="navigation">
				<div class="header-link hide-menu"><i class="fa fa-bars"></i></div>
			<cfoutput>
				<cfset vLeftBorder = "">
				<cfif trim(lcase(attributes.showAppLogo)) eq "1" or trim(lcase(attributes.showAppLogo)) eq "yes">
						<img src="#attributes.applicationLogo#" style="height:40px; width:auto; margin-top:8px; float:left; padding-right:15px;">
					<cfset vLeftBorder = "padding-left:15px; border-left:1px solid ##ccc;">
				</cfif>
					<h2 class="hidden-xs" style="#vLeftBorder# float:left;">
					#attributes.Title#
					</h2>
			</cfoutput>
			<div class="navbar-right">
			<ul class="nav navbar-nav no-borders">
			<cfif trim(lcase(attributes.showPrint)) eq "1" or trim(lcase(attributes.showPrint)) eq "yes">
					<li>
					<cf_tl id="Print" var="1">
					<cfoutput>
							<a href="##" id="printButton" title="#lt_text#" onclick="___prosisMobileWebPrint('##mainContainer', true, '', function(){})">
							<i class="pe-7s-print"></i>
						</a>
					</cfoutput>
					</li>
			</cfif>
			<cfif trim(lcase(attributes.showRightLink)) eq "1" or trim(lcase(attributes.showRightLink)) eq "yes">
					<li>
						<a href="#" id="sidebar" class="right-sidebar-toggle">
							<i class="pe-7s-upload pe-7s-left-arrow"></i>
						</a>
					</li>
			</cfif>
			<cfif not IsAnonimousContext>
				<cfif vAllowLogout>
						<li class="dropdown">
						<cfoutput>
							<a href="javascript:ptoken.navigate('#session.root#/portal/mobile/userpassword.cfm','mainContainer')">
							<i class="pe-7s-key pe-rotate-90"></i>
						</a>
								<a href="#session.root#/portal/mobile/logoff.cfm?appId=#attributes.appId#">
							<i class="pe-7s-upload pe-rotate-90"></i>
						</a>
						</cfoutput>
						</li>
				</cfif>
			</cfif>
			</ul>
			</div>
				<h2 id="___prosisMobileSubTitle" style="float:right; padding-right:15px;"></h2>
			</nav>
			</div>

		</cfcase>

		<cfcase value="left">

			<aside id="menu">
			<div id="navigation">

			<cfif trim(lcase(attributes.showBrandLogo)) eq "1" or trim(lcase(attributes.showBrandLogo)) eq "yes">
					<!-- Navigation -->
				<div id="logo" class="light-version" onclick="window.location.reload();" style="cursor:pointer;text-align:center;display:block;padding:0;height:auto;">
				<cfoutput><img src="#attributes.brandLogo#" style="width:150px; height:auto;"></cfoutput>
				</div>
			</cfif>

			<cfif not IsAnonimousContext>

				<cfif trim(lcase(attributes.showUserInfo)) eq "1" or trim(lcase(attributes.showUserInfo)) eq "yes">
						<div class="profile-picture" style="clear:both;">
						<a>
						<cfoutput>
							<cfif FileExists("#session.rootdocumentpath#\EmployeePhoto\#session.acc#.jpg")>
								<cfset vUserPhotoURL = "#session.rootdocument#/EmployeePhoto/#session.acc#.jpg">
							<cfelse>
								<cfset vUserPhotoURL = "#session.root#/images/user2.png">
							</cfif>
								<img src="#vUserPhotoURL#?ts=#getTickCount()#" class="m-b" alt="logo" style="height:50px;border-radius:6px;border: 3px solid ##033F5D;">
						</cfoutput>
						</a>

						<div class="stats-label text-color">
						<div class="dropdown">
						<a class="dropdown-toggle" data-toggle="dropdown">
						<div class="font-extra-bold font-uppercase">
						<cfoutput>
													#session.first# #session.last#
												</cfoutput>
						</div>
						<small class="text-muted"><cfoutput>#session.acc#</cfoutput><cfif vAllowLogout> <b class="caret"></b></cfif></small>
					</a>
						<cfif vAllowLogout>
								<ul class="dropdown-menu animated fadeInRight m-t-xs">
								<cfif trim(lcase(attributes.showRightLink)) eq "1" or trim(lcase(attributes.showRightLink)) eq "yes">
									<cfoutput>
										<li class="right-sidebar-toggle hide-menu"><a href="##">#attributes.textRightLink#</a></li>
										<li class="divider"></li>
									</cfoutput>
								</cfif>
								<cfoutput>
										<li><a href="#session.root#/portal/mobile/logoff.cfm?appId=#attributes.appId#&ts=#getTickCount()#">Logout</a></li>
								</cfoutput>
								</ul>
						</cfif>
						</div>
						</div>
						</div>
				</cfif>

				<cfif trim(lcase(attributes.prosisMenu)) eq "1" or trim(lcase(attributes.prosisMenu)) eq "yes">
					<cf_mobileProsisMenu appId="#attributes.appId#">
				</cfif>
			<cfelse>
					<div class="profile-picture" style="height:0px; margin:0px; padding:0px; clear:both;"></div>
			</cfif>

		</cfcase>

		<cfcase value="right">
				<!-- Right sidebar -->
			<div id="right-sidebar" class="animated fadeInRight">

			<div class="p-m">
				<button id="sidebar-close" class="right-sidebar-toggle sidebar-button btn btn-default m-b-md"><i class="pe pe-7s-close"></i>
				</button>
		</cfcase>

		<cfcase value="center">
			<div id="wrapper">
		</cfcase>

		<cfcase value="container">
			<cfoutput>
				<div id="#attributes.id#" class="content animate-panel">
			</cfoutput>
		</cfcase>

		<cfcase value="footer">
			<cfoutput>
					<footer class="footer">
					<span class="pull-right">
					#attributes.footerRightText#
					</span>
					#getApplication.FunctionMemo#
					</footer>
			</cfoutput>
		</cfcase>

		<cfdefaultcase></cfdefaultcase>

	</cfswitch>

<cfelse>

	<cfswitch expression="#vPosition#">

		<cfcase value="header"></cfcase>

		<cfcase value="left">
			</div>
			</aside>
		</cfcase>

		<cfcase value="right">
			</div>
			</div>
		</cfcase>

		<cfcase value="center">
			</div>
		</cfcase>

		<cfcase value="container">
			</div>
		</cfcase>

		<cfcase value="footer"></cfcase>

		<cfdefaultcase></cfdefaultcase>

	</cfswitch>

</cfif>