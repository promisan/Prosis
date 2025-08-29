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
<!--- disabled 

<link href="../../pkdb.css" rel="stylesheet" type="text/css">

<cfinclude template="../../Control/VerifyLogin.cfm">
<cfinclude template="../../Control/PreventCache.cfm">

<HTML>

<HEAD>

<TITLE>Workorders</TITLE>
	
</HEAD>

<body onLoad="javascript:document.forms.result.page.focus();">

<form action="" method="post" name="result" id="result">

<cfparam name="URL.ID" default="ContractorName">

<!--- Query returning search results --->
<cfquery name="SearchResult"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM #SESSION.acc#Workorder
    ORDER BY #URL.ID#
</cfquery>
	
<script>
function reloadForm(group,page)
{
     window.location="InquiryResult.cfm?ID=" + group + "&Page=" + page;
}
</script>	
	
<cf_dialogMaterial>

<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->


<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr>
   <TD class="banner"><b>&nbsp;Selected Workorders documents</b></TD>
   <td align="right" class="banner">
  
<CF_DialogHeader 
MailSubject="Workorder" 
MailTo="" 
MailAttachment="" 
ExcelFile=""> 

</td></tr> 	

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">
<tr>
<TD bgcolor="#6688AA" height="30">
<select name="group" id="group" size="1" style="background: #C9D3DE;" onChange="javascript:reloadForm(this.value,page.value)">
     <option value="LocationDescription" <cfif #URL.ID# eq "LocationDescription">selected</cfif>>Group by Location
     <OPTION value="WorkCategory" <cfif #URL.ID# eq "WorkCategory">selected</cfif>>Group by Category
     <OPTION value="ContractorName" <cfif #URL.ID# eq "ContractorName">selected</cfif>>Group by Contractor
	 <OPTION value="WorkorderNo" <cfif #URL.ID# eq "WorkorderNo">selected</cfif>>Group by WorkorderNo
</SELECT> 
</TD>
<td bgcolor="#6688AA" align="right">
    <cfinclude template="../../Tools/PageCount.cfm">
<select name="page" id="page" size="1" style="background: #C9D3DE;" onChange="javascript:reloadForm(group.value,this.value)">
    <cfloop index="Item" from="1" to="#pages#" step="1">
        <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
    </cfloop>	 
</SELECT>   	
</TD>
</tr>
<TR>

<td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" rules="rows">

<tr bgcolor="#8EA4BB">
    <TD width="7%">&nbsp;</TD>
    <TD width="10%" align="center"><font face="Tahoma" size="1" color="#FFFFFF">WorkNo</font></TD>
	<TD width="10%" align="center"><font face="Tahoma" size="1" color="#FFFFFF">Category</font></TD>
	<TD width="10%" align="center"><font face="Tahoma" size="1" color="#FFFFFF">Date</font></TD>
    <TD width="33%" align="center"><font face="Tahoma" size="1" color="#FFFFFF">Briefs</font></TD>
    <TD width="20%" align="center"><font face="Tahoma" size="1" color="#FFFFFF">Contractor</font></TD>
	<td width="10%" align="center"><font face="Tahoma" size="1" color="#FFFFFF">Amount</font></td>
</TR>

<cfoutput query="SearchResult" group="#URL.ID#" startrow=#first# maxrows=#No#>

   <cfswitch expression = #URL.ID#>
     <cfcase value = "LocationDescription">
     <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#LocationDescription#</b></font></td>
     </cfcase>
     <cfcase value = "WorkorderNo">
     <!--- <td colspan="8"><font face="Tahoma" size="2"><b>#Reference#</b></font></td> --->
     </cfcase>	 
     <cfcase value = "WorkCategory">
     <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#WorkCategory#</b></font></td>
     </cfcase>
     <cfcase value = "ContractorName">
     <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#ContractorName#<b></font></td>
     </cfcase>
     <cfdefaultcase>
     <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#ContractorName#<b></font></td>
     </cfdefaultcase>
   </cfswitch>
     
<CFOUTPUT>

    <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('ffffcf'))#">
    <td align="center">
	<a href="javascript:ShowWorkorder('#WorkorderNo#','z','z','z','z','z')">
	<img src="../../Images/open.JPG" alt="" width="17" height="16" border="0" align="middle"></a>
	</td>
	<TD><font face="Tahoma" size="1">#WorkorderNo#</font></TD>
	<TD><font face="Tahoma" size="1">#WorkCategory#</font></TD>
	<TD><font face="Tahoma" size="1">#Dateformat(WorkOrderDate, "#CLIENT.DateFormatShow#")#</font></TD>
    <TD><font face="Tahoma" size="1">#WorkBriefs#</font></TD>
    <TD align="left"><font face="Tahoma" size="1">#ContractorName#</font></TD>
    <td align="right"><font size="1" face="Tahoma">#NumberFormat(Amount,'$___,_____')#&nbsp;</font></td>	
		
    </TR>
</CFOUTPUT>

   <tr><td height="10"></td></tr>

</CFOUTPUT>

</TABLE>

</td>

</TABLE>

</td>

</table>
 
<hr>
<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.welcome#</cfoutput></font> </p>

</form>

</BODY></HTML>

--->