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
<cf_tl id="After Completion" var="1">
<cfset AfterCompletion="#lt_text#">

<cf_tl id="After Start" var="1">
<cfset AfterStart="#lt_text#">
					
<cfoutput>

<!--- show only activities which are not parented directly or indirectly by the current activity --->
					   
		   <table width="100%" border="0" cellpadding="0">
		   
		    <tr class="line">
			   <td width="1%"></td>
			   <td width="40%" class="labelit"><cf_tl id="Activity"></td>
			   <td width="15%" class="labelit"><cf_tl id="Location"></td>
			   <td width="15%" class="labelit"><cf_tl id="Start"></td>
			   <td width="15%" class="labelit"><cf_tl id="Estimated End"></td>
			   <td align="right" width="10%" class="labelit"><cf_tl id="Duration"></td>
		   </tr>
		  
		   <cfloop query="ActionParent">
		   
			   <!--- Query returning search results for activities  --->
				<cfquery name="Check" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  *
					FROM    ProgramActivityParent
					WHERE   ActivityId = '#URL.ActivityId#'
					AND     ActivityParent = '#ActivityId#'
				</cfquery>
			
				<cfset dts = DateFormat(ActivityDate+1,CLIENT.DateFormatShow)>
				
				<tr class="labelit linedotted">		
				<cfif Check.recordcount eq "0">
				
				  <td style="padding-left:3px;padding-right:3px">
				 
					 <cfif ProgramAccess eq "ALL" and completed eq "0">
						 <input type="checkbox" class="radiol" style="height:14px;width:14px" id="parent" name="parent" value="#ActivityId#" onClick="seldep(this,this.checked,'#dts#','#activityid#')">
					 </cfif>
				 
				  </td>
				 
			    <cfelse>
												 
				 <td width="30" style="padding-left:7px">
				 <cfif ProgramAccess eq "ALL" and completed eq "0">
					 <input type="checkbox" class="radiol" style="height:14px;width:14px" id="parent" name="parent" value="#ActivityId#" checked onClick="seldep(this,this.checked,'#dts#','#activityid#')">
				 </cfif>
				 </td>
				 
			    </cfif>
			
				  <td style="padding-left:4px">#ActivityDescriptionShort#</td>
				  <td>#LocationCode#</td>
				  <td>#DateFormat(ActivityDateStart,CLIENT.DateFormatShow)#</td>
				  <td>#DateFormat(ActivityDate,CLIENT.DateFormatShow)#</td>
				  <td align="right" style="padding-right:10px">#ActivityDays#</td>
		    
			 </tr>	
			 
			 <cfif Check.recordcount eq "0">
				 <cfset cl="hide">
			 <cfelse>
		 	     <cfset cl="regular">
			 </cfif>
			 
			 <tr class="#cl#" id="pre#activityid#" class="linedotted">
			 
			     <td></td>
			     <td colspan="4">
				 
				 <table cellspacing="0" cellpadding="0" class="formspacing">
				 
					 <tr><td class="labelit" style="padding-left:4px"><cf_tl id="Start after">:</td>
															 
					 <cfif ProgramAccess eq "ALL">
					 
						  <td style="padding-left:4px"><input type="radio" class="radiol" onclick="setstartdate('#activityid#')" name="StartAfter#ActivityId#" value="completion" <cfif check.StartAfter neq "start">checked</cfif>></td><td class="labelit" style="padding-left:4px">#afterCompletion#</td>
						  <td style="padding-left:4px"><input type="radio" class="radiol" onclick="setstartdate('#activityid#')" name="StartAfter#ActivityId#" value="start" <cfif check.StartAfter eq "start">checked</cfif>></td><td class="labelit" style="padding-left:4px">#AfterStart#</td>					
						  
					 <cfelse>
					 
					   <cfif check.StartAfter eq "start">
					   
						   <td style="padding-left:4px">
						   <cf_tl id="Start">					     
						   <cfelse>					   
						    <cf_tl id="Completion">
					   
					   </cfif>					   
					   
					   </td>
					 
					 </cfif>
										 
					 <td class="labelit" style="padding-left:4px"> <cf_tl id="Delay">:</td>
					 
					 <td colspan="3" style="padding-left:4px" class="labelit">
					 
					  <cfif check.StartAfterDays eq "">
					   <cfset d = 1>
					 <cfelse>
					   <cfset d = check.StartAfterDays>
					 </cfif>
					 
					 <cfif ProgramAccess eq "ALL">
															 
					 	<cfinput type="Text"
					       name="StartAfterDays#ActivityId#"
					       value="#d#"
					       range="1,90"
						   onchange="setstartdate('#activityid#')"
					       validate="integer"
					       required="No"
					       visible="Yes"
						   class="regularxl"
					       enabled="Yes"
					       style="width:30px;text-align:center">	
						   
						   <cf_tl id="days">
					   
					  <cfelse>
					  
					  	#d# <cf_tl id="days">
					  
					  </cfif>  
					 </td>
					 
					 </tr>
				 </table>
				 </td>				
			</tr> 
						 		   	  
		   </cfloop>
		   </table>		   
			
</cfoutput>	

