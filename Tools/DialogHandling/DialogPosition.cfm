
<cfoutput>

<cfparam name="client.width"  default="800">
<cfparam name="client.height" default="1000">

<cfset root = "#SESSION.root#">

<script>

var root = "#root#";
var lookupEmployee = "_blank";

w = 0
h = 0

if (screen) {
	w = #CLIENT.width# - 60
	h = #CLIENT.height# - 110
}

function maintainStaffing(org,mis,man) {		        
	w = #CLIENT.width# - 85;
	h = #CLIENT.height# - 110;
	ptoken.open("#SESSION.root#/Staffing/Application/Position/MandateView/MandateViewGeneral.cfm?ID=ORG&ID1="+org+"&ID2="+mis+"&ID3="+man,"maintain"+org)
}  

function AssignmentConflict(call,caller,st,source,recordid,appno,posno,box) {       
        w = #CLIENT.width# - 100;
        h = #CLIENT.height# - 170;
		if (source == "vac") {
	    ptoken.open(root + "/Staffing/Application/Assignment/AssignmentConflict.cfm?box="+box+"&id="+posno+"&call=" + call + "&caller=" + caller + "&status=" + st + "&source=" + source + "&recordid=" + recordid + "&applicantno=" + appno + "&ts="+new Date().getTime(), "main", "left=35, top=35, width=" + w + ", height= " + h + ", toolbar=yes, scrollbars=yes, resizable=no");
		} else {
		ptoken.open(root + "/Staffing/Application/Assignment/AssignmentConflict.cfm?box="+box+"&id="+posno+"&call=" + call + "&caller=" + caller + "&status=" + st + "&source=" + source + "&recordid=" + recordid + "&applicantno=" + appno + "&ts="+new Date().getTime(), "_top", "left=35, top=35, width=" + w + ", height= " + h + ", toolbar=yes, scrollbars=yes, resizable=no");		
		}
}

function ViewParentPosition(mission,mandate,posno) {
	    ptoken.location(root + "/Staffing/Application/Position/PositionParent/ParentHeader.cfm?ID=" + mission + "&ID1=" + mandate + "&ID2=" + posno)
	}		

function ViewParentPositionDialog(mission,mandate,posno,mode) {
	    ptoken.open(root + "/Staffing/Application/Position/PositionParent/ParentHeader.cfm?mode="+mode+"&ID=" + mission + "&ID1=" + mandate + "&ID2=" + posno, "PositionParent", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
	}			

function EditParentPosition(mission,mandate,posno) {
    w = 900;
    h = 800;			
	ptoken.open(root + "/Staffing/Application/Position/PositionParent/PositionParentInitialView.cfm?ID=" + mission + '&ID1=' + mandate + '&ID2=' + posno,"editparentposition","left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=no")		
  
	}

function AddPosition(mission,mandate,org,fun,tpe,grd,loc,adm,pos) {
  var left = (screen.width/2)-(800/2);
  var top = (screen.height/2)-(880/2);
  ptoken.open(root + "/Staffing/Application/Position/Position/PositionEntry.cfm?ID=" + mission + "&ID1=" + mandate + "&ID2=" + org + "&ID3=" + fun + "&ID4=" + tpe + "&ID5=" + grd + "&ID6=" + loc + "&ID7=" + adm + "&ID8=" + pos + "&ts="+new Date().getTime(),"addposition","left="+left+", top="+top+", width=940, height=820, status=yes, toolbar=no, scrollbars=no, resizable=yes, unadorned:yes;");
}

function EditPosition(mission,mandate,posno,box,refresh) {
	w = #CLIENT.width# - 100;
    h = #CLIENT.height# - 110;			
	ptoken.open(root + "/Staffing/Application/Position/PositionParent/PositionView.cfm?box="+box+"&ID=" + mission + "&ID1=" + mandate + "&ID2=" + posno,posno)					
}

function workscheduleaction(act,wsch,posno,seldate,memo) {
	if (confirm("Do you want to "+memo+" ?")) {	
		ColdFusion.navigate('#session.root#/Staffing/Application/WorkSchedule/Position/WorkScheduleViewDetail.cfm?action='+act+'&workschedule='+wsch+'&positionno='+posno+'&selecteddate='+seldate,'calendartarget')
	}	
}

function positionchain(ind) {
     ptoken.open("#SESSION.root#/Staffing/Application/Position/PositionChain/getChain.cfm?indexno=" + ind, "Chain"+ind);
}

function replaceWorkSchedule(ws,pos,posparent) {
	var width = 800;
	var height = 500;	   
	
	ColdFusion.Window.create('mydialog', 'Supply', '',{x:30,y:30,height:height,width:width,modal:true,center:true});    
	ColdFusion.Window.show('mydialog'); 				
	ColdFusion.navigate(root + "/Staffing/Application/WorkSchedule/Position/ReplaceWorkSchedule.cfm?workSchedule=" + ws + "&positionNo=" + pos + "&positionParentId=" + posparent + "&ts="+new Date().getTime(),'mydialog'); 
}

function EditFunction(funno) {
    	w = #CLIENT.width# - 60;
	    h = #CLIENT.height# - 130;
		ptoken.open(root + "/Roster/Maintenance/FunctionalTitles/FunctionView/FunctionView.cfm?ID=" + funno, "Position", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=yes, scrollbars=no, resizable=yes");
}

function ViewPosition(posno) {
    	w = #CLIENT.width# - 60;
	    h = #CLIENT.height# - 130;
		ptoken.open(root + "/Staffing/Application/Position/PositionParent/PositionView.cfm?ID2=" + posno, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function EditPost(posno) {
    	w = #CLIENT.width# - 60;
	    h = #CLIENT.height# - 130;
		ptoken.open(root + "/Staffing/Application/Position/Position/PositionView.cfm?ID=" + posno, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function EditPerson(personno,index,template) {
        w = #CLIENT.width# - 20;
        h = #CLIENT.height# - 120;				
		ptoken.open(root + "/Staffing/Application/Employee/PersonView.cfm?ID=" + personno +"&ID1=" + index + "&template=" + template,"staff_"+personno);
}

function AddAssignment(postno,box) {
		ptoken.open("#SESSION.root#/Staffing/Application/Assignment/AssignmentEntry.cfm?box="+box+"&ID=" + postno + "&Caller=Listing", "_blank", "width=980, height=820, status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function EditAssignment(per,ass,pos,box) {
        w = #CLIENT.width# - 120;
        h = #CLIENT.height# - 160;
		ptoken.open(root + "/Staffing/Application/Assignment/AssignmentEdit.cfm?box="+box+"&ID=" + per + "&ID1=" + ass + "&Template=Assignment", "assignment"+pos);
}

function History(Ind) {
        w = 800;
        h = 640;
		ptoken.open(root + "/Attendance/Application/Timesheet/CalMonth.cfm?ID=" + Ind, "Employee", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=yes, scrollbars=no, resizable=yes");
}

function selectposition(source, mission, mandateno, applicantno, personno, recordid, documentno) {
        w = #CLIENT.width# - 120;
        h = #CLIENT.height# - 200;		
	    ptoken.open(root + "/Staffing/Application/Position/Lookup/PositionView.cfm?Source=" + source + "&mission=" + mission + "&mandateno=" + mandateno + "&applicantno=" + applicantno + "&personno=" + personno + "&recordid=" + recordid + "&documentno=" + documentno, "PositionLookup", "width=" + w + ", height=" + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");
}

function selectfunction(formname, fldfunctionno, fldfunctiondescription, owner,param1,param2) {
  
	try { ColdFusion.Window.destroy('myfunction',true) } catch(e) {}
	ColdFusion.Window.create('myfunction', 'Functional Titles', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:false,resizable:false,center:true})    					
	ptoken.navigate(root + "/Staffing/Application/Function/Lookup/FunctionView.cfm?FormName=" + formname + "&fldfunctionno=" + fldfunctionno + "&fldfunctiondescription=" + fldfunctiondescription + "&owner=" + owner + "&param1=" + param1 + "&param2=" + param2,'myfunction') 	
	
} 
  
function selectscale(personno,contracttype,contractid) {
	 ProsisUI.createWindow('mydialog', 'Salary scale', '',{x:100,y:100,height:document.body.clientHeight-100,width:document.body.clientWidth-100,modal:true,center:true})    	 		 	
	 ptoken.navigate(root + '/Payroll/Application/SalaryScale/SalaryScaleView.cfm?personno='+personno+'&contracttype='+contracttype+'&contractid='+contractid,'mydialog') 			
}

function scaleapply(org) {    
    ptoken.navigate('#SESSION.root#/Staffing/Application/Assignment/setUnit.cfm?orgunit='+org,'unitprocess')
}

function selectperson(formname,fldpersonno,fldindexno,fldlastname,fldfirstname,fldfull,unit,mis,flddob,fldnationality) {
   
	ptoken.open(root + "/Staffing/Application/Employee/Lookup/LookupSearch.cfm?FormName=" + formname + "&fldpersonno=" + fldpersonno + "&fldindexno=" + fldindexno + "&fldlastname=" + fldlastname + "&fldfirstname=" + fldfirstname + "&fldfull=" + fldfull + "&flddob=" + flddob + "&fldnationality=" + fldnationality + "&orgunit=" + unit + "&mission=" + mis, lookupEmployee, "width=800, height=660, status=yes, toolbar=no, scrollbars=no, resizable=yes");	
    if (lookupEmployee == "_blank") {
   		lookupEmployee = "lookupEmployee"
	} 	
}		

function lookupperson(mis,fnselected) {   
	ptoken.open(root + "/Staffing/Application/Employee/Lookup/LookupSearch.cfm?showadd=0&fnselected=" + fnselected + "&mission=" + mis, lookupEmployee, "width=800, height=660, status=yes, toolbar=no, scrollbars=no, resizable=yes");	
	if (lookupEmployee == "_blank") {
   		lookupEmployee = "lookupEmployee"
	}
} 

function selectentitlement(formname, fldentitlement) {
	ptoken.open(root + "/Payroll/Application/Entitlement/EntitlementSearch.cfm?FormName=" + formname + "&fldentitlement= " + fldentitlement, "IndexWindow", "width=400, height=550, toolbar=no, scrollbars=yes, resizable=yes");
}

function showdocument(vacno,candlist,actionid) {
	ptoken.open(root + "/Vactrack/Application/Document/DocumentEdit.cfm?ID=" + vacno + "&IDCandlist=" + candlist + "&ActionId=" + actionid, "track"+vacno);
}

function gjp() {
    fun = document.getElementById("functionno")
	grd = document.getElementById("postgrade")
    ptoken.open("#SESSION.root#/Roster/Maintenance/FunctionalTitles/FunctionGradePrint.cfm?ID=" + fun.value + "&ID1=" + grd.value, "_blank", "toolbar=no, status=yes, scrollbars=no, resizable=yes"); 
}



</script>
</cfoutput>