
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

<!---

<cfif Form.Crit3_Value neq "">

	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit3_FieldName#"
	    FieldType="#Form.Crit3_FieldType#"
	    Operator="#Form.Crit3_Operator#"
	    Value="#Form.Crit3_Value#">
	
</cfif>	


<cfif Form.Crit4_Value neq "">

	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit4_FieldName#"
	    FieldType="#Form.Crit4_FieldType#"
	    Operator="#Form.Crit4_Operator#"
	    Value="#Form.Crit4_Value#">
	
</cfif>	

--->

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
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr>
 
<td width="100%" colspan="2" valign="top" style="padding:10px">

<!--- Query returning search results --->

<cfparam name="url.datasource" default="appsSystem">

<cfif url.datasource eq "">
	 <cfset url.datasource = "appsSystem">
</cfif>

<cfquery name="Total" 
datasource="#url.datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT count(*) as Total
    FROM   CountryTaxCode
	WHERE   1=1	
	<cfif criteria neq "">
	AND    #preserveSingleQuotes(criteria)# 	
	</cfif>
	<cfif filter1 eq "Country">	
	AND   Country = '#filter1value#'
	</cfif>
</cfquery>

<cf_pagecountN show="16" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>	

<cf_verifyOperational module="WorkOrder" Warning="No">

<cfquery name="SearchResult" 
datasource="#url.datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT TOP #last# *
    FROM CountryTaxCode as V
	WHERE 1=1 	
	
	<cfif filter1 eq "Country">	
	AND   Country = '#filter1value#'
	</cfif>
	 
	<cfif criteria neq "">
	AND  #preserveSingleQuotes(criteria)#
	</cfif>
			
</cfquery>

<table width="100%" class="navigation_table">

<tr><td height="14" colspan="5">
						 
	 <cfinclude template="TaxNavigation.cfm">
	 				 
</td></tr>

<cfoutput query="SearchResult">

<cfif currentrow gte first>

	<tr class="navigation_row line labelmedium fixlengthlist" style="height:21px">
		  
	    <td width="35" style="padding-top:2px;padding-left:5px;padding-right:6px" class="navigation_action" 
		 onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#taxcode#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ProsisUI.closeWindow('dialog#url.box#')</cfif>">			  
			<cf_img icon="select">						
		</td>
		<td width="15%">#TaxCode#</td>
		<TD width="80%">#TaxName#</TD>
		<!---
		<TD width="15%" class="labelit">#PhoneNumber#</TD>
		<TD width="20%" class="labelit">#eMailAddress#</TD>
		--->
	</tr>
		
</cfif>	
		     
</CFOUTPUT>

<tr><td height="2"></td></tr>
<tr><td colspan="5" class="line"></td></tr>

<tr><td height="14" colspan="5">
						 
	 <cfinclude template="TaxNavigation.cfm">
	 				 
</td></tr>

</TABLE>
 
</table>

<cfset AjaxOnLoad("doHighlight")>
