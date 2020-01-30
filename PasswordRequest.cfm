

<cf_screentop height="100%" 
	    scroll="No" 
		html="Yes"
	    label="Password manager" 
	    option="Set Password" 
		user="No" 
		validateSession="No"
	    jQuery="yes" 
		layout="webapp" 
		banner="gray">
		

<cfquery name="get" 
		datasource="AppsSystem">
			SELECT * 
			FROM   UserPasswordAction
			 WHERE ActionId = <cfqueryparam
						value="#URL.actionid#"
						cfsqltype="CF_SQL_IDSTAMP"> 
</cfquery>

<cfif get.recordcount eq "0" or 
      get.ActionExpiration lt now() or 
	  get.ActionStatus gte "3">

	<table width="100%" height="100%">
	   <tr>
	   	<td align="center" class="labellarge"><cf_tl id="This link has expired"></td>
	   </tr>
    </table>
	<cfabort>

</cfif>


<cfajaxproxy cfc="service.authorization.passwordCheck" jsclassname="systempassword">
		
	<cfoutput>
	
	<script>
	
		var pchecker = new systempassword();
		pchecker.setSyncMode();
						
		function chkButton(act) {
											
			var p1 = $('##Password1').val();			
			var p2 = $('##Password2').val();		
						
			var vreturn   = pchecker.testPassword(p1,'#SESSION.acc#');			
			var vreturn_2 = pchecker.testPassword(p2,'#SESSION.acc#');							
						
			$('##pwdstat').html(vreturn.STATUS);
	 		$('##pwdinfo').html(vreturn.ERRORMESSAGES);
				
			$('##pwdstat_2').html(vreturn_2.STATUS);
	 		$('##pwdinfo_2').html(vreturn_2.ERRORMESSAGES);
	 		
			var enable = 0;

 		if (vreturn.ISPASSWORDVALID && vreturn_2.ISPASSWORDVALID) {
	 			
	 			var vreturn_3 = pchecker.compare(p1,p2);
	 			if (vreturn_3.ISPASSWORDVALID) {
	 				enable = 1;
	 			 } else {	
					$('##pwdstat_2').html(vreturn_3.STATUS);
			 		$('##pwdinfo_2').html(vreturn_3.ERRORMESSAGES);
	 				$('##pwdbox_2').show();
	 				var enable = 0;
	 			 }
	 		} else {
	 			enable = 0;
	 		}
	 		
	 		if (enable==1) {
			    if (act == "submit") {
					formvalidate()
				}
		 		$('##Process').show();
		 		$('##pwdbox').hide();
		 		$('##pwdbox_2').hide();
	 		} else {
	 			// $('##Process').hide();
	 			
	 			if (!vreturn.ISPASSWORDVALID) {
	 				$('##pwdbox').show();	
	 			}		 		
	 			if (!vreturn_2.ISPASSWORDVALID)	{
	 				$('##pwdbox_2').show();	
	 			}	 			
	 		}		
		}
		
		function formvalidate() {		  
			document.passwordform.onsubmit() 
			if( _CF_error_messages.length == 0 ) {
          		ptoken.navigate('PasswordRequestSubmit.cfm?actionid=#URL.actionid#','dprocess','','','POST','passwordform')
			}   				
		}
				
	</script>		
	
	</cfoutput>			
		
	<cfquery name="Parameter" 
		datasource="AppsSystem">
			SELECT  TOP 1 LogonMode
			FROM    Parameter
	</cfquery>	
	
		
	<cfif parameter.LogonMode neq "LDAP">
	
		<cfquery name="Get" 
			datasource="AppsSystem">
				SELECT   *
				FROM     userNames
				WHERE    account = '#SESSION.acc#'
		</cfquery>
		
		<cfquery name="Parameter" 
			datasource="AppsSystem">
				SELECT   *
				FROM     Parameter
		</cfquery>
		
		<cf_preventCache>
				
		<CFFORM name="passwordform" onsubmit="return false" method="post">	
	
			<table width="70%" align="center" cellspacing="0" cellpadding="0">
			 
				<tr>
					<td colspan="3" bgcolor="white" height="40" id="dprocess" name="dprocess">
					</td>
				</tr>
	
				<tr><td colspan="3" bgcolor="white" height="10"></td></tr>				
				
			</table>
	
		<cfoutput>
		
			<!--- Entry form --->
	
			<table width="70%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
				<tr><td height="10"></td></tr>
				<TR>
					<td height="30" class="labelmedium">
						<img src="#SESSION.root#/Images/pointer.gif" border="0">&nbsp;
						<cf_tl id="Account">:
					</td>
				</tr>
				
				<tr><td height="5"></td></tr>
				
				<tr>
					<td style="padding-left:40px">
					   <table>
						   <tr>
							   <td>
							  							  						   
							   																
							   		<input type="Text" 
							           name="Account" 
							           id="Account"
									   required="No" 								 
									   size="25" 
									   maxlength="20" 									  
									   autocomplete="off"
									   class="regularxl enterastab">
																	   
								</td>
							   
						   </tr>
					   </table>
					</td>
				</tr>
									
				<tr><td height="5"></td></tr>
	
				<!--- Field: Password --->
				<tr>
					<td class="labelmedium">
						<img src="#SESSION.root#/Images/pointer.gif" border="0">&nbsp;
						<b><cf_tl id="New"></b> <cf_tl id="password"> <cfif Parameter.PasswordMode eq "Basic">(<cfoutput>#Parameter.PasswordTip#</cfoutput>)</cfif>:
					</td>
				</tr>
				
				<tr><td height="3"></td></tr>
				
				<tr>
					<td style="padding-left:40px">
					   <table>
						   <tr>
							   <td>
							  							  						   
							   	<cfif Parameter.PasswordMode eq "Basic">	
								
							   		<cfinput type="Password" 
							           name="Password1" 
							           id="Password1"
									   validateat="onSubmit" 
									   message="#Parameter.PasswordTip#" 
									   validate="regular_expression" 
									   pattern="#Parameter.PasswordBasicPattern#" 
									   required="No"									  
									   size="25" 
									   maxlength="20" 
									   autocomplete="off"
									   class="regularxl enterastab">
									   
								<cfelse>
																
							   		<input type="Password" 
							           name="Password1" 
							           id="Password1"
									   required="No" 								 
									   size="25" 
									   maxlength="20" 									  
									   autocomplete="off"
									   class="regularxl enterastab" 
									   onblur="chkButton();">
									   
							   	</cfif>	   
									   
								</td>
							   <td id="pwdstat" style="cursor:pointer" onclick="document.getElementById('pwdbox').className='regular'" style="padding-left:5px"></td>
						   </tr>
					   </table>
					</td>
				</tr>
				
				<tr><td height="3"></td></tr>	
				
				<tr id="pwdbox" class="hide">
				     <td colspan="2" class="labelmedium" id="pwdinfo" style="padding-left:35px;height:3px;color:red"></td>
				</tr>
	
				<!--- Field: Password --->
				<tr>
					<td class="labelmedium">
						<img src="#SESSION.root#/Images/pointer.gif" border="0">&nbsp;
						<Cf_tl id="Confirm"> <b><cf_tl id="new"></b> <cf_tl id="password">: 
					</td>
				</tr>
				<tr><td height="3"></td></tr>
				<tr>
					<td style="padding-left:40px">
						<table>
							<tr>
								<td>
								
									<cfif Parameter.PasswordMode eq "Basic">	
									
									<cfinput class="regularxl enterastab" 
									    type="Password" 
										id="Password2" 
										name="Password2" 										
										size="25" 
										maxlength="20"
										autocomplete="off">
									
									<cfelse>
																		
									<input class="regularxl enterastab" 
									    type="Password" 
										id="Password2" 
										name="Password2" 
										size="25" 
										maxlength="20" 
										autocomplete="off"
										onblur="chkButton();">
										
									</cfif>
									
										
								</td>
								<td id="pwdstat_2" style="cursor:pointer; padding-left:5px" onclick="document.getElementById('pwdbox_2').className='regular'"></td>
		
							</tr>	
						</table>	
					</td>
				</tr>
	
				<tr><td height="3"></td></tr>

				<tr id="pwdbox_2" class="hide">
				     <td colspan="2" class="labelmedium" id="pwdinfo_2" style="padding-left:35px;height:3px;color:red"></td>
				</tr>

				<!---
				
				<!--- Field: Password --->
				<tr>
					<td class="labelmedium">
						<img src="#SESSION.root#/Images/pointer.gif" border="0">&nbsp;
						<cf_tl id="YourEMail">: </TD>
				</tr>
				<tr><td height="3"></td></tr>
				<tr>
					<td style="padding-left:40px">
						<cfinput type="Text" name="eMailAddress" value="#get.eMailAddress#" validate="email" required="Yes" size="40" maxlength="40" message="Please enter a valid eMail address. The current address is incorrect." class="regularxl enterastab">
					</td>
				</tr>
	
				<tr><td height="5"></td></tr>
	
				<!--- Field: Password --->
				<tr>
					<td class="labelmedium">
						<img src="#SESSION.root#/Images/pointer.gif" border="0">&nbsp;
						<cf_tl id="TypeHint" class="Message">: </td>
				</tr>
				<tr><td height="3"></td></tr>
				<tr>
					<td style="padding-left:40px">
						<input class="regularxl enterastab" type="Text" name="Hint" id="Hint" size="50" maxlength="50">
					</td>
				</tr>
				
				--->
	
				<tr><td height="15"></td></tr>
				<tr><td height="1" colspan="2" class="line"></td></tr>
				
				<cfif Parameter.PasswordMode eq "Basic">	
				
				<tr>
					<td colspan="2" align="left" style="padding-left:40px">
						<cf_tl id="Submit" var="1">
						<cfset tSave=#lt_text#>
						<input class="button10g" type="button" onclick="formvalidate()" style="height:30;width:140px" name="Process" id="Process" value="#tSave#">
					</td>
				</tr>   
				
				<cfelse>
				
				<tr>
					<td colspan="2" align="left" style="padding-left:40px">
						<cf_tl id="Submit" var="1">
						<cfset tSave=#lt_text#>
						<input class="button10g" type="button" onclick="chkButton('submit')" style="height:30;width:140px" name="Process" id="Process" value="#tSave#">
					</td>
				</tr>   
				
				</cfif>  
				
			</table>
	
		</cfoutput>
	
		</cfform>
	
	<cfelse>
	
		<cfoutput>
			<cf_message message = "<b><font color='800000'>Problem, LDAP authentication mode does not allow change in passwords. Please change your password from LDAP authentication console</font></b>"  return = "UserPassword.cfm">
		</cfoutput>	
	
	</cfif>
	
	<cf_screenbottom layout="webapp">
