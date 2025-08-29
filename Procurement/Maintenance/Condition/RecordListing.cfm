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
<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_condition 
	ORDER BY code
</cfquery>

<cf_screentop height="100%" 
			  label="Order class" 
			  layout="webapp" 
			  html="No"
			  jquery="Yes"
			  systemfunctionid="#url.idmenu#">

<cf_divscroll>

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<cfset add          = "1">
<cfset Header       = "Condition">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 490, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 490, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput> 
	
<tr><td colspan="2">

<table width="96%" align="center" class="navigation_table">

<tr class="labelmedium2 line">
   
    <TD width="5%">&nbsp;</TD>
    <TD>Code</TD>
	<TD>Description</TD>
	<TD>Officer</TD>
    <TD>Entered</TD>
  
</TR>

<cfoutput query="SearchResult">
	
    <TR class="navigation_row labelmedium2 line"> 
	<TD style="padding-top:1px;" align="center">
		<cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
	</TD>		
	<TD>#Code#</TD>
	<TD>#Description#</TD>
	<TD>#OfficerFirstName# #OfficerLastName#</TD>
	<TD >#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
		
</CFOUTPUT>

</TABLE>

</td>
</tr>

</TABLE>

</cf_divscroll>

<cfset ajaxonload("doHighlight")>
