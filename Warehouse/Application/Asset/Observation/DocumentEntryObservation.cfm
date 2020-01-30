<cfparam name="url.selected" default="">

<cfquery name="ObservationList" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *
	 FROM    Ref_AssetActionCategoryWorkflow C
	 WHERE   C.ActionCategory = '#url.actioncategory#'		
	 AND     C.Category       = '#url.Category#' 
	 AND     C.Operational = 1 
</cfquery>
	
<select name="Observation" class="regularxl">
    <cfoutput query="ObservationList">
		<option value="#Code#" <cfif url.selected eq code>selected</cfif>>#Description#</option>
	</cfoutput>
</select>