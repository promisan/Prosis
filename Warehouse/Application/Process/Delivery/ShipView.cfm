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


<!--- Query returning search results --->
<cfquery name="SearchResult" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
 	SELECT Shipping.*
    FROM Shipping, Request
    WHERE Request.Reference = Shipping.Reference
	AND Request.ItemNo = Shipping.RequestItemNo
	AND Request.ItemNoOriginal = Shipping.ItemNoOriginal
	AND Shipping.Status = '#URL.ID#'
	AND Request.Section = '#CLIENT.section#'
	AND Request.ContactLastName = '#SESSION.last#'
    ORDER BY ShippingNo DESC	 </cfquery>
	
<cfoutput>


<cf_tl id="Do you want to confirm receipt of all selected items" var="1" class="Message">

<script>

function ask()

{
	if (confirm("#lt_text# ?")) {
	
	return true 
	
	}
	
	return false
	
}	

function reloadForm(page)
{
     window.location="ShipView.cfm?ID=" + #URL.ID# + "&ID0=#URL.ID0#&Page=" + page;
}


</script>	

</cfoutput>		

<HTML><HEAD>
    <TITLE><cf_tl id="Shipping view"></TITLE>
	
</HEAD>

<form action="ShipViewConfirm.cfm" method="post" name="result" id="result" target="confirm">

<body onload="javascript:document.forms.result.page.focus();">

<table width="100%">
<TR>
<TD><cfoutput><font face="Tahoma" size="+1">#URL.ID0#</FONT></cfoutput>
</TD>
<TD>
<cfinclude template="../../../Tools/PageCount.cfm">
    <select name="page" id="page" size="1" style="background: #ffffcf;" onChange="javascript:reloadForm(this.value)">
    <cfloop index="Item" from="1" to="#pages#" step="1">
        <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>><cf_tl id="Page"> #Item# <cf_tl id="of"> #pages#</option></cfoutput>
    </cfloop>	 
    </SELECT>   	
</TD>	
 <TD><img src="../../../warehouse.JPG" alt="" width="35" height="35" border="1" align="right"></TD>  
  </TR>
</TABLE>
<hr>

<form action="ShipViewConfirm.cfm" method="post" name="shipview" id="shipview" target="_blank">

<cf_dialogMaterial>

<table width="99%" border="0" cellspacing="0" cellpadding="0" class="formpadding">

<TR bgcolor="6688aa">
    <TD><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;<cf_tl id="PackingSlip"><font></TD>
	<TD><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;</font></TD>
    <TD><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;<cf_tl id="RequestNo"></font></TD>
    <TD><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;<cf_tl id="Item"></font></TD>
	<TD><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;<cf_tl id="Warehouse"></font></TD>
    <TD><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;<cf_tl id="Date"></font></TD>
	<TD><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;<cf_tl id="UoM"></font></TD>
    <TD><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;<cf_tl id="Quantity"></font></TD>
    <TD><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;<cf_tl id="Extended Price"></font></TD>
</TR>

<TR bgcolor="ffffcf">
<td colspan="9">
<cfif URL.ID is '1'>
<cf_tl id="Yes, confirm receipt" var="1">
<input type="submit" name="Update" id="Update" value="#lt_text#" onClick="return ask()">
</cfif>
</td>
</tr>

<cfoutput query="SearchResult" group="ShippingNo" startrow=#first# maxrows=#No#>
<TR>
<td colspan="1" align="left"><font face="Tahoma" size="1"><b>&nbsp;<cf_tl id="No">:</b></font></td>
<td colspan="7" align="left"><font face="Tahoma" size="1"><b>&nbsp;#ShippingNo#</b></font></td>
<td rowspan="2" align="right">
	 <button style="background: ButtonHighlight;" onClick="javascript:packingslip('#ShippingNo#','1')">
   	 <img src="<cfoutput>#SESSION.root#</cfoutput>/images/view.JPG" alt="" width="18" height="15" border="0" align="bottom">
	 </button>&nbsp;</td>


</TR>
<TR>
<td colspan="1" align="left"><font face="Tahoma" size="1"><b>&nbsp;<cf_tl id="Date">:</b></font></td>
<td colspan="7" align="left"><font face="Tahoma" size="1"><b>&nbsp;#Dateformat(ShippingDate, "#CLIENT.DateFormatShow#")#</b></font></td>

</TR>
<cfoutput>
<TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('ffffcf'))#">
<TD></TD>
<TD><input type="checkbox" name="selected" id="selected" value="'#TransactionNo#'"></TD>
<td align="left"><font face="Tahoma" size="1">
<A href="javascript:ShowRequest('#TransactionRecordTrigger#','0','1','z','z','z')">#Reference#</A></font></td>
<TD><font face="Tahoma" size="1">#ItemDescription#</font></TD>
<TD><font face="Tahoma" size="1">#Warehouse#</font></TD>
<td align="right"><font face="Tahoma" size="1">#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</font></td>
<td align="right"><font face="Tahoma" size="1">#TransactionUoM#</font></td>
<td align="right"><font face="Tahoma" size="1">#NumberFormat(TransactionQuantity,'_____._')#</font></td>
<td align="right"><font face="Tahoma" size="1">#NumberFormat(TransactionValue,'_$____.__')#</font></td>
</TR>
</CFOUTPUT>
<tr><td colspan="9"><hr></td></tr>
</CFOUTPUT>

</TABLE>
<hr>

</form>

<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.welcome#</cfoutput></font> </p>

</BODY></HTML>