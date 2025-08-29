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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<HTML>

<HEAD>

<TITLE>Interview Topics</TITLE>
	
</HEAD>

<body>

<form action="" method="post" name="result" id="result">

<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_TextArea
	Order By TextAreaDomain, ListingOrder 
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0">

<cfset Page = "0">
<cfset Header = "Text area">
<cfinclude template="../ReferenceHeader.cfm">  
 
<script LANGUAGE = "JavaScript">

function reloadForm(page)
{
     window.location="RecordListing.cfm?Page=" + page; 
}

function recordadd(grp)
{
     window.open("RecordAdd.cfm", "Add", "left=80, top=80, width=540, height=350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1)
{
     window.open("RecordEdit.cfm?ID1=" + id1, "Edit", "left=80, top=80, width=540, height=350, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="#ffffcf" class="formpadding">

<tr>
    <TD align="left"></TD> 
    <TD align="left">Code</TD>
	<TD align="left">Description</TD>
	<TD align="left"></TD>
	<TD align="left">Order</TD>
	<TD align="left">Officer</TD>
    <TD align="left">Entered</TD>
  
</TR>

<cfoutput query="SearchResult" group="TextAreaDomain">
   <tr bgcolor="E9E9E9"><td height="1" colspan="7"></td></tr>	
   <tr><td height="1" colspan="6">&nbsp;<b>#TextAreaDomain#</td></tr>	
   
   <cfoutput>
   <tr bgcolor="E9E9E9"><td height="1" colspan="7"></td></tr>	
   <TR bgcolor="white">
	<td width="5%" align="center">
	 <img src="#SESSION.root#/Images/locate.jpg" alt="" name="img0_#currentrow#" 
				  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/locate.jpg'"
				  style="cursor: pointer;" alt="" width="14" height="14" border="0" align="middle" 
				  onClick="javascript:recordedit('#Code#')">
	</td>		
	<TD>#Code#</TD>
	<TD>#Description#</TD>
	<td width="40%">#Explanation#</td>
	<TD>#ListingOrder#</TD>
	<TD>#OfficerFirstName# #OfficerLastName#</TD>
	<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	
	</cfoutput>

</CFOUTPUT>

</TABLE>

</td>

</TABLE>

</form>

</BODY></HTML>