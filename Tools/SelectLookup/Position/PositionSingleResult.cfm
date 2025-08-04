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
				
		<cfset criteria = "(#criteria# or PositionParentId LIKE '#Form.Crit1_Value#')">
	
</cfif>	
	
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

<!--- 14/11/2015 conversion for value on the fly --->

<cfset start = "1">
<cfset new   = link>

<cfloop condition="#start# lte #len(new)#">
		
		<cfif find("{","#new#",start)>
						
			<cfset str   = find("{",new,start)>
			<cfset str   = str+1>
			<cfset end   = find("}",new,start)>
			<cfset end   = end>
						
			<cfset fld   = Mid(new, str, end-str)>
				
			<cfset new = replaceNoCase(new,"{#fld#}","'+document.getElementById('#fld#').value+'","ALL")>
									
			<cfset start = end>
			
		<cfelse>
		
			<cfset start = len(new)+1>	

		</cfif> 
	
</cfloop>		

<cfset link = new>
  
<table width="100%">

<tr>
 
<td width="100%" colspan="2" valign="top" style="padding:0px">

<!--- Query returning search results --->

<cfparam name="url.datasource" default="appsWorkorder">

<cfif url.datasource eq "">
	 <cfset url.datasource = "AppsEmployee">
</cfif>

<cfquery name="Total" 
datasource="#url.datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   COUNT(*) as Total
    FROM     Position
	WHERE    1=1
	<cfif url.filter1value neq "">
	AND      Mission = '#url.filter1value#'
	</cfif>	
	<cfif criteria neq "">
	AND      #preserveSingleQuotes(criteria)# 	
	</cfif>
	AND      DATEADD(m, -3, DateEffective) <= GETDATE() 
	AND      (
	         DateExpiration >= GETDATE() OR 
			 DateExpiration >= DATEADD(m, -3, GETDATE())
		     )
</cfquery>

<cf_pagecountN show="16" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>			   

<cfquery name="SearchResult" 
datasource="#url.datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT TOP #last# *
    FROM    Position
	WHERE   1=1 
	<cfif url.filter1value neq "">
	AND     Mission = '#url.filter1value#'
	</cfif>	
	<cfif criteria neq "">
	AND     #preserveSingleQuotes(criteria)# 	
	</cfif>
	AND      DATEADD(m, -3, DateEffective) <=GETDATE() 
	AND      (DateExpiration >= GETDATE() OR DateExpiration >= DATEADD(m, -3, GETDATE()) )
	ORDER BY SourcePostNumber, DateEffective
</cfquery>

<table style="width:100%" class="navigation_table">

<tr class="line"><td height="14" colspan="6">						 
	 <cfinclude template="PositionSingleNavigation.cfm">	 				 
</td></tr>

<cfoutput query="SearchResult">

<cfif currentrow gte first>

	<tr class="fixlengthlist navigation_row line labelmedium2" style="height:19px">	  
	    <td style="padding-left:5px;padding-right:6px;padding-top:2px" class="navigation_action" onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#positionNo#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ProsisUI.closeWindow('dialog#url.box#')</cfif>">			  
			<cf_img icon="select">						
		</td>
		<td><cfif SourcePostNumber eq "">#PositionParentId#<cfelse>#SourcePostNumber#</cfif></td>
		<TD>#FunctionDescription#</TD>
		<TD>#PostGrade#</TD>	
		<TD style="padding-left:4px">#dateformat(DateEffective,client.dateformatshow)#</TD>	
		<TD style="padding-left:4px;padding-right:4px">#dateformat(DateExpiration,client.dateformatshow)#</TD>		
	</tr>
	
</cfif>	
		     
</CFOUTPUT>

<tr><td height="14" colspan="6">						 
	 <cfinclude template="PositionSingleNavigation.cfm">	 				 
</td></tr>

</table>
</td></tr>
 
</table>

<cfset AjaxOnLoad("doHighlight")>
