
<cfajaximport>
<cf_menuscript>

<cfoutput>

	<script language="JavaScript">
	
		function init(persno) {
		    url = "Init/EmployeeBalanceInit.cfm?ID=" + persno +"&Src=Manual"
			ColdFusion.navigate(url,'contentbox2')		    
		}
		
					
		function leave(id) {		   
			parent.ProsisUI.createWindow('leave', 'Leave', '',{x:100,y:100,height:parent.document.body.clientHeight-90,width:parent.document.body.clientWidth-90,modal:true,center:true,resizable:false})    					
			parent.ColdFusion.navigate('#session.root#/Attendance/Application/LeaveRequest/RequestEdit.cfm?ID='+id+'&src=Manual','leave')			
		}
				
		function records(persno) {
		
		    tpe = document.getElementById('filterleavetype').value
			sta = document.getElementById('filterstatus').value		
						
			yr = document.getElementsByName('filteryear')
			yea = ''
			
			i = 0
			
			while (yr[i]) {
			 if (yr[i].checked) {
				 if (yea == '') {
				    yea = yr[i].value
				 } else { 
				    yea = yea+','+yr[i].value
			 	}
			 }	
			 i++
			} 	
										
			_cf_loadingtexthtml='';
			Prosis.busy('yes')
		    ptoken.navigate('Leaverecords.cfm?ID=' + persno + '&filterleavetype=' + tpe + '&filterstatus=' + sta + '&filteryear=' + yea,'contentbox1');
			
		}
		
		function leaveedit(id,mode) {
		    ptoken.location("EmployeeLeaveEdit.cfm?ID=#URL.ID#&ID1=" + id + "&daymode=" + mode);
		}
			
		function calculate(st,cal,tpe,sta) {				  
			_cf_loadingtexthtml='';	
			Prosis.busy('yes')
			ptoken.navigate('LeaveBalances.cfm?mode=balance&balancestatus='+sta+'&ID=#URL.ID#&ID1='+st+'&ID2='+cal+'&LeaveType='+tpe,'contentbox2')		
		}
				
		function detail(bx,tpe,cls,act,sta) { 			
			se   = document.getElementById(bx);					 		 
			if (se.className == "hide" || act == "force") {	   	 	     
				 se.className  = "regular";
				 _cf_loadingtexthtml='';	
				 Prosis.busy('yes')
				 url = "EmployeeBalanceDetail.cfm?id=#URL.ID#&leavetype=" + tpe + "&class=" + cls + "&balancestatus=" + sta
				 ptoken.navigate(url,'i'+bx)				
			 } else {		   	    
		    	 se.className  = "hide"
			 }				 		
		  }
		  
		function  toggleLines(id){
			se = document.getElementsByName(id);
			i = 0
			while (se[i]) {
			if (se[i].style.display == 'none') {
				se[i].style.display = '';
			} else {
				se[i].style.display = 'none';
			}
			i++	
			}			
		}
	
	</script>

</cfoutput>
<style>
    #menu1{border-left: 1px solid #f3f3f3!important;}
    
    #menu1, #menu2, #menu3, #menu4, #menu5 {
	padding: 2px 0 10px !important;
	border-top: 1px solid #f5f5f5 !important;
	border-right: 1px solid #f3f3f3 !important;
	border-bottom: 1px solid #f5f5f5 !important;
	width: 140px !important;
	/*height: 68px;*/
	display: block;
	margin-bottom: 10px;
}
    #menu5{
        border-right: 0!important;
    }
    #menu1_text.labelit,
    #menu2_text.labelit,
    #menu3_text.labelit,
    #menu4_text.labelit,
    #menu5_text.labelit{
        padding: 0!important;
        
    }
</style>
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	
	<tr><td height="20" valign="top" style="padding-left:20px">
	
		<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">		
								
		<cfset ht = "52">
		<cfset wd = "52">  		
	
		<tr>					
							
			<cf_menutab item       = "1" 
			            iconsrc    = "Logos/Attendance/Leave.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						class      = "highlight"
						name       = "Leave Records"
						source     = "Leaverecords.cfm?id=#url.id#">			
							
			<cf_menutab item       = "2" 
			            iconsrc    = "Logos/Attendance/LeaveBalances.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						name       = "Leave Balances"
						source     = "LeaveBalances.cfm?id=#url.id#">
									
			<cf_menutab item       = "3" 
			            iconsrc    = "Logos/Attendance/Calendar.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						targetitem = "1"
						name       = "Calendar"
						source     = "#SESSION.root#/attendance/application/TimeSheet/CalMonth.cfm?id=#url.id#">					
									
				<td width="40%"></td>	
		</tr>
		</table>
		
		</td>
		
	</tr>
		
	<cf_menucontainer item="1" class="regular">
		  <cfinclude template="LeaveRecords.cfm">
	</cf_menucontainer>
	<cf_menucontainer item="2" class="hide"/>

</table>
	
