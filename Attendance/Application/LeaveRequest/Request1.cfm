<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfparam name="URL.ID"      default="#CLIENT.personNo#">
<cfparam name="URL.webapp"  default="">
<cfparam name="URL.SRC"     default="SelfService">

<cf_calendarviewscript>
<cf_dialogstaffing>

<cfif URL.Src eq "Manual">

	<cf_screentop height="100" html="No" close="parent.parent.ProsisUI.closeWindow('leave',true)" line="no" banner="gray" label="Record a Leave" layout="webapp" jQuery="yes">

<cfelse>

<cfquery name="Parameter" 
	datasource="AppsInit">
		SELECT * 
		FROM Parameter
		WHERE HostName = '#CGI.HTTP_HOST#'
</cfquery>

<cfoutput>

	<cfif FileExists("#SESSION.rootpath#\custom\logon\#Parameter.ApplicationServer#\php_background.jpg")>
		<cfset BG = "custom/logon/#Parameter.ApplicationServer#/php_background.jpg">
	<cfelse>
		<cfset BG = "">						
	</cfif>
	
</cfoutput>

</cfif>

<cf_ActionListingScript>
<cf_FileLibraryScript>
<cf_menuscript>
				
<cfoutput>

	<script language="JavaScript">
	
		function geteffectivedate(fld) {	 
		    setexpirationdate('dateexpiration',fld.dd+'/'+fld.mm+'/'+fld.yyyy,'1')				
		     console.log('hehe');
  		 	syncDatesEff(fld);
		}
		
		function syncDatesEff(fld) {
			if (fld.dd.toString().length==1)
				fld.dd = '0'+fld.dd;
			if (fld.mm.toString().length==1)
				fld.mm = '0'+fld.mm;

			var deff = fld.dd + '/' + fld.mm + '/' + fld.yyyy;
			var dexp = $('##dateexpiration').val();
			
			if (deff==dexp) {
				$('##_Expiration').hide();
				$('##_EffectiveRange').hide();
				$('##_EffectivePortion').show();		
			} else {
				$('##_Expiration').show();	
				$('##_EffectiveRange').show();
				$('##_EffectivePortion').hide();								
			}	
		}	
		
		function getexpirationdate(fld) {				   		 
		    setexpirationdate('dateexpiration',fld.dd+'/'+fld.mm+'/'+fld.yyyy,'0')	
  		 	syncDatesExp(fld);
		}
		
		 function syncDatesExp(fld) {
			if (fld.dd.toString().length==1)
				fld.dd = '0'+fld.dd;
			if (fld.mm.toString().length==1)
				fld.mm = '0'+fld.mm;

			var dexp = fld.dd + '/' + fld.mm + '/' + fld.yyyy;
			var deff = $('##dateeffective').val();
			
			if (deff==dexp) {
				$('##_Expiration').hide();
				$('##_EffectiveRange').hide();
				$('##_EffectivePortion').show();				
			} else {
				$('##_Expiration').show();	
				$('##_EffectiveRange').show();
				$('##_EffectivePortion').hide();						
				}
		 }			
		
		
		function setexpirationdate(fld,val,mde) {		   
		   fldval = document.getElementById(fld).value				      	  
		   ptoken.navigate('#session.root#/Attendance/Application/LeaveRequest/setExpirationDate.cfm?source=#url.src#&id=#url.id#&mde='+mde+'&fld='+fld+'&val='+fldval+'&selected='+val,fld+'_trigger')		  		  		  		  
		}
								
		function setmydate(fld,val) {			    	 
		    setexpirationdate('dateexpiration',val)			   	   		 
		}
				
		function getinformation(per) {
				
		    tpe = document.getElementById('leavetype').value
			cls = document.getElementById('leavetypeclass').value
			try {	
			lst = document.getElementById('grouplistcode').value
			} catch(e) { lst = '' }				
			eff = document.getElementById('dateeffective').value	
			efm = document.getElementById('dateeffectivefull').value							
			exp = document.getElementById('dateexpiration').value						
			exm = document.getElementById('dateexpirationfull').value	
			
			_cf_loadingtexthtml='';			
			ptoken.navigate('#session.root#/attendance/application/leaveRequest/getBalance.cfm?id='+per+'&leavetype='+tpe+'&leavetypeclass='+cls+'&grouplistcode='+lst+'&effective='+eff+'&effectivefull='+efm+'&expiration='+exp+'&expirationfull='+exm,'balance')		
		}			
	
		function leaveedit(id) {
		    ptoken.location("#SESSION.root#/Staffing/Application/Employee/Leave/EmployeeLeaveEdit.cfm?scope=portal&ID=#URL.ID#&ID1=" + id);
		}
		
		function viewcomments(id) {
		    ptoken.open("#session.root#/Attendance/Application/LeaveRequest/RequestView.cfm?id=" + id);
		}

		function workflowdrill(key,box,mode) {
			
			    se = document.getElementById(box)
				ex = document.getElementById("exp"+key)
				co = document.getElementById("col"+key)
					
				if (se.className == "hide") {		
				   se.className = "regular" 		   
				   if (co) co.className = "regular"
				   if (ex) ex.className = "hide"				  
				   ptoken.navigate('#session.root#/Attendance/Application/LeaveRequest/RequestWorkFlow.cfm?ajaxid='+key,key)		   			  
				} else {  se.className = "hide"
				          if (ex) ex.className = "regular"
				   	      if (co) co.className = "hide" 
			    } 		
		}		
		
		function detail(bx,tpe,cls,act) { 			
			se   = document.getElementById(bx);					 		 
			if (se.className == "hide" || act == "force") {	   	 	     
				 se.className  = "regular";
				 _cf_loadingtexthtml='';	
				 Prosis.busy('yes')
				 url = "#SESSION.root#/Staffing/Application/Employee/Leave/EmployeeBalanceDetail.cfm?id=#URL.ID#&leavetype=" + tpe + "&class=" + cls
				 ptoken.navigate(url,'i'+bx)				
			 } else {		   	    
		    	 se.className  = "hide"
			 }				 		
		  }
												
				  
		function formvalidate() {
			document.leaveform.onsubmit() 
			if( _CF_error_messages.length == 0 ) {
			    Prosis.busy('yes')
           		ptoken.navigate('#session.root#/Attendance/Application/LeaveRequest/RequestSubmit.cfm','result','','','POST','leaveform')
			 }   
		}	 

		function toggleDaysAdditionalInfo(status) {
			if (status) {
				$('.clsDateAdditionalInfo').hide();
			} else {
				$('.clsDateAdditionalInfo').show();
			}
		}
		
		function records(persno) {
			tpe = document.getElementById('filterleavetype').value
			sta = document.getElementById('filterstatus').value
			yea = document.getElementById('filteryear').value
			_cf_loadingtexthtml='';
			Prosis.busy('yes')
			ptoken.navigate('#session.root#/Attendance/Application/LeaveRequest/RequestRecords.cfm?ID=' + persno + '&filterleavetype=' + tpe + '&filterstatus=' + sta + '&filteryear=' + yea,'contentbox1');			
		}
		
		function getreason(persno,tpe,code) {           
		    _cf_loadingtexthtml='';
			ptoken.navigate('#session.root#/Attendance/Application/LeaveRequest/getReason.cfm?ID=' + persno + '&leavetype=' + tpe + '&leaveclass=' + code,'reason');			
		 
		}

</script>
	
</cfoutput>

<cfif URL.ID eq "">

   <cf_message message = "Your account has not been registered for on-line requests. Please consult your administrator"
   return = "back">
   
   <cfabort>

<cfelse>
	
   <cfquery name="Get" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT *
	     FROM Person
		 WHERE PersonNo        = '#URL.ID#' 
   </cfquery> 
   
   <cfif Get.Recordcount eq "0">
   
  	<cf_message message = "Your account has not been registered for on-line requests. Please consult your administrator"
	   return = "back">
   	<cfabort>
   
   </cfif>
     
 	<cfform method="POST" name="leaveform" id="leaveform" style="background-color:white">   	   
	
	   <table width="98%" align="center">
	   	      
	   <tr colspan="2" class="xxhide"><td id="result"></td></td></tr> 	
	   
	   <tr><td colspan="2"  valign="top" style="border: 0px solid gray;">		      	      	 

		   <cfoutput>
			   <input type="hidden" name="LastName"  id="LastName"  value="#Get.LastName#">
			   <input type="hidden" name="FirstName" id="FirstName" value="#Get.FirstName#">
			   <input type="hidden" name="PersonNo"  id="PersonNo"  value="#Get.PersonNo#">
			   <input type="hidden" name="IndexNo"   id="IndexNo"   value="#Get.IndexNo#">			   
			   <input type="hidden" name="Source"    id="Source"    value="#URL.Src#">
		   </cfoutput>
		   
		   <!--- 3. define org unit for which the person is working on the last day of his leave --->

			<cfset dateValue = "">
			<CF_DateConvert Value="#DateFormat('#now()#',CLIENT.DateFormatShow)#">
			<cfset date     = dateValue>			
			
			<cfquery name="OrgUnit" 
				 datasource="AppsEmployee"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT   P.*
					 FROM     PersonAssignment PA, Position P
					 WHERE    PersonNo           = '#URL.ID#'
					 AND      PA.PositionNo      = P.PositionNo
					 AND      PA.DateEffective  <= #date#
					 AND      PA.DateExpiration >= #date#
					 AND      PA.AssignmentStatus IN ('0','1')
					 AND      PA.AssignmentType  = 'Actual'				 
		   </cfquery>	
		   
		   <cfif url.src eq "Manual">
		   
			   <cfquery name="OrgUnit" 
					 datasource="AppsEmployee"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT   TOP 1 P.*
						 FROM     PersonAssignment PA, Position P
						 WHERE    PersonNo           = '#URL.ID#'
						 AND      PA.PositionNo      = P.PositionNo					
						 AND      PA.AssignmentStatus IN ('0','1')
						 AND      PA.AssignmentType  = 'Actual'		
						 ORDER BY PA.DateEffective DESC		 
			   </cfquery>	
		   		   
		   </cfif>
			
		  <cfif orgUnit.recordcount eq "0"> 
	   
		  <table width="100%" height="500">
		  
		  <cfelse>
		  
		  <table width="100%" cellspacing="0" cellpadding="0">
		  
		  </cfif>
		  
		  <tr>
		   
		   <td valign="center" style="padding-left:0px;padding-right:10px">
		 		 
			   <cfif orgUnit.recordcount eq "0">
						  
				   <cf_message message = "Sorry, we can not determine a valid assignment. You can not record a leave request, please contact your administrator."
				      return = "no">		
					<cfabort>		          
				       			  
			   <cfelse>
			   
			   <cfset ctr = "1">
			   
				<!--- top menu --->				
				
				<cfset openmode = "close">				
				
				<cfif openmode eq "close" and url.src neq "manual">
				
					<cfset cl  = "hide">
					<cfset cla = "regular">
					
				<cfelse>
				
					<cfset cl  = "regular">
					<cfset cla = "hide">
				
				</cfif>
			  								  
			   </cfif>	  
			  
		   </td>
			  
		  </tr>
		
		  <cfif src neq "Manual">	  
		 		     
		 	 <tr><td id="log">  
			  
				<table width="100%" height="100%">
					
					<tr><td height="20" valign="top">
					
						<table width="100%" align="center" class="formpadding">		
						
						<tr><td colspan="3">
						
						  <img src="<cfoutput>#session.root#/Images/Logos/Attendance/Leave.png</cfoutput>" style="height:65px;float:left;">
       		               <h1 style="float:left;color:##333333;font-size:28px;font-weight:200;padding-left:5px;padding-top:10px;"><strong> Leave</strong> Information</h1>
				        	
                            <p style="font-weight:350;clear: both; font-size: 15px; margin: 1% 0 0 1%;">Request Annual Leave, Home Leave, submit requests for special and sick leave or review your balances.</p>
        		         						
						</td>
						
						<td rowspan="3" valign="top" style="min-width:370px;padding-top:15px;padding-right:16px" align="right">
									
						
						<cf_calendarView 
						   title           = "Leave"				   
						   relativepath    = "../../../Attendance/Application/LeaveRequest/"					  			    				  
						   content         = "getcontent.cfm"			  
						   target          = ""
						   condition       = "personno=#url.id#"
						   cellwidth       = "47"
						   showjump        = "0"
						   showprint       = "0"
						   showrefresh     = "0"
						   mode            = "picker"
						   cellheight      = "25">
						
						</td>
						
						</tr>						
												
						<tr><td colspan="3" style="padding-left:23px;padding-right:23px">
						
								<table style="width:400px;">
														
								<tr>			
								
									<cfset ht = "48">
									<cfset wd = "48">                             
		                            
									<cf_tl id="Leave records" var="1">
													
									<cf_menutab item       = "1" 
									            iconsrc    = "Logos/Attendance/LeaveRecords.png" 
												iconwidth  = "#wd#" 
												iconheight = "#ht#" 
												class      = "highlight"
												name       = "#lt_text#"
												source     = "#session.root#/Attendance/Application/LeaveRequest/RequestRecords.cfm?id=#url.id#">	
												
									<cf_tl id="Balances" var="1">					
													
									<cf_menutab item       = "2" 
									            iconsrc    = "Logos/Attendance/LeaveBalances.png" 
												iconwidth  = "#wd#" 
												iconheight = "#ht#" 
												name       = "#lt_text#"
												source     = "#SESSION.root#/Staffing/Application/Employee/Leave/LeaveBalances.cfm?webapp=#url.webapp#&id=#url.id#">
									
										
									<!---
									
									<cfquery name="check" 
									 datasource="AppsEmployee"
									 username="#SESSION.login#" 
									 password="#SESSION.dbpw#">
										SELECT  TOP 1 *
										FROM    PersonWork
										WHERE   PersonNo     = '#url.id#'
										AND     CalendarDate = '#dateformat(now(),client.datesql)#'
										AND     TransactionType = '1'
									</cfquery>
									
									<cfif check.recordcount gte "1">
									
									--->
									
										<cf_tl id="Calendar" var="1">	
									
									    <!--- we better check if we have record record for this month --->
										
										<cf_menutab item       = "3" 
										            iconsrc    = "Logos/Attendance/Schedule.png" 
													iconwidth  = "#wd#" 
													iconheight = "#ht#" 
													targetitem = "1"
													name       = "#lt_text#"
													source     = "#SESSION.root#/attendance/application/TimeSheet/CalMonth.cfm?id=#url.id#">	
									
									<!---	
									</cfif>	
									--->
																					
										
								</tr>		
													
							</table>
					
					</td>		
					</tr>
					
					<cfoutput>
						
					<tr>														
							                          							
						<td colspan="3" align="center" valign="top" style="padding-left:6px;padding-right:10px;width:100%;" onclick="personviewtoggle('leave')">
									
							<div id="leavecol"						
								align="absmiddle"
								style="font-weight:200;border-bottom:1px solid silver;cursor:pointer;width: 97%; padding-left:10px;background: ##ffffff;font-size: 18px; padding: 2px 2px 5px;margin: 10px auto 0; text-align: left;" class="#cl#">
								<cf_tl id="Close Request">
								<img width="16" height="16" style="position: relative; top: 2px" src="#Client.VirtualDir#/images/Up3.png"></div>
								
									    
							<div id="leaveexp"					
								align="absmiddle"
								style="font-weight:200;cursor:pointer;width: 97%; background: ##ffffff!important;font-size: 18px;padding: 2px 10px 5px;border-bottom:1px solid ##dddddd;margin: 10px auto 0;text-align: left;"										
								class="#cla#"><font color="0080C0"><cf_tl id="Create new leave request"> <img width="16" height="16" style="left: 8px;top: 2px;position: relative;outline: 1px solid transparent;" src="#Client.VirtualDir#/images/Down3.png"></div>
																											
						</td>	
														
                     </tr>						                     
										
				     <tr>
						<td colspan="4" style="width:97%;clear: both; background: ##ffffff;position: relative;top: -1px;padding: 15px 15px;" id="leaveinfo" class="#cl#">													
						    <cfinclude template="RequestForm.cfm">
						</td>							
                           
						<td id="leaveshort" height="10" class="#cla# labellarge" colspan="4"
						  onclick="personviewtoggle('leave')" style="cursor:pointer;padding-top:8px;padding-left:14px;padding-bottom:3px">	
						</td>
                           							
					</tr>	
					
					 </cfoutput>
					
					<tr><td style="padding-left:20px" colspan="4">
					<table style="width:100%;border:0px solid silver;margin-bottom: 5px">	
						<cf_menucontainer item="1" class="regular">
							  <cf_securediv bind="url:#session.root#/attendance/application/leaveRequest/RequestRecords.cfm?id=#url.id#">
						</cf_menucontainer>
						<cf_menucontainer item="2" class="hide"/>
					</table>					
					</td></tr>
					
					</table>
						
					</td>
						
					</tr>
				
				</table>
									
			    </td>
			 </tr>
			 
		  <cfelse>
		  
		     <tr>
					<td colspan="4" style="width:100%;clear: both; background: ##e5e5e5!important;position: relative;top: -1px;padding: 5px 5px;" id="leaveinfo" class="#cl#">													
						    <cfinclude template="RequestForm.cfm">
					</td>
			 </tr>		
		  	 			 
		  </cfif>	                            
         		  
		  </table>	
		  
	</td></tr>

</table>
</cfform>

</cfif>

