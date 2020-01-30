
<cfoutput>

<table width="100%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
		  
	   <tr>
	    <td class="labelmedium" height="25" style="padding-left:4px"><cf_tl id="Process Email notification">:</td>
		<td>
		
		<table cellspacing="0" cellpadding="0">
		<tr>
	   
		<td>  
			<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">	
				<tr>
					<td class="labelmedium">
				    	<input type="radio" name="MailConfirmation" class="radiol" value="NONE" onclick="toggle(this.value)" 
					 	<cfif MailConfirmation neq "BATCH" and MailConfirmation neq "INDIVIDUAL">checked</cfif>>
					</td><td style="padding-left:5px" class="labelmedium">None</td>
				 	</td>
					<td class="labelmedium" style="padding-left:5px">
						 <input type="radio" name="MailConfirmation" class="radiol" value="INDIVIDUAL"  onclick="toggle(this.value)"
						 <cfif MailConfirmation eq "INDIVIDUAL">checked</cfif>></td>
					<td class="labelmedium" style="padding-left:5px"> <cf_UIToolTip tooltip="Immediately sent upon processing the status.">Individual</cf_UIToolTip></td>
				 	<td class="labelmedium" style="padding-left:5px">
					 	<input type="radio" name="MailConfirmation" class="radiol" value="BATCH" onclick="toggle(this.value)" 
					 	<cfif MailConfirmation eq "BATCH">checked</cfif>></td>
					<td style="padding-left:5px" class="labelmedium"><cf_UIToolTip tooltip="Sent as part of the daily batch. Define delay in days.">Batch</cf_UIToolTip></td>
				 
					 <cfif MailConfirmation eq "BATCH">
					   <cfset cl = "labelmedium">
					 <cfelse>
					   <cfset cl = "hide"> 
					 </cfif>  
					 
					 <td class="#cl#" id="delay1" style="padding-left:10px;padding-top:2px"><cf_tl id="delay"> (d):</td>
					 <td class="#cl#" id="delay2" style="padding-left:5px;padding-right:4px">
					 
					  <cfinput type="Text"
					       name="mailbatchdelay"
					       validate="integer"
					       required="Yes"
					       visible="Yes"
						   class="regularxl"
						   style="text-align:center"
						   value="#MailBatchDelay#"
					       enabled="Yes"					      
					       size="1"
					       maxlength="1">
						  
					 </td>
					 <td class="labelmedium" style="padding-left:8px;padding-top:2px"><cf_tl id="Effective">:</td>	 
					 <td>
					 	<cf_calendarscript>
						<cf_intelliCalendarDate9
								FieldName="MailDateStart" 
								class="regularxl" 
								Default="#dateformat(MailDateStart,CLIENT.DateFormatShow)#"
								AllowBlank="True">
				 	 </td>  	   
				 </tr>
			 </table>
		</td>	
       	  		  
	   </tr>
	   </table>
	   </td>
	   </tr>
	   
	   <tr id="mailSubLabel">
	   
	    <td class="labelmedium" style="padding-left:5px"><cf_tl id="Mail Subject">:</td>
		<td>
		
			<table>
			<tr class="labelmedium">
				<td id="mail_a">
				<cfif MailConfirmation eq "NONE">
				<input type="text" name="MailSubject" value="#MailSubject#" size="50" maxlength="50" class="regularxl">
				<cfelse>
				<input type="text" name="MailSubject" value="#MailSubject#" size="50" maxlength="50" class="regularxl">
				</cfif>
				</td>		
				<td style="cursor:pointer;padding-left:30px" id="mailBodyVariables" class="labelmedium">
					<cf_UIToolTip sourcefortooltip="ParameterEditStepMailFields.cfm"><font color="0080C0"><u>Supported Mail Body Variables</cf_UIToolTip>
				</td>
			</tr>
			</table>
		
		</td>
				
	   </tr>	
	  	   	   	   	   
	   <tr>
	    		
		   <td colspan="2" align="center" height="100%">
		   
			   <table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center">
			     	
				   <tr id="mail_b"><td valign="top" style="padding:7px">
				   				   	 
					   <cf_textarea name="emailtext"					    
						 skin="flat"
						 init="yes"
						 resize="false"
						 color="ffffff"
						 height="420">#MailText#</cf_textarea>	  
					
					</td></tr>
				
				</table>					
										
		   </td>
			
	   </tr> 	    
	   
</table>	   

</cfoutput>
