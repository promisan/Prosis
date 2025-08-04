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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM       OrganizationObject
WHERE      ObjectId = '#URL.Objectid#'
</cfquery>

<cfquery name="Get" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   C.*, RE.ActionDescription, U.FirstName, U.LastName,RD.DocumentItemName
FROM     OrganizationObjectActionCost C INNER JOIN
         Ref_EntityAction RE ON C.ActionCode = RE.ActionCode INNER JOIN
         Ref_EntityDocumentItem RD ON C.DocumentId = RD.DocumentId and
		 RD.DocumentItem = C.DocumentItem INNER JOIN 
		 System.dbo.UserNames U ON U.Account=C.OwnerAccount
WHERE    ObjectCostId = '#URL.Id#'
AND      RD.operational=1 and RE.operational='1' 
</cfquery>

<cfoutput>

<table width="99%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td height="4"></td></tr>
<tr><td>

<table width="100%" align="center" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" class="formpadding">

<tr>
<td width="2%">1.</td>
<td width="140"><cf_tl id="Stage">:</td>
<td width="30%">#Get.ActionDescription#</td>
<td width="2%">7.</td>
<td width="140">Incurred by:</td>
<td width="30%">#Get.FirstName# #Get.LastName#</td>
</tr>
<tr><td height="1" colspan="6" bgcolor="C0C0C0"></td></tr>
<tr>
<td >2.</td>
<td ><cf_tl id="Classification">:</td>
<td>#Get.DocumentItemName#</td>
<td >8.</td>
<td >Date:</td>
<td >#DateFormat(Get.DocumentDate, CLIENT.DateFormatShow)# #DateFormat(Get.DocumentDateEnd, CLIENT.DateFormatShow)#</td>
</tr>
<tr><td height="1" colspan="6" bgcolor="C0C0C0"></td></tr>
<tr>
<td >3.</td>
<td ><cf_tl id="Type">:</td>
<td>#Get.DocumentType#</td>
<td >9.</td>
<td >Reference:</td>
<td >#Get.DocumentNo#</td>
</tr>
<tr><td height="1" colspan="6" bgcolor="C0C0C0"></td></tr>

<tr>
<td >4.</td>
<td ><cf_tl id="Description">:</td>
<td>#Get.Description#</td>
<td >10.</td>
<td ><cf_tl id="Amount">:</td>
<td >
<cfif get.documentQuantity lt 0><font color="FF0000">(</cfif>
#Get.DocumentCurrency# #numberformat(Get.DocumentAmount,"__,__.__")#
<cfif get.documentQuantity lt 0><font color="FF0000">)</cfif>
</td>
</tr>
<tr><td height="1" colspan="6" bgcolor="C0C0C0"></td></tr>
<tr>
<td width="2%">5.</td>
<td width="20%"><cf_tl id="Memo">:</td>
<td colspan="4">#Get.DocumentMemo#</td>
</tr>

<cfif Get.DocumentType eq "work">
<tr><td height="1" colspan="6" bgcolor="C0C0C0"></td></tr>
<tr>
<td>6.</td>
<td ><cf_tl id="Duration">:</td>
<td>

<cfset a = abs(get.documentquantity)>
				
					<cfset h = int(a)>
					<cfset m = round((a - h)*60)>
					
					<cfif get.documentQuantity lt 0><font color="FF0000">(</cfif>
				
					#h#<cfif get.DocumentType eq "work">
					<cfif m neq "0">:#m#</cfif>h @ #numberFormat(get.documentrate,"__.__")#</cfif>
				
					<cfif get.documentQuantity lt 0><font color="FF0000">)</cfif>


</td>
<td >12.</td>
<td ><cf_tl id="Rate">:</td>
<td >#Get.DocumentRate#</td>
</tr>
</cfif>	
<tr><td height="1" colspan="6" bgcolor="C0C0C0"></td></tr>
<tr>
<td>13.</td>
<td><cf_tl id="Attachment">:</td>
<td colspan="4">

	<cf_filelibraryN
		DocumentPath="#Object.EntityCode#"
		SubDirectory="#get.ObjectCostId#" 
		Filter=""				
		Width="100%"
		attachDialog="Yes"
		inputsize = "340"
		box = "i#get.ObjectCostId#"
		Loadscript = "No"
		Insert="No"
		Remove="No">	

</td>
</tr>
<tr><td height="1" colspan="6" bgcolor="C0C0C0"></td></tr>

	
</table>
</cfoutput>
</td></tr>

</table>



