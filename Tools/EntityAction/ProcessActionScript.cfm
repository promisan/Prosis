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

<cf_dialogStaffing>
<cf_mapscript>

<cfparam name="url.windowmode" default="window">
<cfparam name="url.myentity"   default="">

<script language="JavaScript">
    
    <!--- validate the regular form --->
	
    function validateform(frm,target,prc,id,ajax) {	
		   				    	
	    try {			    
				   
			document.getElementById(frm).onsubmit()		
					
			if( _CF_error_messages.length == 0 ) {	  			   
	    	    <!--- [it passed Passed the CFFORM JS validation, now run a Ajax script to save] --->
				ptoken.navigate('ProcessActionSubmit.cfm?myentity=#url.myentity#&windowmode=#url.windowmode#&submitaction=embedsave&process='+prc+'&wfmode=8&ID='+id+'&ajaxId='+ajax,target,'','','POST',frm)				  
				return true											
			} else {									
				return false			
			}   		
		} catch(e) {		
		    <!--- [it passed Passed the CFFORM JS validation, now run a Ajax script to save] --->
			ptoken.navigate('ProcessActionSubmit.cfm?myentity=#url.myentity#&windowmode=#url.windowmode#&submitaction=embedsave&process='+prc+'&wfmode=8&ID='+id+'&ajaxId='+ajax,target,'','','POST',frm)															
		}	 
	}
	
	function openmap(field)	{		   	
		val = document.getElementById(field).value			
		ProsisUI.createWindow('mymap', 'Google Map', '',{x:100,y:100,height:580,width:440,modal:false,resizable:false,center:true})    							
		ptoken.navigate('#SESSION.root#/Tools/Maps/MapView.cfm?field='+field+'&coordinates='+val,'mymap') 					
    }
	
	function refreshmap(field,ret) {		      	    
		document.getElementById(field).value = ret
		ptoken.navigate('#SESSION.root#/tools/maps/getAddress.cfm?coordinates='+ret,field)	
	} 

 	function profilereload(){
	    ptoken.navigate('ProcessAction8Embed.cfm?ajaxid=#URL.ajaxid#&process=#url.process#&ID=#URL.ID#','embeddialog')
	 }
	 
	function savereportfields(mode) {					
		emb = document.getElementById('formembed');
		fld = document.getElementById('formcustomfield');
		ap  = document.getElementById('actionprocessbox');
		
		// added by Dev to prevent breakout for ch for LOA
		
	    var wfmode = 8
						
	    if (emb) { 		
		  _cf_loadingtexthtml='';		  
		  ptoken.navigate('ProcessActionSubmit.cfm?myentity=#url.myentity#&windowmode=#url.windowmode#&submitaction=embedsave&wfmode='+wfmode+'&ajaxid=#URL.ajaxid#&process=#url.process#&ID=#URL.ID#','actionprocessbox','','','POST','formembed') 
		}
														
		if (fld && ap) {			
		  _cf_loadingtexthtml='';  		  
		  ptoken.navigate('ProcessActionSubmitCustom.cfm?closemode='+mode+'&windowmode=#url.windowmode#&wfmode='+wfmode+'&process=#URL.Process#&ID=#URL.ID#&ajaxId=#url.ajaxid#','actionprocessbox',mycallBack(),'','POST','formcustomfield')  
		}		
	}
	
	function savequestionaire(objectid,actioncode,id,formfield,field) {		     	     
		 _cf_loadingtexthtml='';	
		 ptoken.navigate('ProcessActionQuestionaireSubmit.cfm?objectid='+objectid+"&actioncode="+actioncode+'&questionid='+id+'&formfield='+formfield+'&field='+field,'i'+id,'','','POST','formquestionaire')	
	}

    function saveforms(mode) {		
		   
		if (mode == "7") {
		
		    <!--- this will mimic the old mode of 7 screens --->
			    document.processaction.onsubmit() 
				if( _CF_error_messages.length == 0 ) {
				    ptoken.navigate('ProcessActionSubmit.cfm?myentity=#url.myentity#&windowmode=#url.windowmode#&submitaction=saveaction&wfmode='+mode+'&process=#URL.Process#&ID=#URL.ID#&ajaxId=#url.ajaxid#','actionprocessbox','','','POST','processaction')				 
			   	 }   		   
		
		} else {				

			   <!--- check custom dialog if fields are pending --->
			  	  		   		   		  
			       <!--- -------------------------------------------------------------- --->
				   <!--- IMPORTANT to keep this in the order of form embeded, custom and normal submit  (dev dev) --->
				   <!--- -------------------------------------------------------------- --->
				   				   
				   embed  = document.getElementById("formembed")	
				   				   	
				   <!--- ---------------------- ---> 	
				   <!--- save the embedded form --->
				   <!--- ---------------------- --->					   
				  				   								   				  
				   if ( (document.getElementById('r0').checked == false) && (embed) ) {
				   
				           actionstatus = '0'
						   
				           try { 
						   
						       if (document.getElementById('r2').checked == true )  {
							      actionstatus = '2'  } 
								  } catch(e) {}	
							
						   try {    
							    if (document.getElementById('r2y').checked == true )  {
							      actionstatus = '2' } 
								  } catch(e) {}	
						   						   							           			  							
																   					   					      				      				      		   				       				      						       						   						     
					       // saving the custom non ajax form, if this does not succeed we need to stop it THOUGH 1/9/2015						   						   
						   try {
						 				
																						       		    				   
								document.getElementById("formembed").onsubmit()																																		
								if( _CF_error_messages.length == 0 ) {	 															   											
						    	    <!--- [it passed Passed the CFFORM JS validation, now run a Ajax script to save] --->
									ptoken.navigate('ProcessActionSubmit.cfm?myentity=#url.myentity#&windowmode=#url.windowmode#&submitaction=process&actionstatus='+actionstatus+'&process=#url.process#&wfmode=8&ID=#url.id#&ajaxId=#url.ajaxid#','actionprocessbox','','','POST','formembed')	
								}   							
							} catch(e) {}					   
														   	   						   			   
				   } else { 				   				
				   				 					  				 
						   <!--- ---------------------- --->
						   <!--- save the custom fields ---> 	
						   <!--- ---------------------- --->	
						   
						   custo  = document.getElementById("formcustomfield");
						   
						   // if ((document.getElementById('r0').checked == false) && (custo)) {				  				   
						   
						   if (custo) {						   	 
							
						      document.formcustomfield.onsubmit()

							   if( _CF_error_messages.length == 0 ) {
								
							     	try { ptoken.navigate('ProcessActionSubmitCustom.cfm?closemode=1&windowmode=#url.windowmode#&wfmode='+mode+'&process=#URL.Process#&ID=#URL.ID#&ajaxId=#url.ajaxid#','actionprocessbox',mycallBack(),'','POST','formcustomfield')  } catch (e) {}
							   } else {
							   
							   Prosis.busy('no')
							   
							   }
							   							    	
						   } else {  

							     <!--- save the action directly --->								
							     try { 	
							  
								 ptoken.navigate('ProcessActionSubmit.cfm?myentity=#url.myentity#&windowmode=#url.windowmode#&submitaction=saveaction&wfmode='+mode+'&process=#URL.Process#&ID=#URL.ID#&ajaxId=#url.ajaxid#','actionprocessbox','','','POST','processaction') 					
								 } catch (e) {}										 
								      				   				   
						   }
								
					}
			}
		
	}
	
	function maildialog(obt,cde,glob) {	
	    	    
	    parent.ProsisUI.createWindow('wMailDialog', 'Notification', '',{x:100,y:100,height:600,width:890,modal:true,center:true})    				   
		parent.ptoken.navigate('#session.root#/Tools/entityaction/ProcessMailView.cfm?objectid='+obt+'&actioncode='+cde+'&NotificationGlobal='+glob,'wMailDialog');								
	}	
					
	function embedtabdoc(actionid,docid,sign,language,format,no,act) {		
	
	    if (act == 'refresh') {		
			if (confirm("This action will overwrite any changes you might have made to this document.\\Do you want to continue ?")) {
		    	ptoken.navigate('Report/DocumentProcess.cfm?actionid='+actionid+'&docid='+docid+'&sign='+sign+'&language='+language+'&format='+format+'&no='+no+'&action='+act,'docaction'+docid) 	 		   
		    } 
		} else {			      
		ptoken.navigate('Report/DocumentProcess.cfm?actionid='+actionid+'&docid='+docid+'&sign='+sign+'&language='+language+'&format='+format+'&no='+no+'&action='+act,'docaction'+docid) 	 		   
		}
	}           	
	
	function mycallBack() { }
		
	var myerrorhandler = function(errorCode,errorMessage){
		alert("[In Error Handler]" + "\n\n" + "Error Code: " + errorCode + "\n\n" + "Error Message: " + errorMessage);
	}	

	function showprocess() {
		ColdFusion.Layout.showTab('processbox', 'actionstep')	
		ColdFusion.Layout.selectTab('processbox', 'actionstep')		
	}
	
	function more(bx,act) {
	
	    icM  = document.getElementById(bx+"Min")
	    icE  = document.getElementById(bx+"Exp")
		se   = document.getElementById(bx)
			
		if (se.className=="hide") {
			se.className  = "regular";
			icM.className = "regular";
		    icE.className = "hide";
		} else {
			se.className  = "hide";
		    icM.className = "hide";
		    icE.className = "regular";
		}
	}	
		
	ie = document.all?1:0
	ns4 = document.layers?1:0

	function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 	 	 		 	
	 if (fld != false){		
	 	itm.className = "highLight2";
	 }else{		
	     itm.className = "regular";		
	 }
	}	
		
	function workflowshow(pub,ent,cls,cde,obj)	{				    			
		ptoken.open("#SESSION.root#/System/EntityAction/EntityFlow/ClassAction/FlowView.cfm?scope=object&objectid="+obj+"&connector=init&PublishNo="+pub+"&EntityCode="+ent+"&EntityClass="+cls+"&ActionNoShow="+cde, "_blank");						
	}
	
	function showdetail(row) {

	 se1 = document.getElementById(row+'Exp')
	 se2 = document.getElementById(row+'Min')
	 se3 = document.getElementById('act'+row)
	 if (se1.className == "regular") {
		    se2.className = "regular"
			se1.className = "hide"
			se3.className = "regular"
	 } else {
		    se1.className = "regular"
			se2.className = "hide"
			se3.className = "hide"
	 }
    }	 
  
  	function saveoutput(mode,id,docid,frm,ele) {		 
		 ptoken.navigate('ProcessActionDocumentTextSubmit.cfm?memoactionid='+id+'&documentid='+docid+'&element='+ele+'&frm='+frm,'myboxes','','','POST',frm)	 
		 if (mode != "save") {
			    docoutput(mode,id,docid)
		 }	 	 
	}	
		
	function docoutput(mode,id,docid) {
	
		if (mode != "mail") {
		  w = #CLIENT.width# - 100;
		  h = #CLIENT.height# - 140;		 		 
		    if (mode != "print") {
			  ptoken.open("ActionPrint.cfm?mode="+mode+"&id="+id+"&docid="+docid,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=yes, status=yes, scrollbars=no, resizable=no")
			  } else {
			  ptoken.open("ActionPrint.cfm?mode="+mode+"&id="+id+"&docid="+docid,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=yes, status=yes, scrollbars=yes, resizable=no")	
			  }
		  } else {
		  ptoken.open("ActionMail.cfm?id="+id+"&docid="+docid,"_blank", "left=30, top=30, width=800, height=600 , toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	    }
	}
			
	function blocktoggle(act,mem,mai) {
	
	   bact = document.getElementById("processblock");
	   	      
	   if (act == "show") {	   
	   	  bact.className   = "regular";
	    } else {
		  bact.className   = "hide"; }
		
	   bmem = document.getElementById("memoblock");
	   	  
	   if (mem == "show") {
	   	  bmem.className   = "regular";
	    } else {
		  bmem.className   = "hide"; }	  
	
	   try {	
		   bmai1 = document.getElementById("mailblock1");	  
		   bmai2 = document.getElementById("mailblock2");	 
		   if (mai == "show") {
			   	  bmai1.className   = "regular";
				  bmai2.className   = "regular";
		    } else {
				  bmai1.className   = "hide";
				  bmai2.className   = "hide"; }	    
			} catch(e) {}		  
    }		 		
		
	function print(id) {
		  w = #CLIENT.width# - 100;
		  h = #CLIENT.height# - 140;
		  ptoken.open("#SESSION.root#/Tools/EntityAction/ActionPrint.cfm?id="+id,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
  	}
	
    function mail(id) {
	      ptoken.open("#SESSION.root#/Tools/EntityAction/ActionMail.cfm?id="+id,"_blank", "width=800, height=615, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")	 
  	}	
			
	function selectoption(selectbox,itm) {
							
		try { document.getElementById("d0").style.fontWeight      = "normal"; } catch(e) {}
		try { document.getElementById("d1").style.fontWeight      = "normal"; } catch(e) {}
		try { document.getElementById("d2").style.fontWeight      = "normal"; } catch(e) {}
		try { document.getElementById("d2n").style.fontWeight     = "normal"; } catch(e) {}
		try { document.getElementById("d2y").style.fontWeight     = "normal"; } catch(e) {}
		
		try { document.getElementById(selectbox).style.fontWeight = "bold"; } catch(e) {}
		
		try { document.getElementById("dialog0").className        = "hide"; } catch(e) {}
		try { document.getElementById("dialog1").className        = "hide"; } catch(e) {}
		try { document.getElementById("dialog2").className        = "hide"; } catch(e) {}
		try { document.getElementById("dialog2N").className       = "hide"; } catch(e) {}
		try { document.getElementById("dialog2Y").className       = "hide"; } catch(e) {}
		
		try { document.getElementById("dialog"+itm).className = "regular"; } catch(e) {}
		
		try {
			revert1 = document.getElementById("d1a")
			if (revert1) {
				revert1.className = "hide";
				revert2 = document.getElementById("d1b");
				revert2.className = "hide"; }	
		} catch(e) {}
		
		try {	
	
		if (selectbox == "d1") {
		    if (revert1) {
			revert1.className = "regular";
			revert2.className = "regular";
			}
			}
			
			} catch(e) {}	
						
		}		
	
   function check(val) {
	 
	 var count = 1
	 se = document.getElementsByName("account")
	
	 while (count <= 30) {
	 
	     if (se[count]) {
			 se[count].checked = val
			 row = document.getElementById("d"+count)		 
			 if (row) {
				 if (val == true) {
				  row.className = "highlight2"
				 } else {
				  row.className = "regular" }
			 	 }		 
			 }
		 count++
	 }	 	 
	 }
		
	</script>
	
</cfoutput>


