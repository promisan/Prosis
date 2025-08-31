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
<cfoutput>

<cfquery name="Open"
	datasource="AppsSystem"
	username="#SESSION.login#"
	Password="#SESSION.dbpw#">
	SELECT	*
	FROM	#CLIENT.LanPrefix#Ref_ModuleControl
	WHERE	SystemModule	= 'SelfService'	
	AND		MenuClass		= 'Menu'
	AND		Functionclass	= '#URL.ID#'
	AND		Operational    	= 1
	Order BY MenuOrder
</cfquery>	



	<cfparam name="url.link"      default="">
	<cfparam name="url.menu"      default="">
	
	<cfif url.link eq "" and url.menu eq "">
		<cfif FileExists ("#SESSION.rootpath##Open.FunctionDirectory##Open.FunctionPath#") AND Open.FunctionDirectory neq "" and Open.FunctionPath neq "">
			<cfset url.link = "../../../#Open.FunctionDirectory##Open.FunctionPath#">
		<cfelse>
			<cfset url.link = "Content/Example.cfm">
		</cfif>
	</cfif>	

</cfoutput>

<cfif url.link neq "">
	<cfinclude template="#url.link#">
<cfelse>
	Menu Link not properly defined.
</cfif>