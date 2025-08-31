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
<cfparam name="url.id" 				default="">
<cfparam name="url.mission" 		default="">
<cfparam name="url.class"   		default="Main">
<cfparam name="url.functionClass"   default="Selfservice">

<cfquery name="get" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *
	 FROM       #client.lanPrefix#Ref_ModuleControl	 
	 WHERE		<cfif url.id neq "">SystemFunctionId = '#url.id#'<cfelse>1 = 0</cfif>
</cfquery>

<cf_textareascript>

<cfset vTitleNew = "Portal"> 
<cfif lcase(url.functionClass) eq "pmobile">
	<cfset vTitleNew = "Prosis Mobile"> 
</cfif>

<cfif trim(get.functionName) eq "">
	<cfset vTitle = "New #vTitleNew# Instance">
<cfelse>
	<cfset vTitle = "#vTitleNew# Instance - #ucase(get.functionName)#">
</cfif>

<cf_screentop 
	 height="100%"
     scroll="Yes" 
	 html="Yes" 	
	 label="#vTitle#" 	 
	 layout="webAPP" 
	 line="no"
	 banner="gray" 
	 JQuery="yes">

<cfif get.recordcount eq "0" and url.id neq "">

<table width="100%"><tr><td align="center" style="height:200" class="labelmedium"><font color="FF0000">Record no longer exists</td></tr></table>

<cfelse>


<table width="100%" height="100%" align="center">

<tr><td height="6"></td></tr>

<tr><td>

		<cf_menuscript>
		
		<table width="97%"
	       border="0"
	       cellspacing="0"
	       cellpadding="0"
	       align="center"><tr>
		   
		   <cfif url.id neq "">
		   
		    <cfset wd = "64">
			<cfset ht = "64">
			
			<cfset itm = 1>
		   
		   	<cf_menutab item  = "#itm#" 
	            iconsrc    = "Logos/System/Maintain.png" 
				iconwidth  = "#wd#" 
				targetitem = "1"
				iconheight = "#ht#" 
	            class      = "highlight1"
				name       = "Function Settings"
				source     = "RecordEditDetail.cfm?id=#url.id#&mission=#url.mission#&class=#url.class#&functionClass=#url.functionClass#&systemmodule=#url.systemmodule#">
			
			
			<cfset itm = itm + 1>
				   							
			<cf_menutab item  = "#itm#" 
	            iconsrc    = "Logos/System/Info.png" 
				iconwidth  = "#wd#" 
				targetitem = "1"
				iconheight = "#ht#" 				
				name       = "About this function"
				source     = "../Functions/FunctionMemo.cfm?id=#URL.ID#">	
				
			<cfset itm = itm + 1>		
			
			<cf_menutab item  = "#itm#" 
	            iconsrc    = "Check.png" 
				iconwidth  = "#wd#" 
				targetitem = "1"
				iconheight = "#ht#" 
				name       = "Validations"
				source     = "../Functions/Validation/FunctionValidation.cfm?id=#URL.ID#">		
			</cfif>			 	 		
		</tr>
		</table>
	
	</td>
	
	</tr>

	<cfajaximport tags="cfform">
	
	<cfinclude template="RecordScript.cfm">
	
	<cf_menucontainer item="1" class="regular">	
	 
     	<cf_securediv id="divMain" bind="url:RecordEditDetail.cfm?id=#url.id#&mission=#url.mission#&class=#url.class#&functionClass=#url.functionClass#&systemmodule=#url.systemmodule#" style="height:100%;">
	
	</cf_menucontainer>	
	
	</table>

</cfif>