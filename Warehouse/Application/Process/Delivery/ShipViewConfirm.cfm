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

<TITLE>Update DeliveryStatus</TITLE>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<body>

<cfparam name="form.selected" default="'0'">

<!--- Register Clearance action in a loop--->

<cfquery name="UpdateStatus" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

UPDATE Shipping 
SET Status = '2', 
 DeliveryDate = getDate(), 
 DeliveredUserId    = '#SESSION.acc#', 
 DeliveredLastName  = '#SESSION.last#', 
 DeliveredFirstName = '#SESSION.first#', 
 DeliveryReference = 'on-line'
WHERE TransactionNo IN (#PreserveSingleQuotes(Form.selected)#)
</cfquery>		

<cfset acc     = #SESSION.acc#>
<cfset first   = #SESSION.first#>
<cfset last    = #SESSION.last#>
<cfset section = #CLIENT.section#>

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsMaterials" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
SELECT Shipping.*
    FROM Shipping, Request
    WHERE Request.Reference = Shipping.Reference
	AND Request.ItemNo = Shipping.RequestItemNo
	AND Request.ItemNoOriginal = Shipping.ItemNoOriginal
	AND TransactionNo IN (#PreserveSingleQuotes(Form.selected)#)
    ORDER BY Request.Created DESC	
</cfquery>

<HTML><HEAD>
    <TITLE>#URL.ID0#</TITLE>
	
</HEAD>
<cfoutput>
<cf_tl id="The receipt of the below listed items is confirmed" var="1">
<font face="Tahoma" size="+1">#lt_text#:</FONT> <BR><hr>
</cfoutput>
<P>

<script language="JavaScript">

function reload()
{
window.close();
opener.location.reload();
}

</script>

<cf_dialogMaterial>

<table width="99%" border="0" cellspacing="0" cellpadding="0" class="formpadding">

<TR bgcolor="6688aa">
    <TD><font face="Tahoma" size="1" color="#FFFFFF"><cf_tl id="RequestNo"></font></TD>
    <TD><font face="Tahoma" size="1" color="#FFFFFF"><cf_tl id="Item"></font></TD>
	<TD><font face="Tahoma" size="1" color="#FFFFFF"><cf_tl id="Warehouse"></font></TD>
    <TD><font face="Tahoma" size="1" color="#FFFFFF"><cf_tl id="Date"></font></TD>
	<TD><font face="Tahoma" size="1" color="#FFFFFF"><cf_tl id="UoM"></font></TD>
    <TD><font face="Tahoma" size="1" color="#FFFFFF"><cf_tl id="Quantity"></font></TD>
    <TD><font face="Tahoma" size="1" color="#FFFFFF"><cf_tl id="Extended Price"></font></TD>
</TR>

<CFOUTPUT query="SearchResult">
<TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('ffffcf'))#">
<td align="right"><font face="Tahoma" size="1"><A href="ItemListOrder.cfm?ID=#URLEncodedFormat(Reference)#&ID2=#RequestItemNo#">#Reference#</A></font></td>
<TD><font face="Tahoma" size="1">#ItemDescription#</font></TD>
<TD><font face="Tahoma" size="1">#Warehouse#</font></TD>
<td align="right"><font face="Tahoma" size="1">#Dateformat(ShippingDate, "#CLIENT.DateFormatShow#")#</font></td>
<td align="right"><font face="Tahoma" size="1">#TransactionUoM#</font></td>
<td align="right"><font face="Tahoma" size="1">#NumberFormat(TransactionQuantity,'_$____.__')#</font></td>
<td align="right"><font face="Tahoma" size="1">#NumberFormat(TransactionValue,'_$____.__')#</font></td>
</TR>
</CFOUTPUT>
</TABLE>
<hr>
<cfoutput>
<cf_tl id="Continue" var="1">
<input class="button1" type="button" name="Submit" id="Submit" value=" #lt_text#  " onClick="reload()">
</cfoutput>
</form>

<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.welcome#</cfoutput></font> </p>


