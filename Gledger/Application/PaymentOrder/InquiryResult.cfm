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


<cf_PreventCache>

<CF_RegisterAction 
SystemFunctionId="0931" 
ActionClass="Payment Orders" 
ActionType="View" 
ActionReference="" 
ActionScript="">

<HTML>

<HEAD>

<TITLE>Account Payment Orders</TITLE>
	
</HEAD>

<body onload="javascript:document.forms.result.page.focus();">

<form action="" method="post" name="result" id="result">

<cfparam name="URL.ID" default="Journal">

<table width="100%">
<TD><font size="4"><b>Selected Payment transactions</b></font>
</TD>
<TD>

  <a href = "javascript:window.print()"><img src="<cfoutput>#SESSION.root#</cfoutput>/Images/print.jpg" alt="Print" width="25" height="21" border="0" onClick=""><font face="Tahoma" size="1"><b>Print <b></b></font></a>
  <a href = "javascript:eMail()"> <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/mail.jpg" alt="eMail this report" width="27" height="23" border="0"><font face="Tahoma" size="1"><b>eMail&nbsp; &nbsp;<b></b></font></a>
  <cfoutput>
  <a href="InquiryExcel.cfm" target="_blank"> <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/excel.jpg" alt="Export to Excel" width="23" height="20" border="0"><font face="Tahoma" size="1"><b>Excel <b></b></font></a>
  </cfoutput>
  </TD>
  <TD><img src="../../../warehouse.JPG" alt="" width="35" height="35" border="1" align="right"></TD>
</table>

<!--- Query returning search results --->
<cfquery name="SearchResult"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM #SESSION.acc#Payment
    ORDER BY Currency, #URL.ID#, JournalBatchNo
</cfquery>

<script>
function reloadForm(group,page)
{
     window.location="InquiryResult.cfm?ID=" + group + "&Page=" + page;
}
</script>	
	
<cf_dialogLedger>
<cf_dialogMaterial>

<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->
<hr>

<table width="98%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

<tr>
<TD bgcolor="#6688AA" height="30">
<select name="group" size="1" style="background: #C9D3DE;" onChange="javascript:reloadForm(this.value,page.value)">
     <option value="Journal" <cfif #URL.ID# eq "Journal">selected</cfif>>Group by Journal
     <OPTION value="ReferenceName" <cfif #URL.ID# eq "ReferenceName">selected</cfif>>Group by Payee
     <OPTION value="TransactionDate" <cfif #URL.ID# eq "TransactionDate">selected</cfif>>Group by Date
</SELECT> 
</TD>
<td bgcolor="#6688AA" align="right">
    <cfinclude template="../../../Tools/PageCount.cfm">
<select name="page" size="1" style="background: #C9D3DE;" onChange="javascript:reloadForm(group.value,this.value)">
    <cfloop index="Item" from="1" to="#pages#" step="1">
        <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
    </cfloop>	 
</SELECT>   	
</TD>
</tr>
<TR>

<td colspan="2">

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<cfoutput query="SearchResult" group=Currency startrow=#first# maxrows=#No#>

<cfset amtT    = 0>
<cfset amtOutT = 0>

<cfoutput group="#URL.ID#">

    <cfset amt    = 0>
    <cfset amtOut = 0>
	
   <tr bgcolor="ffffcf">

   <cfswitch expression = #URL.ID#>
     <cfcase value = "Journal">
     <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#Journal#</b></font></td>
     </cfcase>
     <cfcase value = "ReferenceName">
     <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#ReferenceName#</b></font></td> 
     </cfcase>	 
     <cfcase value = "TransactionDate">
     <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</b></font></td>
     </cfcase>
     <cfdefaultcase>
     <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#Journal#<b></font></td>
     </cfdefaultcase>
   </cfswitch>
   
   </tr>
   
<cfoutput group="JournalBatchNo">  

   <tr bgcolor="6688AA"><td height="4" colspan="8"></td></tr> 
   <tr><td height="7" colspan="8"></td></tr>

   <tr><td></td>
   <td colspan="2"><font face="Tahoma" size="2"><b>&nbsp;Batch:</b></font></td>
   <td colspan="5"><font face="Tahoma" size="2"> #JournalBatchNo# </font></td>
   </tr>
   <tr><td></td>
   <td colspan="2"><font face="Tahoma" size="2"><b>&nbsp;Date:</b></font></td>
   <td colspan="5"><font face="Tahoma" size="2"> #Dateformat(BatchTransactionDate, "#CLIENT.DateFormatShow#")# </font></td>
   </tr>
   <tr><td></td>
   <td colspan="2"><font face="Tahoma" size="2"><b>&nbsp;Officer:</b></font></td>
   <td colspan="5"><font face="Tahoma" size="2"> #FirstName# #LastName#</font></td>
   </tr>
   
   <tr bgcolor="8EA4BB">
    <TD width="7%">&nbsp;</TD>
    <TD width="10%" align="left"><font face="Tahoma" size="1" color="FFFFFF">DocumentNo</font></TD>
	<TD width="17%" align="left"><font face="Tahoma" size="1" color="FFFFFF">Description</font></TD>
	<TD width="10%" align="left"><font face="Tahoma" size="1" color="FFFFFF">Date</font></TD>
    <TD width="31%" align="left"><font face="Tahoma" size="1" color="FFFFFF">Vendor</font></TD>
    <TD width="5%" align="left"><font face="Tahoma" size="1" color="FFFFFF">Curr</font></TD>
	<td width="10%" align="right"><font face="Tahoma" size="1" color="FFFFFF">Amount</font></td>
	<td width="10%" align="right"><font face="Tahoma" size="1" color="FFFFFF">Outstanding&nbsp;</font></td>
</TR>
   
     
<CFOUTPUT>

    <TR>
    <td align="center"><font face="Tahoma" size="1">
	<a href="javascript:ShowTransaction('#Journal#','#JournalSerialNo#','z','z','z','z')">
	<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/view.jpg" alt="" width="14" height="12" border="0" align="middle"></a></font>
	</td>
	<TD><font face="Tahoma" size="1">
	<cfif #TransactionSource# is "InvoiceSeries">
	     <A HREF ="javascript:ShowPurchaseNo('#JournalTransactionNo#','9')">#JournalTransactionNo#</A>
	<cfelse>#JournalTransactionNo#
	</cfif></font></TD>
	<TD><font face="Tahoma" size="1">#Description#</font></TD>
	<TD><font face="Tahoma" size="1">#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</font></TD>
    <TD><font face="Tahoma" size="1">#ReferenceName#</font></TD>
    <TD align="left"><font face="Tahoma" size="1">#Currency#</font></TD>
    <td align="right"><font size="1" face="Tahoma">#NumberFormat(Amount,'_____,__')#&nbsp;</font></td>	
	<td align="right"><font size="1" face="Tahoma">#NumberFormat(AmountOutstanding,'_____,__')#&nbsp;</font></td>	
	
	<cfset Amt = Amt + #Amount#>
    <cfset AmtOut = AmtOut + #AmountOutstanding#>	
    <cfset AmtT = AmtT + #Amount#>
    <cfset AmtOutT = AmtOutT + #AmountOutstanding#>				
	
    </TR>

</CFOUTPUT>

   <tr><td height="10" colspan="8"></td></tr>

</cfoutput>

<TR>
    <td colspan="6" align="center">
	<td align="right"><hr></td>	
	<td align="right"><hr></td>	
   </TR>
   
    <TR>
    <td colspan="6" align="center">
	<td align="right"><font size="1" face="Tahoma"><b>#NumberFormat(Amt,'_____,__')#&nbsp;</b></font></td>	
	<td align="right"><font size="1" face="Tahoma"><b>#NumberFormat(AmtOut,'_____,__')#&nbsp;</b></font></td>	
   </TR>

<tr><td height="10" colspan="8"></td></tr>

</CFOUTPUT>

<TR bgcolor="ffffcf">
    <td colspan="6" align="center">
	<td align="right"><hr></td>	
	<td align="right"><hr></td>	
   </TR>

   <TR bgcolor="ffffcf">
    <td colspan="6" align="center">
	<td align="right"><font size="1" face="Tahoma"><b>#NumberFormat(AmtT,'_____,__')#&nbsp;</b></font></td>	
	<td align="right"><font size="1" face="Tahoma"><b>#NumberFormat(AmtOutT,'_____,__')#&nbsp;</b></font></td>	
   </TR>

</CFOUTPUT>

</TABLE>

</td>

</TABLE>


<hr>
<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.welcome#</cfoutput></font> </p>

</form>

</BODY></HTML>