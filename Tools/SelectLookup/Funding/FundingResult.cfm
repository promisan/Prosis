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
<CFSET Criteria = ''>
<CF_Search_AppendCriteria
    FieldName="#Form.Crit0_FieldName#"
    FieldType="#Form.Crit0_FieldType#"
    Operator="#Form.Crit0_Operator#"
    Value="#Form.Crit0_Value#">
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
<CF_Search_AppendCriteria
    FieldName="#Form.Crit3_FieldName#"
    FieldType="#Form.Crit3_FieldType#"
    Operator="#Form.Crit3_Operator#"
    Value="#Form.Crit3_Value#">	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit4_FieldName#"
    FieldType="#Form.Crit4_FieldType#"
    Operator="#Form.Crit4_Operator#"
    Value="#Form.Crit4_Value#">		
<CF_Search_AppendCriteria
    FieldName="#Form.Crit5_FieldName#"
    FieldType="#Form.Crit5_FieldType#"
    Operator="#Form.Crit5_Operator#"
    Value="#Form.Crit5_Value#">		
<CF_Search_AppendCriteria
    FieldName="#Form.Crit6_FieldName#"
    FieldType="#Form.Crit6_FieldType#"
    Operator="#Form.Crit6_Operator#"
    Value="#Form.Crit6_Value#">				
<CF_Search_AppendCriteria
    FieldName="#Form.Crit7_FieldName#"
    FieldType="#Form.Crit7_FieldType#"
    Operator="#Form.Crit7_Operator#"
    Value="#Form.Crit7_Value#">
	
<cfoutput>
<cfsavecontent variable="qry">
	FROM Ref_Funding	
	<cfif PreserveSingleQuotes(Criteria) neq "">
	WHERE #PreserveSingleQuotes(Criteria)# 
	</cfif>	
</cfsavecontent>
</cfoutput>

<cfquery name="Total" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT count(*) as Total 
    #preserveSingleQuotes(qry)#	
</cfquery>

<cf_pagecountN show="20" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>		

<cfquery name="SearchShow" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP #last# *
               #preserveSingleQuotes(qry)#	
	ORDER BY   Fund,OrgUnitCode,ObjectCode,Reference,ProgramCode 
</cfquery>

<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0"> 
  
  <tr><td colspan="2" valign="top">

	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">
	
	<cfif searchshow.recordcount eq "0">
	
		<tr><td height="14" align="center" colspan="9" class="labelmedium">
			There are no records to show in this view
		</td></tr>
		
	<cfelse>
	
		<tr><td height="24" colspan="9">
			 <cfinclude template="FundingNavigation.cfm">
		</td></tr>
		
<!--- 		<TR class="line">
		    <td height="20"></td>
			<TD class="labelit"><cf_tl id="Type"></TD>
			<TD class="labelit"><cf_tl id="Reference"></TD>			
		    <TD class="labelit"><cf_tl id="Fund"></TD>
			<TD class="labelit"><cf_tl id="OrgUnit"></TD>
		    <TD class="labelit"><cf_tl id="Project"></TD>
			<TD class="labelit"><cf_tl id="Program"></TD>			
			<TD class="labelit"><cf_tl id="Object"></TD>
			<TD class="labelit"><cf_tl id="GLAccount"></TD>
		</TR> --->
	
		<TR class="line">
		    <td height="20"></td>
			<TD class="labelit"><cf_tl id="Type"></TD>
			<TD class="labelit"><cf_tl id="Reference"></TD>			
		    <TD class="labelit"><cf_tl id="Fund"></TD>
			<TD class="labelit"><cf_tl id="CCenter"></TD>
		    <TD class="labelit"><cf_tl id="WBSe"></TD>
			<TD class="labelit"><cf_tl id="Fun Area"></TD>			
			<TD class="labelit"><cf_tl id="Spon Class"></TD>
			<TD class="labelit"><cf_tl id="Grant"></TD>			
			<TD class="labelit"><cf_tl id="GLAccount"></TD>
		</TR>
			
	</cfif>
	
	<cfset link    = replace(url.link,"||","&","ALL")>
	<cfset currrow = 0>
	
	<CFOUTPUT query="SearchShow">
		
		<cfset currrow = currrow + 1>
		 
		<cfif currrow lte last and currrow gte first>		
		
			<TR class="labelit navigation_row linedotted">
			<TD width="30" align="center" class="navigation_action" onClick="ptoken.navigate('#link#&action=insert&#url.des1#=#fundingid#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ColdFusion.Window.hide('dialog#url.box#')</cfif>">
					
			    <cf_img icon="edit">
							 	
			</TD>
			<td><A title="Select" 
			       HREF ="javascript:ptoken.navigate('#link#&action=insert&#url.des1#=#fundingid#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ColdFusion.Window.hide('dialog#url.box#')</cfif>">#FundingType#</a>
		    </td>
			<td>#Reference#</td>
			<TD>#Fund#</TD>		
			<TD>#OrgUnitCode#</TD>	   
			<TD>#ProjectCode#</TD>
			<TD>#ProgramCode#</TD>		
			<TD>#ObjectCode#</TD>
			<TD>#CBGrant#</TD>			
			<td>#GLAccount#</td>
			</TR>
		
		</cfif>
	
	</CFOUTPUT>
	
	<cfif searchshow.recordcount neq "0">	
	<tr><td height="24" colspan="9">
	 	<cfinclude template="FundingNavigation.cfm">
	</td></tr>	
	</cfif>

	</TABLE>

	</td></tr>	

</table>

<cfset AjaxOnLoad("doHighlight")>