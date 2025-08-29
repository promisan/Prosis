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
			  
	<cf_FileLibraryScript>	  
							  	
	<script language="JavaScript">
		
		function doSearch()
		{

			_cf_loadingtexthtml = '';			
			filter = document.getElementById('filter').value;
			ColdFusion.navigate('#SESSION.root#/tools/entityaction/Details/Notes/NoteViewList.cfm?objectid=#url.objectid#&filter='+filter,'notecontainer')
			
		}
		
		function enable_enter()
		{
			$('##filter').keypress(function (event) {
			    var keycode = (event.keyCode ? event.keyCode : event.which);
			    if (keycode == '13') {
			        doSearch();
			    }
			});
			
			$('##filter').focus();
			
		}		
		
		
		
	    function details(objectid,itm) {
		      window.location = "DetailsSelect.cfm?objectid=#objectid#&item="+itm
	    }
		   
	   function showmyfile(rt,fil,name) {   
 		   window.open("#SESSION.rootDocument#/" + rt+ "/" + fil + "/" + name, "DialogWindow", "width=800, height=600, status=yes,toolbar=no, scrollbars=yes, resizable=yes");
	    }	   
				
	    function listshow(sel,val) {
			document.getElementById('selecteditem').value=val			
			ColdFusion.navigate('#SESSION.root#/tools/entityaction/Details/Notes/NoteViewList.cfm?objectid=#url.objectid#&sel='+sel+'&val='+val,'notecontainer') 			
		}	
		
		function listcontent() {			    			   
			ColdFusion.navigate('#SESSION.root#/tools/entityaction/Details/Notes/NoteList.cfm?objectid=#url.objectid#','notecontainerdetail') 			
		}	
		
		function contact() {
		    ColdFusion.Layout.expandArea('container', 'right')		
		}
				
	    function printme() {
	   
		    thr =  document.getElementById("threadid").value
			ser =  document.getElementById("serialno").value
			if (ser == "") {
			  alert("There is nothing to print.")
			} else {
			window.open("NotePrint.cfm?objectid=#url.objectid#&threadid="+thr+"&serialno="+ser,"_blank", "width=800, height=800, status=no, toolbar=no, scrollbars=no, resizable=yes")	 
			}
	   
	    }			   
		
		function navigate()	{
				
			thr    = document.getElementById("threadid").value
			ser    = document.getElementById("serialno").value
			rowno  = document.getElementById("rows").value
	 
			if (window.event.keyCode == "13") {	
				   show(rowno,thr,ser)
				}
				 
			if (window.event.keyCode == "40") {	
				   try { 
				   r = rowno-1+2
				   document.getElementById("r"+r).click()
				   }
				   catch(e) {}				   
				 }
				 				 
			if (window.event.keyCode == "38") {	
				   try { 
				   r = rowno-1
				   se  = document.getElementById("r"+r).click()
				   }
				   catch(e) {}				   
				 } 				 			
				}
					
		   function show(row, thr, ser){
		   
		   	document.getElementById("rows").value = row
		   	document.getElementById("threadid").value = thr
		   	document.getElementById("serialno").value = ser
		   	tot = document.getElementById("total").value
		   	
		   	count = 0
		   	
		   	ColdFusion.navigate('#SESSION.root#/tools/entityaction/Details/Notes/NoteBody.cfm?objectid=#url.objectid#&threadid=' + thr + '&serialno=' + ser, 'notebody')
		   	
		   }
					
		</script>	 
		  
</cfoutput>		  