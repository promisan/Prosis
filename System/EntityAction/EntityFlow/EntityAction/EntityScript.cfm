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

<script>
 
function entityedit(id,mis) {
	ProsisUI.createWindow('entityedit', 'Maintain Object Settings', '',{x:100,y:100,height:660,width:890,resizable:false,modal:true,center:true})	
	ptoken.navigate('#SESSION.root#/system/entityAction/EntityFlow/EntityAction/EntityEdit.cfm?mission='+mis+'&ID=' + id,'entityedit')	
}
  
function toggledet(val) {
	if (val == false) {
	document.getElementById("TemplateCreate").disabled = true
	document.getElementById("TemplateSearch").disabled = true
	document.getElementById("TemplateListing").disabled = true
	}else{
	document.getElementById("TemplateCreate").disabled = false
	document.getElementById("TemplateSearch").disabled = false
	document.getElementById("TemplateListing").disabled = false
	}
}  
  
function validate() {
    
   	document.entityform.onsubmit() 	
	if( _CF_error_messages.length == 0 ) {
	    _cf_loadingtexthtml='';	
       	ptoken.navigate('#SESSION.root#/system/entityAction/EntityFlow/EntityAction/EntitySubmit.cfm','result','','','POST','entityform')
	 }   
	 	 
}	

ie = document.all?1:0
ns4 = document.layers?1:0

function savedet(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
		 	 		 	
	 if (fld != false){		
	 itm.className = "highLight4";
	 validate()
	 
	 }else{
		
     itm.className = "regular";		
	 validate()
	 
	 }
  }
  
</script>  

</cfoutput>