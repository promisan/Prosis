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


<cf_PreventCache>

<HTML>

<HEAD>

<TITLE>Program Target</TITLE>
	
</HEAD>

<body onLoad="javascript:document.forms.result.page.focus();">

<form action="" method="post" name="result" id="result">
 
<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_TargetClass
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" >

<cfset Header = "Target class (old version)">
<cfinclude template="../ReferenceHeader.cfm">  

<script>

function recordadd(grp)
{
          window.open("RecordAdd.cfm", "Add", "left=80, top=80, width= 350, height= 200, toolbar=no, status=no, scrollbars=no, resizable=no");
}

function recordedit(id1)
{
          window.open("RecordEdit.cfm?ID1=" + id1, "Edit", "left=80, top=80, width= 350, height= 200, toolbar=no, status=no, scrollbars=no, resizable=no");
}

</script>	
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="#ffffcf" class="formpadding">

<tr>
    <TD align="left" class="top3n"></TD>
    <TD align="left" class="top3n">Code</TD>
	<TD align="left" class="top3n">Description</TD>
	<TD align="left" class="top3n">Officer</TD>
    <TD align="left" class="top3n">Entered</TD>
  
</TR>

<cfoutput query="SearchResult" startrow=#first# maxrows=#No#>
    
    <!--- <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('ffffcf'))#"> --->
	<TR bgcolor="white">
	<td align="center">
	 <img src="#SESSION.root#/Images/select.gif" alt="" name="img0_#currentrow#" 
				  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/select.gif'"
				  style="cursor: pointer;" alt=""  border="0" align="middle" 
				  onClick="javascript:recordedit('#Code#')"	>
	</td>
	<TD class="regular">#Code#</TD>
	<TD class="regular">#Description#</TD>
	<TD class="regular">#OfficerFirstName# #OfficerLastName#</TD>
	<TD class="regular">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	 <tr><td height="1" colspan="8" class="line"></td></tr>

</CFOUTPUT>


</TABLE>

</td>

</TABLE>

</form>

</BODY></HTML>