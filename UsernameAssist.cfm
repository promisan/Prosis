
<cf_tl id="User Account Assistance" var="1">
<cf_screentop height="100%" html="yes" banner="bluedark" layout="webapp" bannerheight="60" scroll="No" label="#lt_text# - #SESSION.welcome#" user="No" validateSession="No" jquery="yes">

<cf_calendarscript>
<cfajaximport>
   
<cfform name="assist" id="assist" method="post">   

<table width="80%" height="80%" align="center" class="formpadding">
	<tr><td height="45"></td></tr>
	<tr>
		<td height="100%">
			<table align="center">
							
				<tr>
					<td class="labellarge" style="font-size:35px;font-weight:bold">					   
				  		<cf_tl id="User Account Assistance"> 
					</td>
				</tr>
				<tr>
					<td height="30"></td>
				</tr>
				<tr>
					<td class="labellarge" style="font-size:22px">
				  		<cf_tl id="Submit the information below"> <cf_tl id="and we will send to your registered e-Mail address your account information">.
					</td>
				</tr>
					
				<cfoutput>
				
				<tr><td height="30"></td></tr>
				
				<tr>
					<td>				
					 	<table>
					 		<tr>
					     		<td height="40" style="font-size:22px" style="width:50px;" class="labellarge"><cf_tl id="First Name">:</td>
						 		<td>&nbsp;</td>
						 		<td>
						    		<cfinput name="firstname" id="firstname" class="regularxl" style="font-size:24px;height:40px;" type="text" value="" size="15"  maxlength="30" required="yes" message="Please enter your first name">
					     		</td>  
						 		<td>&nbsp;&nbsp;&nbsp;</td>
					 		</tr>
							<tr><td height="5"></td></tr>
							<tr>
					     		<td height="40" style="font-size:22px" style="width:50px;" class="labellarge"><cf_tl id="Last Name">:</td>
						 		<td>&nbsp;</td>
						 		<td>
						    		<cfinput name="lastname" id="lastname" class="regularxl" style="font-size:24px;height:40px;" type="text" value="" size="15"  maxlength="40" required="yes" message="Please enter your last name">
					     		</td>  
						 		<td>&nbsp;&nbsp;&nbsp;</td>
					 		</tr>
							<tr><td height="5"></td></tr>
							<tr>
					     		<td height="40" style="font-size:22px" style="width:50px;" class="labellarge"><cf_tl id="Date of birth">:</td>
						 		<td>&nbsp;</td>
						 		<td>
						    		<cf_intelliCalendarDate9
										FieldName="dob"
										class="regularxl"
										Default="#dateformat(now(), CLIENT.DateFormatShow)#"
										AllowBlank="False">
					     		</td>  
						 		<td>&nbsp;&nbsp;&nbsp;</td>
					 		</tr>
					 	</table>
					</td>
				</tr>
				
				<tr><td height="10"></td></tr>
				<tr>
					<td class="labellarge" style="height:45px" id="process" align="center"></td>
				</tr>
				
				<tr><td height="20"></td></tr>
				<tr><td class="line"></td></tr>
				<tr><td height="22"></td></tr>
				
				<tr>
					<td id="action">
						<table cellspacing="1" cellpadding="1" align="center">
					
					 		<tr>
						 		<td>
								<cf_tl id="Send user account to email on file" var="vLabel2">
						  		<input style="width:400px;height:35px;font-size:16px" type="button" class="button10g" value="#vLabel2#"								   
									onclick="ColdFusion.navigate('#SESSION.root#/UsernameAssistSubmit.cfm','process','','','POST','assist')">
					
						 		</td>
							</tr>
					 	</table>
					 
					 </td>
				</tr>
				</cfoutput>	
				
			</table>
		</td>
	</tr>
</table>
</cfform>


