
<cfoutput>

<script>

function output(id) {
     window.open("ScheduleOutput.cfm?id="+id,"DialogWindow", "width=860, height=760, status=no,toolbar=no,scrollbars=no,resizable=yes")
} 

function scheduleoption(id) {
     _cf_loadingtexthtml="";	
	 ColdFusion.navigate('ScheduleOption.cfm?id='+id,'option'+id)	
	 _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy11.gif'/>"; 
}

function recordrun(id) {   
     ProsisUI.createWindow('executetask', 'Execute Task', '',{x:100,y:100,height:580,width:560,closable:false,modal:true,center:true})	
	 ColdFusion.navigate('#SESSION.root#/System/Scheduler/ScheduleExecute.cfm?id='+id,'executetask')
}

function showprogress(id,idlog) {
   _cf_loadingtexthtml="";	
   ColdFusion.navigate('#SESSION.root#/System/Scheduler/ScheduleExecuteProgress.cfm?id='+id+'&idlog='+idlog,'progress'+id)
   _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy11.gif'/>"; 
}

function stopprogress() {
	 clearInterval ( prg );
}	 

function showlastaction(id) {    
	ColdFusion.navigate('#SESSION.root#/System/Scheduler/ScheduleLast.cfm?id='+id,'last'+id)		
}

function deletelog(id,id1) {
	 _cf_loadingtexthtml="";	
	 ColdFusion.navigate('ScheduleLog.cfm?id='+id+'&id1='+id1,'detail'+id)
	 _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy11.gif'/>";
}

function recordexecute(id,idlog) {       
	ptoken.navigate('ScheduleExecuteGo.cfm?now=1&idlog='+idlog+'&id='+id+'&mode=manual','run'+id)		
    ptoken.navigate('#SESSION.root#/System/Scheduler/ScheduleExecuteProgress.cfm?init=1&idlog='+idlog+'&id='+id,'progress'+id)				
}

function schedulelog(id,id1,act) {    

	icM  = document.getElementById(id+"Min")
    icE  = document.getElementById(id+"Exp")
	se   = document.getElementById("log"+id);	
		
	if (id1 != "") { window.status = "deleting.." }
				 		 
	if (se.className == "hide" || act == "show") {	
	   	 icM.className = "regular";
	     icE.className = "hide";
		 se.className  = "regular";		
		 _cf_loadingtexthtml="";
		 ptoken.navigate('ScheduleLog.cfm?id='+id+'&id1='+id1,'detail'+id)
	} else {
	   	 icM.className = "hide";
	     icE.className = "regular";
    	 se.className  = "hide";
    }		 		
}
  
function schedulelogdetail(idlog) { 
    	
	se   = document.getElementById("log"+idlog);	
					 		 
	if (se.className == "hide")  {	
	 	 se.className  = "regular";		
		 ColdFusion.navigate('ScheduleLogDetail.cfm?idlog='+idlog,'log'+idlog)
	} else {
	   	 se.className  = "hide";
	 }
		 		
  }  

function toggle(id) {
    _cf_loadingtexthtml="";	
    ColdFusion.navigate('ScheduleStatus.cfm?ts='+new Date().getTime()+'&id='+id+'&toggle=1',id)	
	_cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy11.gif'/>";
}

</script>
</cfoutput>
