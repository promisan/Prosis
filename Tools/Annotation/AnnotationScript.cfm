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

<cf_menuscript>

<script language="JavaScript">
	
	function editannotation(ent,key1,key2,key3,key4,box) {
		ProsisUI.createWindow('annotationwindow', 'Annotation','',{x:100,y:100,height:600,width:750,modal:true,center:true,resizable:false})    
        ptoken.navigate('#SESSION.root#/Tools/Annotation/AnnotationDialog.cfm?entity='+ent+'&key1='+key1+'&key2='+key2+'&key3='+key3+'&key4='+key4+'&box='+box, 'annotationwindow');	
	}
	
	
	function annotationtoggle(chk,box) {
 
	  se = document.getElementById(box)
	  if (chk == true) {
    	 se.className = "regular"
	  } else {
    	 se.className = "hide"
	  } 

	}
	
	function maximize(itm) {
		
	 	 se   = document.getElementsByName(itm)
		 icM  = document.getElementById(itm+"Min")
		 icE  = document.getElementById(itm+"Exp")
		 count = 0
			 
		 if (se[0].className == "regular") {
			   while (se[count]) { 
			      se[count].className = "hide"; 
	  		      count++
			   }		   
		 	   icM.className = "hide";
			   icE.className = "regular";
			 } else {
			    while (se[count]) {
			    se[count].className = "regular line"; 
			    count++
			 }	
			 icM.className = "regular";
			 icE.className = "hide";			
		   }
	}  		

</script>

</cfoutput>