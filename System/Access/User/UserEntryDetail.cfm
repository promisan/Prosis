
<table width="95%" align="center" class="formpadding">

<cfquery name="Check" 
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM   Ref_SystemModule
		WHERE  SystemModule = 'Staffing' 
		AND    Operational = 1
	</cfquery>
	
		<!--- Field: Account --->
	    <TR class="labelmedium">
	    <td width="25%"><cf_tl id="User account">: <font color="#FF0000">*</font></td>
	    <TD>
			<cfinput class="regularxl" type="Text" name="Account" id="Account" message="Please enter an account name" required="Yes" size="20" maxlength="20">
		</TD>
		</TR>
			
	   <cfif Check.recordCount eq 1>
	
	    <!--- Field: Applicant.IndexNo --->
			
		<cfif URL.ID eq "Individual">
		
	    <TR class="labelmedium">
	    <TD><cf_tl id="Employee No">:</TD>
	    <TD><table cellspacing="0" cellpadding="0">
		    <tr>
			
				<td class="labelmedium" style="width:100px">
					<input class="regularxl" type="text" name="indexno" id="indexno" style="width:160px" size="20" maxlength="20" readonly>
					<input type="hidden" name="personno" id="personno">
				</td>
				<td class="labelmedium" style="padding-left:2px">
				
					 <cf_selectlookup
					    box        = "employee"
						link       = "getPerson.cfm?id=1"
						button     = "Yes"
						close      = "Yes"						
						icon       = "contract.gif"
						iconheight = "22"
						iconwidth  = "22"
						class      = "employee"
						des1       = "PersonNo">			   
					
				 </td>
				 
				 <td id="employee"></td>
			 
			 </tr>
			 </table>
			</TD>
		</TR>
		
		<cfelse>
			<input type="hidden" name="personno" id="personno">
			<input type="hidden" name="indexno" id="indexno">
		</cfif>
		
	   <cfelse>	
	   	  <input type="hidden" name="indexno" id="indexno" size="10" maxlength="20" readonly>
		  <input type="hidden" name="personno" id="personno">
	   </cfif>	
	   
	   <input type="hidden" name="AccountType" id="AccountType" value="<cfoutput>#URL.ID#</cfoutput>"> 	
	  
		<cfif URL.ID eq "Individual">
	
	    <!--- Field: LastName --->
	    <TR class="labelmedium">
	    <TD><cf_tl id="LastName">: <font color="#FF0000">*</font></TD>
	    <TD>
			<cfinput class="regularxl" type="Text" name="LastName" id="lastname" message="Please enter lastname" required="Yes" size="40" maxlength="40">
		</TD>
		</TR>
		 
	    <!--- Field: FirstName --->
	    <TR class="labelmedium">
	    <TD><cf_tl id="FirstName">: <font color="#FF0000">*</font></TD>
	    <TD>
			<cfinput class="regularxl" type="Text" name="FirstName" id="firstname" message="Please enter a firstname" required="Yes" size="30" maxlength="30">
		</TD>
		</TR>
		
		<!--- Field: Applicant.Gender --->
	    <TR class="labelmedium">
	    <TD><cf_tl id="Gender">:</TD>
	    <TD>
				
	    		<INPUT type="radio" class="radiol" name="Gender" id="male" value="M" checked> <cf_tl id="Male">
		    	<INPUT type="radio" class="radiol" name="Gender" id="female" value="F"> <cf_tl id="Female"> 
		</TD>
		</TR>
		
		<cfelse>
		  
	   
	    <TR class="labelmedium">
	    <TD><cf_tl id="Owner">: <font color="#FF0000">*</font></TD>
	    <TD>			
	    	<cfselect name="AccountOwner" id="AccountOwner" class="regularxl">
		    <cfoutput query="Owner">
			<option value="#Code#">#Code#</option>
			</cfoutput>
		    </cfselect>	
			</TD>
		</TR>
		
		   <!--- Field: LastName --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Name">: <font color="#FF0000">*</font></TD>
	    <TD class="labelmedium">
			<cfinput class="regularxl" type="Text" name="LastName" id="LastName" message="Please enter a group name" required="Yes" size="40" maxlength="40">
			<input type="hidden" name="FirstName" id="FirstName" value="Group:">
		</TD>
		</TR>
		
		</cfif>	
		
	    <!--- Field: Mission --->
	    <TR class="labelmedium">
	    <TD><cf_tl id="Entity">: <font color="#FF0000">*</font></TD>
	    <TD>
			
			
	    	<cfselect name="AccountMission" group="MissionType" queryposition="below"
			   query="Mission" value="Mission" style="width:262px" display="Mission" visible="Yes" enabled="Yes" required="Yes" id="AccountMission" 
			   class="regularxl">
			
			<cfif accessUserAdmin eq "ALL">
				<option value="Global" selected><cf_tl id="Global"></option>
			</cfif>
					   
		    </cfselect>	
			</TD>
		</TR>
		
		<input type="hidden" name="EmployeeNo" id="EmployeeNo" size="10" maxlength="20" readonly>	
	    <input type="hidden" name="Gender" id="Gender" value="">
		<input type="hidden" name="Nationality" id="Nationality" value="">
		<input type="hidden" name="DOB" id="DOB" value="">
		
		<cfif URL.ID eq "Individual">
	
	    <!--- Field: eMail --->
	    <TR class="labelmedium">
	    <TD style="min-width:220px"><cf_tl id="eMail">-<cf_tl id="Primary">: <font color="#FF0000">*</font></TD>
	    <TD>
			<cfinput type="Text"
		       name="eMailAddress"
	           id="eMailAddress"
		       message="Please enter a valid primary email address"
		       validate="email"
		       required="Yes"
		       visible="Yes"
		       enabled="Yes"
		       size="40"
		       maxlength="40"
		       class="regularxl">
		</TD>
		</TR>
		
		<cfelse>
		
		<!--- Field: eMail --->
	    <TR class="labelmedium">
	    <TD><cf_tl id="eMail">-<cf_tl id="Primary"> :</TD>
	    <TD>
			<cfinput type="Text"
		       name="eMailAddress"
	           id="eMailAddress"
		       message="Please enter a valid primary email address"
		       validate="email"
		       required="No"
		       visible="Yes"
		       enabled="Yes"
		       size="30"
		       maxlength="40"
		       class="regularxl">
		</TD>
		</TR>		
		
		</cfif>
		
		 <!--- Field: eMailExternal --->
	    <TR class="labelmedium">
	    <TD><cf_tl id="eMail">-<cf_tl id="Secundary">:</TD>
	    <TD>
			<cfinput type="Text"
		       name="eMailAddressExternal"
	           id="eMailAddressExternal"
		       required="No"
		       visible="Yes"
		       enabled="Yes"
		       size="30"
		       maxlength="40"
		       class="regularxl">
		</TD>
		</TR>
		
		<!--- Field: LDAP Domain --->
	    <TR class="labelmedium">
		    <TD><cf_tl id="LDAP Domain">:</TD>
		    <TD>
		    					
				<cfinput type="Text"
			       name="MailServerDomain"			       
			       required="No"
				   class="regularxl"
		    	   visible="Yes"
			       enabled="Yes"
			       size="20"
			       maxlength="80">
				
			</TD>
			</TR>   
			  
		    <!--- Field: Mail Server Account --->
		 <TR class="labelmedium">
		    <TD><cf_tl id="LDAP Name">:</TD>
		    <TD>
		    					
					<cfinput type="Text"
			       name="MailServerAccount"			      
			       required="No"
				   class="regularxl"
			       visible="Yes"
			       enabled="Yes"
			       size="30"
			       maxlength="80">				
				
			  
			</TD>
		</TR>   
		
	    <!--- Field: AccountGroup --->
	    <TR class="labelmedium">
	    <TD><cf_tl id="Account Class">: <font color="FF0000">*</font></TD>
	    <TD>
		
	    	<cfselect name="AccountGroup" id="AccountGroup" required="Yes" class="regularxl">
			    <cfoutput query="Group">
					<option value="#AccountGroup#">#AccountGroup#</option>
				</cfoutput>
		    </cfselect>	
				
		</TD>
		</TR>
		
		<cfif URL.ID eq "Individual">
		
		<TR>
			<td valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Session Settings">:&nbsp;</td>
			<TD>
			<table width="99%" border="0" cellspacing="0" cellpadding="0" align="left">
			<tr class="labelmedium" style="height:10px">
			    <td>Disable Password expiration :</td>
				<TD>		    		
					<input type="checkbox" name="PasswordExpiration" id="PasswordExpiration" value="1">					
				</TD>
				<TD style="padding-left:10px"  class="labelmedium">Allow Concurrent sessions :</TD>
			    <TD>		    
				<input type="checkbox" name="AllowMultipleLogon" id="AllowMultipleLogon" value="1">
				</TD>
			</tr>
			<tr class="labelmedium" style="height:10px">
			    <td>Disable Session timeout :</td>
				<TD><input type="checkbox" name="DisableTimeout" id="DisableTimeout" value="1"></TD>
				<TD style="padding-left:10px"  class="labelmedium"><cf_UIToolTip  tooltip="Applies to system messages (password change etc.)">Disable e-Mail notification :</cf_UIToolTip></TD>
			    <TD><input type="checkbox" name="DisableNotification" id="DisableNotification" value="1"></TD>
			</tr>
			<tr class="labelmedium" style="height:10px">
			    <td>Disable IP Routing :</td>
				<TD>		    	
				<input type="checkbox" name="DisableIPRouting" id="DisableIPRouting" value="1">				
				</TD>
				<td style="padding-left:10px" class="labelmedium">Disable Friendly Error Message :</td>
				<TD>		    	
				<input type="checkbox" name="DisableFriendlyError" id="DisableFriendlyError" value="1">				
				</TD>
				
			</tr>
			
			<tr class="labelmedium" style="height:10px">
	    
				<td><cf_UIToolTip tooltip="User is granted access onto the pre-production server">Enable as Pre-production user:</cf_UIToolTip></td>
				<TD>		    	
				<input type="checkbox" name="EnablePreProduction" id="EnablePreProduction" value="1">				
				</TD>
							
			</tr>
			
			</table>
			
			</td>
		</tr>
			
		</cfif>		
		
	<tr class="labelmedium">		
	 <td valign="top" style="padding-top:3px"><cf_tl id="Notes">:</td>
	 <TD><textarea class="regular" style="width:99%;padding:3px;font-size:13px" rows="2" name="Remarks" id="Remarks"></textarea>
	</TD>
	</TR>
	
</table>	