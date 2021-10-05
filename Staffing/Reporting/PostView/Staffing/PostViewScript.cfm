
<cfoutput>

<cf_listingscript>
<cf_actionlistingscript>
<cf_menuscript>
<cf_calendarviewscript>

<cfinclude template="../../../Application/WorkSchedule/Planning/PlanningViewScript.cfm">

<cf_customLink
	FunctionClass = "Staffing"
	FunctionName  = "stPosition"
	Key           = ""
	ScriptOnly    = "Yes">	
	
<script language="JavaScript">

function quicksearch(e) {	       
	   keynum = e.keyCode ? e.keyCode : e.charCode;	   	 						
	   if (keynum == 13) {
	      document.getElementById("gosearch").click();
	   }						
   }
	
function detail(cls,mis,dte) {
    var w = #CLIENT.width# - 40;
    var h = #CLIENT.height# - 130;
	var vContents = $('##vacancybox').contents().find('body').html();
	if ($.trim(vContents) == '') {
		ptoken.open("../../Inquiry/DetailView.cfm?link=#link#&ts="+new Date().getTime()+"&mission="+mis+"&dte="+dte+"&class="+cls,"vacancybox");
	}
}	


 function treeview(mis,man,tree) {
	ptoken.open('#SESSION.root#/system/organization/Tree/OrgTree.cfm?link=#link#&mission='+mis+'&mandateno='+man+'&tree='+tree,'tree'+mis);
 }

function positionview(mis,man,tree) {
	ptoken.open('#SESSION.root#/Staffing/Portal/Staffing/StaffingPosition.cfm?header=1&mission='+mis+'&mandateno='+man,'tree'+mis);
}

function tree(mis,man,tree,dte) {
	var vContents = $('##analysisbox').contents().find('body').html();
	if ($.trim(vContents) == '') {
		ptoken.open("#SESSION.root#/System/Organization/Orgtree/OrgTree.cfm?systemfunctionid=#url.systemfunctionid#&mission="+mis+"&mandateno="+man+"&tree="+tree+"&date="+dte,"analysisbox");
	}
}

function facttabledetailxls1(control,format,box) {  
    // pass to a client variable, I am not longer using this 4/9/2013          
    // ColdFusion.Ajax.submitForm('form_'+box,'PostViewDetailSelect.cfm?box='+box)	
	w = #CLIENT.width# - 80;
    h = #CLIENT.height# - 110;	
	ptoken.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?ts="+new Date().getTime()+"&box="+box+"&data=1&controlid="+control+"&mission=#URL.Mission#&Mandate=#URL.Mandate#&format="+format, "facttable");
}		

function submenu(category,menusel,len) {
			
	 menucnt=1 	
	 len++ 	 	
	
     while (menucnt != (len)) {
			
		  if (menucnt == menusel) {
		    document.getElementById(category+menucnt).className = "highlight"
		  } else {
		    document.getElementById(category+menucnt).className = "regular"
		  }		  
		  menucnt++	  	 
	 }
	
}

function workflowdrill(key,context) {
		  		
	    se = document.getElementById(key)
		ex = document.getElementById("exp"+key)			
		co = document.getElementById("col"+key)
		
			
		if (se.className == "hide") {					
		   se.className = "regular" 			 
		   co.className = "regular"			  
		   ex.className = "hide"	
		   
		   if (context == "position") {		       
			   ptoken.navigate('#SESSION.root#/Staffing/Reporting/Postview/Staffing/PostViewDetailWorkflow.cfm?ajaxid='+key+'?ajaxid='+key,key)		   
		   }
		  
		} else {  se.className = "hide"
		          ex.className = "regular"
		   	      co.className = "hide" 
	    } 		
	}		

function showorg(org,start,end,space) {		
       
	  document.getElementById(org+"Expand").className   = "hide";
  	  document.getElementById(org+"Min").className      = "regular";
	 
	  ge = document.getElementById('detail_'+org).innerHTML
	  
	  if (ge == "") {
	     Prosis.busy('yes')
	     fil = document.getElementById("filterid").value
	     url = "PostViewOrganizationDrill.cfm?tree=#URL.Tree#&filterid="+fil+
			      "&col=#Resource.RecordCount+2#&cell=#cell#&tblc=#tblc#&HStart="+start+"&HEnd="+end+"&cellspace="+space;	
	     document.getElementById("detail_"+org).className = "regular";			  		  	  	  
	     ptoken.navigate(url,'detail_'+org)		  	  	
	 } else {
	     document.getElementById("detail_"+org).className = "regular";		
	 }
	 
	 }
	
function hideorg(org) {
	  document.getElementById(org+"Min").className    = "hide";
	  document.getElementById(org+"Expand").className = "regular";	
	  document.getElementById("detail_"+org).className = "hide";
}	
							   
function searchnew(tpe) {
	  se = document.getElementById(tpe)
	  se.click()
}

function gjp(fun,grd) {
     w = #CLIENT.width# - 85;
     h = #CLIENT.height# - 160;
     ptoken.open("#SESSION.root#/Roster/Maintenance/FunctionalTitles/FunctionGradePrint.cfm?ID=" + fun + "&ID1=" + grd, "_blank", "left=30, top=30, width=" + w + ", height= " + h + ",toolbar=no, status=yes, scrollbars=no, resizable=yes"); 
}
	  
function details(tree,mandate,act,box,sel) {
 	
	icM  = document.getElementById("d"+box+"Min")
	icE  = document.getElementById("d"+box+"Exp")
	dcM  = document.getElementById("docExpT")
	dcE  = document.getElementById("docMinT")
	se   = document.getElementById("d"+box);
	frm  = document.getElementById("di"+box);	 		 
	if (act=="show") {	 	
	     	 icM.className = "regular";
			 dcM.className = "hide";
		     icE.className = "hide";
			 dcE.className = "regular";
	    	 se.className  = "regular";
		} else {	 
	   	 icM.className = "hide";
		 dcM.className = "regular";
	     icE.className = "regular";
		 dcE.className = "hide";
		 se.className  = "hide"
	 }
		 		
  }

function reloadview(mde,snap,trval,mandate) {
    
	if (snap == "today") {
	   ptoken.open("#SESSION.root#/Staffing/Reporting/PostView/Staffing/PostViewLoop.cfm?systemfunctionid=#url.systemfunctionid#&acc=#SESSION.acc#&Mission=#URL.Mission#&Mandate="+mandate+"&tree=" + trval + "&Unit=" + mde + "<cfif #URL.FilterId# neq "{00000000-0000-0000-0000-000000000000}">&filterid=#URL.FilterId#</cfif>","_self")
	} else {
	   ptoken.open("#SESSION.root#/Staffing/Reporting/PostView/Staffing/PostViewLoop.cfm?systemfunctionid=#url.systemfunctionid#&Mission=#URL.Mission#&Mandate="+mandate+"&tree=" + trval + "&Unit=" + mde + "&Snap=" + snap + "<cfif #URL.FilterId# neq "{00000000-0000-0000-0000-000000000000}">&filterid=#URL.FilterId#</cfif>","_self")
    	 }   
	}
	
function maintain() {
		   ptoken.open("#SESSION.root#/Staffing/Application/Position/MandateView/InitView.cfm?mission=#URL.Mission#&mandate=#URL.Mandate#","staffingmaintain")
		}
		
function maintainQuick(org) {		        
		w = #CLIENT.width# - 85;
		h = #CLIENT.height# - 110;
		ptoken.open("#SESSION.root#/Staffing/Application/Position/MandateView/MandateViewGeneral.cfm?header=1&ID=ORG&ID1=" + org + "&ID2=#URL.Mission#&ID3=#URL.Mandate#")
	}  
		
function maintainQuickLoan(mis,man,org) {
		        
	    w = #CLIENT.width# - 85;
	    h = #CLIENT.height# - 110;
		ptoken.open("#SESSION.root#/Staffing/Application/Position/MandateView/MandateViewGeneral.cfm?ID=ORG&ID1=" + org + "&ID2="+mis+"&ID3="+man, "_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=no")
	}  	

function more(bx,cls) {

	se = document.getElementById(bx)	
	
    if (se.className == "regular") {
	      act = "hide"
    } else {
	      act = "show"
  	}	
    icM   = document.getElementById(bx+"Min")	
    icE   = document.getElementById(bx+"Exp")				
	
	if (act == "show") {	    
		se.className  = "regular";	   
		icM.className = "regular";		
		icE.className = "hide";
	} else {	  
	    se.className   = "hide";		
		icM.className  = "hide";		
		icE.className  = "regular";
	}		
}

function reloadForm(sort) {
	ptoken.location("PostViewDetail.cfm?#link#&sort="+sort)
}
  
function ShowCandidate(App) {
      w = #CLIENT.width# - 60;
      h = #CLIENT.height# - 120;
	  ptoken.open(root + "/Roster/Candidate/Details/PHPView.cfm?ID=" + App + "&mode=Manual", "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function AddAssignment(postno,box) {
      ptoken.open("#SESSION.root#/Staffing/Application/Assignment/AssignmentEntry.cfm?box="+box+"&Mission=#URL.Mission#&ID=" + postno + "&caller=Listing", "_Assng", "width=930, height=920, status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function AddReview(postno,box) {     
	ptoken.open('#SESSION.root#/Staffing/Application/Assignment/Review/AssignmentReview.cfm?box='+box+'&Mission=#URL.Mission#&ID1=' + postno + '&Caller=Listing',postno) 	
}

// event scripts taken from EventsScripts.cfm

	function eventaddperson(personno,positionno) {     				
		ProsisUI.createWindow('evdialog', 'Event Dialog', '',{x:200,y:200,height:document.body.clientHeight-100,width:document.body.clientWidth-200,modal:true,resizable:false,center:true})    					
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventForm.cfm?scope=matrix&portal=0&personNo='+personno+'&positionno='+positionno,'evdialog')		 	
	}

	function checkevent() {				
		rid = document.getElementById('eventid');
		mis = document.getElementById('mission');	
		per = document.getElementById('personno');			
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/getEvent.cfm?personno='+per.value+'&eventid='+rid.value+'&mission='+mis.value,'dEvent')
	  }    

	function checkreason() {
		tc = document.getElementById('triggercode');
		ev = document.getElementById('eventcode');
		rid = document.getElementById('eventid');		
	    ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/getReason.cfm?triggercode='+tc.value+'&eventcode='+ev.value+'&eventid='+rid.value,'dReason');
		ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/getCondition.cfm?triggercode='+tc.value+'&eventcode='+ev.value+'&eventid='+rid.value,'dCondition');    
    }
	
	function eventsubmit(id) {
	
		tc  = document.getElementById('triggercode');
		ev  = document.getElementById('eventcode');
		de  = document.getElementById('DateEvent');
		ded = document.getElementById('DateEventDue');	
		eff = document.getElementById('ActionDateEffective');
		
		doc = document.getElementById('documentno');				
		pos = document.getElementById('positionNo');
		req = document.getElementById('requisitionNo');
		exp = document.getElementById('ActionDateExpiration');	
				
		dbx = document.getElementById('documentbox');
		pbx = document.getElementById('positionbox');	
		rbx = document.getElementById('requisitionbox');
		ebx = document.getElementById('expirybox');					

		if (pos.value=='' && pbx.className!= 'hide') {
			Ext.Msg.alert('Position', 'Please specify a position.');			
		} else if (tc.value  == '')   {
			Ext.Msg.alert('Trigger', 'Please specify an event trigger.');
		} else if (doc.value  == '' && dbx.className!= 'hide')   {
			Ext.Msg.alert('Document', 'Please specify a Recruitment Document.');	
		} else if (req.value=='' && rbx.className!='hide'){
			Ext.Msg.alert('Requisition', 'Please specify Requisition No.');
		} else if (ev.value  == '')   {
			Ext.Msg.alert('Event', 'Please specify an event action.');		
		} else if (de.value  == '')   {
			Ext.Msg.alert('Effective date', 'Please specify Event Date.');
		} else if (ded.value == '')  {
			Ext.Msg.alert('Expiration date', 'Please specify Due Date.');
		} else if (eff.value == '')  {
			Ext.Msg.alert('Effective date', 'Please specify Action effective Date.');	
		} else if (exp.value == '' && ebx.className!= 'hide') {
			Ext.Msg.alert('Effective date', 'Please specify Action effective Date.');		
		} 
		else{
    		ptoken.navigate('#SESSION.root#/Staffing/Application/employee/events/EventFormSubmit.cfm?scope=matrix&eventid='+id,'process','','','POST','eventform')		
		}
	}

function AddVacancy(postno,box) {
	ProsisUI.createWindow('mydialog', 'Record Recruitment Track', '',{x:100,y:100,height:620,width:640,modal:true,center:true});	
	ptoken.navigate('#SESSION.root#/Vactrack/Application/Document/DocumentEntryPosition.cfm?box='+box+'&Mission=#URL.Mission#&ID1=' + postno + '&Caller=Listing','mydialog')	
}

function AddPAS(assno,box) {
	ProsisUI.createWindow('mypasdialog', 'PAS', '',{x:100,y:100,height:620,width:640,modal:true,center:true});	
	ptoken.navigate("#SESSION.root#/ProgramREM/Portal/Workplan/PAS/PASCreate.cfm?ts="+new Date().getTime()+"&box="+box+"&Mission=#URL.Mission#&AssignmentNo=" + assno,'mypasdialog');	
}

function memoshow(memo,act) {
    icM  = document.getElementById(memo+"Min")
    icE  = document.getElementById(memo+"Exp")
	se   = document.getElementById(memo)
	
	if (act == "show") {
		se.className  = "regular";
		icM.className = "regular";
	    icE.className = "hide";
		
	} else {
		se.className  = "hide";
	    icM.className = "hide";
	    icE.className = "regular";
	}
}

function memo(pos,box) {

	text = document.getElementById('remarks'+box.substring(0,8)).value;
	text = encodeURIComponent(text);
	url = "PostViewMemoUpdate.cfm?box="+box+"&positionno=" + pos+"&remarks="+text;	
	ptoken.navigate(url,'memo'+box)	
	document.getElementById("memo"+box+"hdr").className = "regular";	
	
}

<!--- search --->

function search(tpe,date) {
    
	fld  = document.getElementById("fieldsearch");	
	fil  = document.getElementById("filterid").value
	if (fld.value == "") {
	   alert("Please enter your criteria")
	} else {
	opt  = document.getElementById("option");
	if (opt.checked)
		{op = "1"}
	else
		{op ="0"}
	srt  = document.getElementById("sorting");
	frm  = document.getElementById("dsearch");
	frm.className = "regular" 		
	Prosis.busy('yes')			
	url = "PostViewDetail.cfm?tree=#URL.Tree#&filterid="+fil+"&search=1&fld=" + fld.value + "&opt=" + op + "&sorting=" + srt.value + "&tpe=" + tpe + "&mission=#URL.Mission#&mandate=#URL.Mandate#&date="+date		
	ptoken.navigate(url,'isearch');	
	}
	
 }	
 
 function hidedetail(org) {
	 document.getElementById(org).className = "hide";
 }
			
function detaillisting(org,act,mode,filter,level,line,cell,sort,date,omis,oman,space) {
 		
	_cf_loadingtexthtml='';	
	icM  = document.getElementById("d"+org+"Min")
    icE  = document.getElementById("d"+org+"Exp")
	se   = document.getElementById("d"+org);
	frm  = document.getElementById("i"+org);
	fil  = document.getElementById("filterid").value	
	se.className = "hide";
	
	// temp code not effected yet
	if (omis != undefined) {
	    mis = omis
		man = oman 
	} else {
	    mis = "#URL.Mission#"
		man = "#URL.Mandate#"	
	}	
		
	url = "PostViewDetail.cfm?tree=#URL.Tree#&filterid="+fil+"&Org=" + org + "&Mission="+mis+"&Mandate="+man+"&ID=0&ID1=" + org + "&Mode=" + mode + "&Filter=" + filter + "&Level=" + level + "&Line=" + line + "&unit=#URL.Unit#&sort="+sort+"&date="+date+"&cellspace="+space
	 		 
	if (act=="show") {		
		  Prosis.busy('yes')	   
		  ptoken.navigate(url,'i'+org);
		  icM.className = "regular";
		  icE.className = "hide";
		  se.className  = "regular";				    	
	 	} else {	
	      icM.className = "hide";
		  icE.className = "regular";	
		  se.className  = "hide";	 
	 }
		 		
  }  
		
function shownode(itm) {
     
	 icM  = document.getElementById(itm+"Min")
	 icM.className = "regular";
	 icE  = document.getElementById(itm+"Exp")
	 icE.className = "hide";
	 var loop=0;
	 while (loop<99) {	 	 
	     loop=loop+1		 
		 if (loop<10) { sel = ".0"+loop } else { sel = "."+loop }
		  $("[class='"+itm+sel+" hide']").show();
	 }
  }
  
function hidenode(itm,len,lv) {
     
     icM  = document.getElementById(itm+"Min")
	 icE  = document.getElementById(itm+"Exp")
	 if (icM) {
     	 icM.className = "hide";
		 icE.className = "regular";
	 }		 	  
	 var loop=0;	 
	 while (loop<100){	 	 
	     loop=loop+1		 
		 if (loop<10) { sel = ".0"+loop } else { sel = "."+loop }			
		  $("[class='"+itm+sel+" hide']").hide();		  
	 } 				
  }  
    
</script> 

</cfoutput>   	