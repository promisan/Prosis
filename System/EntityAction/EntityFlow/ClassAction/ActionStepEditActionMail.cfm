

<cfoutput>


		<table width="94%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
		
			 <tr><td height="16"></td></tr>
			 
			   <cfif Mail.Recordcount gte "0">
				
				<tr><td class="labellarge">EMail to other parties other than step actors</b></font></td></tr>	
				<tr><td colspan="2" class="linedotted"></td></tr>
				<tr><td height="5"></td></tr>
				<tr>
				   <td width="50%" class="labelmedium" style="padding-left:10px">Send a custom EMail once this action becomes <b>DUE</b>:</td>
				   <TD>
						<table border="0" cellspacing="0" cellpadding="0">
						<tr><td width="30" style="height:25px">
						<INPUT type="checkbox" class="Radiol" name="PersonMail" id="PersonMail" value="1" onClick="notify(this.checked)" <cfif Get.PersonMailCode neq "">checked</cfif>>
						</td>
						<td style="padding-left:10px">
											
						<cfif Get.PersonMailCode neq "">
						   <cfset c = "regularxl">
						<cfelse>
						   <cfset c = "hide">
						</cfif>
						
						<select class="#c# regularxl" name="PersonMailCode" id="PersonMailCode" onChange="mail(this.value,'duerecipient')">
						    <option value="">--select--</option>
						    <cfloop query="Mail">
						    	<option value="#DocumentCode#"
								 <cfif DocumentCode eq Get.PersonMailCode>selected</cfif>>
								 #DocumentDescription#</option>
							</cfloop>
						</select>
						</td>
					
						</tr>
						</table>
				   </td>
				</tr>
				
				
				<tr><td colspan="2" align="center"><cfdiv id="duerecipient"/></td></tr>
				
				<tr>
				   <td class="labelmedium" style="padding-left:10px">Send a custom EMail once this action is <b>Processed</b>:</td>
				   <TD>
												
						<table cellspacing="0" cellpadding="0">
						
						<tr>
						
							<td width="30" style="height:25px">
							   <INPUT type="checkbox" class="Radiol" name="PersonMail2" id="PersonMail2" value="1" onClick="notify2(this.checked)" <cfif Get.PersonMailAction neq "">checked</cfif>>
							</td>
							
							<cfif Get.PersonMailAction neq "">
							   <cfset c1 = "regularxl">
							<cfelse>
							   <cfset c1 = "hide">
							</cfif>
							
							<td class="#c1#" id="actionmail1" style="padding-left:10px">										
							
								<select name="PersonMailAction" id="PersonMailAction" class="regularxl" onChange="mail(this.value,'processrecipient')">
									<option value="">--select--</option>
								  	<cfloop query="Mail">
									    <option value="#DocumentCode#"
										 <cfif #DocumentCode# eq #Get.PersonMailAction#>selected</cfif>>
										 #DocumentDescription#</option>
									</cfloop>
								</select>
								
							</td>
							
						</tr>							
						
						</table>
						
				   </td>
				</tr>
				
				<tr><td colspan="2" align="center">
				
				<cfdiv bind="javascript:mail({PersonMailAction},'processrecipient')" id="processrecipient" bindonload="no">

				</td></tr>
				
				<tr class="#c1#" id="actionmail2">
					<td align="left" style="padding-left:4px" class="labelmedium">
					<img src="<cfoutput>#SESSION.root#</cfoutput>/images/join.gif" align="absmiddle"	alt="" border="0">
					&nbsp;&nbsp;Attach the "for this step" generated Documents:</td>								
					<td>
						<INPUT type="checkbox" class="Radiol" name="PersonMailActionAttach" id="PersonMailActionAttach" value="1" <cfif Get.PersonMailActionAttach eq "1">checked</cfif>>
					</td>
				</tr>	
				
				<cfif entity.DocumentPathName neq "">
				
				<tr class="#c1#" id="actionmail3">
					<td align="left" style="padding-left:4px" class="labelmedium">
					<img src="<cfoutput>#SESSION.root#</cfoutput>/images/join.gif" align="absmiddle"	alt="" border="0">
					&nbsp;&nbsp;Attach the "for this object" included attachments:</td>								
					<td>
						<INPUT type="checkbox" class="Radiol" name="PersonMailObjectAttach" id="PersonMailObjectAttach" value="1" <cfif Get.PersonMailObjectAttach eq "1">checked</cfif>>
					</td>
				</tr>		
				
				</cfif>	
				
											
			</cfif>
			
			<tr><td height="10"></td></tr>
			
			</table>			

									
			<cfinclude template="ActionStepEditActionMisc.cfm">
									
			<table width="96%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
			
			<tr><td height="4"></td></tr>
			<tr><td height="1" class="linedotted" colspan="2"></td></tr>
			
			<tr><td align="center" colspan="2" height="35">
			
					<cfif URL.PublishNo eq "">
					<input class="button10g"  style="width:130;height:25" type="button" name="Delete" id="Delete" value="Remove" onClick="removeaction()">
					</cfif>
				
					<input class="button10g"  style="width:130;height:25" type="button" name="Update" id="Update" value="Apply" onClick="savequick()">
					<cfparam name="url.action" default="flow">
				
			</td></tr>	
			
			</table>
			
		
</cfoutput>		


	