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
<cf_tl id="Workflow Manager" var="1">


<cf_screenTop height="100%"
		html="No"
		band="No"
		title="#SESSION.welcome# #lt_text#"
		banner="red"
		treeTemplate="yes"
		bannerforce="Yes"
		bannerheight="55"
		border="0"
		jquery="Yes"
		scroll="no"
		menuaccess="Yes"
		validateSession="Yes">

<cf_layoutscript>
<cf_presentationScript>

<script language="JavaScript">

function refreshTree() {
	  ColdFusion.navigate('WorkflowTree.cfm','wftree')
}
	
function stepedit(ent,cls,id,pub) {
	if (id != "") {
	     window.open("ClassAction/ActionStepEdit.cfm?EntityCode="+ent+"&EntityClass="+cls+"&ActionCode="+id+"&PublishNo="+pub, "EditAction", "left=10, top=10, width=960, height=870, toolbar=no, status=yes, scrollbars=yes, resizable=no");				  
		}
}	

function toggleParam(code,val,entCode,entClass,actCode,pubNo,isTextBox) {

	ColdFusion.Ajax.submitForm('formInspector', 'WorkflowInspectToggleField.cfm?Toggle='+code+'&ToggleValue='+val+'&EntityCode='+entCode+'&EntityClass='+entClass+'&ActionCode='+actCode+'&PublishNo='+pubNo+'&isTextBox='+isTextBox)
	
	if (isTextBox == "No") {
	 
	 se = document.getElementById(code+"Green")
	 s1 = document.getElementById(code+"Red")
	 
	 if (se.className == "regular") {
	 	se.className = "hide"
		s1.className = "regular"
	 } else {
	    se.className = "regular"
		s1.className = "hide"
	 } 
		 
	} else
	 	alert ('Changes done!');		 
		 
}
	 
	 
</script>	

<cfajaximport tags="cfform">
	 
<cfset attrib = {type="Border",name="wfcontainer",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
          position="header"
          name="controltop">	
		  
		 <cfinclude template="WorkflowMenu.cfm">
		  
	</cf_layoutarea>		  
		
	<cf_layoutarea 
          position="left"
          name="wftree"
          source="WorkflowTree.cfm"         
		  size="287"
          maxsize="287"		
		  overflow="auto"  
          collapsible="true"
          splitter="true"/>
	
	<cf_layoutarea  
	    position="center" 
		overflow="hidden"		
		name="wfbody" 
		style="height:100%">
		
			<iframe src="WorkflowInit.cfm"
	        name="right"
	        id="right"
	        width="100%"
	        height="100%"	        
	        frameborder="0"></iframe>			
			
	</cf_layoutarea>		
	
	<cfset Client.LayoutHide     = "false">
	<cfset Client.LayoutCollapse = "false">
	
	<cf_layoutarea 
          position="right"
          name="inspect"
          source="WorkflowInspect.cfm"          
		  size="230"
          minsize="230"
          collapsible="true"
          initcollapsed="true"         
          splitter="false"
          maxsize="230"/>	
		  
	<cfset Client.InspectHide = "false">
		  
</cf_layout>
