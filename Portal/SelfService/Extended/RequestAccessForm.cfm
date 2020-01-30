
<cf_screentop height="100%" html="No">	 
	 
<cfparam name="Form.account" default="">
<cfparam name="form.fname" default="">
<cfparam name="form.telephone" default="">
<cfparam name="form.mailfrom" default="">
<cfparam name="form.infoabout" default="">
<cfparam name="form.indexno" default="">
<cfparam name="form.priority" default="normal">
<cfparam name="form.cbody" default="">


<cfquery name="Main" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    #CLIENT.LanPrefix#Ref_ModuleControl
	WHERE   SystemModule   = 'SelfService'
	AND     FunctionClass  = 'SelfService'
	AND     FunctionName   = '#url.id#'
	AND     (MenuClass     = 'Mission' or MenuClass = 'Main')
	ORDER BY MenuOrder
</cfquery>

<script>		
	function formSubmit() {
		document.getElementById("frm1").submit();
	}
</script>
			<cfoutput>
			<form style="width:100%; height:100%" id="frm1" name="frm1" action="RequestAccessForm.cfm?id=#url.id#" method="post">
			
			<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" bgcolor="white" align="center" 
            style="background-image:url('#SESSION.root#/Images/Logos/BGV3.jpg'); background-position:top right; background-repeat:no-repeat">            	
				<tr>
                    <td style="padding:5px" valign="middle" align="center">
					
											
                        <table cellpadding="0" cellspacing="0" border="0" width="96%" height="100%"  align="center">
                            <tr>
                                <td style="font: normal bold 16px verdana; color: gray;" height="65" valign="middle">
                                    <img src="#SESSION.root#/Images/access.png" width="35px" height="35px" border="0" alt="" align="absmiddle">
                                    <cf_tl id="Request Access or Correction"> 	 							
                                    <hr>
                                </td>
                            </tr>
                            <tr>
                                <td height="20" valign="top" class="labelit">
									<cf_tl id="Please fill and submit the following form. You will be contacted as soon as possible"  class="Message">.
                                </td>
                            </tr>
                            <tr>                      
                                
                                <td valign="top" style="padding-top:20px">
									
                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">                            
                                         <tr>
                                            <td width="30%" align="right" class="labelit">
                                                <cf_tl id="Full Name">:<font color="red">*</font>
                                             </td>
                                             <td width="70%" align="left" style="padding-left:4px">
                                                <input name="fname" type="text" id="fname" style="margin:1px; padding:1px; height:18px" value="#form.fname#">
                                             </td>
                                         </tr>
                                         
                                         <tr>
                                             <td align="right" class="labelit">
                                                <cf_tl id="IndexNo">:
                                             </td>
                                             <td align="left" style="padding-left:4px">
                                                <input name="indexno" type="text"  id="indexno" style="margin:1px; padding:1px; height:18px" value="#form.indexno#">
                                             </td>
                                         </tr>
                                         <cfif url.id neq "muc">
                                         <tr>
                                             <td align="right" class="labelit">
                                                <cf_tl id="Account">:
                                             </td>
                                             <td align="left" style="padding-left:4px">
                                                <input name="account" type="text"  id="account" style="margin:1px; padding:1px; height:18px" value="#form.account#">
                                             </td>
                                         </tr>
                                         </cfif>
                                         
                                         <tr>
                                             <td align="right" class="labelit">
                                                <cf_tl id="Telephone">:<font color="red">*</font>
                                             </td>
                                             <td align="left" style="padding-left:4px">
                                                <input name="telephone" type="text"  id="telephone" style="margin:1px; padding:1px; height:18px" value="#form.telephone#">
                                             </td>
                                         </tr>
                                         
                                         <tr>                                        
                                             <td align="right" class="labelit">
                                                <cf_tl id="Email">:<font color="red">*</font>
                                             </td>
                                           
                                             <td align="left" style="padding-left:4px">
                                                <input type = "Text" name = "mailfrom" id="mailfrom" style="margin:1px; padding:1px; height:18px" value="#form.mailfrom#">
                                             </td>
                                         </tr>
                                         
                                        
                                         <tr>
                                             <td align="right" class="labelit">
                                                <cf_tl id="Subject">:
                                             </td>
                                            
                                             <td align="left" style="padding-left:4px">
											 	<table cellpadding="0" cellspacing="0">
													<tr>
														<td class="labelit">
															<select name="infoabout"  id="infoabout" style="width:140;margin:1px" >
																<cf_tl id="Access to the system" var="1">
																<option value="#lt_text#" <cfif #Form.infoabout# eq "#lt_text#">selected="selected"</cfif>>
																	#lt_text#
																</option>
																<cf_tl id="Forgot LDAP Password" var="1">
																<option value="#lt_text#" <cfif #Form.infoabout# eq "#lt_text#">selected="selected"</cfif>>
																	#lt_text#
																</option>
																<cf_tl id="General questions" var="1">
																<option value="#lt_text#" <cfif #Form.infoabout# eq "#lt_text#">selected="selected"</cfif>>
																	Other
																</option>
															</select>     
												 		</td>
														<td class="labelit">&nbsp;Priority</td>
														<td>
															<select name="priority"  id="priority" style="width:65;margin:1px" >
																<cf_tl id="Normal" var="1">
																<option value="#lt_text#" <cfif #Form.priority# eq "#lt_text#">selected="selected"</cfif>>
																	#lt_text#
																</option>
																<cf_tl id="Low" var="1">
																<option value="#lt_text#" <cfif #Form.priority# eq "#lt_text#">selected="selected"</cfif>>
																	#lt_text#
																</option>
																<cf_tl id="High" var="1">
																<option value="#lt_text#" <cfif #Form.priority# eq "#lt_text#">selected="selected"</cfif>>
																	#lt_text#
																</option>
			                                                 </select>  
														</td>
													</tr>
												</table>              
                                             </td>
                                         </tr>
                                         
                                         <tr>
                                             <td align="right" class="labelit">
                                                <cf_tl id="Comments">:
                                             </td>
                                            
                                             <td align="left" style="padding-left:4px">
                                                <textarea name="cbody" cols="25" rows="3" wrap="virtual"  id="cbody" style="margin:1px; width:250px; border:1px solid silver">#form.cbody#</textarea>
                                             </td>
                                         </tr>
                                         
                                         <tr>
                                             <td>
                                             </td>
                                           
                                             <td align="left" style="padding-left:4px">		
											 	<cf_tl id="Submit" var="1">		 
                                                <input type="button" value="#lt_text#" class="button10g" style="margin:1px" onclick="formSubmit()">
                                                <!---    
                                                <input type="button" onClick="document.getElementById('requestaccess').style.display = 'none'; document.getElementById('modalbg').style.display = 'none'" name="Close" value="Close" class="button10g" style="margin:1px">
												--->                                                
                                                
                                             </td>
                                         </tr>                             
                                         <tr>
                                            <td></td>
                                            <td align="left" style="padding-left:4px; padding-top:3px">
                                            <input type = "hidden" name = "oncethrough" id="oncethrough" value = "Yes">
                                            <cfdiv id="dcomments"/>
                                            <cfdiv id="dhidden" class="noprint"/>                                        
                                             </td>
                                         </tr>
                                    </table>
									
                                </td>
                                
                            </tr>
                        </table>
						
                    </td>
                </tr>
				<cfif IsDefined("Form.oncethrough") and Form.fname neq "" and Form.telephone neq "" and find ("@","#Form.mailfrom#")>
				
					<cfif main.FunctionContact neq "">
						<cfset mailto = replace(main.FunctionContact,";",",","ALL")>
					<cfelse>
						<cfset mailto = "jbatres@promisan.com">
					</cfif>
				<tr>
                	<td align="center">
                    	<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/status_complete.gif" border="0">
                        <br>
						
                        <font color="green"><cf_tl id="Your request has been successfully sent." class="message"><br> <cf_tl id="This window will close in 5 seconds" class="message"></font>
                        <script>setTimeout("parent.document.getElementById('requestaccess').style.display = 'none'; parent.document.getElementById('modalbg').style.display = 'none'",6000);</script>
                    </td>
                </tr>
                <tr><td height="5px"></td></tr>

				        <cfmail to = "#mailto#" 
						        from = "#Form.mailFrom#" 
								subject = "#Form.infoabout#" 
								priority = "#Form.priority#" 
								type="html">

									<cf_MailRound HeightSize="small">
									<table cellpadding="6px" cellspacing="0" width="100%" style="border:1px dotted silver; padding:6px" align="center">
										<tr>
											<td align="center">
												<font face="calibri" size="4" color="##003059">
													This is an automatic mail from the <font color="##1562b1" size="5">#Main.FunctionName# Portal</font> (#Main.FunctionMemo#)</font>
												<hr>
											</td>
										</tr>
										<tr>
											<td>
												<font color="##242424" size="3" face="calibri">
													#Form.fname# with IndexNo. #Form.indexno#<cfif Form.account neq "">, System account "#Form.account#"</cfif> <cfif Form.telephone neq "">and Telephone number #Form.telephone#,</cfif> wrote the following in regard to "#Form.infoabout#":
													<br><br>
													#Form.cbody#
												</font>
											</td>
										</tr>
										<tr>
											<td style="border-top:1px dotted silver" bgcolor="##f3f3f3">
												<font color="gray" size="2" face="calibri">
													#Form.fname#'s email is #Form.mailFrom#, (you can also just reply to this mail).
												</font>
											</td>
										</tr>
									</table>
									</cf_MailRound>

				        </cfmail>   

				<cfelse>
					<cfif IsDefined("Form.oncethrough")>
						<tr>
							<td align="middle">
								<font color="red" size="1">						
									<cfif Form.fname eq "">
									<cf_tl id="Please enter your full name" class="message"><br>
									</cfif>
									<cfif Form.telephone eq "">
									<cf_tl id="Please enter your Telephone" class="message"><br>
									</cfif>
									<cfif find ("@","#Form.mailfrom#")>
									<cfelse>
									<cf_tl id="Please enter a valid email address" class="message"><br>
									</cfif>
								</font>
							</td>
						</tr>
					</cfif>
				</cfif>
				
            </table>
			</form>
			</cfoutput>