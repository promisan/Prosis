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
	
	function eventportaladd(personno,scope, mission, trigger, event, reason) {    	
    	Prosis.busy('yes');
    	_cf_loadingtexthtml='';		
		ProsisUI.createWindow('evdialog', 'HR Event request', '',{x:200,y:200,height:document.body.clientHeight-100,width:document.body.clientWidth-200,modal:true,resizable:false,center:true})    					
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventForm.cfm?scope='+scope+'&portal=#url.portal#&personNo='+personno+'&pmission='+mission+'&ptrigger='+trigger+'&preason='+reason+'&pevent='+event,'evdialog')		 	
    }
	
	function eventportalaedit(key,scope, mission, trigger, event, reason) {    	
    	Prosis.busy('yes');
    	_cf_loadingtexthtml='';		
		ProsisUI.createWindow('evdialog', 'HR Event request', '',{x:200,y:200,height:document.body.clientHeight-100,width:document.body.clientWidth-200,modal:true,resizable:false,center:true})    					
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventForm.cfm?scope='+scope+'&portal=#url.portal#&id='+key+'&pmission='+mission+'&ptrigger='+trigger+'&preason='+reason+'&pevent='+event,'evdialog')		 	
    }
	
	function eventportaldelete(event,scope, mission, trigger, eventCode, reason) {
		Ext.MessageBox.confirm('Delete', 'Are you sure ?', function(btn){
		   if(btn === 'yes'){
		       ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventsDelete.cfm?scope='+scope+'&eventid='+event+'&mission='+mission+'&trigger='+trigger+'&reason='+reason+'&event='+eventCode,'divEventDetail');
		   }
		 });
    }
    
   function eventadd(personno,scope) {    	
    	Prosis.busy('yes');
    	_cf_loadingtexthtml='';		
		ProsisUI.createWindow('evdialog', 'HR Event request', '',{x:200,y:200,height:document.body.clientHeight-100,width:document.body.clientWidth-200,modal:true,resizable:false,center:true})    					
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventForm.cfm?scope='+scope+'&portal=#url.portal#&personNo='+personno,'evdialog')		 	
    }
	
	function eventedit(key,scope) {
    	Prosis.busy('yes');
    	_cf_loadingtexthtml='';		
		ProsisUI.createWindow('evdialog', 'HR Event request', '',{x:200,y:200,height:document.body.clientHeight-100,width:document.body.clientWidth-200,modal:true,resizable:false,center:true})    					
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventForm.cfm?scope='+scope+'&portal=0&id='+key,'evdialog')
	}
    
    function checkevent() {
		
		tc  = document.getElementById('triggercode');
		rid = document.getElementById('eventid');
		mis = document.getElementById('mission');	
		per = document.getElementById('personno');		
		pevent = document.getElementById('pevent');
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/getEvent.cfm?personno='+per.value+'&triggercode='+tc.value+'&eventid='+rid.value+'&mission='+mis.value+'&pevent='+pevent.value,'dEvent')
    }    

    function checkreason() {
		tc = document.getElementById('triggercode');
		ev = document.getElementById('eventcode');
		rid = document.getElementById('eventid');
		preason = document.getElementById('preason');
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/getReason.cfm?triggercode='+tc.value+'&eventcode='+ev.value+'&eventid='+rid.value+'&preason='+preason.value,'dReason');		
		ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/getCondition.cfm?triggercode='+tc.value+'&eventcode='+ev.value+'&eventid='+rid.value+'&preason='+preason.value,'dCondition');
    }
	    
    function eventdelete(event,scope) {
		Ext.MessageBox.confirm('Delete', 'Are you sure ?', function(btn){
		   if(btn === 'yes'){
		       ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventsDelete.cfm?scope='+scope+'&eventid='+event,'eventdetail');
		   }
		 });
    }
		
	function eventsubmit(id,box,scope) {
	
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
			Ext.Msg.alert('Effective date', 'Please specify an effective Date.');	
		} else if (exp.value == '' && ebx.className!= 'hide') {
			Ext.Msg.alert('Effective date', 'Please specify an expiration Date.');		
		} 
		else{
    		ptoken.navigate('#SESSION.root#/Staffing/Application/employee/events/EventFormSubmit.cfm?scope='+scope+'&box='+box+'&eventid='+id,'process','','','POST','eventform')		
		}
	}
		
</script>

</cfoutput>