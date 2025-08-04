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
<cfparam name="Attributes.Mode"              default="GoTo">	
<cfparam name="Attributes.Icon"              default="">	
<cfparam name="Attributes.Content"           default="">	
<cfparam name="Attributes.Opener"            default="parent.">
<cfparam name="Attributes.Reload"            default="false">
<cfparam name="Attributes.Style"             default="">
<cfparam name="Attributes.SystemModule"      default="SelfService">	
<cfparam name="Attributes.MenuClass"         default="Process">	
<cfparam name="Attributes.Id"                default="">	
<cfparam name="Attributes.FunctionName"      default="">	

<cfswitch expression="#attributes.Mode#">

	<cfcase value="GoTo">
	
		<cfquery name="getTab" 
			datasource="appsSystem">     
		       SELECT   *
		       FROM     Ref_ModuleControl
		       WHERE    SystemModule = '#attributes.SystemModule#' 
			   AND 		MenuClass = '#attributes.MenuClass#'
		       AND      FunctionClass = '#attributes.id#'        
		       AND      FunctionName = '#attributes.FunctionName#'      
		</cfquery> 
		  
		<cfif getTab.recordcount eq "1">
		    <cfif attributes.icon neq "">
			   <cf_img icon="#attributes.icon#" onclick="javascript:#Attributes.Opener#_goToTab('#getTab.systemFunctionId#', #Attributes.Reload#)">	
			<cfelse>
			<cfoutput>
				<cf_tl id="Go" var="1">
				<a style="#Attributes.Style#" title="#lt_text#" href="javascript:#Attributes.Opener#_goToTab('#getTab.systemFunctionId#', #Attributes.Reload#)"><u>#attributes.Content#</u></a>	  
			</cfoutput>
			</cfif>
		</cfif>
	
	</cfcase>
	
	<cfcase value="Prior">
		<cfoutput>
			<cf_tl id="Previous Tab" var="1">
			<a style="#Attributes.Style#" title="#lt_text#" href="javascript:#Attributes.Opener#_goToPreviousTab(#Attributes.Reload#)">#attributes.Content#</a>	  
		</cfoutput>
	</cfcase>
	
	<cfcase value="Next">
		<cfoutput>
			<cf_tl id="Next Tab" var="1">
			<a style="#Attributes.Style#" title="#lt_text#" href="javascript:#Attributes.Opener#_goToNextTab(#Attributes.Reload#)">#attributes.Content#</a>	  
		</cfoutput>
	</cfcase>
	
	<cfcase value="Login">
		<cfoutput>
			<cf_tl id="Login" var="1">
			<a style="#Attributes.Style#" title="#lt_text#" href="javascript:#Attributes.Opener#showLogin()">#attributes.Content#</a>	  
		</cfoutput>
	</cfcase>
	
	<cfcase value="Menu">
		<cfoutput>
			<cf_tl id="Open Menu" var="1">
			<a style="#Attributes.Style#" title="#lt_text#" href="javascript:#Attributes.Opener#showMainMenu()">#attributes.Content#</a>	  
		</cfoutput>
	</cfcase>
	
	<cfcase value="Preferences">
		<cfoutput>
			<cf_tl id="Open Preferences" var="1">
			<a style="#Attributes.Style#" href="javascript:#Attributes.Opener#showOptions()">#attributes.Content#</a>	  
		</cfoutput>
	</cfcase>

</cfswitch>