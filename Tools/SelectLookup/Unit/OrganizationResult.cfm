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
<cfset criteria = "">
<cfparam name="Form.Crit1_Value" default="">
<cfparam name="Form.Crit2_Value" default="">

<cf_compression>

<cftry>
	
	<cfif Form.Crit1_Value neq "">
	
		<CF_Search_AppendCriteria
		    FieldName="#Form.Crit1_FieldName#,OrgUnitNameShort"
		    FieldType="#Form.Crit1_FieldType#"
		    Operator="#Form.Crit1_Operator#"
		    Value="#Form.Crit1_Value#">
				
	</cfif>	
		
	<cfif Form.Crit2_Value neq "">	
		
		<CF_Search_AppendCriteria
		    FieldName="#Form.Crit2_FieldName#,OrgUnitNameShort"
		    FieldType="#Form.Crit2_FieldType#"
		    Operator="#Form.Crit2_Operator#"
		    Value="#Form.Crit2_Value#">
		
	</cfif>
	
	<cfcatch>
	
		<table align="center">
		<tr><td height="30" align="center">
				<font face="Verdana" color="0080FF">An error occurred processing this request.</font>
		</td></tr>
		</table>		
		
		<cfabort>
	
	</cfcatch>	

</cftry>

<cfset link    = replace(url.link,"||","&","ALL")>

 <cfquery name="Mandate" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT  * 
   FROM    Ref_Mandate
   WHERE   #url.filter1# = '#url.filter1value#'
   <cfif url.filter2 eq "MandateNo" and url.filter2value neq "">
   AND     #url.filter2# = '#url.filter2value#'
   </cfif>   
   ORDER BY MandateDefault DESC
   
</cfquery>

<cfset mis = url.filter1value>
<cfset man = mandate.mandateNo>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr>
 
<td width="100%" colspan="2" valign="top">

<!--- Query returning search results --->

<cfquery name="Total" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT count(*) as Total
    FROM   Organization O
	WHERE  Mission     = '#mis#'
	AND    MandateNo   = '#man#'
	<cfif url.filter2 eq "WorkOrder">
	
		<cfif url.filter2value eq "">
			AND    OrgUnit IN (SELECT OrgUnit 
			                  FROM    Workorder.dbo.Customer 
							  WHERE   OrgUnit = O.OrgUnit)
		<cfelse>
			AND    HierarchyCode LIKE (SELECT HierarchyCode+'%'
			                           FROM   Organization
									   WHERE  OrgUnit = '#url.filter2value#')									   
		</cfif>
							  
	</cfif>
	<cfif criteria neq "">
	AND    #preserveSingleQuotes(criteria)# 	
	</cfif>
	<cfif url.filter2 eq "Substantive">
	AND    OrgUnitClass != 'Administrative' 
	</cfif>
	
	
</cfquery>

<cfset show = int((url.height-300)/19)>

<cf_pagecountN show="#show#" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>			   

<cfquery name="SearchResult" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT TOP #last# *
    FROM Organization O
	WHERE Mission     = '#mis#'
	
	AND   MandateNo   = '#man#'
	
	<cfif url.filter2 eq "WorkOrder">
	
		<cfif url.filter2value eq "">
				AND    OrgUnit IN (SELECT OrgUnit 
				                  FROM    Workorder.dbo.Customer 
								  WHERE   OrgUnit = O.OrgUnit)
		<cfelse>
				AND    HierarchyCode LIKE (SELECT HierarchyCode+'%'
				                           FROM   Organization
										   WHERE  OrgUnit = '#url.filter2value#')									   
		</cfif>
		
	</cfif>	
	<cfif criteria neq "">
	AND #preserveSingleQuotes(criteria)# 	
	</cfif>
	<cfif url.filter2 eq "Substantive">
	AND  OrgUnitClass != 'Administrative'
	</cfif>
	
ORDER BY HierarchyCode
</cfquery>


<table width="100%" class="navigation_table">

<tr><td height="14" colspan="4">						 
	 <cfinclude template="OrganizationNavigation.cfm">	 				 
</td></tr>

<cfoutput query="SearchResult">
	
	<cfif currentrow gte first>
	
		<tr style="height:20px" class="navigation_action navigation_row labelmedium line fixlengthlist">
		 
		    <td class="navigation_action" 				 
				onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#orgunit#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ProsisUI.closeWindow('dialog#url.box#')</cfif>;">			
			   <cf_img icon="open">			  		
			</td>
			<td>#OrgUnitCode#</td>
			<TD><!--- #OrgUnitNameShort# ---></TD>
			<TD>#OrgUnitName#</TD>
		</tr>
		
	</cfif>	
		     
</CFOUTPUT>

<tr><td colspan="4" class="line"></td></tr>
<tr><td height="14" colspan="4">						 
	 <cfinclude template="OrganizationNavigation.cfm">	 				 
</td></tr>

</TABLE>
 
 </td>
 </tr>
 
</table>

<cfset AjaxOnLoad("doHighlight")>

