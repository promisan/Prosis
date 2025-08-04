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
<cfset vLastNMonths = "12">
<cfset vReferenceDate = now()>

<cfquery name="pubList" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	P.*
		FROM   	Publication P
		WHERE  	1=1
		<cfif trim(url.workOrderId) neq "">
		AND		WorkOrderId = '#url.workOrderId#' 
		<cfelse>
		AND		1=0
		</cfif>
		AND		P.ActionStatus = '3'
		AND		(
					P.PeriodEffective BETWEEN #dateAdd('m',vLastNMonths*-1,vReferenceDate)# AND #vReferenceDate#
					OR
					P.PeriodExpiration BETWEEN #dateAdd('m',vLastNMonths*-1,vReferenceDate)# AND #vReferenceDate#
				)
		ORDER BY 
				P.PeriodExpiration DESC, 
				P.PeriodEffective DESC,
				P.Description ASC
</cfquery>

<table width="100%" align="center">
	<tr>
		<td>
			<!-- <cfform name="frmPublicationView"> -->
			<cf_tl id="Please, select a publication" var="1">				
			<cfselect 
				name="publicationId" 
				id="publicationId" 
				query="pubList" 
				display="Description" 
				value="publicationId" 
				class="regularxl"
				message="#lt_text#" 
				queryposition="below" 
				style="font-size:22px; height:40px;"
				onchange="ColdFusion.navigate('Publication/PublicationViewDetail.cfm?id=#url.id#&publicationId='+this.value,'divDetail');">
			</cfselect>
			<!-- </cfform> -->	
		</td>
	</tr>
</table>

<cfset AjaxOnLoad("function() { ColdFusion.navigate('Publication/PublicationViewDetail.cfm?id=#url.id#&publicationId=#pubList.publicationId#','divDetail'); }")>