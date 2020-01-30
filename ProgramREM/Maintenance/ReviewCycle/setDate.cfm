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