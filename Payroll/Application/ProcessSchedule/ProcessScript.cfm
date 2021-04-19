
<cf_dialogProcurement>
<cf_menuscript>

<cfajaximport tags="cfdiv">

<cfoutput>

	<cf_ajaxRequest>
	
		<script>
		
		w = #CLIENT.width# - 55
		h = #CLIENT.height# - 120
			
		function recap(id) {
		    ptoken.open("../../Inquiry/Entitlement/ControlView.cfm?id2="+id  , "_blank");	 
		}
			
		function more(sch) {
		
			se = document.getElementsByName(sch)
			count=0
			
			while (se[count]) {		  
			   if (se[count].className == "hide navigation_row") {
				   se[count].className = "regular navigation_row"
			  } else {	   
			     se[count].className = "hide navigation_row"
			  }		   
			   count++
			   }
			}	
		
		function check(id) {	
		    se = document.getElementById("cd"+id)
			se.className = "regular"	
			url = "CalculationCheck.cfm?id="+id
			ptoken.navigate(url,'ci'+id ) 	
		}
	
		 function checkBalances(id){
		  	se = document.getElementById("cd"+id)
			se.className = "regular"
		  	ptoken.navigate('ScheduleCheck.cfm?currentCalcId='+id,'ci'+id)
		  }
					
		function del(id) {
		
		    if (confirm("Do you want to remove this calculation ?")) {  Prosis.busy('yes')
		        ptoken.navigate('CalculationDelete.cfm?id='+id,'ci'+id) }
				return false		   
		}	
				
		function slip(box,pay,sch,mis,per) {
		
			 se = document.getElementById("d"+box)
			 icM  = document.getElementById(box+"Min")
		     icE  = document.getElementById(box+"Exp")
			 if (se.className == "regular") {
			    se.className = "hide"
				icE.className = "regular";
	  	        icM.className = "hide";
				
			 } else {
				 icM.className = "regular";
		         icE.className = "hide";
				 url = "#SESSION.root#/Payroll/Application/Payroll/SalarySlip.cfm?ts="+new Date().getTime()+
			       "&id="+per+
				   "&paymentdate="+pay+
				   "&salaryschedule="+sch+
				   "&mission="+mis		   
	    
				AjaxRequest.get({
			        'url':url,
		    	    'onSuccess':function(req){ 
			    	document.getElementById("i"+box).innerHTML = req.responseText;	
					se.className = "regular"					
					},
					'onError':function(req) { 
					document.getElementById("i"+box).innerHTML = req.responseText;
					se.className = "regular"
					}	
		    		 });	
		     	}	
		}	
		
		<!--- batch --->
		function calc() {   
	         ProsisUI.createWindow('executetask', 'Payroll Calculation Batch', '',{x:100,y:100,height:570,width:560,closable:false,modal:true,center:true})	
			 ptoken.navigate('../Calculation/CalculationProcessExecute.cfm?mission=#URL.mission#','executetask')
		}
		
		<!--- final payment --->
		function calcperson(selectedid,contractid,mis,mode) {	
	         ProsisUI.createWindow('executetask', 'Final Payment Calculation', '',{x:100,y:100,height:570,width:560,closable:false,modal:true,center:true})	
			 ptoken.navigate('../Calculation/CalculationProcessExecuteFinal.cfm?mode='+mode+'&selectedid='+selectedid+'&contractid='+contractid+'&mission=#URL.mission#','executetask')
		}				
		
		<!--- manual process --->		
		function payrollprocess(processno,personno,enforce,sel,mde) {
					
			 document.getElementById("submit").className = "hide"	
			 		
			 if (sel == '') {
				    		
				 se = document.getElementsByName("calculate")
				 var selected = ""
				 var count = 0
				 while (se[count]) {
				    if (se[count].checked == true) {
		     		  if (selected == '') { 
				         selected = se[count].value
		    		  } else { 
			    	     selected = selected+","+se[count].value}
		    		  }		
			     	 count++
					}
				
			 } else { selected = sel }
			
			 <cfif getAdministrator("*") eq "1">				 
			 ptoken.open('../Calculation/CalculationProcess.cfm?mode='+mde+'&processno='+processno+'&mission=#URL.mission#&persono='+personno+'&enforce='+enforce+'&selectedid='+selected,'_blank')			
			 <cfelse>
			 ptoken.navigate('../Calculation/CalculationProcess.cfm?mode='+mde+'&processno='+processno+'&mission=#URL.mission#&persono='+personno+'&enforce='+enforce+'&selectedid='+selected,'runbox') 		 										
			 </cfif>
			 showprogresscalculate(processno)		 
					 
		} 
		
		function showprogresscalculate(processno) {
	         ptoken.navigate('../Calculation/CalculationProcessProgress.cfm?processno='+processno,'progressbox')
	    }
	
		function stopprogress() {
			 clearInterval ( prg );
		}	 
		
		function lock(calculationid,st) {   
	         ProsisUI.createWindow('executetask', 'Batch Processing', '',{x:100,y:100,height:570,width:560,closable:false,modal:true,center:true})	
			 ptoken.navigate('../LockPayroll/CalculationLockExecute.cfm?mission=#URL.mission#&calculationid='+calculationid+'&actionstatus='+st,'executetask')
		}
			
		function showprogresslock(processno,processclass) {
	         ptoken.navigate('../LockPayroll/CalculationLockProgress.cfm?processno='+processno,'progressbox')
	    }
		
		function unlock(id) {
		
			if (confirm("Do you really want to unlock this month and open the payroll for settlement adjustments ?")) {	
			 ptoken.navigate('../LockPayroll/CalculationLockUndo.cfm?id='+id,'st'+id)
			}	
			return false	   
		}			
		
		function payrolllock(processno,calculationid,st) {	
			
			 <cfif getAdministrator("*") eq '0'>		
			 ptoken.navigate('../LockPayroll/CalculationLockGo.cfm?processno='+processno+'&calculationid='+calculationid+'&actionstatus='+st,'runbox') 		 							
			 <cfelse>
			 ptoken.open('../LockPayroll/CalculationLockGo.cfm?processno='+processno+'&calculationid='+calculationid+'&actionstatus='+st,'_blank')
			 </cfif>
			 showprogresslock(processno)
					 
		} 	
		
		function scheduleedit(id1) {
	    	 ptoken.open('../../Maintenance/SalarySchedule/ScheduleEdit.cfm?idmenu=&id1=' + id1, '_blank')
		}		
						
	</script>	

</cfoutput>
