<!--
    Copyright © 2025 Promisan

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
 	
<cfoutput>
							
	<table class="#cl#"
       id="#fldid#_box">
	
	<tr>
	<td width="1"></td>
	<td>	
																			
	<cfif CriteriaDateRelative eq "1">
	
	   <cfif CriteriaDefault eq "today">
	    <cfset rel = "0"> 
	   <cfelse>
	    <cfset rel = "#CriteriaDefault#">  	
	   </cfif>
	   
	   <cf_tl id="Enter a relative deviation from today's date varying from -100 and +100" var="vRelDate">
	   
	    <table>
		<tr>
		<td class="labelmedium2 fixlength" title="#vRelDate#">						
		<cf_tl id="TODAY">:		
		</td>
		
		<td style="border: 0px solid Silver;" title="#vRelDate#">
				
			 <cfinput type="Text"
		       name="#CriteriaName#"				   
		       value="#rel#"
		       range="-100,100"
		       message="#vRelDate#"
		       required="No"
		       size="2"				   
			   style="text-align: center;border:1px solid silver"
		       maxlength="4"
			   class="regularXXL">
		   
		   </td>
	   
	   <cfif CriteriaDatePeriod eq "1" and CriteriaType eq "Date">
	   
	   	</td>
		<td class="labelmedium2 fixlength" style="padding-left:7px;padding-right:6px" title="#vRelDate#" align="center"><cf_tl id="until">:</td>
		
		<td style="border: 0px solid Silver;">
		
	   	  <cfset relt = "#DefaultValueEnd#">
		   
		  <cfif CriteriaDefault eq "today">
	    		<cfset rel = "0"> 
		  <cfelse>
			    <cfset rel = "#DefaultValueEnd#">  	
		  </cfif>
	   
	   	  <cfinput type = "Text"
	       name         = "#CriteriaName#_end"
	       value        = "#rel#"
	       range        = "-500,500"
	       message      = "#vRelDate#"
	       required     = "No"
	       size         = "2"			   
		   style        = "text-align: center;border:1px solid silver"
	       maxlength    = "4"
		   class        = "regularXXL">	
		   
		   </td>
	   		   
	   </cfif>
	   
	   </tr>
	   
	   </table>
	   		  								   		   
    <cfelse>
	
	   <cfif CriteriaDefault eq "today">		   
		   <cfset default = "#dateFormat(now(),CLIENT.DateFormatShow)#">			   
	   <cfelse>		   
		   <cfset default = "#DefaultValue#">			
	   </cfif>
				
		<table cellspacing="0" cellpadding="0">
		<tr>				
		<td style="min-width:150px">	
		
			<cfif CriteriaDatePeriod eq "1">
			   <cfset sc = "updatedate('#criterianame#','#criterianame#_end')">			  
			<cfelse>
			  <cfset  sc = "">			 
			</cfif> 

			<!--- removing the following line  - Armin 1/4/2015
					script           = "#sc#"
			--->		
			
			<cf_tl id="Enter a date" var="vRelDateErrMess">									 
											  				   				   				   				 				 	   				  			   
		    <cf_intelliCalendarDate9
				FieldName        = "#criterianame#" 
				FieldDescription = "#CriteriaDescription#"
				message          = "#vRelDateErrMess#"
				Default          = "#default#"
				mask             = "false"
				AllowBlank       = "#obd#"
				style            = "text-align: center;font-size:14px;border:1px solid silver"		
				class            = "regularXXL">	
		
		</td>
		
		<cfif CriteriaDatePeriod eq "1" and CriteriaType eq "Date">
		
			   <cfset default = "#DefaultValueEnd#">
							   			
				<td width="8" align="center" style="padding:0px">-</td>
				<td valign="bottom" style="min-width:150px">
			
				   <cf_intelliCalendarDate9
					FieldName        = "#criterianame#_end" 
					FieldDescription = "#CriteriaDescription#"
					Default          = "#default#"
					mask             = "false"
					style            = "text-align: center;font-size:14px;border:1px solid silver"	
					AllowBlank       = "#obd#"
					class            = "regularXXL">	
									
			    </td>
		</cfif>
		
		</tr>
		</table>
								   
	</cfif>
	
	</td></tr></table>
	
</cfoutput>
		
		