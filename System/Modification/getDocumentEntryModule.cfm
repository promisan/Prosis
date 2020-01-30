<cfparam name="url.application" default="">
<cfparam name="url.scope" default="">
<cfparam name="url.selected" default="">

<cfquery name="GetModule" datasource="AppsSystem" username="#SESSION.login#" password="#SESSION.dbpw#">

	SELECT M.*
	FROM   Ref_ApplicationModule AM
	INNER  JOIN Ref_SystemModule M
		   ON AM.SystemModule = M.SystemModule
	WHERE  AM.Code = '#url.application#'
	       AND M.Operational = 1

</cfquery>

<cfoutput>
<select name="#url.scope#SystemModule" id="#url.scope#SystemModule" class="regularxl enterastab">
	<option>[Select]</option>
	<cfloop query="GetModule">
		<option value="#SystemModule#" <cfif url.selected eq SystemModule>selected</cfif> >#Description#</option>
	</cfloop>
</select>
</cfoutput>