<cfparam name="url.ajax" default="yes">
<cfoutput>

	<table width="94%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
	
			<tr><td colspan="2" class="labelmedium">Performance Evaluation Settings</b></td></tr>	
			<tr><td colspan="2" class="linedotted"></td></tr>
	
	        <tr><td height="2"></td></tr>
		    
			<TR>
	    		<TD class="labelmedium" width="40%" style="padding-left:10px;cursor:pointer"><cf_UIToolTip  tooltip="Time in days after the inception of the workflow when this action should be completed">Lead-time:</cf_UIToolTip></b></TD>
	    		<TD class="labelmedium">
					<cfinput type="text" 
					   name="ActionLeadtime" 
					   value="#Get.ActionLeadtime#" 
					   size="4" 
					   tooltip="Time in days after the inception of the workflow when this action should be completed"
					   maxlength="4" 
					   class="regularxl" 
					   style="text-align: center;" 
					   message="Please enter an leadtime in days" validate="integer"> days
				</TD>
			</TR>
			
			<TR>
	    		<TD class="labelmedium" width="40%" style="cursor:pointer;padding-left:10px;"><cf_UIToolTip tooltip="The time within this action would need to be completed after the completion of a prior action. <br>The action will be shown highlighted in my clearances once time exceeds the target. Enter 0 to disable">Action response:</cf_UIToolTip></b></TD>
	    		<TD class="labelmedium">
					<cfinput type="text" 
					   name="ActionTakeAction" 
					   value="#Get.ActionTakeAction#" 
					   size="4" 
					   tooltip="The time within this action would need to be completed after the completion of a prior action. <br>The action will be shown highlighted in my clearances once time exceeds the target. Enter 0 to disable"
					   required="Yes"
					   maxlength="4" 
					   class="regularxl" 
					   style="text-align: center;" 
					   message="Please enter a response time in hours" validate="integer"> hours
				</TD>
			</TR>
			
			<TR>
			 
	    		<TD width="25%" class="labelmedium" style="height:25;cursor:pointer;padding-left:10px;">
				<cf_UIToolTip tooltip="Show the completed action in a different color">
				Color of the completed step (Box):
				</cf_UIToolTip>
				</TD>
	    		
				<TD class="labelmedium">
				
				<cfif Get.ActionCompletedColor eq "Default">
				   <cfset cl = "No">
				<cfelse>
				   <cfset cl = "Yes" >   
				</cfif>
				
				<table cellspacing="0" cellpadding="0" class="formpadding">
				<TR>
					
				<td>										
					<input type="checkbox" 
				       name="ActionCompletedColorDefault" 
					   id="ActionCompletedColorDefault"		
					   onclick="tcl(this.checked)" class="radiol"	   
					   value="1" <cfif Get.ActionCompletedColor eq "Default">checked</cfif>>
				</td>	   
				<td class="labelmedium" style="padding-left:4px;padding-right:4px">Default</td>	  				
				<td>				
								
					<cf_input 	name="ActionCompletedColor" 																
							  	type="colorPicker" 
							  	palette="basic" 
								enabled="#cl#"
								ajax="true"
							  	value="#Get.ActionCompletedColor#">
								
				</td>	 
				</TR>
				</table>				
											   
				</TD>
			</TR>
					
		</table>
		
</cfoutput>		

<cfif url.ajax eq "yes">
	<cfset AjaxOnLoad("ProsisUI.doColor")>
<cfelse>
	<script>
		ProsisUI.doColor();
	</script>
</cfif>	 