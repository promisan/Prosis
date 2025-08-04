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

<HTML>

<HEAD>
    <TITLE>Requisition - Detail</TITLE>
</HEAD>

<body bgcolor="#FFFFFF" leftmargin="3" topmargin="3" rightmargin="3" onLoad="window.focus()">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="Get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.*, I.*, 
	       O.ItemDescription as ItemNoOrginalDescription, 
		   Org.OrgUnitName
		   
	FROM   Request R INNER JOIN
           Item I ON R.ItemNo = I.ItemNo INNER JOIN
           Organization.dbo.Organization Org ON R.OrgUnit = Org.OrgUnit LEFT OUTER JOIN
           Item O ON R.ItemNoOriginal = O.ItemNo	   
	   
    WHERE  R.RequestId = '#URL.ID#' 
	
</cfquery>

<cfquery name="Fulfilled" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   SUM(T.TransactionQuantity) AS Quantity
FROM     ItemTransaction T 
WHERE    CustomerId = '#URL.ID#'
</cfquery>

<cfquery name="Warehouse" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Warehouse
</cfquery>

<cf_dialogMaterial>

<script>

function sum(prc,qty) {

var s = "" + Math.round((prc*qty) * 100) / 100

var i = s.indexOf('.')

if (i < 0) 
return warehouseline.requestedamount.value = s + ".00"

var t = s.substring(0, i + 1) + s.substring(i + 1, i + 3)

if (i + 2 == s.length) t += "0"
return warehouseline.requestedamount.value = t

}

</script>
		   
<cfparam name="URL.ID"  type="string" default="recordno">
<cfparam name="URL.ID1" type="string" default="0">
<cfparam name="URL.ID2" type="string" default="0">
<cfparam name="URL.ID3" type="string" default="0">
<cfparam name="URL.ID4" type="string" default="0">

<cfform action="RequisitionLineSubmit.cfm" method="POST" name="warehouseline">		

<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="silver">
  <tr>
   <td height="26" class="top3n">
   <font face="Verdana" size="2"><cfoutput>&nbsp;<b>#Get.ItemDescription# <cf_tl id="details"></b></cfoutput></td>
   <td align="right" class="top3n">
  
</td></tr> 	
<td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" class="formpadding" style="border-collapse: collapse">

<TR>
    
    <td width="140" height="20" >&nbsp;<cf_tl id="Reference">:</td>
    <td >&nbsp;
	<cfoutput>
	#Get.Reference#
    <input type="hidden" name="RequestId" id="RequestId" value="#Get.RequestId#" size="10">
	</cfoutput>
	</td>
    </TR>
	
	<tr><td height="1" colspan="2" bgcolor="F4F4F4"></td></tr>	
	
    <TR>
    <TD >&nbsp;<cf_tl id="Item">:</TD>
    <TD >&nbsp;
		
	<cfoutput>
	
	<input type="text" name="itemdescription" id="itemdescription" value="&nbsp;#Get.ItemDescription#" size="60" readonly class="disabled">
    	
	<cfif URL.ID1 is not "0">
	<cf_tl id="Replace" var="1">
	<input type="button" class="button7" name="itemselect" id="itemselect" value=" #lt_text# " onClick="javascript:selectitem('warehouseline','itemno','itemdescription','standardcost','unitofmeasure','warehouse','#Get.RequestedQuantity#');">
	</cfif>
	<input type="hidden" name="itemno" id="itemno" value="#Get.ItemNo#" size="4" class="disabled">
	</cfoutput>
	
	</TD>
</TR>
	
<tr><td height="1" colspan="2" bgcolor="F4F4F4"></td></tr>	
	
<TR>

    <TD height="20" >&nbsp;<cf_tl id="Quantity">:</TD>
    <TD >&nbsp;
	<cfoutput>
	<cfif URL.ID1 is not "0">
	   <cfinput type="Text" 
	       name="requestedquantity" 
		   value="#Get.RequestedQuantity#"  
		   class="regular" 
		   message="Please enter a quantity" 
		   validate="float" 
		   required="Yes" 
	       size="10" 
		   style="text-align: right" 
		   onChange="javascript:sum(standardcost.value,this.value);">
	<cfelse>
	   <input type="text" name="RequestedQuantity" id="RequestQuantity" value="#Get.RequestedQuantity#" size="10" readonly class="disabled" style="text-align: right">
	</cfif>   
	
	<input type="text" name="unitofmeasure" id="unitofmeasure" value="&nbsp;#Get.UnitofMeasure#" size="20" readonly class="disabled">
	</cfoutput>
	
	</TD>
 </TR>
	
<tr><td height="1" colspan="2" bgcolor="F4F4F4"></td></tr>	
		
<TR>
    <TD height="20" >&nbsp;<cf_tl id="Cost price">:</TD>
    <TD >&nbsp;
	<cfoutput>
	<input type="text" name="standardcost" id="standardcost" value="#NumberFormat(Get.StandardCost,'_____.__')#" size="10" readonly style="text-align: right;" class="disabled">
	</cfoutput>
	</TD>
    </TR>
	
	<tr><td height="1" colspan="2" bgcolor="F4F4F4"></td></tr>	
			
<TR>
    <TD height="20" >&nbsp;<cf_tl id="Amount">:</TD>
    <TD >&nbsp;
	<cfoutput>
	<input type="text" name="requestedamount" id="requestedamount" value="#NumberFormat(Get.RequestedAmount,'_____.__')#" size="10" readonly style="text-align: right;" class="disabled">
	</cfoutput>
	</TD>
    </TR>
	
	<tr><td height="1" colspan="2" bgcolor="F4F4F4"></td></tr>	
	
<TR>
    <TD height="20" >&nbsp;<cf_tl id="Fulfilled">:</TD>
	<TD >&nbsp;
	<cfoutput>
	#Fulfilled.Quantity#
	</cfoutput>
	</TD>
    </TR>
	
	<tr><td height="1" colspan="2" bgcolor="F4F4F4"></td></tr>	
		
<TR>
    <TD height="20" >&nbsp;<cf_tl id="Memo">:</TD>
    <TD >&nbsp;
	<cfoutput>
	    #Get.Remarks#
	</cfoutput>
    </TD>
    </TR>
	   
    <tr><td height="1" colspan="2" bgcolor="F4F4F4"></td></tr>	
   	
   <TR>
    <TD height="20" >&nbsp;<cf_tl id="Fulfill by">:</TD>
    <TD >&nbsp;
	<cfoutput>
	    <input type="text" name="warehouse" id="warehouse" value="&nbsp;#Get.Warehouse#" size="10" readonly class="disabled">
	</cfoutput>
	</TD></TR>
					
	<cfif #URL.ID1# is not "0">
	
	<tr><td height="1" colspan="2" bgcolor="F4F4F4"></td></tr>	
	
	<TR>
	<TD height="20" >&nbsp;<cf_tl id="Redirect request to">:</TD>
    <TD >&nbsp;
	     			  
	 		<select name="warehousenew" id="warehousenew">
            <cfoutput query="Warehouse">
        	   <option value="#Warehouse#" <cfif #Warehouse# is '#Get.Warehouse#'>selected</cfif>>
           	   #Warehouse#
			 </option>
         	</cfoutput>
			</select>
    </TD>
    </TR>				
					       
	</cfif>
	
<tr><td height="1" colspan="2" bgcolor="F4F4F4"></td></tr>	

<TR>
    <TD height="20" >&nbsp;<cf_tl id="Requested by">:</TD>
    <TD >&nbsp;
	<cfoutput>
	  #Get.ContactFirstName# #Get.ContactLastName#
	</cfoutput>
	</TD>
    </TR>	
	
<tr><td height="1" colspan="2" bgcolor="F4F4F4"></td></tr>	
		
<TR>
    <TD height="20" >&nbsp;<cf_tl id="Section">:</TD>
    <TD >&nbsp;
	<cfoutput>
   	#Get.OrgUnitName#
	</cfoutput>
	</TD>
    </TR>	
	
<tr><td height="1" colspan="2" bgcolor="F4F4F4"></td></tr>	
		
<TR>
    <TD height="20" >&nbsp;<cf_tl id="Date Requested">:</TD>
    <TD >&nbsp;
	<cfoutput>
	#Dateformat(Get.RequestDate,CLIENT.DateFormatShow)#
	</cfoutput>
    </TD>
    </TR>	
	
	<tr><td height="1" colspan="2" bgcolor="F4F4F4"></td></tr>	
		
<TR>
    <TD height="20" >&nbsp;<cf_tl id="Date Submitted">:</TD>
    <TD >&nbsp;
	<cfoutput>
	#Dateformat(Get.Submitted,CLIENT.DateFormatShow)#
	</cfoutput>
    </TD>
    </TR>	
	
	<tr><td height="1" colspan="2" bgcolor="F4F4F4"></td></tr>	
		
<TR>
    <TD height="20" >&nbsp;<cf_tl id="Approved by">:</TD>
    <TD >&nbsp;
	<cfoutput>
	#Get.ReviewerFirstName# #Get.ReviewerLastName# [#Dateformat(Get.ReviewDate,CLIENT.DateFormatShow)#]
	</cfoutput>
    </TD>
    </TR>
	
	<tr><td height="1" colspan="2" bgcolor="F4F4F4"></td></tr>	
		
<TR>
    <TD height="20" >&nbsp;<cf_tl id="Request Type">:</TD>
    <TD >&nbsp;
	<cfoutput>
	   #Get.RequestType#
 	</cfoutput>
	</TD>
    </TR>
	
	<tr><td height="1" colspan="2" bgcolor="F4F4F4"></td></tr>	
	
<TR>
    <TD height="20" >&nbsp;<cf_tl id="Request Class">:</TD>
    <TD >&nbsp;
	<cfoutput>
	#Get.RequestClass#
	</cfoutput>
	</TD>
    </TR>
		
<cfif URL.ID1 is not "0">	

<tr><td height="3" colspan="1"></td></tr>	
<tr><td height="1" colspan="2" bgcolor="gray"></td></tr>	
	
<TR>
    <td height="20" >&nbsp;<cf_tl id="Memo">:</td>
    <TD >&nbsp;
	<cfoutput>
	<input type="text"  name="ReviewRemarks" id="ReviewRemarks" value="#Get.ReviewRemarks#" size="60">
	</cfoutput>
	</TD>
    </TR>
	<tr><td height="3" colspan="1" ></td></tr>	
</cfif>	

</table>

</td>

</table>

</td>

<tr><td height="25" colspan="2" align="right" >
<cf_tl id="Close" var="1">
<input class="button10p" type="button" name="Close" id="Close" value="    #lt_text#    " onClick="javascript:window.close()">

<cf_tl id="Submit" var="1">
<input class="button10p" type="submit" name="submit" id="submit" value="    #lt_text#    ">&nbsp;

</td></tr>

</table>

</CFFORM>

</BODY>

</HTML>