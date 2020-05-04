
<cfoutput>

<cfset root = "#SESSION.root#">

<cf_calendarscript>
<cfajaximport tags="cfwindow">

<script>

 
var root = "#root#";
var myvar1 = ""
var myvar2 = ""
var myvar3 = ""
var myvar4 = ""
var myvar5 = ""
	
function personviewtoggle(box) {
    
     if (box != 'undefined') {
	    sel = box		
	 } else {	  
	   sel = 'person'
	 }
			
	  se = document.getElementById(sel+'info')
	  sh = document.getElementById(sel+'short')
	  im = document.getElementById(sel+'col')
	  ex = document.getElementById(sel+'exp')
	  if (se.className == "hide") {  
	     ptoken.navigate(root + "/Staffing/Application/Employee/setStaffToggle.cfm?show=open","toggleprocess")
	     se.className = "regular"  
		 sh.className = "hide"
		 im.className = "regular"
		 ex.className = "hide"
	  } else {
	      ptoken.navigate(root + "/Staffing/Application/Employee/setStaffToggle.cfm?show=close","toggleprocess")
	      se.className = "hide" 
		  im.className = "hide"
		  sh.className = "labellarge"
		  ex.className = "regular" 
	  }
 }

function AddPerson() {
	 ptoken.open(root + "/Staffing/Application/Employee/PersonEntry.cfm", "AddPerson", "width=450, height=450, toolbar=no, scrollbars=no, resizable=no");
}

function lookuppersonadd(box,link) {
    ColdFusion.navigate('#session.root#/Staffing/Application/Employee/PersonEntryForm.cfm?link='+link+'&box='+box+'&mode=lookup','searchresult'+box)	
}		
				
function lookuppersonvalidate(mode,box,link) {   
	document.formperson.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
           	ColdFusion.navigate('#session.root#/Staffing/Application/Employee/PersonEntrySubmit.cfm?link='+link+'&box='+box+'&mode=lookup','personresult','','','POST','formperson')
    }   
}

// part of modal dialog amendment

function personedit(id) {
	parent.ProsisUI.createWindow('personedit', 'Amend Staff profile information', '',{x:100,y:100,height:parent.document.body.clientHeight-75,width:parent.document.body.clientWidth-75,modal:true,center:true,resizable:false})    
	// parent.ColdFusion.Window.show('personedit')					
	parent.ColdFusion.navigate(root + '/Staffing/Application/Employee/PersonEditView.cfm?ID=' + id,'personedit') 
}

// this is the call back
function personrefresh(id) {
    history.go()
	se = parent.document.getElementById("banner")	
	if (se) {
		parent.ColdFusion.navigate('PersonViewBanner.cfm?id='+id,'banner') 
 	} 
}

function pasdialog(pasid) {
  	w = #CLIENT.width# - 60;
    h = #CLIENT.height# - 120;
     ptoken.open(root + "/ProgramReM/Portal/Workplan/PAS/PASView.cfm?scope=staffing&ContractId="+pasid,"pas"+pasid);
 }
 
 function padialog(docno) {
  	w = #CLIENT.width# - 60;
    h = #CLIENT.height# - 120;
     ptoken.open(root + "/Staffing/Application/Employee/PersonAction/ActionDialog.cfm?drillid="+docno,"pa"+docno);
 }
 
 
 function pasedit(pasid) {
  	w = 850;
    h = 800;
    ptoken.open(root + "/Staffing/Application/Employee/PAS/EmployeePASEdit.cfm?scope=staffing&ContractId="+pasid,"pas"+pasid, "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
 }

function leaveopen(per,id,scope,refer) {
    ptoken.open(root + '/Staffing/Application/Employee/Leave/EmployeeLeaveEdit.cfm?scope='+scope+'&refer='+refer+'&ID='+per+'&ID1=' + id,id);
}
	
function eventdialog(key) {
   	ptoken.open(root + "/Staffing/Application/Employee/Events/EventDialog.cfm?portal=0&id="+key,"_blank")
}	

function eventedit(key) {
      Prosis.busy('yes');
      _cf_loadingtexthtml='';		
	  ProsisUI.createWindow('evdialog', 'Event Dialog', '',{x:200,y:200,height:document.body.clientHeight-100,width:document.body.clientWidth-200,modal:true,resizable:false,center:true})    					
      ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventForm.cfm?portal=0&id='+key,'evdialog')
	}
	
function EditPerson(personno,sid,template) {
    w = #CLIENT.width# - 20;
    h = #CLIENT.height# - 120;	
	ptoken.open(root + "/Staffing/Application/Employee/PersonView.cfm?ID=" + personno + "&template="+template, "staff_"+personno);
}

function EditPersonX(Ind,index,template) {
    w = #CLIENT.width# - 60;
    h = #CLIENT.height# - 120;
	ptoken.open(root + "/Staffing/Application/Employee/PersonView.cfm?ID=" + Ind + "&ID1=" + index + "&Template=" + template, "Employee", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function workschedule(id) {
    w = #CLIENT.width# - 60;
    h = #CLIENT.height# - 120;
	ptoken.open(root + "/Staffing/Application/WorkSchedule/Planning/PlanningView.cfm?header=1&workschedule="+id, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

// address script
		
function personaddress(persno,addressid,webapp) {   
    w = #CLIENT.width# - 60;
    h = #CLIENT.height# - 120;
	ptoken.open(root + "/Staffing/Application/Employee/Address/EmployeeAddress.cfm?header=1&mode=edit&webapp="+webapp+"&header=0&ID=" + persno + "&ID1=" + addressid, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function personaddressentry(persno,webapp) {
    ptoken.navigate(root + '/Staffing/Application/Employee/Address/AddressEntry.cfm?webapp='+webapp+'&header=0&ID=' + persno,'addressdetail');
}

function personrequest(persno,webapp) {
    ptoken.navigate(root + '/Staffing/Portal/PersonRequest/RequestEntry.cfm?webapp='+webapp+'&header=0&ID=' + persno,'requestdetail');
}


function requestedit(persno,requestid,webapp) {
    ptoken.navigate(root + '/Staffing/Portal/PersonRequest/RequestEntry.cfm?webapp='+webapp+'&header=0&ID=' + persno + '&ID1='+requestid,'requestdetail');
}


function personaddressentryvalidate(webapp) {
    <cfif CLIENT.googlemap eq "1">getmap()</cfif>
	document.personaddressform.onsubmit() 
	if( _CF_error_messages.length == 0 ) {            
		ptoken.navigate(root + '/Staffing/Application/Employee/Address/AddressEntrySubmit.cfm?webapp='+webapp,'addressprocess','','','POST','personaddressform')
	 }   
}	 
		
function personaddressedit(persno,addressid,webapp) {   
	ptoken.navigate(root + '/Staffing/Application/Employee/Address/AddressEdit.cfm?mode=edit&webapp='+webapp+'&header=0&ID=' + persno + '&ID1=' + addressid,'addressdetail')		
}

function personaddresseditvalidate(webapp,action) {
	<cfif CLIENT.googlemap eq "1">getmap()</cfif>
	document.personaddressform.onsubmit() 	
	if( _CF_error_messages.length == 0 ) {    	    	  
	    Prosis.busy('yes')
		ptoken.navigate(root + '/Staffing/Application/Employee/Address/AddressEditSubmit.cfm?action=' + action + '&webapp='+webapp,'addressprocess','','','POST','personaddressform')
	 }   
}	 

// end of address script 

function ViewSlip(Ind,index,date,component) {
   	    w = #CLIENT.width# - 160;
	    h = #CLIENT.height# - 180;
	    ptoken.open(root + "/Payroll/Application/Payroll/EmployeePayroll.cfm?ID=" + Ind + "&ID1=" + index + "&ID2=" + date + "&ID3=" + component, "Employee", "left=50, top=50, width=" + w + ", height= " + h + ", status=no, toolbar=no, scrollbars=no, resizable=yes");
}

function SearchCandidate(formname,fieldname) {
	    ptoken.open(root + "/Roster/Search/CandSearch.cfm?FormName= " + formname + "&FieldName= " + fieldname, "SearchCandidate", "width=600, height=550, toolbar=no, scrollbars=yes, resizable=yes");
}

function ShowCandidate(app) {       
        w = #CLIENT.width# - 60;
        h = #CLIENT.height# - 120;
		ptoken.open(root + "/Roster/Candidate/Details/PHPView.cfm?ID=" + app + "&mode=Manual", "box"+app);
}

function addCandidate(edition,source) {
        w = 900;
        h = #CLIENT.height# - 120;
		ptoken.open(root + "/Roster/Candidate/Details/Applicant/ApplicantEntry.cfm?submissionedition="+edition+"&source="+source+"&mode=Manual", "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function showdocumentcandidate(vacno,persno,status) {
	  
	   if (status == "Short-listed") {
	        w = screen.width - 80;
	        h = screen.height - 130;
		    ptoken.open("#SESSION.root#/Vactrack/Application/Document/DocumentEdit.cfm?ID=" + vacno, vacno);
	   } else {
	        w = screen.width - 80;
	        h = screen.height - 130;
		    ptoken.open("#SESSION.root#/Vactrack/Application/Candidate/CandidateEdit.cfm?ID=" + vacno + "&ID1=" + persno, persno);
	  }		
	  }  

function selectfunction(formname,fldfunctionno,fldfunctiondescription,owner,param1,param2) {

     try { ProsisUI.closeWindow('myfunction',true) } catch(e) {}
	 ProsisUI.createWindow('myfunction', 'Functional Titles', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,resizable:false,center:true})    					
	 ptoken.navigate(root + "/Staffing/Application/Function/Lookup/FunctionView.cfm?FormName=" + formname + "&fldfunctionno=" + fldfunctionno + "&fldfunctiondescription=" + fldfunctiondescription + "&owner=" + owner + "&param1=" + param1 + "&param2=" + param2,'myfunction') 	
	
}
 
function EditApplicant(id) {

	ProsisUI.createWindow('mydialog', 'Edit', '',{x:100,y:100,height:document.body.clientHeight-90,width:650,modal:true,center:true})  				
	ptoken.navigate(root + '/Roster/Candidate/Details/Applicant/ApplicantView.cfm?id=' + id,'mydialog') 		
      
}

function refreshheader(id)  {
        _cf_loadingtexthtml='';	
	    ptoken.navigate('#SESSION.root#/roster/candidate/details/applicant/ApplicantDetail.cfm?id='+id,'boxappdetail')		
}

function showbackground(pers,src) {
   		w = #CLIENT.width# - 100;
	    h = #CLIENT.height# - 150;
		ptoken.open(root +  "/Roster/RosterGeneric/Background/ApplicantBackground.cfm?ID=" + pers + "&ID1=" + src, "DialogWindow", "left=50, top=50, width=" + w + ", height= " + h + ", scrollbars=yes, resizable=yes");
}

function ShowPerson(personno,template) {
        w = #CLIENT.width# - 60;
        h = #CLIENT.height# - 160;
		ptoken.open(root + "/Staffing/Application/Employee/PersonView.cfm?ID=" + personno + "&template="+template, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function va(fun,app) {
		ptoken.open(root + "/Vactrack/Application/Announcement/Announcement.cfm?ID="+fun+"&applicantNo="+app, "_blank", "width=860, height=770, status=yes,toolbar=yes, scrollbars=yes, resizable=yes");
}

function ShowUser(account,content) {
        w = #CLIENT.width# - 60;
        h = #CLIENT.height# - 100;
	//	ptoken.open(root + "/System/Access/User/UserDetail.cfm?Content="+content+"&ID=" + account + "&ID1=" + h + "&ID2=" + w, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");		
		ptoken.open(root + "/System/Access/User/UserDetail.cfm?Content="+content+"&ID=" + account + "&ID1=" + h + "&ID2=" + w, account);		
	
	}

function ShowUserRole(Account) {
        w = #CLIENT.width# - 250;
        h = #CLIENT.height# - 140;
	    ptoken.open(root + "/System/Organization/Access/UserAccessListing.cfm?ID=" + Account + "&ID1=" + h + "&ID2=" + w, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function selectzip(fldzip,fldcity,fldcountry,mode) {
					    
		try {					
		  	eCountry = document.getElementById(fldcountry);
			sCountry = eCountry.value;
		    } catch (se) {
			sCountry = '';
	     }	
		 
		 // pass field name to fee back to
		 myvar1 = fldzip
		 myvar2 = fldcity
		 myvar3 = fldcountry
				 
		 ProsisUI.createWindow('myzip', 'ZIP', '',{x:100,y:100,height:560,width:560,modal:true,center:true})    		 				
		 ColdFusion.navigate(root + '/Tools/Input/ZIP/ZIPView.cfm?country='+sCountry,'myzip') 						 
}

function zipapply(zip,city,country) {
		
		ColdFusion.navigate('#SESSION.root#/Tools/Input/ZIP/ZIPFind.cfm?fld='+myvar1+'&code='+zip,'zipfind_'+myvar1)	
  		
		// populate screen values
				
		try {
			se = document.getElementById(myvar1);
			se.value = zip;	
		  	se = document.getElementById(myvar2);
			se.value = city;	
	      	se = document.getElementById(myvar3);
		  	se.value = country;
		  	 			
			} catch(se) {} 			
		     		
		ProsisUI.closeWindow('myzip',true)			  
											
		<!--- put the field values here and refresh the map --->
		<cfif client.GoogleMap eq "1">mapaddress()</cfif>		
		
}		 
 
</script>


<cfinclude template="DialogMail.cfm">

</cfoutput>

