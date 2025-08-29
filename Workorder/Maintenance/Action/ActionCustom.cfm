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
<cfparam name="url.mode" default="edit">

<!--- define custom topics --->

<cfquery name="GetTopics" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Topic
  WHERE  Code IN (SELECT Code 
                  FROM   Ref_TopicServiceItem
				  WHERE  ServiceItem = '#url.ServiceItem#'
				 )
  AND    (Mission = '#url.Mission#' or Mission is NULL)				 
  AND    Operational = 1 
  AND    TopicClass = 'ActionProcess'
  ORDER BY ListingOrder
  
</cfquery>

<cfoutput query="GetTopics">

<tr>    

       <td></td>
	   <td height="20" class="labelit">#Description# :<cf_space spaces="30"></td>
	   
	   <td width="85%">
	    			   
	   <cfif URL.Mode neq "edit">
	   
	       <cfif ValueClass eq "List">
	   
			    <cfquery name="GetList" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT T.*, 
				         P.ListCode as Selected
				  FROM   Ref_TopicList T, 
				         Ref_ActionServiceItemTopic P
				  WHERE  T.Code        = '#GetTopics.Code#'
				  AND    P.Topic         = T.Code
				  AND    P.ListCode      = T.ListCode
				  <cfif url.code neq "">
				  AND    P.Code  = '#URL.code#'
				  AND    P.ServiceItem  = '#URL.ServiceItem#'
			  	  <cfelse>
				  AND    1=0
				  </cfif>
				 		 				 
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
				  FROM   Ref_ActionServiceItemTopic P
				  WHERE  P.Topic = '#GetTopics.Code#'						 
				  <cfif url.code neq "">
				  AND    P.Code  = '#URL.code#'
				  AND    P.ServiceItem  = '#URL.ServiceItem#'
			  	  <cfelse>
				  AND    1=0
				  </cfif>			    
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
				FROM   Ref_ActionServiceItemTopic
				WHERE  Topic = '#Code#'		
				<cfif url.code neq "">
				  AND    Code  = '#URL.code#'
				  AND    ServiceItem  = '#URL.ServiceItem#'
			  	<cfelse>
				AND    1=0
				</cfif>  										 		  
    	   </cfquery>			
		 	   
	   	   <cfif ValueClass eq "List">
	   
			   <cfquery name="GetList" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT T.*, P.ListCode as Selected
					  FROM   Ref_TopicList T LEFT OUTER JOIN Ref_ActionServiceItemTopic P ON P.Topic = T.Code  
					               <cfif url.code neq "">
				  						AND    P.Code  = '#URL.code#'
										  AND    P.ServiceItem  = '#URL.ServiceItem#'
				   					<cfelse> 
										AND 1=0
									</cfif>		  
								   
					  WHERE  T.Code = '#Code#'		
					  AND    T.Operational = 1		
					  ORDER BY T.ListOrder
				</cfquery>
				
				 <cfquery name="Def" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT *
					  FROM   Ref_TopicList
					  WHERE  Code = '#GetTopics.Code#'		
					  AND    ListDefault = 1		
				</cfquery>		
								
				<cfif getValue.ListCode neq "">
					<cfset def = getValue.ListCode>
				<cfelse>				    
					<cfset def = def.ListCode>				
				</cfif>				
														   					   
			    <select name="Topic_#url.code#_#url.serviceItem#_#GetTopics.Code#" id="Topic_#url.code#_#url.serviceItem#_#GetTopics.Code#" class="regularxl">
				
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
			   					   
			    <select name="Topic_#url.code#_#url.serviceItem#_#GetTopics.Code#" id="Topic_#url.code#_#url.serviceItem#_#GetTopics.Code#" class="regularxl">
					<cfif ValueObligatory eq "0">
					<option value=""></option>
					</cfif>
					<cfloop query="GetList">
						<option value="#PK#" <cfif GetList.Display eq GetValue.TopicValue>selected</cfif>>#Display#</option>
					</cfloop>
				</select>						
				
			<cfelseif ValueClass eq "Text">
						
				<input type="Text"
			       name="Topic_#url.code#_#url.serviceItem#_#GetTopics.Code#"
                   id="Topic_#url.code#_#url.serviceItem#_#GetTopics.Code#"
			       required="#ValueObligatory#"					     
			       size="#valueLength#"
				   class="regularxl"
				   message="Please Enter a #GetTopics.Description#"
				   value="#GetValue.TopicValue#"
			       maxlength="#ValueLength#">
				   
			<cfelseif ValueClass eq "Date">			
			
				<cf_intelliCalendarDate9
					FieldName="Topic_#url.code#_#url.serviceItem#_#GetTopics.Code#" 
					Default="#dateformat(GetValue.TopicValue,CLIENT.DateFormatShow)#"
					AllowBlank="#ValueObligatory#"
					class="regularxl">	
								
			<cfelseif ValueClass eq "Boolean">
					
				<input type="Checkbox"
			       name="Topic_#url.code#_#url.serviceItem#_#GetTopics.Code#" 
                   id="Topic_#url.code#_#url.serviceItem#_#GetTopics.Code#"
				   <cfif GetValue.TopicValue eq "1">checked</cfif>
			       value="1">
			
			</cfif>
		
	   </cfif>	
	   
	   </td>
	   
  	</tr>	
		    
  </cfoutput>	
  
  <cfset ajaxOnload("doCalendar")>
  
 