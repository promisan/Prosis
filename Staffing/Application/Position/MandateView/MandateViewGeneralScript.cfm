
<cfoutput>

<script>
		
		function sumpos(org,box,mde) {
		   se = document.getElementById("sumbox"+box)		   
		   if (se.className == "hide") {
			   se.className = "regular"			  
			   ptoken.navigate('#SESSION.root#/Staffing/Application/Position/PositionStatus/PositionStatus.cfm?mde='+mde+'&orgunit='+org,'sum'+box)
		   } else {
			   se.className = "hide"    			   
		   }
		}
		
		function Selected(no,description,fldfunctionno,fldfunctiondescription) {									
			  document.getElementById(fldfunctionno).value = no
			  document.getElementById(fldfunctiondescription).value = description					 
			  ProsisUI.closeWindow('myfunction')
		 }		
		
		function AddAssignment(postno,box) {
		  	ptoken.open("#SESSION.root#/Staffing/Application/Assignment/AssignmentEntry.cfm?box="+box+"&Mission=#URL.Mission#&ID=" + postno + "&Caller=Listing", "_blank", "width=930, height=920, status=yes, toolbar=no, scrollbars=no, resizable=no");
		}
		
		function reloadposition(pos,lay,cls) {           
			  url = "#SESSION.root#/Staffing/Application/Position/MandateView/MandateViewPreparePosition.cfm?header=#url.header#&positionno="+pos+"&lay="+lay+"&class="+cls;	
			  ptoken.navigate(url,'i'+pos)	
		}  
		
		function reloadassignment(box,lay) {	  
		 	  url = "#SESSION.root#/Staffing/Application/Position/MandateView/MandateViewPrepareAssignment.cfm?header=#url.header#&positionno="+box+"&lay="+lay;	
			  ptoken.navigate(url,'i'+box)		
		}  
		
		function reloadForm(page,sort,mandate,layout,act,pdf,header,sel) {
		
			var id      = document.getElementById("id").value;
		    var mission = document.getElementById("mission").value;
			var orgcode = document.getElementById("id1").value;
			var vPage = page;
			var vShowAllRecords = 0;

			if (vPage == 0) {
				vShowAllRecords = 1;
				vPage = 1;
			}

			if (vPage == -1) {
				vShowAllRecords = 0;
				vPage = 1;
			}

			try {
			sel = parent.document.getElementById('selectiondate').value
			} catch(e) {}		
							
			Prosis.busy('yes')				
			ptoken.navigate('#SESSION.root#/Staffing/Application/Position/MandateView/MandateViewList.cfm?header='+header+'&ID='+id+'&ID1='+orgcode+'&mission='+mission+'&mandate=' + mandate + '&ID4=#URL.ID4#&selectiondate=' + sel + '&page=' + vPage + '&sort=' + sort + '&lay=' + layout + '&act=1&pdf=' + pdf + '&showAllRecords=' + vShowAllRecords,'list')			
			
		}
		
		function extend(mis,man) {
		
		    try { ProsisUI.closeWindow('mybox'); } catch(e) {}
			 ProsisUI.createWindow('mybox', 'Extend Assignments', '', {height:500,width:700,modal:false,closable:true,center:true});
			 ptoken.navigate('#SESSION.root#/Staffing/Application/Position/MandateView/MandateExtend.cfm?Mission=#URL.Mission#&MandateNo=#URL.Mandate#','mybox')			    

		}
				
		function extendnow(mis,man) {
			ptoken.navigate('MandateExtendSubmit.cfm?mission='+mis+'&mandateno='+man,'processextension')
		}
	
		function AddVacancy(postno) {
			ProsisUI.createWindow('mydialog', 'Record Recruitment Track', '',{x:100,y:100,height:document.body.clientHeight-90,width:900,modal:true,center:true});	
			ptoken.navigate('#SESSION.root#/Vactrack/Application/Document/DocumentEntry.cfm?mission=#URL.Mission#&ID1='+postno+'&Caller=Listing','mydialog')	
		}
		
		function ShowCandidate(App) {
		   w = #CLIENT.width# - 60;
		   h = #CLIENT.height# - 120;
		   ptoken.open(root + "/Roster/Candidate/Details/PHPView.cfm?ID=" + App + "&mode=Manual", "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
		}
		
		function staffingexcel() {		
			w = #CLIENT.width# - 40;
		    h = #CLIENT.height# - 130;
			window.open("#SESSION.root#/Staffing/Application/Position/MandateView/MandateViewPrepareExcel.cfm?ts="+new Date().getTime(), "staffing");
		}  
		
		function view(unit) {
			parent.window.location = "#SESSION.root#/Staffing/Reporting/PostView/Staffing/PostView.cfm?Mission=#URL.Mission#&Mandate=#URL.Mandate#&Unit=" + unit
		}
		
		function show(par) {
			
			 se1 = document.getElementById(par+"Exp")
			 se2 = document.getElementById(par+"Min")
			 se = document.getElementsByName("g"+par)
			 cnt = 0
			 
			 if (se2.className == "regular") {	 	 
				 se1.className = "regular"
				 se2.className = "hide"	 
				 while (se[cnt])  { se[cnt].className = "hide"; cnt++ }		 		 		 
			 } else  {	 
				 se1.className = "hide"
				 se2.className = "regular"
				 while (se[cnt]) { se[cnt].className = "regular"; cnt++ }		 
			 }	 
			
			}
			
		function more(id,par) {
				 
			 se = document.getElementById(id)
			 se1 = document.getElementById(id+"Exp")
			 se2 = document.getElementById(id+"Min")
			 
			 if (se.className == "regular") {
			 
				 se.className = "hide"
				 se1.className = "show"
				 se2.className = "hide"	 
			 } else {	 
				 se.className = "regular"
				 se2.className = "show"
				 se1.className = "hide"
			 	 
			 	url = "#SESSION.root#/Staffing/Application/Authorization/Staffing/TransactionListing.cfm?positionparentid="+par;	
			    ptoken.navigate(url,'i'+id)		
				
			  }  
			
			}
			
		function refresh(id,act,no) {	

				 row = document.getElementById("row_"+id).value		 
				 url = "#SESSION.root#/Staffing/Application/Position/MandateView/MandateViewMaintainRefresh.cfm?row="+row+"&id="+id+"&act="+act+"&no="+no;		 
				 ptoken.navigate(url,id)	 	   
			}  	
			
		function movePositions(mission,mandate){
		
			 se = document.getElementsByName("position");
			 cnt    = 0;
			 pos    = 0;
			 positions = "";
			 
			 while (se[cnt]) {					 
				  if (se[cnt].checked) {		
				      pos++ 
					  if (positions.length == 0) {
					  	positions = se[cnt].value;
					  } else {
					  	positions = positions + ',' + se[cnt].value; 
					  }					 
				   }	
				   cnt++		  
			 }
			 
			 if (pos == 0) {
			     alert("No postion(s) were selected.") 
			 } else {
			 
			 try { ProsisUI.closeWindow('mybox'); } catch(e) {}
			 ProsisUI.createWindow('mybox', 'Move Positions', '', {height:600,width:980,modal:true,closable:true,center:true});
			 ptoken.navigate('#SESSION.root#/staffing/application/position/PositionParent/MovePositions/MoveForm.cfm?positions='+positions+'&mission='+mission+'&mandateno='+mandate,'mybox')			    
			//	window.open('#SESSION.root#/staffing/application/position/PositionParent/MovePositions/MoveForm.cfm?positions='+positions+'&mission='+mission+'&mandateno='+mandate, 'CopyPositions', 'left=200, top=80, width= 800, height= 600, toolbar=no, status=yes, scrollbars=no, resizable=no')
			 }	
			 
		}
		
		
		function movevalidate() {
			document.moveForm.onsubmit() 
			if( _CF_error_messages.length == 0 ) {
           		ColdFusion.navigate('#session.root#/Staffing/Application/Position/PositionParent/MovePositions/MoveSubmit.cfm','moveprocess','','','POST','moveForm')
			 }   
		}	 
		
	</script>	
	
</cfoutput>	