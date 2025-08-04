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

  <cfquery name="GetTopics" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Topic
  WHERE  Code IN (SELECT Code 
                 FROM   Ref_TopicObject 
				 WHERE  ObjectCode = '#URL.ObjectCode#')
  AND    Operational = 1
</cfquery>

<cfoutput query="GetTopics">

<tr>    
	   <td width="10%" class="labelit">#Description# :</td>
	   <td class="labelit">
	    			   
	   <cfif URL.Mode neq "edit" and url.mode neq "add">
	   
	       <cfif ValueClass eq "List">
	   
			    <cfquery name="GetList" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT T.*, P.ListCode as Selected
				  FROM Ref_TopicList T, ProgramAllotmentRequestTopic P
				  WHERE T.Code = '#GetTopics.Code#'
				  AND P.Topic = T.Code
				  AND P.ListCode = T.ListCode
				  AND P.RequirementId = '#ID#'				  
				</cfquery>
				
				<cfif GetList.ListValue neq "">
			   
				   #GetList.ListValue#
				   
				<cfelse>
				
				   N/A
				   
				</cfif>  
			
			<cfelse>
						
				 <cfquery name="GetList" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT *
				  FROM   ProgramAllotmentRequestTopic P
				  WHERE P.Topic = '#GetTopics.Code#'						 
				  AND   P.RequirementId = '#ID#'				  
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
	   
	   	   <cfif ValueClass eq "List">
	   
			   <cfquery name="GetList" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT T.*, P.ListCode as Selected
					  FROM Ref_TopicList T LEFT OUTER JOIN ProgramAllotmentRequestTopic P ON P.Topic = T.Code AND P.RequirementId = '#ID#'
					  WHERE T.Code = '#GetTopics.Code#'		
					  AND T.Operational = 1		
				</cfquery>
			   					   
			    <select name="Topic_#GetTopics.Code#" id="Topic_#GetTopics.Code#" class="regularxl">
				<cfif ValueObligatory eq "0">
				<option value=""></option>
				</cfif>
				<cfloop query="GetList">
					<option value="#GetList.ListCode#" <cfif GetList.Selected eq GetList.ListCode>selected</cfif>>#GetList.ListValue#</option>
				</cfloop>
				</select>				
				
			<cfelseif ValueClass eq "Lookup">
			
				 <cfquery name="Current" 
				  datasource="appsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT *
					  FROM  ProgramAllotmentRequestTopic
					  WHERE Topic = '#GetTopics.Code#'		
					  AND   RequirementId = '#ID#'					 
				</cfquery>			
			
			   <cfquery name="GetList" 
				  datasource="#ListDataSource#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				 	  SELECT   DISTINCT 
					           #ListPK# as PK, 
					           #ListDisplay# as Display,
							   0 as DEF
					  FROM     #ListTable#
					  ORDER BY #ListDisplay#
				</cfquery>
			   					   
			    <select name="Topic_#GetTopics.Code#" id="Topic_#GetTopics.Code#" class="regularxl enterastab">
				<cfif ValueObligatory eq "0">
				<option value=""></option>
				</cfif>
				<cfloop query="GetList">
					<option value="#PK#" <cfif GetList.Display eq Current.TopicValue>selected</cfif>>#Display#</option>
				</cfloop>
				</select>						
				
			<cfelseif ValueClass eq "Text">
			
				 <cfquery name="GetValue" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT *
				  FROM   ProgramAllotmentRequestTopic P
				  WHERE P.Topic = '#GetTopics.Code#'						 
				  AND   P.RequirementId = '#ID#'				  
				</cfquery>
			
				<cfinput type="Text"
			       name="Topic_#GetTopics.Code#" id="Topic_#GetTopics.Code#"
			       required="#ValueObligatory#"					     
			       size="#valueLength#"
				   Class="regularxl enterastab"
				   message="Please enter a #GetTopics.Description#"
				   value="#GetValue.TopicValue#"
			       maxlength="#ValueLength#">
				   
			<cfelseif ValueClass eq "Date">
			
				 <cfquery name="GetValue" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT *
				  FROM   ProgramAllotmentRequestTopic P
				  WHERE P.Topic = '#GetTopics.Code#'						 
				  AND   P.RequirementId = '#ID#'				  
				</cfquery>
			
				   <cf_intelliCalendarDate9
						FieldName="Topic_#GetTopics.Code#" 
						class="regularxl enterastab"
						Default="#dateformat(GetValue.TopicValue,CLIENT.DateFormatShow)#"
						AllowBlank="#ValueObligatory#">	
								
			<cfelseif ValueClass eq "Boolean">
			
				 <cfquery name="GetValue" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT *
				  FROM   ProgramAllotmentRequestTopic P
				  WHERE P.Topic = '#GetTopics.Code#'						 
				  AND   P.RequirementId = '#ID#'				  
				</cfquery>	
			
				<input type="Checkbox"
				   class="enterastab"
				   style="width:17px;height:17px
			       name="Topic_#GetTopics.Code#" id="Topic_#GetTopics.Code#"
				   <cfif GetValue.TopicValue eq "1">checked</cfif>
			       value="1">
			
			</cfif>
		
	   </cfif>	
	   
	   </td>
	   
  	</tr>			   
	    
  </cfoutput>	