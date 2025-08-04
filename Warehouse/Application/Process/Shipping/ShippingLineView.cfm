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
<!--- Query returning detail information for selected item --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="Get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT S.*, 
	       O.OrgUnitName, 
		   R.ContactLastName, 
		   R.ContactFirstName, 
		   R.RequestDate, 
		   R.Submitted,
	       B.OfficerLastName, 
		   B.OfficerFirstName, 
		   B.Created, 
		   R.RequestType, 
		   R.RequestClass
	
	FROM   Shipping S LEFT OUTER JOIN
           Organization.dbo.Organization O ON S.OrgUnit = O.OrgUnit LEFT OUTER JOIN
           ShippingBatch B ON S.ShippingNo = B.TransactionBatchNo LEFT OUTER JOIN
           Request R ON S.RequestId = R.RequestId	   
  
    WHERE  S.TransactionRecordNo = '#URL.ID#' 
	
</cfquery>

<cf_dialogMaterial>

<script>

function sum(prc,qty)

{

var s = "" + Math.round((prc*qty) * 100) / 100

var i = s.indexOf('.')

if (i < 0) 
return shippingline.requestedamount.value = s + ".00"

var t = s.substring(0, i + 1) + s.substring(i + 1, i + 3)

if (i + 2 == s.length) t += "0"
return shippingline.requestedamount.value = t

}

</script>
		   
<cfparam name="URL.ID"  type="string" default="recordno">
<cfparam name="URL.ID1" type="string" default="0">
<cfparam name="URL.ID2" type="string" default="0">
<cfparam name="URL.ID3" type="string" default="0">
<cfparam name="URL.ID4" type="string" default="0">

<cfform action="ShippingLineSubmit.cfm" method="POST" name="shippingline">		  

<HTML><HEAD>
    <TITLE>Shipping - Line</TITLE>
	
</HEAD>

<body bgcolor="#FFFFFF" onLoad="window.focus()">

<table width="96%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#002350">
  <tr>
   <TD class="bannerXLN"><cfoutput><b>&nbsp;#Get.ItemDescription#</b></cfoutput></TD>
   <td align="right" class="bannerN">
  
<CF_DialogHeaderSub 
MailSubject="Warehouse" 
MailTo="" 
MailAttachment="" 
ExcelFile=""> 

</td></tr> 	

</table>

<cf_tableTop size="96%" omit="true">

<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">

<tr><td height="3" colspan="1" class="regular"></td></tr>		
<TR>
    
    <td width="140" height="20" class="regular">&nbsp;<b><cf_tl id="Reference">:</td>
    <td class="regular">&nbsp;
	<cfoutput>
	#Get.Reference#
    <input type="hidden" name="TransactionRecordNo" id="TransactionRecordNo" value="#Get.TransactionrecordNo#" size="10">
	<input type="hidden" name="RequestId" id="RequestId" value="#Get.RequestId#" size="10">
	</cfoutput>
	</td>
    </TR>
	
	<tr><td height="4"></td></tr>
	
    <TR>
    <TD class="regular">&nbsp;<b><cf_tl id="Item">:</TD>
    <TD class="regular">&nbsp;
		
	<cfoutput>
	
	<input type="text" name="itemdescription" id="itemdescription" value="&nbsp;#Get.ItemDescription#" size="60" readonly class="disabled">
    	
	<cfif #URL.ID1# is "0">
	<cf_tl id="Replace" var="1">
	<input type="button" class="button3" name="itemselect" id="itemselect" value=" #lt_text# " onClick="javascript:selectitem('shippingline','shippingitemno','itemdescription','transactionprice','transactionuom','warehouse','#Get.TransactionQuantity#');">
</cfif>
	<input type="hidden" name="shippingitemno" id="shippingitemno" value="#Get.ShippingItemNo#" size="4" class="disabled">
	</cfoutput>
	

	</TD>
    </TR>
	
	<tr><td height="4"></td></tr>

<TR>
    <TD height="20" class="regular">&nbsp;<b><cf_tl id="Quantity">:</TD>
    <TD class="regular">&nbsp;
	<cfoutput>
	<cfif #URL.ID1# is "0">
	   <cfinput type="Text" name="transactionquantity" value="#Get.TransactionQuantity#" class="regular" message="Please enter a quantity" validate="float" required="Yes" size="10" style="text-align: right" onChange="javascript:sum(transactionprice.value,this.value);">
	<cfelse>
	   <input type="text" name="transactionquantity" id="transactionquantity" value="#Get.TransactionQuantity#" size="10" readonly class="disabled" style="text-align: right">
	</cfif>   
	
	<input type="text" name="transactionuom" id="transactionuom" value="&nbsp;#Get.TransactionUoM#" size="20" readonly class="disabled">
	</cfoutput>
	
	
	</TD>
    </TR>
	
	<tr><td height="4"></td></tr>
	
<TR>
    <TD height="20" class="regular">&nbsp;<b><cf_tl id="Cost price">:</TD>
    <TD class="regular">&nbsp;
	<cfoutput>
	<input type="text" name="transactionprice" id="transactionprice" value="#NumberFormat(Get.TransactionPrice,'_____.__')#" size="10" readonly style="text-align: right;" class="disabled">
	</cfoutput>
	</TD>
    </TR>
	
	<tr><td height="4"></td></tr>
		
<TR>
    <TD height="20" class="regular">&nbsp;<b><cf_tl id="Amount">:</TD>
    <TD class="regular">&nbsp;
	<cfoutput>
	<input type="text" name="requestedamount" id="requestedamount" value="#NumberFormat(Get.TransactionValue,'_____.__')#" size="10" readonly style="text-align: right;" class="disabled">
	</cfoutput>
	</TD>
    </TR>
	
	<tr><td height="4"></td></tr>
	
	<TR>
    <TD height="20" class="regular">&nbsp;<b><cf_tl id="Warehouse">:</TD>
    <TD class="regular">&nbsp;
	<cfoutput>
	#Get.Warehouse# #Get.Location#
	<input type="hidden" name="warehouse" id="warehouse" value="#Get.Warehouse#" size="10" readonly style="text-align: right;" class="disabled">
	<input type="hidden" name="location" id="location" value="#Get.Location#" size="10" readonly style="text-align: right;" class="disabled">
	</cfoutput>
	</TD>
    </TR>	
	
	
	
    <tr><td height="3" colspan="1" class="regular"></td></tr>		
    <tr><td height="1" colspan="2" bgcolor="#6688aa"></td></tr>	
    <tr><td height="3" colspan="1" class="regular"></td></tr>	
	  	
	<tr><td height="4"></td></tr>
		

<TR>
    <TD height="20" class="regular">&nbsp;<b><cf_tl id="Requested by">:</TD>
    <TD class="regular">&nbsp;
	<cfoutput>
	  #Get.ContactFirstName# #Get.ContactLastName#
	</cfoutput>
	</TD>
    </TR>	
	
	<tr><td height="5"></td></tr>
	
<TR>
    <TD height="20" class="regular">&nbsp;<b><cf_tl id="Customer">:</TD>
	<TD class="regular">&nbsp;
	<cfoutput>
	#Get.OrgUnitName#
	</cfoutput>
	</TD>
    </TR>	

	
	<tr><td height="6"></td></tr>
	
<TR>
    <TD height="20" class="regular">&nbsp;<b><cf_tl id="Date Requested">:</TD>
    <TD class="regular">&nbsp;
	<cfoutput>
	#Dateformat(Get.RequestDate,CLIENT.DateFormatShow)#
	</cfoutput>
    </TD>
    </TR>	
	
	<tr><td height="6"></td></tr>
	
<TR>
    <TD height="20" class="regular">&nbsp;<b><cf_tl id="Date Submitted">:</TD>
    <TD class="regular">&nbsp;
	<cfoutput>
	#Dateformat(Get.Submitted,CLIENT.DateFormatShow)#
	</cfoutput>
    </TD>
    </TR>	
	
	<tr><td height="6"></td></tr>	
	
<TR>
    <TD height="20" class="regular">&nbsp;<b><cf_tl id="Processed by">:</TD>
    <TD class="regular">&nbsp;
	<cfoutput>
	#Get.OfficerFirstName# #Get.OfficerLastName# [#Dateformat(Get.Created,CLIENT.DateFormatShow)#]
	</cfoutput>
    </TD>
    </TR>
	
	<tr><td height="6"></td></tr>
	
<TR>
    <TD height="20" class="regular">&nbsp;<b><cf_tl id="Request Type">:</TD>
    <TD class="regular">&nbsp;
	<cfoutput>
	   #Get.RequestType#
 	</cfoutput>
	</TD>
    </TR>
	
	<tr><td height="6"></td></tr>
	
<TR>
    <TD height="20" class="regular">&nbsp;<b><cf_tl id="Request Class">:</TD>
    <TD class="regular">&nbsp;
	<cfoutput>
	#Get.RequestClass#
	</cfoutput>
	</TD>
    </TR>
	
</table>

</td>

</table>

<cf_tableBottom size="96%">

<HTML>
<hr>

<div align="right">
<cfoutput>
<cf_tl id="Request Class" var="1">
<input class="button1" type="button" name="Close" id="Close" value="    #lt_text#  " onClick="javascript:window.close()">

<cfif #Get.Status# is "1" or #Get.Status# is "0">	
<cf_tl id="Update" var="1">
<input class="button1" type="submit" name="update" id="Update" value="    #lt_text#  ">
<cf_tl id="Delete" var="1">
<input class="button1" type="submit" name="purge" id="purge" value="    #lt_text#    ">
</cfif>
</cfoutput>
&nbsp;
</div>

</BODY></CFFORM>

</HTML>