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


<tr>  
  
       <td class="labelmedium" style="padding-top:3px"><cf_space spaces="10">#row#.</td>
	  
	   <td class="labelmedium" width="180"><cf_space spaces="80">	  
	   #Description# <cfif ValueObligatory eq "1"><font color="FF0000">*</font></cfif>:</td>
	   <td width="100%" style="z-index:#rows-currentrow#; position:relative;">

	   <cfif URL.Mode neq "edit">
	   
	       <cfif ValueClass eq "List">
	   
			    <cfquery name="GetList" 
				  datasource="AppsCaseFile" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT   T.*, 
				           P.ListCode as Selected
				  FROM     Ref_TopicList T, 
				           ElementTopic P
				  WHERE    T.Code        = '#Code#'
				  AND      P.Topic         = T.Code
				  AND      P.ListCode      = T.ListCode
				  AND      P.ElementId     = '#URL.elementid#'		  
				  AND      P.ElementLineNo = '0'				
				  ORDER BY T.ListOrder
				</cfquery>
				
				<cfif GetList.ListValue neq "">
			   
				   #GetList.ListValue#
				   
				<cfelse>
				
				   N/A
				   
				</cfif>  
			
			<cfelse>
						
				 <cfquery name="GetList" 
				  datasource="AppsCaseFile" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT *
				  FROM   ElementTopic P
				  WHERE  P.Topic = '#Code#'						 
				  AND    P.ElementId     = '#URL.elementid#'		  
				  AND    P.ElementLineNo = '0'		
				  <!---
				  AND    P.DateEffective = (SELECT MAX(DateEffective)
				                            FROM   WorkOrderLineTopic
											WHERE  WorkOrderId   = '#URL.workorderid#'		  
										    AND    WorkOrderLine = '#url.workorderline#'
											AND    Topic = '#GetTopics.Code#'
											)
											
											--->
				  
				    
				</cfquery>
				
				<cfif GetList.TopicValue neq "">
				
				   <cfif ValueClass eq "Boolean">
				   
					   <cfif GetList.TopicValue eq "1">Yes<cfelse>No</cfif>
					   
				   <cfelseif ValueClass eq "Date">
				   
				        <cftry>
				   		#dateformat(GetList.TopicValue,CLIENT.DateFormatShow)#			
						<cfcatch></cfcatch>	   	   
						</cftry>
				   
				   <cfelse>
				   
				   		#GetList.TopicValue#
						
				   </cfif>
			   						   
				<cfelse>
				
				   N/A
				   
				</cfif>  					
			
			</cfif>			    
		
	   <cfelse>
	   
	       <!--- retrieve the last value --->
	   	   <cfquery name="GetValue" 
			 datasource="AppsCaseFile" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT *
				  FROM   ElementTopic P
				  WHERE  P.Topic         = '#Code#'						 
				  AND    P.ElementId     = '#URL.elementid#'		  
				  AND    P.ElementLineNo = '0'		 		  
    	   </cfquery>			
		 	   
	   	   <cfif ValueClass eq "List">
	   
			   <cfquery name="GetList" 
				  datasource="AppsCaseFile" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">				  
					  SELECT   T.*, 
					           P.ListCode as Selected
					  FROM     Ref_TopicList T LEFT OUTER JOIN ElementTopic P ON
					                    P.ListCode      = T.ListCode  AND P.Topic  = T.Code
								  AND   P.ElementId     = '#URL.elementid#'		  
								  AND   P.ElementLineNo = '0'						  
					  WHERE    T.Code          = '#Code#'					  			
					  ORDER BY T.ListOrder									 
				</cfquery>
				
				 <cfquery name="Def" 
				  datasource="AppsCaseFile" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT *
					  FROM   Ref_TopicList
					  WHERE  Code = '#Code#'		
					  AND    ListDefault = 1		
				</cfquery>		
								
				<cfif getValue.ListCode neq "">
					<cfset def = getValue.ListCode>
				<cfelse>				    
					<cfset def = getValue.ListCode>				
				</cfif>				
														   					   
			    <select class="regularxl enterastab" name="Topic_#Code#" onchange="#locmatch#">
				
					<cfif ValueObligatory eq "0">
					<option value=""></option>
					</cfif>		
					
					<cfloop query="GetList">					  
						<option value="#GetList.ListCode#" <cfif GetList.ListCode eq def>selected</cfif>>#GetList.ListValue#</option>
					</cfloop>
					
				</select>				
				
			<cfelseif ValueClass eq "Lookup">
					
			   <cfquery name="GetList" 
				  datasource="#ListDataSource#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				 	  SELECT   DISTINCT 
					           #ListPK# as PK, 
					           #ListDisplay# as Display,
							   0 as DEF
					  FROM     #ListTable#
					  <cfif ListCondition neq "">
					  WHERE #preservesinglequotes(ListCondition)#
					  </cfif>
					  ORDER BY #ListDisplay#
				</cfquery>
				
				<cfif ListGroup eq "">
				
					 <cfquery name="GetList" 
				  datasource="#ListDataSource#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				 	  SELECT   DISTINCT 
					           #ListPK# as PK, 
					           #ListDisplay# as Display,
							    <cfif Listorder neq "">
								#ListOrder#,
								</cfif>
							   0 as DEF
					  FROM     #ListTable#
					  <cfif ListCondition neq "">
					  WHERE #preservesinglequotes(ListCondition)#
					  </cfif>
					  <cfif Listorder neq "">
					  ORDER BY #ListOrder#
					  <cfelse>
					  ORDER BY #ListDisplay#
					  </cfif>
					  
				    </cfquery>					
			   					   
				    <select class="regularxl enterastab" name="Topic_#Code#" onchange="#locmatch#">
						<cfif ValueObligatory eq "0">
						<option value=""></option>
						</cfif>
						<cfloop query="GetList">
							<option value="#PK#" <cfif GetList.PK eq GetValue.ListCode>selected</cfif>>#Display#</option>
						</cfloop>
					</select>				
				
				<cfelse>
				
				    <!--- was not getting the right data
				
					<cfquery name="GetValueGroup" 
					  datasource="#ListDataSource#" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					 	  SELECT  #ListGroup# as Grouping					         
						  FROM    #ListTable#
						  WHERE   #ListDisplay# = '#GetValue.TopicValue#'						 
				    </cfquery>		
					
					--->
					
					<cfquery name="GetValueGroup" 
					  datasource="#ListDataSource#" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					 	  SELECT   #ListGroup# as Grouping					         
						  FROM     #ListTable#
						  WHERE   #ListPK# = '#GetValue.ListCode#'		
						  <cfif ListCondition neq "">
						    AND   #preservesinglequotes(ListCondition)#
						  </cfif>					 
				    </cfquery>		
					
					<cfquery name="GetGroup" 
					  datasource="#ListDataSource#" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					 	  SELECT   DISTINCT 
						           #ListGroup# as Grouping 					         
						  FROM     #ListTable#
						  <cfif ListCondition neq "">
						  WHERE    #preservesinglequotes(ListCondition)#
						  </cfif>	
						  AND      #listgroup# != '' 
						  ORDER BY #ListGroup#	
						  			 
				    </cfquery>
					
					<select class="regularxl enterastab" name="topic_#Code#_group" onchange="#locmatch#">
						<cfif ValueObligatory eq "0">
						<option value=""></option>
						</cfif>
						<cfloop query="GetGroup">
							<option value="#Grouping#" <cfif GetGroup.Grouping eq GetValueGroup.Grouping>selected</cfif>>#Grouping#</option>
						</cfloop>
					</select>						
					
					<cfselect name="Topic_#Code#"					   
						bindOnLoad="yes"										
						multiple="No"	
						onchange  = "#locmatch#"
						size="1" 
						class="regularxl enterastab"						
						bind="cfc:service.Input.InputDropdown.DropdownSelect('#ListDataSource#','#ListTable#','#ListPK#','#ListOrder#','#ListDisplay#','','','#ListGroup#',{topic_#Code#_group},'','','#GetValue.ListCode#','','#ListPK#','')"/>				
						
							
				</cfif>		
				
			<cfelseif ValueClass eq "Text" or ValueClass eq "ZIP" or ValueClass eq "Memo">
			
					<cf_tl id="Please Enter a" var="1" class="message">
					
					<cfif ValueLength gte "100" or ValueClass eq "Memo">
					    <cfset valuestyle = "width:100%;font-size:13px;padding:3px;border-radius:2px;border:1px solid silver">										
					<cfelse>
						<cfset valuestyle = "">	
					</cfif>
						
					<cfif ValueClass eq "Memo">		
					
						<table width="100%" cellspacing="0" cellpadding="0">
						<tr>
						<td width="99%">		
																
						<cf_textInput
						   form      = "elementform"
						   type      = "#ValueClass#"						   
						   id        = "Topic_#Code#"
						   name      = "Topic_#Code#"
					       value     = "#GetValue.TopicValue#"					   
					       required  = "#ValueObligatory#"
						   validate  = "#ValueValidation#"
						   message   = "#lt_text# #Description#"
					       visible   = "Yes"
						   class     = "regular enterastab"
						   style     = "#valuestyle#;overflow: scroll;"
					       enabled   = "Yes"					  
					       size      = "#ValueLength#"
					       maxlength = "#ValueLength#">
						   
						</td>
						
						<td width="30" style="padding-top:1px" valign="top">		
						<button onClick="elementmemo('Topic_#Code#')" class="button3">									
						<img src="#Client.VirtualDir#/images/dialog.png" 
						 style="cursor:pointer" 
						 alt="Open Dialog" 
						 border="0" 
						 onclick="elementmemo('Topic_#Code#')">						
						</button>	
						</td>
						
						</tr></table>	   
						   					   
					  <cfelse>
					  
						  <cf_textInput
						   form      = "elementform"
						   type      = "#ValueClass#"
						   mode      = "regular"
						   name      = "Topic_#Code#"
					       value     = "#GetValue.TopicValue#"					   
					       required  = "#ValueObligatory#"
						   validate  = "#ValueValidation#"
						   message   = "#lt_text# #Description#"
					       visible   = "Yes"
					       enabled   = "Yes"
						   class     = "regularxl enterastab"
						   style     = "#valuestyle#"
						   onchange  = "#locmatch#"
					       size      = "#ValueLength#"
					       maxlength = "#ValueLength#">					  
					  
					  </cfif> 
					
				   
			<cfelseif ValueClass eq "Date">		
			
				<cfif ValueObligatory eq 1>
				    <cfset allowBlank = 0>
				<cfelse>
				    <cfset allowBlank = 1>
				</cfif>
				
				<table cellspacing="0" cellpadding="0">
				<tr><td style="padding-top:0px">	
								
				<cf_intelliCalendarDate9
					FieldName="Topic_#Code#" 
					class="regularxl enterastab"
					Default="#dateformat(GetValue.TopicValue,CLIENT.DateFormatShow)#"
					AllowBlank="#allowBlank#"> 						
				
				</td>
				</tr>
				</table>
				
			<cfelseif ValueClass eq "time">		
			
				<cfif GetValue.TopicValue neq "">
					<cfset hr = "#timeformat(GetValue.TopicValue,'HH')#">
					<cfset mn = "#timeformat(GetValue.TopicValue,'MM')#">
				<cfelse>
					<cfset hr="">
					<cfset mn="">
				</cfif>
				
				<select name="Topic_#Code#_hour" class="regularxl enterastab">
				
					<option value="" <cfif hr eq "">selected</cfif>></option>
									
					<cfloop index="it" from="0" to="23" step="1">
					
					<cfif it lte "9">
					  <cfset it = "0#it#">
					</cfif>				 
					
					  <option value="#it#" <cfif hr eq it>selected</cfif>>#it#</option>
					
					</cfloop>	
					
				</select>
				
				<select name="Topic_#Code#_minute" class="regularxl enterastab">
				
				        <option value="" <cfif mn eq "">selected</cfif>></option>
										
						<cfloop index="it" from="0" to="59" step="1">
						
						<cfif it lte "9">
						  <cfset it = "0#it#">
						</cfif>				 
						
						  <option value="#it#" <cfif mn eq it>selected</cfif>>#it#</option>
						
						</cfloop>	
									
					</select>		
					
											
				</select>					
															
			<cfelseif ValueClass eq "DateTime">			
			
			    <table cellspacing="0" cellpadding="0">
				<tr><td style="padding-top:6px">
				
				<cfif ValueObligatory eq 1>
				    <cfset allowBlank = 0>
				<cfelse>
				    <cfset allowBlank = 1>
				</cfif>
			
				<cf_intelliCalendarDate8
					FieldName="Topic_#Code#" 
					class="regularxl enterastab"
					Default="#dateformat(GetValue.TopicValue,CLIENT.DateFormatShow)#"
					AllowBlank="#allowBlank#">			
					
					</td>
					
					<td>
					
					<cfset hr = "#timeformat(GetValue.TopicValue,'HH')#">
					<cfset mn = "#timeformat(GetValue.TopicValue,'MM')#">
					
					<select name="Topic_#Code#_hour" class="regularxl enterastab">					
											
						<cfloop index="it" from="0" to="23" step="1">
						
						<cfif it lte "9">
						  <cfset it = "0#it#">
						</cfif>				 
						
						  <option value="#it#" <cfif hr eq it>selected</cfif>>#it#</option>
						
						</cfloop>	
									
					</select>					
					
					</td>
					
					<td>:</td>
					
					<td>
					
					<select name="Topic_#Code#_minute" class="regularxl enterastab">
																
						<cfloop index="it" from="0" to="59" step="1">
						
						<cfif it lte "9">
						  <cfset it = "0#it#">
						</cfif>				 
						
						  <option value="#it#" <cfif mn eq it>selected</cfif>>#it#</option>
						
						</cfloop>	
									
					</select>		
					
					</td>
					</tr>
					
					</table>
					
			<cfelseif ValueClass eq "Map">
			
			      <table cellspacing="0" cellpadding="0">
				  
				  <tr>
				  
				  <td id="map_Topic_#Code#" style="padding-top:2px;padding-bottom:2px">								    
					    <cf_getAddress coordinates="#GetValue.TopicValue#">							
				  </td>
				  
				  <td>		
				  	
				  	<input
					   form      = "elementform"
					   type      = "hidden"
					   mode      = "regular"
					   id        = "Topic_#Code#"
					   name      = "Topic_#Code#"
					   class     = "regularxl enterastab"
				       value     = "#GetValue.TopicValue#">	
					  						   
				   </td>
				   
				   <td>&nbsp;&nbsp;</td>
								   
				   <td>
						  
					   <img src="#Client.VirtualDir#/Images/map.png" alt="Google MAP : [Latitude:Longitude]" name="img0" 
						  onMouseOver="document.img0.src='#Client.VirtualDir#/Images/button.jpg'" 
						  onMouseOut="document.img0.src='#Client.VirtualDir#/Images/map.png'"
						  style="cursor: pointer;" alt="" width="18" height="20" border="0" align="absmiddle" 
						  onClick="openmap('Topic_#Code#')">
						  						   
				   </td>
				   
				   </tr>
				   
				   </table>		
								
			<cfelseif ValueClass eq "Boolean">
					
				<input type="Checkbox"
			       name="Topic_#Code#" class="radiol enterastab" onchange="#locmatch#"
				   <cfif GetValue.TopicValue eq "1">checked</cfif>
			       value="1">
			
			</cfif>
		
	   </cfif>	
	   
	   </td>
  	</tr>	
</cfoutput>	