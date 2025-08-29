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
<cfparam name="url.idmenu" default="">

<cfquery name="getClass" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT 	*
	FROM 	Ref_EntryClass
	WHERE	Code = '#url.id1#'
	
</cfquery>

<cf_screentop height="100%" 
			  label="Edit Entry Class #getClass.description#" 
			  scroll="Yes" 
			  layout="webapp" 
			  jquery="Yes"
			  banner="gray"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
			  
<cfajaximport tags="cfdiv,cfform">

<cf_menuscript>

<cfoutput>
	<script>
		
		function purgeEntryClass(id) {
			if (confirm("Do you want to remove this record ?")) {
				ptoken.navigate('RecordPurge.cfm?id1='+id+'&idmenu=#url.idmenu#&fmission=#url.fmission#','contentbox1');
			}
		}
	
	</script>
</cfoutput>


<cf_divscroll>

<table width="95%"
       border="0"
	   height="100%"
	   align="center"
	   cellspacing="0"
       cellpadding="0">
	<tr><td height="2" id="process"></td></tr>
	<tr>
		<td align="center" valign="top">
		
			<table width="100%" cellspacing="0" cellpadding="0" align="center">
				<tr>
				
				<cfset wd = "64">
				<cfset ht = "64">
				
				<cf_menutab item  = "1" 
			       iconsrc    = "Detail.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   class      = "highlight"
				   name       = "Details"
				   source     = "RecordEditForm.cfm?id1=#url.id1#&idmenu=#url.idmenu#&fmission=#url.fmission#">
				   
				<cf_menutab item  = "2" 
			       iconsrc    = "Vendors.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   targetitem = "1"
				   name       = "Vendor Roster"
				   source     = "Vendors/VendorEntry.cfm?entryclass=#url.id1#&vendor=&idmenu=#url.idmenu#&fmission=#url.fmission#">
				   
				   <td width="10%"></td>
				 </tr>
			 </table>
		
		<td>
	</tr>
	<tr><td class="linedotted"></td></tr>
	<tr><td height="3"></td></tr>
	<tr>
	<td height="100%" valign="top">
	   <table width="100%" height="100%" cellspacing="0" cellpadding="0">
		<cf_menucontainer item="1" class="regular">
		     <cf_getMId>
			 <cfdiv bind="url:RecordEditForm.cfm?mid=#mid#&id1=#url.id1#&idmenu=#url.idmenu#&fmission=#url.fmission#"> 
	 	</cf_menucontainer>	
	   </table>	
	</td>
	</tr>
	<tr><td height="1"></td></tr>
</table>
</cf_divscroll>