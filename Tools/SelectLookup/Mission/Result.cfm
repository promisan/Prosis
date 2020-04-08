<cfparam name="criteria" default="">
	
<cfif Form.Crit2_Value neq "">	
	
	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit2_FieldName#"
	    FieldType="#Form.Crit2_FieldType#"
	    Operator="#Form.Crit2_Operator#"
	    Value="#Form.Crit2_Value#">

</cfif>

<cfif Form.Crit3_Value neq "">	
	
	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit3_FieldName#"
	    FieldType="#Form.Crit3_FieldType#"
	    Operator="#Form.Crit3_Operator#"
	    Value="#Form.Crit3_Value#">

</cfif>


<cfset link    = replace(url.link,"||","&","ALL")>
  
<table width="100%">

<tr>
 
<td width="100%" colspan="2" valign="top">

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	Mission 
	FROM 	Ref_EntityMission 
	WHERE 	EntityCode = '#url.filtervalue1#' 
</cfquery>


<!--- Query returning search results --->
<cfquery name="Total" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT count(*) as Total
    FROM	Ref_Mission		
	WHERE	1=1
	<cfif criteria neq "">
	AND #preserveSingleQuotes(criteria)# 	
	</cfif> 
	<cfif url.filter1 eq "missionEntity" and check.recordcount gte "1">
	AND 	Mission IN 
			(
				SELECT 	Mission 
				FROM 	Ref_EntityMission 
				WHERE 	EntityCode = '#url.filtervalue1#' 
			)
	</cfif>
	AND     Operational = 1
</cfquery>

<cf_pagecountN show="8" count="#Total.Total#">
			   
<cfset counted  = total.total>	

<cfquery name="SearchResult" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  TOP #last# *
	FROM	Ref_Mission		
	WHERE	1=1
	<cfif criteria neq "">
	AND     #preserveSingleQuotes(criteria)# 	
	</cfif> 
	<cfif url.filter1 eq "missionEntity" and check.recordcount gte "1">
	AND 	Mission IN (
				SELECT 	Mission 
				FROM 	Ref_EntityMission 
				WHERE 	EntityCode = '#url.filtervalue1#'
			)
	</cfif>
	AND      Operational = 1
	ORDER BY MissionType, Mission
</cfquery>

<table border="0" width="100%" class="navigation_table">

<tr><td height="14" colspan="7">						 
	 <cfinclude template="Navigation.cfm">	 				 
</td></tr>

<!---
<tr class="labelit line">
	<td height="20"></td>
	<td>Code</td>
	<td>Name</td>
</tr>
--->

<cfoutput query="SearchResult" group="MissionType">
	<cfif currentrow gte first>
	<tr>
		<td colspan="3" style="height:34px;font-size:19px" class="labelmedium">#MissionType#</td>
	</tr>
	</cfif>
	<cfoutput>
	<cfif currentrow gte first>

	<tr style="height:20px" class="line labelmedium navigation_row">
	  
	    <td width="30" class="navigation_action" style="padding-top:4px" onclick="ColdFusion.navigate('#link#&action=insert&#url.des1#=#URLEncodedFormat(Mission)#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ProsisUI.closeWindow('dialog#url.box#')</cfif>">
		
		<cf_img icon="select">
		
	
		</td>		
		<td>#Mission#</td>
		<td width="60%">#left(MissionName,50)#</td>
		
	</tr>
	</cfif>
	</cfoutput>	
</CFOUTPUT>

<tr><td height="2"></td></tr>

</TABLE>


<cfset AjaxOnLoad("doHighlight")>
