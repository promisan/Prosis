<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfparam name="criteria" default="">

<cfif Form.Crit1_Value neq "">

	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit1_FieldName#"
	    FieldType="#Form.Crit1_FieldType#"
	    Operator="#Form.Crit1_Operator#"
	    Value="#Form.Crit1_Value#">
	
</cfif>	
	
<cfif Form.Crit2_Value neq "">	
	
	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit2_FieldName#"
	    FieldType="#Form.Crit2_FieldType#"
	    Operator="#Form.Crit2_Operator#"
	    Value="#Form.Crit2_Value#">

</cfif>

<cfset link    = replace(url.link,"||","&","ALL")>
   
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 
<td width="100%" colspan="2" valign="top">

<!--- Query returning search results --->

<cfquery name="Total" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT count(*) as Total
    FROM FunctionTitle
	WHERE 1=1
	<cfif url.filter1 eq "mission">
	AND FunctionClass IN (SELECT FunctionClass 
	                      FROM   Organization.dbo.Ref_Mission 
						  WHERE  Mission = '#url.filter1value#')
	</cfif>
	<cfif criteria neq "">
	AND #preserveSingleQuotes(criteria)# 	
	</cfif>
</cfquery>

<cf_pagecountN show="15" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>			   

<cfquery name="SearchResult" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT TOP #last# *
    FROM FunctionTitle
	WHERE 1=1
	<cfif url.filter1 eq "mission">
	AND FunctionClass IN (SELECT FunctionClass 
	                      FROM   Organization.dbo.Ref_Mission 
						  WHERE  Mission = '#url.filter1value#')
	</cfif>
	<cfif criteria neq "">
	AND #preserveSingleQuotes(criteria)# 	
	</cfif>
ORDER BY FunctionDescription
</cfquery>

<table border="0" width="100%" class="navigation_table">

<tr><td height="20" colspan="3">						 
	 <cfinclude template="Navigation.cfm">	 				 
</td></tr>

<cfoutput query="SearchResult">

<cfif currentrow gte first>

	<tr class="line navigation_row labelmedium" style="height:20px">	  
	    <td width="30" style="padding-left:4px;padding-top:3px" class="navigation_action" onclick="javascript:ptoken.navigate('#link#&action=insert&#url.des1#=#functionno#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ProsisUI.closeWindow('dialog#url.box#')</cfif>">
		<cf_img icon="select">
		</td>
		<td width="60">#FunctionNo#</td>
		<TD width="80%">#FunctionDescription#</TD>
	</tr>
	
</cfif>	
		     
</CFOUTPUT>

<tr><td height="20" colspan="3">						 
	 <cfinclude template="Navigation.cfm">	 				 
</td></tr>

</TABLE>
 
</table>

<cfset AjaxOnLoad("doHighlight")>