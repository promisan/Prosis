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
<cfoutput>
	
	<script language="JavaScript">
	
	function show(act) {
	
	 se = document.getElementsByName('detailfunction')
	 v = 0
	 while (se[v]) {
		   se[v].className = act  
		   v++
		 }
	 }  
		 
     function closeme(val) {  
	      document.getElementById("drilltemplate").value = val
    	  ProsisUI.closeWindow('mydrill',true)		
    }
	 
	function toggle(fld,val) {	
	  if (val == "") {
	  	document.getElementById(fld).disabled = true
	  } else {
	    document.getElementById(fld).disabled = false
	  }	  
	}
	
	function fieldedit(fid,sid,ser) {		  		
		ProsisUI.createWindow('myfield', 'Field', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    				
		ptoken.navigate('#SESSION.root#/system/modules/InquiryBuilder/FieldView.cfm?systemfunctionid='+sid+'&functionserialno='+ser+'&fieldid='+fid,'myfield') 					  
	}
	
	function fieldrefresh(sid,ser) {	
	    _cf_loadingtexthtml='';
	    ptoken.navigate('#SESSION.root#/System/Modules/InquiryBuilder/InquiryEditFields.cfm?systemfunctionid='+sid+'&functionserialno='+ser,'fields')	     				
	}
	 
	function selectdrilltemplate() {			   	
		ProsisUI.createWindow('mydrill', 'Drill', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    				
		ptoken.navigate('#SESSION.root#/system/modules/inquirybuilder/DrillTemplate.cfm','mydrill') 	   
	} 
	 
	function preview(id) {	
		ptoken.open("#SESSION.root#/tools/listing/listing/Inquiry.cfm?idmenu="+id+"&height=500", "preview", "width=#client.width-100#,height=800,status=yes,resizable=yes");		
	} 
	
	function copy(id) {		
	    ProsisUI.createWindow('copy', 'Copy Listing', '',{x:100,y:100,height:460,width:500,modal:true,resizable:false,center:true})
		ptoken.navigate('#SESSION.root#/system/modules/inquirybuilder/CopyInquiry.cfm?id='+id,'copy');						
	}
		
	function editpreparation(id,ser) {		    		
		ProsisUI.createWindow('myscript', 'Query', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,resizable:false,center:true})    						
		ptoken.navigate('#SESSION.root#/system/modules/inquirybuilder/PreparationEdit.cfm?systemfunctionid='+id+'&functionserialno='+ser,'myscript') 
	}	
		
	function embedding(val) {	
	
	     se = document.getElementsByName("template")
		 i=0
		 if (val == "None" || val == "Default" || val == "Workflow") {
		    while (se[i]) {  se[i].className = "hide";i++  }
		 } else {
		   while (se[i]) {  se[i].className = "regular";i++ }		  
		 }
	 }	
		 	
	</script>
	
</cfoutput>