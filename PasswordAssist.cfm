
<cfparam name="url.mode"      default="regular" type="string">
<cfparam name="url.source"    default="backoffice" type="string">
<cfparam name="session.acc"   default="" type="string">
<cfparam name="client.dateformatshow"   default="DD/MM/YYYY" type="string">


<cfset logon = session.acc>
<cfajaximport>
<cf_SystemScript>

<cf_tl id="Password Reset" var="1">


<script src="Scripts/jQuery/jquery.js" type="text/javascript"></script>




<cf_tl id="Please enter a user account" var="lblErrorAccount">

<cfoutput>
	<script>

		function process(){
			if (document.getElementById('account').value.length > 0) { 
					ptoken.navigate('PasswordAssistSubmit.cfm?mode=#url.mode#','process','','','POST','assist');
			} else{ 
				alert('#lblErrorAccount#');
			}
		}

	</script>
</cfoutput>


<!--- obtain the mode --->
<style>
    body{
	font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,Ubuntu,Cantarell,"Helvetica Neue",sans-serif,'Raleway', sans-serif!important;
	font-size: 13px;
	line-height: 23px;
	color: #555555;
	font-weight: 200;
    }
    td font{
	font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,Ubuntu,Cantarell,"Helvetica Neue",sans-serif,'Raleway', sans-serif!important;
    }
    h2{
        font-size: 36px;
        font-weight: 200;
    }
    input.button{
        background-color: #3498db;
        font-size:15px;
        color: #ffffff;
        height: 40px;
        width:180px;
        display: block;
        padding: 5px;
        border: 0;
        border-radius: 5px;
        cursor: pointer;
    }
    input.button:hover{
        background-color: #006dc6;
    }
</style>

<form name="assist" id="assist" method="post">
    
<table width="80%" height="80%" align="center" class="formpadding" style="max-width: 650px;">
	<tr>
        <td>
            <cfoutput><img src="Images/Prosis-Logo-blue.png" alt="" border="0" height="42" width="150" style="margin: 25px 0;"></cfoutput>
        </td>
    </tr>
	<tr bgcolor="#f6f6f6" style="background-color: #f6f6f6;">
		<td height="100%" style="padding:20px">
			<table align="center">
			
			<cfoutput>
			
				<input type="hidden" name="source" value="#url.source#">

				<cfquery name="Parameter" 
				datasource="AppsInit">
					SELECT *
					FROM   Parameter
					WHERE  Hostname = '#CGI.HTTP_HOST#' 
				</cfquery>		
				
				<cfif Parameter.PasswordReset eq "1">
							
					<tr>
						<td>					   
					  		<h2><cf_tl id="Forgot Password"></h2>
						</td>
					</tr>
					<tr>
						<td height="30"></td>
					</tr>
					<tr>
						<td class="labellarge" style="padding-left:10px;font-size:22px">
					  		<cf_tl id="Enter your #Parameter.SystemTitle# account and we will send you a temporary password">.
						</td>
					</tr>
					
					<tr><td height="5"></td></tr>
								
					<tr>
						<td class="labellarge" style="font-size:18px"><font color="808080">
						  <img src="images/finger.gif" alt="" border="0">
					  		<cf_tl id="eMail is sent to the registered e-Mail under your account.">
						</td>
					</tr>
				
				<cfelse>
				
					<tr>
						<td>					   
					  		<br><h2><cf_tl id="Password Recovery"></h2>
						</td>
					</tr>
					

					<tr>
						<td height="20"></td>
					</tr>
					<tr>
						<td class="labellarge">
					  		<p style="text-align: center;"><cf_tl id="Enter your <strong>#Parameter.SystemTitle#</strong> account to help us identify you" var="1">#trim(lt_text)#:<br><span style="font-size: 14px;padding-top: 8px;"><cf_tl id="(Information will be sent to the your registered e-Mail address)." var="1">#trim(lt_text)#</span></p>
						</td>
					</tr>
					
					<tr><td height="5"></td></tr>

				
				</cfif>
												
				<tr><td height="20"></td></tr>
				
				<tr>
					<td>				
					 	
                            <p style="font-size:18px;text-align: center;"><cf_tl id="Account">: <input name="account" 
						 id ="account"
					     class="regularxl" 
						 style="font-size:24px;height:40px;width:200px;" 
						 type="text" 
						 value="#logon#" 
						 size="15"  
						 maxlength="20" 
						 required="yes" 
						 message="Please enter your account">
                            </p><br>

					</td>
				</tr>
				
				<tr>
					<td style="text-align: center;" id="process"></td>
				</tr>
				
				<tr>
					<td id="action">
						<table align="center">
					
					 		<tr>
						 		<td>						 
									<cfif url.mode eq "regular">
									
										<cf_tl id="Return to Logon" var="1">
										<cfset tLogon= "#lt_text#">
										<input class="button" type="button" id="Cancel" value="#tLogon#" onClick="javascript:window.location='default.cfm'">
										      
									</cfif>				 
								 
						 		</td>
						 		<td id="send" style="padding-left:3px">
								<cf_tl id="Send instructions" var="vLabel2">
						  		<input class="button" type="button" value="#vLabel2#" onclick="process()">
					
						 		</td>
							</tr>
					 	</table>
					 <br><br><br>
					 </td>
				</tr>
				</cfoutput>	
				
			</table>
		</td>
	</tr>
</table>
</form>


