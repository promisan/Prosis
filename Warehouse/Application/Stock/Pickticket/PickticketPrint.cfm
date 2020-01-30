
<cfoutput>

<head>
		<title>Pickticket</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		
		<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 	
		<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css" media="print">
	</head>
	
</cfoutput>	
	
<cfquery name="Batch"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * FROM WarehouseBatch
		WHERE  BatchNo = '#url.BatchNo#'
</cfquery>

<cfquery name="Pickticket"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  T.*, 
		        U.UoMDescription, 
			    R.Reference, 
		        R.OfficerFirstName + ' ' + R.OfficerLastName as Requester,
			    R.RequestDate
		FROM    ItemTransaction T, ItemUoM U, Request R
		WHERE   TransactionBatchNo = '#url.BatchNo#' 
		AND     T.ItemNo = U.ItemNo
		AND     T.TransactionUoM = U.UoM
		AND     T.RequestId = R.RequestId
</cfquery>

<cfparam name="URL.ID2" default="Supply">

<cfoutput query="Batch">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">

<tr class="noprint"><td align="center" height="30">
<input type="button" onclick="window.print()" class="button10g" name="Close" id="Close" value="Print">
<input type="button" onclick="returnValue='1';window.close()" class="button10g" name="Close" id="Close" value="Close">
</td></tr>

<tr><td>

 <table width="99%" height="98%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" rules="cols">
 <tr>
    <td width="100%" height="54" colspan="2" align="center" valign="middle">
    <b><font size="4">PICKTICKET FOR EQUIPMENT OR SUPPLIES</font></b>
    </td>
 </tr>
 <tr>
    <td width="100%" bgcolor="d2d2d2" height="26" colspan="2" align="center" valign="middle"> 
	<b><font face="verdana" size="1">IMPORTANT: Mark all packages and papers with Batch No</font></b></td>
 </tr>

 <tr>
    <td width="50%" valign="top" height="50">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	   <tr>
        <td width="100%" height="20">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <td width="36%" valign="absmiddle"><font size="1" face="Trebuchet MS">WAREHOUSE:</td>
            <td width="64%" valign="absmiddle"><b><font size="2" face="Trebuchet MS">
				#Warehouse#</font></b></td>
          </tr>
        </table>
        </td>
       </tr>
	   <tr>
        <td width="100%" height="20">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <td width="36%" valign="absmiddle"><font size="1" face="Trebuchet MS">BATCH NO:</td>
            <td width="64%" valign="absmiddle"><b><font size="2" face="Trebuchet MS">
				#BatchNo#</font></b></td>
          </tr>
        </table>
        </td>
       </tr>
    </table>
	</td>
	
	<td width="50%" valign="top" height="50">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	   <tr>
        <td width="100%" height="20">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <td width="36%" valign="absmiddle"><font size="1" face="Trebuchet MS">OFFICER:</td>
            <td width="64%" valign="absmiddle"><b><font size="2" face="Trebuchet MS">
				#OfficerFirstName# #OfficerLastName#</font></b></td>
          </tr>
        </table>
        </td>
       </tr>
	   <tr>
        <td width="100%" height="20">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <td width="36%" valign="absmiddle"><font size="1" face="Trebuchet MS">DATE:</td>
            <td width="64%" valign="absmiddle"><b><font size="2" face="Trebuchet MS">
				#DateFormat(Created, CLIENT.DateFormatShow)#</font></b></td>
          </tr>
        </table>
        </td>
       </tr>
    </table>
	</td>
	
	</tr>
	
	 <tr>
    <td width="100%" bgcolor="d2d2d2" height="1" colspan="2" align="center" valign="middle"></td>
	 </tr>
		
</cfoutput>

<tr><td colspan="2" height="100%" valign="top">

	<table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<cfoutput query="PickTicket" group="Location">
		
	<tr>
	<td colspan="7" height="20" >&nbsp;Picking from Location: <b>#Location#</td>
	</tr>
	
	<tr>
    <td bgcolor="d2d2d2" height="1" colspan="8" align="center" valign="middle"></td>
	</tr>
		
	<tr bgcolor="f4f4f4">
	   <td width="10" height="20"></td>
	   <td><b><cf_tl id="Item"></b></td>
	   <td><b><cf_tl id="Description"></b></td>
	   <td><b><cf_tl id="UoM"></b></td>
	   <td><b><cf_tl id="Reference"></b></td>
	   <td align="right"><b><cf_tl id="Quantity"></b></td>	  
	   <td align="right"><b><cf_tl id="Picked"></b></td>
	    <td align="right"><b><cf_tl id="Cost Price"></b></td>
	</tr>
	
	<tr><td height="1" colspan="8" class="linedotted"></td></tr>
	
	<tr><td></td></tr>
	
		<cfoutput>
		
		<tr>
		   <td height="20">#Currentrow#</td>
		   <td width="80">#ItemNo#</td>
		   <td width="40%">#ItemDescription#</td>
		   <td width="80">#UOMDescription#</td>
		   <td width="80">#Reference#</td>
		   <td width="80" align="right">#TransactionQuantity*-1#</td>
		   <td rowspan="2" height="25" width="120"
		       bgcolor="FDF2EA"
		       style="border: 1px solid Silver;"></td>
		    <td width="100" align="right">#numberformat(TransactionCostPrice,"__,__.__")#</td>	   
		</tr>
		
		<tr>
		<td></td>
		<td></td>
		<td></td>
		<td>#DateFormat(RequestDate,CLIENT.DateFormatShow)#</td>
		<td colspan="3">#Requester#</td>
		</tr>
		
		<tr><td height="3"></td></tr>
		
		<tr><td colspan="8" bgcolor="E5E5E5"></td></tr>
		
		<!---
			<cfif #AssetNo# neq "">
				 
				 <cfquery name="Asset"
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
						FROM   Asset
						WHERE  AssetNo = '#AssetNo#'
					</cfquery>
					
					<tr>
					   <td colspan="5">SerialNo: #Asset.SerialNo# Barcode: #Asset.AssetBarCode#</td>
					</tr>
		
			</cfif>
		--->
			
		</cfoutput>
	
</cfoutput>

</table>

</td></tr>

</table>

</td></tr></table>

<script>
	window.print()
</script>
