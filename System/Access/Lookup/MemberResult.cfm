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
<TITLE>User Administration</TITLE>

<div style="position:absolute;width=100%;height:100%; overflow: auto; scrollbar-face-color: F4f4f4;">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
	
<!--- Query returning search results --->

<cfparam name="Form.Page" default="1">
<cfparam name="Form.Group" default="AccountGroup">
<cfparam name="URL.Page" default="#Form.Page#">
<cfparam name="URL.ID4" default="">
<cfparam name="URL.IDSorting" default="#Form.Group#">
<cfparam name="URL.Search" default="">

<cfoutput>

<script>

function sel(id,last,first) {
	
	    var form     = "#URL.Form#";
		var fldid    = "#URL.id#";
		var fldlast  = "#URL.id1#";
		var fldfirst = "#URL.id2#";
		var fldname  = "#URL.id3#";
		eval("self.opener.document." + form + "." + fldid  + ".value = id");	
		eval("self.opener.document." + form + "." + fldlast + ".value = last");
		eval("self.opener.document." + form + "." + fldfirst + ".value = first");
		window.close();
}

function process(acc,formgoto) {

if (formgoto == "groupmember") {
    window.location="#SESSION.root#/System/Access/Membership/UserMemberSubmit.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ACC=" + acc;
} else {

if (formgoto == "rosteraccess") {
    window.location="#SESSION.root#/Roster/Maintenance/Access/UserAccess.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ACC=" + acc;
} else {

if (formgoto == "rosterbucket") {
    window.location="#SESSION.root#/Roster/Maintenance/Access/UserBucketAccessSubmit.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ACC=" + acc;
} else {
if (formgoto == "stepfly") {
    window.location="#SESSION.root#/Tools/EntityAction/ProcessActionAccess.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ACC=" + acc;
} else {
	
if (formgoto == "workflow") {
	window.location="#SESSION.root#/Vacancy/Maintenance/Access/UserAccess.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ACC=" + acc;
} else {
	
if (formgoto == "programindicator") {		
    window.location="#SESSION.root#/ProgramREM/Application/Program/Indicator/TargetFlyAccess.cfm?TargetId=#URL.ID#&Role=#URL.ID1#&i=#URL.ID2#&ACC=" + acc
} else {
	window.location="#SESSION.root#/System/Organization/Access/UserAccess.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&Mission=#URL.ID3#&ACC=" + acc
}}}}}}}

function reloadForm(group,page) {
     window.location="UserResult.cfm?Form=#URL.Form#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&ID4=#URL.ID4#&IDSorting=" + group + "&Page=" + page;
}

</script>	
</cfoutput>

<!--- Query returning search results --->

<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  UserNames 
WHERE Account IN (SELECT Account FROM UserNamesGroup WHERE AccountGroup LIKE '%#url.group#%')
ORDER BY #URL.IDSorting#
</cfquery>

<cfinvoke component="Service.Access"  
	   method="useradmin" 
	   returnvariable="access">	
   
<cf_dialogStaffing>

<HTML><HEAD></HEAD>

<form action="UserBatch.cfm" method="post" name="result">

<body leftmargin="1" topmargin="1" rightmargin="1" bottommargin="1">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="25" class="top4n labelmedium">
	<b>Registered user accounts</font></b>
	</td>
	
    <td align="right" class="top4n">
		
	<select name="group" id="group" size="1" class="regularxl" onChange="javascript:reloadForm(this.value,page.value)">
	     <option value="AccountGroup" <cfif #URL.IDSorting# eq "AccountGroup">selected</cfif>>Order by Account group
	     <OPTION value="LastName" <cfif #URL.IDSorting# eq "LastName">selected</cfif>>Order by Last name
	     <OPTION value="Account" <cfif #URL.IDSorting# eq "Account">selected</cfif>>Order by Account name
	</SELECT> 
	
	&nbsp;

   <cfinclude template="../../../Tools/PageCount.cfm">
   <cfif pages gt "1">
	<select name="page" id="page" size="1" class="regularxl" onChange="javascript:reloadForm(group.value,this.value)">
    <cfloop index="Item" from="1" to="#pages#" step="1">
        <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
    </cfloop>	 
	</SELECT>&nbsp;
   <cfelse>
   <input type="hidden" name="page" id="page" value="1">	
   </cfif>	
	
	</td>
	 
	 </td>
  </tr>
 
 <tr>

<td width="100%" colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="F4F4F4">

<td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" rules="rows">

<TR bgcolor="E4E4E4">
    <td></td>
    <TD class="labelit">Account</TD>
    <TD class="labelit">Name</TD>
    <TD class="labelit">eMail</TD>
    <TD class="labelit">Group</TD>
	<TD class="labelit">IndexNo</TD>
	<TD class="labelit">Created</TD>
    <TD></TD>
</TR>

<cfset currrow = 0>

<CFOUTPUT query="SearchResult" group="#URL.IDSorting#" startrow=#first#>

   <cfif #currrow# lt #No#>

   <cfswitch expression = #URL.IDSorting#>
     <cfcase value = "AccountGroup">
	 <tr height="20" bgcolor="f3f3f3">
     <td colspan="8" class="labelit"><b>&nbsp;#AccountGroup#</b></font></td>
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
     <td colspan="8" class="labelit"><b>&nbsp;#AccountGroup#<b></font></td>
	 </tr>
     </cfdefaultcase>
   </cfswitch>
      
   </cfif>

   <cfoutput>
   
   <cfset currrow = #currrow# + 1>

   <cfif #currrow# lte #No#>
   
   <tr><td colspan="8" bgcolor="E6E6E6"></td></tr>

   <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('fbfbfb'))#">
  
   <td bgcolor="FFFFFF" height="20" width="5%" align="right">
    <cfif #URL.ID3# eq "Lookup">
	
    <img onMouseOver="document.result.img_#currentrow#.src='#SESSION.root#/Images/Button.jpg'" 
	 onMouseOut="document.result.img_#currentrow#.src='#SESSION.root#/Images/insert.gif'"
	 src="#SESSION.root#/Images/insert.gif" alt="Select" id="img_#currentrow#" width="15" height="15" border="0" align="middle" 
	 onClick="javascript:sel('#Account#','#LastName#','#FirstName#')">
	
	<cfelse>
	
    <img onMouseOver="document.result.img_#currentrow#.src='#SESSION.root#/Images/Button.jpg'" 
	 onMouseOut="document.result.img_#currentrow#.src='#SESSION.root#/Images/insert.gif'"
	 src="#SESSION.root#/Images/insert.gif" alt="Select" id="img_#currentrow#" width="15" height="15" border="0" align="middle" 
	 onClick="javascript:process('#URLEncodedFormat(Account)#','#URL.Form#')">
	 
	</cfif> 
   &nbsp;&nbsp;</td>
	
   </TD>
   <TD class="labelit">
      <cfif Access eq "EDIT" or Access eq "ALL">
       <a href="javascript:ShowUser('#URLEncodedFormat(Account)#')">#Account#</a>
	  <cfelse>
	  #Account# 
      </cfif>
   </TD>
   <TD class="labelit" width="25%">#LastName#, #FirstName#</TD>
   <TD class="labelit" width="25%"><cfif eMailAddress neq ""><a href="javascript:email('#eMailAddress#','','','','User','#Account#')"></cfif>#eMailAddress#</TD>
   <TD class="labelit">#AccountGroup#</TD>
   <TD class="labelit"><A HREF ="javascript:ShowPerson('#IndexNo#')">#IndexNo#</a></TD>
   <TD class="labelit">#DateFormat(Created, CLIENT.DateFormatShow)#</td>
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

</div>

</BODY></HTML>