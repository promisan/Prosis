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
  <cfif LookupMultiple eq "0">
							
		<cfif Default.DefaultValue eq "">
		
				<cfquery name="query#CriteriaName#" 
				     datasource="appsSystem" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					     SELECT   DISTINCT *
						 FROM     Ref_ReportControlCriteriaList
						 WHERE    ControlId = '#ControlId#'
						 AND      CriteriaName = '#CriteriaName#' 
						 ORDER BY ListOrder, ListDisplay						
				</cfquery> 	 
		
		<cfelse>
			
				 <cfset tmp = "">
		         <cfloop index="itm" list="#Default.DefaultValue#,#CriteriaDefault#" delimiters=",">
        	     <cfif tmp eq "">
		    	    <cfset tmp = "'#itm#'">
			     <cfelse>
			        <cfset tmp = "#tmp#,'#itm#'">
			     </cfif>
		         </cfloop>
				 
				<cfquery name="query#CriteriaName#" 
			     datasource="appsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
			     SELECT   DISTINCT *
				 FROM     Ref_ReportControlCriteriaList
				 WHERE    ControlId = '#ControlId#'
				 AND      CriteriaName = '#CriteriaName#'
				 AND      ListValue IN (#preserveSingleQuotes(tmp)#) 
				 ORDER BY ListOrder, ListDisplay
				</cfquery> 	  
			 						
		</cfif>
		
		<cfif CriteriaInterface neq "Checkbox">
					
			<cfoutput>
				<table style="width:100%" class="#cl#" id="#fldid#_box" class="formpadding">
			</cfoutput>
			
			<tr><td>	
						
			<cfset qValues = evaluate("query#CriteriaName#")> 
			
			<cf_UIselect name = "#CriteriaName#"
					selected       = "#CriteriaDefault#"
					size           = "1"
					class          = "#cl# regularXXL"
					id             = "#fldid#"
					message        = "#Error#"											
					style          = "width:100%"
					tooltip        = "#CriteriaMemo#"
					label          = "#CriteriaDescription#:"							
					query          = "#qValues#"
					queryPosition  = "below"
					value          = "ListValue"
					display        = "ListDisplay">
						<cfif LookupEnableAll eq "1">
							  <option value="all">    --- <cf_tl id="All"> ---    </option>
						</cfif>  
				</cf_UIselect>
						
			</td></tr>
			
			</table>
			
											
		<cfelse>
		    				
			 <cfset def = "#CriteriaDefault#">	
			 <cfset des = "#CriteriaDescription#">			
			
			<table cellspacing="0" cellpadding="0"><tr>	
			 <cfloop query="query#CriteriaName#">
			 
			 		<td style="<cfif currentrow neq 1>padding-left:10px</cfif>">
				  				  
				        <cfif find(listvalue,#def#)>
						
						  <cfinput type="Radio" 
				           name="#CriteriaName#" 						   				   
						   value="#ListValue#"
		                   size="10" 
						   class="#cls# radiol"
						   id="#fldid#"
		                   maxlength="10" 
				           label="#ListDisplay#"
						   checked/>
						   
						<cfelse>												
						 
						 <cfinput type="Radio" 
				           name="#CriteriaName#" 						   
						   value="#ListValue#"
		                   size="10" 
						   class="#cls# radiol"
						   id="#fldid#"
		                   maxlength="10" 
				           label="#ListDisplay#"/>
						   
						</cfif>
						
						</td>
													
						<cfif format eq "HTML">
						    <td class="labelmedium" style="padding-left:4px;padding-right:5px">
								<cfoutput>
									<cf_tl id="#ListDisplay#">
									<cfif recordcount gte "6"><br></cfif>
								</cfoutput>
							</td>
						</cfif>					
						      										 
				  </cfloop>		
				  
				  </tr>
				</table>
				  
		</cfif>	  		 
				
	<cfelse>
	
			<cfif Default.DefaultValue eq "">
		
				<cfquery name="query#CriteriaName#" 
					     datasource="appsSystem" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
					     SELECT DISTINCT *
						 FROM   Ref_ReportControlCriteriaList
						 WHERE  ControlId = '#ControlId#'
						 AND    CriteriaName = '#CriteriaName#' 
						 ORDER BY ListOrder, ListDisplay
						
				</cfquery> 	 
		
			<cfelse>
			
				 <cfset tmp = "">
		         <cfloop index="itm" list="#Default.DefaultValue#,#CriteriaDefault#" delimiters=",">
        	     <cfif tmp eq "">
		    	    <cfset tmp = "'#itm#'">
			     <cfelse>
			        <cfset tmp = "#tmp#,'#itm#'">
			     </cfif>
		         </cfloop>
				 						 
				<cfquery name="query#CriteriaName#" 
			     datasource="appsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				     SELECT   DISTINCT *
					 FROM     Ref_ReportControlCriteriaList
					 WHERE    ControlId = '#ControlId#'
					 AND      CriteriaName = '#CriteriaName#'
					 AND      ListValue IN (#preserveSingleQuotes(tmp)#) 
					 ORDER BY ListOrder, ListDisplay
				</cfquery> 	  
			 						
			</cfif>	
			
				<cfif CriteriaInterface neq "Checkbox">
				
				<!---
				
				<cfif s gt evaluate("query#CriteriaName#.recordcount")>
					<cfset s = evaluate("query#CriteriaName#.recordcount")>
					<cfif s lte 1>
						<cfset s = 2>
					</cfif>
				</cfif>
				<cfset ht = s*22+3>		
				
				--->
				
				<cfset qValues = evaluate("query#CriteriaName#")> 
								
				<cf_UIselect name = "#CriteriaName#"
					selected       = "#CriteriaDefault#"
					multiple       = "Yes"
					class          = "#cl# regularXXL"
					id             = "#fldid#"
					message        = "#Error#"											
					style          = "width:100%"
					tooltip        = "#CriteriaMemo#"
					label          = "#CriteriaDescription#:"							
					query          = "#qValues#"
					queryPosition  = "below"
					value          = "ListValue"
					display        = "ListDisplay">  
				</cf_UIselect>							
			
			<cfelse>
			
				<cfoutput>
				<table border="0" cellspacing="0" cellpadding="0" class="#cl#" id="#fldid#_box" class="formpadding">
				
					 <tr><td class="labelmedium">
				
				      <cfset fld = "#Parameter.CriteriaName#">
					  <cfset des = "#Parameter.CriteriaDescription#">
				
				      <cfloop query="query#CriteriaName#">
					  
					         <!---  class="#class#"  --->
					  
					        <cfif find(listvalue,Parameter.CriteriaDefault)>
							
							  <cfinput type   = "CheckBox" 
					           name           = "#fld#_#currentrow#" 
							   value          = "#ListValue#"
			                   size           = "10"
							   id             = "#fldid#"
							   class          = "radiol"
							   maxlength      = "10" 
					           label          = "#ListDisplay#"
							   checked/>
							   
							<cfelse>
							
							 <cfinput type    = "CheckBox" 
					           name           = "#fld#_#currentrow#" 
							   value          = "#ListValue#"
			                   size           = "10" 
							   maxlength      = "10" 
							   class          = "radiol"
					           label          = "#ListDisplay#"/>
							   
							</cfif>
																							
							<cfif format eq "HTML"><cfoutput><cf_tl id="#ListDisplay#">&nbsp;</cfoutput></cfif>
							
							<cfif evaluate("query#CriteriaName#.recordcount") gt "3">
							  </td></tr><tr><td>
							</cfif>
							      										 
					  </cfloop>	
					  
					 </td></tr>
				</table>	
				</cfoutput> 				  			 
			
			</cfif>
				
	</cfif>
	