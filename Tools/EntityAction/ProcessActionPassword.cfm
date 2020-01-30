
<cfoutput>	

<form method="post" name="formpwdvalidate" id="formpwdvalidate">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="FFFFFF">
	
    <tr><td height="6"></td></tr>
	<tr>
	
	<td width="15"></td>
	<td valign="top"><img height="50" width="50" src="#SESSION.root#/images/password.png" alt="" border="0"></td>		
			
	<td>
	
		<table>
		
			<tr>
				<td class="labelit">Re-enter Password please:</td>	
			</tr>
			
			<tr><td height="4"></td></tr>
			
			<tr><td>
				<input type="password" 
				    style="width:220;height:40;font-size:25px" 
					onKeydown="if (window.event.keyCode == '13') {return false}"
					onKeyup="if (window.event.keyCode == '13') {ColdFusion.navigate('ProcessActionPasswordValidate.cfm?wfmode=#url.wfmode#','passwordvalidate','','','POST','formpwdvalidate');return false}"
					name="ProcessPassword" 		
					id="ProcessPassword"							
					class="regularxl">
			</td></tr>
						
			<tr><td height="4"></td></tr>
			
			<tr><td id="passwordvalidate"></td></tr>
			
		</table>
	
	</td>
	
	</tr>
				
	<tr><td height="4"></td></tr>
	
	<tr><td class="linedotted" colspan="3" height="1"></td></tr>
	
	<tr>
			<td height="40" colspan="3">
			
			<table cellspacing="0" cellpadding="0" align="center" class="formspacing">
			<tr><td>
			
			    <cf_tl id="Cancel" var="1">
			  
			    <input type = "button" 
			      name    = "cancel" 
				  id      = "cancel"
			      onclick = "ColdFusion.Window.hide('boxauth');document.getElementById('r0').click()" 
				  value   = "#lt_text#" 
				  class   = "button10g"
				  style   = "width:120;height:20">
				  
				</td>
				<td>  
				  
				<cf_tl id="Submit" var="1">	  
				  					  
				<input type = "button" 
				      name    = "saveaction"
					  id      = "saveaction" 
				      onclick = "ColdFusion.navigate('ProcessActionPasswordValidate.cfm?wfmode=#url.wfmode#','passwordvalidate','','','POST','formpwdvalidate')" 
					  value   = "#lt_text#" 
					  class   = "button10g"
					  style   = "width:120;height:20">
				  					
			</td></tr>
			
			</td>
	</tr>
	
	
</table>

</form>

</cfoutput>		

