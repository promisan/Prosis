<table width="92%" border="0"  class="formpadding" cellspacing="0" cellpadding="0" cellpadding="0" align="center">
						
	    <TR>
	    <td class="labelmedium" width="170">URL Reporting server:</td>
	    <TD>
	  	    <cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="ReportingServer" value="#ReportingServer#" required="No" size="50" maxlength="50">
			</cfoutput>
	    </TD>
		</TR>	
			
	    <TR>
	    <td class="labelmedium">Show report maximized:</td>
	    <TD class="labelmedium">
		
		    <INPUT class="radiol" type="radio" name="ReportingFullScreen" id="ReportingFullScreen" value="1" <cfif #Get.ReportingFullScreen# eq "1">checked</cfif>> Yes
			<INPUT class="radiol" type="radio" name="ReportingFullScreen" id="ReportingFullScreen" value="0" <cfif #Get.ReportingFullScreen# eq "0">checked</cfif>> No
	  	 
	    </TD>
		</TR>
		
	    <TR>
	    <td class="labelmedium">Default Mail template:</td>
	    <TD>
	  	    <cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="ReportMailTemplate" value="#ReportMailTemplate#" required="No" size="40" maxlength="30">
			</cfoutput>
	    </TD>
		</TR>
		
	    <TR>
	    <td class="labelmedium">Account Anonymous:</td>
	    <TD class="labelmedium">
		
		    <table cellspacing="0" cellpadding="0"><tr><td>
		
	  	    <cfoutput query="get">
			
				<img src="#SESSION.root#/Images/search.png" alt="Select User Account" name="img1" 
						  onMouseOver="document.img1.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img1.src='#SESSION.root#/Images/search.png'"
						  style="cursor: pointer;border-radius:2px" alt="" width="25" height="25" border="0" align="absmiddle" 
						  onClick="userlocateN('xxwebdialog','anonymoususerid','lastname','firstname','lookup')">
				
				</td>
				<td style="padding-left:1px">		  
				<cfinput class="regularxl" type="Text" name="anonymoususerid" value="#AnonymousUserId#" required="No" size="20" maxlength="20">
				<input type="hidden" name="lastname"   id="lastname">
				<input type="hidden" name="firstname"  id="firstname">
				<input type="hidden" name="lookup"     id="lookup" value="">
					
			</cfoutput>
			
			</td></tr></table>
			
	    </TD>
		</TR>
		
		<tr><td height="5" colspan="2"></td></tr>
		
		<tr><td height="1" colspan="2" class="linedotted"></td></tr>
		
		<tr><td colspan="2" align="center" height="30">
	
			<input type="submit" name="Update" id="Update" value=" Apply " class="button10g">	
	
		</td></tr>
			
</table>