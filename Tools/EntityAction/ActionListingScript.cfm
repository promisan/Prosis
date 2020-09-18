
<cfoutput>


<style>
      .Procets{
          display: inline;
		  line-height:18px;
          background:##F4F4F4 url('#SESSION.root#/Images/Process.png') no-repeat 98% center;
          background-size:16px 16px;
          border: 1px solid ##cccccc;
		  border-left: 0px solid ##cccccc;
          border-radius: 0 8px 8px 0;
          margin: 0 0 0 0px;
          font-size: 11px;
          font-weight: 600;
          padding: 10px 18px 10px 10px;
          text-align: left;
          color: ##D35400;
          text-transform: uppercase;
          float: left;
	      max-width: 158px;
		  min-width:60px;
      }
      .Procets:hover{
          background:rgba(174, 192, 108,1) url('#SESSION.root#/Images/Process-W.png') no-repeat 98% center;
          background-size:16px 16px;
          color: ##FFFFFF;
          text-decoration: none;
          cursor:pointer;
          
      }
       @media screen and (-ms-high-contrast: active), (-ms-high-contrast: none) {
	.Procets,.Procets:hover{
              
              background-size:16px 16px;
              max-width: 158px;
		      min-width: 70px;
          }
         
      }
	
		
 </style>

<cfparam name="url.myclentity" default="">

<!--- provision added 26/4/2010 for reload of a screen --->
<cfset qstr = replace("#CGI.QUERY_STRING#","&","|","ALL")>
<cfset qstr = replace("#qstr#","'","","ALL")>

<cfif qstr neq "">
	<cfset loadlink = "#CGI.SCRIPT_NAME#?#qstr#">
<cfelse>
	<cfset loadlink = "#CGI.SCRIPT_NAME#">
</cfif>

<cf_tl id="More" var="vMoreMsg">
<cf_tl id="Less" var="vLessMsg">

<cf_systemscript>
<cf_dialogorganization>
<cf_ajaxRequest>
<cf_mapscript>

<script language="JavaScript">

	function opentree(mis) {
	    ptoken.open(root + "/System/Organization/Application/OrganizationView.cfm?mode=embed&mission=" + mis, "orgtree", "width=980, height=660, status=yes, toolbar=no, scrollbars=yes, resizable=no");		
	}

	function aboutworkflow(id) {
	
	    try { ProsisUI.closeWindow('aboutworkflow',true)} catch(e){};
		ProsisUI.createWindow('aboutworkflow', 'About this workflow', '',{x:10,y:10,height:250,width:460,resizable:false,modal:true,center:true});
		ptoken.navigate('#SESSION.root#/Tools/EntityAction/AboutThisWorkflow.cfm?objectid='+id,'aboutworkflow')					
	}
	
	function setwforgunit(object,org,target) {
	   _cf_loadingtexthtml='';	
		ptoken.navigate('#SESSION.root#/Tools/EntityAction/AboutThisWorkflowUnit.cfm?objectid='+object+'&orgunit='+org,'orgunit_'+object)		
	}

	function templatedetail(id,compare) {
		  w = #CLIENT.width# - 30;
		  h = #CLIENT.height# - 100;
		  window.open("#SESSION.root#/System/Template/TemplateDetail.cfm?id="+id+"&compare="+compare,"_blank","left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes")
	}
	
	function maildialog(obt,cde,glob) {			   
		window.open("#SESSION.root#/Tools/EntityAction/ProcessMailDialog.cfm?objectid="+obt+"&actioncode="+cde+"&NotificationGlobal="+glob, "wMailDialog", "height=700, width=700");				
	}	
	
	function userlocateN(formname,id,id1,id2,id3,id4) {
		
		wid = document.body.clientWidth-80		
		if (wid > 800) {
		  wid = 800
		}
		ProsisUI.createWindow('userdialog', 'Select User', '',{x:100,y:100,height:document.body.clientHeight-90,width:wid,modal:true,center:true})    
		ptoken.navigate('#SESSION.root#/System/Access/Lookup/UserSearch.cfm?Form=' + formname + '&id=' + id + '&id1=' + id1 + '&id2=' + id2 + '&id3=' + id3 + '&id4=' + id4,'userdialog') 	
	
	}
		
	<!--- context sensitive for workflow process dialog embedded workflow only --->
	
	function workflowreload(ajaxid) {		
					
		el = document.getElementById("workflowlink_"+ajaxid)		
														
		if (el) {
						    
			ln = el.value	
									
			try {			   		  
			   document.getElementById("workflowlinkprocess_"+ajaxid).click()				      		   
			} catch(e) {}											
									
			try {			 
				cd = document.getElementById("workflowcondition_"+ajaxid).value;
				_cf_loadingtexthtml="";
				ptoken.navigate(ln+cd,ajaxid)
				_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";	
				
				} catch(e) {	
			
			    _cf_loadingtexthtml="";											  	    
			    ptoken.navigate(ln+'?ajaxid='+ajaxid,ajaxid)												
				_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";							
				
				}			
		}		
		
    }		
	  
	  <!--- checks the comments status --->
	  function commentstatus(last,id,ajaxid) {	       	  	    
        se = document.getElementById('communicatecomment_'+id)				
		if (se) {					
		ptoken.navigate('#SESSION.root#/tools/EntityAction/getCommentStatus.cfm?last='+last+'&objectid='+id+'&ajaxid='+ajaxid,'communicatecomment_'+id,null,workflowerrorhandler)	 		 									
		}		
    }		
	  
	function commentreload(ajaxid) {	
		var vId = ajaxid.replace(/-/gi, '');	 
	  	_cf_loadingtexthtml="";
	  	ptoken.navigate('#session.root#/Tools/EntityAction/Details/Comment/CommentListingContent.cfm?objectid='+ajaxid,'communicatecomment_'+vId)	
	}  	   
		
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
						
	function workflowshow(pub,ent,cls,cde,obj)	{	
		ptoken.open('#SESSION.root#/System/EntityAction/EntityFlow/ClassAction/FlowView.cfm?scope=object&objectid='+obj+'&connector=init&PublishNo='+pub+'&EntityCode='+ent+'&EntityClass='+cls+'&ActionNoShow='+cde, 'workflow');	
	    /*	    			in Finantial Event, the error was triggered: "root is undefined"
		ptoken.open(root + '/System/EntityAction/EntityFlow/ClassAction/FlowView.cfm?scope=object&objectid='+obj+'&connector=init&PublishNo='+pub+'&EntityCode='+ent+'&EntityClass='+cls+'&ActionNoShow='+cde, 'workflow','status=yes,height=800,width=1000,scrollbars=yes,center=yes,resizable=yes');					
		*/
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
	 	
	<!--- attachment scripts --->
	
	function del_att(id,doc,own) {		
	
		url = "#SESSION.root#/tools/entityaction/ActionListingViewExternal.cfm?ts="+new Date().getTime()+"&objectid="+id+"&documentid="+doc+"&ownerid="+own;
	
		AjaxRequest.get({
		        'url':url,
		        'onSuccess':function(req){ 					
			     document.getElementById("external").innerHTML = req.responseText;
				 },						
		        'onError':function(req) { 	
				 document.getElementById("external").innerHTML = req.responseText;}	
		         });			
	}	
	
	function res_att(id,doc,own) {		
	
		url = "#SESSION.root#/tools/entityaction/ActionListingViewExternal.cfm?ts="+new Date().getTime()+"&objectid="+id+"&documentid=1&ownerid="+own+"&reset=1";
	
		AjaxRequest.get({
		        'url':url,
		        'onSuccess':function(req){ 					
			     document.getElementById("external").innerHTML = req.responseText;
				 },						
		        'onError':function(req) { 	
				 document.getElementById("external").innerHTML = req.responseText;}	
		         });			 
	}	 
	
	function objectdetail(id,itm) {
	    w = #CLIENT.width# - 100;
	    h = #CLIENT.height# - 130;	
		if (itm == "communicator") {
		ptoken.open("#SESSION.root#/ActionView.cfm?id="+id, "communicator"+id);		
		} else {	
		ptoken.open("#SESSION.root#/Tools/EntityAction/Details/DetailsSelect.cfm?item="+itm+"&objectid="+id, "mailobject", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");		
		}
	}
		
	function pdf_merge(id) {
		
		document.getElementById("pdf_wait_"+id).className = "regular";	
		url = "#SESSION.root#/tools/PDF/PDF_workflow.cfm?ts="+new Date().getTime()+"&objectid="+id;
	
		AjaxRequest.get({
		        'url':url,
		        'onSuccess':function(req){ 	
				 document.getElementById("pdf_wait_"+id).className = "hide"	;			
			     <!--- document.getElementById("pdf_select").innerHTML = req.responseText; --->
				 window.open("#SESSION.root#/cfrstage/mergepdf/"+id+".pdf?ts="+new Date().getTime(),"pdf", "status=yes, toolbar=no, scrollbars=no, resizable=yes")
				 },						
		        'onError':function(req) { 	
				 document.getElementById("pdf_wait_"+id).className = "hide"					      
			     document.getElementById("pdf_select_"+id).innerHTML = req.responseText;}	
		         });			 
	}		
	
	function openmap(field)	{			
		val = document.getElementById(field).value	
		try { ColdFusion.Window.destroy('mymap',true) } catch(e) {}
		ColdFusion.Window.create('mymap', 'Google Map', '',{x:100,y:100,height:580,width:440,modal:true,resizable:false,center:true})    							
		ColdFusion.navigate('#SESSION.root#/Tools/Maps/MapView.cfm?field='+field+'&coordinates='+val,'mymap') 					
    }
	
	function refreshmap(field,ret) {		   
		document.getElementById(field).value = ret
		ptoken.navigate('#SESSION.root#/tools/maps/getAddress.cfm?coordinates='+ret,'map_'+field)	
	} 
			
	function process(id,allow,ajaxid,pmde) {	
		    
		w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 70;	
						
		if (ajaxid == "" || pmde == "0" || pmde == "2" || pmde == "3" || pmde == "4") {	
			
			if (pmde == "3" || pmde == "4") {				   
			ptoken.open("#SESSION.root#/Tools/EntityAction/ProcessAction.cfm?windowmode=window&ajaxid="+ajaxid+"&process="+allow+"&id="+id+"&myentity=#url.myclentity#", "_blank"); 					
			} else {
			ptoken.open("#SESSION.root#/Tools/EntityAction/ProcessAction.cfm?windowmode=window&ajaxid="+ajaxid+"&process="+allow+"&id="+id+"&myentity=#url.myclentity#", "_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes"); 								
			}

		} else {	
					
			// ptoken.open("#SESSION.root#/Tools/EntityAction/ProcessAction.cfm?windowmode=window&ajaxid="+ajaxid+"&process="+allow+"&id="+id+"&myentity=#url.myclentity#", "_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes"); 					
					
			ProsisUI.createWindow('workflowstep', 'Process workflow step', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,center:true})    
			ptoken.navigate('#SESSION.root#/Tools/EntityAction/ProcessActionView.cfm?windowmode=embed&ajaxid='+ajaxid+'&process='+allow+'&id='+id+'&myentity=#url.myclentity#','workflowstep')
				
		}					
	}	
	
	function personcancel(ajaxid,persno,line,template,cls) {
	   
		if (confirm("Do you want to remove this person from the shortlist ?")) {		
		    _cf_loadingtexthtml='';		  
		    ptoken.navigate(template+'?line='+line+'&ajaxid=' + ajaxid + '&ID1=' + persno + '&personclass='+cls,'urldetail'+line)				       
		}	
	}	
		
	function actionlog(id) {
	    w = #CLIENT.width# - 120;
	    h = #CLIENT.height# - 130;
		ptoken.open("#SESSION.root#/Tools/EntityAction/Dialog/DialogContent.cfm?id="+id, "_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes");
	}
	  
	function documentshow(id,row,wd) {	
		
		icE  = document.getElementById("d"+row+"Min");
		icM  = document.getElementById("d"+row+"Exp");
		se   = document.getElementById("d"+row);
						
		if (se.className == "hide") {	
		    
			icM.className = "regular";
			icE.className = "hide";
			se.className  = "regular";					
			ptoken.navigate('#SESSION.root#/Tools/EntityAction/ActionListingViewEmbed.cfm?box='+row+'&textmode=read&memoactionid='+id+'&width='+wd,'document_'+row)
				
		} else {
		    
		    icM.className = "hide";
			icE.className = "regular";
			se.className  = "hide";		
		}	
	}	
  	 
  function remind(obj,code) {    
	// if (confirm("Do you want to send a reminder ?")) {
    ptoken.open("#SESSION.root#/Tools/EntityAction/ProcessMailDialog.cfm?Text=REMINDER&ActionCode="+code+"&ObjectId="+obj,"_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	// }
 
  }	 	 
  
  <!--- ------------------------------------------------ ---> 
  <!--- modified to open without a nasty dialog 6/5/2009 --->	
  <!--- ------------------------------------------------ --->  
 	 
  function reopen(id,ajaxid)  {    
	if (confirm("Do you want to reopen this step of the workflow ?")) {
	
		if (ajaxid == "") {
			ptoken.location("#SESSION.root#/Tools/EntityAction/ActionReopen.cfm?id="+id+"&ref=#loadlink#")
		} else {
			ptoken.navigate('#SESSION.root#/Tools/EntityAction/ActionReopen.cfm?ajaxid='+ajaxid+'&id='+id+'&ref=#loadlink#',ajaxid)
		}

	}	
  }	     
   
  <!--- ------------------------------------------------ ---> 
  <!--- modified to open without a nasty dialog 6/5/2009 --->
  <!--- ------------------------------------------------ ---> 
  function resetwf(id,ajaxid,cls) {   
      ProsisUI.createWindow('wfreset', 'Reset workflow', '',{x:100,y:100,height:300,width:600,modal:true,center:true})    
	  ptoken.navigate('#SESSION.root#/Tools/EntityAction/Dialog/DialogReset.cfm?entityclass=' + cls + '&objectid=' + id + '&ajaxid=' + ajaxid,'wfreset') 	
  }
  
  function resetwfapply(id,ajaxid,mde,cls,ret) {  
       
	   if (ajaxid == '') {
	   ptoken.location('#SESSION.root#/Tools/EntityAction/ActionReset.cfm?archive='+mde+'&ref=#loadlink#&objectid='+id+'&entityclassnew='+cls+'&retain='+ret) 	  
	   } else {	   	 	 
	   ptoken.navigate('#SESSION.root#/Tools/EntityAction/ActionReset.cfm?archive='+mde+'&ref=#loadlink#&objectid='+id+'&entityclassnew='+cls+'&retain='+ret+'&ajaxid='+ajaxid,ajaxid) 	  
	   }  
  } 
  
  function resetgroup(id) {    
   if (confirm("Do you want to associate the flow to a different authorization group ?")) {	   
       se = document.getElementById("newgroup_"+id)
	   ptoken.navigate('#SESSION.root#/Tools/EntityAction/GroupReset.cfm?objectid='+id+'&entitygroupnew='+se.value,'groupreset_'+id)
	 } else {
	   se  = document.getElementById("newgroup_"+id)
	   old = document.getElementById("priorgroup_"+id)
	   try {
	   se.options[old].selected = true 
	   } catch(e) { se.options[0].selected = true }
	 } 
  }	 
    
  function init(id) {    
	if (confirm("Do you want to associate this document to another workflow ?")) {
       ptoken.open("#SESSION.root#/Tools/EntityAction/ActionNew.cfm?ts=#now()#&id="+id,"_blank", "left=30, top=30, width=50, height=50, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")
	} 
  }	    
      
  function printme(id,format) {
	  w = #CLIENT.width# - 100;
	  h = #CLIENT.height# - 140;
	  ptoken.open("#SESSION.root#/Tools/EntityAction/ActionPrint.cfm?format="+format+"&id="+id,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
  }
		
  function mailsend(id) {
	 ptoken.open("#SESSION.root#/Tools/EntityAction/ActionMail.cfm?id="+id,"_blank", "width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
  }	
		
  function statusbar(text) {
     window.status = text	
  }	     
	
  function ajaxdialog(box,row,id) {
  		
	di = document.getElementById(box+row)	
	ep = document.getElementById(box+row+"Max")
	co = document.getElementById(box+row+"Min")	
	
	if (ep.className == "hide") {
	
		ep.className = "regular"
		co.className = "hide"
		di.className = "hide"
	
	} else {
	
		ep.className = "hide"
		co.className = "regular"
		di.className = "show"
		url = "#SESSION.root#/tools/EntityAction/ActionListingViewMail.cfm?actionid="+id;
	    ptoken.navigate(url,box+row)	
    }		
  }	
  
  <!--- checks the object status --->
  function objectstatus(last,id,ajaxid) {	
        try {       	  	    
        	se = document.getElementById('communicate_'+id)		
			if (se) {		
			ptoken.navigate('#SESSION.root#/tools/EntityAction/getObjectStatus.cfm?lastaction='+last+'&objectid='+id+'&ajaxid='+ajaxid,'communicate_'+id,null,workflowerrorhandler)	 		 									
			}	
		} catch(e) {}
  }		  
    
  var workflowerrorhandler = function(errorCode,errorMessage){	 	           
      // nada
  } 
  	  
  function toggleaction(id) {    
		  se = document.getElementById("d"+id)	  
		  if (se.className == "hide") {
		  se.className = "button10s"
		  } else {
		   se.className = "hide"
		  }  
    }
		
  function submitwfquick(id,ajaxid) {
        		
		var act  = ""		
		count = 0		
		se = document.getElementsByName("confirmwf")	 	
		while (se[count]) {
				if (se[count].checked == true)	{
					act = act+','+se[count].value					  
				}
				count++
				} 		
		ptoken.navigate('#SESSION.root#/tools/entityaction/ProcessActionSubmitQuick.cfm?myentity=#url.myclentity#&ref=#loadlink#&ajaxid='+ajaxid+'&confirm='+act,'quick'+id)						
	}			
				
    function stepedit(ent,cls,pub,code) {		
		  ptoken.open("#SESSION.root#/System/EntityAction/EntityFlow/ClassAction/ActionStepEdit.cfm?EntityCode="+ent+"&EntityClass="+cls+"&ActionCode="+code+"&PublishNo="+pub, "Edit", "left=80, top=80, width=980, height=890, toolbar=no, status=yes, scrollbars=no, resizable=no");			
	}			
				
	function showatt(row) {

	 se1 = document.getElementById(row+'Exp')
	 se2 = document.getElementById(row+'Min')
	 se3 = document.getElementById('att'+row)
	 if (se1.className == "regular") {
	  	  	se2.className = "regular"
			se1.className = "hide"
			se3.className = "hide"
	 } else {
		    se1.className = "regular"
			se2.className = "hide"
			se3.className = "regular"
	 }
    } 
		
	function accessgrantedwf(topic,row,act,set,org,role,pub) {
				
			icE  = document.getElementById(topic+row+"Min");			
			icM  = document.getElementById(topic+row+"Exp");
			se   = document.getElementById(topic+row);
							
			url = "#SESSION.root#/tools/EntityAction/ActionListingActor.cfm?OrgUnit="+org+"&Role="+role+"&ActionPublishNo="+pub+"&ActionCode="+set+"&box="+topic+row
							
			if (icE.className == "regular") {
			   	 icM.className = "regular";
			     icE.className = "hide";
				 se.className  = "regular";
				 if (set != "") { ptoken.navigate(url,topic+row) }				 
	 	    } else {
			   	 icM.className = "hide";
			     icE.className = "regular";
			   	 se.className  = "hide";
			}
			
	 }
	 
	function questionairewf(topic,row,act,set,obj,role,pub) {
											
			se   = document.getElementById(topic+row);							
			url = "#SESSION.root#/tools/EntityAction/ActionListingViewQuestion.cfm?Object="+obj+"&Role="+role+"&ActionPublishNo="+pub+"&ActionCode="+set+"&box="+topic+row
							
			if (se.className != "regular") {			   
				se.className  = "regular";
				if (set != "") { ptoken.navigate(url,topic+row) }				 
	 	    } else {			   	
			   	se.className  = "hide";
			}			
	 }
	 		 
	function accessedit(id,id1,id2,acc,box,mode,orgunit,actionpublishno,actioncode,group,assist) {				        
		ptoken.navigate('#SESSION.root#/tools/entityAction/ActionListingActor.cfm?role='+id+'&box='+box+'&mode='+mode+'&ObjectId='+id2+'&OrgUnit='+orgunit+'&ActionPublishNo='+actionpublishno+'&ActionCode='+actioncode+'&Group='+group+'&Assist='+assist,box)			
	} 
			
	function accessremove(id ,id1, acc)	{
		ptoken.open("ProcessActionAccessDelete.cfm?ID="+id+"&ID1="+id1+"&acc="+acc, "_blank", "width=10, height=10, status=yes, toolbar=yes, scrollbars=yes, resizable=no");
	}				
			
	function maximize(itm) {
	 
		 se   = document.getElementsByName(itm)
		 icM  = document.getElementById(itm+"Min")
		 icE  = document.getElementById(itm+"Exp")
		 count = 0
			 
		 if (icM.className == "regular") {
			
			 icM.className = "hide";
			 icE.className = "regular";			 
			 while (se[count]) {
			   se[count].className = "hide"
			   count++ }
		 
		 } else {		 	 
			 while (se[count]) {
			 se[count].className = "regular"
			 count++ }
			 icM.className = "regular";
			 icE.className = "hide";				 	
		 }	
	 
	 }		
	 
	 function toggleCommentLength(contentSelector, containerSelector, toggler, twistie, maxChars) {
	 	if ($(toggler).val() == 0) {
			$(toggler).val(1);
			$(twistie).html(' [#vMoreMsg#]');
			$(containerSelector + ' div').html($(contentSelector).html().substring(0,maxChars) + ' ...');
		}else{
			$(toggler).val(0);
			$(twistie).html(' [#vLessMsg#]');
			$(containerSelector + ' div').html($(contentSelector).html());
		}
	 }
	 			  	
</script>

</cfoutput>
