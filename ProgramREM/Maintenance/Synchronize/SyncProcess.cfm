
<cf_screentop layout="webapp" height="100%" label="Shared Indicator Synchronization" scroll="yes">

<cfparam name="URL.Base" default="0">

<cfoutput>

<script language="JavaScript">

function reload(base) {
	parent.result.location = "SyncProcess.cfm?mission=#URL.Mission#&mandateno=#URL.mandateNo#&period=#URL.period#&Base="+base
}

function info(action) {

if (confirm("Do you want to " + action +" ?")) {
      ColdFusion.Window.show('process')
      return true		
   	} else {
	  return false
	}
}


</script>

</cfoutput>

<cfquery name="Base" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Organization
WHERE Mission   = '#URL.Mission#'
AND   MandateNo = '#URL.MandateNo#'
ORDER By HierarchyCode 
</cfquery>

<table width="100%" align="center" cellspacing="0" cellpadding="0">

<cfform action="SyncSubmit.cfm?Mission=#URL.Mission#&MandateNo=#URL.mandateNo#&Period=#URL.Period#"
        method="POST"
        target="sync">

<tr>
<td height="25" width="20%">&nbsp;Base unit:</td>
<td>

<select name="Base" onChange="reload(this.value)">
<cfif #URL.Base# eq "0">
	<option value=""></option>
</cfif>

<cfoutput query="Base">
	<option value="#OrgUnit#" <cfif #URL.Base# eq "#OrgUnit#">selected</cfif>>#OrgUnitName#</option>
</cfoutput>
</select>

</td>
</tr>
<tr>
<td valign="top">&nbsp;Destination:
<br>
<br>&nbsp;<i>Hold the CRTL key to select</td>
<td>

<select name="Destination"
        size="12" style="width:90%"
        multiple>
<cfoutput query="Base">
	<cfif #URL.Base# neq "#OrgUnit#">
		<option value="#OrgUnit#" >#OrgUnitCode# #OrgUnitName#</option>
	</cfif>
</cfoutput>
</select>
</td>
</tr>

<cfquery name="Period" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Period
	WHERE  PeriodClass IN (SELECT PeriodClass 
	                       FROM   Ref_Period 
						   WHERE  Period = '#URL.Period#')
</cfquery>

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Program P, ProgramPeriod Pe
	WHERE  P.ProgramCode = Pe.ProgramCode
	AND    Pe.OrgUnit = '#URL.Base#'
	AND    Pe.Period  = '#URL.Period#'
	AND    P.ProgramClass = 'Component'  
	AND    Pe.RecordStatus != '9'
	AND    P.ProgramCode NOT LIKE '%-%'   
</cfquery>

<tr><td>&nbsp;Program area:</td>
<td valign="top">
	<table width="80%" border="0" cellspacing="0" cellpadding="0" bordercolor="#E9E9E9" frame="below" rules="rows">
	
	<cfif program.recordcount eq "0">
		<tr><td><font color="FF0000">No program areas to be selected</font></td></tr>
	</cfif>
	
	<cfoutput query="Program">
	<tr>
	<td width="6%" ><input type="radio" name="ProgramCode" value="'#ProgramCode#'"></td>
	<td width="10%">#ProgramCode#</td>
	<td>#ProgramName#</td>
	</tr>
	<cfif currentRow lt recordcount>
	<tr><td colspan="3" bgcolor="e4e4e4"></td></tr>
	</cfif>
	</cfoutput>
	</table>
</td>
</tr>


<tr><td height="25">&nbsp;Create for Period:</td>
<td>
	<select name="Period">
	<cfoutput query="Period">
	   <option value="#Period#" <cfif url.period eq period>selected</cfif>>#Period#</option>
	</cfoutput>
	</select>
</td>
</tr>

<tr><td height="25">&nbsp;Preserve existing:</td>
<td>
	<input type="radio" name="Retain" value="1" checked>Yes 
	<input type="radio" name="Retain" value="0">No (Attention : Contact support before you select No)
</td>
</tr>
<cfif Program.recordcount eq "0">
	
<cfelse>
	<tr><td colspan="2" align="center">
	<input type="button" name="Cancel" value="Cancel" class="button10g" onClick="window.close()">
	<input class="button10g" type="submit" name="submit"  onClick="return info('synchronise the selected programs')" value="Synchronise">
	</td></tr>
</cfif>

</cfform>

</table>

<cfwindow name="process" Title="Import" height="400" width="500" closable="Yes" modal="Yes" center="Yes">
	<iframe name="sync" id="sync" width="100%" height="100%" frameborder="0"></iframe>
</cfwindow>	



