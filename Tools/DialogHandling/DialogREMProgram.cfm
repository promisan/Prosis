
<cfoutput>

<cfajaximport tags="cfwindow">

<script language="JavaScript1.1">

var root = "#SESSION.root#";

function selectprogramme(mission,period,orgunitparent,orgunit,programcode,applyscript,scope) {	
	
	// 15/2/2015 newly added to replace modal dialog 	
	ColdFusion.Window.create('programwindow', 'Programme', '',{x:100,y:100,height:document.body.clientHeight-80,width:750,modal:false,center:true})    
    ColdFusion.Window.show('programwindow')				
    ptoken.navigate(root + '/ProgramREM/Application/Program/Lookup/Program.cfm?mission=' + mission + '&period=' + period + '&orgunitparent=' + orgunitparent + '&orgunit=' + orgunit + '&programcode=' + programcode + '&applyscript='+ applyscript + '&scope=' + scope,'programwindow') 		
}	 

function programactivity(prg,per,act) {	  
      w = #CLIENT.width#  - 80;
      h = #CLIENT.height# - 100;	 
	  ptoken.open("#SESSION.root#/programrem/application/program/ActivityProject/ActivityView.cfm?ProgramCode="+prg+"&Period="+per+"&ActivityId="+act,"_blank","width="+w+",height="+h+",status=yes,toolbar=no,scrollbars=yes,resizable=yes")		  
}

function AddProgram(mission,Period,ParentUnit,ProgramCode,refresh,id) {
   
     w = 900
	 h = #CLIENT.height# - 110	   	

     if (id != 'add') {	 
	 	 ptoken.open(root + "/ProgramREM/Application/Program/Create/ProgramEntry.cfm?id="+id+"&mission=" + mission +"&Period=" + Period + "&ParentUnit=" + ParentUnit + "&EditCode=" + ProgramCode + "&Refresh=" + refresh,"addprogram", "left=35, top=35, width="+w+",height="+h+",status=yes,toolbar=no,scrollbars=yes,resizable=yes");								
	 } else {	 		 
	   	 ptoken.open(root + "/ProgramREM/Application/Program/Create/ProgramEntry.cfm?id="+id+"&mission=" + mission +"&Period=" + Period + "&ParentUnit=" + ParentUnit + "&EditCode=" + ProgramCode + "&Refresh=" + refresh,"addprogram", "left=35, top=35, width="+w+",height="+h+",status=yes,toolbar=no,scrollbars=yes,resizable=yes");					 
		 }	 
	 }


function AddComponent(mission,Period,ParentCode,ParentUnit,ProgramCode,refresh,id,mode) {

	 w = 950
	 h = #CLIENT.height# - 110	   	

     if (id != 'add') {	 
	 	 ptoken.open(root + "/ProgramREM/Application/Program/Create/ComponentEntry.cfm?id="+id+"&mission=" + mission +"&Period=" + Period + "&ParentCode=" + ParentCode + "&ParentUnit=" + ParentUnit + "&EditCode=" + ProgramCode + "&Refresh=" + refresh,"addproject", "left=35, top=35, width="+w+",height="+h+",status=yes,toolbar=no,scrollbars=yes,resizable=yes");								
	 } else {	 		 
	   	 ptoken.open(root + "/ProgramREM/Application/Program/Create/ComponentEntry.cfm?id="+id+"&mission=" + mission +"&Period=" + Period + "&ParentCode=" + ParentCode + "&ParentUnit=" + ParentUnit + "&EditCode=" + ProgramCode + "&Refresh=" + refresh,"addproject", "left=35, top=35, width="+w+",height="+h+",status=yes,toolbar=no,scrollbars=yes,resizable=yes");					 
		 }	 
	 }

function AddProject(mission,Period,ParentCode,ParentUnit,ProgramCode,refresh,id,mode) {

	 w = #CLIENT.width# - 60
	 h = #CLIENT.height# - 110	   	

     if (id != 'add') {	 
	 	 ptoken.open(root + "/ProgramREM/Application/Program/Create/ProjectEntry.cfm?id="+id+"&mission="+mission+"&Period="+Period+"&ParentCode="+ParentCode+"&ParentUnit="+ParentUnit+"&EditCode="+ProgramCode+"&Refresh="+refresh,"addproject", "left=35, top=35, width="+w+",height="+h+",status=yes,toolbar=no,scrollbars=yes,resizable=yes");								
	 } else {	 		 
	    ptoken.open(root + "/ProgramREM/Application/Program/Create/ProjectEntry.cfm?id="+id+"&mission="+mission+"&Period="+Period+"&ParentCode="+ParentCode+"&ParentUnit="+ParentUnit+"&EditCode="+ProgramCode+"&Refresh="+refresh,"addproject", "left=35, top=35, width="+w+",height="+h+",status=yes,toolbar=no,scrollbars=yes,resizable=yes");							
	 }		
}

function EditDonor(id) {
 	 ptoken.open(root + "/ProgramREM/Application/Program/Donor/Contribution/ContributionView.cfm?drillid="+id, "Donor", "width=900, height=830, status=yes, scrollbars=yes, resizable=yes");
}

function OpenContribution(mid,id) {	
	 ptoken.open(root + "/ProgramREM/Application/Program/Donor/Contribution/ContributionView.cfm?systemfunctionid="+mid+"&drillid="+id, "AddBudget", "width=#client.width#, height=#client.height-100#, status=yes, scrollbars=yes, resizable=yes");
}

function CarryProgram(Period, ParentUnit, ProgramClass) {
	 ptoken.open(root + "/ProgramREM/Application/Program/CarryOver/ProgramCarryOver.cfm?Period=" + Period + "&ParentUnit=" + ParentUnit, "CarryProgram", "width=#CLIENT.width#-120, height=900, toolbar=no, scrollbars=yes, resizable=yes");
		
}

<!--- -------------- --->
<!--- budget actions --->
<!--- -------------- --->

function budgetaction(actionid) {   
	ptoken.open(root + "/ProgramREM/Application/Budget/Action/AllotmentActionView.cfm?id="+actionid, "AddBudget", "width=990, height=830, status=yes, scrollbars=yes, resizable=yes");
}

function budgettransfer(mission,period,edition,program) {   
    ptoken.open(root + '/ProgramREM/Application/Budget/Transfer/TransferView.cfm?EditionId='+edition+'&Mission=' + mission + '&Period=' + period + '&program=' + program,'transfer', 'width=1200, height=850, status=yes, scrollbars=yes, resizable=yes')
}

function budgettransfercontribution(id,traid,sid,cid) {

   ptoken.open(root + '/ProgramREM/Application/Budget/Transfer/TransferView.cfm?transactionid='+traid+'&contributionlineid='+id,'transfer','width=1000, height=830, status=yes, scrollbars=yes, resizable=yes') 	

	// if (ret == 1) {
	//	history.go()
	// }   
}

function contributionreallocate(tra,cli,sid,cid) {
    
    val = document.getElementsByName(tra)
	cnt = 0
	var traids = ''
	while (val[cnt]) {
	    if (val[cnt].checked) {
		    traids = traids+':'+val[cnt].value
		}	
    	cnt++
	}
	
	
	try { ColdFusion.Window.destroy('mycontribution',true) } catch(e) {}
	ColdFusion.Window.create('mycontribution', 'Reallocation', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    
    ColdFusion.navigate(root + '/ProgramREM/Application/Budget/Contribution/Reallocation.cfm?contributionlineid='+cli+'&systemfunctionid='+sid+'&transactionids='+traids,'mycontribution') 
			   	
}

function contributionreallocatefresh(sid,cid,cli) {
    ColdFusion.navigate('../Allocation/RequirementListing.cfm?systemfunctionid='+sid+'&contributionid='+cid+'&contributionlineid='+cli,'contentbox1')
} 

function WhatIf(edition,period) {
    w = #CLIENT.width# - 60
	h = #CLIENT.height# - 110
    ptoken.open(root + "/ProgramREM/Application/Budget/Markdown/MarkDownView.cfm?EditionId=" + edition + "&Period=" + period, "whatif", "width=970, height=870, status=yes, toolbar=no, scrollbars=no, resizable=no");
}

function Allocation(edition,period) {
         w = #CLIENT.width# - 60
	     h = #CLIENT.height# - 110	
         ptoken.open(root + "/ProgramREM/Application/Budget/Allocation/AllocationView.cfm?edition=" + edition + "&Period=" + period, "form"+edition, "width="+w+", height="+h+", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function ReviewProgram(mission, ProgramCode, Period, SubPeriod) {
	     ptoken.open(root + "/ProgramREM/Application/Program/Review/ProgramReview.cfm?Mission=" + mission +"&ProgramCode=" + ProgramCode + "&Period=" + Period + "&SubPeriod=" + SubPeriod, "ReviewProgram", "width=950, height=800, status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function DeleteProgram(Code,Per) {
	if (confirm("Do you want to deactivate this Program for planning period " + Per + "?")) {
	     ptoken.open(root + "/ProgramREM/Application/Program/ProgramDelete.cfm?ts="+new Date().getTime()+"&ProgramCode=" + Code + "&Period=" + Per, "right");
	}
}

function ReinstateProgram(Code,Per) {
	if   (confirm("Do you want to reinstate this Program for planning period " + Per + "?")) {
	     ptoken.open(root + "/ProgramREM/Application/Program/ProgramReinstate.cfm?ts="+new Date().getTime()+"&ProgramCode=" + Code + "&Period=" + Per, "right");
	}
}

function EditProgram(Code, Period, Layout) {
        w = #CLIENT.width# - 60;
        h = #CLIENT.height# - 120;		 
		_cf_loadingtexthtml='';	
		ptoken.open(root + "/ProgramREM/Application/Program/ProgramView.cfm?ProgramCode=" + Code + "&Period=" + Period + "&ProgramLayout=" + Layout, Code);
}

function ViewProgram(Code, Period, Layout) {
        w = #CLIENT.width# - 60;
        h = #CLIENT.height# - 120;
		ptoken.open(root + "/ProgramREM/Application/Program/ProgramView.cfm?ProgramCode=" + Code + "&Period=" + Period + "&ProgramLayout=" + Layout, "ProgramView", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function AllotmentProgram(mission,code,period) {
        w = #CLIENT.width# - 80;
        h = #CLIENT.height# - 120;
		ptoken.open(root + "/ProgramREM/Application/Budget/Allotment/AllotmentView.cfm?Mission=" + mission + "&Program=" + code + "&Period=" + period, "ProgramAll", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}

function allotdetail(prg,per,ed,fd,ob,box,par) {
	    se = document.getElementById('box_'+ob+'_'+box)
        if (se.className == "regular") {
		    se.className = "hide"
		} else {
	        se.className = "regular";		
			_cf_loadingtexthtml='';		
	        ptoken.navigate(root + '/ProgramREM/Application/Budget/Allotment/AllotmentInquiryDetail.cfm?isParent='+par+'&ProgramCode='+prg+'&Period='+per+'&Edition='+ed+'&Fund='+fd+'&Object='+ob,'detail_'+ob+'_'+box)
		}
}	

function preencdetail(prg,hie,per,ed,fd,ob,box,par,res) {
        _cf_loadingtexthtml='';	
	    ptoken.navigate(root + '/ProgramREM/Application/Budget/Allotment/AllotmentInquiryDetailRequisition.cfm?box='+box+'&isParent='+par+'&ProgramCode='+prg+'&ProgramHierarchy='+hie+'&Period='+per+'&Edition='+ed+'&Fund='+fd+'&Object='+ob+'&Resource='+res,'requisition_'+box)		
}	

function obligdetail(prg,period,ed,fund,obj,box,par,reqno,org,hier) {    
		w = #CLIENT.width# - 200;
	    h = #CLIENT.height# - 210;	
		ptoken.open("#SESSION.root#/Procurement/Application/Funding/FundingExecutionDetail.cfm?editionid="+ed+"&unithierarchy="+org+"&box="+box+"&reqno="+reqno+"&fund="+fund+"&period="+period+"&programcode="+prg+"&programhierarchy="+hier+"&objectcode="+obj+"&isParent=1","oblig", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}	

 function disbursdetail(prg,period,ed,fund,obj,box,par,reqno,org,hier) {
		w = #CLIENT.width# - 200;
	    h = #CLIENT.height# - 210;	
	    ptoken.open("#SESSION.root#/Procurement/Application/Funding/FundingExecutionDetail.cfm?editionid="+ed+"&unithierarchy="+org+"&box="+box+"&reqno="+reqno+"&fund="+fund+"&period="+period+"&programcode="+prg+"&programhierarchy="+hier+"&objectcode="+obj+"&isParent=1","disburs", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes"); 	
 }	

function AuditProgram(Code,period) {
        w = #CLIENT.width# - 80;
        h = #CLIENT.height# - 120;
		ptoken.open(root + "/ProgramREM/Application/Indicator/Audit/IndicatorView.cfm?Program=" + Code + "&Period=" + period, "ProgramAll", "left=40, top=40, width=" + w + ", height= " + h + ", status=no, toolbar=no, scrollbars=no, resizable=yes");
}

function AuditProgramDates(target,period) {
        w = #CLIENT.width# - 180;
        h = #CLIENT.height# - 160;		
        ret = window.showModalDialog(root + "/ProgramREM/Application/Indicator/Audit/IndicatorAuditDates.cfm?ts="+new Date().getTime()+"&targetId=" + target + "&Period=" + period, window, "unadorned:yes; edge:raised; status:yes; dialogHeight:800px; dialogWidth:930px; help:no; scroll:no; center:yes; resizable:no");
		if (ret) { history.go() }
}

function AuditProject(Code,period) {
        w = #CLIENT.width# - 80;
		g = w-35;
        h = #CLIENT.height# - 120;
		ptoken.open(root + "/ProgramREM/Application/Activity/Progress/ActivityView.cfm?html=yes&output=0&ProgramCode=" + Code + "&Period=" + period, "_blank", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function AuditActivity(id) {
        w = #CLIENT.width# - 80;
        h = #CLIENT.height# - 120;
		ptoken.open(root + "/ProgramREM/Application/Activity/Progress/ActivityView.cfm?html=yes&ActivityId=" + id, "_blank", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, toolbar=yes, scrollbars=yes, resizable=yes");
}

function Allotment(code,fund,period,mode,version,target,sid,context) {

        w = screen.width - 80;
        h = #CLIENT.height# - 100;					
		if (target == "undefined") {
		   target = "_blank"
		}  					
		ptoken.open(root + "/ProgramREM/Application/Budget/Allotment/AllotmentOpen.cfm?systemfunctionid="+sid+"&Program=" + code + "&version=" + version +"&fund=" + fund + "&caller=External&width=" + w + "&period=" + period + "&mode=" + mode + "&context=" + context , target);						
}

function AllotmentInquiry(code,fund,period,mode,version,sid) {
        w = screen.width- 120;
        h = #CLIENT.height# - 120;			
		ptoken.open(root + "/ProgramREM/Application/Budget/Allotment/AllotmentInquiry.cfm?systemfunctionid="+sid+"&ts="+new Date().getTime()+"&Program=" + code + "&version=" + version + "&fund=" + fund + "&caller=External&width=" + w + "&period=" + period + "&Verbose=1&mode=" + mode, "_blank");		
}

function AllotmentApprovalReject(code,fund,period) {
        w = #CLIENT.width# - 200;
        h = #CLIENT.height# - 160;
		ptoken.open(root + "/Portal/Clearance/Budget/AllotmentApprovalReject.cfm?ts="+new Date().getTime()+"&Program=" + code + "&fund=" + fund + "&caller=External&width=" + w + "&period=" + period, "Program", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}

function SearchProgram(formname, fieldname) {
	    ptoken.open(root + "/Search/IndexSearch.cfm?ts="+new Date().getTime()+"&FormName=" + formname + "&FieldName=" + fieldname, "SearchPerson", "width=600, height=550, toolbar=no, scrollbars=yes, resizable=yes");
}

function LocateProgram(formname, fieldname, last, dob, nat) {
	    ptoken.open(root + "/Search/IndexSearchLocate.cfm?ID=" + formname + "&ID1=" + fieldname + "&ID2=" + last + "&ID3=" + dob + "&ID4=" + nat, "SearchPerson", "width=600, height=550, toolbar=no, scrollbars=yes, resizable=yes");
}

function showbackground(pers,src) {
   		w = #CLIENT.width# - 100;
	    h = #CLIENT.height# - 150;
		ptoken.open(root +  "/Roster/RosterGeneric/Background/ApplicantBackground.cfm?ID=" + pers + "&ID1=" + src, "DialogWindow", "left=50, top=50, width=" + w + ", height= " + h + ", scrollbars=yes, resizable=yes");
}

</script>

</cfoutput>