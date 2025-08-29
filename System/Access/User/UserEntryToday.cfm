<!--
    Copyright © 2025 Promisan B.V.

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
<cfinvoke component="Service.Access"  
  method="useradmin" 
  treeaccess="yes"
  role="'AdminUser'"
  returnvariable="access">

<cfquery name="today" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT rTrim(U.Account) as Account, 
	       U.IndexNo, 
		   U.AccountType, 
		   U.LastName, 
		   U.FirstName, 
		   (SELECT  PersonNo 
		    FROM    Employee.dbo.Person
			WHERE   PersonNo = U.PersonNo ) as StaffRecord,				  
		   U.eMailAddress, 
		   U.AccountGroup,
		   U.PersonNo, 
		   U.Created, 
		   (SELECT LastConnection FROM skUserLastLogon WHERE Account = U.Account) as LastLogon,		  
		   U.disabled,
		   U.OfficerLastName,
		   U.OfficerFirstName,
		   U.Created
	FROM  UserNames U
	WHERE U.OfficerUserid = '#SESSION.acc#'
	AND   U.Created > getDate()-7
	ORDER BY U.Created
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0">
			
	<tr id="todayno">
	
	<td colspan="2">
	
		<table width="100%" border="0" align="right" class="navigation_table">
		
		<tr class="line labelmedium fixlengthlist">	
		
		<td height="22" width="40"></td>
		<td width="30%"><cf_tl id="Name"></td>
		<td width="100"><cf_tl id="Account"></td>
		<td width="100"><cfoutput>#client.indexNoName#</cfoutput></td>
		<td width="20%"><cf_tl id="EMail"></td>
		<td width="100"><cf_tl id="Group"></td>
		<td width="20%"><cf_tl id="Officer"></td>
		<td></td>
		</tr>
			
		<cfif today.recordcount eq "0">
		<tr><td height="1" colspan="8" class="line"></td></tr>
		<tr class="labelmedium"><td align="center" colspan="8"><font color="808080">No records to show in this view</font></td></tr>
		</cfif>
		
	
	<CFOUTPUT query="Today">
	
		<TR id="todayno" class="line navigation_row labelmedium2 fixlengthlist">
		  	  
		   <td align="center">
		   
		   <cfif AccountType eq "Group">
		   
		     <img src="#SESSION.root#/Images/group.png"
		     alt="Usergroup profile"
		     name="c2#currentRow#"
		     id="c2#currentRow#"
		     width="18"
		     height="18"
		     border="0"
		     align="absmiddle"
		     style="cursor: pointer;"
		     onClick="javascript:ShowUser('#URLEncodedFormat(Account)#')"
		     onMouseOver="document.c2#currentRow#.src='#SESSION.root#/Images/Button.jpg'"
		     onMouseOut="document.c2#currentRow#.src='#SESSION.root#/Images/group.png'">
			    
		   <cfelse>
		   
		     <img src="#SESSION.root#/Images/pointer.gif"
		     alt="User profile"
		     name="c2#currentRow#"
		     id="c2#currentRow#"
		     width="11"
		     height="11"
		     border="0"
		     align="absmiddle"
		     style="cursor: pointer;"
		     onClick="javascript:ShowUser('#URLEncodedFormat(Account)#')"
		     onMouseOver="document.c2#currentRow#.src='#SESSION.root#/Images/button.jpg'"
		     onMouseOut="document.c2#currentRow#.src='#SESSION.root#/Images/pointer.gif'">
		    	 
		   </cfif>	 
			
		   </td>
		
		   <TD>#LastName#, #FirstName#</td> 
		   <TD><a href="javascript:UserEdit('#Account#')">#Account#</a></TD>
		   
		   <TD>
		   <cfif staffrecord neq "">
			   <A HREF ="javascript:EditPerson('#PersonNo#')">#IndexNo#</a>
		   </cfif>
		   </TD>
		   <TD><cfif eMailAddress neq "">
			   <a href="javascript:email('#eMailAddress#','','','','User','#Account#')">
			   </cfif>#eMailAddress#
		   </TD>
		   <TD>#AccountGroup#</TD>	  
		   <td>#OfficerFirstName# #OfficerLastName#</td>
		   <td align="right" style="padding-right:4px">
		   
		   <cfif Access eq "EDIT" or Access eq "ALL">
			   <input type="checkbox" class="radiol" name="Account" id="Account" value="'#Account#'" onClick="hl(this,this.checked)">
		   </cfif>
		   </td>
		   
	   </TR>
	
	</CFOUTPUT> 
	
	</table>

</td></tr>

</table>

<cfset ajaxonload("doHighlight")>
