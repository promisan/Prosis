
<cf_tl id="Workforce Manager" var="1">
<cf_screentop height="100%" html="yes" label="#lt_text#" jquery="yes" line="no" banner="gray" layout="webapp">

<cfset vParams = listToArray(url.key,"__")>

<cfquery name="getMandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM	Ref_Mandate
		WHERE  	Mission   = '#vParams[2]#'
		AND		Operational = 1
		AND		#now()# BETWEEN DateEffective AND DateExpiration	
</cfquery>

<cfif getMandate.recordCount gt 0>
	
	<cfset url.workschedule = vParams[1]>
	<cfset url.mission = vParams[2]>
	<cfset url.mandate = getMandate.mandateNo>
	
	<cf_calendarviewscript>
	<cfajaximport tags="cfform">
	<cfinclude template="PlanningViewScript.cfm">
	
	<cfinclude template="PlanningView.cfm">
	
<cfelse>
	<table width="100%" height="100%">
		<tr>
			<td align="center" class="labellarge" style="color:808080;">[<cf_tl id="No active mandate is defined">]</td>
		</tr>
	</table>
</cfif>
		