<cf_screentop html="no">

<cfset FileNo = round(Rand()*20)>

<cfquery name="Pivot" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   UserPivot
		WHERE  ControlId = '#URL.ID#'
</cfquery>
	 	 
<cfinvoke component="Service.Analysis.CrossTab" method="Filter"
	  controlid           = "#URL.id#"
	  returnVariable       = "condition">			

<cfinvoke component="Service.Analysis.CrossTab" method="Basic"
	  CrossTabName        = "Pivottable"
	  sourceid            = ""
	  controlid           = "#URL.id#"
	  fileNo              = "#FileNo#"
	  node                = "#Pivot.Node#"
	  alias               = "#Pivot.DataSource#"
	  table               = "#URL.Table#"
	  format              = "Excel"
	  condition           = "#condition#"
	  SummaryColor        = "ffffdf"
	  colHeaderHeight     = "19"
	  hideYaxNULL         = "1">
	  

