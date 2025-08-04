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

<!--- Query returning search results --->

<cfquery name="Total" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT count(*) as Total
    FROM Ref_AuthorizationRoleOwner
	WHERE 1=1
	<cfif url.filter1value neq "">
	AND #url.filter1# = '#url.filter1value#'
	</cfif>			
	<cfif criteria neq "">
	AND #preserveSingleQuotes(criteria)# 	
	</cfif>
</cfquery>

<cf_pagecountN show="22" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>			   

<cfquery name="SearchResult" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT TOP #last# *    
	 FROM Ref_AuthorizationRoleOwner
	WHERE 1=1
	<cfif url.filter1value neq "">
	AND #url.filter1# = '#url.filter1value#'
	</cfif>			
	<cfif criteria neq "">
	AND #preserveSingleQuotes(criteria)# 	
	</cfif>
</cfquery>

<table height="100%" width="97%" align="center" class="navigation_table">

<tr><td height="14" colspan="3">						 
	 <cfinclude template="Navigation.cfm">	 				 
</td></tr>

<cfoutput query="SearchResult">
	
	<cfif currentrow gte first>
	
	    <tr height="100%">
		<td height="100%" valign="top">
		
		<table>
	
		<tr class="navigation_row labelmedium line">	  
		    <td height="18" width="30" style="padding-right:5px" class="navigation_action" onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#code#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ProsisUI.closeWindow('dialog#url.box#')</cfif>">			  	
				<cf_img icon="select">					   		
			</td>
			<td width="20%">#Code#</td>
			<TD width="80%">#Description#</TD>
		</tr>	
		</table>
		</td></tr>
		
	</cfif>	
		     
</CFOUTPUT>

<tr><td height="14" colspan="3">
						 
	 <cfinclude template="Navigation.cfm">
	 				 
</td></tr>

</TABLE>
 


<cfset AjaxOnLoad("doHighlight")>