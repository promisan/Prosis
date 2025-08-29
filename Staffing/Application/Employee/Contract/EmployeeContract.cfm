<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="URL.Order" default="DESC">

<cfset dependentshow = "0">

<cfajaximport tags="cfdiv,cfform">
<cf_actionListingScript>
<cf_FileLibraryScript>
<cf_dialogposition>

<cfset SPAcount = "1">

<!--- ---------------------------------------- --->
<!--- initially populate the PersonGrade table --->
<!--- ---------------------------------------- --->

<cfquery name="Clear" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM PersonGrade	
	WHERE   Source = 'System' 
	AND     PersonNo = '#URL.ID#' 
</cfquery>

<!--- UN specific --->

<cfquery name="ClearManual" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM PersonGrade	
	WHERE   Source = 'Manual' 
	AND     PersonNo = '#URL.ID#'
	AND     DateEffective >= ( SELECT MIN(DateEffective) 
	                           FROM   PersonContract 
							   WHERE  PersonNo = '#url.id#'
							   AND    Mission != 'UNDEF'
							   AND    ActionStatus != '9')
</cfquery>

<cfquery name="Grade" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    DISTINCT PersonNo, DateEffective, ContractLevel, ContractStep
	FROM      PersonContract
	WHERE     ActionStatus <> '9' 
	AND       Mission != 'UNDEF'
	AND       PersonNo = '#URL.ID#'
	ORDER BY  DateEffective
</cfquery>

<cfset lvl = "">
<cfset stp = "">

<cfloop query="Grade">
	
	<cfif lvl neq ContractLevel or stp neq ContractStep>
		
		<cftry>
		
		<cfquery name="Grade" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO PersonGrade
				   (PersonNo, DateEffective, ContractLevel, ContractStep,Source)
			VALUES ('#URL.ID#','#dateeffective#','#contractlevel#','#contractstep#','System')		
		</cfquery>
		
		<cfcatch></cfcatch>
		</cftry>
		
		<cfset lvl = ContractLevel>
		<cfset stp = ContractStep>
	
	</cfif>

</cfloop>

<!--- END UN specific --->

<!--- ---------------------------------------- --->

<cf_screentop height="100%" scroll="Yes" html="No" menuAccess="context" jquery="Yes">

<cfoutput>
	
	<script language="JavaScript">
	
		function contract(persno) {		    
		    ptoken.location('#SESSION.root#/staffing/application/employee/contract/ContractEntry.cfm?ID=' + persno)
		}
		
		function EditContract(persno,id) {
		    ptoken.location('#SESSION.root#/staffing/application/employee/contract/ContractEdit.cfm?ID=' + persno + '&ID1=' + id);
		}
		
		function contractshow(id,status,order) {	 
		    Prosis.busy('yes')   
	    	ptoken.location('#SESSION.root#/staffing/application/employee/contract/EmployeeContract.cfm?id='+id+'&status='+status+'&order='+order)	
		}		
		
		function workflowdrill(key,box,mode) {
		
		    se = document.getElementById(box)
			ex = document.getElementById("exp"+key)			
			co = document.getElementById("col"+key)
				
			if (se.className == "hide") {					
			   se.className = "regular" 	
			      
			   co.className = "regular"
			  
			   ex.className = "hide"	
			   
			   if (mode != "spa") {
				   ptoken.navigate('#SESSION.root#/staffing/application/employee/contract/EmployeeContractWorkflow.cfm?ajaxid='+key,key)		   
			   } else {
			  	   ptoken.navigate('#SESSION.root#/staffing/application/employee/contract/Adjustment/EmployeeContractSPAWorkflow.cfm?ajaxid='+key,key)	
	   		   }
			  
			} else {  se.className = "hide"
			          ex.className = "regular"
			   	      co.className = "hide" 
		    } 		
		}		
	
	</script>

</cfoutput>

<cfset ctr= 0>

<table width="100%" height="100%" align="center" class="formpadding">

<cfparam name="url.header" default="1">
<cfif url.header eq "1">
<tr>
	<td height="10" style="padding-left:7px">	
	  <cfset ctr      = "1">		
	  <cfset openmode = "open"> 
	  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
	</td>
</tr>	
</cfif>

<tr><td style="height:100%">

<table width="99%" style="height:100%" align="center" border="0" ccellpadding="0" class="navigation_table">

<cfparam name="url.status" default="valid">

<cf_verifyOperational module="Payroll" Warning="No">

<!--- Query returning search results --->

<cfquery name="SearchResult" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   L.*, 
			 R.Description,
			 A.Description as AppointmentName,
			 T.ContractAdjustment,
	
         	 (SELECT  Description 
				  FROM    Ref_Action 
				  WHERE   ActionCode = L.ActionCode) as ActionDescription,
			  
			 (SELECT  Description 
				  FROM    Ref_PersonGroupList
				  WHERE   GroupCode = L.GroupCode
				  AND     GrouplistCode = L.GroupListCode) as ActionReason,
			
			 <!--- look for valid workflow --->
			 
			 (SELECT TOP 1 Objectid 
				  FROM     Organization.dbo.OrganizationObject 
				  WHERE    Objectid   = L.ContractId 
				  AND      EntityCode = 'VacCandidate' 
				  AND      Operational = 1) as RecruitmentId,	
			 	  
			 (SELECT TOP 1 ObjectKeyValue4 
				  FROM     Organization.dbo.OrganizationObject 
				  WHERE    (Objectid   = L.ContractId OR ObjectKeyValue4 = L.ContractId)
				  AND      EntityCode = 'PersonContract' 
				  AND      Operational = 1) as WorkflowId,		
				  
			 <!--- obtain salary level --->	 
			 
			 <cfif operational eq "1">
			 
				 (SELECT     TOP 1 SCL.Amount
				   FROM       Payroll.dbo.SalaryScale SC INNER JOIN
	                          Payroll.dbo.SalaryScaleLine SCL ON SC.ScaleNo = SCL.ScaleNo INNER JOIN
	                          Payroll.dbo.SalarySchedule S ON SC.SalarySchedule = S.SalarySchedule INNER JOIN
	                          Payroll.dbo.SalaryScheduleComponent C ON S.SalarySchedule = C.SalarySchedule 
							  AND S.SalaryBasePayrollItem = C.PayrollItem 
							  AND SCL.ComponentName       = C.ComponentName	 						  
							  
				   WHERE      SCL.ServiceLevel    = L.ContractLevel
				   AND        SCL.ServiceStep     = L.ContractStep
				   AND        SC.Operational      = 1
				   AND        SC.Mission          = L.Mission
				   AND        SC.ServiceLocation  = L.ServiceLocation
				   AND        SC.SalaryEffective <= L.DateEffective
				   AND  	  SC.SalarySchedule   = L.SalarySchedule
				   AND        SC.SalaryFirstApplied <= L.DateEffective 
				   ORDER BY   SalaryFirstApplied DESC )
			   			   
			   <cfelse>
			   
			   0
			   
			   </cfif> 
			   
			   as BaseSalary						 		  			
				  
    FROM     PersonContract L 
	         INNER JOIN Ref_ContractType R ON L.ContractType = R.ContractType
			 INNER JOIN Ref_AppointmentType T ON T.AppointmentType = R.AppointmentType
			 INNER JOIN Ref_AppointmentStatus A ON L.AppointmentStatus = A.Code
	AND      L.PersonNo = '#URL.ID#' 
	<cfif url.status eq "valid">
	AND      ActionStatus IN ('0','1')
	ORDER BY L.DateEffective #URL.Order#, L.ActionStatus DESC <!--- make sure the expired contract show first --->
	<cfelse>
	ORDER BY L.DateEffective #URL.Order#, L.Created #URL.Order#, L.ActionStatus DESC <!--- make sure the expired contract show first --->
	</cfif>
	

		
</cfquery>


<cfquery name="ResetRecord" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT *
		FROM   PersonContractAdjustment T
		WHERE  PersonNo   = '#url.id#' 
		AND    ContractId IN
                        (SELECT   ContractId
                          FROM    PersonContract
                          WHERE   PersonNo = T.PersonNo 
						  AND     ActionStatus = '9')
</cfquery>		

<cfloop query="ResetRecord">
	
	<cfquery name="getRecord" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			SELECT   TOP 1 *
			FROM     PersonContract
			WHERE    PersonNo = '#URL.ID#'
			AND      DateEffective <= '#dateEffective#'
			AND      ActionStatus IN ('0','1')
			ORDER BY DateExpiration DESC 
	</cfquery>
	
	<cfif getRecord.recordcount eq "1">
	
			<cfquery name="Update" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 UPDATE  PersonContractAdjustment
					 SET     ContractId = '#getRecord.contractid#'
					 WHERE   PersonNo = '#url.id#'
					 AND     PostAdjustmentId = '#PostAdjustmentId#'							
			</cfquery>	 		
				
	</cfif>			

</cfloop>		 

<!--- check if this person has any valid contract after today's date --->

<cfquery name="Expire" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
    FROM      PersonContract
	WHERE     PersonNo = '#URL.ID#' 
	AND       (DateExpiration >= getDate() or DateExpiration is NULL)
	AND       ActionStatus != '9'	   
	ORDER By  DateExpiration DESC 
</cfquery>

<tr><td style="height:100%">
	
<table width="98%" border="0" align="center" style="min-width:1024px;height:100%">
	
	<cfinvoke component  = "Service.Access" 
      method     = "contract"
	  personno   = "#URL.ID#"	
	  role       = "'ContractManager','PayrollOfficer'"		
	  returnvariable = "access">
			  
	<cfoutput>	  
	
	<cfif url.header eq "1">
		
		<tr>

		    <td>
	
			<table>
			<tr>		
			
			    <td colspan="6" style="height:40px;padding-left:13px;min-width:120px">				
				<table><tr class="labelmedium">
					<td><img src="#client.root#/images/contract.png" height="43" alt="" border="0"></td>
					<td style="height:43px;padding-top:10px;padding-left:18px;font-size:38px">
					<cf_tl id="Appointments"></td><td style="height:40px;padding-top:24px;padding-left:5px;font-size:19px;"><cf_tl id="and"><cf_tl id="Amendments"></td></tr>
				</table>			
				</td>
				
			</tr>
			
			<tr class="labelmedium2">	
									 
				 <cfif url.status eq "valid">
				 
				     <td align="right" valign="bottom" style="padding-left:20px;height:20px;min-width:80px">
					 <a href="javascript:contractshow('#url.id#','all','#URL.Order#')">
					 <cf_tl id="AUDIT view">
					 </a>
					 </td>
				 
				 <cfelse>
				 
				 	<td align="center" valign="bottom" style="padding-left:20px">
					 <a href="javascript:contractshow('#url.id#','valid','#URL.Order#')">
					 <cf_tl id="ACTIVE">
					 </a>
				    </td>
					 
				 </cfif>
				 
				 <td valign="bottom" style="padding-left:5px;padding-right:5px">|</td> 
				 						
				 <cfif url.order eq "ASC">
				 	<td align="center" style="min-width:105px" valign="bottom">
						 <a href="javascript:contractshow('#url.id#','#URL.status#','DESC')">
						 <cf_tl id="NEWEST on top">
						 </a>
					 </td>
				<cfelse>	
					<td align="center" style="min-width:105px" valign="bottom">
						 <a href="javascript:contractshow('#url.id#','#URL.status#','ASC')">
						 <cf_tl id="OLDEST on top">
						 </a>		 
					 </td>	 
				 </cfif>
	
				 <td class="labelmedium2" align="center" valign="bottom" style="min-width:90px;color:0080C0;">
				 	<input type="checkbox" id="btnToggleDetails" onclick="$('.clsDetailComments').toggle()"> <label for="btnToggleDetails"><cf_tl id="Details"></label>
				 </td>	
				 			
				</tr>
				
			</table>
	
		  </td>
		
		  <td align="right" height="24" valign="bottom">
			
			<!--- check if there are any pending contracts --->
					
			<!--- Query returning search results --->
			<cfquery name="Pending" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
			    FROM     PersonContract
				WHERE    PersonNo = '#URL.ID#' 
				AND      ActionStatus = '0'	   	
			</cfquery>
			
			<table><tr class="labelmedium2">
											
				<cfif access eq "ALL" or access eq "EDIT">							 
					    <cfset jvlink = "ProsisUI.createWindow('dialoggrade', 'Grade', '',{x:100,y:100,height:400,width:510,resizable:false,modal:true,center:true});ptoken.navigate('PersonGrade.cfm?id=#url.id#','dialoggrade')">									    
						<td valign="bottom" style="font-size:14px;padding-left:4px;padding-right:4px"><cf_tl id="View"></td>												
						<cf_tl id="Grade" var="1">								
						<td valign="bottom" style="font-size:14px;padding-left:4px;padding-right:4px"><a href="javascript:#preservesinglequotes(jvlink)#"><cfoutput>#lt_text#</cfoutput></a></td>						
						<td valign="bottom" style="padding-left:5px;padding-right:5px">|</td>   
						<cfset jvlink = "ProsisUI.createWindow('dialogappointment', 'Appointment', '',{x:100,y:100,height:480,width:810,resizable:true,modal:true,center:true});ptoken.navigate('PersonAppointment.cfm?id=#url.id#','dialogappointment')">									    
						<cf_tl id="Appointment" var="1">								
						<td valign="bottom" style="font-size:14px;padding-left:4px;padding-right:4px"><a href="javascript:#preservesinglequotes(jvlink)#"><cfoutput>#lt_text#</font></cfoutput></a></td>						
						  				    			
				</cfif>
					 	
				<cfif access eq "ALL" or access eq "EDIT">	
							
			  	    <cf_tl id="Record new" var="1">	
					<td class="labelmedium" valign="bottom" style="min-width:10px;font-size:14px;padding-left:24px;padding-right:15px"><a href="javascript:contract('#URL.ID#')"><cfoutput>#lt_text#</cfoutput></a></td>
									
				</cfif>
				
				<cfif Pending.recordcount gte "1">	
				
				<td valign="bottom" style="padding-left:5px;padding-right:5px">|</td>
			    <td class="labelmedium" valign="bottom" style="font-weight:200;padding-left:3px;padding-right:15px"><font color="red"><cf_tl id="Open Actions"></td>
						
				</cfif>
			
			</tr>
			</table>
			
		    </td>
			
		</tr>	
			
	</cfif>
		
   </cfoutput>	
      
   <cfif Expire.recordcount eq "0" and SearchResult.Recordcount neq "0">
	   <tr class="line"><td colspan="2" align="center" class="labelmedium2" style="height:32px;font-size:15px">	  
	   Attention :<font color="FF0000"><cf_tl id="This person has no active appointment at this moment"></td></tr>	  
   </cfif>
   
  <td width="100%" colspan="2" height="100%" style="padding-top:10px;padding-left:10px">
  
  	  <cf_divscroll>
 
	  <table style="width:99%;border-bottom:1px solid silver;padding:2px">
			
		<TR class="labelmedium line fixrow fixlengthlist">
		    <td height="18" align="center"></td>
			<td></td>		
			<TD><cf_tl id="Entity"></TD>	
			<TD colspan="2"><cf_tl id="Action"></TD>	
			
			<TD><cf_tl id="Reference"></TD>					    
			<TD><cf_tl id="Type"></TD>
			<TD><cf_tl id="Schedule"></TD>
			<TD></TD>
						
			<TD><cf_tl id="Gr">/<cf_tl id="St"></TD>	
			<TD><cf_tl id="Increment"></TD>				
			<TD align="right" style="padding-right:5px"><cf_tl id="Base"></TD>						
			<TD><cf_tl id="Status"></TD>		
			<td><cf_tl id="Effective"></td>
			<TD><cf_tl id="Expiration"></TD>		
		</TR>
		
		<cfset last = '1'>
		
		<cfif URL.Order eq "ASC">
			<cfset dte = "01/01/1900">
		<cfelse>
			<cfset dte = "01/01/2900">
		</cfif>	
		
		<cf_verifyOperational 
		     datasource= "appsSystem"
		     module    = "Payroll" 
			 Warning   = "No">
		
		<cfset start = "0"> 
		
		<cfoutput query="SearchResult">
		
	
		
		<cfif recruitmentid neq "">	
	    	 <cfset workflow = recruitmentid>
		<cfelse>
		     <cfset workflow = workflowid>	 		
		</cfif>
			
		<cfif ActionStatus eq "0" or ActionStatus eq "1">		
									
			<cfif url.order eq "DESC">
			
				<cfif url.status neq "all">
			
					<cfif DateExpiration gt dte>
				
					<tr><td align="center" height="20" colspan="15">
					<table width="100%" align="center">
					<tr bgcolor="red" class="labelmedium">
						<td align="center" height="20"><font color="FFFFFF"><cf_tl id="Attention: Effective periods should not overlap."></td>
					</tr>
					</table>
					</td></tr>
					
					</cfif>
				
				    <cfif DateExpiration lt dte and start eq "1">				    
						<tr class="labelmedium" style="border:1px solid silver;">
						<td colspan="15" align="center" style="background-color:ffffcf;color:black">
						<cf_tl id="Break in contract"></td>
						</tr>						
					</cfif>
							
				</cfif>
				
				<cfset dte = dateAdd("d","-1",DateEffective)>
							
			<cfelse>
			
				<cfif url.status neq "all">
			
					<cfif DateEffective lt dte>
			
						<tr><td align="center" height="20" colspan="15">
						<table width="100%" align="center">
						<tr bgcolor="red">
							<td align="center" height="20"><font color="FFFFFF"><b><cf_tl id="Attention: Effective periods should not overlap."></td>
						</tr>
						</table>
						</td></tr>
				
					</cfif>
									
					<cfif DateEffective gt dte and start eq "1">
						<tr class="labelmedium"><td style="border:0px solid gray;height:25px;color:white" colspan="15" align="center" bgcolor="DD6F00"><cf_tl id="Break in contract"></td></tr>
					</cfif>
				
				</cfif>	
				<cfset dte = dateAdd("d","1",DateExpiration)>				
			
			</cfif>						
			
			<!---- to be cleared by Hvp by JM on 28/04/10 ----->
			<cfif dte eq ""> 
				<!---- can this be a parameter? ----->			
				<cfset dte="1/1/2050">			
			</cfif>
			
			<cfset start = "1">
		
		</cfif>
		
		<cfif actionStatus eq "9" or actionstatus eq "8">
		
			<!--- 16/2/2011 adjustment to handle cancelled records better	
			check if the workflow of the cancelled record is still open, we close it in that case 	
			--->
			
		    <cf_wfActive entitycode="PersonContract" objectkeyvalue4="#contractid#">	
			
			<cfif wfstatus eq "open">
			
				<cfquery name="ArchiveFlow" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE OrganizationObjectAction
						SET    ActionStatus     = '2',
						       OfficerUserId    = 'administrator',
							   OfficerLastName  = 'Agent',
							   OfficerFirstName = 'System',
							   OfficerDate      = getDate()					   		
						WHERE  ObjectId IN (SELECT ObjectId 
						                    FROM   OrganizationObject 
											WHERE  ObjectKeyValue4 = '#contractid#')
						AND    ActionStatus = '0'			
				</cfquery>	
			
			</cfif>
		
		<tr bgcolor="f1f1f1" style="border-top:0px solid silver;height:30px;" class="navigation_row labelmedium2 fixlengthlist">
		
		<cfelseif HistoricContract eq "1">
		
		<!--- active contract --->
		<tr bgcolor="f1f1f1" style="height:30px;border-top:1px solid silver" class="navigation_row labelmedium2 fixlengthlist">
		
		<cfelseif dateeffective lte now() and (dateExpiration is "" or dateExpiration gte now())>
		
		<!--- active contract --->
		<tr bgcolor="DAF9FC" class="navigation_row labelmedium2 fixlengthlist" style="height:30px;border-top:1px solid silver">
		
		<cfelse>
		
		<TR bgcolor="#iif(currentrow Mod 2, DE('FFFFFF'), DE('FFFFFF'))#" style="height:30px;border-top:1px solid silver" class="navigation_row labelmedium2 fixlengthlist">
		
		</cfif>
					
		<cfif workflow neq "">
			 
			 <td height="20"
			    align="center" 			
				style="cursor:pointer" 
				onclick="workflowdrill('#workflow#','box_#workflow#')" >
			 	<cfif Access eq "All" or Access eq "Edit">
			 	<cfif ActionStatus eq "0">
				
					  <img id="exp#Workflow#" 
					     class="hide" 
						 src="#SESSION.root#/Images/arrowright.gif" 
						 align="absmiddle" 
						 alt="Expand" 
						 height="9"
						 width="7"			
						 border="0"> 	
									 
				   <img id="col#Workflow#" 
					     class="regular" 
						 src="#SESSION.root#/Images/arrowdown.gif" 
						 align="absmiddle" 
						 height="10"
						 width="9"
						 alt="Hide" 			
						 border="0"> 
				
				<cfelse>
				
				   <img id="exp#Workflow#" 
					     class="regular" 
						 src="#SESSION.root#/Images/arrowright.gif" 
						 align="absmiddle" 
						 alt="Expand" 
						 height="9"
						 width="7"			
						 border="0"> 	
									 
				   <img id="col#Workflow#" 
					     class="hide" 
						 src="#SESSION.root#/Images/arrowdown.gif" 
						 align="absmiddle" 
						 height="10"
						 width="9"
						 alt="Hide" 			
						 border="0"> 
				
				</cfif>
				</cfif>
				
			<cfelse>
			
			<td height="20" align="center">	
			  
			</cfif>	 
			
			</td>
			
			<td align="center">
					      
			 	<cfif HistoricContract eq "1">
				
				 <cfif getAdministrator("*") eq "1">				 
				 	<cf_img icon="open" navigation="Yes" onClick="EditContract('#PersonNo#','#ContractId#')">				 
				 </cfif>
				
				<cfelseif ActionStatus neq "9">		 
							
				 <cfif access eq "ALL" or access eq "EDIT">				 
				 	<cf_img icon="edit" navigation="Yes" onClick="EditContract('#PersonNo#','#ContractId#')">				 			 
				 </cfif>  
			 
			   </cfif>		
				 
			</td>	
			
			<cfif actionStatus eq "9">
				<cfset cl = "FED7CF">
			<cfelse>
				<cfset cl = "">
			</cfif>
			
			<td style="background-color:#cl#">#Mission#</td>		
			<td style="background-color:#cl#" colspan="2">#ActionDescription#</td>
			<td style="background-color:#cl#">
						
			<cfquery name = "Action"
			datasource = "AppsEmployee"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				SELECT EA.ActionDocumentNo, EAS.ActionStatus 
				FROM   EmployeeAction EA INNER JOIN EmployeeActionSource EAS ON EA.ActionDocumentNo = EAS.ActionDocumentNo
				WHERE  EAS.ActionSourceId = '#ContractId#'
				AND    EA.ActionSource = 'Contract'
						
		    </cfquery>
			
			<cfquery name = "Recruitment"
			datasource = "AppsEmployee"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				SELECT      D.DocumentNo,
	                        (SELECT    ReferenceNo
	                         FROM      Applicant.dbo.FunctionOrganization AS FO
	                         WHERE     FunctionId = D.FunctionId) AS Reference
				FROM         Vacancy.dbo.DocumentCandidate AS DC INNER JOIN Vacancy.dbo.Document AS D ON DC.DocumentNo = D.DocumentNo
				<cfif candidateid neq "">
				WHERE        DC.CandidateId = '#CandidateId#'
				<cfelse>
				WHERE 1=0
				</cfif>
			</cfquery>
									
			<cfif Action.RecordCount eq "1">
			
				<cfloop query="Action">
				<a href="javascript:padialog('#Actiondocumentno#')"><cfif actionStatus eq "9"><font color="FF0000"></cfif><cfif SearchResult.PersonnelActionNo neq "">#SearchResult.PersonnelActionNo#<cfelse>#ActionDocumentNo#</cfif></font></a><cfif recordcount neq currentrow>|</cfif>
				</cfloop>	
					
			<cfelseif Action.RecordCount gt "1">
						
				<cfloop query="Action">
					<a href="javascript:padialog('#Actiondocumentno#')"><cfif actionStatus eq "9"><font color="FF0000"></cfif>#ActionDocumentNo#</font></a><cfif recordcount neq currentrow>|</cfif>
				</cfloop>			
			
			<cfelseif Recruitment.recordcount gte "1">
			
				<a href="javascript:showdocument('#Recruitment.documentNo#')">
				<cfif Recruitment.Reference neq "">#Recruitment.Reference#<cfelse>#Recruitment.DocumentNo#</cfif>
				</a>
			
			<cfelse>
			
				<cfif PersonnelActionNo neq "">#PersonnelActionNo#</cfif>
			
			</cfif>
					
			
			</TD>			
			
			<TD style="background-color:#cl#">#Description#</TD>
			<TD style="background-color:#cl#">#ServiceLocation#&nbsp;#SalarySchedule#</TD>
			
			<td style="background-color:#cl#">

				<cfif operational eq "1">
				
				<cfquery name="Trigger" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				
					SELECT    *, (					
							SELECT       TOP 1 PersonNo
							FROM         PersonEntitlement
							WHERE        ContractId = '#contractid#' 
							AND          SalaryTrigger = R.SalaryTrigger ) as Selected
					
					
					
					FROM      Ref_PayrollTrigger R
					WHERE     EnableContract IN ('1','2')
					AND       Operational    = 1
					AND       TriggerGroup != 'Contract'
											
					AND       SalaryTrigger IN (
						                        SELECT  RC.SalaryTrigger
												FROM    SalaryScheduleComponent SC INNER JOIN
									                    Ref_PayrollComponent RC ON SC.ComponentName = RC.Code
												WHERE   SC.SalarySchedule IN ('#salarySchedule#')
												)  								
									
				</cfquery>						
				
				<table>
					<tr>
					<cfloop query="trigger">
					<cfif selected neq "">
						<cfset ecl = "lime">
					<cfelse>
						<cfset ecl = "white">
					</cfif>
					<td style="background-color:#ecl#;border:1px solid gray;height:10px;width:10px;font-size:7px" title="#description#">&nbsp;</td>
				    </cfloop>
					</tr>
				</table>
				
				</cfif>
						
			</td>
			
			<td style="background-color:#cl#">
			
			<cfif SalarySchedule eq "NoPay">
				<font color="800040"><cf_tl id="Unfunded"></font>
			<cfelse>
				#ContractLevel#/#ContractStep#<cfif contracttime neq "100">&nbsp;:&nbsp;#ContractTime#</cfif>
			</cfif>
			
			</td>
			
			<td style="background-color:#cl#">
			<cfif actioncode eq "3006">--
				<cfelseif stepincreasedate eq "">--
				<cfelseif StepIncreaseDate lte DateEffective><font color="FF0000"
				                              style="font-style: italic; text-decoration: line-through;">#Dateformat(StepIncreaseDate, CLIENT.DateFormatShow)#
				<cfelse>#Dateformat(StepIncreaseDate, CLIENT.DateFormatShow)#
			</cfif>
			
			</td>
			
			<td align="right" style="background-color:#cl#">
						
				<cfif BaseSalary eq "0" or BaseSalary eq "">--
				<cfelseif contractTime eq 100 or contractTime eq "">			
				#numberformat(BaseSalary,',.__')#			
				<cfelse>			
				#numberformat(BaseSalary*contracttime/100,',.__')#
				</cfif>
			
			</td>			
			
			<td style="background-color:#cl#" id="status_#contractid#">
			
				<cfif HistoricContract eq "1">
				
					<font color="gray"><cf_tl id="Historic">
					
				<cfelse>
					
				<cfif actionStatus eq "9">
					<font color="red"><cf_tl id="Superseded">				
				<cfelse>			   
				    <cfif mandateNo neq "">
					   <font color="0080FF"><cf_tl id="Carry-over"></font> 
					<cfelseif actionstatus eq "1">
					    <font color="green"><cf_tl id="Cleared">
					<cfelse>
					   <font color="red"><cf_tl id="Pending">
				   </cfif>
				</cfif>			
				
				</cfif>
				
			</td>

			<cfset vDatesColor = "background-color:##E0E0E080;">
			<cfif now() GTE DateEffective AND (now() LTE DateExpiration OR DateExpiration eq "")>
				<cfset vDatesColor = "background-color:##95EDA380;">
			</cfif>
			
			<cfif ActionStatus eq "8" or actionStatus eq "9">
			<td align="center" style="border:1px solid silver;border-top:0px;border-bottom:0px; #vDatesColor#">#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
			<td style="border-left:1px solid silver;#vDatesColor#" align="center">#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</td>
			<cfelse>
			<td align="center" style="border:1px solid silver;border-bottom:0px;border-top:0px; #vDatesColor#">#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
			<td style="border-left:1px solid silver;#vDatesColor#" align="center">#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</td>
			</cfif>
		</TR>
		
		<cf_verifyOperational 
		     datasource= "appsSystem"
		     module    = "Payroll" 
			 Warning   = "No">
		 
		<cfif ModuleEnabled eq "1" and HistoricContract eq "0">
		
			<cfquery name="Schedule" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     TOP 1 *
				FROM       SalarySchedule
				WHERE      SalarySchedule      = '#SalarySchedule#' 								
			</cfquery>	
			
			<cfif schedule.operational eq "1">
			
				<!--- validate of the step and location has an occurence --->
			
				<cfquery name="Check" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT     TOP 1 *
					FROM       SalaryScale S INNER JOIN
				               SalaryScaleLine SL ON S.ScaleNo = SL.ScaleNo
					WHERE      S.SalarySchedule    = '#SalarySchedule#' 				
					AND        S.ServiceLocation   = '#ServiceLocation#' 
					AND        SL.ServiceLevel     = '#ContractLevel#' 
					AND        SL.ServiceStep      = '#ContractStep#'
					AND        SL.Operational      = 1				
				</cfquery>	
				
				<cfif Check.recordcount eq "0">
					<tr>				
						<td colspan="15" align="center" class="labelmedium2" bgcolor="red"><font color="white"><cf_tl id="Problem">: <cf_tl id="Payroll contract level/step no longer exists for this schedule/location." class="Message"></td>
					</tr>
				</cfif>
				
			</cfif>	
		
		</cfif> 		
			
	    <cfif actionStatus eq "9" or actionstatus eq "8">	
		
		<cfelseif historiccontract eq "1">	
			  
		<cfelseif dateeffective lte now() and (dateExpiration is "" or dateExpiration gte now())>
			<tr class="labelmedium2 clsDetailComments clsDetailComments_#contractid#" style="border-top:1px solid d0d0d0;background-color:F0FFFF; display:none;">
			<td bgcolor="ffffff"></td>
			<td bgcolor="FFFFFF"></td>
			<td colspan="3" align="left" style="background-color:f1f1f1;font-size:12px;height:20px;padding-left:5px;border:1px solid silver;border-bottom:0px solid silver;padding-right:10px;border-top:1px solid d0d0d0">#Officerlastname#: #dateformat(created,client.dateformatshow)#&nbsp;#timeformat(created,"HH:MM")#</td>
			<td colspan="2" align="left" style="background-color:C6F2E2;font-size:12px;height:20px;padding-left:5px;border:1px solid silver;border-bottom:0px solid silver;padding-right:10px;border-top:1px solid d0d0d0">#AppointmentName#<cfif appointmentstatusmemo neq ""><br>#AppointmentStatusMemo#</cfif></td>				
			<td colspan="10" align="left" style="height:20px;font-size:12px;padding-left:5px;border:1px solid silver;border-bottom:0px solid silver;padding-right:10px;border-top:1px solid d0d0d0"><cfif Actionreason neq ""><b>#Actionreason#&nbsp;</b></cfif><cfif left(remarks,9) eq "Generated"><i><font color="800000"></cfif>#Remarks#</td>		
			</tr>			
			
		<cfelseif remarks neq "" or actionreason neq "">
			<tr class="labelmedium2 clsDetailComments clsDetailComments_#contractid#" style="border-top:1px solid d0d0d0;background-color:F0FFFF; display:none;">
			<td bgcolor="FFFFFF"></td>
			<td bgcolor="FFFFFF"></td>
			<td colspan="3" align="left" style="background-color:f1f1f1;font-size:12px;height:20px;padding-left:5px;border:1px solid silver;border-bottom:0px solid silver;padding-right:10px;border-top:1px solid d0d0d0">#Officerlastname#: #dateformat(created,client.dateformatshow)#&nbsp;#timeformat(created,"HH:MM")#</td>
			<td colspan="2" align="left" style="background-color:C6F2E2;font-size:12px;height:20px;padding-left:5px;border:1px solid silver;border-bottom:0px solid silver;padding-right:10px;border-top:1px solid d0d0d0">#AppointmentName#<cfif appointmentstatusmemo neq ""><br>#AppointmentStatusMemo#</cfif></td>	
			<td colspan="10" align="left" style="height:20px;font-size:12px;padding-left:5px;border:1px solid silver;border-bottom:0px solid silver;padding-right:10px;border-top:1px solid d0d0d0"><cfif Actionreason neq ""><b>#Actionreason#&nbsp;</b></cfif><cfif left(remarks,9) eq "Generated"><font color="800000"></cfif>#Remarks#</td>			
			</tr>		
			
		</cfif>				
				
		<cfif workflow neq "" and HistoricContract eq "0">
				
			<input type="hidden" 
			   name="workflowlink_#workflow#" 
			   id="workflowlink_#workflow#" 		   
			   value="EmployeeContractWorkflow.cfm">			   
			  
			<input type="hidden" 
			   name="workflowlinkprocess_#workflow#" 
			   onclick="ptoken.navigate('EmployeeContractStatus.cfm?id=#contractid#','status_#workflow#')">		    
			   
			<!---  not relevant anymore 19/4/2018 as per effort to re-embed the contract entry screen
			into the workflow as opposed to what we had in NY back in 2013 as contracts are now differently embedded can be removed   
			
	        <cfquery name="Check" 
	        datasource="AppsOrganization" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	            SELECT *
	            FROM   OrganizationObject
	            WHERE  (ObjectId =  '#contractid#' or ObjectKeyValue4 = '#contractid#')                                                                                
	            AND    EntityCode = 'VacCandidate' 
	        </cfquery>
	                                        
	        <cfquery name="getCandidate" 
	        datasource="AppsVacancy" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
                    SELECT *
                    FROM  DocumentCandidate
                    WHERE DocumentNo = '#check.objectkeyvalue1#'
                    AND   PersonNo   = '#check.objectkeyvalue2#'
	        </cfquery>		                                    
	
	        <script language="JavaScript">
			
				function arrival() {		   
						try { ColdFusion.Window.destroy('myarrival',true) } catch(e) {}
						ColdFusion.Window.create('myarrival', 'On boarding', '',{x:100,y:100,height:document.body.clientHeight-40,width:document.body.clientWidth-40,modal:false,resizable:false,center:true})    					
						ColdFusion.navigate('#SESSION.root#/Staffing/Application/Position/Lookup/PositionTrack.cfm?Source=vac&mission=#check.mission#&mandateno=0000&applicantno=#check.objectkeyvalue2#&personno=#url.id#&recordid=#check.objectkeyvalue1#&documentno=#check.objectkeyvalue1#','myarrival') 	
					}
						
				function arrivalrefresh() {	
		              ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/CandidateWorkflow.cfm?id=#check.objectkeyvalue1#&id1=#check.objectkeyvalue2#&ajaxid=mybox#getcandidate.Personno#','mybox#getcandidate.Personno#')                 
	 			   }			               
	
	        </script>
			
			only for pending contract the workflow is shown / triggered --->
			
			<!--- show only open contracts and only if dependents were not shown yet --->
					
			<cfif ActionStatus eq "0" and dependentshow eq "0">
									
				<!--- determine PA action --->
					
				<cfquery name="PA" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT     TOP 1 *
						FROM       EmployeeAction
						WHERE      ActionSourceId = '#contractid#'			
				</cfquery>	
					
				<cfif PA.recordcount eq "1">
				
					<cfset dependentshow = "1">
						
					<!--- show workflow directly if this is pending --->
					
					<tr id="dependentbox">	
					
						<td colspan="1"></td>
						
						<td colspan="14" id="contentdependent">
						
						<table width="100%" ccellspacing="0" ccellpadding="0" align="right">
						<tr><td style="padding-right:20px">
											
							<cfset url.contractid = contractid>
							<cfset url.action = "contract">		
							
							<cfinclude template="../Dependents/EmployeeDependentScript.cfm">
							<cfinclude template="../Dependents/EmployeeDependentDetail.cfm"> 										
						
						</td></tr>
						</table>
						
						</td>
					</tr>
					
				</cfif>	
				
			  </cfif>	
				
			  <cfif ActionStatus eq "0">
					
				<tr id="box_#workflow#">
				
				<td colspan="1"></td>
				
				<td colspan="14"  style="padding-right:0px" id="#workflow#">
	
					<cfset url.ajaxid = contractid>					
										
					<cftry>
					
						<cfinclude template="EmployeeContractWorkflow.cfm">
						
						<cfcatch>						   
						   <cfdiv bind="url:#SESSION.root#/Staffing/Application/Employee/Contract/EmployeeContractWorkflow.cfm?ajaxid=#url.ajaxid#">							
						</cfcatch>
						
					</cftry>
				
				</td></tr>		
				
			  <cfelse>
			
				<tr id="box_#workflow#" class="hide">
					<td colspan="1"></td>
					<td colspan="14" style="padding-right:10px" id="#workflow#"></td>
				</tr>
			
			  </cfif>		
		
		</cfif>
		
		<!--- check for SPA entries or allow for entry --->
		
		<cfif actionStatus eq "0" or actionStatus eq "1">
			
			<cfquery name="SPA" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   PersonContractAdjustment 
				WHERE  PersonNo = '#PersonNo#'
				<cfif url.status eq "valid">		
				AND      ActionStatus IN ('0','1')
				</cfif>		
				
				AND    (
				
					        (
						    DateEffective >= '#dateformat('#DateEffective#','#client.dateSQL#')#'
							AND    DateExpiration <= '#dateformat('#dte#','#client.dateSQL#')#'
							AND    Contractid IN (SELECT Contractid 
					                      FROM   PersonContract 
										  WHERE  PersonNo = '#PersonNo#' 
										  AND    Mission = '#Mission#')
							)			  
						 
						 	OR ContractId = '#Contractid#'
						  
						)  
				ORDER BY DateEffective, 
				         PostAdjustmentLevel DESC, 
						 PostAdjustmentStep DESC,
						 ActionStatus
			</cfquery>	
						
			<!--- There should be a ripple if a valid SPA for a mission that is for an effective period
			which does not have an active contract anymore, should be flagged --->
			
			<cfset row = 0>
			
			<cfif SPA.recordcount gte "1">	
							
			    <cfloop query="SPA">
									
						<cfset row = row+1>				
					    <cfset url.spabox = "spa#row#">
					    <cfinclude template="Adjustment/EmployeeContractSPA.cfm">				
									
				</cfloop>
				
											
			</cfif>	
			
			<cfquery name="Parameter" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_ParameterMission 
				WHERE    Mission = '#Mission#'					
			</cfquery>		
			
			<cfquery name="CheckLast" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   TOP 1 *
				FROM     PersonContractAdjustment 
				WHERE    PersonNo = '#PersonNo#'		
				AND      ActionStatus IN ('0','1')
				ORDER BY DateEffective DESC
			</cfquery>	
			
			
			
			<cfif Expire.recordcount eq "0" and SearchResult.Recordcount neq "0">
			
				<!--- no active contract --->
			
			<cfelse>
									
				<cfif actionStatus eq "1" 
				    and Parameter.disableSPA eq "0" 
					and HistoricContract eq "0" 
					and ContractAdjustment eq "1"
					and dependentshow eq "0" 
					and SalarySchedule neq "NoPay"
					and url.status eq "valid" 
					and actioncode neq "3006"> 	
								
				<!---	requested by Karin for STL temp measurement			
				<cfif actionStatus eq "1" and Parameter.disableSPA eq "0" and (DateExpiration gte now() or DateExpiration eq "")>
				--->
							
					<cfif CheckLast.DateExpiration lt dateExpiration or dateExpiration eq "">
					
					    <!--- ------------------------------------------------------------------------- --->
					    <!--- do not allow for additional SPA request if there is a pending SPA request --->
					    <!--- ------------------------------------------------------------------------- --->
						
						<cfset row = row+1>
						
						<cf_assignid>
													
					    <cfset jvlink = "ProsisUI.createWindow('spa', 'Contract Post Adjustment','',{x:100,y:100,height:630,width:630,resizable:false,modal:true,center:true});ptoken.navigate('#session.root#/Staffing/Application/Employee/Contract/Adjustment/ContractSPA.cfm?contractid=#contractid#&postadjustmentid=#rowguid#&spabox=spa#row#','spa')">				
						
						<cfif (access eq "ALL" or access eq "EDIT") and SPAcount lte "2">
						
						<tr style="border-top:1px solid silver">
						
							<td colspan="1"></td>					
							<td colspan="14" id="spa#row#">
							
								<table width="100%" align="center">
								
									<cfset SPACount = SPACount + 1>
								
									<tr height="26">
									
										<td class="labelmedium">			    					
										<img src="#SESSION.root#/images/finger.gif" onclick="#jvlink#" style="cursor:pointer" alt="" border="0" align="absmiddle">						
										<a href="javascript:#jvlink#" title="Record a request for Special Post Adjustment">
										<cf_tl id="Grant SPA">
										</a>						
										</td>
									
									</tr>
								
								</table>	
								
							</td>		
						</tr>	
						
						</cfif>
								
					</cfif>
					
				</cfif>
				
			</cfif>		
		
		</cfif>
						
		</cfoutput>
				
		</TABLE>
		
		</cf_divscroll>

</td>

</table>

</td>

</table>

</td>

</table>
