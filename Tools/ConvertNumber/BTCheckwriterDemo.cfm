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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>BassTech's BTCheckwriter Demo page</title>
</head>

<!---------------------------------------------------------------------
  Custom Tag: <cf_BTCheckwriter>
  URL: http://www.basstechconsulting.com
  Release: 2/1/2001
    
  Author..: Peter A Bassey
  mailto..: dev@email
    
  What does it do?
    BTCheckwriter is a custom control that converts numbers to words. It's great for Check Printing
	programs or any system requiring numbers to be spelled out.  
    
  Disclaimer:
     
  Input Parameters 
    Required:
      	NumberVal 				[string]: 	This is the number to be converted to words
    Optional:
		Currency				[String]:	Select the currency for the generated amount
											The default is 'Dollars'
		          
  Modification List:
    3/18/2001: (1) Created;
	                    
  Additional Notes:
    BTCheckwriter is compatible with all versions of Cold Fusion
    If you have any problems,comments, or would like any improvements to be 
	made to this tag please email me at dev@email and let me know.
        
  Usage:
	<cf_BTCheckwriter
		NumberVal = "1222.21"
		Currency = "Dollars">
------------------------------------------------------------------------------->
<style type="text/css">
<!--
a {  font-family:Arial, Helvetica, sans-serif; font-size: 12pt; font-style: normal; color: #77F0B6; text-decoration: none}
a:active {  font-family:Arial, Helvetica, sans-serif; font-size: 12pt; font-style: normal; color: #FF0000; text-decoration: none}
a:link {  font-family:Arial, Helvetica, sans-serif; font-size: 12pt; font-style: normal; color: #77F0B6; text-decoration: none}
a:visited {  font-family:Arial, Helvetica, sans-serif; font-size: 12pt; font-style: normal; color: #77F0B6; text-decoration: none}
a:hover {  font-family:Arial, Helvetica, sans-serif; font-size: 12pt; font-style: normal; color: #FF0000; text-decoration: underline}
-->
</style>
<cfset NValue = "">

<cfif IsDefined("FORM.do_action")>
	<cfif IsDefined("FORM.TheNumber")>
		<cfset NValue = #FORM.TheNumber#>
	</cfif>
<cfelse>
	<cfset NValue = "">
</cfif>


<body  background="<cfoutput>#SESSION.root#</cfoutput>/Images/main_bkg.gif">
<center>
<form action="BTCheckwriterDemo.cfm" method="post">
	<input type="hidden" name = "do_action" id="do_action" value = "Continue">
	<table width="75%">
		<tr>
			<td align="center">
				<font face="Arial,Helvetica,sans-serif" size="5" color="666666">
					Welcome to BassTech's <b><i>BTCheckwriter</i></b><br>Custom Control Demo !<br><br>
				</font>
			</td>
		</tr>	
		<tr>
			<td align="center">
				<font face="Arial,Helvetica,sans-serif" size="2" color="666666">
					<b><i>BTCheckwriter</i></b> is a custom control that converts numbers to words. It's great for Check Printing
					programs or any system requiring numbers to be spelled out.  
				</font><br><br>
			</td>
		</tr>
		<tr>
			<td align="center">
				<table width="600" border="1">
					<tr>
						<td>
							<table width="600" background="checkbackground2.gif" >
								<tr>
									<td width="10">&nbsp;</td>
									<td width="500" valign="top">
										<font face="Arial,Helvetica,sans-serif" size="1" color="666666">
											<b>John Q. Public<br>
											Jane Q. Public<br>
											1 Main Street<br>
											Anywhere, USA</b>
										</font>
									</td>
									<td align="right" valign="top">
										<font face="Arial,Helvetica,sans-serif" size="2" color="666666">
											<b><div align="right">101&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></b><br>
										</font>
										<input type="text" name="TheDate" id="TheDate" size="10" readonly value="<cfoutput>#DateFormat(now(), CLIENT.DateSQL)#</cfoutput>">
										<font face="Arial,Helvetica,sans-serif" size="1" color="666666">
											<div align="right">Date&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
										</font>
									</td>
								</tr>
								<tr>
									<td width="10">&nbsp;</td>
									<td width="500">
										<font face="Arial,Helvetica,sans-serif" size="1" color="666666">
											Pay to the<br>
											Order of: &nbsp;____________________________________________________________ <b>$</b>
										</font>
									</td>
									<td align="right" valign="bottom">
										<input type="text" name="TheNumber" id="TheNumber" size="10" value="<cfoutput>#NValue#</cfoutput>">
									</td>
								</tr>
								<tr>
									<td width="10">&nbsp;</td>
									<td>
										<font face="Arial,Helvetica,sans-serif" size="2" color="666666">
											<cfif len(Trim(NValue)) neq 0>
												<cf_BTCheckWriter NumberValue="#NValue#">			
												<u><cfoutput>#Trim(NumberResult)#</cfoutput></u>				
											<cfelse>
												___________________________________________________________________ 
											</cfif>		
										</font>							
									</td>
									<td>
										<font face="Arial,Helvetica,sans-serif" size="2" color="666666">
											<b>Dollars</b>
										</font>
									</td>
								</tr>
								<tr><td colspan="3">&nbsp;<br><br></td></tr>
								<tr>
									<td width="10">&nbsp;</td>
									<td colspan="2">
										<font face="Arial,Helvetica,sans-serif" size="1" color="666666">
											FOR: ___________________________________
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											___________________________________
										</font>							
									</td>
								</tr>

								<tr>
									<td width="20">&nbsp;</td>
									<td colspan="2"><img src="routing_bankNbrs.gif" width="316" height="17" border="0" alt=""></td>
								</tr>
								
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
							
												
					<tr>
						<td align="center">
							<br><input type="submit" name="btnSubmit" id="btnSubmit" value="Submit"><br><br>
							<font face="Arial,Helvetica,sans-serif" size="2" color="666666">
								To download the <i>BTCheckwriter</i> control, click <a href="BTCWDemo.zip">here</a>.
								<br><br>
								To <b>purchase</b> the <i>BTCheckwriter</i> <b>control</b> online, click <a href="http://www.infopost.com/ItemDescription.asp?navtyp=SRH&ItemI=79260&c=3WIZ0X5ADDSRLOSS">here</a>.							
							</font>
							
						</td>
					</tr>
					<tr>
						<td align="center">
							<br><br>
							<font face="Arial,Helvetica,sans-serif" size="2" color="666666">
								<a href="../BTControls.cfm">Return to BassTech's BTControl center.</a>		
											
								<br><br><br>
							</font>
						</td>
					</tr>
					
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<hr>
				<font face="Arial,Helvetica,sans-serif" size="2" color="666666">
	<!---				This page has been accessed <CF_Counter Start="1"> times since 3/18/2001. --->
				</font>
			</td>
		</tr>		
		
	</table>
</form>
</center>

	
</body>
</html>
