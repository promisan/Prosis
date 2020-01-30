
<!--- Create Criteria string for query from data entered thru search form --->

<cftry>

<CFSET Criteria = ''>
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
		
	<cfcatch>
	
		<table align="center">
		<tr><td height="30" align="center">
				<font face="Verdana" color="0080FF">An error occurred processing this request.</font>
		</td></tr>
		</table>		
		
		<cfabort>
	
	</cfcatch>	

</cftry>

<cfparam name="Form.Nationality" default="">	

<cfif Form.Nationality IS NOT "">
     <cfif Criteria is ''>
	 <CFSET Criteria = "Nationality IN (#PreserveSingleQuotes(Form.Nationality)# )">
	 <cfelse>
	 <CFSET Criteria = #Criteria#&" AND Nationality IN ( #PreserveSingleQuotes(Form.Nationality)# )" >
     </cfif>
</cfif> 	

<cfparam name="form.Contract" default="0">

<cfoutput>

<cfsavecontent variable="qry">

	FROM  Applicant	P
	<cfif PreserveSingleQuotes(Criteria) neq "">
	WHERE #PreserveSingleQuotes(Criteria)# 
	<cfelse>
	WHERE P.PersonNo is not NULL
	</cfif>
				
</cfsavecontent>
</cfoutput>


<cfquery name="Total" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT count(*) as Total 
    #preserveSingleQuotes(qry)#	
</cfquery>

<cfset show = int((url.height-350)/20)>

<cf_pagecountN show="#show#" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>		

<cfquery name="SearchShow" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP #last# *
    #preserveSingleQuotes(qry)#	
	ORDER BY LastName, FirstName, MiddleName 
</cfquery>

<!--- check access --->
				
<cfinvoke component = "Service.Access"  
   method           = "staffing" 		  
   returnvariable   = "accessStaffing">	  

<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table" id="t_result"> 
  
  <tr><td colspan="2" valign="top">

	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	
	<cfset link    = replace(url.link,"||","&","ALL")>
	<cfset currrow = 0>
	
	<!--- example for contributioj to allow quick adding --->
	
	<cfif findNoCase("insert=yes",url.link)>
	
	<tr>
	   <td height="28" class="labelmedium" colspan="7">
		   <table width="100%">
			   <tr>
				  
				  <cfoutput>
				   <td class="labelmedium">
				      <a href="javascript:lookuppersonadd('#url.box#','#link#')"><font color="6688aa"><cf_tl id="Register a new person"></a>
				   </td>
				  </cfoutput> 
				   
			   </tr>
		   </table>
	   </td>
	   <td align="right"></td>
	</tr> 	
	
	</cfif>
	
	<cfif searchshow.recordcount eq "0">
	
		<tr><td height="14" align="center" colspan="7" class="labelmedium">
			<cf_tl id="There are no records to show in this view">
		</td></tr>
		
	<cfelse>
	
		<tr><td height="24" colspan="8">
			 <cfinclude template="PersonNavigation.cfm">
		</td></tr>
		
		<TR>
		    <td height="20"></td>		   
			<TD class="labelit"><cf_tl id="Name"></TD>
		    <TD class="labelit"><cf_tl id="Nat."></TD>
			<TD class="labelit"><cf_tl id="S"></TD>
			<TD class="labelit"><cf_tl id="Index No"></TD>
			<cfif accessstaffing neq "NONE">
			<TD class="labelit"><cf_tl id="Id"></TD>
			<TD class="labelit"><cf_tl id="DOB"></TD>			
			</cfif>
		</TR>
	
	</cfif>
			
	<CFOUTPUT query="SearchShow">
	
	<cfset currrow = currrow + 1>
	 
	<cfif currrow lte last and currrow gte first>		
		
		<tr><td height="0" colspan="8" class="linedotted"></td></tr>
				
		<TR class="navigation_row labelit">
		
		
			
			<TD width="30" align="center" style="height:18;padding-top:2px"
			  class="navigation_action"
			  onclick="ColdFusion.navigate('#link#&action=insert&#url.des1#=#personno#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ColdFusion.Window.hide('dialog#url.box#')</cfif>">			
				<cf_img icon="select">				  
			</TD>						
			<TD>#LastName#, #FirstName# #MiddleName#</font></TD>
			<TD>#Nationality#</font></TD>
			<TD>#Gender#</font></TD>			
			<cfif accessstaffing neq "NONE">
			<TD><A title="View profile" href="javascript:EditPerson('#PersonNo#','#IndexNo#')"><font color="6688aa">#IndexNo#</a></TD>			
			<td>#PersonNo#</td>
			<TD>#DateFormat(DOB, CLIENT.DateFormatShow)#</TD>			
			<cfelse>
			<TD>#IndexNo#</TD>						
			</cfif>
			
		</TR>
		
		<!---
		<cfif OrganizationName neq "">
			<tr class="navigation_row_child">
				<td></td>
				<cfif accessstaffing neq "NONE">
					<td colspan="7" class="labelit">#OrganizationName#</td>
				<cfelse>
					<td colspan="4" class="labelit">#OrganizationName#</td>
				</cfif>
			</tr>	
		</cfif>
		--->
		
	</cfif>
	
	</CFOUTPUT>
	
	<cfif searchshow.recordcount neq "0">	
	<tr><td height="24" colspan="8">
	     <cfinclude template="PersonNavigation.cfm">
	</td></tr>	
	</cfif>

	</TABLE>

	</td></tr>

</table>

<cfif searchshow.recordcount gt 0>
	<cfset AjaxOnLoad("doHighlight")>
</cfif>

