
<cfoutput>

<cf_menuscript>

<script language="JavaScript">
	
	function editannotation(ent,key1,key2,key3,key4,box) {
		ProsisUI.createWindow('annotationwindow', 'Annotation','',{x:100,y:100,height:600,width:750,modal:true,center:true})    
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
			    se[count].className = "regular"; 
			    count++
			 }	
			 icM.className = "regular";
			 icE.className = "hide";			
		   }
	}  		

</script>

</cfoutput>