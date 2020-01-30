<!--- Query returning search results --->

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
		
		<tr class="line labelmedium">	
		
		<td height="22" width="40"></td>
		<td width="30%">Name</td>
		<td width="100">Account</td>
		<td width="100">IndexNo</td>
		<td width="20%">EMail</td>
		<td width="100">Group</td>
		<td width="20%">Officer</td>
		<td></td>
		</tr>
			
		<cfif today.recordcount eq "0">
		<tr><td height="1" colspan="8" class="line"></td></tr>
		<tr class="labelmedium"><td align="center" colspan="8"><font color="808080">No records to show in this view</font></td></tr>
		</cfif>
		
	
	<CFOUTPUT query="Today">
	
		<TR bgcolor="ffffff" id="todayno" class="line navigation_row">
		  	  
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
		
		   <TD class="labelit"><a href="javascript:ShowUser('#URLEncodedFormat(Account)#')">#LastName#, #FirstName#</a></td> 
		   <TD class="labelit"><a href="javascript:UserEdit('#Account#')">#Account#</a></TD>
		   
		   <TD class="labelit"><A HREF ="javascript:EditPerson('#PersonNo#')">#IndexNo#</a></TD>
		   <TD class="labelit"><cfif eMailAddress neq "">
			   <a href="javascript:email('#eMailAddress#','','','','User','#Account#')">
			   </cfif>#eMailAddress#
		   </TD>
		   <TD class="labelit">#AccountGroup#</TD>	  
		   <td width="150" class="labelit">#OfficerFirstName# #OfficerLastName#</td>
		   <td align="right" style="padding-right:4px">
		   
		   <cfif Access eq "EDIT" or Access eq "ALL">
			   <input type="checkbox" name="Account" id="Account" value="'#Account#'" onClick="hl(this,this.checked)">
		   </cfif>
		   </td>
		   
	   </TR>
	
	</CFOUTPUT> 
	
	</table>

</td></tr>

</table>

<cfset ajaxonload("doHighlight")>
