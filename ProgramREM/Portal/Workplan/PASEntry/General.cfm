
<cf_screenTop height="100%" html="No" layout="webapp" jquery="Yes" banner="gray" scroll="no">

<cf_dialogstaffing>
<cf_dialogposition>

<cfquery name="Section" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ContractSection
	WHERE Code = '#URL.Section#'
</cfquery>

<cfquery name="Contract" 
 datasource="AppsEPAS" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT *
    FROM   Contract
    WHERE  ContractId = '#URL.ContractId#'
</cfquery>

<cfform action="GeneralSubmit.cfm?Code=#URL.Code#&Section=#URL.Section#&ContractId=#URL.ContractId#" method="POST" name="action" style="height:98%">
		
<cf_divscroll>
	
	<table height="100%" width="100%" style="min-width:850px">
	
	<tr><td height="98%" valign="top">		
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		
		<tr><td valign="top" style="padding:10px">
		
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			
			<tr>
		    <td height="30" align="left" valign="middle">
			   <table>
			   <cfoutput>
				   <tr><td style="width:50px">
					 <img src="#SESSION.root#/Images/Logos/PAS/ReviewData-on.png" height="64" alt="" border="0" align="absmiddle" style="margin-left: 20px;">
					 </td>
					 <td valign="middle" style="padding-top:10px" class="labellarge"><h1 style="padding-left:5px;font-size:25px;font-weight:200;">#Section.Description#</h1></td>				
				</tr>
				<cfif section.Instruction neq "">
				<tr>					
					<td colspan="2" class="labellarge" style="font-size:16px;padding:5px 18px 0;font-weight: 200;">#Section.Instruction#</h1></td>																					
				</tr>
				</cfif>
				</cfoutput>
				
				</table>
		    </td>
		    </tr> 	
						
			<cfoutput>
			
			<tr><td style="padding-top:20px;padding-left:20px">
			
			    <table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
				
				<cfinvoke component = "Service.Access"  
				   method           = "staffing" 
				   mission          = "#Contract.Mission#" 
				   orgunit          = "#Contract.OrgUnit#" 
				   returnvariable   = "accessStaffing">	  		
				   
				<tr class="labelmedium">
				    <td height="24"><cf_tl id="Ref. No">:</td>
			        <td>
					#Contract.ContractNo#
					</td>
			    </td>
				</tr>   	
				
				<cfquery name="Class" 
			datasource="AppsEPAS" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_ContractClass
				WHERE  Code = '#Contract.ContractClass#'							
			</cfquery>
				
				<tr class="labelmedium">
				    <td height="24"><cf_tl id="Class">:</td>
			        <td>
					#Class.Description#
					</td>
			    </td>
				</tr>   
				   
				<tr class="labelmedium">
				    <td height="24"><cf_tl id="Period">:</td>
			        <td>
					
					<cf_calendarscript>
					
					<cfquery name="Check" 
						datasource="appsEPAS" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
							FROM Contract
							WHERE PersonNo = '#Contract.PersonNo#'
							AND DateEffective > '#DateFormat(Contract.DateEffective,CLIENT.DateSQL)#'
						</cfquery>	
						
						<cfif Check.Recordcount eq "0">
						
							<table  cellspacing="0" cellpadding="0">
							<tr><td style="min-width:140px">
					
							<cf_intelliCalendarDate9
								FieldName="DateEffective" 
								class="regularxl"
								Default="#Dateformat(Contract.DateEffective, CLIENT.DateFormatShow)#"
								AllowBlank="False">	
							
							</td>
							<td width="1" style="padding-left:4px;padding-right:4px">-</td>
							<td style="min-width:140px">
							<cf_intelliCalendarDate9
								FieldName="DateExpiration" 
								Default="#Dateformat(Contract.DateExpiration, CLIENT.DateFormatShow)#"
								class="regularxl"
								AllowBlank="False">	
							</td>
							</tr>
							</table>
					
						<cfelse>
						
							#Dateformat(Contract.DateEffective, CLIENT.DateFormatShow)# - 
							#Dateformat(Contract.DateExpiration, CLIENT.DateFormatShow)#
							<input type="hidden" name="DateExpiration" value="#Dateformat(Contract.DateExpiration, CLIENT.DateFormatShow)#">
							<input type="hidden" name="DateEffective" value="#Dateformat(Contract.DateEffective, CLIENT.DateFormatShow)#">
						
					</cfif>
					
			        </td>
				</tr>   
						
				<cfif (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL") 
				    and (Contract.ActionStatus lte "2" or Contract.ActionStatus eq "8" or Contract.ActionStatus eq "9")>
				
					<cf_interface cde="StallPas">	
					
					<tr class="labelmedium">
					    <td height="24">#Name#:</td>
				        <td>
						
						<cfif Contract.ActionStatus lte "2">
							<cfset st = Contract.ActionStatus>
						<cfelse>
							<cfset st = "0">
						</cfif>
						
						<table><tr>
						<td><input type="radio" class="radiol" name="ActionStatus" value="#st#" <cfif Contract.ActionStatus lte "2">checked</cfif>></td>
						<td style="padding-left:4px"><cf_tl id="Active"></td>
						<td style="padding-left:7px"><input type="radio" class="radiol" name="ActionStatus" value="8"    <cfif Contract.ActionStatus eq "8">checked</cfif>></td>
						<td style="padding-left:4px"><cf_tl id="Stall"></td>
						<td style="padding-left:7px"><input type="radio" class="radiol" name="ActionStatus" value="9"    <cfif Contract.ActionStatus eq "9">checked</cfif>></td>
						<td style="padding-left:4px"><cf_tl id="Deactivate"></td>
						</tr></table>
						
				    </td>
					</tr>
				
				<cfelse>
				
					<input type="hidden" name="ActionStatus" value="#Contract.ActionStatus#">
					
				</cfif>
			    
				
				<cfif (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL") 
				    and (Contract.ActionStatus lte "2" or Contract.ActionStatus eq "8" or Contract.ActionStatus eq "9")>
				
										
					<tr class="labelmedium">
					    <td height="24" style="padding-left:20px"><cf_tl id="Mid-term review date">:</td>
				        <td>
						
						<cf_intelliCalendarDate9
								FieldName="PASEvaluation" 
								Default="#Dateformat(Contract.PASEvaluation, CLIENT.DateFormatShow)#"
								class="regularxl"
								AllowBlank="True">	
						</td>
				    </td>
					</tr>
				
				<cfelse>
				
					<input type="hidden" name="PASEvaluation" value="#Dateformat(Contract.PASEvaluation, CLIENT.DateFormatShow)#">
					
				</cfif>
				
				
				<!--- can be used to inherit behaviors etc.
										
				<cfquery name="Other" 
				datasource="AppsEPAS" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  C.*, P.FullName
					FROM    Contract C, Employee.dbo.Person P
					WHERE   ContractId IN
					        ( SELECT    ContractId
					          FROM      ContractActor
					          WHERE     PersonNo = '#CLIENT.PersonNo#') 
					AND 	C.Period        = '#Contract.Period#' 
					AND     C.PersonNo     != '#Contract.PersonNo#' 
					AND 	C.ActionStatus IN ('1','2')
					AND     C.PersonNo      = P.PersonNo
				</cfquery>		
					
				<cfif Other.recordcount neq "0">
				
				<tr class="labelmedium">
				    <td height="24"><cf_tl id="Inherit">:</td>
			        <td>
					<select name="inherit" class="regularxl">
					<option value=""></option>
					<cfloop query="Other">
						<option value="#ContractId#">#FullName#</option>
					</cfloop>
					</select>
					</td>
			    </tr>		
				</cfif>		
				
				--->
				
				
						
				<tr class="labelmedium">
				    <td height="24"><cf_tl id="Section">/<cf_tl id="Unit">:</b></td>
					
					<cfquery name="Unit" 
					datasource="appsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				    
						SELECT  *
						FROM    Organization
						WHERE   OrgUnit = '#Contract.OrgUnit#'				
					</cfquery>		
					
					<cfquery name="Parent1" 
					datasource="appsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				    
						SELECT  *
						FROM    Organization
						WHERE   Mission     = '#Unit.Mission#'
						AND     MandateNo   = '#Unit.MandateNo#'
						AND     OrgUnitCode = '#Unit.ParentOrgUnit#'				
					</cfquery>	
					
					<td>
					
					<cfif Parent1.recordcount eq "1">
					
						<cfquery name="Parent2" 
						datasource="appsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">				    
							SELECT  *
							FROM    Organization
							WHERE   Mission     = '#Unit.Mission#'
							AND     MandateNo   = '#Unit.MandateNo#'
							AND     OrgUnitCode = '#Parent1.ParentOrgUnit#'				
						</cfquery>	
						
						 <cfif parent2.orgunitName neq "">#Parent2.OrgUnitName# / </cfif>
						 						 					
					</cfif>
					
			        <cfif parent1.orgunitName neq "">#Parent1.OrgUnitName# / </cfif>				
					<b>#Contract.OrgUnitName#
					
					</td>
					
			    </tr>
				
				
				<tr class="labelmedium">
				    <td height="24"><cf_tl id="Functional Title">:</td>
			        <td>
					<input type="text" class="regularxl" style="width:350px" maxlength="100" name="FunctionDescription" value="#Contract.FunctionDescription#">								
					</td>
			    </td>
				</tr>
				
				<tr class="labelmedium">
				    <td height="24"><cf_tl id="My duties are divided accross">:</td>
			        <td>
					<table><tr class="labelmedium"><td>
					<select name="EnableTasks" class="regularxl">
						<cfloop index="itm" from="1" to="10">
							<option value="#itm#" <cfif contract.EnableTasks eq itm>selected</cfif>>#itm#</option>
						</cfloop>
					</select>
					</td>
					<td style="padding-left:5px"><cf_tl id="Functional areas"></td>
					</tr></table>
					</td>
			    </td>
				</tr>
							
				<cfloop index="RoleFunction" list="FirstOfficer,SecondOfficer">
													
					<tr class="labelmedium">
					    <td height="24"><cf_tl id="#RoleFunction#">:&nbsp;<font color="FF0000">*)</font></td>
						<td>
						
						<table>
						<tr class="labelmedium">
						
						<td style="padding-right:4px">				
						
						<cfset link = "#SESSION.root#/ProgramREM/Portal/Workplan/PASEntry/setPerson.cfm?function=#rolefunction#">	
									
						 <cf_selectlookup
						    class      = "Employee"
						    box        = "member_#RoleFunction#"
							button     = "no"
							icon       = "search.png"
							iconwidth  = "22"
							iconheight = "22"
							title      = "#lt_text#"
							link       = "#link#"						
							close      = "Yes"
							des1       = "PersonNo">							
																	
						</td>
						
				        <td id="member_#RoleFunction#" style="border:1px solid silver;padding-left:5px;background-color:e1e1e1;min-width:240px">
						
						<cfquery name="Role" 
							datasource="appsEPas" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT    *
							FROM      ContractActor C
							WHERE     ContractId   = '#ContractId#'
							AND       Role         = 'Evaluation'
							AND       RoleFunction = '#RoleFunction#'
							AND       ActionStatus = '1'
							ORDER BY Created DESC						
						</cfquery>
						
						<cfquery name="Get" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT *
							    FROM   Employee.dbo.Person
							    WHERE  PersonNo = '#Role.personno#'
							</cfquery>
							
						#Get.FirstName# #Get.LastName#	
						
						<cf_tl id="#RoleFunction#" var="1">	
							
						
						</td>
						
						<td class="hide">
						<cfinput type="text" name="#RoleFunction#" value="#Role.PersonNo#" message="Please record a #lt_text#" required="Yes" id="#RoleFunction#">						
						</td>
						
						</tr>
						</table>
						</td>
				    </tr>
				
				</cfloop>		
				
				<tr class="labelmedium"><td style="height:30px" colspan="2"><cf_tl id="Assignments"></td></tr>
								
				<tr class="labelmedium">
					<td colspan="2" style="padding-right:20px">
					<cfset Header   = "0">
					<cfset url.mode = "portal">
					<cfset URL.ID   = "#Contract.PersonNo#">
					
					<cfinclude template="../../../../Staffing/Application/Assignment/EmployeeAssignment.cfm">
					</td>
				</tr>
						
				<tr class="labelmedium"><td style="height:30px" colspan="2"><cf_tl id="Comments">:</td></tr>
						
				<tr class="labelmedium">			    
			        <td colspan="2" style="padding-left:10px">
					<textarea style="font-size:13px;padding:3px;border-radius:1px;height:80px;width:96%" 
					totlength="800" onkeyup="return ismaxlength(this)" class="regular" name="Objective">#Contract.Objective#</textarea>
					</td>
			    </tr>
							
			    </table>
				
			</td></tr>	
			  
			</table>
			
			</cfoutput>
		
		</table>
	
	</td></tr>  
	
	<tr><td height="30">
	
		<cfif getAdministrator("#contract.mission#") eq "1">
			<cfset reset = "1">
		<cfelse>
			<cfset reset = "0">
		</cfif>	
								  
		<cf_Navigation
			 Alias         = "AppsEPAS"
			 Object        = "Contract"
			 Group         = "Contract"
			 Section       = "#URL.Section#"
			 Id            = "#URL.ContractId#"
			 BackEnable    = "1"
			 HomeEnable    = "0"
			 ResetEnable   = "#reset#"
			 ResetDelete   = "0"	
			 ProcessEnable = "0"
			 NextSubmit    = "1"
			 NextEnable    = "1"
			 NextMode      = "1"
			 SetNext       = "0">
		 
	</td></tr>	 
	
	</table>
	
</cf_divscroll>

</cfform>	
