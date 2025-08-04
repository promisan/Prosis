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

<!--- get the text to be show --->

<cfparam name="url.programcode" default="">
<cfparam name="url.mode"        default="limited">
<cfparam name="url.Field"       default="ProgramGoal">
<cfparam name="url.Period"      default="">
 
<cfquery name="getProgram" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  #url.field# as Text
	FROM    #CLIENT.LanPrefix#ProgramPeriod Pe
	WHERE   Pe.ProgramCode    = '#URL.ProgramCode#'	
	AND     Pe.Period         = '#URL.Period#'
</cfquery>

<cfoutput>

	<cfif url.mode eq "full">
	 #evaluate("getProgram.Text")# <a href="javascript: _cf_loadingtexthtml='';ColdFusion.navigate('#session.root#/ProgramREM/Application/Program/Header/getProgramText.cfm?period=#url.period#&mode=limited&programcode=#url.programcode#&field=#url.field#','#url.field#box')"><font color="0080C0"><b>less << </font></a>
	<cfelse>
	 #left(getProgram.Text,200)#... <a href="javascript:_cf_loadingtexthtml='';ColdFusion.navigate('#session.root#/ProgramREM/Application/Program/Header/getProgramText.cfm?period=#url.period#&mode=full&programcode=#url.programcode#&field=#url.field#','#url.field#box')"><font color="0080C0"><b>more >> </font></a>										
	</cfif>

</cfoutput>