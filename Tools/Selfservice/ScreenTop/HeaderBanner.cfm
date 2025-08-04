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
<!--- To be reviewed by Kristhian --->

<cfif attributes.banner eq "blank">
	<cfset bg = "">
<cfelseif attributes.banner eq "yellow">
	<cfset bg = "BGV7.jpg">
<cfelseif attributes.banner eq "blue">
	<cfset bg = "BGV6.jpg">	
<cfelseif attributes.banner eq "bluedark">
	<cfset bg = "BGV11.jpg">
<cfelseif attributes.banner eq "gradient">
	<cfset bg = "BGV8.jpg">
<cfelseif attributes.banner eq "gray">
	<cfset bg = "BGV9.jpg">
<cfelse>
	<cfset bg = "BGV7.jpg">
</cfif>