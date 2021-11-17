
<cfquery name="Group" 
datasource="appsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_AccountGroup
</cfquery>

<cfquery name="System" 
datasource="appsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Parameter
</cfquery>

<cfquery name="Owner" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_AuthorizationRoleOwner
	WHERE  Operational = 1
</cfquery>

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   UserNames 
	WHERE  Account = '#URL.ID#'
</cfquery>

<cfinvoke component   = "Service.Access"  
	   method         = "useradmin" 
	   accesslevel    = "'0','1','2'"
	   returnvariable = "accessUserAdmin">

<cfif accessUserAdmin neq "NONE">

	<cfquery name="Mission" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM   Ref_Mission
		ORDER BY MissionOwner
	</cfquery>

<cfelse>
	
	<cfquery name="Mission" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM Ref_Mission
		WHERE Mission IN (SELECT Mission 
			                  FROM   OrganizationAuthorization 
							  WHERE  UserAccount = '#SESSION.acc#'
							  AND    Role = 'OrgUnitManager') OR Mission = '#get.AccountMission#'
		ORDER BY MissionOwner
	</cfquery>

</cfif>

<cfparam name="url.script" default="">

<cfif url.script neq "">
	<cfset user = "No">
<cfelse>
	<cfset user = "Yes">
</cfif>

<cfif Get.AccountType eq "Individual">

		<cf_tl id="User Account Settings" var="1">
	
     	<cf_screenTop height="100%" 
		   jquery         = "Yes" 
		   layout         = "webapp" 
		   scroll         = "no"
		   bannerforce    = "Yes"
		   textColorLabel = "black"
		   user           = "no"
		   html           = "no"
		   menuaccess     = "Context"
		   label          = "#lt_text#" 		  
		   systemmodule   = "System"		   
		   functionclass  = "Window"
		   functionName   = "UserAccount">
<cfelse>

		<cf_tl id="User Group Settings" var="1">
		
	    <cf_screenTop height="100%" 
		    jquery        = "Yes" 
			layout        = "webapp" 
			textColorLabel ="black"
			bannerforce    = "Yes"
			scroll         = "no"
			user           = "no"
			html           = "no"
			menuaccess     = "Context"
			label          = "#lt_text#" 				 
		    systemmodule   = "System"
		    functionclass = "Window"
		    functionName  = "UserGroup">
			
</cfif>

<cf_dialogPosition>
<cf_textAreaScript>

<cf_divscroll>

	<table width="100%" height="100%">
			
	<tr><td valign="top" height="100%">
						
		<cfform action="UserEditSubmit.cfm?script=#url.script#" method="POST" target="myresult" name="useredit">
	
		<table width="92%" align="center" class="formpadding">
		
			<tr class="hide"><td colspan="2">
		   <iframe name="myresult" height="100" width="100%" id="myresult" scrolling="yes" frameborder="0"></iframe>
		   </td>
			</tr>
		
		   <!--- Field: Account --->	   
		   
		    <TR>
		    <TD height="22" class="labelmedium"><cf_tl id="Account">:</TD>
		    <TD class="labellarge" style="font-size:23px">
		        <cfoutput query="get">	    
				#Account#				
			    </cfoutput>
			</TD>
			</TR>
			
			<input type="hidden" name="Account" id="Account" value="<cfoutput>#get.Account#</cfoutput>">
			<input type="hidden" name="AccountType" id="AccountType" value="<cfoutput>#Get.AccountType#</cfoutput>">
			
			<cfif Get.AccountType eq "Individual">
			
			<!--- check --->
			
				<cfquery name="check" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT  * 
				    FROM    Applicant.dbo.ApplicantSubmission
					WHERE   ApplicantNo = '#get.ApplicantNo#'		
				</cfquery>
				
				<cfquery name="staff" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT  * 
				    FROM    Employee.dbo.Person
					WHERE   PersonNo = '#get.PersonNo#'		
				</cfquery>
			
				<cfif check.recordcount eq "1">
				
					<TR>
				    <TD class="labelmedium"><cf_tl id="Natural Person">:</TD>
				    <TD class="labelmedium">
						
				    	<cfoutput>		
						<table>
						<tr>
						
						<td><cf_tl id="Submission">:</td>
						<td style="padding-left:10px">
						<input style="background-color:f1f1f1" type="text" name="ApplicantNo" id="applicantNo" value="#get.ApplicantNo#" size="5" maxlength="20" class="regularxl enterastab" readonly>
						</td>
						
						<cfif staff.recordcount eq "1">
						
							<td><cf_tl id="Staff">:</td>
							<td style="padding-left:4px">
							<input style="background-color:f1f1f1" type="text" name="EmployeeNo" id="personno" value="#get.PersonNo#" size="10" maxlength="20" class="regularxl enterastab" readonly>
							</td>
							<td style="padding-left:0px">
							
							 <cf_selectlookup
									    box        = "employee"
										link       = "getPerson.cfm?id=1"
										button     = "Yes"
										close      = "Yes"						
										icon       = "search.png"
										iconheight = "25"
										iconwidth  = "25"
										class      = "employee"
										des1       = "PersonNo">
									
							</td>
							
							<td id="employee"></td>
						
						<cfelse>
						
							<td style="padding-left:4px">
							<input style="background-color:f1f1f1" type="text" name="EmployeeNo" id="personno" value="#check.PersonNo#" size="10" maxlength="20" class="regularxl enterastab" readonly>
							</td>
							<td style="padding-left:10px"><cf_tl id="Set as staff">:</td>
							<td style="padding-left:0px">
							
							 <cf_selectlookup
									    box        = "employee"
										link       = "getPerson.cfm?id=1"
										button     = "Yes"
										close      = "Yes"						
										icon       = "search.png"
										iconheight = "25"
										iconwidth  = "25"
										class      = "employee"
										des1       = "PersonNo">
									
							</td>
							<td id="employee"></td>	
						</cfif>	
										
						<input type="hidden" name="indexno" id="indexno" value="#get.indexNo#">					
						</cfoutput>						
						</tr>				
						</table>
								   
					</TD>
					</TR>				
				
				<cfelse>						
					
				    <TR>
				    <TD class="labelmedium"><cf_tl id="EmployeeNo">:</TD>
				    <TD class="labelmedium">
						
				    	<cfoutput>		
						<table cellspacing="0" cellpadding="0"><tr><td>
						<input type="text" name="EmployeeNo" id="personno" value="#get.PersonNo#" size="10" maxlength="20" class="regularxl enterastab" readonly>
						</td>
						<td style="padding-left:0px">
						
						 <cf_selectlookup
								    box        = "employee"
									link       = "getPerson.cfm?id=1"
									button     = "Yes"
									close      = "Yes"						
									icon       = "search.png"
									iconheight = "25"
									iconwidth  = "25"
									class      = "employee"
									des1       = "PersonNo">
								
						</td>
						
						<input type="hidden" name="indexno" id="indexno" value="#get.indexNo#">
						
						</cfoutput>	
								 	    	
						<td id="employee">
								    
						</td>			
						</tr>
						
						</table>
								   
					</TD>
					</TR>
					
				</cfif>
			
			</cfif>
			
			
			<cfif Get.AccountType eq "Individual">
		
			  <!--- Field: LastName --->
			 <TR>
			    <td class="labelmedium" width="120"><cf_tl id="LastName">:</td>
			    <TD class="labelmedium">
			  	   
					<cfinput type="Text" class="regularxl enterastab" id="lastname" name="LastName" value="#get.lastname#" message="Please enter lastname" required="Yes" size="35" maxlength="40">
					
			    </TD>
				</TR>
				
			    <!--- Field: FirstName --->
			    <TR>
			    <TD class="labelmedium"><cf_tl id="FirstName">:</TD>
			    <TD class="labelmedium">
				    
					  <cfinput type="Text" class="regularxl enterastab" id="firstname" name="FirstName" value="#get.firstname#" message="Please enter a firstname" required="Yes" size="30" maxlength="30">			  
									
				</TD>
				</TR>
				
				<!--- Field: Applicant.Gender --->
			    <TR>
			    <TD class="labelmedium" style="height:30px"><cf_tl id="Gender">:</TD>
			    <TD class="labelmedium">	
				    <table><tr class="labelmedium">
					<td><INPUT type="radio" class="radiol enterastab" name="Gender" ID="male" value="M" <cfif get.gender neq "F">checked</cfif>></td>
					<td style="padding-left:3px"><cf_tl id="Male"></td>
					<td style="padding-left:5px"><INPUT type="radio" class="radiol enterastab" name="Gender" id="female" value="F" <cfif get.gender is "F">checked</cfif>></td>
					<td style="padding-left:5px"><cf_tl id="Female"></td>
					</tr>
					</table>	
				</TD>
			</TR>
				
			<TR>
		    <TD class="labelmedium"><cf_tl id="Owner">:</TD>
		    <TD class="labelmedium">
			
		    	<select name="AccountOwner" id="AccountOwner" class="regularxl enterastab">
				    <option value="" selected>N/A</option>
				    <cfoutput query="Owner">
					<cfif get.AccountOwner IS Code>
		        	 		 <option value="#Code#" selected>
					<cfelse> <option value="#Code#">
					</cfif>#Code#
					</option>
					</cfoutput> 
			    </select>	
					
			</TD>
			</TR>
			
			<cfelse>
			
		    <!--- Field: Owner --->
			
			<TR>
		    <TD class="labelmedium"><cf_tl id="Owner">:</TD>
		    <TD class="labelmedium">
			
		    	<select name="AccountOwner" id="AccountOwner" class="regularxl">
				    <option value="" selected>N/A</option>
				    <cfoutput query="Owner">
					<cfif get.AccountOwner IS #Code#>
		        	 		 <option value="#Code#" selected>
					<cfelse> <option value="#Code#">
					</cfif>#Code#
					</option>
					</cfoutput> 
			    </select>	
					
			</TD>
			</TR>
			  
			<!--- Field: LastName --->
			<TR>
			    <td class="labelmedium" width="120"><cf_tl id="Name">:</td>
			    <TD class="labelmedium">
			  	    <cfoutput query="get">
					<cfinput type="Text" class="regularxl" name="LastName" value="#lastname#" message="Please enter lastname" required="Yes" size="40" maxlength="40">
			    	<input type="Hidden" name="FirstName" id="FirstName" value="#firstname#">
					</cfoutput>
				</TD>
			</TR>
						
			</cfif>
			
			<!--- Field: AccountGroup --->
		    <TR>
			
		    <td class="labelmedium" title="Classification of the account"><cf_tl id="Account Group">:</td>			
		    <TD class="labelmedium">
			
				<cfset nat = get.AccountGroup>
		    	<cfselect name="AccountGroup" required="Yes" class="regularxl">
			    <cfoutput query="Group">
				<cfif AccountGroup IS nat>
		         		 <option value="#AccountGroup#" selected>
				<cfelse> <option value="#AccountGroup#">
				</cfif>#AccountGroup#
				</option>
				</font>
				</cfoutput> 
			    </cfselect>	
					
			</TD>
			</TR>
			  
		    <TR>
		    <TD class="labelmedium"><cf_tl id="Managing entity">:</TD>
		    <TD>
			
			  <cfif Get.AccountType neq "Individual">	
			
				  <cfselect name   = "AccountMission"
			         group         = "MissionOwner"
					 queryposition = "below"
			         query         = "Mission"
					 class         = "regularxl"
					 onchange      = "_cf_loadingtexthtml='';ptoken.navigate('getFunction.cfm?usergroup=#url.id#&mission='+this.value,'functions')"
				     selected      = "#get.AccountMission#"
			         value         = "Mission"
			         display       = "Mission">	
					 
					 <cfif accessUserAdmin eq "ALL">
						<option value="Global" selected><cf_tl id="Not defined"></option>
					</cfif>
					 
				   </cfselect>	 
				   
			   <cfelse>
			   
				    <cfselect name   = "AccountMission"
			         group         = "MissionOwner"
					 queryposition = "below"
			         query         = "Mission"
					 class         = "regularxl"					 
				     selected      = "#get.AccountMission#"
			         value         = "Mission"
			         display       = "Mission">		
						 <cfif accessUserAdmin neq "NONE">
					     <option value="Global" selected>Global</option>
						 </cfif>
				   </cfselect>
			   			   
			   </cfif>
			   			
			</TD>
			</TR>
			
			<cfif Get.AccountType neq "Individual">
			
				<tr>
				
					<td valign="top" class="labelmedium"><cf_tl id="Functions">:</td>
					<td style="width:100%;height:100%" id="functions">
					
					<cfset url.usergroup = url.id>
					<cfset url.mission   = get.accountMission>
					<cfinclude template = "getFunction.cfm">
					
					</td>
				
				</tr>
			
			</cfif>
			
			  <!--- Field: Mail Server Account --->
		    <TR>
		    <TD style="min-width:140px" class="labelmedium"><cf_tl id="Corporate Logon">:</TD>
		    <TD class="labelmedium">
		    	<cfoutput query="get">
				
				<cfinput type="Text"
			       name="AccountNo"
			       value="#AccountNo#"
			       required="No"
				   class="regularxl"
			       visible="Yes"
			       enabled="Yes"
			       size="40"
			       maxlength="40">
				
				
			    </cfoutput>	
			</TD>
			</TR>   
			  
						  
		    <!--- Field: Mail Server Account --->
		    <TR>
		    <TD class="labelmedium"><cf_tl id="LDAP Domain">:</TD>
		    <TD class="labelmedium fixlength">
		    	<cfoutput query="get">
				
				<cfinput type="Text"
			       name="MailServerDomain"
			       value="#MailServerDomain#"
			       required="No"
				   class="regularxl"
		    	   visible="Yes"
			       enabled="Yes"
			       size="10"
			       maxlength="20">
				   
				   /
				   
				<cfinput type="Text"
			       name="MailServerAccount"
			       value="#MailServerAccount#"
		    	   required="No"
				   class="regularxl"
		       	   visible="Yes"
		           enabled="Yes"
		           size="60"
				   style="width:400px">				
				
			    </cfoutput>	
			</TD>
			</TR>   
			
			
				
		    <!--- Field: eMail --->
		    <TR>
		    <TD class="labelmedium"><cf_tl id="eMail"> 1:</TD>
		    <TD>
		    	<cfoutput query="get">
				<cfinput type="Text"
			       name="eMailAddress"
			       value="#eMailAddress#"
			       validate="email"
			       required="No"
				   class="regularxl"
			       visible="Yes"
			       enabled="Yes"
			       size="50"
			       maxlength="60"> 
				
				
			    </cfoutput>	
			</TD>
			</TR>
			
			<cfif Get.AccountType eq "Individual">
				
			 <!--- Field: eMailExternal --->
		    <TR>
		    <TD class="labelmedium"><cf_tl id="eMail"> 2:</TD>
		    <TD>
		    	<cfoutput query="get">
				<cfinput type="Text"  class="regularxl" validate="email" name="eMailAddressExternal" value="#eMailAddressExternal#" required="No" size="50" maxlength="60">
				</cfoutput>	
			</TD>
			</TR>
			
			</cfif>
			
			<tr>		
				
			<td class="labelmedium" valign="top" style="min-width:160px;padding-top:4px"><cf_tl id="Remarks">:</td>
			 <TD height="100%">
			 <cfoutput query="get">
			   <textarea style="width:98%;height:60px;padding:3px;font-size:13px" class="regular" id="" name="Remarks" type="text" size="50" maxlength="200">#Remarks#</textarea>
			 </cfoutput>
			</TD>
			</TR>
			
		    <TR class="fixlengthlist">
			<td class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Session settings">:&nbsp;</td>
			
			<TD style="background-color:f1f1f1;padding-left:8px;padding-right:4px">
				
				<table width="100%" align="center">
				<tr class="fixlengthlist">
				    <td class="labelit" title="Password will not longer expire based on the general system settings">Disable Password expiration after <cfoutput>#System.PasswordExpiration#</cfoutput> weeks </td>
					<TD>
			    		<cfoutput query="get">
						<input type="checkbox" class="radiol"  name="PasswordExpiration" id="PasswordExpiration" value="1" <cfif PasswordExpiration eq "1">checked</cfif>>
						</cfoutput>	
					</TD>
					<TD class="labelit"><cf_tl id="Allow Concurrent">:</TD>
				    <TD title="Account can be logged on on multiple instances.">
			    	<cfoutput query="get">
					<input type="checkbox" class="radiol"  name="AllowMultipleLogon" id="AllowMultipleLogon" value="1" <cfif AllowMultipleLogon eq "1">checked</cfif>>
					</cfoutput>	
					
					</TD>
				</tr>
				<tr class="fixlengthlist">
				
				    <td class="labelit"><cfoutput>Disable Session timeout after #System.SessionExpiration# min :</cfoutput></td>
					<TD>
			    	<cfoutput query="get">
					<input type="checkbox" class="radiol"  name="DisableTimeout" id="DisableTimeout" value="1" <cfif DisableTimeOut eq "1">checked</cfif>>
					</cfoutput>	
					</TD>
					
					<TD class="labelit" title="Applies to system messages (password change etc.)">Disable e-Mail notification:</TD>
				    <TD>
			    	<cfoutput query="get">
					<input type="checkbox" class="radiol"  name="DisableNotification" id="DisableNotification" value="1" <cfif DisableNotification eq "1">checked</cfif>>
					</cfoutput>	
					</TD>
					
				</tr>
				<tr class="fixlengthlist">
				    
					<td class="labelit"><cf_tl id="Disable IP routing">:</td>
					<TD>
			    	<cfoutput query="get">
					<input type="checkbox" class="radiol"  name="DisableIPRouting" id="DisableIPRouting" value="1" <cfif DisableIPRouting eq "1">checked</cfif>>
					</cfoutput>	
					</TD>
					
					<td class="labelit">Disable Friendly Error Message :</td>
					<TD>
			    	<cfoutput query="get">
					<input type="checkbox" class="radiol"  name="DisableFriendlyError" id="DisableFriendlyError" value="1" <cfif DisableFriendlyError eq "1">checked</cfif>>
					</cfoutput>	
					</TD>
					
				</tr>
				
				<tr class="fixlengthlist">
				    
					<td class="labelit" title="User is granted access onto the pre-production server">Enable as Pre-production user:</td>
					<TD>
			    	<cfoutput query="get">
					<input type="checkbox" class="radiol"  name="EnablePreProduction" id="EnablePreProduction" value="1" <cfif EnablePreProduction eq "1">checked</cfif>>
					</cfoutput>	
					</TD>
					
					<cfif System.LogonMode eq "Mixed">
						<td class="labelit" title="User is granted access onto the pre-production server"><cf_tl id="Enforce LDAP">:</td>
						<TD>
				    	<cfoutput query="get">
						<input type="checkbox" class="radiol" name="EnforceLDAP" id="EnforceLDAP" value="1" <cfif EnforceLDAP eq "1">checked</cfif>>
						</cfoutput>	
						</TD>
					<cfelse>
						<input type="hidden" name="EnforceLDAP" value="<cfoutput>#Get.EnforceLDAP#</cfoutput>">
					</cfif>
								
				</tr>
				
				</table>
			
			</td>
			</tr>
			
			<tr class="line fixlengthlist">		
				
			<td class="labelmedium" style="padding-top:4px"><cf_tl id="Recorded by">:</td>
			 <TD height="100%" class="labelmedium">
						 
			 <table>
			 
			 <tr class="fixlengthlist labelmedium2">
			 <td>
			  <cfoutput query="get">
			  <cfif OfficerLastName eq "">undefined<cfelse>#OfficerFirstName# #OfficerLastName#</cfif> on #dateformat(created,CLIENT.DateFormatShow)#
			 </cfoutput>
			 </td>
						 
			 <cfquery name="Last" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   TOP 1 *
				    FROM     UserStatusLog
				    WHERE    Account = '#URL.ID#'
					ORDER BY Created DESC
				</cfquery>
					
					<cfoutput>
					 		    	  
						 <td><cf_tl id="Last Logon">:</td>
						 <td>
						 <cfif Last.Created eq ""><font color="FF0000"><cf_tl id="never"></b>
						 <cfelse>#DateFormat(Last.Created, CLIENT.DateFormatShow)#
						 </cfif>
						 </td>
									
					</cfoutput>	
								 
			    <td><cf_tl id="Password">:</td>
				<td>
				<cfif len(get.Password) lte 10>
					<font color="FF0000"><cf_tl id="Unsecure password"></font>
				<cfelse>
					<cf_tl id="Secure password">
				</cfif>
				</td>				 
			 
			 </table>
			 </td>
			 
			
			</TD>
			</TR>
			
			<cfif get.recordcount eq "1">
					
				<tr><td colspan="2" align="center" height="25" style="padding-top:5px">				  
					<input class="button10g" style="width:140px;height:27px" type="button" value="Close" onClick="parent.ProsisUI.closeWindow('mydialog',true)">					
					<input class="button10g" style="width:140px;height:27px" type="submit" value="Save">
				</td></tr>
			
			</cfif>
		
		</table>
		
		</CFFORM>
			
	</td>
	</tr>
	
	</table>
	
</cf_divscroll>	
