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

<cfparam name="Form.Page"     default="1">
<cfparam name="Form.Group"    default="LastName">
<cfparam name="URL.Page"      default="#Form.Page#">
<cfparam name="URL.ID4"       default="">
<cfparam name="URL.IDSorting" default="#Form.Group#">
<cfparam name="URL.Search"    default="">
<cfparam name="No"    default="999">

<CFSET Criteria = ''>

<cfif #Form.Crit1_Value# neq "">

<CF_Search_AppendCriteria
    FieldName="#Form.Crit1_FieldName#"
    FieldType="#Form.Crit1_FieldType#"
    Operator="#Form.Crit1_Operator#"
    Value="#Form.Crit1_Value#">
	
</cfif>	
	
<cfif #Form.Crit2_Value# neq "">	
	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit2_FieldName#"
    FieldType="#Form.Crit2_FieldType#"
    Operator="#Form.Crit2_Operator#"
    Value="#Form.Crit2_Value#">

</cfif>

<cfif Form.Crit4_Value neq "">	

<CF_Search_AppendCriteria
    FieldName="#Form.Crit4_FieldName#"
    FieldType="#Form.Crit4_FieldType#"
    Operator="#Form.Crit4_Operator#"
    Value="#Form.Crit4_Value#">	
	
</cfif>	
	
<cfset Crit = " Disabled = #Form.Status#">	

<cfif Criteria eq "">
    <cfset Criteria = Crit>
<cfelse>
    <cfset Criteria = "#Criteria# AND #Crit#">
</cfif>
	
<cfset CLIENT.search          = Criteria>

<cfset link    = replace(url.link,"||","&","ALL")>

<cfquery name="Total" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT count(*) as Total
	FROM   UserNames 
	WHERE  #PreserveSingleQuotes(CLIENT.search)# 
	AND    AccountType != 'Individual'	
</cfquery>

<cf_pagecountN show="14" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>		

<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP #last# *
	FROM     UserNames 
	WHERE    #PreserveSingleQuotes(CLIENT.search)# 
	AND      AccountType != 'Individual'	
	ORDER BY #URL.IDSorting#
</cfquery>

<cfinvoke component="Service.Access"  
	   method="useradmin" 
	   returnvariable="access">	
   
<table width="99%" align="center">
  
<tr><td height="14" colspan="3">						 
	 <cfinclude template="UserGroupNavigation.cfm">	 				 
</td></tr>  

<tr>

	<td width="100%" colspan="2">
	
		<table width="100%">
		
			<tr>
		
			<td colspan="2">
			
			<table width="100%" align="center" class="navigation_table">
			
			<TR class="labelmedium line fixlengthlist">
			    <td style="max-width:30px"></td>
				<TD><cf_tl id="Group name"></TD>
			    <TD><cf_tl id="Account"></TD>			   
			    <TD><cf_tl id="eMail"></TD>			   
			</TR>
			
			<cfset currrow = 0>
			
								
			<CFOUTPUT query="SearchResult" group="LastName">
			
			   <cfif currrow lt last and currrow gte first>		
			   				 
				   <cfswitch expression = #URL.IDSorting#>
				     <cfcase value = "AccountGroup">
					 <tr class="labelmedium line fixlengthlist" height="20" bgcolor="f3f3f3">
				     <td colspan="4"><b>#AccountGroup#</b></font></td>
					 </tr>
				     </cfcase>
				     <cfcase value = "LastName">
				     <!--- <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#LastName#</b></font></td> --->
				     </cfcase>	 
				     <cfcase value = "Account">
				     <!--- <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</b></font></td> --->
				     </cfcase>
				     <cfdefaultcase>
					 <tr bgcolor="E8E8CE">
				    	 <td class="labelmedium" colspan="4"><b>#AccountGroup#<b></td>
					 </tr>
				     </cfdefaultcase>
				   </cfswitch>
				   				      
			   </cfif>
				
			   <cfoutput>				   
								   
			   <cfset currrow = currrow + 1>
			   				
				   <cfif currrow lte last and currrow gte first>				   
					  					
					   <TR class="navigation_row line labelmedium fixlengthlist" style="height:20px" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('fbfbfb'))#">
					  
						   <td style="height:20px;padding-top:1px" class="navigation_action" onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#account#','#url.box#','','','POST','')">					   
						       <cf_img icon="select">						   
						   </td>							
						  
						   <TD>#LastName#</TD>						   
						   <TD>						   
							   <cfif Access eq "EDIT" or Access eq "ALL">
							   		<a href="javascript:ShowUser('#URLEncodedFormat(Account)#')" title="Open profile">#Account#</a>
							   <cfelse>
								    #Account# 
						       </cfif>						   
						   </TD>								   
						   <TD>
							   <cfif eMailAddress neq "">
							   <a href="javascript:email('#eMailAddress#','','','','User','#Account#')">#eMailAddress#</a>
							   <cfelse>
							   #eMailAddress#
							   </cfif>						   
						   </TD>					   		   
										          
					   </TR>
			  		     
			   </cfif>
			  		
		   </cfoutput>		   		  
		   
		</CFOUTPUT>
				
		</TABLE>
		</td>
		</tr>
		
		</TABLE>
		
	</td>
</tr>	

<tr><td height="14" colspan="3">						 
	 <cfinclude template="UserGroupNavigation.cfm">	 				 
</td></tr>

</table>

<cfset AjaxOnLoad("doHighlight")>