
<!--- configuration file --->
<cfoutput>
<cfsavecontent variable="myquery">
	 SELECT *, OfficerFirstName+' '+OfficerLastName as OfficerName
	  FROM   ParameterSiteVersion
	  WHERE  ApplicationServer = '#URL.site#'	 
</cfsavecontent>

<cfset fields=ArrayNew(1)>

<cfset fields[1] = {label   = "Version&nbsp;Date", 
                    width   = "10%",					
					field   = "VersionDate",
					formatted  = "dateformat(VersionDate,CLIENT.DateFormatShow)",
					search  = "date"}>
					
<cfset fields[2] = {label   = "Group", 
                    width   = "10%", 
					field   = "TemplateGroup",
					search  = "text"}>					
					
<cfset fields[3] = {label   = "Server", 
                    width   = "20%", 
					field   = "ApplicationServer",
					search  = "text"}>
						
<cfset fields[4] = {label   = "Prepared&nbsp;by&nbsp;Officer", 
					width   = "60%", 
					field   = "OfficerName",
					search  = "no"}>	
						
							
<cf_listing
    header        = "Release Log"
    box           = "releasedetail"
	link          = "#SESSION.root#/System/Template/TemplateReleaseDetail.cfm?site=#url.site#"
    html          = "No"
	show          = "10"
	datasource    = "AppsControl"
	listquery     = "#myquery#"
	listorder     = "VersionDate"
	listorderdir  = "DESC"
	filtershow    = "No"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	drillmode     = "workflow"
	drilltemplate = "workflow"
	drillkey      = "versionid">
	
</cfoutput>	
