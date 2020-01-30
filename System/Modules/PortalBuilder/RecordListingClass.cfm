<cfquery name="getDetail" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *
	 FROM       #client.lanPrefix#Ref_ModuleControl
	 WHERE		SystemModule = '#url.systemmodule#'
	 AND		FunctionClass = '#url.name#'
	 AND		MenuClass = '#url.class#'
	 ORDER BY MenuClass,MenuOrder,FunctionName
</cfquery>

<cfquery name="get" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *
	 FROM       #client.lanPrefix#Ref_ModuleControl	 
	 WHERE		SystemModule = '#url.systemmodule#'
	 AND		FunctionClass = '#url.functionClass#'
	 AND		FunctionName = '#url.name#'
</cfquery>


<table width="100%" align="center" cellspacing="0" class="formpadding">	
	<cfif getDetail.recordCount eq 0>
	<tr>
		<td align="center" colspan="5" class="labellarge">								
		<font color="808080">
			<cfoutput>
			No #lcase(url.class)# lines recorded.
			</cfoutput>
		</font>
		</td>
	</tr>
	</cfif>		
	<cfoutput query="getDetail">
	
		<cfset vShowThisRow = false>
		<cfif ucase(get.functionTarget) eq "HTML5">
			
			<cfif menuClass eq "layout">
				<cfif FindNoCase("logo",functionName) neq 0>
					<cfset vShowThisRow = true>
				<cfelseif FindNoCase("icon",functionName) neq 0>
					<cfset vShowThisRow = true>
				</cfif>
			<cfelseif menuClass eq "function">
				<cfif functionName eq "BeforeLogout" 
					or functionName eq "CustomCSS" 
					or functionName eq "AutohideMenu"
					or functionName eq "Preferences"
					or functionName eq "InitShowMenu"
					or functionName eq "AutoIE8"
					or functionName eq "CustomInformation"
					or functionName eq "RequestAccess"
					or functionName eq "ForgotPassword"
					or functionName eq "LanguageTopMenu"
					or functionName eq "ShowPublicPreferences"
					or functionName eq "ShowPublicInformation"
					or functionName eq "PreferencesPassword"
					or functionName eq "Configurations"
					or functionName eq "PreferencesFeatures"
					or functionName eq "PreferencesAnnotations"
					or functionName eq "PreferencesLDAPMailbox"
					or functionName eq "InformationEntity"
					or functionName eq "ShowPrivateInformation"
					or functionName eq "ShowMenuInfo"
					or functionName eq "ShowSupportMenu"
					or functionName eq "OnLogin"
					or functionName eq "OnFinishPreparation"
					or functionName eq "ShowLanguageFlag"
					or functionName eq "ForgotUsername"
					or functionName eq "IconSet"
					or functionName eq "ShowLoginOnInit">
						<cfset vShowThisRow = true>
				</cfif>
				<cfif functionName eq "CustomLogin" and systemModule eq "PMobile">
					<cfset vShowThisRow = true>
				</cfif>
			<cfelse>
				<cfset vShowThisRow = true>
			</cfif>
			
		<cfelse>
			<cfset vShowThisRow = true>
		</cfif>
		
		<cfif vShowThisRow>
		
			<cfset vBGColor = "">
			<cfif operational eq 0>
				<cfset vBGColor = "##FFC4C5">
			</cfif>
								
			<tr class="navigation_row" bgcolor="#vBGColor#">							
				<td class="labelmedium" align="center" width="2%" style="padding-right:5px;"><cfif lcase(MenuClass) neq "layout">#MenuOrder#</cfif></td>
				<td class="labelmedium" width="18%">#FunctionName#</td>
				<td class="labelmedium" colspan="2">
					<cfif trim(lcase(url.systemmodule)) eq "pmobile">
						<cfif trim(FunctionDirectory) eq "" and trim(FunctionPath) eq "">
							[ <cf_tl id="Submenu"> ]
						<cfelse>
							#FunctionDirectory##FunctionPath#
						</cfif>
					<cfelse>
						#FunctionDirectory##FunctionPath#
					</cfif>
				</td>
				<td class="labelmedium" align="center" width="35">
					<table width="100%" align="center">
						<tr>
							<td class="labelit" align="center">
								<cf_img icon="edit"	onClick="javascript: addportalline('#SystemFunctionId#','#url.name#','#MenuClass#','#url.systemmodule#','#url.functionClass#');">
							</td>
							<cfif lcase(MenuClass) neq "layout">
							<td class="labelit" align="center">
								<cf_img icon="delete" onClick="if (confirm('Do you want to remove this record ?')) { purgeportalline('#SystemFunctionId#','#url.name#','#MenuClass#','#url.systemmodule#','#url.functionClass#'); }">
							</td>
							</cfif>
						</tr>
					</table>
				</td>
			</tr>
			<cfif FunctionCondition neq "">
									
			<tr>
				<td class="labelmedium"></td>
				<td class="labelmedium"></td>
				<td class="labelmedium" colspan="2">
				<font color="808080">#FunctionCondition#</font>
				</td>
			</tr>
			
			</cfif>
			
		</cfif>
	</cfoutput>
</table>

<cfset AjaxOnLoad("doHighlight")>