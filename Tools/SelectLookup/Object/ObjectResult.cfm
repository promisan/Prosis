
<cfparam name="criteria" default="">

<cfparam name="Form.Crit1_Value" default="">
<cfparam name="Form.Crit2_Value" default="">

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
   
<table width="98%" border="0" cellspacing="0" cellpadding="0">
 
<td width="100%" colspan="2" valign="top">

<!--- Query returning search results --->

<cfparam name="Form.ObjectUsage" default="">

<cfquery name="Total" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT count(*) as Total
    FROM   Ref_Object
	WHERE  1=1
	AND Objectusage = '#Form.ObjectUsage#'
	<cfif criteria neq "">
	AND    #preserveSingleQuotes(criteria)# 	
	</cfif>
</cfquery>

<cf_pagecountN show="15" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>			   

<cfquery name="SearchResult" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  TOP #last# *
    FROM    Ref_Object	
	WHERE   1=1
	AND Objectusage = '#Form.ObjectUsage#' 
	<cfif criteria neq "">
	AND    #preserveSingleQuotes(criteria)# 	 
	</cfif>
    ORDER BY Code
</cfquery>

<table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">

<tr><td height="14" colspan="4">
						 
	 <cfinclude template="ObjectNavigation.cfm">
	 				 
</td></tr>
<tr><td height="3"></td></tr>
<tr><td colspan="4" height="1" class="line"></td></tr>

<cfoutput query="SearchResult">

<cfif currentrow gte first>

	<tr class="navigation_row line">
	  
	    <td class="navigation_action" height="18" width="30" style="padding-left:3px;padding-top:3px" 
		onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#code#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ColdFusion.Window.hide('dialog#url.box#')</cfif>"><cf_img icon="open"></td>
		<td width="11%" class="labelit" style="padding-left:5px"><cfif codedisplay neq "">#CodeDisplay#<cfelse>#Code#</cfif></td>		
		<TD width="85%" class="labelit">#Description#</TD>
	</tr>
	
</cfif>	
		     
</CFOUTPUT>

<tr class="line"><td height="20" colspan="4">
						 
	 <cfinclude template="ObjectNavigation.cfm">
	 				 
</td></tr>

</TABLE>
 
</table>


<cfset AjaxOnLoad("doHighlight")>