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

<cfoutput>

<cf_tl id="Purchase order Inquiry" var="1">

<cf_screenTop height="100%" title="#lt_text# #URL.Mission#" 
    jQuery="Yes" html="No" border="0" scroll="no" flush="Yes" MenuAccess="Yes" validateSession="Yes">

<script language="JavaScript">
	
	function reloadForm(role,per) {    
		ptoken.navigate('PurchaseViewTree.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&period='+per+'&role='+role,'treebox')
	}
	
	<!--- not used --->
	function ClearRow(field, fieldNum) {
	
		for (i = 1; i <= fieldNum; i++)	
		  document.getElementById(field+i).style.fontWeight='normal'	  
		  peri()
	}
	
	function peri(per,mandate,role) {
	    
		document.getElementById("PeriodSelect").value = per
	   	if (mandate != document.getElementById("MandateNo").value) {
		   document.getElementById("MandateNo").value = mandate
		   reloadForm(role,per)
		}
	
		else {   
		   document.getElementById("MandateNo").value = mandate
		   reloadForm(role,per)
		}	
	}

</script>
	 
<cf_LayoutScript>
	 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
	      type="Border"
          position="header"
          name="controltop">	
				
		 <cfinclude template="PurchaseMenu.cfm">
				 
	</cf_layoutarea>		

	<cf_layoutarea 
	    type="Border" position="left" name="treebox" maxsize="400" size="260" overflow="hidden" style="height:100%" collapsible="true" splitter="true">
		
	       <cfinclude template="PurchaseViewTree.cfm">			
										
	</cf_layoutarea>

	<cf_layoutarea type="Border" position="center" name="box" style="height:100%" overflow="hidden">		

		   <iframe src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm" name="right" id="right" width="100%" height="100%" scrolling="0" frameborder="0"></iframe>
			
			<!--- <cf_loadpanel id="right" template="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"> --->
						
	</cf_layoutarea>			
		
</cf_layout>		

</cfoutput>


