
<cfoutput>

<cf_calendarscript>
<cf_filelibraryscript>
<cf_actionlistingscript>
<cf_dialogposition>

<cfajaximport tags="cfform,cfdiv">

<script language="JavaScript">

	function doFilter() {
		var vUnits = $('.clsFilterUnit:checked').map(function() {return this.value;}).get().join(',');
		ptoken.navigate('StaffingPositionListing.cfm?mission=#url.mission#&selection=#url.selection#&unit='+vUnits, 'main');
	}
					
	function AddClassification(pos,ajaxid) {
		ProsisUI.createWindow('classify', 'Record Classification', '',{x:100,y:100,height:600,width:640,modal:true,center:true});	
		ptoken.navigate('#SESSION.root#/Staffing/Portal/Staffing/StaffingPositionClassification.cfm?positionparentid='+pos+'&ajaxid='+ajaxid+'&portal=1&init=1','classify')		
	}
	
	function AddVacancy(postno,box) {
		ProsisUI.createWindow('mydialog', 'Record Recruitment Track', '',{x:100,y:100,height:600,width:640,modal:true,center:true});	
		ptoken.navigate('#SESSION.root#/Vactrack/Application/Document/DocumentEntryPosition.cfm?box='+box+'&portal=1&Mission=#URL.Mission#&ID1=' + postno + '&Caller=Listing','mydialog');	
	}
	
	function rostersearch(action,actionid,ajaxid) {    
	    ptoken.open("#SESSION.root#/Roster/RosterGeneric/RosterSearch/Search1ShortList.cfm?mode=vacancy&wActionId="+actionid, "search"+ajaxid, "left=35, top=35, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes")	
    }
		
	function AddEvent(per,pos,box,trg,cde) {    		   		   
		ProsisUI.createWindow('evdialog', 'HR Event request', '',{x:100,y:100,height:430,width:680,modal:true,resizable:false,center:true})    					
	   	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventForm.cfm?box='+box+'&portal=1&personNo='+per+'&positionno='+pos+'&trigger='+trg+'&code='+cde,'evdialog')		 	
	}
	
	function checkevent() {
		tc  = document.getElementById('triggercode');
		rid = document.getElementById('eventid');
		mis = document.getElementById('mission');	
		per = document.getElementById('personno');			
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/getEvent.cfm?personno='+per.value+'&portal=1&triggercode='+tc.value+'&eventid='+rid.value+'&mission='+mis.value,'dEvent')
    }    

    function checkreason() {
		tc = document.getElementById('triggercode');
		ev = document.getElementById('eventcode');
		rid = document.getElementById('eventid');		
    	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/getReason.cfm?triggercode='+tc.value+'&eventcode='+ev.value+'&eventid='+rid.value,'dReason');
		ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/getCondition.cfm?triggercode='+tc.value+'&eventcode='+ev.value+'&eventid='+rid.value,'dCondition');  
    }
	
	function eventsubmit(id,box) {
	
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
    		ptoken.navigate('#SESSION.root#/Staffing/Application/employee/events/EventFormSubmit.cfm?box='+box+'&eventid='+id,'process','','','POST','eventform')		
		}
	}

</script>

</cfoutput>
