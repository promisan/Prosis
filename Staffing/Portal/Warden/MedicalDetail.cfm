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
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Topic
  WHERE Operational = 1
  AND Code = '#URL.Code#'
  ORDER BY ListingOrder
</cfquery>

<cfform name="form_topics_#URL.CODE#">


<cfoutput>
<cfloop query = "GetTopics">


<table width = "100%">

<tr>

<td width="5%">&nbsp;</td>

<td>
	   	   <cfif ValueClass eq "List">
	   
			   <cfquery name="GetList" 
				  datasource="AppsEmployee" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT 
					  	0 as Type,
					  	T.Code, 
						T.ListCode, 
						T.ListValue,
						T.ListDefault,
						(
							SELECT COUNT(1)
							FROM PersonMedicalStatus 
							WHERE 
							Topic = T.Code
							AND ListCode = T.ListCode
						    AND PersonNo = '#URL.ID#'		
						)as Total
					  FROM 
					  	Ref_TopicList T 
					  WHERE T.Code = '#URL.Code#'		
					  AND T.Operational = 1		
					  <cfif URL.Multiple eq "1">
						  UNION
						  SELECT 
						  1,
						  'None',
						  'None',
						  'None',
						  999,
		 					 (	SELECT COUNT(1)
								FROM PersonMedicalStatus 
								WHERE 
								Topic = '#URL.Code#'	
								AND PersonNo = '#URL.ID#'		
								AND ListCode IS NOT NULL
							)
						</cfif>

				</cfquery>
				
				<table width = "100%">
				<cfoutput>
				<cfset j = 0 >
				<cfif URL.Multiple eq "1">
					<cfset vColumns = 2>
				<cfelse>
					<cfset vColumns = 5>
				</cfif>
				
	
				<cfloop query="GetList">
						
					 	<cfif GetList.Total neq 0>
							<cfif GetList.Type eq "1">
							 	<cfset vChecked = "No">
								<cfset vClass = "UnChecked">
								
							<cfelse>	
								<cfset vChecked = "Yes">	
								<cfset vClass = "Checked">								
							</cfif>	
						<cfelse>	
							<cfif GetList.Type eq "1">
							 	<cfset vChecked = "Yes">
								<cfset vClass = "Checked">								
							<cfelse>	
								<cfset vChecked = "No">
								<cfset vClass = "UnChecked">								
							</cfif>	
						</cfif> 									
						
						<cfif j MOD vColumns eq 0>
							<tr height="15">    
						</cfif>				
						
						<td width = "2%"></td>
						
						<cfif URL.Multiple eq "1">
							<td width = "5%" >
								<cfinput type="Checkbox" name="Topic_#URL.Code#_#GetList.ListCode#"  onClick="javascript:set_multiple('#GetList.Type#','#URL.Code#','#GetList.ListCode#')" checked="#vChecked#">
							</td>
							<td width = "30%" align = "left" name = "row_#URL.Code#_#GetList.ListCode#" id = "TD_#URL.Code#_#GetList.ListCode#" class = "#vClass#">
								<cfif GetList.Type eq 0>
									<a href="##" onclick="javascript:get_form('#URL.Code#','#GetList.ListCode#')">
								</cfif>	
								#GetList.ListValue#
								<cfif GetList.Type eq 0>	
									</a>
								</cfif>	
							</td>
						<cfelse>
							<td>
							<cfinput type="Radio" name="Topic_#URL.Code#" value="#GetList.ListValue#" onClick="javascript:set_single('#URL.Code#','#GetList.ListCode#')" checked="#vChecked#">#GetList.ListValue#
							</td>
						</cfif>						
						
						<td width = "2%"></td>
	
						<cfset j = j + 1>
					
						<cfif j MOD vColumns eq 0>
							</tr>
						</cfif>	
				</cfloop>

				
				</cfoutput>
				</table>			   					   
			<cfelseif ValueClass eq "Text">
				 <cfquery name="GetValue"  
				  datasource="appsEmployee" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT *
					  FROM  PersonMedicalStatus
					  WHERE Topic = '#URL.Code#'		
					  AND   PersonNo = '#URL.ID#'					 
				</cfquery>		
							
				<cfinput type="Text" 
					name="Topic_#GetTopics.Code#" 
					value="#GetValue.TopicValue#" 
					message="Please enter a #GetTopics.Description#" 
					validate="integer" required="No" 
					size="#valueLength#" 
					maxlength="#ValueLength#"
					onKeyUp= "javascript: set_text('#GetTopics.Code#')">
					
			<cfelseif ValueClass eq "Date">
			
				 <cfquery name="GetValue" 
				  datasource="appsEmployee" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT *
					  FROM  PersonMedicalStatus
					  WHERE Topic = '#URL.Code#'		
					  AND   PersonNo = '#URL.ID#'					 
				</cfquery>			
				
				   <cfif ValueObligatory eq "1">
			
				   <cf_intelliCalendarDate9
						FieldName="Topic_#GetTopics.Code#" 
						Default="#dateformat(GetValue.TopicValue,CLIENT.DateFormatShow)#"
						Message="Please enter a valid date"
						AllowBlank="false">	
						
				   <cfelse>
				   
				    <cf_intelliCalendarDate9
						FieldName="Topic_#GetTopics.Code#" 
						Default="#dateformat(GetValue.TopicValue,CLIENT.DateFormatShow)#"
						Message="Please enter a valid date"
						AllowBlank="true">	
				   
				   
				   </cfif>		
								
			<cfelseif ValueClass eq "Boolean">
			
				 <cfquery name="GetValue" 
				  datasource="appsEmployee" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT *
					  FROM  PersonMedicalStatus
					  WHERE Topic = '#URL.Code#'		
					  AND   PersonNo = '#URL.ID#'					 
				</cfquery>			
			
				<cfif GetValue.recordcount eq 0>
					<cfset vChecked1 = "No">
					<cfset vChecked2 = "No">					
				<cfelse>
					<cfif GetValue.TopicValue eq "1">
						<cfset vChecked1 = "Yes">
						<cfset vChecked2 = "No">
					<cfelse>
						<cfset vChecked1 = "No">
						<cfset vChecked2 = "Yes">
					</cfif>
					
				</cfif>

				<cfinput type="radio" name="Topic_#GetTopics.Code#" value="Yes" onclick="javascript:set_boolean('#URL.Code#','1')" checked="#vChecked1#">Yes
				<cfinput type="radio" name="Topic_#GetTopics.Code#" value="No"  onclick="javascript:set_boolean('#URL.Code#','0')" checked="#vChecked2#">No				
			
			</cfif>
</td>	
</tr>		
</table>

</cfloop>
</cfoutput>

</cfform>