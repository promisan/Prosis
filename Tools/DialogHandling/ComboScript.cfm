
<!--- scriptfile 

field_#box# : the target field that gets the value which is selected/highlighted

combobox

select_#box# : container for search div
selectcontent_#box# : data container for search div
selectedrow_#box# : the currently selected rowno
line_#box#_#rowno# : the lines of the search content
linevalue_#box#_#rowno# : the key value of a line which is passed 

--->

<script language="JavaScript">

<!--- key based search --->

function selectcombo(box,temget,temset,condition,val,mode) {  
   
   if  (val.length < 3) {
      
	   	document.getElementById('select_'+box).className = "hide"
		   
   } else {   
      	   	 
       document.getElementById('select_'+box).className = "regular"
   
	   if(window.event) {   
		  keynum = window.event.keyCode;	  
	   } else {   
		  keynum = window.event.which;	  
	   }		    	
	   
	   		  
	   if (mode == "down") {
	   		   
	       switch(keynum) {
		   
		   // user presses tab 
		   
		   case 9:    
		    // user presses enter to select 
	     	document.getElementById('select_'+box).className = "hide"																			
			ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/'+temset+'?box='+box+'&'+condition+'&keyvalue='+document.getElementById('field_'+box).value,'selectcontent_'+box)	
			
			if(window.event) {   
			  event.keyCode=9   
		     } else {  
		      event.which=9   			 	  
		     }		
											
			 break;
			
		   
		   // user presses enter 
		   
		   case 13:    
		    // user presses enter to select 
	     	document.getElementById('select_'+box).className = "hide"																			
			ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/'+temset+'?box='+box+'&'+condition+'&keyvalue='+document.getElementById('field_'+box).value,'selectcontent_'+box)	
			
			if(window.event) {   
			  event.keyCode=9   
		     } else {  
		      event.which=9   			 	  
		     }		
											
			 break;
			 
			} 
	   
	   } else {	   
	       
	       <!--- navigation keys --->
		     		   		   	 
		   switch(keynum) {	   
				
		   case 13:    		   
			   document.getElementById('select_'+box).className = "hide"
			   break;
			
		   case 38:	  
		   
		     <!--- up ---> 	   
			 
		     line = document.getElementById('selectedrow_'+box).value
			 line--
			 
			 if (document.getElementById('linevalue_'+box+'_'+line)) {
			     // set new value for row
				 document.getElementById('selectedrow_'+box).value = line		
				 // get info from the row 				 
				 document.getElementById('field_'+box).value  = document.getElementById('linevalue_'+box+'_'+line).value	
				 clearlines('line_'+box+'_',line) 	
			     }	 	 
			 break;
			 
		   case 40:
		   
		   	 <!--- down --->
		   		     
		     line = document.getElementById('selectedrow_'+box).value
			 line++		
			
			 if (document.getElementById('linevalue_'+box+'_'+line)) {
			     // set new value for row
				 document.getElementById('selectedrow_'+box).value = line				 
				 // get info from the row 				
				 document.getElementById('field_'+box).value  = document.getElementById('linevalue_'+box+'_'+line).value		
				 clearlines('line_'+box+'_',line) 		
			     }	 	 
			 break;
			 
		   default:  	
		   
		      // search more     
			 		 
			  ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/'+temget+'?box='+box+'&'+condition+'&search='+val,'selectcontent_'+box)
			 
		   }	
	    }	 
    }    
}


function clearlines(name,no) {
   
   cnt = 1
   
   while (document.getElementById(name+cnt)) {
      document.getElementById(name+cnt).className = "regular"	 
	  cnt++
   }   
   document.getElementById(name+no).className = "highlight3"   

}

</script>

