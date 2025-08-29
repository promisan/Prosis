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


<cfparam name="URL.Pick" default="">

<HTML>

<HEAD>

<TITLE><cf_tl id="Warehouse Picktickets Preparation"></TITLE>

</HEAD>

<cfoutput>

<cf_tl id="Do you want to prepare packingslips now" var="1">

<script>

function minimize(itm,icon,st){
	 
	 se0  = document.getElementById(itm+"0")
	 se1  = document.getElementById(itm+"1")
	 se0.className = "hide";
	 se1.className = "hide";
	 ic0  = document.getElementById(itm+"day")
	 ic0.className = "hide"
	 icM  = document.getElementById(itm+"Min")
	 icM.className = "hide";
     icE  = document.getElementById(itm+"Exp")
	 icE.className = "regular";
			 
  }
  
function expand(itm,icon,st){
	 
     ic0  = document.getElementById(itm+"day")
	 ic0.className = "regular"
	 		 
	 icM  = document.getElementById(itm+"Min")
	 icM.className = "regular";
	 
     icE  = document.getElementById(itm+"Exp")
	 icE.className = "hide";
	 
	 se0  = document.getElementById(itm+"0")
	 se1  = document.getElementById(itm+"1")
	 
	 if (st == "0")
	 
	 {
	   se0.className="regular"
	   se1.className="hide"
	 }
	 
	 else
	 
	 {
	 
	   se1.className="regular"
	   se0.className="hide"
	 
	 }
				
  }  

function ask() {
	if (confirm("#lt_text# ?")) {	
	return true 
	}	
	return false
	
}	

function reloadForm(group,page,warehouse,status) {
    window.location="ShippingListing.cfm?IDSorting=" + group + "&Page=" + page + "&IDWarehouse=" + warehouse + "&IDStatus=" + status;
}

if (screen) 
{
w = screen.width - 60;
h = screen.height - 200;
}


ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){
     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight2";
	 }else{
		
     itm.className = "regular";		
	 }
  }

function enter(itm)
  
  {

  
   if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 itm.className = "highLight";
    
  }
  
function exit(itm)
  
  {

  
   if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 itm.className = "regular";
    
  }
  

</script>	
</cfoutput>
	
<cf_dialogMaterial>

<cfparam name="URL.IDStatus" default="0">

<cfparam name="URL.IDSorting" default="HierarchyCode">

<cfquery name="Status"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Status
	WHERE Class = 'Shipping'
	AND Show = '1'
</cfquery>

<cfquery name="warehouse" datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT Warehouse
		FROM  OrganizationAuthorization O, 
		      Materials.dbo.Warehse L
		WHERE O.UserAccount = '#SESSION.acc#'
		AND   O.AccessLevel IN ('0','1','2')
		AND   O.Role = 'WhsShip'
		AND   L.OrgUnit = O.OrgUnit
</cfquery>

<cfparam name="URL.IDWarehouse" default="#Warehouse.Warehouse#">

<cfif URL.IDWarehouse neq "">
    <cfset cond = "AND R.Warehouse = '#URL.IDWarehouse#'">
<cfelse>
    <cfset cond = "">	
</cfif>

<cfquery name="SearchResult" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT DISTINCT R.*, Org.HierarchyCode, Org.OrgUnitName
   FROM dbo.Shipping R, Organization.dbo.OrganizationAuthorization O, Warehse L, Organization.dbo.Organization Org
   WHERE (R.Status = '#URL.IDStatus#')
     AND  O.UserAccount = '#SESSION.acc#'
	 AND  O.AccessLevel IN ('0','1','2')
	 AND  O.Role = 'WhsShip'
	 AND  L.OrgUnit = O.OrgUnit
	 AND  Org.OrgUnit = R.OrgUnit
	 AND  L.Warehouse = R.Warehouse
          #PreserveSingleQuotes(cond)#
    ORDER BY #URL.IDSorting#, Reference
</cfquery>

<!--- Query returning search results --->

<body onLoad="javascript:document.forms.result.page.focus();" class="Main">

<form action="ShippingProcess.cfm" method="post" name="result" id="result" onSubmit="return ask()">

<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr>
   <TD class="bannerXLN">
    <cfoutput query="Warehouse">
	<input type="radio" name="warehouse" id="warehouse" value="#Warehouse#" <cfif #Warehouse# is '#URL.IDWarehouse#'>checked</cfif> onClick="javascript:reloadForm(result.group.value,result.page.value,this.value,result.status.value)">
	<cfif #Warehouse# is '#URL.IDWarehouse#'><font face="Tahoma" size="4"><b><u>#Warehouse#</u></b></font>
	<input type="hidden" name="warehousesel" id="warehousesel" value="#Warehouse#">
	<cfelse><font face="Tahoma" size="3"><b>#Warehouse#</b></font>
	</cfif>
	</cfoutput>
   </TD>
   <td align="right" class="bannerN">
  
<CF_DialogHeader 
MailSubject="Warehouse" 
MailTo="" 
MailAttachment="" 
ExcelFile=""> 

 <cfinclude template="../../../Tools/PageCount.cfm">
<select name="page" id="page" size="1" style="background: #C9D3DE;" onChange="javascript:reloadForm(group.value,this.value,warehousesel.value,status.value)">
    <cfloop index="Item" from="1" to="#pages#" step="1">
        <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>><cf_tl id="Page"> #Item# <cf_tl id="of"> #pages#</option></cfoutput>
    </cfloop>	 
</SELECT>   	&nbsp;

</td></tr> 	

</table>

<cf_tableTop size="100%" omit="true">

<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">

<tr><td>

<cf_tableTop size="100%">
<table width="100%">
<cfoutput>
<tr>
<td class="regular"><b><cf_tl id="Today's distribution lists"></b></td>
<td align="right" class="regular" id="pdfday">
   
   <input type="radio" name="period" id="period" value="0" checked onClick="expand('pdf','Exp','0')"><cf_tl id="today only">
   <input type="radio" name="period" id="period" value="1" onClick="expand('pdf','Exp','1')"><cf_tl id="all documents">
   
   </td>

   <td class="regular" align="right">   
   
   <img src="#SESSION.root#/Images/portal_max.JPG" id="PdfExp" border="0" class="hide" 
   align="middle" style="cursor: pointer;" onClick="expand('pdf','Exp','0')">
   
   <img src="#SESSION.root#/Images/portal_min.JPG" id="PdfMin" border="0" align="middle" class="regular" style="cursor: pointer;" 
   onClick="minimize('pdf','Min','0')">&nbsp;
       
   </td></tr>
   <tr><td colspan="3">
		<table width="100%" id="pdf0">
		<tr><td>
	
        	<iframe src="../../../Tools/PDF/PDFLibrary.cfm?ID=Shipping&TODAY=1" name="inline" id="inline" width="100%" height="130" frameborder="0" style="border: thin"></iframe>		

		</td></tr>
		</table>
		<table width="100%" id="pdf1" class="hide">
		<tr><td>
	
        	<iframe src="../../../Tools/PDF/PDFLibrary.cfm?ID=Shipping&TODAY=0" name="inline" id="inline" width="100%" height="100%" scrolling="no" frameborder="0" style="border: thin"></iframe>		

		</td></tr>
		</table>
		
</td></tr>
</cfoutput>		
</table>
<cf_tableBottom size="100%">
</td></tr>

<tr>

<td colspan="2">

<cf_tableTop size="100%">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<TR>

<td height="25" colspan="5" align="left">

	<select name="status" id="status" style="background: #C9D3DE;" accesskey="P" title="Status Selection" onChange="javascript:reloadForm(group.value,page.value,warehousesel.value,this.value)">
	    <cfoutput query="Status">
		<option value="#Status#" <cfif #Status# is '#URL.IDStatus#'>selected</cfif>>
		<font face="Tahoma" size="1">
		#Description#
		</font></option>
		</cfoutput>
	</select>
	
	<select name="group" id="group" size="1" style="background: #C9D3DE;" onChange="javascript:reloadForm(this.value,result.page.value,warehousesel.value,result.status.value)">
     <option value="TransactionDate" <cfif #URL.IDSorting# eq "TransactionDate">selected</cfif>><cf_tl id="Group by Date">
     <OPTION value="HierarchyCode" <cfif #URL.IDSorting# eq "HierarchyCode">selected</cfif>><cf_tl id="Group by Customer">
     <OPTION value="ShippingItemNo" <cfif #URL.IDSorting# eq "ShippingItemNo">selected</cfif>><cf_tl id="Group by ItemNo">
	 <cfif #URL.IDStatus# gt '0'>
    	<OPTION value="ShippingNo" <cfif #URL.IDSorting# eq "ShippingNo">selected</cfif>><cf_tl id="Group by Shipping List">
	 </cfif>
	 
</SELECT> 

</td>

<cfif searchresult.status is "0">
<td height="25" colspan="9" align="right">
<cf_tl id="Prepare packingslip" var="1">
<input class="button1" type="submit" name="Packing" id="Packing" value="#lt_text#"></td>
</cfif>
<cfif searchresult.status is "1">
<td height="25" colspan="9" align="right">
<!--- <input class="button1" type="submit" name="Receipt" value="Confirm receipt"></td> --->
</cfif>
<cfif #searchresult.status# is "9">
<td height="25" colspan="9" align="right">
<cf_tl id="Confirm return" var="1">
<input class="button1" type="submit" name="Return" id="Return" value="#lt_text#"></td> 
</cfif>

</tr>

<tr><td height="3"></td></tr>

<tr bgcolor="#8EA4BB">
    <td width="5%" height="18"></td>
	<TD width="10%" align="left" class="regular"><cf_tl id="RequestNo"></TD>
	<TD width="5%"></TD>
	<TD width="8%" align="left" class="regular"><cf_tl id="ItemNo"></TD>
	<TD width="34%" align="left" class="regular"><cf_tl id="Description"></TD>
    <TD width="10%" align="left" class="regular"><cf_tl id="UoM"></TD>
    <TD width="10%" align="right" class="regular"><cf_tl id="Qty"></TD>
	<td width="10%" align="right" class="regular"><cf_tl id="Price"></td>
	<td width="10%" align="right" class="regular"><cf_tl id="Total">&nbsp;</td>
</TR>

<cfset amtT    = 0>

<cfoutput query="SearchResult" group=#URL.IDSorting# startrow=#first# maxrows=#No#>

    <cfset amt    = 0>
    
   <tr bgcolor="ffffcf">

   <cfswitch expression = #URL.IDSorting#>
     <cfcase value = "TransactionDate">
	     <td colspan="9" class="top2n"><b>&nbsp;#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</b></td>
     </cfcase>
     <cfcase value = "HierarchyCode">
	     <td colspan="9" class="top2n"><b>&nbsp;#OrgUnitName#</b></td> 
     </cfcase>	 
     <cfcase value = "ShippingItemNo">
		 <td colspan="9" class="top2n"><b>&nbsp;#ShippingItemNo# #ItemDescription#</b></td>
     </cfcase>
     <cfcase value = "ShippingNo">
		 <td colspan="2" class="top2n"><b>&nbsp;<cf_tl id="No">:</b></td>
		 <td colspan="6" class="top2n"><b>&nbsp;#ShippingNo#</b></td>
		 <td align="right">
		 <button style="background: ButtonHighlight;" onClick="javascript:packingslip('#ShippingNo#','1')">
	       	 <img src="<cfoutput>#SESSION.root#</cfoutput>/images/view.JPG" alt="" width="18" height="15" border="0" align="bottom">
		 </button>&nbsp;</td>
		 <tr bgcolor="ffffcf">
		 <td colspan="2" class="top2n"><b>&nbsp;<cf_tl id="Date">:</b></td>
		 <td colspan="7" class="top2n"><b>&nbsp;#Dateformat(ShippingDate, "#CLIENT.DateFormatShow#")#</b></td>
		 </tr>
     </cfcase>	 
   </cfswitch>
   
   </tr>
   
     
<CFOUTPUT>

    <tr class="highLight2">
		
	<td align="left" valign="top">
	<cfif #Status# is '0' or #Status# is "9">
	<input type="checkbox" name="selected" id="selected" value="'#TransactionRecordNo#'" onClick="hl(this,this.checked)" checked>
	</cfif>
	</td>
		
	<td valign="top" class="regular">#Reference#</td>
	 <td align="left">
	<img src="<cfoutput>#SESSION.root#</cfoutput>/images/document.gif" alt="" border="0" style="cursor: pointer;" onClick="javascript:ShowShipping('#TransactionRecordNo#','#Status#','1','z','z','z')">
	</td>
	<TD valign="top" class="regular"><A href="javascript:ShowItem('#ShippingItemNo#')">#ShippingItemNo#</a></TD>
	<TD valign="top" class="regular">#ItemDescription#</TD>
    <TD valign="top" class="regular">#TransactionUoM#</TD>
    <TD valign="top" align="right" class="regular">#TransactionQuantity#</TD>
    <td valign="top" align="right" class="regular">#NumberFormat(TransactionPrice,'_____,__.__')#&nbsp;</td>	
	<td valign="top" align="right" class="regular">#NumberFormat(TransactionValue,'_____,__.__')#&nbsp;</td>	
	
	<cfset Amt = Amt + #TransactionValue#>
    <cfset AmtT = AmtT + #TransactionValue#>
    		
	</TR>
	
	<cfif #Status# eq "9">
	
	<tr>
	
	<td height="1" colspan="1" bgcolor="f6f6f6">
		<img src="<cfoutput>#SESSION.root#</cfoutput>/images/join.gif" alt="" border="0">
	</td>
	
	<td height="1" colspan="8" bgcolor="f6f6f6">
	
			<table width="100%">
			<tr>
			  <td width="30%" class="regular">#DeliveredFirstName# #DeliveredLastName#&nbsp;</td>
			  <td width="20%" class="regular">#DateFormat(DeliveryDate, CLIENT.DateFormatShow)#&nbsp;</td>
			  <td width="50%" class="regular">#DeliveryReference#&nbsp;</td>
		    </tr>
			</table>
		
	</td></tr>
	
	</cfif>

</CFOUTPUT>

<TR>
    <td colspan="8" align="center">
	<td align="right"><hr></td>	
   </TR>
   
    <TR>
    <td colspan="8" align="center">
	<td align="right"><font size="1" face="Tahoma"><b>#NumberFormat(Amt,'_____,__.__')#&nbsp;</b></font></td>	
    </TR>

<tr><td height="10" colspan="8"></td></tr>

</CFOUTPUT>

<TR>
    <td colspan="8" align="center">
	<td align="right"><hr></td>	
   </TR>
   
   

   <TR>
    <td colspan="8" align="center">
	<td align="right"><font size="1" face="Tahoma"><b><cfoutput>#NumberFormat(AmtT,'_____,__.__')#&nbsp;</cfoutput></b></font></td>	
  </TR>


</TABLE>

<cf_tableBottom size="100%">

</td>

</TABLE>

<cf_tableBottom size="100%">

<!--- <cfinclude template="InquiryAging.cfm"> --->
 
<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.welcome#</cfoutput></font> </p>

</form>

</BODY></HTML>