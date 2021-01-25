
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
  
<table width="100%">

<tr>
 
<td width="100%" colspan="2" valign="top">

<!--- Query returning search results --->

<cfquery name="Total" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT count(*) as Total
    FROM Ref_AuthorizationRole
	WHERE 1=1
	<cfif url.filter1value neq "">
	AND #url.filter1# = '#url.filter1value#'
	</cfif>		
	<cfif url.filter2value neq "">
	AND #url.filter2# = '#url.filter2value#'
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
	 FROM Ref_AuthorizationRole
	WHERE 1=1
	<cfif url.filter1value neq "">
	AND #url.filter1# = '#url.filter1value#'
	</cfif>		
	<cfif url.filter2value neq "">
	AND #url.filter2# = '#url.filter2value#'
	</cfif>		
	<cfif criteria neq "">
	AND #preserveSingleQuotes(criteria)# 	
	</cfif>
</cfquery>

<table width="100%" class="navigation_table">
	
	<tr><td height="14" colspan="3">						 
		 <cfinclude template="Navigation.cfm">	 				 
	</td></tr>
	
	<cfoutput query="SearchResult">
	
	<cfif currentrow gte first>
	
		<tr class="navigation_row labelmedium2 line">	  
		    <td style="padding-left:6px" class="navigation_action" 
			onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#role#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ProsisUI.closeWindow('dialog#url.box#')</cfif>">		
			    <cf_img icon="select">		  				
			</td>
			<td width="90%">#Role# : #Description#</td>			
		</tr>
		
	</cfif>	
			     
	</CFOUTPUT>
	<tr><td height="14" colspan="3">						 
		 <cfinclude template="Navigation.cfm">	 				 
	</td></tr>

</TABLE>

</td>
</tr>
 
</table>

<cfset AjaxOnLoad("doHighlight")>
