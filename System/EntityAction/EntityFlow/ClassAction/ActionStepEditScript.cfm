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

<script language="JavaScript">

function showscript(id) {
   	ptoken.open("ActionStepEditViewScript.cfm?id="+id+"&ts="+new Date().getTime(), "showscript", "unadorned:yes; edge:raised; status:no; dialogHeight:800px; dialogWidth:1000px; status:yes;help:no; scroll:no; center:yes; resizable:yes");						
}

function toggle(sc,val) {
   document.getElementById('list').className = "hide"   
   if (val == "") {
      document.getElementById(sc).className = "hide"
	} else {
	  document.getElementById(sc).className = "regular"
    }
}

function toggleall(el,val) {
   se = document.getElementsByName(el)
   cnt = 0         
   while (se[cnt]) {      
       if (val == "") {
	     se[cnt].className = "hide"
	   } else {
	     se[cnt].className = "regular"
	   }
	   cnt++
   }
}

function template(file) {  
 	ptoken.open("../EntityAction/TemplateDialog.cfm?path="+file, "Template", "left=40, top=40, width=860, height= 732, toolbar=no, status=yes, scrollbars=yes, resizable=yes");
}

function showaction(step,insert) {     
   	   ptoken.navigate('ActionStepEditAction.cfm?ajax=yes&entityCode=#URL.EntityCode#&entityClass=#URL.EntityClass#&ActionCode=#url.actionCode#&Publishno=#url.publishno#','stepdata')	
}
	   
function showflow() {
   	   ColdFusion.navigate('ActionStepFlow.cfm?entityCode=#URL.EntityCode#&entityClass=#URL.EntityClass#&ActionCode=#url.actionCode#&Publishno=#url.publishno#','stepdata')	
}	
	   
function showinstruction() {
    ptoken.navigate('ActionStepMemo.cfm?PublishNo=#URL.PublishNo#&EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode=#URL.ActionCode#','stepdata')	
}	

function saveform(mde) {	
	if (mde == "3") {
	ptoken.navigate('ActionStepEditActionSubmit.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode=#url.actionCode#&PublishNo=#URL.PublishNo#&save='+mde,'verifytab','','','POST','actionform')	
	ColdFusion.Layout.showTab('MethodList','verifytab')
	ColdFusion.Layout.selectTab('MethodList','verifytab')
	} else {
    ptoken.navigate('ActionStepEditActionSubmit.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode=#url.actionCode#&PublishNo=#URL.PublishNo#&save='+mde,'stepdata','','','POST','actionform')
	}	 	
} 

function savequick(mde) {	 
     ptoken.navigate('ActionStepEditActionSubmit.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode=#url.actionCode#&PublishNo=#URL.PublishNo#&save=1','#URL.EntityClass#_#URL.actionCode#_result','','','POST','actionform')		 
}


function saveflow() {
		
    ptoken.navigate('ActionStepFlowSubmit.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode=#url.actionCode#&PublishNo=#URL.PublishNo#&save=1','process','','','POST','flowform')					
    
	se = document.getElementById("ActionGoTo")	
	if (se.value != '0') {		
	    document.getElementById("goto").className = "regular"								
	} else {
		document.getElementById("goto").className = "hide"						
	}
	
}	   

function saveflowcondition(box,act,mde) {	      
   ptoken.navigate('ActionStepFlowSubmit.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode=#url.actionCode#&PublishNo=#URL.PublishNo#&save='+mde+'&stepto='+act,'conditionresult'+act,'','','POST','form'+box);							    
}	   

function gotoselect(box,itm,fld,act){
	
     if (ie){
         while (itm.tagName!="TR")
         {itm=itm.parentElement;}
   	 }else{
         while (itm.tagName!="TR")
         {itm=itm.parentNode;}
     }
 		 	 		 	
	 if (fld != false){		
	 itm.className = "highLight2";
	 ptoken.navigate('ActionStepFlowSubmit.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode=#url.actionCode#&PublishNo=#URL.PublishNo#&save=2&stepto='+act+'&insert='+fld,'box'+box)					
	 }else{		
     itm.className = "regular";					
	 ptoken.navigate('ActionStepFlowSubmit.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode=#url.actionCode#&PublishNo=#URL.PublishNo#&save=2&stepto='+act+'&insert='+fld,'box'+box)						
	 }			 
 }
 
function html(val) {
		
	if (val != "0") {				
	  document.getElementById("enableHTMLEdit").disabled = false
	} else {
	  document.getElementById("enableHTMLEdit").checked  = false				
	  document.getElementById("enableHTMLEdit").disabled = true
	}  
}
			
 
function removeaction() {	
	if (confirm("Do you want to remove this record ?")) {	 
	ptoken.navigate('ActionStepEditActionSubmit.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode=#url.actionCode#&PublishNo=#URL.PublishNo#&save=9','stepdata','','','POST','actionform')	 
	}
}		

function gotocondition(box,step) {
     ptoken.navigate('ActionStepFlowCondition.cfm?entityCode=#URL.EntityCode#&entityClass=#URL.EntityClass#&ActionCode=#url.actionCode#&Publishno=#url.publishno#&stepto='+step,box)	
}
	   
function showparam(dlg) {
	 ptoken.navigate('ActionStepEditActionParam.cfm?entityCode=#URL.EntityCode#&dialog='+dlg+'&dialogparameter=#get.actionDialogParameter#','parameter')		
}	   
	   
function tcl(c) {
   var colorpicker = $("##ActionCompletedColor").data("kendoColorPicker");
   if (c == true) {
		colorpicker.enable(false);
   } else {
		colorpicker.enable(true);
		colorpicker.open();
   }	
}     				   
							
function standard(st) {
															
	showparam(st)
													
	se = document.getElementById("disablestandarddialog");
	if (st == "") { 
	       se.disabled = true }
	else { se.checked = false;
		   se.disabled = false
		 }					
						
	se = document.getElementById("enablequickprocess");
	if (st == "") { se.disabled = false 
	} else { se.checked = false;
		     se.disabled = true
		   }
	}	
	
function mail(code,box) { 
   ptoken.navigate('ActionStepEditActionRecipient.cfm?box='+box+'&entityCode=#url.entityCode#&entityclass=#url.entityclass#&documentcode='+code+'&actioncode=#url.actioncode#',box) 
}		
	
function quick(chk) {
	se = document.getElementById("notificationmanual")
	if (chk == true) {
	     se.checked = false
		 se.disabled = true
    } else {
	  se.disabled = false}
    }	
	
function show(box,chk)	{
	se = document.getElementById(box);
	if (chk == true) {
	   se.className = "regular"
	} else {
	  se.className = "hide"}
	}			 								
	   
ie = document.all?1:0
ns4 = document.layers?1:0

function notify(st) {
	se = document.getElementById("PersonMailCode")
	if (st == true) { 
	  se.className = "regularxl" }
	else { se.className = "hide" }
	}
	
function notify2(st) {
	m1 = document.getElementById("actionmail1")
	m2 = document.getElementById("actionmail2")
	m3 = document.getElementById("actionmail3")
	if (st == true) { 
	 m1.className = "regular" 
	 m2.className = "regular" 	
	 m3.className = "regular" 	
	} else { 
	 m1.className = "hide";
	 m2.className = "hide" 
	 m3.className = "hide" 	
	 }
	}	

function decision(st) {
    se = document.getElementById("yesno")
	if (st == 0) {se.className = "hide" }
	else { se.className = "regular"	}	
    }	

function stepedit(action) {
	if (action != "") {
	     ptoken.open("ActionStepEdit.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode="+action+"&PublishNo=#URL.PublishNo#", "EditAction", "left=10, top=10, width=930, height=900, toolbar=no, status=yes, scrollbars=no, resizable=yes");
     }
   }

</script>

</cfoutput>