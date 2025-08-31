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
<cf_tl id="Receipt and Inspection" var ="1">

<cf_screentop height="100%" label="#lt_text#" scroll="Yes" html="Yes" layout="webapp" jQuery="yes" banner="gray" bannerforce="Yes" line="no">

<cfquery name="Asset" 
 datasource="appsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM   AssetItem
 WHERE  ReceiptId = '#URL.ID#'
</cfquery>

<cfquery name="Mission" 
 datasource="appsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT R.Mission
 FROM   PurchaseLineReceipt L, Receipt R
 WHERE  L.Receiptno = R.ReceiptNo
 AND    L.ReceiptId = '#URL.ID#'
</cfquery>


<!--- check if record exist in db --->
<cfif Asset.recordcount gt "0">
	<cflocation url="ReceiptParentEdit.cfm" addtoken="No">
</cfif>

<cfquery name="Receipt" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM   Receipt R, 
        PurchaseLineReceipt L, 
		RequisitionLine S
 WHERE  R.ReceiptNo = L.ReceiptNo 
 AND    L.RequisitionNo = S.RequisitionNo
 AND    ReceiptId = '#URL.ID#'
</cfquery>

<cfparam name="URL.ID1" default="#Receipt.ItemMaster#">

<cfquery name="Parameter" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT  *
  FROM  Parameter
</cfquery>

<cfoutput>

<script language="JavaScript">

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     document.getElementById("submit").className = "button10g"

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
  

function more(bx,itm) {
 
	icM  = document.getElementById(bx+"Min")
    icE  = document.getElementById(bx+"Exp")
	se   = document.getElementById(bx);
			 		 
	if (se.className == "hide") {
	   	 icM.className = "regular";
	     icE.className = "hide";
		 se.className  = "regular";
		 url = "ReceiptParentDetail.cfm?category=" + bx + "&itemno=" + itm		 
		 ptoken.navigate(url,'i'+bx)	
	 } else {
	   	 icM.className = "hide";
	     icE.className = "regular";
    	 se.className  = "hide"
	 }
		 		
  }

</script>  

</cfoutput>
 
<table width="99%" align="center" align="center">

<tr><td>
<cfinclude template="ReceiptInfo.cfm">
</td></tr>

<tr><td>

	<cfform action="ReceiptParentEntry.cfm?ID=#URL.ID#&mission=#Mission.mission#" style="width:98%;height:98%" method="POST" name="assetselect" target="result">
	
	<table width="98%" align="center" class="formspacing">
	
	<cfquery name="Category" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Ref_Category
	  WHERE  Category IN (SELECT Category 
	                      FROM Item 
						  WHERE ItemNo = '#Receipt.WarehouseItemNo#')
	  ORDER BY Description
	</cfquery>
	<tr>
		<td bgcolor="ffffff" colspan="2" height="23" align="center" class="labelmedium">
		<cf_tl id="Associate this receipt to one or more asset items" class="Message"></td>  
	</tr> 	
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<cfquery name="Parent" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	     FROM  Item I, ItemUoM U
		 WHERE I.ItemNo = U.ItemNo
		 AND   U.ItemNo   = '#Receipt.WarehouseItemNo#'
		 AND   U.UoM      = '#Receipt.WarehouseUoM#'
		 ORDER BY I.ItemDescription
	</cfquery>
	
	<cfif Parent.recordcount eq "1">
	
	    <cfoutput>
			<tr><td colspan="2">
			
				<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
					<TR>
				  	  	<TD width="7%" class=labelmedium><cf_tl id="No"></TD>
						<TD width="15%" class=labelmedium><cf_tl id="Stock No"></TD>
						<TD width="58%" class=labelmedium><cf_tl id="Description"></TD>
						<TD width="10%" class=labelmedium><cf_tl id="UoM"></TD>
						<TD width="10%" class=labelmedium></TD>
					</TR>
									
					<TR class="linedotted highlight2">
				    	<TD class=labelmedium style="padding-left:4px">#Parent.ItemNo#</TD>
						<TD class=labelmedium>#Parent.CommodityCode#</TD>
				    	<TD class=labelmedium>#Parent.ItemDescription#</TD>
						<TD class=labelmedium>#Parent.UoM#</TD>
				    	<TD><input type="checkbox" class="radiol" name="ItemUoMId" id="ItemUoMId"  checked value="'#Parent.ItemUoMId#'" onClick="hl(this,this.checked)"></TD>
					</tr>
				</table>
			
			</td></tr>
			<tr><td colspan="2" class="linedotted"></td></tr>
		</cfoutput>
		
	</cfif>	
		
	
	<cfoutput query="Category">
	
		<tr>
	   	
		<td width="4%" height="21" align="center">
		
				<img src="#SESSION.root#/Images/ct_collapsed.gif" alt="" 
					id="#Category#Exp" border="0" class="show" 
					align="middle" style="cursor: pointer;" 
					onClick="more('#Category#','#Receipt.WarehouseItemNo#')">
					
					<img src="#SESSION.root#/Images/ct_expanded.gif" 
					id="#Category#Min" alt="" border="0" 
					align="middle" class="hide" style="cursor: pointer;" 
					onClick="more('#Category#','#Receipt.WarehouseItemNo#')">
		
		</td>
		<td class="labelmedium"><a href="javascript:more('#Category#','#Receipt.WarehouseItemNo#')">#Description#</a></td>  
		</tr> 	
		
	
	<tr><td height="1" colspan="4" class="linedotted"></td></tr>
		
		<tr class="hide" id="#Category#"><td colspan="2">
			<cfdiv id="i#Category#">
		</td></tr>
	
	</cfoutput>
	
	 <tr>
	    <td align="center" height="27" colspan="4">
		 <input type="button" name="button" id="button" class="button10s" style="width:120;height:24;font-size:13px" value="Close" onclick="window.close()">
	 	  <cf_tl id="Register" var="1">
		  <cfoutput>
		  <input type="submit" name="submit" id="submit" value="#lt_text#" class="button10s" style="width:120;height:24;font-size:13px">
		  </cfoutput>
	     </td>
	 </tr> 	
	 
	</table>	
	
	</cfform>

	</td>
</tr>

</table>

<cf_screenbottom layout="webapp">