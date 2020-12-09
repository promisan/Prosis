
<cf_submenuleftscript>

<cfquery name="Mission" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Organization.dbo.Ref_Mission
	WHERE  Mission IN (SELECT Mission
					   FROM   ItemUoMMission
					   WHERE  ItemNo = '#URL.ID#'
					   AND    Operational = 1) 
</cfquery>

<cfset fcolor = "002350">
	 
<input type="hidden" name="optionselect" id="optionselect">	 
	 	 
<table style="width:210px">

<tr><td height="8"></td></tr>
<tr><td style="padding-left:7px">
	<cfset heading      = "Specifications">
	<cfset module       = "'Warehouse'">
	<cfset img          = "condition.gif">	
	<cfset selection    = "'Item'">
	<cfset menuclass    = "'Maintain'">
	<cfinclude template = "../../../Tools/SubmenuLeft.cfm">
</td></tr>

<tr><td style="padding-left:10px;padding-top:4px;padding-bottom:4px">

<select name="mission" id="mission" class="regularxxl" style="width:205px" onchange="applymenu()">
<cfoutput query="Mission">
<option value="#mission#" <cfif mission eq url.mission>selected</cfif>>#mission#</option>
</cfoutput>
</select>

</td></tr>

<tr><td style="padding-left:7px">
	<cfset heading        = "Acquisition">
	<cfset module         = "'Warehouse'">
	<cfset img            = "locate3.gif">	
	<cfset selection      = "'Acquisition'">
	<cfset menuclass      = "'Maintain','Inquiry'">
	<cfinclude template  ="../../../Tools/SubmenuLeft.cfm">
</td></tr>

<tr><td style="padding-left:7px">
	<cfset heading        = "Storage">
	<cfset module         = "'Warehouse'">
	<cfset img            = "locate3.gif">	
	<cfset selection      = "'Storage'">
	<cfset menuclass      = "'Maintain','Inquiry'">
	<cfinclude template   = "../../../Tools/SubmenuLeft.cfm">
</td></tr>

<tr><td style="padding-left:7px">
	<cfset heading        = "Sales and Distribution">
	<cfset module         = "'Warehouse'">
	<cfset img            = "locate3.gif">	
	<cfset selection      = "'Distribution'">
	<cfset menuclass      = "'Maintain','Inquiry'">
	<cfinclude template="../../../Tools/SubmenuLeft.cfm">
</td></tr>

<tr><td style="padding-left:7px">
	<cfset heading        = "Analysis">
	<cfset module         = "'Warehouse'">
	<cfset img            = "locate3.gif">	
	<cfset selection      = "'Analysis'">
	<cfset menuclass      = "'Maintain','Inquiry'">
	<cfinclude template="../../../Tools/SubmenuLeft.cfm">
</td></tr>

</table>
