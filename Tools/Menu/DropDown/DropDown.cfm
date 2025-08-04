<!--
    Copyright © 2025 Promisan

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
<cfajaximport>

<style>
	table.highLight {
		BACKGROUND-COLOR: #C9D3DE;
	}
	table.regular {
		BACKGROUND-COLOR: #ffffff;	
	}	
</style>

<cfoutput>
 
	<script language="JavaScript">
	
	ie = document.all?1:0
		
	function hl(itm,fld,name){
				 
	     if (ie){
	          while (itm.tagName!="TABLE")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TABLE")
	          {itm=itm.parentNode;}
	     }
		 	 	 		 	
		 if (fld != false){			
			 itm.className = "highLight"; 
			 itm.style.cursor = "pointer"; 
			 self.status = name;			 
		 }else{			
		     itm.className = "header";
			 itm.style.cursor = ""; 
			 self.status = name;
		 }
	  }
	  
	function cmexpand(name,nos,template) {
						
		cmclear(name)
					
		if (template == "") {
				
		  if (nos != "0") { 
		  
		  	  itm =  document.getElementById(name+nos)
		      itm.className = "regular";   		    
			  if (ie){
			      itm=itm.parentElement;
		          while (itm.tagName!="TD") {  itm=itm.parentElement; }
		      }else{
			      itm=itm.parentNode;
			      while (itm.tagName!="TD") {  itm=itm.parentNode;}
		      }
			  itm.className = "regular"
		  }
		
		 } else {
		 
		 _cf_loadingtexthtml='';			 		 	 
		  ptoken.navigate(template,name+nos) 	  
		 
		  if (nos != "0") { 
		  		      
		  	  itm =  document.getElementById(name+nos)	
		      itm.className = "regular";  
			 			  			  			   		    
			  if (ie){
			      itm=itm.parentElement;
		          while (itm.tagName!= "TD") {  itm=itm.parentElement; }
		      }else{
			      itm=itm.parentNode;
			      while (itm.tagName!= "TD") {  itm=itm.parentNode;}
		      }
			  itm.className = "regular"
		  }	
		}		
	}
		
	function cmclear(name) {	    
		se = document.getElementsByName(name)				
		cnt = 0				
		while (se[cnt])  {			   		  		   
			se[cnt].className = "hide";  	
		    cnt++;
		}		
	}
		
	function cmclose(id) {
	    document.getElementById(id).className = "hide"; 		
	}		
 
</script>

</cfoutput>

<cfset CLIENT.DropDownNo = 1>