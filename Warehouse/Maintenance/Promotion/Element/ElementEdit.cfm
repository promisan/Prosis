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
<cfset vAction = "Maintain Promotion Element">
<cfset vBanner = "Yellow">
<cfif url.serial eq "">
	<cfset vAction = "Add Promotion Element">
	<cfset vBanner = "Gray">
</cfif>

<cf_screentop height="100%" 
              scroll="Yes" 
			  html="No"
			  layout="webapp" 
			  label="#vAction#" 
			  banner="#vBanner#"
			  menuAccess="Yes" 
			  jquery="Yes"
			  close="parent.ColdFusion.Window.destroy('mypromo',true)"
			  systemfunctionid="#url.idmenu#">

<cfajaximport tags="cfform,cfdiv">

<cfoutput>
	<script>
		function saveCI(control, ci, promotionid, serial, cat, catitem) {
			var action = '';
			if (control.checked) {
				action = 'insert';
				document.getElementById('td1_'+ci).style.backgroundColor = 'FFFFCF';
			} else {
				action = 'delete';
				document.getElementById('td1_'+ci).style.backgroundColor = '';
			}
			
			_cf_loadingtexthtml='';	
			ptoken.navigate('ElementCategoryItem/ElementCategoryItemSingleSubmit.cfm?action='+action+'&promotionid='+promotionid+'&serial='+serial+'&category='+cat+'&categoryItem='+catitem,'processCategoryItemSelect');
		}
	</script>
</cfoutput>

<cf_tl id = "Please enter a valid numeric discount percentage between 0 and 100." var = "disReqError1">
<cf_tl id = "Please enter a valid numeric discount amount greater than 0." var = "disReqError2">

<cfoutput>

	<script language="JavaScript">
	
		function validateElementFields() {
				var vMessage = '';
				var vTest = '';
				var vFirstError = '';
				var isDirty = 0;
				
				//Discount
				vTest = document.getElementById('Discount').value;
				vTest = vTest.replace(/ /gi, "");
				if (document.getElementById('DiscountType').value == 'Percentage') {
					isDirty = 0;
					if (vTest == '') {
						isDirty = 1;
					} else {
						if (isNaN(vTest)) {
							isDirty = 1;
						}else{
							if (vTest < 0 || vTest > 100) {
								isDirty = 1;
							}
						}
					}
					if (isDirty == 1) {
						vMessage = vMessage + '#disReqError1#\n';
						if (vFirstError == '') vFirstError = 'Discount';
					}
				}
				
				if (document.getElementById('DiscountType').value == 'Cash') {
					isDirty = 0;
					if (vTest == '') {
						isDirty = 1;
					}
					else {
						if (isNaN(vTest)) {
							isDirty = 1;
						}
						else{
							if (vTest < 0) {
								isDirty = 1;
							}
						}
					}
					if (isDirty == 1) {
						vMessage = vMessage + '#disReqError2#\n';
						if (vFirstError == '') vFirstError = 'Discount';
					}
				}
	
				//Return error
				if (vMessage != '' && vFirstError != ''){
					alert(vMessage);
					document.getElementById(vFirstError).focus();
					return false;
				}
				
				//Success
				return true;
			}
	</script>
	
</cfoutput>  
			  		  
<table width="90%" align="center">
	
	<tr>
		<td><cf_securediv id="divElementEditHead" bind="url:ElementEditForm.cfm?idmenu=#url.idmenu#&promotionid=#url.promotionid#&serial=#url.serial#"></td>
	</tr>
	
	<tr>
		<td><cf_securediv id="divElementEditDetail" bind="url:ElementCategoryItem/ElementCategoryItem.cfm?idmenu=#url.idmenu#&promotionid=#url.promotionid#&serial=#url.serial#"></td>
	</tr>
	
</table>