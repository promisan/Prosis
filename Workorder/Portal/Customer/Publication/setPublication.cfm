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