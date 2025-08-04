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
		
<!--- this template goes to the first valid menu function as defined in the process options of the portal, which thus no longer has to be
harded coded in the portal landing page  --->

<cfset BrowserSupport = "1">
																		
<cfquery name="Menu" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM   #CLIENT.LanPrefix#Ref_ModuleControl
		WHERE  SystemModule   = 'SelfService'
		AND    FunctionClass  = '#url.id#'
		AND    MenuClass      = 'Process'
		AND    Operational = 1
		
		<cfif client.browser eq "Explorer">
		AND    (BrowserSupport = '1' OR BrowserSupport = '2')
		<cfelseif client.browser eq "Firefox" or client.browser eq "Chrome" or client.browser eq "Safari">
		AND    BrowserSupport = '2'
		<cfelse>
		AND    BrowserSupport = '0'
			<cfset BrowserSupport = "0">
		</cfif>	
		ORDER BY MenuOrder
</cfquery>
				
<cfset url.systemfunctionid = menu.systemfunctionid>	

<cfif Menu.functiontarget neq "iframe" and BrowserSupport neq "0">

	<cf_submenuLog systemfunctionid = menu.systemfunctionid> 
			
	<!--- open via the normal way the page to be loaded --->		
	<cfinclude template="../../#Menu.FunctionDirectory#/#Menu.FunctionPath#">
			
<cfelseif BrowserSupport neq "0">

	<cf_submenuLog systemfunctionid = menu.systemfunctionid>

	<cfparam name="client.mission" default="">		
	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/>   
		
      <cfoutput>
	  <iframe src="#client.root#/#Menu.FunctionDirectory#/#Menu.FunctionPath#?webapp=#url.webapp#&id=#client.personno#&scope=portal&mid=#mid#" 
	    name="contentframe" 
		id="contentframe" 
		width="100%" 
		height="100%" 
		frameborder="0">									  
      </iframe>	
	  
      </cfoutput>
	
<cfelse>				
					
	<cfoutput>
	<font color="red" size="2">#url.id# Menu configuration does not allow content to be viewed in your browser (#client.browser#).</font>
	<br>
	<font color="black" size="1">We recommend Internet Explorer 11 or equivalent.</font>
	</cfoutput>						

</cfif>		
			