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
<cfquery name="Get" 
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ReviewCycle
		WHERE 	CycleId = '#URL.ID1#'
</cfquery>

<cfquery name="qPeriod" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_Period
		WHERE     Period = '#url.period#'
</cfquery>

<cfif url.blank eq 1>
	<cfset vDate = qPeriod.DateExpiration>
<cfelse>
	<cfset vDate = evaluate("get.Date#url.name#")>
	<cfif vDate eq "">
		<cfset vDate = now()>
	</cfif>
</cfif>

<!-- <cfform method="POST" name="frmReviewCycle"> -->
<table cellspacing="0" cellpadding="0">
	<tr>
		<td style="position:relative; z-index:1;">

			<cf_tl id = "Select a valid #url.name# Date" var = "vDateMess">
			<cf_intelliCalendarDate9
				FieldName      = "Date#url.name#"
				Message        = "#vDateMess#"
				class          = "regularxl"
				Default        = "#dateformat(vDate, CLIENT.DateFormatShow)#"
				DateValidStart = "#Dateformat(qPeriod.DateEffective, 'YYYYMMDD')#"
				DateValidEnd   = "#Dateformat(qPeriod.DateExpiration, 'YYYYMMDD')#"
				Manual         = "false"
				AllowBlank     = "False">
		</td>
	</tr>
</table>
<!-- </cfform> -->

<cfset AjaxOnLoad("doCalendar")>