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
<!--- launch the template in a containing iframe --->

<cfquery name="MainMenu" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ModuleControl
	WHERE    SystemModule   = 'SelfService'
	AND      FunctionClass  = 'SelfService'
	AND      FunctionName   = '#url.id#' 
	AND      MenuClass      IN ('Mission','Main')
	ORDER BY MenuOrder
</cfquery>

<cfif mainmenu.recordcount neq "1">

    <table height="100%" align="center"><tr><td height="70%" class="labelit">Problem with retrieving portal template</td></tr></table>

<cfelse>
	
	<cfoutput query="MainMenu">
	
	<cfparam name="client.mission" default="">		
	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/>   
	
	<cfif findNoCase("mission=",functioncondition)>
	
		<!--- MISSION IS PASSED HARDCODED --->

		<iframe marginheight="0" 
			marginwidth="0" 
			frameborder="0" 
			allowTransparency="true"
			id="PortalView" 
			scrolling="No" 
			style="height:100%; width:100%; display:block"
			src="#SESSION.root#/#FunctionDirectory#/#FunctionPath#?webapp=#url.id#&id=#url.id#&#functioncondition#&mid=#mid#">
		</iframe>
	
	<cfelse>
	
		<iframe marginheight="0" 
			marginwidth="0" 
			frameborder="0" 
			allowTransparency="true"
			id="PortalView" 
			scrolling="No" 
			style="height:100%; width:100%; display:block"
			src="#SESSION.root#/#FunctionDirectory#/#FunctionPath#?webapp=#url.id#&id=#url.id#&mission=#client.mission#&#functioncondition#&mid=#mid#">
		</iframe>
		
	</cfif>		
		
	</cfoutput>

</cfif>