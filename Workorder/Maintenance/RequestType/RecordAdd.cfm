<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Request Type" 
			  option="Add a request type" 
			  layout="webapp" 
			  user="No" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">
	
<table width="93%" align="center" class="formpadding formspacing">
	
	<tr><td height="6"></td></tr>
    <TR>
    <TD class="labelmediun2">Code:</TD>
    <TD>
  	   <cfinput type="Text" 
		      name="Code" 
		      value="" 
			  message="Please enter a code" 
			  required="Yes" 
			  size="20" 
			  maxlength="20" 
			  class="regularxxl">
    </TD>
	</TR>
	
	 <TR>
    <TD class="labelmedium2">Descriptive:</TD>
    <TD>
  	   <cfinput type="Text" 
		       name="Description" 
			   value="" 
			   message="Please enter a descriptive" 
			   required="Yes" 
			   size="40" 
			   maxlength="50" 
			   class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Type:</TD>
    <TD>
	
		<select name="TemplateApply" id="TemplateApply" class="regularxxl">
				    
			<option value="RequestApplyService.cfm">New Service or change in service provisioning</option>
			<option value="RequestApplyAmendment.cfm">Amended Service Consumption (Unit,User)/Porting</option>
			<option value="RequestApplyTermination.cfm">Termination of Service</option>
			<option value="">Other, such as equipment changes</option>
		
		</select>
		
	  </TD>
	</TR>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
		<td align="center" colspan="2" height="40">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
	    <input class="button10g" type="submit" name="Insert" id="Insert" value="Insert">
		</td>	
	
	</tr>
			
</table>

</CFFORM>

<cf_screenbottom layout="innerbox">
