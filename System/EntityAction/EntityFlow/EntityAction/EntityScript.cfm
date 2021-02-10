<!--- detail dialog script --->

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