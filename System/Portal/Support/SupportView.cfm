
	<cfquery name="System" 
		datasource="AppsInit" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     Hostname
			FROM       Parameter
			ORDER BY Hostname
	</cfquery>
	
	
	<cfquery name="Module" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     SystemModule
			FROM       Ref_SystemModule
			ORDER BY SystemModule
	</cfquery>
	
	<cfparam name="url.msg" default="">
									
	<cfoutput>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" bgcolor="white" align="center">
		<tr>
			<td valign="top" style="padding-top:15px">
				<cf_tableround mode="solidborder" color="silver">
				<cfform action="../support/mail.cfm" method="post" enctype="multipart/form-data">
				<table cellpadding="0" cellspacing="0" border="0" width="96%" height="100%"  align="center">
					<tr>					
						<td valign="top" style="padding-top:20px">
							<table cellpadding="0" cellspacing="0" border="0" width="100%">                            
	                             <tr>
	                             	<td class="fnormal">
	                                 	Full Name: <font color="red" size="2">*</font>
	                                 </td>
	                                 <td class="finput">
	                                 	<cfinput 
											validate="noblanks" 
											validateAt="onBlur" 
											message = "You must enter your Full Name" 
											required="yes" 
											name="fname" 
											type="text" 
											id="fname" 
											class="fnormal"
											value="#SESSION.first# #SESSION.last#">
	                                 </td>
	                             </tr>
	                             
	                             <tr>
	                                 <td class="fnormal">
	                                 	IndexNo:
	
	                                 </td>
	                               	 <td class="finput">
	                                 	<cfinput 
											validate="noblanks" 
											validateAt="onBlur" 
											message = "You must enter your Indexno" 
											required="yes" 
											name="indexno" 
											type="text"  
											id="indexno" 
											value="#client.indexno#"
											class="fnormal">
	                                 </td>
	                             </tr>
								 
								 <tr>
	                                 <td class="fnormal">
	                                 	Account:
	
	                                 </td>
	                               	 <td class="finput">
										<cfoutput>
	                                 	<input 
											name="account"
											id="account" 
											type="text"  
											id="account" 
											value="#SESSION.acc#"
											class="fnormal">
										</cfoutput>
	                                 </td>
	                             </tr>
	                             
								 <tr>
	                                 <td class="fnormal">
	                                 	Telephone:
	
	                                 </td>
	                               	 <td class="finput">
	                                 	<input 
											name="telephone" 
											id="telephone"
											type="text"  
											id="telephone" 
											class="fnormal">
	                                 </td>
	                             </tr>
								 
	                             <tr>                                        
	                               	 <td class="fnormal">
	                               		Email: <font color="red" size="2">*</font>
	
	                               	 </td>
	                               
	                               	 <td class="finput">
	                                 	<cfinput 
											validateAt="onBlur" 
											validate="noblanks,email" 
											message = "You must enter a valid email address" 
											required="yes"  
											type = "Text" 
											name = "mailfrom" 
											id="mailfrom" 
											class="fnormal">
	                                 </td>
	                             </tr>
							</table>
						</td>
						<td valign="bottom">
							<table cellpadding="0" cellspacing="0" width="100%">
								<tr>
	                                 <td class="fnormal">
	                                 	Priority:
	
	                                 </td>
	                               	
	                                 <td class="finput">
	                                 	<select name="Priority"  id="Priority" style="width:200;margin:1px">
	                                       <option value="Low">
										   	Low
										   </option>
	                                       <option value="Medium">
										   	Medium	
										   </option>
										   <option value="High">
										   	High
										   </option>
	                                     </select>                      
	                                 </td>
	                             </tr>
								 
								<tr>
	                                 <td class="fnormal">
	                                 	Type of Support:
	
	                                 </td>
	                               	
	                                 <td class="finput">
	                                 	<select name="infoabout"  id="infoabout" style="width:200;margin:1px">
	                                       <option value="System Error">
										   	System Error
										   </option>
	                                       <option value="General Questions">
										   	General Questions	
										   </option>
										   <option value="Reporting Needs">
										   	Reporting Needs	
										   </option>
	                                     </select>                      
	                                 </td>
	                             </tr>				 
								 
								 <tr>
	                                 <td class="fnormal">
	                                 	System Name:
	                                 </td>
	                               	
	                                 <td class="finput">
									 
	                                 	<select name="system"  id="system" style="width:200;margin:1px">
											<cfloop query="System">
												<option value="#system.hostname#">
													#system.hostname#
												</option>
											</cfloop>
	                                     </select>                      
	                                 </td>
	                             </tr>
	                             
								  <tr>
	                                 <td class="fnormal">
	                                 	Module:
	                                 </td>
	                               	
	                                 <td class="finput">
									 
	                                 	<select name="module"  id="module" style="width:200;margin:1px">
											<cfloop query="Module">
												<option value="#module.systemmodule#">
													#module.systemmodule#
												</option>
											</cfloop>
	                                     </select>                      
	                                 </td>
	                             </tr>
								 <tr>
								 	<td class="fnormal">
										Attachment:
									</td>
								 	<td style="padding-top:2px; padding-left:1px">	
									<!---		
									<cf_filelibraryN
										DocumentPath="Support"
										SubDirectory="Attachment" 
										Filter=""
										LoadScript="Yes"
										Insert="yes"
										Remove="yes"
										Listing="yes">		
										--->
										<input style="border:1px solid silver; width:250px; height:22px" type="file" name="attachment" id="attachment" value="test">			                     
	                                 </td>
	                             </tr>
							</table>
						</td>					
					</tr>
					<tr>
						<td colspan="2" style="padding-left:20px; padding-right:20px">
							<table cellpadding="0" cellspacing="0" width="100%">
								<tr>
	                            	 <td align="left" style="padding-left:4px; font:normal verdana 12px; color:gray">
	                                 	Comments: <font color="red" size="2">*</font>
	                                 </td>
								</tr>
	                            <tr>
	                                 <td align="left" style="padding-left:4px">
	                                 	<textarea name="cbody" cols="25" rows="5" wrap="virtual"  id="cbody" style="width:100%; border:1px solid silver"></textarea>
	                                 </td>
	                             </tr>
	                             
	                             <tr>
	                                 <td align="left" style="padding-left:4px">		
									 	<input type="submit" value="Send" class="button10g">									
									 </td>
	                             </tr>                             
								
								<tr>
									<td>
										<cfif url.msg eq "yes">
										<font color="red" size="1">
											Your request was NOT sent, please fill in all required fields properly.
										</font>
										<cfelseif url.msg eq "no">
										<font color="green" size="1">
											Your request was sent.
										</font>
										</cfif>
									</td>
								</tr>
								 
							</table>
						</td>
					</tr>
				</table>
				</cfform>
				</cf_tableround>
			</td>
		</tr>
	</table>
	</cfoutput>