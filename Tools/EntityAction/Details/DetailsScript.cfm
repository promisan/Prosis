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
<cfajaximport tags="cfdiv">

<cfoutput>
								  	
	<script language="JavaScript">
	
	function address() {
	
		to  = document.getElementById("sendTO").value
		cc  = document.getElementById("sendCC").value
		bcc = document.getElementById("sendBCC").value
			
		ProsisUI.createWindow('addressdialog', 'Address book', '',{x:100,y:100,height:document.body.clientHeight-140,width:document.body.clientWidth-140,modal:true,center:true})    
		ptoken.navigate('#SESSION.root#/tools/mail/AddressBook.cfm?to='+to+'&cc='+cc+'&bcc='+bcc,'addressdialog') 	
	
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
	
	function openfunction(itm,object,topic,mode,action){ 
	
 	 icM  = document.getElementById(itm+"Min")
	 icE  = document.getElementById(itm+"Exp")		
	 		
	 if (icM.className == "hide") {	 	   
	 	 	
	 	 icM.className = "regular";
		 icE.className = "hide";	
		 document.getElementById(itm).className = "regular"	
										 
		 if (topic == "fnts") {
			 ptoken.navigate('#SESSION.root#/tools/entityaction/details/notes/NoteList.cfm?box='+itm+'_'+object+'&mode=note&objectid='+object+'&actioncode='+action,itm+'_'+object)
		 }	
		 
		  if (topic == "fact") {
			 ColdFusion.navigate('#SESSION.root#/tools/entityaction/details/actor/ActorView.cfm?box='+itm+'_'+object+'&mode=actor&objectid='+object+'&actioncode='+action,itm+'_'+object)
		 }	
	 
		 if (topic == "fexp") {
			 ColdFusion.navigate('#SESSION.root#/tools/entityaction/details/cost/CostList.cfm?box='+itm+'_'+object+'&mode=cost&objectid='+object+'&actioncode='+action,itm+'_'+object)
		 }	
		 
		 if (topic == "ftme") {
			 ColdFusion.navigate('#SESSION.root#/tools/entityaction/details/cost/CostList.cfm?box='+itm+'_'+object+'&mode=work&objectid='+object+'&actioncode='+action,itm+'_'+object)
		 }	
		 
		  if (topic == "ftpl") {
			 ColdFusion.navigate('#SESSION.root#/tools/entityaction/details/template/Template.cfm?box='+itm+'_'+object+'&mode=template&objectid='+object+'&actioncode='+action,itm+'_'+object)
		 }	
						  
	 } else {	
	 	     	 
		 icE.className = "regular";
		 icM.className = "hide";	
		 document.getElementById(itm).className = "hide"							 
	 }
	 
	 }
	 	
	 function costentry(objectid,id,tpe,mode,box,action) {	
	 	    ProsisUI.createWindow('costdialog', 'Costs', '',{x:100,y:100,height:540,width:600,modal:true,center:true})    			  			
			ptoken.navigate('#SESSION.root#/tools/entityaction/Details/Cost/CostEntry.cfm?box='+box+'&mode='+mode+'&objectid='+objectid+'&recordid='+id+'&type='+tpe+'&actioncode='+action,'costdialog') 					
	 }
		
	 function costask(objectid,id,mode,box,action) {
	   		ptoken.navigate('#SESSION.root#/tools/entityaction/Details/Cost/CostDelete.cfm?box='+box+'&mode='+mode+'&objectid='+objectid+'&objectcostid='+id+'&actioncode='+action,'costdialog') 				
	 }
			 	
	 function costhidedialog(tpe) {
	        ProsisUI.closeWindow('costdialog')	
	 }  
		
	 function costtoggle(id,row) {
	        ptoken.navigate('#SESSION.root#/tools/entityaction/Details/Cost/CostStatus.cfm?objectcostid='+id+'&row='+row+'&toggle=1','coststatus'+row);
	 }	
			 
	 function noteentry(objectid,threadid,ser,type,to,mode,box,action) {	
	 	      	
			try {			
			se = document.getElementById("selecteditem")	
			sid = se.value 
			} catch(e) {
			sid = "" 
			} 		
						
			if (mode != 'Actor') {
			
				w = 820
				h = 700			
				ptoken.open("#SESSION.root#/tools/entityaction/Details/Notes/NoteEntry.cfm?box="+box+"&mode="+mode+"&to="+to+"&type="+type+"&objectid="+objectid+"&threadid="+threadid+"&serialno="+ser+"&actioncode="+action+"&sitem="+sid+"&ts="+new Date().getTime(), "amendment", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=no");											
				} 
				
			else {
				se = window.showModalDialog("#SESSION.root#/tools/entityaction/Details/Notes/NoteEntry.cfm?box="+box+"&mode="+mode+"&to="+to+"&type="+type+"&objectid="+objectid+"&threadid="+threadid+"&serialno="+ser+"&actioncode="+action+"&sitem="+sid, window, "unadorned:yes; edge:raised; status:no; dialogHeight:700px; dialogWidth:820px; help:no; scroll:no; center:yes; resizable:yes");
				ColdFusion.navigate('#SESSION.root#/tools/entityaction/details/notes/NoteList.cfm?box='+box+'&mode='+mode+'&objectid='+objectid+'&actioncode='+action,box) 			
			}
	 }	 			
			 	
	 function notehidedialog(tpe) {
	        if (tpe == 'notes') { 
	        ColdFusion.Window.hide('notedialog')	
			} else {
			ColdFusion.Window.hide('notedialog')
			}
	 }
							
	</script>	 
		  
</cfoutput>		 

