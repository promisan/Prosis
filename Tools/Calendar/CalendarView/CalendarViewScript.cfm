
<!--- this is causing a complete library to load --->

<cfoutput>

<script language="JavaScript1.2">

	_cf_loadingtexthtml='';
	
	function calendarmonth(date,dir,mde,field,flyfilter) {	
				   	 
	   if (date == "") {
	     date = document.getElementById(field).value 
		 _cf_loadingtexthtml='';	 
	   }
	   
	   if (flyfilter) {
	      document.getElementById('cellconditionfly').value = flyfilter		 		  
	   }	   	   			    
	  	   
	   cellfn	     = document.getElementById('cellfunction').value;	   		 	  
	   cellw         = document.getElementById('cellwidth').value;
	   cellh         = document.getElementById('cellheight').value;	   
	   fieldh        = document.getElementById('cellfieldname').value;	   
	   condition     = document.getElementById('cellcondition').value;	 
	    	
	   <!--- not sure if this is needed --->
	   conditionurl  = document.getElementById('cellconditionurl').value;	   	
	   conditionfly  = document.getElementById('cellconditionfly').value;
	   
	   preparation   = document.getElementById('cellpreparation').value;	  
	   vcontent      = document.getElementById('cellcontent').value;	 
	   path          = document.getElementById('cellrelativepath').value;	 
	   targetid      = document.getElementById('celltargetid').value;	  	   
	   target        = document.getElementById('celltarget').value;	 	     	   
	   range         = document.getElementById('celldaterange').value;	
	   isDisabled    = document.getElementById('cellIsDisabled').value;
	   mode          = document.getElementById('mode').value;
	   showToday     = document.getElementById('showToday').value;
	   showPrint     = document.getElementById('showPrint').value;
	   showRefresh   = document.getElementById('showRefresh').value;
	   
	   if (mode == "picker") {	
	   	   _cf_loadingtexthtml='';	  
	   	   ptoken.navigate('#SESSION.root#/tools/calendar/CalendarView/CalendarViewPicker.cfm?pfunction='+cellfn+'&fieldname='+fieldh+'&daterange='+range+'&cellw='+cellw+'&cellh='+cellh+'&'+condition+'&condition='+conditionurl+'&preparation='+preparation+'&content='+vcontent+'&relativepath='+path+'&target='+target+'&targetid='+targetid+'&selecteddate='+date+'&direction='+dir+'&isDisabled='+isDisabled,'calendarcontent');	
	   } else {	 	     
	       _cf_loadingtexthtml='';		 			   
		   window['__calendarCB'] = function(){ $('##calendarcontent').fadeIn(500); };
		   $('##calendarcontent').fadeOut(250);		   		   
	       ptoken.navigate('#SESSION.root#/tools/calendar/CalendarView/CalendarViewContent.cfm?pfunction='+cellfn+'&fieldname='+fieldh+'&daterange='+range+'&cellw='+cellw+'&cellh='+cellh+'&'+condition+'&condition='+conditionurl+'&'+conditionfly+'&preparation='+preparation+'&content='+vcontent+'&relativepath='+path+'&target='+target+'&targetid='+targetid+'&selecteddate='+date+'&direction='+dir+'&isDisabled='+isDisabled,'calendarcontent', '__calendarCB');		
	   }
	   	   
	   if (document.getElementById('divCalendarViewMonthMenu')) {	        
			_cf_loadingtexthtml='';				
	   		ptoken.navigate('#SESSION.root#/tools/calendar/CalendarView/CalendarViewMonthMenu.cfm?cellwidth='+cellw+'&pdate='+date+'&showToday='+showToday+'&showRefresh='+showRefresh+'&showPrint='+showPrint,'divCalendarViewMonthMenu');
	   }
		
	}
	
	// refreshes the calendar cell		
	function calendarrefresh(t,dte) {		    
	    vcontent      = document.getElementById('cellcontent').value;		
		condition     = document.getElementById('cellcondition').value;
		conditionfly  = document.getElementById('cellconditionfly').value; 
	    cf_loadingtexthtml='';	 	    		   
	    ptoken.navigate('#SESSION.root#/'+vcontent+'?'+condition+'&'+conditionfly+'&calendardate='+dte,'calendarday_'+t)  				   	    	
		// refreshes the content 		
		calendardetail(dte)		
		_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";		
	}
	
	// refreshes the calendar cell		
	function calendarrefreshonly(t,dte,size) {		    
	    vcontent      = document.getElementById('cellcontent').value;		
		condition     = document.getElementById('cellcondition').value;
		conditionfly  = document.getElementById('cellconditionfly').value; 
	    cf_loadingtexthtml='';	 	   
		
		 if (size = 'undefined') {
		 		 
		   try { 		   
		   	 if ($('##mybox_borderCENTER').is(':visible')) {
			 	size = 'small'
			    } else  { size = 'full'  }			 
				
			 } catch(e) { size = 'small' }
		 
		 }	
						   
	    ptoken.navigate('#SESSION.root#/'+vcontent+'?'+condition+'&'+conditionfly+'&calendardate='+dte+'&size='+size,'calendarday_'+t)  				   	   		
	}
	
	// refreshes the target content for a data 		
	function calendardetail(dte,size) { 	
		    	
		 if (size = 'undefined') {
		 		 
		   try { 		   
		   	 if ($('##mybox_borderCENTER').is(':visible')) {
			 	size = 'small'
			    } else  { size = 'full'  }			 
				
			 } catch(e) { size = 'small' }
		 
		 }		
		 				 				 
		 ptoken.navigate('#session.root#/tools/Calendar/CalendarView/applyCalendarDate.cfm?dte='+dte,'calendarprocess')							 
		 target        = document.getElementById('celltarget').value;		
		 condition     = document.getElementById('cellcondition').value;	
		 conditionfly  = document.getElementById('cellconditionfly').value; 	 
		 
		 if (target != "") {
		    _cf_loadingtexthtml='';	
			ptoken.navigate('#SESSION.root#/'+target+'?'+condition+'&'+conditionfly+'&selecteddate='+dte+'&size='+size,'calendartarget')	 	
		 }		 	
		 		 		 
		 menuleftdate   = document.getElementById('celltargetleftdate').value;
		 condition      = document.getElementById('cellcondition').value;	 	 
		 
		 if (menuleftdate != '') {		
		    _cf_loadingtexthtml='';	
			ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/'+menuleftdate+'?'+condition+'&'+conditionfly+'&selecteddate='+dte,'targetleftdate')			
		 }	
		// Prosis.busy('yes') 		 
	  	 // _cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>"
		 
		}	
	
	function calselected (t,dte,field,scriptname) {
		    		
	    document.getElementById(field).value = dte;
		if (scriptname != "") {
		  window[scriptname](dte);	 
		}
		var i = 0;
		while (i<32) {
			try { document.getElementById('cal'+i).style.backgroundColor=''; } catch(e){}
		  i++;
		  }		  
		 t.style.backgroundColor='FBF9AA';		 
		}		
			
	function hlx(t,d) {
		//FBF9AA = rgb(251, 249, 170)
		if(t.style.backgroundColor != 'rgb(251, 249, 170)') {
			if (d == true) {
				t.style.backgroundColor='eef6ff'
			} else {
				t.style.backgroundColor='' }				
		};
	}
		
	function calendarJumpTo() {
		var vlink = '#session.root#/Tools/Calendar/CalendarView/CalendarViewJumpTo.cfm';
		try {
			ProsisUI.closeWindow('__prosis_calendarJumpTo');
		}catch(e){}		
		ProsisUI.createWindow('__prosis_calendarJumpTo','Jump To',vlink,{height:390,width:320,modal:true,resizable:false,closable:true,center:true});
	}
	
	function calendarToday() {
		calendarDoJumpTo("#dateFormat(now(),'#client.dateFormatShow#')#");
	}
	
	function calendarDoJumpTo(date) {		
		if (document.getElementById('divGotoPriorMonths')) { ptoken.navigate('#SESSION.root#/tools/calendar/CalendarView/CalendarViewGoMonth.cfm?name=gotoPriorMonths&date='+date+'&type=prior', 'divGotoPriorMonths'); }
	    if (document.getElementById('divGotoNextMonths')) { ptoken.navigate('#SESSION.root#/tools/calendar/CalendarView/CalendarViewGoMonth.cfm?name=gotoNextMonths&date='+date+'&type=next', 'divGotoNextMonths'); }
		calendarmonth(date,'jump','standard','seldate');		
		try { ProsisUI.closeWindow('__prosis_calendarJumpTo'); }catch(e){}
	}

</script>

</cfoutput>