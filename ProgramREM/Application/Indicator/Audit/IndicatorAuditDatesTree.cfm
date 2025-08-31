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
<HTML><HEAD>
	<TITLE>Indicators</TITLE>
</HEAD>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<body leftmargin="0" topmargin="0" rightmargin="0">


<cfquery name="Target"
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
SELECT   PI.*, OrgUnit
FROM     ProgramIndicator PI, ProgramPeriod Pe
WHERE    TargetId = '#URL.TargetId#'
AND      PI.ProgramCode = Pe.ProgramCode
AND      PI.Period  = Pe.Period
</cfquery>

<cfquery name="Indicator"
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT   P.*, R.*, PI.Period, PI.TargetId
	FROM     ProgramIndicator PI,
	         Ref_Indicator R,
			 Program P 
	WHERE PI.IndicatorCode = R.IndicatorCode
	AND   PI.ProgramCode IN (SELECT ProgramCode FROM ProgramPeriod WHERE OrgUnit = '#Target.OrgUnit#')
	AND   Period = '#Target.Period#'
	AND   P.ProgramCode = PI.ProgramCode
	AND   LocationCode = '#Target.LocationCode#'
	AND   PI.RecordStatus != '9' 
	ORDER BY PI.ProgramCode, r.IndicatorCode
</cfquery>

<cf_divscroll>

<table border="0" cellspacing="0" cellpadding="0">
<cfoutput query="Indicator" group="ProgramCode">
<tr><td width="14"></td><td colspan="1" height="20" align="left"><b><font face="Verdana" color="0080C0">#ProgramName#</b></td></tr>
<tr><td colspan="2" bgcolor="EAEAEA"></td></tr>
<cfoutput>

<cfinvoke component = "Service.Access"
	Method          = "indicator"
	OrgUnit         = "#Target.OrgUnit#"
	Indicator       = "'#IndicatorCode#'"
	Role            = "ProgramAuditor"
	ReturnVariable  = "Access">
	
	<cfif Access eq "EDIT" or Access eq "ALL">
		
		<tr>
		<td width="14"></td>
		<td valign="top"><font face="Verdana" size="1"><b>#IndicatorCodeDisplay#</b></td>
		</tr>
		<tr>
		<td>&nbsp;</td>
		<td valign="top"><font face="Verdana" size="1">
		<a href="IndicatorAuditDatesInput.cfm?TargetId=#TargetId#&Period=#Period#" target="right">#IndicatorDescription#</a></td>
		</tr>
		<tr><td colspan="2" bgcolor="EAEAEA"></td></tr>

	</cfif>

</cfoutput>
<tr><td height="2"></td></tr>
</cfoutput>
</table>

</cf_divscroll>

</BODY></HTML>
