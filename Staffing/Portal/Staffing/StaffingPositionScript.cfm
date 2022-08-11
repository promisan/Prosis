
<cfoutput>

<cf_presentationScript>
<cf_textareascript>
<cf_calendarscript>
<cf_filelibraryscript>
<cf_actionlistingscript>
<cf_dialogposition>

<cfajaximport tags="cfform,cfdiv">

	<script language="JavaScript">
	
		function doFilter(content) {
			var vUnits = $('.clsFilterUnit:checked').map(function() {return this.value;}).get().join(',');		
			// Prosis.busyRegion('yes','main');		
			ptoken.navigate('StaffingPositionListing.cfm?content='+content+'&systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&selection=#url.selection#&unit='+vUnits, 'main');
		}
		
		function ViewPosition(pos) {
			ProsisUI.createWindow('positiondialog', 'Position Classification', '',{x:100,y:100,height:500,width:840,modal:true,center:true});	
			ptoken.navigate('#SESSION.root#/Staffing/Portal/Staffing/PositionDialogView.cfm?positionparentid='+pos,'positiondialog')		
		}
						
		function AddClassification(pos,ajaxid) {
		    if (document.body.clientHeight-60 >= 680) { ht = 680 } else { ht = document.body.clientHeight-40 } 
			ProsisUI.createWindow('classify', 'Record Classification', '',{x:100,y:100,height:ht,width:840,modal:true,center:true});	
			ptoken.navigate('#SESSION.root#/Staffing/Portal/Staffing/StaffingPositionClassification.cfm?positionparentid='+pos+'&ajaxid='+ajaxid+'&portal=1&init=1','classify')		
		}
		
		function AddVacancy(postno,box) {
		    if (document.body.clientHeight-60 >= 800) { ht = 800 } else { ht = document.body.clientHeight-40 } 
			ProsisUI.createWindow('mydialog', 'Record Recruitment Track', '',{x:100,y:100,height:ht,width:900,modal:true,center:true});	
			ptoken.navigate('#SESSION.root#/Vactrack/Application/Document/DocumentEntryPosition.cfm?box='+box+'&portal=1&Mission=#URL.Mission#&ID1=' + postno + '&Caller=Listing','mydialog');	
		}
		
		function Selected(no,description) {									
			document.getElementById('functionno').value = no
			document.getElementById('FunctionDescription').value = description					 
			ProsisUI.closeWindow('myfunction')
		}		
		
		function va(fun) {
			ptoken.open('#SESSION.root#/Vactrack/Application/Announcement/Announcement.cfm?header=yes&ID='+fun, fun);
		}
		
		function rostersearch(action,actionid,ajaxid) {    
		    ptoken.open("#SESSION.root#/Roster/RosterGeneric/RosterSearch/Search1ShortList.cfm?mode=vacancy&wActionId="+actionid, "search"+ajaxid, "left=35, top=35, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes")	
	    }
			
		function AddEvent(per,pos,box,trg,cde,org) {    		
		    if (document.body.clientHeight-60 >= 600) { ht = 600 } else { ht = document.body.clientHeight-40 }    		   
			ProsisUI.createWindow('evdialog', 'HR Event request', '',{x:100,y:100,height:ht,width:690,modal:true,resizable:false,center:true})    					
		   	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventForm.cfm?box='+box+'&portal=1&personNo='+per+'&positionno='+pos+'&orgunit='+org+'&trigger='+trg+'&code='+cde,'evdialog')		 	
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
				alert('Please specify a position.');			
			} else if (tc.value  == '')   {		   
				alert('Please specify an event trigger.');
			} else if (doc.value  == '' && dbx.className!= 'hide')   {		    
				alert('Please specify a Recruitment Document.');	
			} else if (req.value=='' && rbx.className!='hide'){		    
				alert('Please specify Requisition No.');
			} else if (ev.value  == '')   {		    
				alert('Please specify an event action.');		
			} else if (de.value  == '')   {		    
				alert('Please specify Event Date.');
			} else if (ded.value == '')  {		    
				alert('Please specify Due Date.');
			} else if (eff.value == '')  {		    
				alert('Please specify Action effective Date.');	
			} else if (exp.value == '' && ebx.className!= 'hide') {		    
				alert('Please specify Action expiration Date.');		
			} else{		
	    		ptoken.navigate('#SESSION.root#/Staffing/Application/employee/events/EventFormSubmit.cfm?box='+box+'&eventid='+id,'process','','','POST','eventform')		
			}
		}
	
	</script>

</cfoutput>
