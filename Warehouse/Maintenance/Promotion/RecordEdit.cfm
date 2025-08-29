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

<cfset vAction = "Maintain">
<cfset vBanner = "Yellow">
<cfif url.id1 eq "">
	<cfset vAction = "Add">
	<cfset vBanner = "Gray">
</cfif>

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="#vAction# Promotions or Hot topics" 
			  banner="#vBanner#"
			  menuAccess="Yes" 
			  jquery="Yes"			  
			  systemfunctionid="#url.idmenu#">

<cfajaximport tags="cfform,cfdiv">
<cf_calendarScript>
<cf_filelibraryscript>

<cf_tl id = "The expiration date and time must be greater than the effective date and time." var = "vDateError">
<cf_tl id = "Please, enter a valid effective date." var = "effReqError">

<cfoutput>
	<script>
		function validateFields() {
			var vDay = '';
			var vMonth = '';
			var vYear = '';
			var vMessage = '';
			var vTest = '';
			var vFirstError = '';
			
			//Effective date
			vTest = document.getElementById('DateEffective').value;
			if ('#APPLICATION.DateFormat#' == 'EU') {
				vDay = vTest.substring(0,2);
				vMonth = vTest.substring(3,5);
				vYear = vTest.substring(6,10);
			}
			else {
				vMonth = vTest.substring(0,2);
				vDay = vTest.substring(3,5);
				vYear = vTest.substring(6,10);
			}
			var vHour = document.getElementById('TimeEffective_Hour').value;
			var vMinute = document.getElementById('TimeEffective_Minute').value;
			
			var vInitDate = new Date(parseInt(vYear), parseInt(vMonth)-1, parseInt(vDay), parseInt(vHour), parseInt(vMinute), 0, 0);
			
			//Expiration date
			vTest = document.getElementById('DateExpiration').value;
			if ('#APPLICATION.DateFormat#' == 'EU') {
				vDay = vTest.substring(0,2);
				vMonth = vTest.substring(3,5);
				vYear = vTest.substring(6,10);
			}
			else {
				vMonth = vTest.substring(0,2);
				vDay = vTest.substring(3,5);
				vYear = vTest.substring(6,10);
			}
			var vHour = document.getElementById('TimeExpiration_Hour').value;
			var vMinute = document.getElementById('TimeExpiration_Minute').value;
			
			var vEndDate = new Date(parseInt(vYear), parseInt(vMonth)-1, parseInt(vDay), parseInt(vHour), parseInt(vMinute), 0, 0);
			
			//Validation expiration > effective
			if (vInitDate >= vEndDate) {
				vMessage = vMessage + '#vDateError#\n';
				if (vFirstError == '') vFirstError = 'DateExpiration';
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
		
		function elementEdit(promotionid,serial) {
		    
			try { ProsisUI.closeWindow('mypromo',true) } catch(e) {}
			ProsisUI.createWindow('mypromo', 'Promotion Element', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,resizable:false,center:true})    							
			ptoken.navigate('#session.root#/Warehouse/Maintenance/Promotion/Element/ElementView.cfm?idmenu=#url.idmenu#&promotionid=' + promotionid + '&serial=' + serial,'mypromo') 		
		}
		
		function elementrefresh(promotionid) {
		    ptoken.navigate('Element/ElementListing.cfm?idmenu=#url.idmenu#&id1=' + promotionid, 'divElementListing');
		}
		
		function elementPurge(promotionid,serial) {
			if (confirm('Do you want to remove this element and all of its details ?')) {
				ptoken.navigate('Element/ElementPurge.cfm?idmenu=#url.idmenu#&promotionid=' + promotionid + '&serial=' + serial, 'divElementListing');
			}
		}

	</script>
</cfoutput>

<table width="98%" align="center">
	<tr>
		<td>
			<cf_securediv id="divHeader" bind="url:RecordEditDetail.cfm?idmenu=#url.idmenu#&id1=#url.id1#&fmission=#url.fmission#">
		</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td>
			<cf_securediv id="divDetail" bind="url:Element/Element.cfm?idmenu=#url.idmenu#&id1=#url.id1#&fmission=#url.fmission#">
		</td>
	</tr>
</table>
	
