
<cfinvoke component="Service.Presentation.Presentation"
       method="highlight"
    returnvariable="stylescroll"/>
	
<cfparam name="url.AssetId" default="">			
<cfparam name="url.Code"    default="">	

<cfquery name="Asset" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   AssetItem A, Item I
	WHERE  AssetId = '#URL.Assetid#'	
	AND    A.ItemNo = I.ItemNo
</cfquery>

<!--- check access rights --->

<cfinvoke component = "Service.Access"  
   method           = "AssetHolder" 
   mission          = "#Asset.Mission#" 
   assetclass       = "#Asset.category#"
   returnvariable   = "access">	

<cfquery name="qMetrics" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT Metric
	FROM Ref_AssetActionMetric
	WHERE Category = '#Asset.category#'
	AND ActionCategory = '#URL.Code#'
</cfquery>				
   
<cfoutput>
<cfsavecontent variable="myquery">
    SELECT   A.*, A.OfficerFirstName+ ' ' + A.OfficerLastName as 'Officer', B.ListValue

	<cfloop query = "qMetrics">
		, (SELECT MetricValue 
			FROM AssetItemActionMetric
			WHERE AssetActionId = A.AssetActionId
			AND Metric = '#Metric#') as '#Metric#'	
	</cfloop>	
	
    FROM     AssetItemAction A, Ref_AssetActionList B
	WHERE    A.ActionCategory = B.Code
	AND      A.ActionCategoryList = B.ListCode
	AND      AssetId          = '#URL.Assetid#'
	AND      A.ActionCategory = '#URL.Code#'
	AND      A.ActionType     = 'Standard'
	AND      A.ActionStatus <> '9'	
</cfsavecontent>
</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
	
	<cfset itm = itm+1>	
	<cf_tl id="Date Audit" var = "1">
	<cfset fields[itm] = {label   = "#lt_text#",                   		
						  field   = "ActionDate",					
					      formatted  = "DateFormat(ActionDate,CLIENT.DateFormatShow)",
						  search  = "date"}>	

	<cfset itm = itm+1>	
	<cf_tl id="Observation" var = "1">	
	<cfset fields[itm] = {label   = "#lt_text#",                   		
						  field   = "ListValue"}>	
						  
	<cfset itm = itm+1>	
	<cf_tl id="Memo" var = "1">		
	<cfset fields[itm] = {label   = "#lt_text#",                   		
						  field   = "ActionMemo"}>	

	<cfloop query = "qMetrics">
		
		<cfset itm = itm+1>	
		<cfset fields[itm] = {label   = "#Metric#",                   		
				  field   = "#Metric#"}>		
	
	</cfloop>		

	<cfset itm = itm+1>
	<cf_tl id="Officer" var = "1">				
	<cfset fields[itm] = {label   = "#lt_text#",                   		
						  field   = "Officer",					
						  search  = "text"}>	

						  

<cf_listing
	    header        = "AssetActionList"
	    box           = "linedetail#URL.Code#"
		link          = "#SESSION.root#/Warehouse/Application/Asset/AssetAction/AssetActionContent.cfm?AssetId=#URL.Assetid#&Code=#URL.Code#"
	    html          = "No"		
		tableheight   = "100%"
		tablewidth    = "100%"
		datasource    = "AppsMaterials"
		listquery     = "#myquery#"
		listorderfield = "ActionDate"
		listorder      = "ActionDate"
		listorderdir   = "DESC"
		headercolor   = "ffffff"
		show          = "35"		
		filtershow    = "Hide"
		excelshow     = "Yes" 		
		listlayout    = "#fields#"
		allowgrouping = "No">	
		


