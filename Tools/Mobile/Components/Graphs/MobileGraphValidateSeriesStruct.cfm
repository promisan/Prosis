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
<cfparam name="attributes.struct"	default="#StructNew()#"  type="struct">

<cfset vSeries = attributes.struct>

<cfif not StructKeyExists(vSeries, "type")>
	<cfset vSeries.type = "">
</cfif>

<cfif not StructKeyExists(vSeries, "name")>
	<cfset vSeries.name = "">
</cfif>

<cfif not StructKeyExists(vSeries, "query")>
	<cfset vSeries.query = "">
</cfif>

<cfif not StructKeyExists(vSeries, "label")>
	<cfset vSeries.label = "">
</cfif>

<cfif not StructKeyExists(vSeries, "value")>
	<cfset vSeries.value = "">
</cfif>

<cfif not StructKeyExists(vSeries, "color")>
	<cfset vSeries.color = "green">
</cfif>

<cfif not StructKeyExists(vSeries, "colorMode")>
	<cfset vSeries.colorMode = "regular">
</cfif>

<cfif not StructKeyExists(vSeries, "transparency")>
	<cfset vSeries.transparency = "0.6">
</cfif>

<cfset caller.vSeries = vSeries>