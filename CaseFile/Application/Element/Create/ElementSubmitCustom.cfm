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

<cfif element.recordcount eq "1">
		
	<cfquery name="getTopics" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT   R.*
		     FROM     Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
			 WHERE    ElementClass = '#element.elementclass#'	
			 AND      Operational = 1
			 AND      (Mission = '#case.Mission#' or Mission is NULL)	
			 ORDER BY S.ListingOrder,R.ListingOrder
	</cfquery>

<cfelse>
	
	<cfquery name="getTopics" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT   R.*
		     FROM     Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
			 WHERE    ElementClass = '#url.elementclass#'	
			 AND      Operational = 1
			 AND      (Mission = '#case.Mission#' or Mission is NULL)	
			 ORDER BY S.ListingOrder,R.ListingOrder
	</cfquery>

</cfif>

<!--- ----saving the topic values------- --->
<!--- 11/1/2011 can be made more generic --->
<!--- ---------------------------------- --->

<cfset alias   = "AppsCaseFile">
<cfset table   = "ElementTopic">
<cfset tField1 = "ElementId">
<cfset tField2 = "ElementLineNo">

<cfset PERSON_UPDATE = 0>

<cfloop query="getTopics">

	<cfif TopicClass eq 'Person'>

			<cfif NOT PERSON_UPDATE>
				<cfset PERSON_UPDATE = 1>
				<cfinclude template = "ElementSubmitPerson.cfm">
			</cfif>		
	
	<cfelse>
	
	 <cfquery name="DeactivateValues" 
		datasource="#alias#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 UPDATE  #table#
		 SET     Operational   = 0
		 WHERE   #tfield1#     = '#elementid#'		  
		 AND     #tfield2#     = '0'
		 AND     Topic         = '#Code#'			
     </cfquery>
			
	 <cfif ValueClass eq "List">

		<cfset value  = Evaluate("FORM.Topic_#Code#")>
		
		 <cfquery name="GetList" 
			datasource="#alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT *
			  FROM   Ref_TopicList
			  WHERE  Code     = '#Code#'
			  AND    ListCode = '#value#'	
		  
		</cfquery>		
					
		<cfif value neq "">
		
			<cfquery name="SelectCurrentValue" 
			  datasource="#alias#" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT   TOP 1 * 
			  FROM     #table#
			  WHERE    #tfield1#     = '#elementid#'		  
			  AND      #tfield2#     = '0'
			  AND      Topic         = '#Code#'			 
		    </cfquery>		
		
	        <!--- check if new value = last value --->
			
			<cfif getList.ListValue eq SelectCurrentValue.TopicValue
			  and getList.ListCode eq SelectCurrentValue.ListCode>
									
			     <!--- just reactivate no changes --->
				 
				<cfquery name="CheckLast" 
				  datasource="#alias#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">						  	
				  UPDATE   #table#
				  SET      Operational  = 1
				  WHERE    #tfield1#   = '#elementid#'		  
				  AND      #tfield2#   = '0'
				  AND      Topic        = '#Code#'				 
			   </cfquery>		
		 
			<cfelse>			
			    
				<cfquery name="LogOldRecord" 
				  datasource="#alias#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">		
				  INSERT INTO #table#Log
					  (	#tfield1#,
						#tfield2#,
						Topic,
						ExpirationDate,
					    ListCode,
					    TopicValue,
						ToListCode,
						ToTopicValue,	
						ActionId,					
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName)						
				  SELECT  #tfield1#,
						  #tfield2#,
						  Topic,
						  getdate(),
					      ListCode,
					      TopicValue,
						  '#value#',
						  '#getList.ListValue#',
						  '#url.actionid#',
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName
				  FROM    #table#
				  WHERE   #tfield1#   = '#elementid#'		  
			      AND     #tfield2#   = '0'
				  AND     Topic        = '#Code#'					 
				</cfquery>  
									  		
				<cfquery name="CleanCurrent" 
				  datasource="#alias#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">							 
				  DELETE  FROM  #table#
				  WHERE    #tfield1#   = '#elementid#'		  
			      AND      #tfield2#   = '0'
				  AND     Topic        = '#Code#'				  
			    </cfquery>
						
				<cfquery name="InsertTopics" 
				  datasource="#alias#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO  #table#
				 		 (#tfield1#,
						  #tfield2#,
						  Topic,						
						  ListCode,
						  TopicValue,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				  VALUES ('#elementid#',
				          '0',
				          '#Code#',						 
						  '#value#',
						  '#getList.ListValue#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#') 
				</cfquery>
				
			</cfif>	
		
		</cfif>
		
		<cfelse>
	
		<cfquery name="SelectCurrentValue" 
			  datasource="#alias#" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT   TOP 1 * 
			  FROM     #table#
			  WHERE    #tfield1#     = '#elementid#'		  
			  AND      #tfield2#     = '0'
			  AND      Topic         = '#Code#'
			  <!--- ORDER BY DateEffective DESC --->
		    </cfquery>		
		
		<cfif ValueClass eq "Boolean">	
								
			<cfparam name="FORM.Topic_#Code#" default="0">						
			
		</cfif>
		
		<cfif ValueClass eq "Lookup">	
		
			<cfif isDefined("Form.Topic_#Code#")>  
			    
			 <cfset lcode  = Evaluate("FORM.Topic_#Code#")>
			 
			  <cfquery name="GetLookup" 
			  datasource="#ListDataSource#" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			     SELECT  DISTINCT 
			             #ListPK# as PK, 
			             #ListDisplay# as Display
			     FROM    #ListTable#
			     WHERE   #ListPK# = '#lcode#'  
			     <cfif ListCondition neq "">
			     AND     #preservesinglequotes(ListCondition)#
			     </cfif>                
			  </cfquery>			
			      
			 <cfset value = getLookup.Display>  
			 
			<cfelse>
			
			 <cfset value = "">
			 
			</cfif>
						
		<cfelseif ValueClass eq "Date">			
		
		    <cfset dateValue = "">
		    <CF_DateConvert Value="#evaluate('FORM.Topic_#Code#')#">
		    <cfset DTE = dateValue>
					
		    <cfset lcode  = "">
			<cfset value  = "#dateformat(dte,client.dateSQL)#">
			
			<cfif left(value,10) eq "01/01/1900">
			   <cfset value = "">
			</cfif> 
		
			
		<cfelseif ValueClass eq "DateTime">		
		
			<cfset dateValue = "">
		    <CF_DateConvert Value="#evaluate('FORM.Topic_#Code#')#">
		    <cfset DTE = dateValue>
		
		    <cfset lcode  = "">
			<cfset value  = "#dateformat(dte,client.dateSQL)# #evaluate('FORM.Topic_#Code#_hour')#:#evaluate('FORM.Topic_#Code#_minute')#:00">
			
			<cfif left(value,10) eq "01/01/1900">
				   <cfset value = "">
			</cfif> 
		
		<cfelseif ValueClass eq "Time">		
		
		    <cfset lcode  = "">
					
			<cfif evaluate('FORM.Topic_#Code#_hour') neq "" and evaluate('FORM.Topic_#Code#_minute') neq "">
				<cfset value  = "#evaluate('FORM.Topic_#Code#_hour')#:#evaluate('FORM.Topic_#Code#_minute')#">
			<cfelse>
				<cfset value = "">
			</cfif>
		
		<cfelse>
		
		    <cfset lcode  = "">
			<cfset value  = Evaluate("FORM.Topic_#Code#")>

		</cfif>			
		
		<cfif value neq "">
		
			<cfif value eq SelectCurrentValue.TopicValue 
			  and (lcode eq SelectCurrentValue.ListCode or SelectCurrentValue.ListCode is "")>
			
			     <!--- reactivate --->
				 
				<cfquery name="UpdateLast" 
				  datasource="#alias#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  UPDATE  #table#
				  SET     Operational = 1
				  WHERE   #tfield1#     = '#elementid#'		  
			      AND     #tfield2#     = '0'
				  AND     Topic         = '#Code#'
				</cfquery>		
		 
			<cfelse>
			
				<cfquery name="LogOldRecord" 
				  datasource="#alias#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">		
				  INSERT INTO #table#Log
					  (	#tfield1#,
						#tfield2#,
						Topic,
						ExpirationDate,
						<cfif lcode neq "">
					    ListCode,
						</cfif>
					    TopicValue,
						ToTopicValue,
						ActionId,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName)						
				  SELECT  #tfield1#,
						  #tfield2#,
						  Topic,
						  getdate(),
						  <cfif lcode neq "">
					      ListCode,
						  </cfif>
					      TopicValue,
						  '#value#',
						  '#url.actionid#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#'
				  FROM    #table#
				  WHERE   #tfield1#   = '#elementid#'		  
			      AND     #tfield2#   = '0'
				  AND     Topic        = '#Code#'	 				 
				</cfquery>  
		
				<cfquery name="CleanSameDateValues" 
				  datasource="#alias#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  DELETE FROM #table#
				  WHERE    #tfield1#     = '#elementid#'		  
			      AND      #tfield2#     = '0'
				  AND      Topic         = '#Code#'				    
			    </cfquery>
			
				<cfquery name="InsertTopics" 
				  datasource="#alias#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO #table#
				 			 (#tField1#,
							  #tField2#, 
							  Topic, 
							  <cfif lcode neq "">
							  ListCode,
							  </cfif>							 
							  TopicValue,
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
				  VALUES 	 ('#elementid#',
				              '0',
							  '#Code#',
							  <cfif lcode neq "">
							  '#lcode#',
							  </cfif>							 
							  '#value#',
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
				</cfquery>	
				
			</cfif>	
		
		</cfif>
		
	</cfif>	
	
	 <cfquery name="DeactivateValues" 
		datasource="#alias#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 DELETE FROM #table#		 
		 WHERE   #tfield1#     = '#elementid#'		  
		 AND     #tfield2#     = '0'
		 AND     Topic         = '#Code#'			
		 AND     Operational   = 0
     </cfquery>
	</cfif>	 

</cfloop>
