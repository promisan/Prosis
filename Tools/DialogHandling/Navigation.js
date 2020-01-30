function navigateRow()	{
		
	vrowid  = document.getElementById("rowid").value		
	vrowno  = document.getElementById("rowno").value
	
	if (window.event.keyCode == "13") {	
	   showRow(vrowno,vrowid)
	}
	 
	if (window.event.keyCode == "40") {	
	   try {	   
	   r = vrowno-1+2
	   document.getElementById("r"+r).click()
	   } catch(e) {}				   
	 }
	 				 
	if (window.event.keyCode == "38") {	
	   try { 
	   r = vrowno-1
	   se  = document.getElementById("r"+r).click()
	   } catch(e) {}				   
	 } 				 			
	} 
	
function showRow(rowno,rowid) {
			
	   document.getElementById("rowno").value = rowno	   	   
	   document.getElementById("rowid").value = rowid	  		  		
	   count = 1
	   
	   try {  showdetail(rowid) } catch(e) {}
   			  						 	   
	   while (document.getElementById("r"+count)) {
		   try { 
			   rw = document.getElementById("r"+count)
			   rw.className = "regular"
		   	   } catch(e) {}
			   count++ 
		   }
		   
		   try {
		  
		   rw = document.getElementById("r"+rowno)
		   rw.className = "highlight2"		  	   	   
		   } catch(e) {}
	   }