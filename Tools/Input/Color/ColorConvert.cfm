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
<cffunction name="Complement">
	<cfargument name="strnumber" type="string">
	<cfargument name="limit" >

	<cfset vresult = strnumber>	
	<cfloop index="j" from="1" to="#limit-Len(strnumber)#">
		<cfset vresult = 0 & vresult>
	</cfloop>

	<cfreturn vresult>
</cffunction>



<cfparam name="attributes.rgb" default="">
<cfparam name="attributes.variable" default="result">

<cfset strcolor = attributes.rgb>

<cfset strcolor = replaceNoCase(strcolor,"rgb","","all")>
<cfset strcolor = replaceNoCase(strcolor,"(","","all")>
<cfset strcolor = replaceNoCase(strcolor,")","","all")>
<cfset strcolor = replaceNoCase(strcolor,"##","","all")>

<cfset result = "##">
<cfloop list="#strcolor#" index="i">
	<cfif isNumeric(i)>
		<cfset result = result & Complement(FormatBaseN(i, 16 ),2)>
	<cfelse>
		<cfset result = result & i>	
	</cfif>
</cfloop>

<cfset result = replaceNoCase(result,"##","","all")>

<cfset "caller.#attributes.variable#" = result> 