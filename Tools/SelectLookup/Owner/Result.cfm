
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

<table height="100%" border="0" cellpadding="0" cellspacing="0" width="97%" align="center" class="navigation_table">

<tr><td height="14" colspan="3">
						 
	 <cfinclude template="Navigation.cfm">
	 				 
</td></tr>

<cfoutput query="SearchResult">

<cfif currentrow gte first>

    <tr height="100%">
	<td height="100%" valign="top">
	
	<table>

	<tr class="navigation_row">
	  
	    <td height="18" width="30" style="padding-right:5px" class="navigation_action" onclick="ColdFusion.navigate('#link#&action=insert&#url.des1#=#code#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ProsisUI.closeWindow('dialog#url.box#')</cfif>">
			  	
			<cf_img icon="select">					   
		
		</td>
		<td width="20%" class="labelit">#Code#</td>
		<TD width="80%" class="labelit">#Description#</TD>
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