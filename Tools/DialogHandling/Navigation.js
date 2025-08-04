/*
 * Copyright © 2025 Promisan
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
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