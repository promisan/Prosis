

<cfquery name="Edition" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_AllotmentEdition R, Ref_AllotmentVersion V
	WHERE     Editionid     = '#url.editionid#' 
	AND       R.Version = V.Code
</cfquery>

<cfoutput>
<script>
	document.getElementById('screentoplabel').innerHTML = "#Edition.Description# for plan period #URL.Period#"
</script>
</cfoutput>