
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

<table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">

<tr><td height="14" colspan="3">
						 
	 <cfinclude template="Navigation.cfm">
	 				 
</td></tr>

<cfoutput query="SearchResult">

<cfif currentrow gte first>

	<tr class="navigation_row">
	  
	    <td style="padding-left:6px" height="18" width="30" class="navigation_action" onclick="ColdFusion.navigate('#link#&action=insert&#url.des1#=#role#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ColdFusion.Window.hide('dialog#url.box#')</cfif>">&nbsp;
			  					   
		   <img src="#SESSION.root#/Images/bullet.png" alt="Select"
		     name="img98_#orgunit#" 
			 onMouseOver="document.img98_#orgunit#.src='#SESSION.root#/Images/button.jpg'" 
		     onMouseOut="document.img98_#orgunit#.src='#SESSION.root#/Images/bullet.png'"
			 id="img98_#orgunit#" 
			 width="12" 
			 style="cursor: pointer;"
			 height="12" 
			 border="0" 
			 align="absmiddle">					
	
		</td>
		<td class="labelit" width="20%">#Role#</td>
		<TD class="labelit" width="80%">#Description#</TD>
	</tr>
	
</cfif>	
		     
</CFOUTPUT>

<tr><td height="2"></td></tr>
<tr><td colspan="3" class="linedotted"></td></tr>

<tr><td height="14" colspan="3">
						 
	 <cfinclude template="Navigation.cfm">
	 				 
</td></tr>

</TABLE>
 
</table>


<cfset AjaxOnLoad("doHighlight")>
