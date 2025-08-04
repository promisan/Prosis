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


<cfparam name="Attributes.Message"          default="Error in Date">
<cfparam name="Attributes.AllowBlank"       default="True">
<cfparam name="Attributes.DateValidStart"   default="19500101">	
<cfparam name="Attributes.DateValidEnd"     default="20500101">	
<cfparam name="Attributes.Script"           default="">	
<cfparam name="Attributes.ScriptDate"       default="">	
<cfparam name="Attributes.Class"            default="regular">	
<cfparam name="Attributes.Id"               default="#Attributes.FieldName#">
<cfparam name="Attributes.Manual"           default="true">	
<cfparam name="Attributes.Calendar"         default="show">	
<cfparam name="Attributes.InLine"           default="false">	
<cfparam name="Attributes.onError"          default="">
<cfparam name="Attributes.Disabled"         default="">
<cfparam name="Attributes.Style"            default="text-align:center">
<cfparam name="Attributes.OnKeyUp"          default="">
<cfparam name="Attributes.OnChange"         default="">

<cfset mask = "99/99/9999">

<cfif attributes.allowblank eq "false">
   <cfset req = "Yes">	  
<cfelse>
   <cfset req = "No">	
</cfif>

<cfif Attributes.Default eq "TODAY">
      <cfset Attributes.default = Dateformat(now(), CLIENT.DateFormatShow)>
</cfif>

<cfparam name="Attributes.tooltip" default="Enter Date">
<cfparam name="Attributes.default" default="today">

<!--- received default value for calendar --->

<cfset def = Attributes.Default>

<cfif attributes.calendar eq "show">

	<!--- mask caused conversion of dates --->
	<cfset mask = CLIENT.DateFormatShow>
			
	<cfif APPLICATION.DateFormat eq "EU" or APPLICATION.DateFormat eq "DD/MM/YYYY">
	    <cfset dateval = "eurodate">
		<cfset APPLICATION.DateFormat = "EU">
	<cfelse>
		<cfset dateval = "date">
	</cfif>
		
	<cfoutput>
	
	<table cellspacing="0" cellpadding="0">
	<tr class="fixlengthlist">
	<td title="#Attributes.ToolTip#" style="cursor:pointer;padding-left:0px">
		
	<cfif attributes.inline eq "true">
	
	<input type="hidden" 	 
		 id         = "#Attributes.id#" 	 
	     class      = "#Attributes.Class#"
	     style      = "#Attributes.Style#"
		 readonly	
		 size       = "11"	
		 name       = "#Attributes.FieldName#" 
		 value      = "#attributes.default#"/>
		 
	<cfelseif attributes.manual eq "False">
	
		<input type="text" 	 
		 id         = "#Attributes.id#" 	 
	     class      = "#Attributes.Class#"
	     style      = "#Attributes.Style#"
		 readonly	
		 size       = "11"	
		 name       = "#Attributes.FieldName#" 
		 value      = "#attributes.default#"/>
	
	<cfelse>
											
		<cfif Attributes.onError neq "">		
		
							
			<cfinput type="text" 	 
		 	id         = "#Attributes.id#" 		 	
	     	class      = "#Attributes.Class#"
	     	style      = "#Attributes.Style#"
		 	validate   = "#dateval#"
	     	required   = "#req#"	
		 	size       = "11"
			mask       = "99/99/9999"
			onKeyUp    = "#attributes.OnKeyUp#"
			OnChange   = "#attributes.OnChange#"
			OnBlur     = "#attributes.OnChange#"
		 	onError    = "#Attributes.onError#"	
		 	message    = "#Attributes.Message#"
		 	name       = "#Attributes.FieldName#" 
		 	value      = "#attributes.default#"/>
			
		<cfelse>
			
				<cfinput type="text" 	 
			 	id         = "#Attributes.id#" 		 	
		     	class      = "#Attributes.Class#"
		     	style      = "#Attributes.Style#"
			 	validate   = "#dateval#"
		     	required   = "#req#"	
			 	size       = "11"
				mask       = "99/99/9999"
				onKeyUp    = "#attributes.OnKeyUp#"
				OnChange   = "#attributes.OnChange#"
				OnBlur     = "#attributes.OnChange#"
			 	message    = "#Attributes.Message#"
			 	name       = "#Attributes.FieldName#" 
			 	value      = "#attributes.default#"/>				
			
		</cfif>
					 
	 </cfif>	
		 		 	 
	 </td> 
	 	 
	 <td style="padding-top:3px" id="#Attributes.id#picker">
	 			 			 	 	
		<script type="text/javascript">
		   	// <![CDATA[
	        var today     = new Date(),
	            // low range, 35 days before today's date
	            rangeLow  = new Date(today.getFullYear(), today.getMonth(), today.getDate() - 35),
	            // high range, one year after today's date
	            rangeHigh = new Date(today.getFullYear() + 1, today.getMonth(), today.getDate())				
			       
	        single_opts = {        
			        id:"#Attributes.Id#",                    
	                formElements:{"#Attributes.Id#":"d-sl-m-sl-Y"},
	                showWeeks:true,
					noFadeEffect:true,
					staticPos:#attributes.inline#,
					highlightDays:[0,0,0,0,0,1,1],
					bespokeTitles:{"****1225":"Christmas Day", "****1231":"New Years Eve", "****0101":"New Years Day"}, 
					// disabledDays:[0,0,0,0,0,1,1] ,                 
	                // Set some dynamically calculated ranges				
	                rangeLow:"#attributes.dateValidStart#",
	                rangeHigh:"#attributes.dateValidEnd#", 			
					<cfif attributes.scriptdate neq "">
					callbackFunctions:{"dateset":[#attributes.scriptdate#] },
					<cfelseif attributes.script neq "">
					callbackFunctions:{"dateset":[#attributes.script#] },
					</cfif>
					statusFormat:"l-cc-sp-d-sp-F-sp-Y"				  					   
		        };
			
			
		 	var found=0;
			for ( i = 0; i< opts.length; i++) {		         
				var test_opts = opts[i];
				if (test_opts.id=="#Attributes.id#") {	
					found=1;
					datePickerController.destroyDatePicker("#Attributes.Id#");
					opts[i]=single_opts;
					break;
				}	
			}  
		
			if (found==0) {
				opts.push(single_opts);	
			}	
			
	      // ]]>
			disabledDates_#Attributes.Id# = {
				<cfloop list="#Attributes.Disabled#" index="i">
				        "#i#":1,
				</cfloop>
		    };
		  
		  doCalendar();	  
		  
	      </script>
		 		 		 	  
	  </td>
	  	  
	  <!--- ----------------------------------------------- --->
	  <!--- box for ajax scripting processing of the result --->
	  <!--- ----------------------------------------------- --->
	  
	  <td id="#Attributes.id#_trigger" class="xhide"></td>
	  
	  </tr>
	  </table>
	  
	</cfoutput>	
	
</cfif>	    