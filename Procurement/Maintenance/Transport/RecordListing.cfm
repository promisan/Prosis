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

<HTML>

<HEAD>

<TITLE>Type of transportation</TITLE>
	
</HEAD>

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  Ref_transport
ORDER BY code
</cfquery>

<cfset add          = "1">
<cfset Header       = "Unit of Measure">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
 
<script>

function recordadd(grp)
{
          window.open("RecordAdd.cfm", "Add", "left=80, top=80, width= 400, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1)
{
          window.open("RecordEdit.cfm?ID1=" + id1, "Edit", "left=80, top=80, width= 400, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr>
   
    <TD align="left" class="top3n" width="5%">&nbsp;</TD>
    <TD align="left" class="top3n">&nbsp;Code</TD>
	<TD align="left" class="top3n">Description</TD>
	<TD align="left" class="top3n">Tracking</TD>
	<TD align="left" class="top3n">Officer</TD>
	<TD align="left" class="top3n">Entered</TD>
  
</TR>

<cfoutput query="SearchResult" startrow=#first# maxrows=#No#>
   
    <TR class="line"><td height="1" colspan="6"></td></tr>  
    <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f6f6f6'))#"> 
	<TD class="regular">&nbsp;
			 <img src="#SESSION.root#/Images/locate.jpg" alt="" name="img0_#currentrow#" 
				  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/locate.jpg'"
				  style="cursor: pointer;" alt="" width="14" height="14" border="0" align="middle" 
				  onClick="javascript:recordedit('#Code#')"	>
	</TD>		
	<TD class="regular">&nbsp;#Code#</TD>
	<TD class="regular">#Description#</TD>
	<TD class="regular"><cfif #Tracking# eq "1">Yes<cfelse>No</cfif></TD>
	<TD class="regular">#OfficerFirstName# #OfficerLastName#</TD>
	<TD class="regular">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	
</cfoutput>

</TABLE>

</td>

</TABLE>

<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.welcome#</cfoutput></font> </p>

</form>

</BODY></HTML>
