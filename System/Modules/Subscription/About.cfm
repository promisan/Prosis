
<cfoutput>

<cfquery name="Report" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM  Ref_ReportControl 
   WHERE ControlId = '#URL.ID#'
</cfquery> 

<cf_screentop height="100%" bannerheight="5" title="About #SESSION.welcome# report - #Report.FunctionName#">
 
		<cfoutput>#Report.FunctionAbout#</cfoutput>
	
<cf_screenbottom footer="default">

</cfoutput>	

 