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
<cfparam name="url.maxWeeks" 		default="12">
<cfparam name="url.weeks" 			default="6">
<cfparam name="url.asof" 			default="#dateformat(now(), client.DateFormatShow)#">
<cfparam name="url.validStartDate"	default="#dateformat(now()-365, client.DateFormatShow)#"> <!--- remover 365 to allow from today only --->
<cfparam name="url.effective" 		default="#dateformat(now(), client.DateFormatShow)#">
<cfparam name="url.maxTo" 			default="#dateformat(now(), client.DateFormatShow)#">

<cfif url.effective eq "">
	<cfset url.effective = dateformat(now(), client.DateFormatShow)>
</cfif>

<cfif url.asof eq "">
	<cfset url.asof = dateformat(now(), client.DateFormatShow)>
</cfif>

<cfif url.maxTo eq "">
	<cfset url.maxTo = dateformat(now(), client.DateFormatShow)>
</cfif>

<cfif url.weeks eq "">
	<cfset url.weeks = 6>
</cfif>

<cfset selDate = replace("#url.validStartDate#", "'", "", "ALL")>
<cfset dateValue = "">
<CF_DateConvert Value="#SelDate#">
<cfset vDateValidStart = dateValue>

<cfset selDate = replace("#url.asof#", "'", "", "ALL")>
<cfset dateValue = "">
<CF_DateConvert Value="#SelDate#">
<cfset vAsOf = dateValue>
<cfset vAsOfEnd = dateAdd('d', url.weeks*7, vAsOf)>

<cfset selDate = replace("#url.maxto#", "'", "", "ALL")>
<cfset dateValue = "">
<CF_DateConvert Value="#SelDate#">
<cfset vMaxTo = dateValue>

<cfquery name="validatePersonTo" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	CopySchedulePersonTo_#session.acc#
</cfquery>

<cfif validatePersonTo.recordCount gt 0>
	<cfinclude template="ScheduleCopyDetailTo.cfm">
<cfelse>
	<cfinclude template="ScheduleCopyDetailFrom.cfm">
</cfif>

<cfset ajaxOnLoad("doCalendar")>