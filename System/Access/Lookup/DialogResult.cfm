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

<TITLE>User Administration</TITLE>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.Page" default="1">
<cfparam name="Form.Group" default="AccountGroup">
<cfparam name="URL.Page" default="#Form.Page#">
<cfparam name="URL.IDSorting" default="#Form.Group#">

<CFOUTPUT>

<script>

function reloadForm(grp, page) {
  location = "DialogResult.cfm?page="+page+"&idsorting="+grp+"&FormName=#URL.FormName#&flduserid=#URL.flduserid#&fldlastname=#URL.fldlastname#&fldfirstname=#URL.fldfirstname#&&fldname=#URL.fldname#"
}
	
function sel(id,last,first)
{
	
	    var form     = "#URL.FormName#";
		var fldid    = "#URL.flduserid#";
		var fldlast  = "#URL.fldlastname#";
		var fldfirst = "#URL.fldfirstname#";
		var fldname  = "#URL.fldname#";
		eval("self.opener.document." + form + "." + fldid + ".value    = id");	
		eval("self.opener.document." + form + "." + fldlast + ".value  = last");
		eval("self.opener.document." + form + "." + fldfirst + ".value = first");
		eval("self.opener.document." + form + "." + fldname + ".value  = first+' '+last");
		window.close();
}
</script>

</CFOUTPUT>

<!--- Query returning search results --->

<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  UserNames 
	WHERE #PreserveSingleQuotes(CLIENT.search)#
	ORDER BY #URL.IDSorting#
</cfquery>
   
<cf_dialogStaffing>

<HTML><HEAD></HEAD>

<form action="UserBatch.cfm" method="post" name="result">

<body leftmargin="0" topmargin="0" rightmargin="0" onLoad="javascript:document.forms.result.page.focus();">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<td width="100%" colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#C9D3DE">

<tr>

<td height="30" align="left">&nbsp;

<select name="group" id="group" size="1" style="background: #C9D3DE;" onChange="javascript:reloadForm(this.value,page.value)">
     <option value="AccountGroup" <cfif #URL.IDSorting# eq "AccountGroup">selected</cfif>>Group by Group
     <OPTION value="LastName" <cfif #URL.IDSorting# eq "LastName">selected</cfif>>Group by Name
     <OPTION value="Account" <cfif #URL.IDSorting# eq "Account">selected</cfif>>Group by Account
</SELECT> 

</TD>

<td align="right">&nbsp;
	   <cfinclude template="../../../Tools/PageCount.cfm">
<select name="page" id="page" size="1" style="background: #C9D3DE;" onChange="javascript:reloadForm(group.value,this.value)">
    <cfloop index="Item" from="1" to="#pages#" step="1">
        <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
    </cfloop>	 
</SELECT>&nbsp;</td>

</tr>
<TR>

<td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" rules="rows">

<TR>
    <td class="top4N"></td>
    <TD class="top4N">&nbsp;Account</TD>
    <TD class="top4N">LastName</TD>
    <TD class="top4N">FirstName</TD>
    <TD class="top4N">eMail</TD>
    <TD class="top4N">Group</TD>
	<TD class="top4N">IndexNo</TD>
	<TD class="top4N">Created</TD>
    <TD class="top4N"></TD>
</TR>

<cfset currrow = 0>

<CFOUTPUT query="SearchResult" group="#URL.IDSorting#" startrow=#first#>

   <cfif currrow lt No>

   <tr bgcolor="ffffcf">

   <cfswitch expression = #URL.IDSorting#>
     <cfcase value = "AccountGroup">
     <td colspan="9"><font face="Verdana" size="2"><b>&nbsp;#AccountGroup#</b></font></td>
     </cfcase>
     <cfcase value = "LastName">
     <!--- <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#LastName#</b></font></td> --->
     </cfcase>	 
     <cfcase value = "Account">
     <!--- <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</b></font></td> --->
     </cfcase>
     <cfdefaultcase>
     <td colspan="9"><font face="Verdana" size="2"><b>&nbsp;#AccountGroup#<b></font></td>
     </cfdefaultcase>
   </cfswitch>
   
   </tr>
   
   </cfif>

   <cfoutput>
   
   <cfset currrow = currrow + 1>

   <cfif currrow lte No>

   <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('fbfbfb'))#">
  
	   <td bgcolor="FFFFFF" width="5%" align="right" valign="top">
	    <img 
		 onMouseOver="document.result.img_#currentrow#.src='#SESSION.root#/Images/Button.jpg'" 
		 onMouseOut="document.result.img_#currentrow#.src='#SESSION.root#/Images/view.JPG'"
		 src="#SESSION.root#/Images/view.JPG" alt="" id="img_#currentrow#" width="13" height="16" border="0" align="middle" 
		 onClick="javascript:sel('#Account#','#LastName#','#FirstName#')">	  
	   </TD>
	   <TD style="padding-left:4px"><a href="javascript:ShowUser('#Account#')">#Account#</a></TD>
	   <TD>#LastName#</TD>
	   <TD>#FirstName#</TD>
	   <TD>#eMailAddress#</TD>
	   <TD>#AccountGroup#</TD>
	   <TD><A HREF ="javascript:ShowPerson('#PersonNo#')"><font color="0080C0">#IndexNo#</a></TD>
	   <TD>#DateFormat(Created, CLIENT.DateFormatShow)#</td>
	   <td align="center">
	   <!--- <input type="checkbox" name="Account" value="'#Account#'" onClick="hl(this,this.checked)"> --->
	   </td>
        
   </TR>
         
   </cfif>

   </cfoutput>
   
</CFOUTPUT>

</TABLE>
</TABLE>
</td>
</table>

</BODY></HTML>