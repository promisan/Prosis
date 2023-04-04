<cfparam name="URL.portal" default="0">
<cfparam name="URL.personno" default="">

<cfajaximport tags="cfform">

<cfoutput>

<script language="JavaScript">

	_cf_loadingtexthtml='';	
	
	function workflowdrill(key,box){
		
		if (document.getElementById(box).className == "hide") {
			document.getElementById(box).className = "regular";
			_cf_loadingtexthtml='';
			ptoken.navigate('#client.root#/Staffing/Application/Employee/Events/EventWorkflow.cfm?ajaxid='+key,key);	
		}else{
			document.getElementById(box).className = "hide";
		}		
	}
			
	function setSelected() { 
        $('a.selected').each(function() {
             $(this).click();
        });
    } 
	    
   function eventadd(personno,scope,mis,trigger,code) {    	
    	Prosis.busy('yes');
    	_cf_loadingtexthtml='';		
		
		ht = document.body.clientHeight-70		   
		if (document.body.clientWidth < 800) {
		      wi = document.body.clientWidth-100
		   } else {
		      wi = 900
		   } 
		ProsisUI.createWindow('evdialog', 'HR Service Request / Advice', '',{x:200,y:200,height:ht,width:wi,modal:true,resizable:true,center:true})    					
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventForm.cfm?scope='+scope+'&portal=#url.portal#&personNo='+personno+'&mission='+mis+'&trigger='+trigger+'&code='+code,'evdialog')		 	
    }
	
	function eventedit(key,scope,portal) {
    	Prosis.busy('yes');
    	_cf_loadingtexthtml='';		
		ProsisUI.createWindow('evdialog', 'HR Service Request / Advice', '',{x:200,y:200,height:document.body.clientHeight-100,width:document.body.clientWidth-200,modal:true,resizable:false,center:true})    					
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventForm.cfm?scope='+scope+'&portal='+portal+'&id='+key,'evdialog')
	}
	
	function eventview(key,scope,portal) {
    	ptoken.open('#SESSION.root#/Staffing/Application/Employee/Events/EventDialog.cfm?scope='+scope+'&portal='+portal+'&id='+key,'evdialog')
	}
    
    function checkevent() {		
	    por     = document.getElementById('portal');
		scp     = document.getElementById('scope');					
		mis     = document.getElementById('mission');
		tc      = document.getElementById('triggercode');	
		rid     = document.getElementById('eventid');	
		per     = document.getElementById('personno');		
		pevent  = document.getElementById('pevent');				
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/getEvent.cfm?portal='+por.value+'&scope='+scp.value+'&personno='+per.value+'&triggercode='+tc.value+'&eventid='+rid.value+'&mission='+mis.value+'&pevent='+pevent.value,'dEvent')
    }    
	
	function checkinstruction() {		
	    mis     = document.getElementById('mission');
	   	evt     = document.getElementById('eventcode');		
	   	ptoken.navigate('#session.root#/Staffing/Application/Employee/Events/getInstruction.cfm?eventcode='+evt.value+'&mission='+mis.value,'myinstruction')			
	}

    function checkreason() {	 	    
	    por     = document.getElementById('portal');
		scp     = document.getElementById('scope');	  	   
	    mis     = document.getElementById('mission');		
		tc      = document.getElementById('triggercode');
		ev      = document.getElementById('eventcode');
		rid     = document.getElementById('eventid');		
		preason = document.getElementById('preason');	
				
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/getReason.cfm?portal='+por.value+'&scope='+scp.value+'&mission='+mis.value+'&triggercode='+tc.value+'&eventcode='+ev.value+'&eventid='+rid.value+'&preason='+preason.value,'dReason');				
		ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/getCondition.cfm?triggercode='+tc.value+'&eventcode='+ev.value+'&eventid='+rid.value+'&preason='+preason.value,'dCondition');
    }
	    
    function eventdelete(event,portal,scope) {
	
	
	    if (confirm("Are you sure to remove this request?"))	{			
	       ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventsDelete.cfm?portal='+portal+'&scope='+scope+'&eventid='+event,'eventdetail');
	   }
	
    }
		
	function eventsubmit(id,box,portal,scope) {	
	  
		tc  = document.getElementById('triggercode');
		ev  = document.getElementById('eventcode');
		de  = document.getElementById('DateEvent');
		ded = document.getElementById('DateEventDue');	
		eff = document.getElementById('ActionDateEffective');
		
		pri = document.getElementById('EventPriority');	
		prm = document.getElementById('EventPriorityMemo');
		
		doc = document.getElementById('documentno');				
		pos = document.getElementById('positionNo');
		req = document.getElementById('requisitionNo');
		exp = document.getElementById('ActionDateExpiration');	
				
		dbx = document.getElementById('documentbox');
		pbx = document.getElementById('positionbox');	
		rbx = document.getElementById('requisitionbox');
		efx = document.getElementById('effectivebox');	
		ebx = document.getElementById('expirybox');					
				
		if (pos.value=='' && pbx.className!= 'hide') {		    
			alert('Please specify a position.');		
				
		} else if (tc.value  == '')   {		    
			alert('Please specify an event trigger.');
			
		} else if (doc.value  == '' && dbx.className!= 'hide')   {		   
			alert('Please specify a Recruitment Document.');	
			
		} else if (req.value=='' && rbx.className!='hide'){		    
			alert('Please specify Requisition No.');
			
		} else if (pri.checked && prm.value ==''){		   
			alert('Please specify a reason.');	
			
		} else if (ev.value  == '')   {		  
			alert('Please specify an event action.');		
			
		} else if (de.value  == '')   {		
			alert('Please specify Event Date.');
			
		} else if (ded.value == '')  {		
			alert('Please specify Due Date.');
			
		} else if (eff.value == '')  {		
			alert('Please specify an effective Date.');	
			
		} else if (exp.value == '' && ebx.className!= 'hide') {		
			alert('Please specify an expiration Date.');		
		
		} else{		
		   
    		ptoken.navigate('#SESSION.root#/Staffing/Application/employee/events/EventFormSubmit.cfm?portal='+portal+'&scope='+scope+'&box='+box+'&eventid='+id,'process','','','POST','eventform')		
		}
	}
		
</script>

</cfoutput>