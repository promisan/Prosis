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

<cf_tl id="Receipt and Inspection Management" var="1">

<cf_screenTop height="100%" title="#lt_text#  #URL.Mission#" border="0" 
   html="No" scroll="No" menuAccess="Yes" jquery="Yes" validateSession="Yes">

<cfajaximport tags="cfform">   
   
<cfoutput>

<script language="JavaScript">

function clearrows(field, fieldNum) {
	for (i = 1; i <= fieldNum; i++)	
	document.getElementById(field+i).style.fontWeight='normal'
 }

function refreshTree() {
	location.reload();
}

function reloadForm(per) { 
   _cf_loadingtexthtml='';	
	ptoken.navigate('ReceiptViewTree.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&period='+per,'treebox')
}

function newreceipt() {	
    ptoken.open('../ReceiptEntry/LocatePurchaseView.cfm?systemfunctionid=#url.systemfunctionid#&Mission=#URL.Mission#&Period='+document.getElementById("PeriodSelect").value,'right')
	// $('##right').attr('src','../ReceiptEntry/LocatePurchaseView.cfm?Mission=#URL.Mission#&Period='+document.getElementById("PeriodSelect").value);
}

function newSearch() {
    ptoken.open('ReceiptViewOpen.cfm?systemfunctionid=#url.systemfunctionid#&ID1=Locate&ID=STA&Mission=#URL.Mission#','right')
//	$('##right').attr('src','ReceiptViewOpen.cfm?ID1=Locate&ID=STA&Mission=#URL.Mission#');
}

function updatePeriod(per,mandate) {
	
	document.getElementById("PeriodSelect").value = per
	
	if (mandate != document.getElementById("MandateNo").value) {
	   window.receipt.MandateNo.value = mandate
	   reloadForm(per)
	} else {   
	   window.receipt.MandateNo.value = mandate
	   reloadForm(per)
	}
}

</script>

<cf_layoutScript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>
	 
<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
	      type      = "Border"
          position  = "header"
          name      = "controltop">	
		  
		 <cfinclude template="ReceiptMenu.cfm">
		 
	</cf_layoutarea>		 

	<cf_layoutarea 
          type        = "Border"
          position    = "left"
          name        = "treebox"
          size        = "250"
          collapsible = "true"
          splitter    = "true"
		  state       = "open"
          maxsize     = "400">
	
	    <cfinclude template="ReceiptViewTree.cfm">
			
	</cf_layoutarea>

	<cf_layoutarea type="Border" position="center" name="box" overflow="hidden" style="height:100%">
		
			<iframe src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
		        name="right"
	    	    id="right"
	        	width="100%"
		        height="100%"
	    	    align="middle"
	        	scrolling="no"
		        frameborder="0"></iframe>
							
	</cf_layoutarea>
		
</cf_layout>	

</cfoutput>

