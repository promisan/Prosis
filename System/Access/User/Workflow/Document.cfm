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
<cfoutput>
	
	<cf_dialogPosition>
	
	<cfparam name="URL.ID" default="Individual">
	<cfparam name="URL.Mode" default="">
			 
	<cfif url.wparam eq "PHP">
				  
		<cfquery name="Person" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM   Applicant
			WHERE  PersonNo = '#Object.ObjectKeyValue1#'
		</cfquery>
		
		<cfset class = person.applicantclass>
		
		<cfquery name="Submission" 
		   datasource="AppsSelection" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		    SELECT   *
			FROM     ApplicantSubmission
			WHERE    PersonNo = '#Object.ObjectKeyValue1#'
			ORDER BY Created DESC
		</cfquery>	
		
		<cfset pers  = Person.PersonNo>
		<cfset mail  = Person.eMailAddress>
		<cfset index = Person.IndexNo>
		<cfset appl  = Submission.ApplicantNo>
		
		<cfif indexNo neq "">
		
			<cfquery name="Check" 
			datasource="appsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
			    FROM   Person
				WHERE  IndexNo = '#Person.IndexNo#' AND LastName = '#Person.LastName#' 
			</cfquery>
			
			<cfif Check.recordcount neq "1">
			
			  <!--- invalid indexNo --->		  
			  <cfset index = "">
			  
			</cfif>
		
		</cfif>	
		
	<cfelse>
	
		<cfset class = "applicant">	
		
	</cfif>
	 
	<!--- checking if account already exists --->
	
	<cfset source = "user">
	
	<cfquery name="UserNames" 
		datasource="appsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM   UserNames
			WHERE  PersonNo = '#pers#' AND PersonNo is not NULL
			AND    Disabled = 0
	</cfquery> 
	
	<cfif UserNames.recordcount eq "0">
				
		<cfquery name="UserNames" 
			datasource="appsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   UserNames
			 WHERE  eMailAddress = '#mail#' AND eMailAddress > ''
			 AND    Disabled = 0
		</cfquery> 
			
		<cfif UserNames.recordcount neq "1">
			
			<cfquery name="UserNames" 
				datasource="appsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				 SELECT * 
				 FROM   UserNames
				 WHERE  IndexNo = '#index#' AND IndexNo != ''
				 AND    Disabled = 0
			</cfquery> 
			
			<cfif UserNames.recordcount neq "1">
			
				<cfset source = "candidate">
			
			</cfif>
	
		</cfif>
				
	</cfif>
	
	<cfif source eq "user">
		
		<cfset account   = usernames.account>
		<cfset lastname  = usernames.lastname>
		<cfset firstname = usernames.firstname>
		<cfset eMail     = person.eMailAddress>
		<cfset personno  = usernames.personno>
		<cfset indexno   = index>
		<cfset gender    = userNames.gender>
	
	<cfelse>
		
		<cfset account   = person.personNo>
		<cfset lastname  = person.lastname>
		<cfset firstname = person.firstname>
		<cfset eMail     = person.eMailAddress>
		<cfset personno  = person.personno>
		<cfset indexno   = person.indexno>
		<cfset gender    = person.gender>
	
	</cfif>
	  
	<cfquery name="Group" 
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM Ref_AccountGroup
	</cfquery>
	
	<cfquery name="Owner" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM Ref_AuthorizationRoleOwner
		<cfif SESSION.isAdministrator eq "No">
		WHERE Code IN (SELECT ClassParameter 
		               FROM   Organization.dbo.OrganizationAuthorization
	               	   WHERE  Role        = 'AdminUser' 
					   AND    UserAccount = '#SESSION.acc#')
		</cfif>			   
	</cfquery>
	
	<cfif Owner.recordcount eq "0">
	
		<cf_message message = "Your are not authorised to define user group for any owner. Operation not allowed."
		  return = "">
		<cfabort>
	
	</cfif>
	
	<cfinvoke component   = "Service.Access"  
		   method         = "useradmin" 
		   accesslevel    = "'0','1','2'"
		   returnvariable = "accessUserAdmin">
	
	<cfif accessUserAdmin eq "EDIT" or accessUserAdmin eq "ALL">
	
		<cfquery name="Mission" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM Ref_Mission
		</cfquery>
	
	<cfelse>
	
		<cfquery name="Mission" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM Ref_Mission
			WHERE Mission IN (SELECT Mission 
			                  FROM OrganizationAuthorization 
							  WHERE UserAccount = '#SESSION.acc#'
							  AND Role = 'OrgUnitManager')
		</cfquery>
	
	</cfif>
	
	<cf_dialogStaffing>
	
	<!--- Entry form --->
	
	<table width="96%"
	       border="0"
	       cellspacing="0"
	       cellpadding="0"
		   class="formpadding formspacing"
	       align="center">		    
	
		<cfquery name="Check" 
		datasource="appsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM   Ref_SystemModule
			WHERE  SystemModule = 'Staffing' 
			AND    Operational = 1
		</cfquery>
		
		<!---
		
		    <cfif account neq "">
			    <tr><td colspan="3" style="padding-bottom:5px" class="labelmedium"><b><font color="red">Attention:</b> An existing user account has been detected for this candidate under name #Account#. <br>If this is not the correct account simply assign a new account name and continue.</font></td></tr>
			    <input type="hidden" name="detected" id="detected" value="#Account#">
			<cfelse>
			    <input type="hidden" name="detected" id="detected" value=""> 
			</cfif>
			
			--->
		   
			<!--- Field: Account --->
		    <TR class="labelmedium">
		    <td width="25%"><cf_tl id="User Account">: <font color="FF0000">*</font></td>
		    <TD>
			    <table>
				<tr><td>
				
					<cfinput class="regularxl" 
					type="Text" 
					name="Account" 
					value="#account#"
					message="Please enter an account name"
					required="Yes" 
					size="20" 
					onkeyup="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/System/Access/User/Workflow/checkaccount.cfm?detected=#Account#&account='+this.value,'accountcheck')"
					maxlength="20">
				</td>
				<td style="padding-left:3px" id="accountcheck"></td>
				</tr>
				</table>
			</TD>
			</TR>
						
		    <TR>
		    <TD class="labelmedium">#client.IndexNoName#:</TD>
		    <TD>
			
				<table cellspacing="0" cellpadding="0">
				<tr>			
				<td>		    
				<input class="regularxl" type="text" name="indexno" id="indexno" value="#indexNo#" size="20" maxlength="20" readonly>
				<input type="hidden" name="applicantno" id="applicantno" value="#appl#">
				</td>
								
				<td>
				 <input type="hidden" name="personno" id="personno" value="#personno#">
				</td>
				</tr>
				</table>		
				 
				</TD>
			</TR>
				   
		   <input type="hidden" name="AccountType" id="AccountType" value="Individual"> 	
		  	
		    <!--- Field: LastName --->
		    <TR>
		    <TD class="labelmedium"><cf_tl id="LastName">: <font color="FF0000">*</font></TD>
		    <TD>
				<cfinput class="regularxl" type="Text" name="LastName" value="#LastName#" message="Please enter lastname" required="Yes" size="40" maxlength="40">
			</TD>
			</TR>
			 
		    <!--- Field: FirstName --->
		    <TR>
		    <TD class="labelmedium"><cf_tl id="FirstName">: <font color="FF0000">*</font></TD>
		    <TD>
				<cfinput class="regularxl" type="Text" name="FirstName" value="#FirstName#" message="Please enter a firstname" required="Yes" size="30" maxlength="30">
			</TD>
			</TR>
			
			<!--- Field: Applicant.Gender --->
		    <TR>
		    <TD class="labelmedium"><cf_tl id="Gender"></TD>
		    <TD class="labelmedium">
					
		    		<INPUT type="radio" class="radiol" name="Gender" id="Gender" value="M" <cfif gender eq "M">checked</cfif>> Male
			    	<INPUT type="radio" class="radiol" name="Gender" id="Gender" value="F" <cfif gender neq "M">checked</cfif>> Female 
			</TD>
			</TR>			
					
		    <!--- Field: Mission --->
		    <TR>
		    <TD class="labelmedium"><cf_tl id="Entity">: <font color="FF0000">*</font></TD>
		    <TD>
				
		    	<cfselect name="AccountMission" required="Yes" class="regularxl">
				
				<cfif accessUserAdmin eq "ALL" or accessUserAdmin eq "EDIT">
					<option value="Global" selected>Global</option>
				</cfif>
			    <cfloop query="Mission">
				<option value="#Mission#" <cfif usernames.Accountmission eq mission>selected</cfif>>
				#Mission#
				</option>
				</cfloop>
			    </cfselect>	
				</TD>
			</TR>
			
			<input type="hidden" name="EmployeeNo"  id="EmployeeNo"  size="10" maxlength="20" readonly>	
		    <input type="hidden" name="Gender"      id="Gender"      value="">
			<input type="hidden" name="Nationality" id="Nationality" value="">
			<input type="hidden" name="DOB"         id="DOB"         value="">
						
		    <!--- Field: eMail --->
		    <TR>
		    <TD class="labelmedium"><cf_tl id="eMail"><cf_tl id="primary">: <font color="FF0000">*</font></TD>
		    <TD>
				<cfinput type="Text"
			       name="eMailAddress"
			       message="Please enter a valid primary email address"
			       validate="email"
			       required="Yes"
				   value="#eMail#"
			       visible="Yes"
			       enabled="Yes"
			       size="40"
			       maxlength="40"
			       class="regularxl">
			</TD>
			</TR>
					
			 <!--- Field: eMailExternal --->
		    <TR>
		    <TD class="labelmedium"><cf_tl id="eMail"><cf_tl id="alternate">:</TD>
		    <TD>
				<cfinput type="Text"
		       name="eMailAddressExternal"
		       required="No"
		       visible="Yes"
			   value="#UserNames.eMailAddressExternal#"
		       enabled="Yes"
		       size="40"
		       maxlength="40"
		       class="regularxl">
			</TD>
			</TR>
			
		    <!--- Field: AccountGroup --->
		    <TR>
		    <TD class="labelmedium"><cf_tl id="Account Class">: <font color="FF0000">*</font></TD>
		    <TD>	
			<cfif usernames.accountgroup neq "">
			
			    <select name="AccountGroup" required="Yes" class="regularxl">
				    <cfloop query="Group">
						<option value="#AccountGroup#" <cfif usernames.accountgroup eq AccountGroup>selected</cfif>>#AccountGroup#</option>
					</cfloop>
			    </select>		
						
			<cfelse>
			
				<select name="AccountGroup" required="Yes" class="regularxl">
				    <cfloop query="Group">
						<option value="#AccountGroup#" <cfif "portal" eq Category>selected</cfif>>#AccountGroup#</option>
					</cfloop>
			    </select>		

			</cfif>		
		   			
			</TD>
			</TR>	
					
		<td class="labelmedium" valign="top" style="padding-top:3px"><cf_tl id="Memo">:</td>
		<TD>
			<textarea class="regular" style="font-size:13px;padding:3px;width:70%" rows="3" name="Remarks">#UserNames.Remarks#</textarea>
		</td>
		
		</tr>
		
		<input name="savecustom" id="savecustom" type="hidden"  value="System\Access\User\Workflow\DocumentSubmit.cfm">
		
		<cfif class lte "2">	

			<tr><td colspan="2" style="border: 0px solid silver;">
				<cfinclude template="../../Membership/MemberSelect.cfm">
				</td>
			</tr>
			
		</cfif>		
		
	</table>

</cfoutput>	