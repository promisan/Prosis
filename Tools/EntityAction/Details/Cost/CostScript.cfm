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

<cfoutput>
			  
	<cfinclude template="../../../Document/FileLibraryScript.cfm">	  
							  	
	<script language="JavaScript">
	
	   function details(objectid,itm) {
	       window.location = "DetailsSelect.cfm?objectid="+objectid+"&item="+itm
	   }		  
					
	   function list(sel,val,se2,va2) {	    
			ColdFusion.navigate('#SESSION.root#/tools/entityaction/Details/Cost/CostList.cfm?mode=regular&objectid=#url.objectid#&sel='+sel+'&val='+val+'&se2='+se2+'&va2='+va2,'costcontainer') 			
	   }	
		
	   function showsummary() {		
		    ColdFusion.Layout.showArea('container', 'right')				
			ColdFusion.navigate('#SESSION.root#/tools/entityaction/Details/Cost/CostSummary.cfm?objectid=#url.objectid#','summary') 					
	   }
		
	   function postledger() {					
			ColdFusion.navigate('#SESSION.root#/tools/entityaction/Details/Cost/CostLedger.cfm?objectid=#url.objectid#','costcontainer','','','POST','formcost') 											
	   }
				
	   function printme() {
	   
	    thr =  document.getElementById("threadid").value
		ser =  document.getElementById("serialno").value
		if (ser == "") {
		  alert("There is nothing to print.")
		} else {
		window.open("Cost/CostPrint.cfm?objectid=#url.objectid#&threadid="+thr+"&serialno="+ser,"_blank", "width=800, height=800, status=no, toolbar=no, scrollbars=no, resizable=yes")	 
		}
	   
	   }	
					
	   function navigate()	{
				
		  id     = document.getElementById("id").value
		  rowno  = document.getElementById("rows").value
	 
		  if (window.event.keyCode == "13") {	
			   show(rowno,id)
		  }
				 
		  if (window.event.keyCode == "40") {	
			   try { 
			   r = rowno-1+2
			   document.getElementById("r"+r).click()
			   } catch(e) {}				   
		  }
				 				 
		  if (window.event.keyCode == "38") {	
				   try { 
				   r = rowno-1
				   se  = document.getElementById("r"+r).click()
				   } catch(e) {}				   
				 } 				 			
		   }				   
		
		 function show(row,id) {
					
				document.getElementById("rows").value = row	   
				document.getElementById("id").value = id
				tot = document.getElementById("total").value
						     
				count = 0
				   
	 	   		ColdFusion.navigate('#SESSION.root#/tools/entityaction/Details/Cost/CostBody.cfm?objectid=#url.objectid#&id='+id,'notebody') 			
					  						 	   
				while (count <= tot) {
					   try { 
						   rw = document.getElementById("r"+count)
						   rw.className = "regular"
					   	   } catch(e) {}
						   count++ 
					   }
					   rw = document.getElementById("r"+row)
					   rw.className = "highlight2"
					  	   	   
				   }
				   
			
				
				<!-- Original:  Cyanide_7 (leo7278@hotmail.com) -->
				<!-- Web Site:  http://members.xoom.com/cyanide_7 -->
				
				<!-- This script and many more are available free online at -->
				<!-- The JavaScript Source!! http://javascript.internet.com -->
				
				<!-- Begin
				var isNN = (navigator.appName.indexOf("Netscape")!=-1);
				
		function autoTab(input,len, e) {
					var keyCode = (isNN) ? e.which : e.keyCode; 
					var filter = (isNN) ? [0,8,9] : [0,8,9,16,17,18,37,38,39,40,46];
					if(input.value.length >= len && !containsElement(filter,keyCode)) {
					input.value = input.value.slice(0, len);
					input.form[(getIndex(input)+1) % input.form.length].focus();
					}
					function containsElement(arr, ele) {
					var found = false, index = 0;
					while(!found && index < arr.length)
					if(arr[index] == ele)
					found = true;
					else
					index++;
					return found;
					}
					function getIndex(input) {
					var index = -1, i = 0, found = false;
					while (i < input.form.length && index == -1)
					if (input.form[i] == input)index = i;
					else i++;
					return index;
					}
					return true;
				}
				//  End -->	
	   
					
		</script>	 
		  
</cfoutput>		  