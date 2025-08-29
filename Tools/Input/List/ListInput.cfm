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
<cfoutput>

<cfparam name="Attributes.Form"           default="">
<cfparam name="Attributes.Parent"         default="">
<cfparam name="Attributes.Type"           default="List">
<cfparam name="Attributes.Class"          default="regularxl">
<cfparam name="Attributes.Name"           default="">
<cfparam name="Attributes.Value"          default="">
<cfparam name="Attributes.Required"       default="1">
<cfparam name="Attributes.Visible"        default="Yes">
<cfparam name="Attributes.Enabled"        default="Yes">
<cfparam name="Attributes.Size"           default="20">
<cfparam name="Attributes.MaxLength"      default="#Attributes.Size#">

<cf_tl class="Message" id="PleaseEnterAValue" var="1">

<cfparam name="Attributes.Message"        default="#lt_text#">
<cfparam name="Attributes.Class"          default="regularxl">
<cfparam name="Attributes.DataSource"     default="appsSystem">
<cfparam name="Attributes.Mode"           default="regularxl">
<cfparam name="Attributes.Query"          default="">
<cfparam name="Attributes.Multiple"       default="No">
<cfparam name="Attributes.Style"       	  default="">
<cfparam name="Attributes.OnChange"       default="">

<cfquery name="list" 
  datasource="#Attributes.DataSource#" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  #preserveSingleQuotes(Attributes.Query)#
</cfquery>

<input type="hidden" id="#Attributes.Name#_selected">
				  
 <cfif (List.recordcount lte "8" and List.ValueMask neq "Combo") or Attributes.Multiple eq "Yes">

	  <cfif Attributes.Multiple eq "No">
	  		 
		<table height="100%" cellspacing="0" cellpadding="0">
			<tr>
						
			<cfloop query="List">
			
						
			<cfif Style eq "" or operational eq "0">			
				<cfset st = "height:25px;padding-left:2px;">
			<cfelse>			
				<cfset st = "#liststyle#;height:25px;padding-left:2px;">
			</cfif>
												     
				<td style="#st#;padding-right:3px">
																																																					
					<input type="radio" style="#Attributes.Style#;height:15px;width:15px;display:inline-block;"
					 	name="#Attributes.Name#" id="#Attributes.Name#"
					 	value="#PK#" class="enterastab"
					 	<cfif (Attributes.Value eq PK) or (Attributes.Value eq "" and Def eq "1")>
					   	checked
					 	</cfif>
						<cfif list.operational eq "0">disabled</cfif>
					 	onclick="document.getElementById('#Attributes.Name#_selected').value='#PK#';toggle('#Attributes.Parent#','#TopicEntry#');<cfif attributes.tooltip eq "1">showtopiccode('#attributes.parent#','#list.pk#')</cfif>" 										
						onchange="#Attributes.OnChange#">
				</td>
				
				<cfif Style eq "" or operational eq "0">
					<cfset st = "padding-left:1px;padding-right:5px">
				<cfelse>
					<cfset st = "#liststyle#;font-size:12px;padding-top:2px;padding-left:1px;padding-right:5px;font-family:Helvetica Neue, Helvetica, Arial, sans-serif;">
				</cfif>
			
				<td style="#st#" class="labelmedium">#Display#</td>
				
			</cfloop>	
			
			</tr>
		</table>  			    	
		  
	 <cfelse>
	 
		  <table>
		  
		  <cfif list.recordcount lte "3">
		  
		   <tr>
		   <cfloop query="List">
		 		
	 			<td>  
					<table>
						<tr>
							<td>
								<input type="checkbox" class="radiol"
								 	name="#Attributes.Name#" id="#Attributes.Name#"
								 	value="#PK#" class="enterastab"
								 	<cfif (ListContainsNoCase(Attributes.Value, PK)) or (Attributes.Value eq "" and Def eq "1")>
								   	checked
								 	</cfif>
								 	onclick="toggle('#Attributes.Parent#','#TopicEntry#')"
									onchange="#Attributes.OnChange#"
									style="#Attributes.Style#">
							</td>
							<td style="padding-left:3px;padding-right:6px" class="labelmedium">#Display#</td>
						</tr>
					</table>  
		    	</td>
			   			
		  </cfloop>
		   </tr>	
		  
		  <cfelse>
		  
	      <cfloop query="List">
		 		<tr>
		 			<td>  
						<table>
							<tr>
								<td>
									<input type="checkbox" class="radiol"
									 	name="#Attributes.Name#" id="#Attributes.Name#"
									 	value="#PK#" class="enterastab"
									 	<cfif (ListContainsNoCase(Attributes.Value, PK)) or (Attributes.Value eq "" and Def eq "1")>
									   	checked
									 	</cfif>
									 	onclick="toggle('#Attributes.Parent#','#TopicEntry#')"
										onchange="#Attributes.OnChange#"
										style="#Attributes.Style#">
								</td>
								<td style="padding-left:3px;" class="labelmedium">#Display#</td>
							</tr>
						</table>  
			    	</td>
			    </tr>				
		  </cfloop>
		  
		  </cfif>
		  </table>	 
	 </cfif>	
	   
 <cfelse>
     	
    <select name="#Attributes.Name#" <cfif attributes.required eq "1">required</cfif>
	      id="#Attributes.Name#" class="#attributes.mode#" onchange="#Attributes.OnChange#">

		  <cfloop query="List">
		  
			  <cfif pk eq "na" or pk eq "L99">
			  	<cfset val = "">
			  <cfelse>
			  	<cfset val = pk>	
			  </cfif>
			  
			  <option value="#val#" 
				 <cfif (Attributes.Value eq PK) or (Attributes.Value eq "" and Def eq "1")>selected</cfif>>
				 #Display#
			  </option>
			   
		  </cfloop>
		  
	  </select>
	  
 </cfif>	
 
 </cfoutput>