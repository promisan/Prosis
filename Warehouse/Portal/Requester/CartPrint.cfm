<!--- Create Criteria string for query from data entered thru search form --->

<HTML><HEAD>
    <TITLE><cf_tl id="Warehouse Request"></TITLE>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
	
</HEAD><BODY bgcolor="D4D0CA">

<cfset acc     = #SESSION.acc#>
<cfset first   = #SESSION.first#>
<cfset last    = #SESSION.last#>
<cfset section = #CLIENT.section#>
<cfset ReqNo   = #URL.ID2#>

<cfset total   = 0>
	
<cfquery name="Cart" 
datasource="AppsMaterials" 
dbtype="ODBC" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
    SELECT Request.*, Item.ItemDescription, Item.Category, Item.UnitOfMeasure
	FROM Request, Item
    WHERE Request.ItemNo = Item.ItemNo 
	AND Request.Reference = '#URL.ID2#'
	AND Request.Status <> '9'  </cfquery>
	
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="39%">
  <tr>
    <td width="100%">
	
<cfoutput>
<font face="Tahoma" size="5"><B>
<img src="<cfoutput>#SESSION.root#</cfoutput>/images/usaid.JPG" alt="" width="119" height="108" border="0"> 
#ParagraphFormat(CLIENT.OrgAddress)#</B></FONT></cfoutput></td>
  </tr>
</table>
<p>
	
<cfoutput>
<font face="Tahoma" size="4"><B>
&nbsp;Order/Request #URL.ID2# [#Section#]</B></FONT> </p>
<hr><p>
</cfoutput>

<table width="99%" border="0" cellspacing="0" cellpadding="0" class="formpadding">

<tr bgcolor="#C0C0C0">
    <TD><font face="Tahoma" size="1" color="#000000"><cf_tl id="RequestNo"></font></TD>
    <TD><font face="Tahoma" size="1" color="#000000"><cf_tl id="Item"></font></TD>
	<TD><font face="Tahoma" size="1" color="#000000"><cf_tl id="Workorder"></font></TD>
    <TD><font face="Tahoma" size="1" color="#000000"><cf_tl id="Date"></font></TD>
	<td align="right"><font face="Tahoma" size="1" color="#000000"><cf_tl id="Price"></font></td>
    <td align="right"><font face="Tahoma" size="1" color="#000000"><cf_tl id="Quantity"></font></td>
    <td align="right"><font face="Tahoma" size="1" color="#000000"><cf_tl id="Fulfilled"></font></td>
 	<TD><font face="Tahoma" size="1" color="#000000"><cf_tl id="UoM"></font></TD>
	<td align="right"><font face="Tahoma" size="1" color="#000000"><cf_tl id="Amount"></font></td>
 </TR>

<CFOUTPUT query="Cart">
<cfset Cat = #Category#>
<TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('ffffcf'))#">
<TD><font face="Tahoma" size="1">#Reference#</font></TD>
<TD><font face="Tahoma" size="1">#ItemNo# #ItemDescription#</font></TD>
<TD><font face="Tahoma" size="1">#CustomerId#</font></TD>
<TD><font face="Tahoma" size="1">#Dateformat(RequestDate, "#CLIENT.DateFormatShow#")#</font></TD>
<TD><font face="Tahoma" size="1">#NumberFormat(StandardCost,'_$____.__')#</font></TD>
<td align="right"><font face="Tahoma" size="1"><CFIF #Status# is '9'> #RequestedOriginal# <CFELSE> #RequestedQuantity# </cfif></font></td>
<td align="right"><font face="Tahoma" size="1">#RequestedFulfilled#</font></td>
<TD><font face="Tahoma" size="1">#UnitOfMeasure#</font></TD>
<td align="right"><font face="Tahoma" size="1">#NumberFormat(RequestedAmount,'_$____.__')#</font></td>
<TD><font face="Tahoma" size="1">
<cfset total = total + #RequestedAmount#>
</TR>
</cfoutput>
</TABLE>

<p align="right">

_________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>

<p align="right">

<cfoutput><font face="Tahoma" size="2"><b><cf_tl id="Total value"> #NumberFormat(total,'$____.00')#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</b></font>
</cfoutput>
</p>
<cf_tl id="Print" var="1">
<INPUT class="button1" TYPE="button" VALUE="  #lt_text# " onclick="window.print();"> 
<hr>
<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.welcome#</cfoutput></font> </p>

</BODY></HTML>