
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