
<cfset criteria = "">
<cfparam name="Form.Crit1_Value" default="">
<cfparam name="Form.Crit2_Value" default="">

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


<cfset link    = replace(url.link,"||","&","ALL")>

 <cfquery name="Mandate" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT  * 
   FROM    Ref_Mandate
   WHERE   #url.filter1# = '#url.filter1value#'
   <cfif url.filter2 neq "">
   AND #url.filter2# = '#url.filter2value#'
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
    FROM Organization
	WHERE Mission     = '#mis#'
	AND   MandateNo   = '#man#'
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
    FROM Organization
	WHERE Mission     = '#mis#'
	AND   MandateNo   = '#man#'
	<cfif criteria neq "">
	AND #preserveSingleQuotes(criteria)# 	
	</cfif>
ORDER BY HierarchyCode
</cfquery>

<table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">

<tr><td height="14" colspan="4">
						 
	 <cfinclude template="OrganizationNavigation.cfm">
	 				 
</td></tr>


<cfoutput query="SearchResult">

<cfif currentrow gte first>

	<tr class="navigation_row">
	  
	    <td height="18" width="30" class="navigation_action" onclick="ColdFusion.navigate('#link#&action=insert&#url.des1#=#orgunit#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ColdFusion.Window.hide('dialog#url.box#')</cfif>">&nbsp;
			  					   
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
		<td width="60">#OrgUnitCode#</td>
		<TD width="20%">#OrgUnitNameShort#</TD>
		<TD width="60%">#OrgUnitName#</TD>
	</tr>
	
</cfif>	
		     
</CFOUTPUT>

<tr><td height="2"></td></tr>
<tr><td colspan="4" bgcolor="silver"></td></tr>

<tr><td height="14" colspan="4">
						 
	 <cfinclude template="OrganizationNavigation.cfm">
	 				 
</td></tr>

</TABLE>
 
</table>


<cfset AjaxOnLoad("doHighlight")>