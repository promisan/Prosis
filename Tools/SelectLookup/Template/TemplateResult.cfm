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

<!--- Create Criteria string for query from data entered thru search form --->

<CFSET Criteria = ''>
<CF_Search_AppendCriteria
    FieldName="#Form.Crit1_FieldName#"
    FieldType="#Form.Crit1_FieldType#"
    Operator="#Form.Crit1_Operator#"
    Value="#Form.Crit1_Value#">
<CF_Search_AppendCriteria
    FieldName="#Form.Crit2_FieldName#"
    FieldType="#Form.Crit2_FieldType#"
    Operator="#Form.Crit2_Operator#"
    Value="#Form.Crit2_Value#">

<cfoutput>
<cfsavecontent variable="qry">
	FROM Ref_Template	
	<cfif PreserveSingleQuotes(Criteria) neq "">
	WHERE #PreserveSingleQuotes(Criteria)# 
	<cfelse>
	WHERE PathName is not NULL
	</cfif>   
	AND Operational = 1
</cfsavecontent>
</cfoutput>

<cfquery name="Total" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT count(*) as Total 
    #preserveSingleQuotes(qry)#	
</cfquery>

<cf_pagecountN show="21" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>		

<cfquery name="SearchShow" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP #last# *
    #preserveSingleQuotes(qry)#	
	ORDER BY PathName, FileName	
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
 
  <tr><td colspan="2" valign="top">

	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">
	
	<cfif searchshow.recordcount eq "0">
	
		<tr><td height="14" align="center" colspan="7" class="labelmedium">
			No files found>
		</td></tr>
		
	<cfelse>
	
		<tr><td height="14" colspan="7">
			 <cfinclude template="TemplateNavigation.cfm">
		</td></tr>
		
		<TR class="labelit">
		    <td height="20"></td>
		    <TD><cf_tl id="PathName"></TD>
			<TD><cf_tl id="FileName"></TD>
		    <TD><cf_tl id="Op."></TD>
			<TD><cf_tl id="Size"></TD>
			<TD><cf_tl id="Updated"></TD>
		</TR>
	
	</cfif>
		
	<cfset link    = replace(url.link,"||","&","ALL")>
		
	<CFOUTPUT query="SearchShow">
	
	<cfif currentrow gte first>
	
	<tr><td height="1" colspan="7" bgcolor="e8e8e8"></td></tr>
	
		<TR class="navigation_row labelit">
			<TD width="30" align="center" height="18" width="30" style="padding-left:3px;padding-top:3px">
			
			<cfset path = replace(pathname,'\','\\','ALL')> 
			
			<cfif url.close eq "Yes">
			<cf_img icon="open" navigation="Yes" onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#path#&#url.des2#=#filename#','#url.box#');ColdFusion.Window.hide('dialog#url.box#')">		
			<cfelse>
			<cf_img icon="open" navigation="Yes" onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#path#&#url.des2#=#filename#','#url.box#')">
			</cfif>
						  
			</TD>
			<TD>#PathName#</TD>
			<TD>#FileName#</TD>
			<TD>#Operational#</TD>
			<TD>#numberformat(fileSize/1024,"_._")#Kb</TD>
			<TD>#Dateformat(LastUpdated, CLIENT.DateFormatShow)#</TD>
		</TR>
	
	</cfif>
	
	</CFOUTPUT>
	
	<cfif searchshow.recordcount neq "0">	
		<tr><td height="14" colspan="7">
		 <cfinclude template="TemplateNavigation.cfm">
		</td></tr>	
	</cfif>

	</TABLE>

	</td></tr>	

</table>

<cfset ajaxonload("doHighlight")>