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

<cfsilent>
	<cfparam name="attributes.tpe"      default="integer">
	<cfparam name="attributes.val"      default="">
	<cfparam name="attributes.base"     default="1">
	<cfparam name="attributes.size"     default="">
	<cfparam name="attributes.fontsize" default="">
	<cfset val  = "#Attributes.val#">
	<cfset bas  = "#Attributes.base#">
	
	<cfoutput>
	<cfif attributes.tpe eq "Integer">
		<cfset out = "#numberFormat(val,"___")#">
	<cfelseif attributes.tpe eq "Amount0">
		<cfset out = "#numberFormat(val,"_,__")#">
	<cfelseif attributes.tpe eq "Amount1">
		<cfset out = "#numberFormat(val,"_,_")#">	
	<cfelseif attributes.tpe eq "Amount2">
		<cfset out = "#numberFormat(val,"_,_.__")#">
	<cfelseif attributes.tpe eq "Currency">
		<cfset out = "$#numberFormat(val,"_,_.__")#">
	<cfelseif attributes.tpe eq "Percentage">
		    <cfif val neq "">
				<cfset out = "#numberFormat((val/bas)*100,"._")#%">	
			</cfif>	
	<cfelse>
		<cfset out = "#val#">
	</cfif>
	</cfoutput>
</cfsilent>

<cfset content = replaceNoCase(out," ","")>

<cfoutput>
<cfif attributes.size neq "">
   <cf_space spaces="#attributes.size#" align="right" label="#content#" font="#attributes.fontsize#">
<cfelse>
	#content#
</cfif>
</cfoutput>
