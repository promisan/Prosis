<cfoutput>
  
  <form action="javascript:send_smtp_go()" name="smtp_window" style="padding-top:10px">
  
  <table class="formpadding" align="center" valign="top" width="100%" height="100%"  style="background: url('../Notification/SMTP/Mail.png') no-repeat; background-position: 25px 40px;">
  	<tr height="19"><td></td><td colspan="1"></td></tr>
	<tr height="30">
		<td width="220"></td>
		<td>
		<cfoutput>
				<cf_textarea name="smtp_text" 
                	width="80%" height="150" 
                	init="no" 
                	color="ffffff" 
                	toolbar="basic" 
                	onchange="updateTextArea();">
                		#SESSION.SMTP#
                	</cf_textarea>
		</cfoutput>
		</td>
	</tr> 
	
	<tr><td height="10"></td></tr> 
	
	<tr>
	    <td colspan="2" align="center">
		<table><tr>		
		<td><input class="button10g" type="Submit" value="Send"></td>				
		<td style="padding-left:1px"><input class="button10g" type="button" value="Close" onClick="ColdFusion.Window.hide('bb_tts');"></td>
		</tr></table>
		</td>
	</tr>
	  
	</table> 
	
  </form>
  
  <cfset AjaxOnLoad("initTextArea")>
</cfoutput>


