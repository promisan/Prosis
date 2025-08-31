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
<cfparam name="Form.AssetNo" default="1">
<cfparam name="URL.ID" default="{32B9AE38-7C75-47F2-A4E7-2C38DC1020CC}">

<cfform action="ReceiptParentEntrySubmit.cfm?ID=#URL.ID#" method="POST" name="functionselect">

<cfoutput>
	<input type="hidden" name="AssetNo" Id="AssetNo" value="#Form.AssetNo#">
</cfoutput>

<cfquery name="Receipt" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM   Receipt R, PurchaseLineReceipt L 
 WHERE  R.ReceiptNo = L.ReceiptNo 
 AND    ReceiptId = '#URL.ID#'
</cfquery>

<cfquery name="Parameter" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT  *
  FROM  Parameter
</cfquery>

<cfinclude template="ReceiptInfo.cfm">

<cfquery name="Make" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM Ref_Make
	  ORDER By Description
</cfquery>

<cfquery name="Parent" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT  *
     FROM  AssetParent
	 WHERE AssetNo IN (SELECT AssetNo 
	                   FROM AssetItem 
					   WHERE ReceiptId = '#URL.ID#')
     ORDER BY Description
</cfquery>

<cfif #Parent.recordcount# eq "1">
	<cfset amount = round((#Receipt.ReceiptAmountBase#/#Receipt.ReceiptQuantity#) * 100)>
	<cfset amount = #amount#/100>
<cfelse>
	<cfset amount = "">
</cfif>

<cfoutput query="Parent">

<cfquery name="Item" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT  TOP 1 *
     FROM  AssetItem
	 WHERE AssetNo   = '#AssetNo#'
	 AND   ReceiptId = '#URL.ID#'
</cfquery>


<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr>
    <td colspan="5" height="18" bgcolor="f4f4f4">&nbsp;<cf_tl id="Equipment"> <cf_tl id="registration"> : <b>#Description#</b></td>
</tr>

<tr><td height="4"></td></tr>
<tr><td>
   <table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
    <tr>
	<td width="15%" height="20">&nbsp;&nbsp;<cf_tl id="Unit value">:</td>
	<td colspan="4"><cfinput type="Text" class="amount" value="#Item.DepreciationBase#" name="DepreciationBase_#AssetNo#" message="Please enter a valid amount" validate="float" required="Yes" enabled="Yes" size="20" maxlength="20"></td>
    </tr>
    <tr><td height="2"></td></tr>
    <tr>
	<td height="20">&nbsp;&nbsp;<cf_tl id="Make">:</td>
	<td colspan="4">
	    
		<select name="Make_#AssetNo#" id="Make_#AssetNo#" required="No" style="font:10px">
			<cfloop query="Make">
			<option value="#Code#" <cfif #Item.Make# eq "#Code#">selected</cfif>>#Description#</option>
			</cfloop>
		</select>
	</td>
    </tr>
    <tr><td height="2"></td></tr>
    <tr>
	<td height="20">&nbsp;&nbsp;<cf_tl id="Model">:</td>
	<td colspan="4"><input type="text" name="Model_#AssetNo#" id="Model_#AssetNo#" value="#Item.Model#" size="40" maxlength="40" class="regular"></td>
    </tr>
    <tr><td height="2"></td></tr>
    <tr>
	<td height="20">&nbsp;&nbsp;<cf_tl id="Add. description">:</td>
	<td colspan="4"><input type="text" name="Description_#AssetNo#" id="Description_#AssetNo#" value="#Item.Description#" size="80" maxlength="200" class="regular"></td>
    </tr>
	
	<cfquery name="Topic" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  R.*
	     FROM  AssetParentTopic T, Ref_Topic R
		 WHERE AssetNo = '#AssetNo#'
		 AND  R.Code = T.Topic
	</cfquery>

	<cfif Topic.recordcount gt "0">

	<tr><td height="2"></td></tr>
	<cfloop query="topic">
	<tr>
		<td>&nbsp;&nbsp;#Description#</td>
		<td colspan="4">
		
		<cfquery name="List" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  *
		     FROM  Ref_TopicList R
			 WHERE Code = '#Code#'
		</cfquery>
				
		<cfquery name="AssetTopic" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  TOP 1 *
		  FROM  AssetItemTopic
		  WHERE AssetId   = '#Item.AssetId#'
		  AND   Topic = '#Code#'
	    </cfquery>
				
		<select name="ListCode_#AssetNo#_#Code#" id="ListCode_#AssetNo#_#Code#" required="No" style="font:10px">
			<cfloop query="List">
			<option value="#ListCode#" <cfif AssetTopic.ListCode eq "#Code#">selected</cfif>>#ListValue#</option>
			</cfloop>
		</select>
		</td>
	</tr>
	</cfloop>
	</cfif>
	
	
	<tr><td height="3"></td></tr>
	<tr><td colspan="5">
	
	<table width="99%" align="center">
	
	<tr>
	   <td bgcolor="E8E8CE"><cf_tl id="Item"></td>
	   <td bgcolor="E8E8CE"><cf_tl id="SerialNo"></td>
	   <td bgcolor="E8E8CE"><cf_tl id="Barcode"></td></tr>
	   
	   <tr><td height="1" colspan="3" class="linedotted"></td></tr>
	   
	   <tr><td height="2"></td></tr>
	   <cfset val = "">
	   	   
	<cfloop index="itm" from="1" to="#Receipt.ReceiptQuantity#">
	
	<cfquery name="Asset" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  TOP 1 *
    	 FROM  AssetItem
		 WHERE AssetNo   = '#AssetNo#'
		 AND   ReceiptId = '#URL.ID#'
		 <cfif #val# neq "">
		 AND   AssetId NOT IN (#val#)
		 </cfif>
	</cfquery>
	
	<cfif val eq "">
	  <cfset val = "'#Asset.AssetId#'"> 
	<cfelse>
	  <cfset val = "#val#,'#Asset.AssetId#'">
	</cfif>
		
	<tr>
		<td>&nbsp; #itm#</td>
		<cfif Parameter.VerifySerialNo eq "1">
		  <cfset s = "Yes">
		<cfelse>
		  <cfset s = "No">
		</cfif>
		<td><cfinput type="Text" name="SerialNo_#AssetNo#_#itm#" value="#Asset.SerialNo#" message="Please enter a serialNo" required="#s#" visible="Yes" enabled="Yes" size="20" maxlength="20" class="regular"></td>
		
		
		<cfif Parameter.VerifyBarcode eq "1">
		  <cfset s = "Yes">
		<cfelse>
		  <cfset s = "No">
		</cfif>
		<td><cfinput type="text" name="BarCode_#AssetNo#_#itm#" value="#Asset.AssetBarcode#" message="Please enter a barcode" required="#s#" size="20" maxlength="20" class="regular"></td>
	</tr>
	
	</cfloop>
	</table>
	</td></tr>
	</TABLE>
	</TD></TR>
		
<tr><td height="2"></td></tr>

</cfoutput>

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td align="right" bgcolor="f4f4f4">
<cf_tl id="Undo prior registration" var="1">
<input type="submit" name="Submit" id="Submit" class="button7" value="#lt_text#">

<cf_tl id="Register equipment" var="1">
<input type="submit" name="Submit" id="Submit" class="button7" value="#lt_text#">

</td></tr>

</table>

</cfform>

