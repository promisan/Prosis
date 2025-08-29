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
<cfparam name="attributes.year" 	default="#year(now())#">
<cfparam name="attributes.period" 	default="y">
<cfparam name="attributes.leap" 	default="1">

<cfset vDate = createDate(attributes.year - 1, 12, 31)>
												
<cfif trim(lcase(attributes.period)) eq "w">
	<cfset vDate = dateAdd("ww", attributes.leap, vDate)>
</cfif>

<cfif trim(lcase(attributes.period)) eq "m">
	<cfset vDate = dateAdd("m", attributes.leap, vDate)>
	<cfset vDate = createDate(year(vDate), month(vDate), daysInMonth(vDate))>
</cfif>

<cfif trim(lcase(attributes.period)) eq "q">
	<cfset vDate = dateAdd("q", attributes.leap, vDate)>
	<cfset vDate = createDate(year(vDate), month(vDate), daysInMonth(vDate))>
</cfif>

<cfif trim(lcase(attributes.period)) eq "s">
	<cfset vDate = dateAdd("q", 2*attributes.leap, vDate)>
	<cfset vDate = createDate(year(vDate), month(vDate), daysInMonth(vDate))>
</cfif>

<cfif trim(lcase(attributes.period)) eq "y">
	<cfset vDate = dateAdd("yyyy", attributes.leap, vDate)>
	<cfset vDate = createDate(year(vDate), month(vDate), daysInMonth(vDate))>
</cfif>

<cfset caller.LeapDate = vDate>