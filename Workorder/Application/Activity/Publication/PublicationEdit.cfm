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
<cfif trim(url.publicationId) eq "">
	<cf_tl id="Add Publication" var="1">
<cfelse>
	<cf_tl id="Edit Publication" var="1">
</cfif>

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="#lt_text#" 
			  banner="blue"
			  jQuery="yes"
			  user="no">
			  
<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Publication
		<cfif trim(url.publicationId) eq "">
		WHERE	1=0
		<cfelse>
		WHERE	PublicationId = '#url.publicationId#'
		</cfif>
</cfquery>

<cfform name="frmPublish" method="POST" onsubmit="return false;">

	<table width="93%" height="100%" align="center" class="formpadding">
		<tr><td height="15"></td></tr>
		<tr>
			<td class="labelit"><cf_tl id="Description">:</td>
			<td>
				<cfinput name="description" id="description" maxlength="50" value="#get.description#" size="30" required="Yes" message="Please, enter a valid description." class="regularxl">
			</td>
		</tr>
		
		<tr>
			<td class="labelit"><cf_tl id="Effective">:</td>
			<td style="position:relative; z-index:10;">
				<cfset vPeriodEffective = now()>
				<cfif trim(url.publicationId) neq "">
					<cfset vPeriodEffective = get.PeriodEffective>
				</cfif>
				<cf_intelliCalendarDate9
					FieldName="PeriodEffective" 
					Default="#dateformat(vPeriodEffective,CLIENT.DateFormatShow)#"
					class="regularxl"
					AllowBlank="False">	
			</td>
		</tr>
		
		<tr>
			<td class="labelit"><cf_tl id="Expiration">:</td>
			<td>
				<cfset vPeriodExpiration = now()>
				<cfif trim(url.publicationId) neq "">
					<cfset vPeriodExpiration = get.PeriodExpiration>
				</cfif>
				<cf_intelliCalendarDate9
					FieldName="PeriodExpiration" 
					class="regularxl"
					Default="#dateformat(vPeriodExpiration,CLIENT.DateFormatShow)#"
					AllowBlank="False">	
			</td>
		</tr>
		<tr><td height="5"></td></tr>
		<tr><td class="line" colspan="2"></td></tr>
		<tr><td height="5"></td></tr>
		<tr>
			<td colspan="2" align="center">
				<cf_tl id="Save" var="1">
				<cfoutput>
					<input 
						type="Button" 
						id="btnSubmitPub" 
						name="btnSubmitPub" 
						value="#lt_text#" 
						class="button10g" 
						onclick="submitPublishForm('#url.workorderid#','#url.publicationId#');">
				</cfoutput>
			</td>
		</tr>
	</table>
</cfform>  

<table><tr><td id="processPublication"></td></tr></table>

<cfset AjaxOnLoad("doCalendar")>
