
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
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT count(*) as Total
    FROM   Ref_Standard
	WHERE  1=1
	<cfif criteria neq "">
	AND    #preserveSingleQuotes(criteria)# 	
	</cfif>
</cfquery>

<cf_pagecountN show="21" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>			   

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  TOP #last# *
    FROM    Ref_Standard
	WHERE   1=1
	<cfif criteria neq "">
	AND    #preserveSingleQuotes(criteria)# 	
	</cfif>
    ORDER BY Code
</cfquery>

<table style="width:100%" class="navigation_table">

<tr><td height="14" colspan="3">						 
	 <cfinclude template="Navigation.cfm">	 				 
</td></tr>
<cfoutput query="SearchResult">

<cfif currentrow gte first>

	<tr class="labelmedium2 navigation_row">	  
	    <td style="padding-top:3px" height="18" width="30">		
		   <cf_img icon="select" onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#code#','#url.box#','','','POST','')">					
		</td>
		<td width="60">#Code#</td>
		<TD width="80%">#Description#</TD>
	</tr>
	
</cfif>	
		     
</CFOUTPUT>

<tr><td height="20" colspan="3">						 
	 <cfinclude template="Navigation.cfm">	 				 
</td></tr>

</TABLE>
 

<cfset ajaxonload("doHighlight")>
