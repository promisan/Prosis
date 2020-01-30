
<cfquery name="site"
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM ParameterSite
	WHERE ApplicationServer = '#URL.Site#'
</cfquery>

<cfquery name="master"
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM ParameterSite
	WHERE ServerRole = 'QA'
</cfquery>

<cfquery name="version"
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM ParameterSiteVersion
	WHERE ApplicationServer = '#URL.Site#'
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" bgcolor="white">
<tr><td>
<table width="90%"
       border="0"
       cellspacing="0"
       cellpadding="0"
       align="center"
	   class="formpadding"
       bordercolor="D8D8D8"
       >
</td></tr>

<cfif version.recordcount eq "0">
<b>No distributions found</b>
</cfif>

<cfoutput query="version">

<cfset relurl  = "#SESSION.root#/_distribution/#URL.Site#/v#DateFormat(VersionDate,'YYYYMMDD')#">
<cfset relpath = "#master.replicaPath#\_distribution\#URL.Site#\v#DateFormat(VersionDate,'YYYYMMDD')#">

<tr>
	<td width="100">#dateformat(versionDate,CLIENT.DateFormatShow)#</td>
	<td width="130">#officerLastName#</td>
	<td width="80"><cfif actionStatus neq "1"><font color="FF0000">Pending</cfif></td>
	
	<cfdirectory action="LIST" 
			directory="#relpath#" 
			name="GetFiles" filter="*.pdf|*.zip">
			
			<cfif getfiles.recordcount eq "0">
			<td><font color="FF0000">Release is located on a different host</font></td>
			</cfif>
			<cfloop query="getfiles">		
			<td width="20%"><a href="#relurl#/#name#" target="_blank">#name#</a></td>
			</cfloop>	
			
</tr>
<tr><td colspan="8" height="1" class="line"></td></tr>
</cfoutput>
</table>
</tr>
</table>