
<cf_screenTop height="100%" label="Maintain PAS record" html="Yes" layout="webapp" jquery="Yes" banner="gray" scroll="no">

<cf_dialogstaffing>
<cf_dialogposition>
<cf_dialogOrganization>

<cfoutput>

	<script>
	
		function applyunit(org) {    
			    ptoken.navigate('setUnit.cfm?orgunit='+org,'unitprocess')
		}
				
		function ask() {
			if (confirm("Do you want to remove this PAS  ?")) {
				return true 	
			}	
			return false	
		}	
	
	</script>

</cfoutput>

<cfquery name="Contract" 
 datasource="AppsEPAS" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT *
    FROM   Contract
    WHERE  ContractId = '#URL.ContractId#'
</cfquery>

<cf_divscroll>

	<cfform action="EmployeePASEditSubmit.cfm?ContractId=#URL.ContractId#" method="POST" name="action" style="height:98.5%">
	
	<table height="100%" width="100%" style="min-width:850px">
	
	<tr><td height="100%" valign="top">		
	
		<table width="100%">
		
		<tr><td valign="top">
		
			<table width="100%" class="formpadding formspacing">
												
			<cfoutput>
			
			<tr><td style="padding-top:20px;padding-left:20px">
			
			    <table width="99%" align="center" class="formpadding formspacing">
				
				<cfinvoke component = "Service.Access"  
				   method           = "staffing" 
				   mission          = "#Contract.Mission#" 
				   orgunit          = "#Contract.OrgUnit#" 
				   returnvariable   = "accessStaffing">	  		
				   
				<tr class="labelmedium">
				    <td height="24"><cf_tl id="Contract Id">:</td>
			        <td style="font-size:15">#Contract.ContractNo# (<cfif Contract.actionStatus eq "3"><cf_tl id="Completed"></cfif>)</td>
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
			        <td style="font-size:15">#Class.Description#</td>
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
						    SELECT  *
							FROM    Contract
							WHERE   Mission       = '#Contract.Mission#'
							AND     PersonNo      = '#Contract.PersonNo#'
							AND     ContractClass = '#Contract.ContractClass#'
							AND     DateEffective > '#DateFormat(Contract.DateEffective,CLIENT.DateSQL)#'							
							ORDER BY DateEffective 
						</cfquery>	
												
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
							
							<cfif Check.Recordcount gte "1">
							
							<cf_intelliCalendarDate9
								FieldName="DateExpiration" 
								Default="#Dateformat(Contract.DateExpiration, CLIENT.DateFormatShow)#"
								DateValidEnd="#Dateformat(Check.DateEffective-1, 'YYYYMMDD')#"
								class="regularxl"
								AllowBlank="False">	
								
							<cfelse>
							
							<cf_intelliCalendarDate9
								FieldName="DateExpiration" 
								Default="#Dateformat(Contract.DateExpiration, CLIENT.DateFormatShow)#"								
								class="regularxl"
								AllowBlank="False">	
							
							</cfif>	
							</td>
							</tr>
							</table>
					
											
			        </td>
				</tr>   
						
				<cfif (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL") 
				    and (Contract.ActionStatus lte "2" or Contract.ActionStatus eq "8" or Contract.ActionStatus eq "9")>
									
					<tr class="labelmedium">
					    <td height="24"><cf_tl id="Stall">:</td>
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
					    <td height="24"><cf_tl id="Alternate mid-term review">:</td>
				        <td>
						
						<cf_intelliCalendarDate9
								FieldName="PASEvaluation" 
								Default="#Dateformat(Contract.PASEvaluation, CLIENT.DateFormatShow)#"
								class="regularxl"
								AllowBlank="True">	
						</td>
				    </td>
					</tr>
					
					<tr class="labelmedium">
					
						<td valign="top" style="padding-top:4px"><cf_tl id="Stages">:</td>
						<td>
						<table width="70%">
						
							<cfquery name="Section" 
							datasource="appsEPAS" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">							
								SELECT   CS.ContractSection, R.Description, CS.Operational, CS.ProcessStatus, CS.ProcessDate
								FROM     ContractSection AS CS INNER JOIN
								         Ref_ContractSection AS R ON CS.ContractSection = R.Code
								WHERE    CS.ContractId = '#Contractid#'
								ORDER BY ContractSection
							</cfquery>
							
							<cfloop query="Section">							
							<tr class="labelmedium line" style="height:20px">
							    <td>#currentrow#.</td>
								<td>#Description#</td>
								<td><cfif processstatus eq "0">
								   
								   <cfquery name="check" 
									datasource="appsEPAS" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">							
										SELECT   *
										FROM     ContractSection 
										WHERE    ContractId = '#Contractid#'
										AND      ContractSection > '#contractsection#'
										AND      ProcessStatus = '1'								
									</cfquery>
									
								   <cfif check.recordcount eq "0">								     
									   <input type="checkbox" name="field_#ContractSection#" value="1" <cfif operational eq "1">checked</cfif>>
								   <cfelse>
								   		<input type="hidden" name="field_#ContractSection#" value="#operational#">   
								   </cfif>
								   <cfelse>		
								   <input type="hidden" name="field_#ContractSection#" value="1">						   
								   #dateformat(processDate,client.dateformatshow)#
								   </cfif>
							   </td>
							</tr>
							</cfloop>
						
						</table>
						</td>
					
					</tr>
				
				<cfelse>
				
					<input type="hidden" name="PASEvaluation" value="#Dateformat(Contract.PASEvaluation, CLIENT.DateFormatShow)#">
					
				</cfif>
				
						
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
					
					<table>
					
					<cfsavecontent variable="struct">
					
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
					
					</cfsavecontent>
					
					<cfif struct neq "">
					
					<tr class="labelmedium" id="struct"><td colspan="2">#struct#</td></tr>
					
					</cfif>		
										
					<tr class="labelmedium">
					  
					  <td><input type="text" id="orgunitname" name="orgunitname" value="#Contract.OrgUnitName#" size="50" class="regularxl" maxlength="60" readonly style="text-align: left;"></td>					
					    <input type="hidden" id="orgunit" name="orgunit"      value="#Contract.OrgUnit#"> 						
						</td>
						
					  <td style="padding-left:3px">
					  <cfoutput>
					  <img src="#SESSION.root#/Images/search.png" alt="Select authorised unit" name="img0" 
									  onMouseOver="document.img0.src='#SESSION.root#/Images/button.jpg'" 
									  onMouseOut="document.img0.src='#SESSION.root#/Images/search.png'"
									  style="cursor: pointer;" alt="" width="23" height="23" border="0" align="absmiddle" 
									  onClick="selectorgmis('webdialog','orgunit','orgunitcode','mission','orgunitname','orgunitclass','#Unit.Mission#', '#Unit.MandateNo#')">
					  </cfoutput>	
					  
					  </td>		
					  
					  <td id="unitprocess"></td>				
						
					</tr>
					
					</table>
					
					</td>
					
			    </tr>
				
				<tr class="labelmedium">
				    <td height="24"><cf_tl id="Functional Title">:</td>
			        <td>
					<input type="text" class="regularxl" style="width:350px" name="FunctionDescription" value="#Contract.FunctionDescription#">								
					</td>
			    </td>
				</tr>
				
				<cfif (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL") 
				    and (Contract.ActionStatus lte "2" or Contract.ActionStatus eq "8" or Contract.ActionStatus eq "9")>
				
				<tr class="labelmedium">
				    <td height="24"><cf_tl id="Duties are divided accross">:</td>
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
				
				<cfelse>
				
				<input type="hidden" name="EnableTasks" value="#Contract.EnableTasks#">		
				
				</cfif>
							
				<cfloop index="RoleFunction" list="FirstOfficer,SecondOfficer">
													
					<tr class="labelmedium">
					    <td height="24"><cf_tl id="#RoleFunction#">:</td>
						<td>
						
						<table>
						<tr class="labelmedium">
						
						
						
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
						
						<cfif (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL") 
					    and (Contract.ActionStatus lte "2" or Contract.ActionStatus eq "8" or Contract.ActionStatus eq "9")>
						
							<td style="padding-left:3px">				
							
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
						
						</cfif>
						
						<td class="hide">
						<cfinput type="text" name="#RoleFunction#" value="#Role.PersonNo#" message="Please record a #lt_text#" required="No" id="#RoleFunction#">						
						</td>
						
						</tr>
						</table>
						</td>
				    </tr>
				
				</cfloop>		
														
				<tr class="labelmedium"><td style="height:30px" colspan="2"><cf_tl id="Comments">:</td></tr>
						
				<tr class="labelmedium">			    
			        <td colspan="2" style="padding-left:10px"><textarea style="font-size:13px;padding:3px;height:70px;width:96%" class="regular" name="Objective">#Contract.Objective#</textarea></td>
			    </tr>
							
			    </table>
				
			</td></tr>	
			  
			</table>
			
			</cfoutput>
		
		</table>
	
	</td></tr>  
	
	<tr style="height:40px">
		
	<td align="center" colspan="2">
	<table align="center">
	<tr>
	<td><input class="button10g" type="button" name="Close" value=" Close " onclick="window.close()"></td>
	<!--- <td><input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()"></td> --->
	<cfif (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL") 
					    and (Contract.ActionStatus lte "2" or Contract.ActionStatus eq "8" or Contract.ActionStatus eq "9")>
	<td style="padding-left:1px"><input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()"></td>
	</cfif>
	<td style="padding-left:1px"><input class="button10g" type="submit" name="Update" value=" Update "></td>	
	</tr>
	</table>
	</td>	
	
	</tr>
			
	</table>
	
	</cfform>	

</cf_divscroll>
