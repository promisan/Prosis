
<cfparam name="url.mission" default="">

<cfquery name="Line"
		datasource="AppsSystem"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
	SELECT L.*
	FROM   Ref_ModuleControl L
	WHERE  SystemFunctionId = '#URL.ID#'
</cfquery>

<!--- action="RecordSubmit.cfm?ID=#URL.ID#&mission=#url.mission#" --->

<cfform method="POST" target="saveform" name="entry">

	<table width="94%" align="center" class="formpadding">

		<tr><td style="height:3"></td></tr>

	<cfif SESSION.isAdministrator eq "No">

		<cfquery name="Module"
				datasource="AppsSystem"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT DISTINCT
				S.SystemModule,
				S.Description,
				S.Hint,
				S.MenuTemplate,
				S.TemplateRoot,
				S.MenuIcon,
				S.MenuOrder,
				S.Operational,
				S.EnableReportDefault,
				S.ShowMenuAsList,
				S.RoleOwner,
				S.LicenseId,
				S.Created
				FROM  Ref_SystemModule S,
				Organization.dbo.OrganizationAuthorization A
				WHERE A.ClassParameter = S.RoleOwner
				AND   A.UserAccount = '#SESSION.acc#'
			AND   A.Role = 'AdminSystem'
			ORDER BY menuOrder
		</cfquery>

	<cfelse>

		<cfquery name="Module"
				datasource="AppsSystem"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT   DISTINCT
				S.SystemModule,
				S.Description,
				S.Hint,
				S.MenuTemplate,
				S.TemplateRoot,
				S.MenuIcon,
				S.MenuOrder,
				S.Operational,
				S.EnableReportDefault,
				S.ShowMenuAsList,
				S.RoleOwner,
				S.LicenseId,
				S.Created
				FROM     Ref_SystemModule S
				ORDER BY menuOrder
		</cfquery>

	</cfif>

	<TR  class="labelmedium2" style="height:27px">
		<td width="130"><cf_tl id="Module">:</td>
	<TD width="80%">
	<cfoutput>
		#Line.SystemModule#
		</TD>
	</cfoutput>
	</TR>

	<TR class="labelmedium2" style="height:27px">
		<td><cf_tl id="Function class">:</td>
	<TD>
	<cfoutput>
		#Line.FunctionClass#
		</TD>
	</cfoutput>
	</TR>

	<cfif Line.FunctionClass eq "SelfService">
			<TR class="labelmedium2">
				<td  style="height:23"><cf_tl id="Background image">:</td>
			<TD>
			<cfoutput>
					<input type="text"
						   name="FunctionBackground"
						   id="FunctionBackground"
							value="#Line.FunctionBackground#"
						   size="80"
						   maxlength="80"
						   class="regularxl"
						   visible="Yes"
						   enabled="Yes">
			</cfoutput>
			</TD>
			</tr>
	</cfif>

	<cfif Line.FunctionClass eq "SelfService">
			<TR class="labelmedium2">
				<td style="height:23"><cf_tl id="Enforce Host">:</td>
			<TD>
			<cfoutput>

		    <cf_UIToolTip tooltip="Enter a valid host name like: <b>travelclaim</b> to redirect users to the preferred (virtual) server. <br>Leave blank if not required">
				<cfinput type="text"
						name="FunctionHost"
						value="#Line.FunctionHost#"
						size="20"
						maxlength="20"
						class="regularxl"
						visible="Yes"
						enabled="Yes">
			</cf_UIToolTip>

		 </cfoutput>
			</TD>
			</tr>
	</cfif>

	<TR class="labelmedium2">
		<td style="height:24"><cf_tl id="Menu class">:</td>
	<TD>

	<table><tr><td>
	<cfoutput>
		<cfif Line.MenuClass eq "Builder">
			<cfinput type="Text" name="MenuClass" value="#Line.MenuClass#" message="Please enter a menu class" validate="noblanks" required="Yes" visible="Yes" size="20" maxlength="20" class="regularxl">
		<cfelse>
			<cfinput type="Text" name="MenuClass" value="#Line.MenuClass#" message="Please enter a menu class" validate="noblanks" required="Yes" visible="Yes" size="20" maxlength="20" class="regularxl">
		</cfif>
		</td>

			<td style="padding-left:7px" class="labelmedium">
				Main menu:
			</td>
		<td style="padding-left:6px">
				<input type="checkbox" class="radiol" name="MainMenuItem" value="1" <cfif Line.MainMenuItem eq "1">checked</cfif>>
	</td>

	</tr></table>
	</TD>

	</cfoutput>
	</TR>

	<TR class="labelmedium2">
		<TD style="height:24"><cf_tl id="Menu Name">:</TD>

	<td>

	<cfoutput>
			<input type="hidden" name="FunctionName" id="FunctionName" value="#Line.FunctionName#" size="50" maxlength="50" class="disabled">
	</cfoutput>

	<table cellspacing="0" cellpadding="0">

	<cf_LanguageInput
				TableCode       = "Ref_ModuleControl"
				Mode            = "Edit"
				Name            = "FunctionName"
				Key1Value       = "#Line.SystemFunctionId#"
				Key2Value       = "#url.mission#"
				Type            = "Input"
				Required        = "No"
				Message         = ""
				MaxLength       = "80"
				Size            = "80"
				Class           = "regularxl"
				Operational     = "1"
				Label           = "Yes">

	</table>

	</td>

	</tr>

	<TR class="labelmedium2">
		<td style="height:36">Menu Subtitle:</td>
	<TD>

	<cfoutput>
			<input type="hidden" name="FunctionMemo" id="FunctionMemo" value="#Line.FunctionMemo#" size="80" maxlength="80" class="disabled">
	</cfoutput>

		<table cellspacing="0" cellpadding="0">

		<cf_LanguageInput
				TableCode       = "Ref_ModuleControl"
				Mode            = "Edit"
				Name            = "FunctionMemo"
				Key1Value       = "#Line.SystemFunctionId#"
				Key2Value       = "#url.mission#"
				Type            = "Input"
				Required        = "No"
				Message         = ""
				MaxLength       = "100"
				Size            = "90"
				Class           = "regularxl"
				Operational     = "1"
				Label           = "Yes">

		</table>

<!---
<cfoutput>
    <textarea style="width:98%" rows="2" name="FunctionMemo" class="regular">#Line.FunctionMemo#</textarea> </TD>
</cfoutput>
--->
	</TR>

	<TR class="labelmedium2">
		<TD style="height:24">Relative order:</TD>
	<TD>
	<cfinput type="Text" name="MenuOrder" value="#Line.MenuOrder#" message="Please enter a valid integer" validate="integer" required="Yes" size="1" maxlength="3" style="text-align:center;" class="regularxl">
	</td>

	<tr class="labelmedium2">
		<TD style="height:24">Menu Icon:</TD>
	<TD>

	<table cellspacing="0" cellpadding="0">
	<tr><td style="height:40px">

	<cfquery name="Icon"
			datasource="AppsSystem"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT DISTINCT FunctionIcon
			FROM  Ref_ModuleControl S
			WHERE     (FunctionIcon > '')
	</cfquery>

	<cfoutput>
			<select name="FunctionIcon" id="FunctionIcon" class="regularxxl"
					onChange="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/SubmenuImages.cfm?functionicon='+this.value,'showicon')">

			<option value="Main"    selected>Default</option>
				<option value="Report"   <cfif Line.FunctionIcon eq "Report">selected</cfif>>Report</option>
				<option value="DataSet"  <cfif Line.FunctionIcon eq "Dataset">selected</cfif>>Dataset</option>
				<option value="Monitor"  <cfif Line.FunctionIcon eq "Monitor">selected</cfif>>Monitor</option>
				<option value="Schedule" <cfif Line.FunctionIcon eq "Schedule">selected</cfif>>Schedule</option>
				<option value="List"     <cfif Line.FunctionIcon eq "List">selected</cfif>>List</option>
				<option value="Log"      <cfif Line.FunctionIcon eq "Log">selected</cfif>>Log</option>
				<option value="Audit"    <cfif Line.FunctionIcon eq "Audit">selected</cfif>>Audit</option>
				<option value="Workflow" <cfif Line.FunctionIcon eq "Workflow">selected</cfif>>Workflow</option>
				<option value="Tree"     <cfif Line.FunctionIcon eq "Tree">selected</cfif>>Tree</option>
				<option value="HowTo"     <cfif Line.FunctionIcon eq "HowTo">selected</cfif>>Manual</option>

<!---
<cfloop query="Icon">
 <option value="#FunctionIcon#" <cfif Line.FunctionIcon eq FunctionIcon> SELECTED</cfif>>#FunctionIcon#</option>
</cfloop>
--->

			</select>
	</cfoutput>

	</td>
		<td>&nbsp;</td>
	<td style="border: 0px solid Silver;">
	<cf_securediv bind="url:#SESSION.root#/tools/SubmenuImages.cfm?functionicon=#line.functionicon#" id="showicon">
	</td>
	</tr>

	</table>
	</TD>
	</TR>

	<TR class="labelmedium2">
		<td valign="top" style="padding-top:3px;height:38">Memo:</td>
	<TD>

	<cfoutput>
		<textarea style="padding:3px;width:94%;height:45;font-size:14px;padding:3px;border-radius:3px" name="FunctionModuleMemo" class="regular" >#Line.FunctionMemo#</textarea> </TD>
	</cfoutput>

	</TR>

	<cfif Line.ScreenWidth neq "">

		<TR class="labelmedium2">
			<td align="right" style="height:24">Dialog width:</td>
		<TD>
		<cfoutput>
			<cfinput type="Text"
				name="ScreenWidth"
				value="#Line.ScreenWidth#"
				validate="integer"
				required="No"
				visible="Yes"
				enabled="Yes"
				size="60"
				maxlength="70"
				class="regularxl"></TD>
		</cfoutput>
		</TR>

		<TR class="labelmedium2">
			<td align="right" style="height:24">Dialog height:</td>
		<TD>
		<cfoutput>
			<cfinput type="Text"
				name="ScreenHeight"
				value="#Line.ScreenHeight#"
				validate="integer"
				required="No"
				visible="Yes"
				enabled="Yes"
				size="60"
				maxlength="70"
				class="regularxl">
			</TD>
		</cfoutput>
		</TR>

	</cfif>

	<cfif Line.ScriptName eq "">

			<TR class="labelmedium2">
				<td valign="top" style="padding-top:4px" height="22">Launch Template:</td>
			<td>

			<table cellspacing="0" cellpadding="0">

			<cfif Line.FunctionClass eq "Search">
					<tr class="labelmedium">
						<td>Visible only on Server:</td>
					<td style="padding:1px">

					<cfquery name="AppServer"
							datasource="AppsInit"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
							SELECT DISTINCT ApplicationServer
							FROM Parameter
					</cfquery>

					<select name="ApplicationServer" class="regularxl" id="ApplicationServer">
						<option value="">Any</option>
					<cfoutput query="AppServer">
						<option value="#ApplicationServer#" <cfif Line.Applicationserver eq applicationserver>selected</cfif>> #ApplicationServer#
							</cfoutput>
					</select>

					</td>

					</tr>
			</cfif>

			<cfif Line.FunctionClass neq "SelfService">
					<TR class="labelmedium2">
						<td>Host:</td>

					<TD>

					<table cellspacing="0" cellpadding="0">
					<tr class="labelmedium2"><td style="padding:1px">
							<input type="radio" class="radiol" name="HostSelect" id="HostSelect" value="0" <cfif Line.FunctionHost eq "">checked</cfif> onclick="document.getElementById('host').className='hide'">
				</td><td style="padding:1px">Default</td>
					<td>&nbsp;</td>
				<td style="padding:1px">
						<input type="radio" class="radiol" name="HostSelect" id="HostSelect" value="1" <cfif Line.FunctionHost neq "">checked</cfif> onclick="document.getElementById('host').className='regular'">
				</td><td style="padding:1px">Dedicated</td>
					<td style="padding:1px">&nbsp;</td>

					<cfif Line.FunctionHost eq "">
						<cfset cl = "hide">
					<cfelse>
						<cfset cl = "regular">
					</cfif>
					<td id="host" class="<cfoutput>#cl#</cfoutput>" style="padding:1px">
					<cfoutput>
							<input type="text" name="FunctionHost" id="FunctionHost" value="#Line.FunctionHost#" size="50" maxlength="50" class="regular">
					</cfoutput>
						example : https://securemanual/
					</td>
					</tr>
					</table>

					</td>

					</TR>
			</cfif>

			<cfif Line.FunctionPath eq "Listing/Inquiry.cfm">
				<cfset read = "readonly">
				<cfset cl = "disabled regularxl">
			<cfelse>
				<cfset read = "">
				<cfset cl = "regularxl">
			</cfif>

			<TR class="labelmedium2">
				<td style="padding:1px;padding-right:10px">Directory:</td>
			<TD style="padding:1px">
			<cfoutput>
				<input type="text" #read# style="height:25px" name="FunctionDirectory" id="FunctionDirectory" value="#Line.FunctionDirectory#" size="80" maxlength="80" class="#cl#"></TD>
			</cfoutput>
			</TR>

			<TR class="labelmedium2">
				<td style="padding:1px">Path:</td>
			<TD style="padding:1px">
			<cfoutput>
				<input type="text" #read# style="height:25px" name="FunctionPath" id="FunctionPath" value="#Line.FunctionPath#" size="80" maxlength="80" class="#cl#"></TD>
			</cfoutput>
			</TR>

			<TR class="labelmedium">
				<td style="padding:1px">Condition:</td>
			<TD style="padding:1px">
			<cfoutput>
				<input type="text" style="height:25px" name="FunctionCondition" id="FunctionCondition" value="#Line.FunctionCondition#" size="80" maxlength="80" class="regularxl"></TD>
			</cfoutput>
			</TR>


			<TR class="labelmedium2">
				<td valign="top" style="padding-top:3px">Target:</td>
			<TD style="padding-top:3px">
			<table cellspacing="0" cellpadding="0">
			<tr><td style="padding:1px">
					<input type="radio" class="radiol" name="FunctionTarget" id="FunctionTarget" value="right" <cfif Line.FunctionTarget eq "right">checked</cfif>></td><td class="labelmedium" style="padding-left:4px;padding:1px">Same Frame (top)</td>
			</td>
		<td style="padding-left:6px">
				<input type="radio" class="radiol" name="FunctionTarget" id="FunctionTarget" value="new" <cfif Line.FunctionTarget eq "new">checked</cfif>></td><td class="labelmedium" style="padding-left:4px;padding:1px">New Window</td>
			</td>
		<td style="padding-left:6px">
				<input type="radio" class="radiol" name="FunctionTarget" id="FunctionTarget" value="newfull" <cfif Line.FunctionTarget eq "newfull">checked</cfif>></td><td class="labelmedium" style="padding-left:4px;padding:1px">New Window (full size)</td>
			</td>
		<td style="padding-left:6px">
				<input type="radio" class="radiol" name="FunctionTarget" id="FunctionTarget" value="_new" <cfif Line.FunctionTarget eq "_new">checked</cfif>></td><td class="labelmedium" style="padding-left:4px;padding:1px">New Tab</td>
			</td></tr>
		</table>
		</TR>

		</table>
		</td>
		</TR>

	<cfelse>

			<TR class="labelmedium2">
				<td style="height:24px">Java/Action script:</td>
			<TD>
			<cfoutput>
				<input type="text" name="ScriptName" id="ScriptName" value="#Line.ScriptName#" size="60" maxlength="70" class="regularxl"></TD>
			</cfoutput>
			</TR>

		<cfif Line.MainmenuItem eq "1">

				<TR class="labelmedium2">
					<td style="height:24px">Target:</td>
				<TD>
				<table cellspacing="0" cellpadding="0">
				<tr><td>
						<input type="radio" class="radiol" class="radiol" name="FunctionTarget" id="FunctionTarget" value="new" <cfif Line.FunctionTarget eq "new">checked</cfif>></td><td style="padding-left:5px" class="labelmedium">New Window</td>
				</td>
			<td class="labelmedium" style="padding-left:5px">
					<input type="radio" class="radiol" class="radiol" name="FunctionTarget" id="FunctionTarget" value="_new" <cfif Line.FunctionTarget eq "_new">checked</cfif>></td><td style="padding-left:5px" class="labelmedium">New Browser tab</td>
				</td>
			<td style="padding-left:6px" class="labelmedium">
					<input type="radio" class="radiol" name="FunctionTarget" id="FunctionTarget" value="newfull" <cfif Line.FunctionTarget eq "newfull">checked</cfif>></td><td class="labelmedium" style="padding-left:4px;padding:1px">New Window (full size)</td>
				</td>
<!---
<td style="padding-left:6px" class="labelmedium">
<input type="radio" class="radiol" name="FunctionTarget" id="FunctionTarget" value="_new" <cfif Line.FunctionTarget eq "_new">checked</cfif>></td><td class="labelmedium" style="padding-left:4px;padding:1px">New Tab</td>
</td>
--->
				</tr>
				</table>
				</td>
				</TR>

		<cfelse>

				<input type="hidden" name="FunctionTarget" id="FunctionTarget" value="_blank">

		</cfif>

	</cfif>

	<TR class="labelmedium2">
		<TD style="height:24">Enforce refresh:</TD>
	<TD>
	<table cellspacing="0" cellpadding="0">
	<tr>
	<td><input type="radio" class="radiol" name="EnforceReload" id="EnforceReload" value="1" <cfif "1" eq Line.EnforceReload>checked</cfif>></td>
	<td class="labelmedium" style="padding-left:4px">Yes</td>
<td style="padding-left:7px"><input type="radio" class="radiol" name="EnforceReload" id="EnforceReload" value="0" <cfif "0" eq Line.EnforceReload>checked</cfif>></td>
	<td class="labelmedium" style="padding-left:4px">No</td>
</tr>
</table>
</td>
</tr>

<TR class="labelmedium2">
	<TD style="height:24">Enabled:</TD>
<TD>
<table cellspacing="0" cellpadding="0">
<tr>
<td><input type="radio" class="radiol" name="Operational" id="Operational" value="1" <cfif "1" eq Line.Operational>checked</cfif>></td>
	<td class="labelmedium" style="padding-left:4px">Yes</td>
<td style="padding-left:7px"><input type="radio" class="radiol" name="Operational" id="Operational" value="0" <cfif "0" eq Line.Operational>checked</cfif>></td>
	<td class="labelmedium" style="padding-left:4px">No</td>
</tr>
</table>
</td>

	<cfif Line.FunctionClass neq "SelfService">

		<TR class="labelmedium2">
			<TD style="height:24">Grant Access to UserGroup:</TD>
		<TD>
		<table cellspacing="0" cellpadding="0">
		<tr>
		<td>
				<input type="radio" class="radiol" name="AccessUserGroup" id="AccessUserGroup" value="1" <cfif "1" eq Line.AccessUserGroup>checked</cfif>>
		<td class="labelmedium" style="padding-left:4px">Yes</td>
	<td style="padding-left:7px"><input type="radio" class="radiol" name="AccessUserGroup" id="AccessUserGroup" value="0" <cfif "0" eq Line.AccessUserGroup>checked</cfif>></td>
		<td class="labelmedium" style="padding-left:4px">No</td>
	</tr>
	</table>
	<TR>
		<TD style="height:24">Anonymous Access:</TD>
	<TD>
	<table cellspacing="0" cellpadding="0">
	<tr>
	<td><input type="radio" class="radiol" name="EnableAnonymous" id="EnableAnonymous" value="1" <cfif "1" eq Line.EnableAnonymous>checked</cfif>></td>
		<td class="labelmedium" style="padding-left:4px">Yes</td>
	<td style="padding-left:7px"><input type="radio" class="radiol" name="EnableAnonymous" id="EnableAnonymous" value="0" <cfif "0" eq Line.EnableAnonymous>checked</cfif>></td>
		<td class="labelmedium" style="padding-left:4px">No</td>
	</tr>
	</table>

	</td>
	</tr>

	</cfif>

		<tr class="labelmedium2">
			<td style="height:24" class="labelmedium">Browser Support:</td>
		<td>

		<cfoutput>

			<table>
			
				<tr class="labelmedium2 fixlengthlist">
				
					<td><INPUT type="radio" class="radiol" name="BrowserSupport" id="BrowserSupport" value="1" <cfif line.functionclass eq "Listing" or line.functionclass eq "Maintain" or Line.FunctionClass eq "System">disabled</cfif><cfif Line.BrowserSupport eq "1">checked</cfif>></td>
					<td width="40">Only Chromium (Edge/Chrome)</td>
					<td><img src="#SESSION.root#/Images/edge.png" height="21" width="19" alt="Edge" border="0" align="absmiddle"></td>				
					<td><INPUT type="radio" class="radiol" name="BrowserSupport" id="BrowserSupport" value="2" <cfif Line.BrowserSupport eq "2" or line.functionclass eq "Listing" or line.functionClass eq "Maintain" or Line.FunctionClass eq "System">checked</cfif>></td>
					<td width="40">All common browsers</td>
					<td>
						<table class="formpadding">
							<tr class="fixlengthlist">
							<td><img src="#SESSION.root#/Images/edge.png" height="21" width="19" title="Edge 80+" border="0" align="absmiddle"></td>
							<td style="padding-left:2px"><img src="#SESSION.root#/Images/chrome_icon.jpg"   height="21" width="19" title="Chrome 80+" border="0" align="absmiddle"></td>
							<td style="padding-left:2px"><img src="#SESSION.root#/Images/safari_icon.png"   height="21" width="19" title="Safari 10+" border="0" align="absmiddle"></td>
							<td style="padding-left:2px"><img src="#SESSION.root#/Images/firefox_icon.gif"  height="21" width="19" title="Firefox (Mozilla) 80+" border="0" align="absmiddle"></td>
							</tr>
						</table>
					</td>
	
				</tr>

			</table>

		</cfoutput>

		</td>
		</tr>

<!---
<tr class="hide"><td id="myresult"><iframe name="saveform" id="saveform" scrolling="yes"></iframe></td></tr>
--->

		<tr><td colspan="2" height="1" class="line"></td></tr>
	<tr><td colspan="2" valign="bottom">
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">

	<td class="labelmedium2">
	<cfif Line.FunctionClass eq "Maintain">

			<input type="checkbox"
				   name="sync"
				   id="sync"
				   value="1">&nbsp;Sync Role and Group Access to all functions of maintenance

	</cfif>

	</td>
	<td align="center" height="30">

	<cfoutput>

		<cfif Line.MenuClass eq "Builder" or Line.FunctionClass eq "Manuals">
				<input type="button"
					   style="width:140px;height:25"
					   class="button10g"
					   name="del"
					   id="del"
					   value="Delete"
						onclick="ptoken.navigate('FunctionDelete.cfm?id=#Line.SystemFunctionId#&scope=#url.scope#','myresult')">
		</cfif>


			<input class="button10g" style="width:140px;height:25" type="button" name="update" id="update" value ="Apply"
					onclick="ptoken.navigate('RecordSubmit.cfm?ID=#URL.ID#&mission=#url.mission#&scope=#url.scope#','contentbox1','','','POST','entry')">

	</cfoutput>

	</td>
	</table>

	</td></tr>

	</table>

</cfform>

