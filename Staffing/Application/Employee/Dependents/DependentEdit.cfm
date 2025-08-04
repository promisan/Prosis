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

<cfparam name="url.mycl"   default="0">  <!--- if the screen is opened from the workflow my cleanrances inbox --->

<cfajaximport>
<cf_CalendarScript>

<cfparam name="url.action" default="0">

<cf_tl id="Edit family member" var="1">

<cfif url.action eq "1">
	
	<cf_screentop height="100%" label="#lt_text#" html="No" scroll="Yes" jquery="Yes" layout="webapp" menuaccess="context">
	
<cfelseif url.action eq "Contract">

	<cf_screentop height="100%" close="parent.ProsisUI.closeWindow('mydependent',true)" html="No" jquery="Yes" bannerforce="yes" label="Edit Dependent" scroll="Yes" layout="webapp" banner="blue">
	
<cfelse>	

    <cfif url.mycl eq "0">

	    <cf_screentop height="100%" label="Edit Dependent" html="No" scroll="Yes" layout="webapp" jquery="Yes" menuaccess="context">
		
		<cfinclude template="../PersonViewHeaderToggle.cfm">
		
		<table width="98%" align="center" cellspacing="0" cellpadding="0">	
		    <tr><td class="line"></td></tr>	
			<tr><td align="center" style="font-weight:200;font-size:20px;height:45" class="labelmedium" style="height:20px">Modify Dependent Information or Entitlements</td></tr>
			<tr><td class="line"></td></tr>
		</table>	
		
	<cfelse>
	
		<cf_screentop height="100%" label="Edit Dependent" html="Yes" scroll="Yes" layout="webapp" jquery="Yes" menuaccess="context">
		
		<cfinclude template="../PersonViewHeaderToggle.cfm">		
	
	</cfif>	
	
</cfif>

<cf_actionListingScript>
<cf_FileLibraryScript>
						
<cfoutput>	
		<input type="hidden" name="workflowlink_#URL.ID1#"  id="workflowlink_#URL.ID1#" value="EmployeeDependentWorkflow.cfm">		   
</cfoutput>	   

<cfif url.action eq "1">
	<body bgcolor="ffffff">
<cfelse>
	<body bgcolor="#FFFFFF">
</cfif>

<cf_dialogPosition>

<cfoutput>
<cf_tl id="Do you want to remove this dependent" var="1">
<cf_tl id="Add" var="lblAddNewLine">
<cf_tl id="Remove New" var="lblRemoveNewLine">

<script>

	function sh(ln,fld){
		    	   
	 	 fld1 = document.getElementsByName('SalaryTrigger'+ln);  	 
		 fld2 = document.getElementsByName('DateEffective'+ln);		
		 fld3 = document.getElementsByName('DateExpiration'+ln);
		 fld4 = document.getElementsByName('Remarks'+ln);
		 fld5 = document.getElementsByName('Group'+ln);
		 
		 if (fld != false){
		 	$('.clsNewLineBtn_'+ln).show();
		 } else {
			$('.clsNewLineBtn_'+ln).hide();
		 }

		 cnt = 0;
		 
		 if (fld == false) {
		 
		 	 if (confirm("Removing entitlements might affect already processed payroll entitlements.\n\n Are you really sure you want to do this ?")) {	
			 	 process = 1				 
			 } else {
			 	process = 0				
				document.getElementById(ln).checked = true				
			 }	
			 
		} else {
		  	process = 1			
		}				 
		 		 
		while (fld1[cnt]) {
		 			 	 	 	 		 	
			 if (fld != false){
			 		
				 fld1[cnt].className = "regular";
				 // fld2[0].value = "#Dateformat(now(), CLIENT.DateFormatShow)#"
				 fld2[cnt].className = "regular";
				 // fld3[0].value = "#Dateformat(now(), CLIENT.DateFormatShow)#"
				 fld3[cnt].className = "regular";	
				 fld4[cnt].className = "regular";
				 fld5[cnt].className = "regular";
				 
			 } else {	
			 
			     if (process == 1) {
			     						
					 fld1[cnt].className = "hide";	
					 fld2[cnt].className = "hide";		
					 fld3[cnt].className = "hide";	 
					 fld4[cnt].className = "hide";
					 fld5[cnt].className = "hide";	
					 					
				 }							
			 }
		 
		 cnt++
		 
		 } 
	}
   
	function ask() {
		if (confirm("#lt_text# ?")) {	
		Prosis.busy('yes')
		return true 	
		}	
		return false	
	}	 

	function goback(source) {
	   if (source == 'entitlement') {
		ptoken.location('#session.root#/Staffing/Application/Employee/Entitlement/EmployeeEntitlement.cfm?ID=#url.id#&systemfunctionid=#url.systemfunctionid#')
		} else {
		ptoken.location('#session.root#/Staffing/Application/Employee/Dependents/EmployeeDependent.cfm?ID=#url.id#&systemfunctionid=#url.systemfunctionid#')
		}
	}

	function toggleNewLine(tag) {
		if($('.clsNewLine_'+tag).is(":visible")) {
			$('.clsNewLine_'+tag).hide();
			$('.clsNewLineBtn_'+tag+'b a').html("[ #lblAddNewLine# ]");
		} else {
			$('.clsNewLine_'+tag).show();
			$('.clsNewLineBtn_'+tag+'b a').html("[ #lblRemoveNewLine# ]");
		}
		$('##DateEffective'+tag+'_0').val('');
		$('##DateExpiration'+tag+'_0').val('');
	}
  
</script>

</cfoutput>

<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   * 
    FROM     PersonDependent
	WHERE    DependentId = '#URL.ID1#' 
</cfquery>

<cfif Get.recordcount eq "0">

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td align="center" class="labellarge" style="height:20px">Problem, record does no longer exist in the database</td></tr>
	
	</table>
	
	<cfquery name="Reset" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE   OrganizationObject
		WHERE     ObjectKeyValue4 = '#URL.ID1#'
	</cfquery>

<cfelse>

<!--- 
IMPORTANT status info : 
status = 0 : initial workflow status, change can be made
status = 1 : during the actionstatus = 1 reserved for workflow, people can NOT make changes, but only process the approval
once the status = 2, they can change but a new workflow will be initiated.
status = 2 : can be changed but a new workflow will be initiated
--->

<!--- check for active workflow --->  
<cf_wfActive entitycode="Dependent" objectkeyvalue4="#url.id1#">	

<cfif (get.actionStatus eq "1"  and wfStatus eq "Open") <!--- dependent document is part of a contrsct amendment --->
      
	   or (get.ActionStatus eq "2" and wfStatus eq "Open")   <!--- document is still pending completion in the wf processing --->
      
	   or url.action eq "1"    <!---access through PA screen --->
	   or url.mycl eq "1">     <!---access through wf --->	  
	  	  
	  <cfset mode = "view">
	  
<cfelse>

	  <cfset mode = "edit">	  
	  <!--- any real change will result in a new record --->
	  
</cfif>

<cfparam name="Contract.ContractId" default="00000000-0000-0000-0000-000000000000">
<cfparam name="URL.Contractid" default="#Contract.ContractId#">

<table width="100%" align="center" class="formpadding">

  <tr class="hide">
  		<td><iframe name="processform" id="processform" width="100%" height="80"></iframe></td>
  </tr>
  
  <cfif get.actionStatus eq "9" or get.actionStatus eq "8">
	<tr><td></td></tr>	
	<tr bgcolor="FFFF00"><td style="border:1px solid silver" class="labelmedium" colspan="3" align="center">Attention, this record is no longer applicable or effective</font></td></tr>
	
  <cfelse>
 
	 <cfif url.action eq "1">
	 
	 	<tr><td></td></tr>
		<tr><td style="border:1px solid silver" class="labelmedium" colspan="3" align="center">Attention, this record currently applicable and effective</font></td></tr>
		
	</cfif>	
			
  </cfif>	
  
  <tr><td style="height:100%" valign="top">
    
  <cfform action="DependentEditSubmit.cfm?action=#url.action#" target="processform" method="POST" name="DependentEdit">
    
	<cfoutput>
	    <input type="hidden" name="PersonNo"    value="#get.PersonNo#">
		<input type="hidden" name="DependentId" value="#URL.ID1#">
		<input type="hidden" name="ContractId"  value="#URL.Contractid#">
	</cfoutput>

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	  
	  <cfif url.action eq "0">

		  <tr>
		    <td width="100%" height="22" align="left" valign="middle" style="font-weight:200;padding-left:22px;font-size:26px" class="labellarge" bgcolor="fafafa">
			<cfoutput>
	    		<cf_tl id="Change Dependent">
			</cfoutput>
		    </td>
		  </tr> 	
		  
	  </cfif>
	  
	  <!--- removed this cancel button as it was cancelling too much here which is better controlled through the workflow.
	  19/4/2018 --->
	  
	 	  
	  <cfif url.action eq "1" and get.actionStatus eq "0" and getAdministrator("*") eq "1">
	
		<tr>
		
		<td colspan="3" align="left">
			
			<cf_tl id="Purge Action" var="1">
			<cfoutput>
				<input class="button10g"  style="width:110" type="submit" name="Delete" value="<cfoutput>#lt_text#</cfoutput>">
			</cfoutput>
					
		</td></tr>
						
	  </cfif>
	  	       
	  <tr class="line">
	    <td width="100%">
		
	    <table border="0" cellpadding="0" cellspacing="0" width="96%" align="center" class="formspacing">
				 
		 <TR bgcolor="ffffff" style="height:30px" class="line">
		 
		  <cfif mode eq "view">
		  
		  	<td class="labelmedium" style="height:20px" height="23"><cf_tl id="Action">:</td>		 
			<td>
		  	  
			    <table cellspacing="0" cellpadding="0">
				<tr class="labelmedium"><td style="font-size:15px;height:20px">
			  
				  <cfquery name="pAction" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   Ref_Action
						WHERE  ActionCode    = '#get.ActionCode#' 								
				  </cfquery>
			  
				  <cfoutput><b>#pAction.Description#</cfoutput>
				  
				  </td>
				  
				  <td height="29" style="padding-left:20px;font-size:13px;height:20px;padding-right:10px">|</td>	
				  										 
		  		  <td style="padding-left:6px;font-size:15px;height:20px"> 	
																	
						<cfquery name="GroupList" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    SELECT *
						    FROM   Ref_PersonGroupList
							WHERE  GroupCode     = '#get.GroupCode#'
							AND    GroupListCode = '#get.GroupListCode#' 
						</cfquery>				
						<b>
						<cfif GroupList.description neq "">
							<cf_tl id="#GroupList.Description#">
						<cfelse>
							<cf_tl id="not applicable">
						</cfif>				
								
				   </td>									
							
			       <td height="29" style="padding-left:20px;font-size:13px;height:20px;padding-right:10px"><cf_tl id="Effective">:</td>	
				   				  			  			  			  
				  <td style="padding-left:6px;font-size:15px;height:20px">
				  			  
				  <cfif get.actionStatus eq "0">
				  			  
	                   <cfquery name="PendingContract" 
						 datasource="AppsEmployee"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							 SELECT   PC.*, ActionDocumentNo
							 FROM     PersonContract PC,  EmployeeAction PA
							 WHERE    PC.PersonNo         = '#get.PersonNo#'
							 AND      PC.Contractid       = PA.ActionSourceId 
							 AND      PC.ActionStatus     = '0'			
							 and      PC.HistoricContract = '0'		 
						</cfquery>
								
						<cfif PendingContract.recordcount eq "0">	
							
							<cfoutput>
							<input type = "hidden" 
							       name     = "DateEffective" 
								   id       = "DateEffective" 
								   value    = "#Dateformat(get.DateEffective, CLIENT.DateFormatShow)#">
								   		 
							  #Dateformat(get.DateEffective, CLIENT.DateFormatShow)#
							  
							  </cfoutput>
							 											
						<cfelse>
													
							<cfoutput>
								<input type = "hidden" 
							       name     = "DateEffective" 
								   id       = "DateEffective" 
								   value    = "#Dateformat(PendingContract.DateEffective, CLIENT.DateFormatShow)#">
								   <b>#Dateformat(PendingContract.DateEffective, CLIENT.DateFormatShow)# <font color="FF0000">[open contract]</font>	
							</cfoutput>
										
						</cfif>
									
					<cfelse>
					
						<cfoutput>
						&nbsp;[#Dateformat(get.DateEffective, CLIENT.DateFormatShow)#]
						</cfoutput>
									
					</cfif>		
					
					</td>
					</tr>
					</table>		

		  <cfelse>		
		  
		  		 <td class="labelmedium" style="height:20px" height="24"><cf_tl id="Effective">:</td>
		 
				 <td>
		  		  
		  	      <script language="JavaScript">
				  
					 function actionprocess(val,id) {
		    
					 	 sv = document.getElementsByName('actionview')
						 se = document.getElementsByName('actionedit')
					     cnt = 0						
					     if (val != '2001') {						   
					   		while (sv[cnt]) { sv[cnt].className = 'regular'; cnt++ }
							cnt = 0
							while (se[cnt]) { se[cnt].className = 'hide'; cnt++ }
						 } else {
						    while (sv[cnt]) { sv[cnt].className = 'hide'; cnt++ }
							cnt = 0
						    while (se[cnt]) { se[cnt].className = 'regular'; cnt++  }
						 }		
						  
					  			 
					 }
			       </script>					
		 
		 		<cfquery name="ActionSel" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   Ref_Action
						WHERE  ActionSource = 'Dependent'	
						AND    (CustomForm is NULL OR CustomForm != 'Insert') 
						AND    ActionCode != '2000'
					</cfquery>
					
					<table cellspacing="0" cellpadding="0">
					<tr class="labelmedium" style="height:20px">
					 
					 <TD style="font-weight:230">
																														 
							<cfquery name="PendingContract" 
							 datasource="AppsEmployee"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								 SELECT   PC.*, ActionDocumentNo
								 FROM     PersonContract PC,  EmployeeAction PA
								 WHERE    PC.PersonNo    = '#get.PersonNo#'
								 AND      PC.Contractid  = PA.ActionSourceId 
								 AND      PC.ActionStatus = '0'			
								 and      PC.HistoricContract = '0'		 
							</cfquery>
							
							<cfif PendingContract.recordcount eq "0">	
								 
								  <cf_intelliCalendarDate9
										FieldName="DateEffective" 
										Default="#Dateformat(Get.DateEffective, CLIENT.DateFormatShow)#"
										AllowBlank="True"
										class="regularxl enterastab">	
										
							<cfelse>
							
									<cfoutput>
									<input type = "hidden" 
									       name="DateEffective" 
										   id="DateEffective" 
										   value="#Dateformat(PendingContract.DateEffective, CLIENT.DateFormatShow)#">
											#Dateformat(PendingContract.DateEffective, CLIENT.DateFormatShow)#	<font color="FF0000"><br>[open contract]</font>
									</cfoutput>
									
							</cfif>
									
								  
					 </td>
					
					<TD style="padding-left:20px" class="labelmedium" style="height:20px"><cf_tl id="Action">:<cf_space spaces="20"></TD>
					
					<td style="padding-left:3px">
																						
					<select id="actioncode" name="actioncode" class="regularxl enterastab" onchange="actionprocess(this.value,'#get.dependentid#')">					    
						<cfoutput query="ActionSel">
							<option value="#ActionCode#" <cfif get.ActionCode eq ActionCode>selected</cfif>>#Description#</option>
						</cfoutput>		
					</select>	
					
					</td>
					
					<td style="padding-left:10px" class="labelmedium" style="height:20px" height="29"><cf_tl id="Reason">:</td>	
					
					<td id="groupfield" name="groupfield" 
					 style="padding-left:3px;"
					 class="labelmedium ccell">						 
					 <cfdiv bind="url:getReason.cfm?actioncode={actioncode}&selected=#get.grouplistcode#" id="groupfield" name="groupfield">				 
				     </td>					
					
					</tr>
					</table>					
					
						
		 </cfif>	
		 
		 </td>
		 
		</TR>	
		 	 
		<cfif get.ActionCode eq "2002" or get.ActionCode eq "2003">		
		  <cfset cv = "regular">
		  <cfset ce = "hide">
		<cfelse>		
		  <cfset ce = "regular">
		  <cfset cv = "hide">
		</cfif>	
		
		<tr><td></td></tr>	
		 		
		<TR>
	    <TD class="labelmedium" style="height:20px"><cf_tl id="Relationship">:<cf_space spaces="32"></TD>
	    <TD width="100%">
		
		    <table cellspacing="0" cellpadding="0">
			<tr class="labelmedium" style="height:20px">
			<td class="<cfoutput>#cv#</cfoutput>" name="actionview">
			
			    <cfoutput>
				   #get.Relationship#
				</cfoutput>
			
			</td>
			
			<td name="actionedit" class="<cfoutput><cfoutput>#ce#</cfoutput></cfoutput>">
		
			    <cfif mode eq "view">
				
				    <cfoutput>
					   #get.Relationship#
					</cfoutput>
				
				<cfelse>							
		
					<cfquery name="Relationship" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * 
					    FROM Ref_Relationship
						ORDER BY ListingOrder
					</cfquery>
						
				  	<select name="Relationship" size="1" class="regularxl enterastab">
					<cfoutput query="Relationship">
					<option value="#Relationship#" <cfif Get.RelationShip eq Relationship>selected</cfif>>
			    		#Description#
					</option>
					</cfoutput>
				    </select>
				
				</cfif>
			
			</td>
			</tr>
			
			</table>
		</TD>
		</TR>		
					
		
					
		
		<TR class="labelmedium" style="height:20px">
	    <TD><cf_tl id="Lastname">:</TD>
	    <TD>
		
		 <table cellspacing="0" cellpadding="0">
			<tr class="labelmedium" style="height:20px">
			<td class="<cfoutput>#cv#</cfoutput>" name="actionview">
			
			 <cfoutput>#Get.LastName#</cfoutput>
			
			</td>
			
			<td name="actionedit" class="<cfoutput>#ce#</cfoutput> labelmedium">
		
			 <cfif mode eq "view">
					
				 <cfoutput>#Get.LastName#</cfoutput>
					
			 <cfelse>
				
		  	     <input type="text" id="lastname" name="Lastname" value="<cfoutput>#Get.LastName#</cfoutput>" size="40" maxlength="40" class="regularxl enterastab">
			
			 </cfif>
			 
			</td>
			</tr>
			</table> 
			
		</TD>
		</TR>		
				
		<TR class="labelmedium" style="height:20px">
	    <TD><cf_tl id="Firstname">:</TD>
	    <TD>
		
		 <table cellspacing="0" cellpadding="0">
			<tr class="labelmedium" style="height:20px">
			<td class="<cfoutput>#cv#</cfoutput>" name="actionview">			
			 <cfoutput>#Get.FirstName#</cfoutput>			
			</td>
			
			<td name="actionedit" class="<cfoutput>#ce#</cfoutput>">	
						
				<cfif mode eq "view">					
					<cfoutput>#Get.FirstName#</cfoutput>					
				<cfelse>			 
				  	<input type="text" id="firstname" name="FirstName" value="<cfoutput>#Get.FirstName#</cfoutput>" size="30" maxlength="30" class="regularxl enterastab">			
				</cfif>
			
			</td>
			</tr>
		 </table>
		 					
		</TD>
		</TR>
						
		<TR class="labelmedium" style="height:20px">
	    <TD><cf_tl id="DOB">:</TD>
	    <TD>
		
		 <table cellspacing="0" cellpadding="0">
			<tr class="labelmedium" style="height:20px">
			<td class="<cfoutput>#cv#</cfoutput>" name="actionview">
			
			<cfoutput>#Dateformat(Get.BirthDate, CLIENT.DateFormatShow)#</cfoutput>
			
			</td>
			
			<td name="actionedit" class="<cfoutput>#ce#</cfoutput>">		
				
			<cfif mode eq "view">
				
				<cfoutput>#Dateformat(Get.BirthDate, CLIENT.DateFormatShow)#</cfoutput>
				
		   <cfelse>		   
		   		
			    <cf_intelliCalendarDate9
					FieldName="BirthDate" 
					Default="#Dateformat(Get.BirthDate, CLIENT.DateFormatShow)#"
					DateValidStart="19200101"	
					class="regularxl"
					AllowBlank="False">
			
			</cfif>	
			
			</td>
			
			</tr>
		</table>	
				
		</TD>
		</TR>	
		
		<TR class="labelmedium" style="height:20px">
		<TD><cfoutput><cf_tl id="PersonNo">:</cfoutput></TD>
		<TD>	
		
		 <table cellspacing="0" cellpadding="0">
			<tr class="labelmedium" style="height:20px">
			<td class="<cfoutput>#cv#</cfoutput>" name="actionview">			
			  <cfoutput><cfif get.DependentPersonNo eq "">N/A<cfelse>#Get.DependentPersonNo#</cfif></cfoutput>			
			</td>
			
			<td name="actionedit" class="<cfoutput>#ce#</cfoutput>">
		 
			  <cfif mode eq "view">		 	
				<cfoutput><cfif get.DependentPersonNo eq "">N/A<cfelse>#Get.DependentPersonNo#</cfif></cfoutput>								
			  <cfelse>
					 	 
				<script language="JavaScript">
				
				function indexblank() {
					document.getElementById("dependentpersonno").value = ""
					}
				
				</script>
				
				<cfoutput>
			
			    	<img src="#SESSION.root#/Images/contract.gif" alt="Select person" name="img0" 
						  onMouseOver="document.img0.src='#SESSION.root#/Images/button.jpg'" 
						  onMouseOut="document.img0.src='#SESSION.root#/Images/contract.gif'"
						  style="cursor: pointer;" alt="" width="16" height="18" border="0" align="absmiddle" 
						  onClick="selectperson('webdialog','dependentpersonno','indexno','lastname','firstname','name','','')"
						  onClick="LocatePerson('webdialog','indexno')">
					  
					<input type="text" id="dependentpersonno" name="dependentpersonno" size="15" maxlength="20" value="#Get.DependentPersonNo#" readonly class="regularxl enterastab" style="text-align:center">
					<cfoutput>
						<img src="#SESSION.root#/images/delete5.gif" alt="" width="12" height="12" border="0" onClick="javascript:indexblank()">
					</cfoutput>
					<input type="hidden" id="indexnono" name="indexnono" size="10" maxlength="20" readonly>
					<input type="hidden" id="name" name="name" size="10" maxlength="20" readonly>
				
				</cfoutput>			
					
			</cfif>
			
			</td>
			</tr>
			</table>
				
		</TD>
		</TR>
		
	    <!--- Field: Gender --->
	    <TR class="labelmedium" style="height:20px">
	    <TD><cf_tl id="Gender">:</TD>
	    <TD>
		
		 <table cellspacing="0" cellpadding="0">
			<tr class="labelmedium" style="height:20px">
			<td class="<cfoutput>#cv#</cfoutput>" name="actionview">			
			<cfoutput>#Get.Gender#</cfoutput>			
			</td>			
			<td name="actionedit" class="<cfoutput>#ce#</cfoutput>">			
			  <cfif mode eq "view">					
					<cfoutput>#Get.Gender#</cfoutput>					
			   <cfelse>			
					<table>
					<tr class="labelmedium" style="height:20px">
					<td><INPUT type="radio" class="radiol" name="Gender" value="M" <cfif Get.Gender eq "M">checked</cfif>></td>
					<td style="padding-left:4px"><cf_tl id="Male"></td>
					<td style="padding-left:7px"><INPUT type="radio" class="radiol" name="Gender" value="F" <cfif Get.Gender eq "F">checked</cfif>></td> 
					<td style="padding-left:4px"><cf_tl id="Female"></td>
					</tr>
					</table>				
				</cfif>				
			</td>
			
			</tr>
		</table>		
			
		</TD>
		</TR>			
				
		<TR class="labelmedium" style="height:20px">
	    <TD><cf_tl id="Beneficiary">:</TD>
	    <TD>
		
		 <table cellspacing="0" cellpadding="0">
			<tr class="labelmedium" style="height:20px">
			<td class="<cfoutput>#cv#</cfoutput>" name="actionview">
			
			<cfquery name="Beneficiary" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * 
					    FROM   Ref_Beneficiary
						WHERE  Code = '#Get.Beneficiary#'
					</cfquery>	
				 
				  <cfoutput>#Beneficiary.Description#</cfoutput>
			
			</td>
			
			<td name="actionedit" class="<cfoutput>#ce#</cfoutput>">	
		
			 <cfif mode eq "view">
			 
				 <cfquery name="Beneficiary" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * 
					    FROM   Ref_Beneficiary
						WHERE  Code = '#Get.Beneficiary#'
					</cfquery>	
				 
				  <cfoutput>#Beneficiary.Description#</cfoutput>
			 
			 <cfelse>
			 
			 	<cfquery name="Beneficiary" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT * 
				    FROM Ref_Beneficiary
				</cfquery>	
			 
			  	<select name="Beneficiary" size="1" class="regularxl">					
				<cfoutput query="Beneficiary">
				<option value="#Code#" <cfif Get.Beneficiary eq code>selected</cfif>>
		    		#Description#
				</option>
				</cfoutput>
			    </select>
				
			</cfif>	
			
			</td>
						
			<td style="padding-left:5px"></td>			
			<TD style="padding-left:20px"><cf_tl id="Lives with staffmember">:</TD>			
			<td class="<cfoutput>#cv#</cfoutput>" style="padding-left:10px" name="actionview">
				<cfif Get.Housing eq "1"><cf_tl id="Yes"><cfelse><cf_tl id="No"></cfif>			
			</td>
			
			<td name="actionedit" class="<cfoutput>#ce#</cfoutput>">	
			
				<cfif mode eq "view">
				
					<cfif Get.Housing eq "1"><cf_tl id="Yes"><cfelse><cf_tl id="No"></cfif>
				
				<cfelse>
				
					<table><tr>
							
					<td style="padding-left:5px"><input type="radio" <cfif Get.Housing eq "1">checked</cfif> name="Housing" value="1"></td>			
					<td class="labelmedium" style="height:20px" style="padding-left:5px"><cf_tl id="Yes"></td>
					<td style="padding-left:5px"><input type="radio" <cfif Get.Housing eq "0">checked</cfif> name="Housing" value="0"></td>			
					<td class="labelmedium" style="height:20px" style="padding-left:5px"><cf_tl id="No"></td>
					
					</tr></table>
				
				</cfif>
			
			</td>
			
			<TD style="padding-left:10px"><cf_tl id="Operational">:</TD>	
			
			<td class="<cfoutput>#cv#</cfoutput>" style="padding-left:10px" name="actionview">
				<cfif Get.Operational eq "1"><cf_tl id="Yes"><cfelse><cf_tl id="No"></cfif>	
			</td>		
						
			<td name="actionedit" class="<cfoutput>#ce#</cfoutput>">	
						
				<cfif mode eq "view">
				
					<cfif Get.Operational eq "1"><cf_tl id="Yes"><cfelse><cf_tl id="No"></cfif>
				
				<cfelse>
				
					<table><tr class="labelmedium" style="height:20px">
							
					<td style="padding-left:5px"><input type="radio" <cfif Get.Operational eq "1">checked</cfif> name="Operational" value="1"></td>			
					<td style="padding-left:5px"><cf_tl id="Yes"></td>
					<td style="padding-left:5px"><input type="radio" <cfif Get.Operational eq "0">checked</cfif> name="Operational" value="0"></td>			
					<td style="padding-left:5px"><cf_tl id="No"></td>					
					</tr></table>
				
				</cfif>
			
			</td>
			
			</tr>
			</table>
			
		</TD>
		</TR>		
						
		<tr class="labelmedium" style="height:20px">
		<TD valign="top" style="padding-top:2px;min-width:200px"><cf_tl id="Remarks">:</TD>
		<TD>
		
			<cfif mode eq "view">
				
				<cfoutput>
				<cfif get.remarks eq "">--<cfelse>#Get.Remarks#</cfif>
				</cfoutput>
				
		    <cfelse>
			
				 <textarea name="Remarks" totlength="300" style="width:100%;height:46;padding:3px;font-size:14px"  onkeyup="return ismaxlength(this)"  class="regular"><cfoutput>#Get.Remarks#</cfoutput></textarea>
			
			</cfif>
			
		</TD>
		</tr>
								
		<cfquery name="Parameter" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
		    FROM     Parameter	
		</cfquery>
				
		<cf_verifyOperational 
		         module    = "Payroll" 
				 Warning   = "No">
		
		<cfif operational eq "1" or Parameter.DependentEntitlement eq "1">	 
						
		<tr class="line">							
			<TD style="height:28px;font-size:18px" colspan="2" class="labelmedium" width="100"><cf_tl id="Entitlements"></TD>			
		</tr>								
				
			<cfloop index="itm" list="Insurance,RateInsurance,Entitlement,Dependent">
												
				<cfquery name="Dependent" 
			     datasource="AppsPayroll" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     SELECT * 
				     FROM   Ref_PayrollTrigger R				 
				  	 WHERE  TriggerGroup     = '#itm#'			
					 AND    TriggerCondition = 'Dependent'
					 
					 AND  (  EXISTS (
							
							<!--- show only components that can be associated to a schedule of the main person to be valid--->
												
								SELECT    'X'
								FROM      SalaryScheduleComponent SL INNER JOIN Ref_PayrollComponent C ON SL.ComponentName = C.Code
							    WHERE     C.SalaryTrigger = R.SalaryTrigger												
								AND       EXISTS (
								                  SELECT  'X'
					                              FROM     Employee.dbo.PersonContract
					                              WHERE    PersonNo        = '#get.PersonNo#' 
												  AND      SalarySchedule  = SL.SalarySchedule
												  AND      ActionStatus IN ('0','1') 
												  
												  UNION 

												  SELECT   'X'
												  FROM     Employee.dbo.PersonContractAdjustment
												  WHERE    PersonNo            = '#get.personno#' 
												  AND      PostSalarySchedule  = SL.SalarySchedule
												  AND      ActionStatus IN ('0','1')
												  
					 							)				  
											  
						 OR	    EXISTS (			
							
									SELECT    'X'
									FROM      PersonDependentEntitlement
									WHERE     PersonNo      = '#get.PersonNo#'
									AND       DependentId   = '#url.id1#'
									AND       SalaryTrigger = R.SalaryTrigger
								)						
								
						)	

						)	
					
					 
					</cfquery>
							
				<cfoutput>
						
				<cfif Dependent.recordcount gte "1">
				
					<cfset tag = left(itm,1)>
							
					<cfquery name="GetEnt" 
				     datasource="AppsPayroll" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     SELECT * 
					     FROM   PersonDependentEntitlement E, Ref_PayrollTrigger T
						 WHERE  E.PersonNo      = '#get.PersonNo#' 
						 AND    E.DependentId   = '#URL.ID1#'
						 AND    E.SalaryTrigger = T.SalaryTrigger
						 AND    TriggerGroup    = '#itm#'
						 <cfif get.actionStatus neq "9">
						 AND    E.Status < '8'
						 </cfif>
						 ORDER BY DateEffective
				    </cfquery>								
														
					<cfif GetEnt.SalaryTrigger eq "" and mode eq "View">
						 <cfset cl = "hide">							 	
					<cfelse>
						 <cfset cl = "regular">						
					</cfif>
					
					<tr class="line" style="height:35px">
															
					<!--- used to determine if something changes in the number of lines --->					
					<input type="hidden" name="lines#tag#"  value="#GetEnt.recordcount#" class="regular">
											
						<td height="100%" valign="top" class="labelmedium" style="min-width:150">
												
							<table style="height:100%">
							<tr>
							
							<td valign="top" style="padding-top:7px">												
							<cfif mode eq "edit">							
							   <input type="checkbox" name="#tag#" id="#tag#b" class="radiol" value="1" <cfif GetEnt.SalaryTrigger neq "">checked</cfif> onClick="sh('#tag#b',this.checked)">
							</cfif>
							</td>
							
							<td class="labelmedium" valign="top" style="min-width:210px;padding-left:10px;padding-top:6px;border-right:1px solid silver">
							
								<cfquery name="getLabel" 
							     datasource="AppsPayroll" 
							     username="#SESSION.login#" 
							     password="#SESSION.dbpw#">
									 SELECT * 
									 FROM   Ref_TriggerGroup
									 WHERE  TriggerGroup = '#itm#'
								</cfquery>
							 
								 <cfif getLabel.TriggerGroupName neq "">
								 	<cf_tl id="#getLabel.TriggerGroupName#">
								 <cfelse>
								 	<cf_tl id="#itm#">
								 </cfif>
							
							</td>
							</tr>
							
							<cfif mode neq "view">
							
								<tr class="clsNewLineBtn_#tag#b" class="labelmedium">
									<td></td>
									<td valign="top" style="padding-left:20px;padding-top:6px;border-right:1px solid silver">
										<cfif GetEnt.recordCount gt 0>
											<a href="javascript:" onclick="toggleNewLine('#tag#');" style="color:##20B6E8;">[ #lblAddNewLine# ]</a>
										</cfif>
									</td>
								</tr>
							
							</cfif>
							
							</table>	
																
					    </td>						
												
						<td colspan="1" valign="top">
						
							<table width="100%">
							
							<!--- -------------- --->
							<!--- existing lines --->
							<!--- -------------- --->
							
							<cfloop query="GetEnt">					
							
									<tr>
								
									<td id="SalaryTrigger#tag#b" name="SalaryTrigger#tag#b" class="labelmedium" style="padding-top:3px;padding-left:5px; min-width:200px;">	
																																														
									 	<cfif mode eq "view">
										 
										 	<cfquery name="List" 
										     datasource="AppsPayroll" 
										     username="#SESSION.login#" 
										     password="#SESSION.dbpw#">
										     SELECT * 
										     FROM   Ref_PayrollTrigger
											 WHERE  SalaryTrigger = '#SalaryTrigger#'				
										    </cfquery>
											
											#List.Description# 
										 
									 	<cfelse>									
																		
									 		<select name="SalaryTrigger#tag#_#currentrow#" size="1" class="regularxl" style="width:200px">
											
												<cfloop query="Dependent">
													<option value="#SalaryTrigger#" <cfif GetEnt.SalaryTrigger eq SalaryTrigger>selected</cfif>>
											    		#Description# 
													</option>
												</cfloop>
												
										    </select>
											
										</cfif>	
									
									</TD>										
									
									<TD name="Group#tag#b" id="Group#tag#b" class="labelmedium" style="padding-top:3px;padding-right:3px;padding-left:4px">
																		
									<cfif mode eq "view">									 
										 											
											#GetEnt.EntitlementGroup# 
											
									<cfelse>
									
										<table width="100%">
										<tr>
										<td style="min-width:210px">
											
										<cfdiv bind="url:getEntitlementGroup.cfm?tag=#tag#&salarytrigger={SalaryTrigger#tag#_#currentrow#}&id=#Get.PersonNo#&selected=" bindonload="No">
						
										  <cfset url.tag           = "#tag#_#currentrow#">
										  <cfset url.salarytrigger = GetEnt.SalaryTrigger>
										  <cfset url.selected      = GetEnt.EntitlementGroup>
										  <cfset url.id      	   = Get.PersonNo>
										  									  
										  <cfinclude template="getEntitlementGroup.cfm">													   	
										
										</cfdiv>
										
										 </td>
					  									    
										 <cfif itm eq "Insurance">
										 <td style="min-width:46px" ><cf_tl id="Subsidy"></td>
										 <td style="padding-top:3px;padding-left:5px;padding-right:3px;min-width:26px">
									     <input type="checkbox" style="cursor:pointer;height:19px;width:19px;" title="If not CHECKED no subsidy is calculated" name="EntitlementSubsidy#tag#_#currentrow#" <cfif GetEnt.EntitlementSubsidy eq "1">checked</cfif> value="1">
										 </td>
										 <cfelse>
										 <td align="right" style="padding-top:3px;padding-left:3px;padding-right:3px;min-width:72px">
									  	  <input type="hidden" name="EntitlementSubsidy#tag#_#currentrow#" value="1">
										  </td>
										 </cfif>
									     
					  
									  </tr></table> 
									
									</cfif>
																		
									<!--- define a group based on the selected entitlement of the trigger as defined in the group field --->
									
									</td>
										
								    <TD class="labelmedium" name="DateEffective#tag#b" id="DateEffective#tag#b" style="padding-top:3px;padding-left:4px">
									
										<cf_space spaces="42">
									
										 <cfif mode eq "view">
										
											#Dateformat(DateEffective, CLIENT.DateFormatShow)#
											
										 <cfelse>	
										 
										  <cf_intelliCalendarDate9
												FieldName="DateEffective#tag#_#currentrow#" 
												Default="#Dateformat(DateEffective, CLIENT.DateFormatShow)#"
												AllowBlank="True"
												Tooltip="Effective"
												class="regularxl">	
											
										  </cfif>
									
									</TD>
									
									<TD class="labelmedium" name="DateExpiration#tag#b" id="DateExpiration#tag#b" style="padding-top:3px;padding-left:4px">
									
										<cf_space spaces="42">
									
										 <cfif mode eq "view">
										
											#Dateformat(DateExpiration, CLIENT.DateFormatShow)#
											
										 <cfelse>	
										 
										  <cf_intelliCalendarDate9
												FieldName="DateExpiration#tag#_#currentrow#" 
												Default="#Dateformat(DateExpiration, CLIENT.DateFormatShow)#"
												AllowBlank="True"
												Tooltip="Expiration"
												class="regularxl">	
											
										  </cfif>
									
									</TD>
									
									<TD class="labelmedium" width="62%" name="Remarks#tag#b" id="Remarks#tag#b" style="padding-top:3px;padding-left:4px">	
									
										 <cfif mode eq "view">										   
										 	#GetEnt.Remarks#											
										 <cfelse>										 
										 	<input type="text" name="Remarks#tag#_#currentrow#" value="#Remarks#" size="30" style="width:96%" maxlength="30" class="regularxl"> 
										 </cfif>
								    	
									</TD>
										
									</tr>							
															
							</cfloop>
							
							<!--- -------------------- --->
							<!--- new line to be added --->
							<!--- -------------------- --->
							
							<cfif mode eq "edit">
								<cfset vShowNewLine = "">
								<cfif GetEnt.recordCount gt 0>
									<cfset vShowNewLine = "display:none;">
								</cfif>
								
								<tr class="<cfoutput>#cl#</cfoutput> clsNewLine_#tag#" style="#vShowNewLine#">
																					
									<td id="SalaryTrigger#tag#b" name="SalaryTrigger#tag#b" style="padding-left:5px;height:30px">																			
									 				
								 		<select name="SalaryTrigger#tag#_0" size="1" class="regularxl" style="width:200px">
											<cfloop query="Dependent">
												<option value="#SalaryTrigger#" <cfif GetEnt.SalaryTrigger eq SalaryTrigger>selected</cfif>>
										    		#Description#
												</option>
											</cfloop>
									    </select>
																			
									</TD>
									
									<td name="Group#tag#b" id="Group#tag#b" style="padding-right:3px;padding-left:4px">
									
									 <table width="100%" border="0">
									 <tr><td style="min-width:210px">
									 
									<cfdiv bind="url:getEntitlementGroup.cfm?tag=#tag#_0&salarytrigger={SalaryTrigger#tag#_0}&id=#Get.PersonNo#&selected=" bindonload="Yes">
					
									  <cfset url.tag           = "#tag#b">
									  <cfset url.salarytrigger = GetEnt.SalaryTrigger>
									  <cfset url.selected      = GetEnt.EntitlementGroup>
									  <cfset url.id      	   = Get.PersonNo>
									  
									  <cfinclude template="getEntitlementGroup.cfm">												   	
									
									</cfdiv>								
													
									  </td>
									  
									  <td style="padding-left:4px;padding-right:3px;min-width:26px">
									 								 
									  <cfif itm eq "Insurance">								     								     									  
										  <input type="checkbox" style="cursor:pointer" name="EntitlementSubsidy#tag#_0" value="1" title="If not CHECKED no subsidy is calculated" checked class="radiol">									  
									  <cfelse>
									  	  <input type="hidden" name="EntitlementSubsidy#tag#_0" value="1">
									  </cfif>
									  </td>
									  
									  </tr></table> 
																	
									<!--- define a group based on the selected entitlement of the trigger as defined in the group field --->
									
									</td>
										
								    <TD name="DateEffective#tag#b" id="DateEffective#tag#b" style="padding-left:4px">
																																 
										  <cf_intelliCalendarDate9
											FieldName="DateEffective#tag#_0" 
											Default=""
											Tooltip="Effective"
											AllowBlank="True"
											class="regularxl">	
											
											<cf_space spaces="42">
																				
									</TD>
									
									<TD name="DateExpiration#tag#b" id="DateExpiration#tag#b" style="padding-left:4px">							
																													 
										  <cf_intelliCalendarDate9
											FieldName="DateExpiration#tag#_0" 
											Default=""
											Tooltip="Expiration"
											AllowBlank="True"
											class="regularxl">	
											
											<cf_space spaces="42">
																				
									</TD>
									
									<TD name="Remarks#tag#b" width="82%" id="Remarks#tag#b" style="padding-left:4px">																														 
										 <input type="text" name="Remarks#tag#_0" value="" size="30" style="width:96%" maxlength="30" class="regularxl"> 																							    	
									</TD>
									
								</tr>												
							
							</cfif>
							
							</table>
						
					  </td>
				  </tr>														
												
				<cfif GetEnt.SalaryTrigger eq "" and mode eq "Edit">
				
			    	<script language="JavaScript">
						
						 cnt = 0
						 fld1 = document.getElementsByName('SalaryTrigger#tag#b')
						 fld2 = document.getElementsByName('DateEffective#tag#b')
						 fld3 = document.getElementsByName('DateExpiration#tag#b')
						 fld4 = document.getElementsByName('Remarks#tag#b')
						 fld5 = document.getElementsByName('Group#tag#b')						 
						 
	 		 			 while (fld1[cnt]) {
								 fld1[cnt].className = "hide" 
								 fld2[cnt].className = "hide" 
								 fld3[cnt].className = "hide" 
								 fld4[cnt].className = "hide" 	
								 fld5[cnt].className = "hide" 							
								 cnt++
							 }
						 
				    </script>
				
				</cfif>
				
			</cfif>
			
			</cfoutput>
			
		  </cfloop>				   		
		
		</cfif>
		
		<cfif mode eq "edit">
							   	
		   <cfinvoke component="Service.Access" 
		    method="employee"  
			personno="#get.PersonNo#" 
			returnvariable="access">
		
			<!--- Note to the file
			
			to edit a closed dependent : status = 1, re-open the workflow again and trigger an update
			status = 0
			Yes : we can consider creating historic workflows if needed		
			--->
			
			<cfoutput>
							 
			 <tr>
			   <td style="padding-top:2px" colspan="4" height="45" align="center">
			  	
			   <cfif url.action eq "Person" or url.action eq "entitlement">			   			   				  
				   <cf_tl id="Back" var="1">
				   <input type="button" name="back" value="#lt_text#" class="button10g" style="width:140px" onClick="goback('#url.action#')">			   
			   </cfif>
			   			
			    <!--- status 0 in wf, status 2 not applicable wf  --->
				
			   <!---			    							
			   <cfif Get.ActionStatus eq "0" or (get.ActionStatus eq "1" and getAdministrator("*") eq "1") or Get.ActionStatus eq "2">			   
			   --->
			   	
				   <!--- was before <cfif access eq "ALL"> --->
				   
				   <cfif getAdministrator("*") eq "1">
					   <cf_tl id="Delete" var="1">						   
					   <input type="submit" name="Delete" value="#lt_text#" style="width:140px" class="button10g" onClick="return ask()">					   
				   </cfif>   
					
					<cfif access eq "EDIT" or access eq "ALL">   
					   <cf_tl id="Save" var="1">						   
					   <input class="button10g" type="submit" name="Submit" style="width:140px" value="#lt_text#">
				   </cfif>
				
				<!--- 
				</cfif>
				--->
				
		       </td>
			 </tr> 
			 			
			</cfoutput>
				 				  
		</cfif>			  
		
		</cfform>			
  				
  <!--- check for wf enabling --->
		
  <!--- check if there are pending personnel actions for this person  --->
						
	<cfquery name="PendingContract" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT  PC.*, ActionDocumentNo
			 FROM    PersonContract PC,  EmployeeAction PA
			 WHERE   PC.PersonNo         = '#get.PersonNo#'
			 AND     PC.Contractid       = PA.ActionSourceId 
			 AND     PC.ActionStatus     = '0'		
			 AND     PC.HistoricContract = '0'					 
	</cfquery>
	
	<cfquery name="PendingSPA" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   PC.*, ActionDocumentNo
			 FROM     PersonContractAdjustment PC,  EmployeeAction PA
			 WHERE    PC.PostAdjustmentId   = PA.ActionSourceId 
			 AND      PC.PersonNo           = '#get.PersonNo#'     
			 AND      PC.ActionStatus       = '0'					 
	</cfquery>
	
	<cfquery name="Action" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT    EA.ActionSource
			FROM      EmployeeActionSource AS EAS INNER JOIN
                      EmployeeAction AS EA ON EAS.ActionDocumentNo = EA.ActionDocumentNo
			WHERE     EAS.ActionSourceId = '#get.DependentId#'			 
	</cfquery>
		
	<cfif (get.ActionStatus eq "9" or Action.ActionSource neq "Dependent") and wfStatus eq "Open">
	
		<!--- finish the workflow --->
		
	<cfelse>	
												
		<cfif (PendingContract.recordcount eq "0" and PendingSPA.recordcount eq "0") or mode eq "view">
			
			<cfif Get.ActionStatus lte "1" or wfStatus eq "Open" or url.action eq "1" or url.mycl eq "1">
																	
				<!--- 0 or 1 means : requires worflow --->
				
				<cf_VerifyOnboard personNo = "#get.PersonNo#">
										
				<cfif Mission neq "">
								
						<cfquery name="CheckMission" 
					 datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT   *
						 FROM     Ref_EntityMission 
						 WHERE    EntityCode     = 'Dependent'  
						 AND      Mission        = '#Mission#' 
					</cfquery>
																									
					<cfif CheckMission.WorkflowEnabled eq "1" and CheckMission.recordcount eq "1">
																									
						<cfquery name="Person" 
							 datasource="AppsEmployee" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								SELECT *
								FROM   Person
								WHERE  PersonNo = '#get.PersonNo#' 
						</cfquery>	
						
						<cfoutput>		
						<tr>					
						  <td colspan="4" id="#url.id1#">
											
						  	<cfset url.ajaxid = URL.ID1>
						    <cfinclude template="EmployeeDependentWorkflow.cfm">
											  
						  </td>
						</tr>
						</cfoutput>
						
					</cfif>	
									
				</cfif>
											
			</cfif> 
			
		</cfif>	
		
     </cfif>		
				
</cfif>	
	
</table>
	
</td></tr>	
 
</table>


