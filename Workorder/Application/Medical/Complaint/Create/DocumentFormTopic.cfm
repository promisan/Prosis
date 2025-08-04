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
<!--- define custom topics --->

<cfparam name="url.mode"          default="edit">
<cfparam name="url.mission"       default="">
<cfparam name="URL.requestid"     default="00000000-0000-0000-0000-000000000000">
<cfparam name="URL.workorderline" default="0">
<cfparam name="URL.topic"         default="">
<cfparam name="url.context"       default="backoffice">
<cfparam name="URL.inputclass"    default="regular">
<cfparam name="URL.style"         default="padding-left:5px">

<cfquery name="GetTopics" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT   *
  FROM     #CLIENT.LanPrefix#Ref_Topic
  WHERE Operational = 1   
  AND   TopicClass = 'Request'  
  ORDER BY ListingOrder
</cfquery>

<cfoutput query="GetTopics">

<cfif url.topic eq "">

<tr>        
		
				
	   <cfif tooltip neq "">
	      <td height="18" width="30%" class="labelmedium" style="#url.style#;cursor:pointer;">			  
		  <cf_space spaces="60">
	   	  <cf_UIToolTip  tooltip="#Tooltip#"><font color="0080C0">#Description# : <cfif valueobligatory eq "1"><font color="red">*)</font></cfif></cf_UIToolTip>
		  </td>
	   <cfelse>
	    <td height="18" class="labelmedium" style="#url.style#">		
		 <cf_space spaces="60">
	     #Description# : <cfif valueobligatory eq "1"><font color="red">*)</font></cfif>
	    </td>
	   </cfif>
	  
	   <td width="70%" class="labelmedium">		
	   
</cfif>	   
   			    			   
<cfif URL.Mode neq "edit">
   
       <cfif ValueClass eq "List">
   
		    <cfquery name="GetList" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT T.*, 
			         P.ListCode as Selected
			  FROM   #CLIENT.LanPrefix#Ref_TopicList T, 
			         RequestTopic P
			  WHERE  T.Code          = '#GetTopics.Code#'
			  AND    P.Topic         = T.Code
			  AND    P.ListCode      = T.ListCode
			  AND    P.RequestId     = '#URL.RequestId#'		  
			  ORDER BY T.ListOrder
			</cfquery>
			
			<cfif GetList.ListValue neq "">
		   
			   #GetList.ListValue#
			   
			<cfelse>
			
			   N/A
			   
			</cfif>  
		
		<cfelse>
				
			 <cfquery name="GetList" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT *
			  FROM   #CLIENT.LanPrefix#RequestTopic P
			  WHERE  P.Topic         = '#Code#'						 
			  AND    P.RequestId     = '#URL.RequestId#'		  
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
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM   RequestTopic
			WHERE  Topic         = '#Code#'		
			<cfif url.requestid neq "">
			AND    RequestId     = '#URL.RequestId#'		  
			<cfelse>
			AND 1=0
			</cfif>
   	   </cfquery>	
	   	
	 	   
   	   <cfif ValueClass eq "List">
   
		   <cfquery name="GetList" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				  SELECT T.*, P.ListCode as Selected
				  FROM   #CLIENT.LanPrefix#Ref_TopicList T LEFT OUTER JOIN RequestTopic P ON P.Topic = T.Code  
				               <cfif url.requestid neq "">AND    P.RequestId = '#URL.RequestId#' <cfelse> AND 1=0</cfif>
				  WHERE  T.Code = '#Code#'		
				  AND    T.Operational = 1		
				  ORDER BY T.ListOrder
			</cfquery>
							
			 <cfquery name="Def" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				  SELECT *
				  FROM   #CLIENT.LanPrefix#Ref_TopicList
				  WHERE  Code = '#GetTopics.Code#'		
				  AND    ListDefault = 1		
			</cfquery>		
							
			<cfif getValue.ListCode neq "">
				<cfset def = getValue.ListCode>
			<cfelse>				    
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
					
			<cfinput type="Text" name="Topic_#GetTopics.Code#" id="Topic_#GetTopics.Code#"
		       required="#ValueObligatory#"					     
		       size="#valueLength#"
			   class="#url.inputclass# enterastab"
			   message="Please Enter a #GetTopics.Description#"
			   value="#GetValue.TopicValue#"
		       maxlength="#ValueLength#">
			   			   
		<cfelseif ValueClass eq "Date">			
		
			<cfif ValueObligatory eq 0>
				<cf_intelliCalendarDate9 class="#url.inputclass# enterastab"
					FieldName="Topic_#GetTopics.Code#" 
					Default="#dateformat(GetValue.TopicValue,CLIENT.DateFormatShow)#"
					AllowBlank="True">				
			<cfelse>
				<cf_intelliCalendarDate9 class="#url.inputclass# enterastab"
					FieldName="Topic_#GetTopics.Code#" 
					Default="#dateformat(GetValue.TopicValue,CLIENT.DateFormatShow)#"
					AllowBlank="False">			
			</cfif>	
	
							
		<cfelseif ValueClass eq "Boolean">
					
			<input type="Checkbox" class="enterastab" style="height:16px;width:16px"
		       name="Topic_#GetTopics.Code#" 
                  id="Topic_#GetTopics.Code#"
			   <cfif GetValue.TopicValue eq "1">checked</cfif>
		       value="1">		   		   
		
		</cfif>
			
	
</cfif>	
   
<cfif url.topic eq "">
	   
	   </td>
	   
  	</tr>	
	
</cfif>
		    
</cfoutput>	

  
