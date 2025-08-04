<!--
    Copyright © 2025 Promisan

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

	<cfif Form.Crit8_Value eq "Individual">
	
		<cfsavecontent variable="sel">
		   ,(SELECT count(*) FROM System.dbo.UserNames AS U INNER JOIN
            Applicant.dbo.ApplicantSubmission AS S ON U.ApplicantNo = S.ApplicantNo AND S.PersonNo = P.PersonNo) as UserAccount
		</cfsavecontent>	
	
		<cfsavecontent variable="qry">
	
			FROM  Applicant	P
			<cfif PreserveSingleQuotes(Criteria) neq "">
			WHERE #PreserveSingleQuotes(Criteria)# 
			<cfelse>
			WHERE P.PersonNo is not NULL
			</cfif>
		
		</cfsavecontent>
	
	<cfelse>
	
		<cfsavecontent variable="sel">		
		  ,(SELECT count(*) FROM System.dbo.UserNames WHERE PersonNo = P.PersonNo) as UserAccount
		</cfsavecontent>	
			
		<cfsavecontent variable="qry">
	
			FROM  Employee.dbo.Person	P
			<cfif PreserveSingleQuotes(Criteria) neq "">
			WHERE #PreserveSingleQuotes(Criteria)# 
			<cfelse>
			WHERE P.PersonNo is not NULL
			</cfif>	
		
		</cfsavecontent>
	
	</cfif>
				
</cfoutput>

<cfquery name="Total" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT count(*) as Total 
    #preserveSingleQuotes(qry)#	
</cfquery>

<cfset show = int((url.height-350)/27)>

<cf_pagecountN show="#show#" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>		

<cfquery name="SearchShow" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  TOP #last# * #preserveSingleQuotes(sel)#
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
				      <a href="javascript:lookuppersonadd('#url.box#','#link#')"><cf_tl id="Register a new person"></a>
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
		
		<TR class="fixrow labelmedium line fixlengthlist">
		    <td height="20"></td>		   
			<TD><cf_tl id="Name"></TD>
			<td><cf_tl id="User"></td>
		    <TD><cf_tl id="Nat"></TD>
			<TD><cf_tl id="G"></TD>
			<TD><cf_tl id="Index No"></TD>
			<cfif accessstaffing neq "NONE">
			<TD><cf_tl id="Id"></TD>
			<TD><cf_tl id="DOB"></TD>			
			</cfif>
		</TR>
	
	</cfif>
			
	<CFOUTPUT query="SearchShow">
	
		<cfset currrow = currrow + 1>
		 
		<cfif currrow lte last and currrow gte first>				
					
			<TR class="navigation_row labelmedium line fixlengthlist">				
				<TD width="30" align="center" style="height:18;padding-top:2px"
				  class="navigation_action"
				  onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#personno#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ProsisUI.closeWindow('dialog#url.box#')</cfif>">			
					<cf_img icon="select">				  
				</TD>						
				<TD>#LastName#, #FirstName# #MiddleName#</TD>
				<cfif UserAccount gte "1">
				<td style="padding-top:3px"><img src="#session.root#/images/user.png" alt="" width="25" height="19" border="0" title="Has a user account">#useraccount#</td>
				<cfelse>
				<td></td>
				</cfif>
				<TD>#Nationality#</font></TD>
				<TD>#Gender#</font></TD>			
				<cfif accessstaffing neq "NONE">
				<TD style="padding-left:3px"><A title="View profile" href="javascript:EditPerson('#PersonNo#','#IndexNo#')">#IndexNo#</TD>			
				<td>#PersonNo#</td>
				<cfif Form.Crit8_Value eq "Individual">
				<TD>#DateFormat(DOB, CLIENT.DateFormatShow)#</TD>			
				<cfelse>
				<TD>#DateFormat(BirthDate, CLIENT.DateFormatShow)#</TD>		
				</cfif>
				<cfelse>
				<TD>#IndexNo#</TD>						
				</cfif>			
			</TR>	
			
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

