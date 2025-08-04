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

<cfparam name="HelpWizard.SystemFunctionId" default="">

<div id="step1" class="helpwizard" style="display:block">
	<cfoutput>#SESSION.welcome#</cfoutput> has changed a bit, would you like to take an interactive 3 minute tour of the system?
	<br><br>
	<span onclick="helpwizard('1')">
		Yes
	</span>
	<span onclick="$('#helpwizarddialog').fadeOut(600)">Remind me later</span>
	<cfoutput>
	<span onclick="$('##helpwizarddialog').fadeOut(600); helpwizard('','Delete','#HelpWizard.SystemFunctionId#')">No</span>
	</cfoutput>
	<br><br>
</div>

<div id="step2" class="helpwizard">
	<img src="images/leftarrow.png" style="position:absolute; top:40px; left:-35px">
	First, the Main Menu. It's now simpler and more intuitive, requiring less mouse clicks.
	<br><br>
	You can:
	<br><br>
		<ul style="margin-left:20px;">
			<li type=square>Minimize it by clicking on the headers. <img src="images/Maximize_maincontent.png" style="padding-top:3px"></li>
			<li type=square>Load the content window in Full Screen mode directly. <img src="images/full_screen.png" style="padding-top:3px"></li>
			<li type=square>Change Login screen theme (bottom left).</li>
		</ul>
	<br>
	<span onclick="helpwizard('2') ">Next</span>
	<br><br>

</div>

<div id="step3" class="helpwizard">
	<img src="images/rightarrow.png" style="position:absolute; top:40px; right:-35px">
	Now, the Widgets area. A fun and user friendly group of everyday tools. <strong>Just minimize the Portal Topics area</strong>.
	<br><br>
	You can:
	<br><br>
		<ul style="margin-left:20px;">
			<li type=square>Store needed files in the FileShelf.</li>
			<li type=square>View live weather feeds from locations associated to your account.</li>
			<li type=square>Jot down your thoughts / to-do list in the Notes area.</li>
		</ul>
		<br>
		You can add and erase widgets when ever you want. Just hover you mouse over the top right corner of each widget.
		<br><br>
		<span onclick="helpwizard('3') ">Next (and last)</span>
		<br><br>
</div>

<div id="step4" class="helpwizard">
	<img src="images/rightarrow.png" style="position:absolute; top:20px; right:-35px">
		Finally, the User Menu area. A simple and centralized place for options associated to your account.
	<br><br>
	You can:
	<br><br>
		<ul style="margin-left:20px;">
			<li type=square>Change System Password.</li>
			<li type=square>View your system Preferences.</li>
			<li type=square>Plus additional Utilities you may have.</li>
		</ul>
		<br>
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
				AND       U.Account = '#SESSION.acc#'

		</cfquery>
		<cfoutput>
		<span onclick="helpwizard('4','Complete','#HelpWizard.SystemFunctionId#')">Done</span>
		</cfoutput>
		<br><br>
</div>
