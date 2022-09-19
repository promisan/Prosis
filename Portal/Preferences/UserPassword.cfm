<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>SAT CHANGE</proDes>
	<proCom>SAT CHANGE</proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   UserNames 
	WHERE  Account = '#SESSION.acc#'
</cfquery>

<cfquery name="GetHistory" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP 5 PasswordExpiration
	FROM     UserPasswordLog
	WHERE    Account = '#SESSION.acc#'
	ORDER BY PasswordExpiration DESC
</cfquery>

<cfform method="POST" onsubmit="return false" name="formsetting">
        
<cfset objPwdCheck = CreateObject("component","service.authorization.passwordCheck")/>

<cfif Len(Trim(Get.Password)) gt 20> 
      <cf_decrypt text = "#Get.Password#">
	  <cfset vPassword = Decrypted>
<cfelse>
	  <cfset vPassword = Get.Password>
</cfif>

<cfset objResponse = objPwdCheck.testPassword('#vPassword#','#SESSION.acc#')>

<cfset vResult = DeserializeJSON(objResponse)>
 	
<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td height="4"></td></tr>
	
	<tr class="line"><td colspan="2" class="labellarge"><span style="font-size: 24px;margin: 10px 0 6px;display: block;color: #52565B;"><cf_tl id="Password"></span></td></tr>
	
	<tr><td height="6"></td></tr>
	
	<cfif get.EnforceLDAP eq "1">
	
		<TR>
		    <TD colspan="2" height="20" width="280" class="labellarge"><font color="gray"><cf_tl id="You are required to logon with your LDAP credentials"></font><cfoutput><br><br>: #get.MailServerAccount#<br>: #get.eMailAddress#</cfoutput></TD>
		    
		</TR>
	
	<cfelse>
	
		<cfif session.acc neq "Administrator">
			
		<cfquery name="Param" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Parameter	
		</cfquery>
		
		<cfset days = Param.PasswordExpiration * 7>
		
		<cftry>
			
		<cfquery name="GetLast" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    MAX(PasswordExpiration) + #days# AS Last
			FROM      UserPasswordLog
			WHERE     Account = '#session.acc#'
		</cfquery>	
	
		    <TR>
		    <TD height="20" width="280" class="labelmedium"><cf_tl id="Current password expires">: </TD>
		    <TD>
			
			<cfif getLast.last gt now()>
			
			   <cfoutput>
			   in <b><font size="5">#dateDiff("d",  now(), getLast.last)#</b></font> <cf_tl id="Days">
			   </cfoutput>
			
			<cfelse>
			
				<b><cf_tl id="Today"></b>		
				
			</cfif>
			    	
			</TD>
			</TR>
		
			<cfcatch>
			
				<TR>
			    <TD height="20" width="280" class="labelmedium"><cf_tl id="It is recommended to change your password">.</TD>
			    <TD></TD>
				</TR>
			
			</cfcatch>
		
		</cftry>
		
		</cfif>	
		
	
	    <TR>
	    <TD height="20" width="280" valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Active Password strength">: </TD>
	    <TD class="labelmedium" style="padding-top:4px" > 
		<cfif vResult.ErrorMessages neq "">
		    <font color="FF0000"><cfoutput>#vResult.ErrorMessages#</cfoutput></font>
		<cfelse>
		   <cfoutput>#vResult.Status#</cfoutput>
		</cfif>
		</td>
	    </TR>
		
		<cfif getHistory.recordcount gte "1">
		
		    <TR>
		    <TD height="20" width="180" class="labelmedium" valign="top"><cf_tl id="You changed your password on">: </TD>
		    <TD>
		    	<cfoutput>
		    	<table width="100%">
				<cfloop query = "GetHistory">
						<tr>
							<td style="height:15px" class="labelmedium">
								#dateformat(GetHistory.PasswordExpiration, "mm/dd YYYY")# @ #dateformat(GetHistory.PasswordExpiration, "HH:mm")#
							</td>	
						</tr>	
				</cfloop>
				</table>	
				</cfoutput>
			</TD>
			</TR>
		
		</cfif>
	
	 </cfif>	
	
	<tr><td height="5"></td></tr>
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	<tr><td height="5"></td></tr>
	
	<tr><td height="1" colspan="2">
	
	<cf_tl id="Save" var="vSave">
	
	<cfif get.EnforceLDAP eq "0">
	
		<cfoutput>
		<input type="button" onclick="prefsubmit('password')" name="Save" id="Save" value="#vSave#" class="button10g">
		</cfoutput>
		
	</cfif>
		
	</td></tr>
	
</table>	

</cfform>

<script>
	Prosis.busy('no');	
</script>