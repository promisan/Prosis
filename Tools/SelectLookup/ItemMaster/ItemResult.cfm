<!--
    Copyright © 2025 Promisan B.V.

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
   
<table width="100%" border="0" frame="hsides" cellspacing="0" cellpadding="0" bordercolor="silver">
 
<td width="100%" colspan="2" valign="top">

<!--- Query returning search results --->

<cfquery name="Total" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT count(*) as Total
    FROM ItemMaster
	WHERE 1=1
	<cfif criteria neq "">
	AND #preserveSingleQuotes(criteria)# 	
	</cfif>
</cfquery>

<cf_pagecountN show="23" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>			   

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT TOP #last# *
    FROM ItemMaster
	WHERE 1=1
	<cfif criteria neq "">
	AND #preserveSingleQuotes(criteria)# 	
	</cfif>
ORDER BY Code
</cfquery>

<table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">

	<tr><td height="14" colspan="5">
							 
		 <cfinclude template="ItemNavigation.cfm">
		 				 
	</td></tr>
	
	<cfoutput query="SearchResult">
	
	<cfif currentrow gte first>
	
		<tr class="labelit navigation_row">
		  
		    <td height="18" class="navigation_action" width="30" onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#Code#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ColdFusion.Window.hide('dialog#url.box#')</cfif>">&nbsp;
				  					   
			   <img src="#SESSION.root#/Images/bullet.png" alt="Select"
			     name="img97_#orgunit#" 
				 onMouseOver="document.img97_#orgunit#.src='#SESSION.root#/Images/button.jpg'" 
			     onMouseOut="document.img97_#orgunit#.src='#SESSION.root#/Images/bullet.png'"
				 id="img97_#orgunit#" 
				 width="12" 
				 style="cursor: pointer;"
				 height="12" 
				 border="0" 
				 align="absmiddle">					
		
			</td>
			<td width="60">#Code#</td>
			<td>#EntryClass#</td>
			<TD>#Description#</TD>
			<td><cfif operational eq "0"><font color="FF0000">disabled</font></cfif></td>
		</tr>
		
	</cfif>	
			     
	</CFOUTPUT>

	<tr><td colspan="5" bgcolor="silver"></td></tr>

	<tr><td height="14" colspan="5">
						 
	 <cfinclude template="ItemNavigation.cfm">
	 				 
</td></tr>

</TABLE>
 
</table>


<cfset AjaxOnLoad("doHighlight")>