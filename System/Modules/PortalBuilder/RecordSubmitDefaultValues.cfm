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
<cfset menuClassList = "Menu,Layout,Function">

<cfloop index="vMenuClass" list="#menuClassList#" delimiters=",">

	<!--- Set default values per class --->
	<cfset defaultOptions = "">
	
	<cfif vMenuClass eq "Menu">
	
		<cfset defaultOptions = "Home,FAQ">
		<cfif url.systemModule eq "PMobile">
			<cfset defaultOptions = "">
		</cfif>
		
	<cfelseif vMenuClass eq "Layout">
	
		<cfset defaultOptions = "Background,Banner,Footer,Header,Logo,BrandLogo,LogoDark,Widgets,Item,FavIcon">
		<cfif url.systemModule eq "PMobile">
			<cfset defaultOptions = "">
		</cfif>
		
	<cfelseif vMenuClass eq "Function">
	
		<cfset defaultOptions = "Logout,Login,ToggleHeader,Preferences,BeforeLogout,CustomCSS,AutohideMenu,Preferences,InitShowMenu,AutoIE8,CustomInformation,RequestAccess,ForgotPassword,LanguageTopMenu,ShowPublicPreferences,ShowPublicInformation,PreferencesPassword,Configurations,PreferencesFeatures,PreferencesAnnotations,PreferencesLDAPMailbox,InformationEntity,ShowPrivateInformation,ShowMenuInfo,ShowSupportMenu,OnLogin,OnFinishPreparation,ShowLanguageFlag,ForgotUsername,IconSet,ShowLoginOnInit,Clearances">
		<cfif url.systemModule eq "PMobile">
			<cfset defaultOptions = "CustomLogin">
		</cfif>
		
	</cfif>
	
	<cfset cntOption = 1>
	
	<cfloop index="defaultOption" list="#defaultOptions#" delimiters=",">

		<cfquery name="getDetail" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">		 
			 SELECT 	* 
			 FROM 		Ref_ModuleControl	 
			 WHERE		FunctionClass = '#url.contextFunctionName#'
			 AND		SystemModule = '#url.systemmodule#'
			 AND		MenuClass = '#vMenuClass#'
			 AND		FunctionName = '#defaultOption#'
		</cfquery>
		
		<cfset vFunctionId = "">
		
		<cfif getDetail.recordCount eq 0>
		
			<cfset vOperational = 1>
			
			<cfif (vMenuClass eq "Function" and defaultOption eq "ToggleHeader") 
				or (vMenuClass eq "Function" and defaultOption eq "Preferences")
				or (vMenuClass eq "Function" and defaultOption eq "RequestAccess")
				or (vMenuClass eq "Function" and defaultOption eq "ForgotPassword")
				or (vMenuClass eq "Function" and defaultOption eq "ForgotUsername")
				or (vMenuClass eq "Function" and defaultOption eq "LanguageTopMenu")
				or (vMenuClass eq "Function" and defaultOption eq "ShowSupportMenu")
				or (vMenuClass eq "Function" and defaultOption eq "ShowLoginOnInit")
				or (vMenuClass eq "Function" and defaultOption eq "Clearances")
				or (vMenuClass eq "Menu" and defaultOption eq "FAQ")>
				
					<cfset vOperational = 0>
				
			</cfif>

			<cfif url.systemModule eq "PMobile" and defaultOption eq "CustomLogin">
				<cfset vOperational = 0>
			</cfif>

			<cfset vDefaultPath = "Custom/Portal/#url.contextFunctionName#/">
			<cfif url.systemModule eq "PMobile">
				<cfset vDefaultPath = "Custom/MobileApps/#url.contextFunctionName#/">
			</cfif>
	
			<cf_AssignId>
			
			<cfset vFunctionId = rowguid>
			
			<cfquery name="Insert" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 INSERT INTO Ref_ModuleControl
				 	(
						SystemFunctionId,
						SystemModule,
						FunctionClass,
						MenuClass,
						FunctionName,				
						FunctionDirectory,	
						MenuOrder,			
						Operational,
						OfficerUserId,
						OfficerFirstName,
						OfficerLastName
					)
				VALUES
					(
						'#vFunctionId#',
						'#url.systemmodule#',
						'#url.contextFunctionName#',
						'#vMenuClass#',
						'#defaultOption#',
						'#vDefaultPath#',
						#cntOption#,
						#vOperational#,
						'#SESSION.acc#',
						'#SESSION.first#',
						'#SESSION.last#'
					)
			</cfquery>
			
			<cf_LanguageInput
				TableCode       = "Ref_ModuleControl" 
				Key1Value       = "#vFunctionId#"
				Key2Value       = "#url.mission#"
				Mode            = "Save"
				Name1           = "FunctionMemo"	
				Operational     = "1">
		
		</cfif>
		
		<cfset vFunctionId = getDetail.SystemFunctionId>
		
		<!--- SET FUNCTIONNAME THE SAME FOR ALL LANGUAGES --->
		<cfif trim(defaultOption) neq "" and trim(vFunctionId) neq "">
		
			<cfquery name="Insert" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 UPDATE Ref_ModuleControl_Language
				 SET 	FunctionName = '#defaultOption#'
				 WHERE	SystemFunctionId = '#vFunctionId#'
			</cfquery>
		
		</cfif>
		
		<cfset cntOption = cntOption + 1>
	
	</cfloop>
	

</cfloop>