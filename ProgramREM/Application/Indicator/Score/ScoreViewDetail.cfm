
<cfinclude template="ScoreViewPrepare.cfm">

<cfquery name="Result"
datasource="appsQuery">	
	SELECT * 
	FROM     ProgramIndicatorWeight#fileNo#
	ORDER BY IndicatorCode, OrgunitName
</cfquery>

<table width="100%" border="0" align="center" bgcolor="ffffff" cellspacing="0" cellpadding="0">

<cfset prior = "">

<cfoutput query="result">

<cfif url.orgunit eq "0" and prior neq IndicatorCode> 
<tr><td></td><td colspan="6">
	#IndicatorDescription#
</td></tr>
</cfif>

<cfset prior = indicatorCode>

<cfif result eq "0">
<cfset color = "ffffcf">
<cfelse>
<cfset color = "f7f7f7">
</cfif>

<tr bgcolor="#color#">
<td width="70" bgcolor="white">&nbsp;&nbsp;</td>
<td> 

<cfif url.orgunit eq "0">&nbsp;&nbsp;&nbsp;&nbsp;
<a href="javascript:more('#IndicatorCode#_#orgunit#','show','#TargetId#')" title="Show/Hide graph">
#OrgunitName#
<cfelse>
<a href="javascript:more('#IndicatorCode#_#orgunit#','show','#TargetId#')" title="Show/Hide graph">
#IndicatorDescription#
</cfif>
</td>
<td align="right" width="84"><cfif result eq "1">#ResultExternal#</cfif></td>
<td align="right" width="84"><cfif result eq "1">#numberformat(ResultExternal/MaxScore*100,"__._")# %</cfif></td>
<td align="right" width="84"><cfif result eq "1">#ResultManual#</cfif></td>
<td align="right" width="84"><cfif result eq "1">#numberformat(ResultManual/MaxScore*100,"__._")# %</cfif></td>
<td align="right" width="84">0</td>
</tr>

<cfif targetId neq "">
<tr id="e#IndicatorCode#_#orgunit#" class="hide">
  <td colspan="7">
        <iframe name="i#IndicatorCode#_#orgunit#" 
	         id="i#IndicatorCode#_#orgunit#" 
			 width="100%" 
			 height="240" 
			 align="middle" 
			 scrolling="no" 
			 frameborder="0">
			 </iframe>
 </td>
</tr>
</cfif>
<tr><td></td><td colspan="7" bgcolor="d4d4d4"></td></tr>

</cfoutput>
</table>
