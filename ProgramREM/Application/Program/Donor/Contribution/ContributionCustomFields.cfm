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
<cfparam name="url.action"       default="view">

<cfparam name="URL.ContributionId"   default="00000000-0000-0000-0000-000000000000">
<cfparam name="URL.inputclass"    default="regularxl">
<cfparam name="URL.style"         default="height:18px;padding-left:5px">

<cfquery name="GetTopics" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Topic
	WHERE Mission = '#url.Mission#'
	AND TopicClass = 'Contribution'
	AND Operational = 1
 	ORDER BY ListingOrder	
</cfquery>

<cfset cnt = 0>

<cfoutput query="GetTopics">

	<cfset cnt = cnt+1>

	<cfif cnt eq "1">
	<tr>        
	</cfif>
		
	<cfif tooltip neq "">
	      <td height="18" class="labelmedium" style="#url.style# cursor:pointer;">	
		  <cf_space spaces="40">
	   	  <cf_UIToolTip  tooltip="#Tooltip#"><font color="0080C0">#Description# : <cfif valueobligatory eq "1"><font color="red">*)</font></cfif></cf_UIToolTip>
		  </td>
	<cfelse>
	    <td height="18" class="labelmedium" style="#url.style#">	
		 <cf_space spaces="40">
	    #Description# : <cfif valueobligatory eq "1"><font color="red">*)</font></cfif>
	    </td>
	</cfif>
	  
	   <td width="80%" class="labelmedium">		
			 			   
	   <cfif URL.action neq "edit" and URL.action neq "new">
	   
	       <cfif ValueClass eq "List">
	   
			    <cfquery name="GetList" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">

				  
					SELECT T.*, 
					     P.ListCode as Selected
					FROM  Ref_TopicList T, 
					      ContributionTopic P
					WHERE  T.Code        = '#GetTopics.Code#'
					AND    P.Topic         = T.Code
					AND    P.ListCode      = T.ListCode
					AND    P.ContributionId = '#URL.ContributionId#'		  
					ORDER BY T.ListOrder				  
				  
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
				  FROM   ContributionTopic P
				  WHERE  P.Topic = '#GetTopics.Code#'						 
				  AND    P.ContributionId  = '#URL.ContributionId#'		  				    
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
			 datasource="AppsProgram" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT TOP 1 *
				FROM   ContributionTopic
				WHERE  Topic = '#Code#'		
				AND    ContributionId   = '#URL.ContributionId#'		  
    	   </cfquery>	
		   
			<cfif GetValue.TopicValue neq "">
				<cfset vDefault = GetValue.TopicValue>
			<cfelse>
				<cfset vDefault = "">	
			</cfif>		   		
		 	   
	   	   <cfif ValueClass eq "List">
	   
			   <cfquery name="GetList" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT T.*, P.ListCode as Selected
					  FROM   Ref_TopicList T LEFT OUTER JOIN ContributionTopic P ON P.Topic = T.Code  
					               AND    P.ContributionId   = '#URL.ContributionId#'		
								   								   
					  WHERE  T.Code = '#Code#'		
					  AND    T.Operational = 1		
					  ORDER BY T.ListOrder
				</cfquery>
								
				 <cfquery name="Def" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT *
					  FROM   Ref_TopicList
					  WHERE  Code = '#GetTopics.Code#'		
					  AND    ListDefault = 1		
				</cfquery>		
				
				<cfset def = "">							
				<cfif getValue.ListCode neq "">
					<cfset def = getValue.ListCode>
				</cfif>				
														   					   
			    <select name="Topic_#GetTopics.Code#" id="Topic_#GetTopics.Code#" class="#url.inputclass# enterastab">
				
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
					  ORDER BY #ListDisplay#
				</cfquery>
			   					   
			    <select name="Topic_#GetTopics.Code#" id="Topic_#GetTopics.Code#" class="#url.inputclass# enterastab">
					<cfif ValueObligatory eq "0">
					<option value=""></option>
					</cfif>
					<cfloop query="GetList">
						<option value="#PK#" <cfif GetList.Display eq GetValue.TopicValue>selected</cfif>>#Display#</option>
					</cfloop>
				</select>						
				
			<cfelseif ValueClass eq "Text">
						
				<cfinput type="Text"
			       name="Topic_#GetTopics.Code#"
                   id="Topic_#GetTopics.Code#"
			       required="#ValueObligatory#"					     
			       size="#valueLength#"
				   class="#url.inputclass# enterastab"
				   message="Please Enter a #GetTopics.Description#"
				   value="#GetValue.TopicValue#"
			       maxlength="#ValueLength#">
				   
			<cfelseif ValueClass eq "Date">			
			
				<cf_intelliCalendarDate9 class="#url.inputclass# enterastab"
					FieldName="Topic_#GetTopics.Code#" 
					Default="#dateformat(GetValue.TopicValue,CLIENT.DateFormatShow)#"
					AllowBlank="#ValueObligatory#">	
								
			<cfelseif ValueClass eq "Boolean">
						
				<input type="Checkbox" class="enterastab" style="height:14px height:14px"
			       name="Topic_#GetTopics.Code#" 
                   id="Topic_#GetTopics.Code#"
				   <cfif vDefault eq "1">checked</cfif>
			       value="1">				   		   
			
			</cfif>
		
	   </cfif>	
	   
	   </td>	   
	   
<cfif cnt eq "2">
</tr>        
<cfset cnt=0>
</cfif>	   
  			    
</cfoutput>	