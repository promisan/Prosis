
<cfparam name="Form.Page"         default="1">
<cfparam name="Form.Group"        default="LastName">
<cfparam name="URL.Page"          default="#Form.Page#">
<cfparam name="URL.ID4"           default="">
<cfparam name="URL.IDSorting"     default="#Form.Group#">
<cfparam name="URL.Search"        default="">
<cfparam name="No"                default="999">

<CFSET Criteria = ''>

<cfif Form.Crit0_Value neq "">

	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit0_FieldName#"
	    FieldType="#Form.Crit0_FieldType#"
	    Operator="#Form.Crit0_Operator#"
	    Value="#Form.Crit0_Value#">
	
</cfif>	

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
	
<cfset Crit = " Disabled = #Form.Status#">	

<cfif Criteria eq "">
    <cfset Criteria = Crit>
<cfelse>
    <cfset Criteria = "#Criteria# AND #Crit#">
</cfif>
	
<cfset CLIENT.search = Criteria>

<cfset link    = replace(url.link,"||","&","ALL")>

<cfquery name="Total" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT count(*) as Total
	FROM   UserNames U
	WHERE  #PreserveSingleQuotes(CLIENT.search)# 
	<cfif url.filter3 eq "accounttype">	
		<cfif url.filter3value neq "all">
		AND   AccountType = '#url.filter3value#'
		</cfif>
	<cfelse>
		AND   AccountType = 'Individual'	
	</cfif>
	<cfif url.filter1 eq "mission">
		AND   Account IN (SELECT   U.Account
						 FROM     Organization.dbo.Organization AS O INNER JOIN
			                      Employee.dbo.PersonAssignment AS PA ON O.OrgUnit = PA.OrgUnit INNER JOIN
	                              UserNames AS U ON PA.PersonNo = U.PersonNo
						 WHERE    PA.AssignmentStatus IN ('0', '1') 
						 AND      PA.DateEffective < GETDATE() 
						 AND      PA.DateExpiration >= GETDATE() 
						 AND      O.OrgUnit IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE Mission = '#url.filter1value#') 
						 AND      PA.AssignmentType = 'Actual')
	
	<cfelseif url.filter1 eq "orgunit">
	   AND   Account IN (SELECT   U.Account
						 FROM     Organization.dbo.Organization AS O INNER JOIN
			                      Employee.dbo.PersonAssignment AS PA ON O.OrgUnit = PA.OrgUnit INNER JOIN
	                              UserNames AS U ON PA.PersonNo = U.PersonNo
						 WHERE    PA.AssignmentStatus IN ('0', '1') 
						 AND      PA.DateEffective < GETDATE() 
						 AND      PA.DateExpiration >= GETDATE() 
						 AND      O.OrgUnit = '#url.filter1value#' 
						 AND      PA.AssignmentType = 'Actual')
	
	
	<cfelseif url.filter1 neq "">
		AND   Account IN (SELECT Account 
		                  FROM   UserNamesGroup 
						  WHERE  AccountGroup = '#url.filter1value#')
	</cfif>
	<cfif url.filter2 eq "onboard" and getAdministrator("*") eq "0">
	AND       PersonNo IN (SELECT PersonNo 
	                       FROM   Employee.dbo.vwAssignment
						   WHERE  DateEffective <= getDate() and DateExpiration >= getDate()
						   AND    PersonNo = U.PersonNo
						   AND    AssignmentStatus IN ('0','1'))						
	</cfif>
	AND   LastName > '' 
	AND   Disabled = 0
</cfquery>

<cfset show = int((url.height-510)/19)>

<cf_pagecountN show="#show#" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>		

<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP #last# *
	FROM   UserNames U
	WHERE #PreserveSingleQuotes(CLIENT.search)# 
	<cfif url.filter3 eq "accounttype">	
		<cfif #url.filter3value# neq "all">
		AND   AccountType = '#url.filter3value#'
		</cfif>
	<cfelse>
		AND   AccountType = 'Individual'	
	</cfif>
	<cfif url.filter1 eq "mission">
		AND   Account IN (SELECT   U.Account
						 FROM     Organization.dbo.Organization AS O INNER JOIN
			                      Employee.dbo.PersonAssignment AS PA ON O.OrgUnit = PA.OrgUnit INNER JOIN
	                              UserNames AS U ON PA.PersonNo = U.PersonNo
						 WHERE    PA.AssignmentStatus IN ('0', '1') 
						 AND      PA.DateEffective < GETDATE() 
						 AND      PA.DateExpiration >= GETDATE() 
						 AND      O.OrgUnit IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE Mission = '#url.filter1value#') 
						 AND      PA.AssignmentType = 'Actual')
	
	<cfelseif url.filter1 eq "orgunit">
	   AND   Account IN (SELECT   U.Account
						 FROM     Organization.dbo.Organization AS O INNER JOIN
			                      Employee.dbo.PersonAssignment AS PA ON O.OrgUnit = PA.OrgUnit INNER JOIN
	                              UserNames AS U ON PA.PersonNo = U.PersonNo
						 WHERE    PA.AssignmentStatus IN ('0', '1') 
						 AND      PA.DateEffective < GETDATE() 
						 AND      PA.DateExpiration >= GETDATE() 
						 AND      O.OrgUnit = '#url.filter1value#' 
						 AND      PA.AssignmentType = 'Actual')
	
	
	<cfelseif url.filter1 neq "">
		AND   Account IN (SELECT Account 
		                  FROM   UserNamesGroup 
						  WHERE  AccountGroup = '#url.filter1value#')
	</cfif>
	<cfif url.filter2 eq "onboard" and getAdministrator("*") eq "0">
	AND    PersonNo IN (SELECT PersonNo 
	                    FROM   Employee.dbo.vwAssignment
						WHERE  DateEffective <= getDate() and DateExpiration >= getDate()
						AND    PersonNo = U.PersonNo
						AND    AssignmentStatus IN ('0','1'))						
	</cfif>
	AND    LastName > '' and Disabled = 0
	ORDER BY #URL.IDSorting#	
</cfquery>

<cfinvoke component="Service.Access"  
	   method="useradmin" 
	   returnvariable="access">	
   
<table width="100%" align="center">

<tr><td height="5"></td></tr>

<tr><td colspan="3" style="height:20px">						 
	 <cfinclude template="UserNavigation.cfm">	 				 
</td></tr>  

<tr>

	<td width="100%" colspan="2">
						
			<table width="100%" align="center" class="navigation_table">
			
			<TR class="line labelmedium fixrow fixlengthlist">
			    <td></td>			   
			    <TD><cf_tl id="Name"></TD>
				<TD style="padding-left:1px"><cf_tl id="IndexNo"></TD>
			    <TD style="padding-left:1px"><cf_tl id="eMail"></TD>
			    <TD></TD>	  
			</TR>
									
			<cfif counted eq "0">			
				<tr><td height="30" class="labelmedium" align="center" colspan="5"><font color="808080">There are no records to show in this view.</font></td></tr>
			</cfif>  
			
			<cfset currrow = 0>
											
			<CFOUTPUT query="SearchResult" group="LastName">
			
			   <cfif currrow lt last and currrow gte first>		
			   				 
				   <cfswitch expression = "#URL.IDSorting#">
				   
				     <cfcase value = "AccountGroup">
					 <tr height="20" bgcolor="f3f3f3" class="line">
				         <td colspan="5" style="padding-left:4px"><font size="1"><b>&nbsp;#AccountGroup#</b></font></td>
					 </tr>					
				     </cfcase>
				     <cfcase value = "LastName">
				     <!--- <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#LastName#</b></font></td> --->
				     </cfcase>	 
				     <cfcase value = "Account">
				     <!--- <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</b></font></td> --->
				     </cfcase>
				     <cfdefaultcase>
					 <tr bgcolor="E8E8CE" class="line">
				         <td colspan="8" style="padding-left:4px"><font size="1"><b>&nbsp;#AccountGroup#<b></font></td>
					 </tr>					 
				     </cfdefaultcase>
				   </cfswitch>
				   				      
			   </cfif>
				
			   <cfoutput>			
			   
			   <cfparam name="url.form" default="">	   
								   
			   <cfset currrow = currrow + 1>
			   				
				   <cfif currrow lte last and currrow gte first>
				   				
					   <TR class="navigation_row labelmedium line fixlengthlist" style="height:20px">
					  
						   <td  height="18" align="center" style="padding-top:1px;padding-right:7px"
								class="navigation_action"  
						   	    onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#account#','#url.box#','','','POST','#url.form#');<cfif url.close eq 'Yes'>ProsisUI.closeWindow('dialog#url.box#')</cfif>">
						        <cf_img icon="select">					   
						   </td>
						   
						   <cfif accounttype eq "Individual">
						   <td>#LastName# <cfif firstname neq "">, #FirstName#</cfif></td>						   						   						   
						   <td>#IndexNo#</td>	
						   <td title="#emailaddress#">
						   <cfif eMailAddress neq ""><a href="javascript:email('#eMailAddress#','','','','User','#Account#')"></cfif>#eMailAddress#					   
						   </td>
						   <cfelse>
						   <td colspan="3"><font color="FF0080">ug:&nbsp;</font>#LastName#</td>		
						   </cfif>
						  					   
						    <td style="padding-top:2px">
							   <cfif Access eq "EDIT" or Access eq "ALL">
							   <cf_img icon="open" onclick="javascript:ShowUser('#URLEncodedFormat(Account)#')">
							   </cfif>
						   </td>						   						   			   
										          
					   </TR>
					     
			   </cfif>
			  		
		   </cfoutput>		   		  
		   
		</CFOUTPUT>
				
		</TABLE>
		
	</td>
</tr>	

<tr><td height="20" style="height:30px" colspan="3">						 
	 <cfinclude template="UserNavigation.cfm">	 				 
</td></tr>
</table>

<cfset AjaxOnLoad("doHighlight")>
