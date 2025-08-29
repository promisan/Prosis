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
<cfparam name="Entry" default="Edit">

<cfoutput>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
				
			<tr>
			<td width="20%" class="labelit"><cf_interface cde="TrainingReason">
			<img src="#SESSION.root#/images/bullet.png" alt="#Name#:" border="0" align="absmiddle">&nbsp;
			#Name#:</td>
			<td width="80%" class="labelit">
			    <cfif #Entry# eq "Edit">				
			   	    <input type="text" value="#Training.TrainingReason#" name="TrainingReason_#task#" style="width:90%" size="80" maxlength="100" class="regularxl">
				<cfelse>				
				    #Training.TrainingReason#
				</cfif>	
			</td>			
			</tr>
					
			<!---
						
			<tr>
			<td>
			<cf_interface cde="Training">
			<img src="#SESSION.root#/images/bullet.png" alt="#Name#:" border="0" align="absmiddle">&nbsp;
			#Name#:</td>
			<td>
			    <cfif #Entry# eq "Edit">
			    <input type="text" value="#Training.TrainingDescription#" name="TrainingDescription_#task#" style="width:90%" size="80" maxlength="100">
				<cfelse>
				#Training.TrainingDescription#
				</cfif>
			</td>
			
			</tr>
									
			<tr>
			<td><cf_interface cde="TrainingTarget">
			<img src="#SESSION.root#/images/bullet.png" alt="#Name#:" border="0" align="absmiddle">&nbsp;
			#Name#:</td>
			<td>
			
			<cfif #Entry# eq "Edit">
			
				<cfif #Training.TrainingTarget# neq "">
					<cfset dte = "#Dateformat(Training.TrainingTarget, CLIENT.DateFormatShow)#">
				<cfelse>
				    <cfset dte = "#Dateformat(now(), CLIENT.DateFormatShow)#">
				</cfif>
							
				
				<cfif #Parameter.ShowCalendar# eq "1">
																						
						<cf_intelliCalendarDate8
							FieldName="TrainingTarget_#task#" 
							Default="#dte#"
							AllowBlank="Yes">	
														
				<cfelse>
							
						<cfinput type="Text"
						      name="TrainingTarget_#task#"
						      value="#dte#"
						      message="Please enter a valid date"
						      validate="eurodate"
					    	  required="No"
						      visible="Yes"
						      enabled="Yes"
						      style="text-align: center"
						      size="12"
						      class="regular">
								  
				</cfif>	  
				
			<cfelse>
			
				#Dateformat(Training.TrainingTarget, CLIENT.DateFormatShow)#
			
			</cfif>	
														
			</td></tr>
			
			<tr>
			<td><cf_interface cde="TrainingReference">
			<img src="#SESSION.root#/images/bullet.png" alt="#Name#:" border="0" align="absmiddle">&nbsp;
			#Name#:</td>
			<td>
			<cfif Entry eq "Edit">
			    <input type="text" value="#Training.TrainingReference#" name="TrainingReference_#task#" style="width:90%" size="80" maxlength="100">
			<cfelse>
			#Training.TrainingReference#
			</cfif>	
			</td>
			
			</tr>
			
			--->
			
	</table>
		
</cfoutput>		