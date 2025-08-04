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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<HTML><HEAD><TITLE>Measurement sources</TITLE></HEAD>
<body>

<form action="" method="post" name="result" id="result">

<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_MeasureSource
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" >

<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm", "Add", "left=80, top=80, width= 350, height= 200, toolbar=no, status=no, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?ID1=" + id1, "Edit", "left=80, top=80, width= 350, height= 200, toolbar=no, status=no, scrollbars=no, resizable=no");
}

</script>	
	
<tr><td colspan="2">

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr>
    <TD></TD>
    <TD>Code</TD>
	<TD>Description</TD>
	<TD>Officer</TD>
    <TD>Entered</TD>
</TR>
<tr><td height="1" colspan="5" class="line"></td></tr>

<cfoutput query="SearchResult">
    
    <!--- <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('ffffcf'))#"> --->
	<TR>
	<td align="center" height="19">
	 <img src="#SESSION.root#/Images/select4.gif" alt="" name="img0_#currentrow#" 
				  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/select4.gif'"
				  style="cursor: pointer;" height="14" width="13"  border="0" align="absmiddle" 
				  onClick="javascript:recordedit('#Code#')"	>
	</td>
	<TD>#Code#</TD>
	<TD>#Description#</TD>
	<TD>#OfficerFirstName# #OfficerLastName#</TD>
	<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	 <tr><td height="1" colspan="5" class="line"></td></tr>

</CFOUTPUT>

    <TR bgcolor="white"><td height="3" colspan="5"></td></tr>

</TABLE>

</td>

</TABLE>

</BODY></HTML>