
<!--- loads navigation script --->

<!---
<script language="JavaScript" src="AjaxNavigate.js" type="text/javascript"></script>
--->

<script language="JavaScript">

function clearsearch() { 
   document.getElementById("find").value = "" 
   }

function search() {

	 if (window.event.keyCode == "13")
		{	document.getElementById("refresh").click() }
			
    }
	
function navigate()	{
					
		rowid  = document.getElementById("row").value		
											 
		if (window.event.keyCode == "13") {			     
		   $("#r"+rowid).dblclick();		   
		}	
		 
		if (window.event.keyCode == "40") {	
		  		  
		   try { 		   
		   r = rowid-1+2			     
		   document.getElementById("r"+r).click()
		   } catch(e) {}
		   
		 }
		 				 
		if (window.event.keyCode == "38") {	
		   try
		   { 
		   r = rowid-1
		   se  = document.getElementById("r"+r).click()
		   }
		   catch(e) {}
		   
		 } 
		 
		 if (window.event.keyCode == "33") {	
		   try
		   { 
		   p = document.getElementById("page").value
		   r = p-1
		   if (r != 0){
		   document.getElementById("page").value = r
		   document.getElementById("refresh").click()}
		   }
		   catch(e) {}
		   
		 }
		 
		 if (window.event.keyCode == "34") {	
		   try
		   { 
		   p = document.getElementById("page").value
		   pgs = document.getElementById("pages").value
		   r = p-1+2
		   if (r <= pgs){
		   document.getElementById("page").value = r
		   document.getElementById("refresh").click()
		   }
		   }
		   catch(e) {}
		   
		 }
		
		}
			   
	function selectact(rowno,tpc) {
				   	
		   document.getElementById("row").value   = rowno	   
		   document.getElementById("topic").value = tpc
		 
		   count = 0
		   tot   = document.getElementById("total").value
				 				 	   
		   while (count <= tot) {
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

</script>