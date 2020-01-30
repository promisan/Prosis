
<HTML><HEAD>
<TITLE>Script output file</TITLE>
</HEAD><body leftmargin="0" topmargin="0" bottommargin="0" rightmargin="0" bgcolor="FfFfFf">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<div style="position:absolute;width:100%;height:100%; overflow: auto; scrollbar-face-color: d4d4d4;">

<cfquery name="Log" 
  datasource="appsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT *
    FROM   ScheduleLog
	WHERE ScheduleRunId = '#URL.ID#'
</cfquery>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

	<tr>
	<td class="top3n" height="23">
	&nbsp;&nbsp;Output Timestamp: 
	<cfoutput>
	<b>#DateFormat(Log.ProcessEnd,CLIENT.DateFormatShow)# #TimeFormat(Log.ProcessEnd,"HH:MM:SS")#</b>
	</cfoutput>
	</td>
	</tr>
	<tr>
		<td align="center" bgcolor="d4d4d4" height="100%">
		<table width="99%" height="100%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
		<tr><td>
		<cfoutput>#Log.ScriptOutput#</cfoutput>
		</td></tr>
		</table>
  	    </td>
	</tr>

</table>

</div>