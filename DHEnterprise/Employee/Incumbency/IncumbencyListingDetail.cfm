
<cfset vPrevDate = "">
<cfset vDate = trim(replace(url.prevDate, "'", "", "ALL"))>
<cfif vDate neq "">
	<cfset dateValue = "">
	<CF_DateConvert Value="#vDate#">
	<cfset vPrevDate = dateValue>
</cfif>

<cfset vCurDate = "">
<cfset vDate = trim(replace(url.curDate, "'", "", "ALL"))>
<cfif vDate neq "">
	<cfset dateValue = "">
	<CF_DateConvert Value="#vDate#">
	<cfset vCurDate = dateValue>
</cfif>

<cfquery name="getData" 
	datasource="hubEnterprise" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TransactionId,
		       IndexNo,
		       ActionDocumentNo,
		       ActionName,
		       ActionReason,
		       ActionRemarks,
		       ActionEffective,
		       DateProcessed,
		       UserId,
		       Source
		FROM   PersonEventAction
		WHERE  IndexNo = '#url.indexno#'
		<cfif trim(vPrevDate) neq "">
		AND   ActionEffective < #vPrevDate#
		</cfif>
		<cfif trim(vCurDate) neq "">
		AND   ActionEffective >= #vCurDate#
		</cfif>
		AND   TransactionStatus = '1'
		-- AND   Source = '#url.source#'
		AND   HistoricAction = 0 
		-- AND   ActionName NOT LIKE 'Increment%'
		ORDER BY ActionEffective DESC
</cfquery>

<table width="97%" class="navigation_table">
	<tr class="line"><td colspan="5"></td></tr>
	<cfif getData.recordCount gt 0>
		<tr class="line labelmedium">
			<td style="padding-right:10px;min-width:90"><cf_tl id="Effective"></td>			
			<td style="padding-right:10px;" width="90%"><cf_tl id="Action"></td>			
			<td style="padding-right:10px;min-width:80"><cf_tl id="PANo"></td>
			<td style="padding-right:10px;min-width:90"><cf_tl id="Processed"></td>
			<td style="padding-right:10px;min-width:90"><cf_tl id="Officer"></td>
		</tr>
		<cfoutput query="getData">
			<tr class="navigation_row line">			     
				<td style="padding-right:10px;">#dateformat(ActionEffective,client.dateformatshow)#</td>
				<td style="padding-right:10px;">
					<b>#ActionName#</b> <cfif trim(ActionReason) neq ""> / #ActionReason#</cfif>
					
					<cfset vRemarks = trim(ActionRemarks)>
					<cfif vRemarks eq "\N">
						<cfset vRemarks = "">
					</cfif>
					#vRemarks#
				</td>
				
				<td style="padding-right:10px;">#actionDocumentNo#</td>
				<td style="padding-right:10px;">#dateFormat(DateProcessed, client.dateformatshow)#</td>
				<td style="padding-right:10px;">#UserId#</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr><td align="center" class="labellarge">[ <cf_tl id="No details found"> ]</td></tr>
	</cfif>
	<tr><td height="15"></td></tr>
</table>

<cfset ajaxOnLoad("doHighlight")>
