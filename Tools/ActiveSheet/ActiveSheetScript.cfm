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

 function cellzoom(box,mod) {
    
    se = document.getElementById("cell_"+box)	
	id = document.getElementById("id_"+box).value
				
	if (se.className != "standard") {
	
		if (se.className == "cellstandard") {	 	
		  se.className = "cellzoom"
		  se.style.width = 200	
		  cont = document.getElementById("container_"+box)			  		 
		  cont.style.zIndex = 100			  	 		  
		  ColdFusion.navigate('#SESSION.root#/tools/activesheet/ActiveSheetCellContent.cfm?module='+mod+'&mode=expanded&elementid='+id,'content_'+id)
		  document.getElementById('header_'+box).src='#SESSION.root#/images/collapse5.gif'
		 		  
		} else {
		  se.className = "cellstandard"		
		  se.style.width = 10		
		  cont = document.getElementById("container_"+box)				   
		  cont.style.zIndex = 1		
		  ColdFusion.navigate('#SESSION.root#/tools/activesheet/ActiveSheetCellContent.cfm?module='+mod+'&mode=collapsed&elementid='+id,'content_'+id) 
		  document.getElementById('header_'+box).src='#SESSION.root#/images/expand5.gif'
		}
	}
	
 }
 
 function highlight(box,module,id){
	
	se = document.getElementById("cell_"+box)	
	id = document.getElementById("id_"+box).value
	se.className = "highlighted" 	
	 
 }
  

</script>

</cfoutput>