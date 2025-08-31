<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="url.ajax" default="yes">
<cfoutput>

	<table width="94%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
	
			<tr><td colspan="2" class="labelmedium">Performance Evaluation Settings</b></td></tr>	
			<tr><td colspan="2" class="linedotted"></td></tr>
	
	        <tr><td height="2"></td></tr>
		    
			<TR>
	    		<TD class="labelmedium" width="40%" style="padding-left:10px;cursor:pointer" title="Time in days after the inception of the workflow when this action should be completed">Lead-time:</TD>
	    		<TD class="labelmedium">
					<cfinput type="text" 
					   name="ActionLeadtime" 
					   value="#Get.ActionLeadtime#" 
					   size="4" 					   
					   maxlength="4" 
					   class="regularxl" 
					   style="text-align: center;" 
					   message="Please enter an leadtime in days" validate="integer"> days
				</TD>
			</TR>
			
			<TR>
	    		<TD class="labelmedium" width="40%" style="cursor:pointer;padding-left:10px;" title="The time within this action would need to be completed after the completion of a prior action. <br>The action will be shown highlighted in my clearances once time exceeds the target. Enter 0 to disable">Action response:</TD>
	    		<TD class="labelmedium">
					<cfinput type="text" 
					   name="ActionTakeAction" 
					   value="#Get.ActionTakeAction#" 
					   size="4" 
					   required="Yes"
					   maxlength="4" 
					   class="regularxl" 
					   style="text-align: center;" 
					   message="Please enter a response time in hours" validate="integer"> hours
				</TD>
			</TR>
			
			<TR>
			 
	    		<TD width="25%" class="labelmedium" style="height:25;cursor:pointer;padding-left:10px;" title="Show the completed action in a different color">
				Color of the completed step (Box):				
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