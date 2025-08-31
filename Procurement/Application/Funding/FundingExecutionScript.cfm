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
<cfparam name="client.fundingmission" default="">
<cfparam name="client.fundingperiod"  default="">
<cfparam name="URL.Object"  default="">
<cfparam name="URL.Org"     default="0">
<cfparam name="URL.Job"     default="">
<cfparam name="URL.ID"      default="">

<cfoutput>

<cf_DialogProcurement>
<cf_DialogREMProgram>
<cf_DialogLedger>

<script language="JavaScript">

function printme() {
    w   = #CLIENT.width# - 100;
    h   = #CLIENT.height# - 110;	
	org = document.getElementById('orgunit').value	
    window.open("FundingExecutionPrint.cfm?unithierarchy="+org+"&mode=print&ts="+new Date().getTime()+"&#CGI.QUERY_STRING#", "dialog", "unadorned:yes; edge:raised; status:no; dialogHeight: "+h+" px; dialogWidth:"+w+" px; help:no; scroll:yes; center:yes; resizable:yes");
}

function search() {

	se = document.getElementById("findsearch")	 
	if (window.event.keyCode == "13")
		{	document.getElementById("locate").click() }						
    }
	
function imis(yr,fd,act,obj,ed,mi,res,prg) {
    window.open("Detail/IMIS.cfm?editionid="+ed+"&programcode="+prg+"&year="+yr+"&fund="+fd+"&activity="+act+"&object="+obj+"&resource="+res+"&mission="+mi,"_blank","left=30, top=30, width=#client.widthfull-80#, height=#client.height-80#, status=yes, toolbar=no, scrollbars=no, resizable=yes") 
 }		

function facttablexls1(controlid,format,filter,qry,dsn) {			
	w = #CLIENT.width# - 100;
    h = #CLIENT.height# - 110;		
    window.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?data=1&dsn="+dsn+"&controlid="+controlid+"&"+qry+"&filter="+filter+"&format="+format+"&ts="+new Date().getTime(), "facttable", "height="+h+"px, width="+w+"px, scrollbars=yes, resizable=no");
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
	    itm.className = "highLight3";				 
	 }else{			 
	    itm.className = "header";		
	 }
  }
  
function object(prg,mis,planperiod,period,cls,hrg,edt,fund,org) {		
 		
	try {		
	
		apply  = document.getElementById('applyhierarchy').checked	
		if (apply) {	 
		    hier = hrg 
		} else {
		    hier = ""
		} 		
		}
		catch(e) {
		hier=""
		}
	
			
	icM  = document.getElementById(prg+"_"+edt+"_"+fund+"Min")
	icE  = document.getElementById(prg+"_"+edt+"_"+fund+"Exp")
	se   = document.getElementById("d"+prg+"_"+edt+"_"+fund);		
		
	if (se.className == "hide") {
	
	    se.className  = "regular"
		icM.className = "regular"
		icE.className = "hide"
		_cf_loadingtexthtml='';	
		ptoken.navigate('../Requisition/Funding/RequisitionEntryFundingSelectObject.cfm?mode=list&Object=#URL.Object#&id=#url.id#&programcode='+prg+'&programclass='+cls+'&mission='+mis+'&programhierarchy='+hier+'&planperiod='+planperiod+'&period='+period+'&edition='+edt+'&fund='+fund+'&unithierarchy='+org,'i'+prg+'_'+edt+'_'+fund)	
		
	} else {
	
	    se.className  = "hide"
		icE.className = "regular"
		icM.className = "hide"	
		
	}					
	 		 		
  }

function amore(tpc,box,ed,fund,reqno,period,prg,obj,act,mode,mis,hier,org,resource,status) {
	    se   = document.getElementById(tpc+box);	
        if (se.className == "regular") {
		    se.className = "hide"
		} else {
		  se.className = "regular";
	      ColdFusion.navigate('#SESSION.root#/ProgramREM/Application/Budget/Allotment/AllotmentInquiryDetail.cfm?status='+status+'&isParent=1&ProgramCode='+prg+'&Period='+period+'&Edition='+ed+'&Fund='+fund+'&Object='+obj+'&mode='+mode+'&programhierarchy='+hier+'&unithierarchy='+org+'&resource='+resource,'a'+tpc+box)
		}
	}	    
  
function bmore(tpc,box,fund,reqno,period,prg,obj,act,mode,mis,hier,org,ed,resource) {		
    w = #CLIENT.width# - 200;
    h = #CLIENT.height# - 210;			
    ptoken.open("FundingExecutionDetail.cfm?editionid="+ed+"&ts="+new Date().getTime()+"&unithierarchy="+org+"&mission="+mis+"&box="+box+"&reqno="+reqno+"&fund="+fund+"&period="+period+"&programcode="+prg+"&programhierarchy="+hier+"&objectcode="+obj+"&isParent=1&mode="+mode+"&resource="+resource, "dialog");   
}
 
function umore(tpc,box,fund,reqno,period,prg,obj,act,mode,mis,hier,org,ed,resource) {		
    w = #CLIENT.width# - 200;
    h = #CLIENT.height# - 210;	
    ptoken.open("FundingExecutionDetail.cfm?editionid="+ed+"&ts="+new Date().getTime()+"&unithierarchy="+org+"&mission="+mis+"&box="+box+"&reqno="+reqno+"&fund="+fund+"&period="+period+"&programcode="+prg+"&programhierarchy="+hier+"&objectcode="+obj+"&isParent=1&mode="+mode+"&resource="+resource, "dialog"); 
}
	
function imore(tpc,box,fund,reqno,period,prg,obj,act,mode,mis,hier,org,ed,resource) {				
	w = #CLIENT.width# - 200;
    h = #CLIENT.height# - 210;	
    ptoken.open("FundingExecutionDetail.cfm?editionid="+ed+"&ts="+new Date().getTime()+"&unithierarchy="+org+"&mission="+mis+"&box="+box+"&reqno="+reqno+"&fund="+fund+"&period="+period+"&programcode="+prg+"&programhierarchy="+hier+"&objectcode="+obj+"&isParent=1&mode="+mode+"&resource="+resource, "dialog");
 
}	

function alldetexecution(id,status) {		   
	ColdFusion.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestExecution.cfm?requirementid='+id+'&status='+status,id+'_exe')	
}
 
</script>

</cfoutput>

