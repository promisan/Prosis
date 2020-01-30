<html>

<head>
<meta http-equiv="Content-Language" content="en-us">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Packing slip</title>
</head>


<cf_PreventCache>

<link href="../../../select.css" rel="stylesheet" type="text/css">

<body onLoad="window.focus()">

<cfparam name="URL.ID" default="8">

<cfquery name="SearchResult" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT DISTINCT *
   FROM Shipping R, Warehse W
   WHERE (R.ShippingNo = '#URL.ID#')
   AND R.Warehouse = W.Warehouse
   ORDER BY R.ShippingItemNo
</cfquery>

<table width="95%" height="412" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">
  <tr>
    <td width="95%" align="center">
    <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" height="83">
      <tr>
        <td width="50%" height="83" align="left" valign="top">
        <u><b><font size="6"><cf_tl id="Packing slip"></font></b></u>
		<cfoutput query="SearchResult" maxrows=1>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" rules="cols" bordercolor="111111" bgcolor="FFFFFF" style="border-collapse: collapse">
          <tr>
            <td width="100%">&nbsp;&nbsp;<b></b>#WarehouseName#</b></td>
          </tr>
          <tr>
            <td width="100%">&nbsp;&nbsp;#Address# #City#</td>
          </tr>
		   <tr>
            <td width="100%">&nbsp;&nbsp;#ChiefFirstName# #ChiefLastName#</td>
          </tr>
          <tr>
            <td width="100%">&nbsp;&nbsp;Tel: #Telephone#</td>
          </tr>
        </table>
				
		</td>
		
        <td width="50%" height="62" valign="top"><b><font face="Tahoma" size="2" color="FFFFFF">		
   		
		<table width="100%" border="0" cellspacing="0" cellpadding="0" rules="cols" bordercolor="111111" bgcolor="FFFFFF" style="border-collapse: collapse">
          <tr valign="top">
            <td width="100%" align="right">&nbsp;&nbsp;<b><cf_tl id="No">:&nbsp;&nbsp;&nbsp;#ShippingNo#&nbsp;&nbsp;</b></td>
          </tr>
		  <tr><td height="6"></td></tr>
          <tr>
            <td width="100%" align="right">&nbsp;&nbsp;<b><cf_tl id="Date">:&nbsp;#Dateformat(ShippingDate, "#CLIENT.DateFormatShow#")#</b>&nbsp;&nbsp;</td>
          </tr>
        </table>
				
		</cfoutput>
        </td>
      </tr>
    </table>
    </td>
  </tr>
  <tr><td height="10"></td></tr>
  
  <tr>
    <td width="100%">
    <table border="1" cellpadding="0" cellspacing="0" rules="cols" style="border-collapse: collapse" bordercolor="#111111" width="100%" height="62">
      <tr>
        <td width="50%" height="62" bgcolor="8EA4BB"><b><font face="Tahoma" size="2" color="#FFFFFF">&nbsp;<cf_tl id="Bill to">:</font></b>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#111111" bgcolor="#FFFFFF" style="border-collapse: collapse">
          <tr>
            <td width="100%">&nbsp;<cfoutput query="SearchResult" maxrows=1>#Section#</cfoutput></td>
          </tr>
          <tr>
            <td width="100%">&nbsp;</td>
          </tr>
          <tr>
            <td width="100%">&nbsp;</td>
          </tr>
        </table>
        </td>
         <td width="50%" height="62" bgcolor="8EA4BB"><b><font face="Tahoma" size="2" color="#FFFFFF">&nbsp;<cf_tl id="Ship to">:</font></b>
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#111111" bgcolor="#FFFFFF" style="border-collapse: collapse">
          <tr>
            <td width="100%">&nbsp;<cfoutput query="SearchResult" maxrows=1>#Section#</cfoutput></td>
          </tr>
          <tr>
            <td width="100%">&nbsp;</td>
          </tr>
          <tr>
            <td width="100%">&nbsp;</td>
          </tr>
        </table>
        </td>
      </tr>
    </table>
    </td>
  </tr>
  
  <tr><td height="10"></td></tr>
  
  <tr>
  
    <td>
	
	<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#111111" rules="cols" style="border-collapse: collapse">
    	
	<cfset amt    = 0>

    <tr bgcolor="#8EA4BB">
        <td width="10%" height="20" align="left"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;<cf_tl id="RequestNo"></font></td>
    	<TD width="8%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;<cf_tl id="ItemNo"></font></TD>
    	<TD width="42%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;<cf_tl id="Description"></font></TD>
        <TD width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;<cf_tl id="UoM"></font></TD>
        <TD width="10%" align="right"><font face="Tahoma" size="1" color="#FFFFFF"><cf_tl id="Quantity">&nbsp;</font></TD>
    	<td width="10%" align="right"><font face="Tahoma" size="1" color="#FFFFFF"><cf_tl id="Price">&nbsp;</font></td>
    	<td width="10%" align="right"><font face="Tahoma" size="1" color="#FFFFFF"><cf_tl id="Total">&nbsp;</font></td>
    </TR>
	
	<cfoutput query="SearchResult">
	
	<tr bgcolor="FFFFCF">
       <TD><font face="Tahoma" size="1">&nbsp;#Reference#</font></TD>
       <TD><font face="Tahoma" size="1">&nbsp;#ShippingItemNo#</font></TD>
	   <TD><font face="Tahoma" size="1">&nbsp;#ItemDescription#</font></TD>
       <TD><font face="Tahoma" size="1">&nbsp;#TransactionUoM#</font></TD>
       <TD align="right"><font face="Tahoma" size="1">&nbsp;#TransactionQuantity#&nbsp;</font></TD>
       <td align="right"><font size="1" face="Tahoma">#NumberFormat(TransactionPrice,'_____,__.__')#&nbsp;</font></td>	
	   <td align="right"><font size="1" face="Tahoma">#NumberFormat(TransactionValue,'_____,__.__')#&nbsp;</font></td>	
	</TR>
	
	<cfset Amt = Amt + #TransactionValue#>
	
	</cfoutput>
		
	</table>
	
	</td>
  </tr>
  
  <tr><td height="10"></td></tr>
  
   <tr>
    <td width="95%" align="center">
    <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" height="83">
      <tr>
        <td width="50%"></td>
  		
        <td width="50%"><b><font face="Tahoma" size="2" color="#FFFFFF">		
   		<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" rules="cols" bordercolor="111111" bgcolor="FFFFFF" style="border-collapse: collapse">
		  <tr><td height="10" colspan="2" bgcolor="8EA4BB"></td></tr>
          <tr>
		    <td align="right"><font face="Tahoma" size="2">&nbsp;<cf_tl id="Total">:</font></td>
            <td align="right">&nbsp;&nbsp;<font face="Tahoma" size="2"><b>#NumberFormat(Amt,'_____,__.__')#&nbsp;</b></font></td>
          </tr>
   
        </table>
		</cfoutput>
        </td>
      </tr>
    </table>
    </td>
  </tr>
  
  
</table>

</body>

</html>
