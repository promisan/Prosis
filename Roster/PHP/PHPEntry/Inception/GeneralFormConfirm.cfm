
<!--- confirmation form --->

<cfoutput>



<table width="90%" align="center" class="formpadding formspacing">

	<tr><td height="4"></td></tr>
	
	<tr><td colspan="2" class="labellarge"><cf_tl id="Please verify the below submitted information before you send it"></td></tr>
	
	<tr><td height="4"></td></tr>
	
	
	<tr><td height="4"></td></tr>
	
	<tr id="personfield" name="personfield">		
	    <TD class="labelmedium" align="left"><cf_tl id="LastName">:</TD>
	    <TD class="labelmedium" style="font-size:22px" align="left" width="80%">#Form.LastName#</td>
	</tr>
	
	<tr><td height="4"></td></tr>
	
	<tr id="personfield" name="personfield">		
	    <TD class="labelmedium" align="left"><cf_tl id="FirstName">:</TD>
	    <TD class="labelmedium" style="font-size:22px" align="left" width="80%">#Form.FirstName#</td>
	</tr>
	
	<tr><td height="4"></td></tr>
	
	<tr id="personfield" name="personfield">		
	    <TD class="labelmedium" align="left"><cf_tl id="DOB">:</TD>
	    <TD class="labelmedium" style="font-size:22px" align="left" width="80%">#DateFormat(Form.DOB, CLIENT.DateFormatShow)#</td>
	</tr>
	
	<tr><td height="4"></td></tr>
	
	<tr id="personfield" name="personfield">		
	    <TD class="labelmedium" align="left"><cf_tl id="Nationality">:</TD>
	    <TD class="labelmedium" style="font-size:22px" align="left" width="80%">#Form.Nationality#</td>
	</tr>
	
	<tr><td height="4"></td></tr>
	
	<tr id="personfield" name="personfield">		
	    <TD class="labelmedium" align="left">#client.IndexNoName#:<cf_space spaces="46"></TD>
	    <TD class="labelmedium" style="font-size:22px" align="left" width="80%">#Form.IndexNo#</td>
	</tr>
	
	<tr><td height="4"></td></tr>
	
	<tr id="personfield" name="personfield">		
	    <TD class="labelmedium" align="left"><cf_tl id="eMail">:</TD>
	    <TD class="labelmedium" style="font-size:22px" align="left" width="80%">#Form.eMailAddress#</td>
	</tr>
	
	<tr><td height="4"></td></tr>
	
	<tr id="personfield" name="personfield">		
	    <TD class="labelmedium" align="left"><cf_tl id="MobileNumber">:</TD>
	    <TD class="labelmedium" style="font-size:22px" align="left" width="80%">#Form.MobileNumber#</td>
	</tr>
	
	<tr><td height="4"></td></tr>
	<tr><td height="4"></td></tr>
	
	<cfset session.myForm = structCopy(form)>
			
	<tr><td colspan="2" align="center">
	
		<table align="center" class="formpadding formspacing">
		<tr>
			<td>
			
			 <cf_tl id="Amend" var="1">
	
			  <input style  = "width:200;height:28" 
					 type    = "button" 
					 class   = "button10g"
					 onclick = "ptoken.location('#session.root#/Roster/PHP/PHPEntry/Inception/General.cfm?public=#url.public#&entrymode=#url.entrymode#&scope=#url.scope#&applicant=#url.applicantno#&Public=1&Action=#form.mode#&Class=#url.applicantclass#&Owner=#url.owner#&mission=#url.mission#')"
					 name    = "Back"
					 id      = "submitme"
					 value   = "#lt_text#">
			
			
			</td>
			<td>
			
			<cfsavecontent variable="submitscript">					   		    
		   		ptoken.navigate('#session.root#/Roster/PHP/PHPEntry/Inception/GeneralSubmit.cfm?public=#url.public#&&entrymode=#url.entrymode#&scope=#url.scope#&embed=1&action=edit&mission=#url.mission#&owner=#url.owner#&applicantclass=#url.applicantclass#&applicantno=','detailcontent')			          		   				   
			</cfsavecontent>
						
			 <cf_tl id="Send" var="1">
			 			
			 <input style  = "width:200;height:28" 
					 type    = "button" 
					 class   = "button10g"
					 onclick = "javascript:#submitscript#"
					 name    = "Submit"					 
					 value   = "#lt_text#">
						
			</td>
		</tr>
		</table>
		
	</td></tr>

</table>

</cfoutput>
