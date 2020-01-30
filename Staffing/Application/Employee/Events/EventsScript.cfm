
<cfajaximport tags="cfform">

<cfoutput>

<script language="JavaScript">
	
	function workflowdrill(key,box){
		
		if (document.getElementById(box).className == "hide") {
			document.getElementById(box).className = "regular";
			_cf_loadingtexthtml='';
			ptoken.navigate('#client.root#/Staffing/Application/Employee/Events/EventWorkflow.cfm?ajaxid='+key,key);	
		}else{
			document.getElementById(box).className = "hide";
		}		
	}
	
	function eventedit(key) {
    	Prosis.busy('yes');
    	_cf_loadingtexthtml='';
		try { ColdFusion.Window.destroy('evdialog',true) } catch(e) {}
		ProsisUI.createWindow('evdialog', 'Event Dialog', '',{x:200,y:200,height:document.body.clientHeight-100,width:document.body.clientWidth-200,modal:true,resizable:false,center:true})    					
    	ColdFusion.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventForm.cfm?portal=0&id='+key,'evdialog')
	}
	
	function setSelected() { 
        $('a.selected').each(function() {
             $(this).click();
        });
    } 
    
   function eventadd(personno) {    	
    	Prosis.busy('yes');
    	_cf_loadingtexthtml='';
		try { ColdFusion.Window.destroy('evdialog',true) } catch(e) {}
		ProsisUI.createWindow('evdialog', 'Event Dialog', '',{x:200,y:200,height:document.body.clientHeight-100,width:document.body.clientWidth-200,modal:true,resizable:false,center:true})    					
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventForm.cfm?portal=0&personNo='+personno,'evdialog')		 	
    }
    
    function checkevent() {
		tc = document.getElementById('triggercode');
		rid = document.getElementById('eventid');
		mis = document.getElementById('mission');		
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/getEvent.cfm?triggercode='+tc.value+'&eventid='+rid.value+'&mission='+mis.value,'dEvent')
    }    

    function checkreason() {
		tc = document.getElementById('triggercode');
		ev = document.getElementById('eventcode');
		rid = document.getElementById('eventid');		
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/getReason.cfm?triggercode='+tc.value+'&eventcode='+ev.value+'&eventid='+rid.value,'dReason');
    }
    
    function eventdelete(event) {
		Ext.MessageBox.confirm('Delete', 'Are you sure ?', function(btn){
		   if(btn === 'yes'){
		       ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventsDelete.cfm?eventid='+event,'eventdetail');
		   }
		 });
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
    		ptoken.navigate('#SESSION.root#/Staffing/Application/employee/events/EventFormSubmit.cfm?scope=person&eventid='+id,'eventdetail','','','POST','eventform')		
		}
	}
		
</script>

</cfoutput>