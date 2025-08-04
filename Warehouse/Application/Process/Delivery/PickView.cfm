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


<CF_DropTable dbName="AppsMaterials" tblName="#SESSION.acc#tmpPick">

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsMaterials" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
 
SELECT Request.Reference AS ResultField1, 
	   Request.ItemNo AS ResultField2, 
	   Shipping.ItemDescription AS ResultField2a,
	   Request.RequestDate AS ResultField3, 
	   Request.RequestedOriginal AS ResultField4, 
	   Request.RequestedAmount AS ResultField5, 
	   Request.RequestedFulfilled AS ResultField6, 
	   Request.Reference AS ID_Field,
	   Request.TransactionRecordNo
    FROM Request, Shipping
    WHERE Request.Section = '#CLIENT.section#'
	AND Shipping.Status = '0'
	AND Request.ContactLastName = '#SESSION.last#'
	AND Request.Reference = Shipping.Reference
	AND Request.ItemNo   = Shipping.RequestItemNo
	ORDER BY Request.Created DESC	 
	
</cfquery>
		

<HTML><HEAD>
    <TITLE>#URL.ID0#</TITLE>
	
</HEAD>
<cfoutput>
<font face="Tahoma" size="+1">#URL.ID0#</FONT> <BR><hr>
</cfoutput>
<P>

<cf_dialogMaterial>

<form action="PickView.cfm" method="post" name="result" id="result">

<table width="99%" border="0" cellspacing="0" cellpadding="0" class="formpadding">

<TR bgcolor="6688aa">
    <TD><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;</font></TD>
    <TD><font face="Tahoma" size="1" color="#FFFFFF"><cf_tl id="RequestNo"></font></TD>
    <TD><font face="Tahoma" size="1" color="#FFFFFF"><cf_tl id="Item"></font></TD>
    <TD><font face="Tahoma" size="1" color="#FFFFFF"><cf_tl id="Date"></font></TD>
    <TD><font face="Tahoma" size="1" color="#FFFFFF"><cf_tl id="Qty"></font></TD>
    <TD><font face="Tahoma" size="1" color="#FFFFFF"><cf_tl id="Amount"></font></TD>
    <TD><font face="Tahoma" size="1" color="#FFFFFF"><cf_tl id="Fulfilled"></font></TD>

</TR>

<CFOUTPUT query="SearchResult">
<TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('ffffcf'))#">
<td>
<button style="background: ButtonHighlight;" onClick="ShowRequest('#TransactionRecordNo#','0','1','z','z','z')"">
<img src="<cfoutput>#SESSION.root#</cfoutput>/images/view.JPG" alt="" width="18" height="15" border="0" align="bottom">
</button></td>
<td align="left"><font face="Tahoma" size="1">#ResultField1#</font></td>
<TD><font face="Tahoma" size="1">#ResultField2a#</font></TD>
<td align="right"><font face="Tahoma" size="1">#Dateformat(ResultField3, "#CLIENT.DateFormatShow#")#</font></td>
<td align="right"><font face="Tahoma" size="1">#ResultField4#</font></td>
<td align="right"><font face="Tahoma" size="1">#NumberFormat(ResultField5,'_$____.__')#</font></td>
<td align="right"><font face="Tahoma" size="1">#ResultField6#</font></td>
</TR>

</CFOUTPUT>

</TABLE>

<hr>
<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.welcome#</cfoutput></font> </p>

</BODY></HTML>