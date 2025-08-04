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
<cfoutput>
	
<cfif url.save eq "1">
	
	<cfif URL.PublishNo eq "">
		<cfset list = "Ref_EntityClassAction">
	<cfelse>
	     <!--- correctedd
		<cfset list = "Ref_EntityActionPublish,Ref_EntityClassAction">
		--->
		<cfset list = "Ref_EntityActionPublish">
		
	</cfif>
	
		
	<cfloop index="tbl" list="#list#" delimiters=",">
		
		<cfquery name="Update" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE #tbl#
			SET    ActionGoTo      = '#Form.ActionGoTo#', 
			       ActionGoToLabel = '#Form.ActionGoToLabel#' 
			WHERE  ActionCode      = '#url.ActionCode#'
			<cfif tbl eq "Ref_EntityActionPublish">
			  AND  ActionPublishNo = '#URL.PublishNo#'
			<cfelse>
			  AND  EntityCode  = '#URL.EntityCode#' 
			  AND  EntityClass = '#URL.EntityClass#'  
			</cfif>
		</cfquery>	
		
	</cfloop>	

</cfif>

<cfif url.save eq "2">
	
	<cfif URL.PublishNo eq "">
		<cfset list = "Ref_EntityClassAction">
	<cfelse>
	    <!--- correctedd
		<cfset list = "Ref_EntityActionPublish,Ref_EntityClassAction">
		--->
		<cfset list = "Ref_EntityActionPublish">
	</cfif>
				
	<cfloop index="tbl" list="#list#" delimiters=",">	

		<cfif url.insert eq "true">	
		
			<cfquery name="Check" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * FROM #tbl#Process
				WHERE ActionCode = '#url.ActionCode#'
				 <cfif tbl eq "Ref_EntityActionPublish">
				   AND ActionPublishNo = '#URL.PublishNo#'
				 <cfelse>
				   AND EntityCode  = '#URL.EntityCode#' 
				   AND EntityClass = '#URL.EntityClass#'  
				 </cfif>
				   AND ProcessActionCode = '#URL.stepto#'
			    </cfquery>	
				
			<cfif check.recordcount eq "1">
			
				<cfquery name="Update" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE #tbl#Process
				SET    Operational = 1
				 WHERE ActionCode = '#url.ActionCode#'
				 <cfif tbl eq "Ref_EntityActionPublish">
				   AND ActionPublishNo = '#URL.PublishNo#'
				 <cfelse>
				   AND EntityCode  = '#URL.EntityCode#' 
				   AND EntityClass = '#URL.EntityClass#'  
				 </cfif>
				   AND ProcessActionCode = '#URL.stepto#'
			    </cfquery>
			
			<cfelse>		
		
				<cfif tbl eq "Ref_EntityActionPublish">
				
					<cfquery name="Insert" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO #tbl#Process
						(ActionPublishNo,ActionCode,ProcessClass,ProcessActionCode)
					VALUES
						('#URL.PublishNo#','#URL.ActionCode#','GoTo','#URL.stepto#')
					</cfquery>
					
				  <cfelse>
				  
				  	<cfquery name="Insert" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO #tbl#Process
						(EntityCode,EntityClass,ActionCode,ProcessClass,ProcessActionCode)
					VALUES
						('#URL.EntityCode#','#URL.EntityClass#','#URL.ActionCode#','GoTo','#URL.stepto#')
					</cfquery>			  
				  
				</cfif>
				
			</cfif>	
			
			<cfinclude template="ActionStepFlowCondition.cfm">
		
		<cfelse>
		
			<cfquery name="Update" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE #tbl#Process
			SET Operational = 0
			 WHERE ActionCode = '#url.ActionCode#'
			 <cfif tbl eq "Ref_EntityActionPublish">
			   AND ActionPublishNo = '#URL.PublishNo#'
			 <cfelse>
			   AND EntityCode  = '#URL.EntityCode#' 
			   AND EntityClass = '#URL.EntityClass#'  
			 </cfif>
			   AND ProcessActionCode = '#URL.stepto#'
		    </cfquery>
			
		</cfif>	
					
	</cfloop>	

</cfif>

<cfif url.save eq "3" or url.save eq "4">

	<cfif URL.PublishNo eq "">
		<cfset list = "Ref_EntityClassAction">
	<cfelse>
		<cfset list = "Ref_EntityActionPublish,Ref_EntityClassAction">
	</cfif>
		
	<cfloop index="tbl" list="#list#" delimiters=",">
		
		<cfquery name="Update" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE #tbl#Process
			SET    ConditionShow       = '#Form.ConditionShow#',
			       ConditionField      = '#Form.ConditionField#',
				   ConditionValue      = '#Form.ConditionValue#',
				   ConditionDataSource = '#Form.ConditionDataSource#',
				   ConditionScript     = '#Form.ConditionScript#',
				   ConditionMessage    = '#Form.ConditionMessage#', 
				   ConditionMemo       = '#Form.ConditionMemo#',
				   MailCode            = '#Form.MailCode#'
			WHERE  ActionCode          = '#url.ActionCode#'
			<cfif tbl eq "Ref_EntityActionPublish">
			  AND ActionPublishNo = '#URL.PublishNo#'
			<cfelse>
			  AND EntityCode  = '#URL.EntityCode#' 
			  AND EntityClass = '#URL.EntityClass#'  
			</cfif>
			 AND ProcessActionCode = '#URL.stepto#'
		</cfquery>	
		
	</cfloop>
	
	<cfif url.save eq "3">
	
		<table>
			<tr>
				<td align="center"><font color="008000"><b>Condition was saved</b></font></td>
			</tr>
		</table>
	
	<cfelse>

	 <table width="96%"      
	   class="formpadding"
       align="center"
       bgcolor="FFFFFF">
	 
	   <cfparam name="Form.ActionStatus" default="0">
	 	
		<cfloop index="tbl" list="#list#" delimiters=",">
		
			<cfquery name="Get" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * FROM #tbl#Process
				WHERE ActionCode = '#url.ActionCode#'
				<cfif tbl eq "Ref_EntityActionPublish">
				   AND ActionPublishNo = '#URL.PublishNo#'
				<cfelse>
				   AND EntityCode  = '#URL.EntityCode#' 
				   AND EntityClass = '#URL.EntityClass#'  
				</cfif>
				 AND ProcessActionCode = '#URL.stepto#'
			</cfquery>
		
			<cfif Get.recordcount gt 0>
				<cfbreak>
			</cfif>
		
		</cfloop>
		
		 <cfset key1   = "0">
		 <cfset key2   = "0">
		 <cfset key3   = "0">
		 <cfset key4   = "{00000000-0000-0000-0000-000000000000}">
		 <cfset action = "{00000000-0000-0000-0000-000000000000}">
		 <cfset object = "{00000000-0000-0000-0000-000000000000}">
	 
	 	<cfset s = 0>

		<!--- Loop through script table fields that were updated above --->
	    <cfloop index="script" list="ConditionScript" delimiters=",">

		 <cfparam name="Get.#script#" default="">
		 
		 <cfset val = Get[script]>

		 <cfset val = replaceNoCase("#val#", "@key1",   "#key1#" , "ALL")>
		 <cfset val = replaceNoCase("#val#", "@key2",   "#key2#" , "ALL")>
		 <cfset val = replaceNoCase("#val#", "@key3",   "#key3#" , "ALL")>
		 <cfset val = replaceNoCase("#val#", "@key4",   "#key4#" , "ALL")>
		 <cfset val = replaceNoCase("#val#", "@action", "#action#" , "ALL")>
		 <cfset val = replaceNoCase("#val#", "@acc",    "#SESSION.acc#" , "ALL")>
		 <cfset val = replaceNoCase("#val#", "@last",   "#SESSION.last#" , "ALL")>
		 <cfset val = replaceNoCase("#val#", "@first",  "#SESSION.first#" , "ALL")>

		  <!--- runtime conversion of custom object fields --->
					
				<cfquery name="Fields" 
					 datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">	 
				     SELECT    R.EntityCode, R.DocumentCode, R.DocumentDescription, R.FieldType, I.DocumentItem, I.DocumentItemValue, R.DocumentId
				        FROM      Ref_EntityDocument AS R LEFT OUTER JOIN
				                  OrganizationObjectInformation AS I ON R.DocumentId = I.DocumentId AND I.Objectid = '#Object#'
				        WHERE     (R.EntityCode = '#URL.EntityCode#') 
					 AND       (R.DocumentType = 'field')
				</cfquery>	       
				
				<cfloop query="fields">
				
				    <cfif fieldtype eq "date">
					
						<cfset val = replaceNoCase("#val#", "@#documentcode#","01/01/1900", "ALL")>
					    	
					<cfelse>
					
					   	<cfset val = replaceNoCase("#val#", "@#documentcode#","customvalue", "ALL")>
					
					</cfif>
					    		
				</cfloop>
		  
		 <cfif val neq "">
		 
		 	<cfset s = 1>
		 	
			<tr><td height="5"></td></tr>					 
		     <tr><td height="22" bgcolor="silver"><font face="Verdana" size="3"><b>#script#</font></td></tr> 
			  <tr><td>#ParagraphFormat(val)#</td></tr>
			  
			    <cftry>
							
			 									 				
				<cfquery name="SQL" 
				 datasource="#Get.ConditionDataSource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">	  	
				    <cfoutput>
					#preserveSingleQuotes(val)# 
					</cfoutput>
				 </cfquery>				 
					 <tr><td bgcolor="EAFAAB" align="center">Good, your #script# syntax is correct!</b></td></tr>				
					 					 							 
				 <cfcatch>
				 	<tr><td align="center" bgcolor="FF8080">Problem, your #script# syntax is NOT correct!</td></tr>
					<tr><td align="center" bgcolor="ffffcf">#CFCatch.Message# - #CFCATCH.Detail#</td></tr>
				 </cfcatch>				 
		 	   		 
				</cftry> 
				
				<cftry>	
					  				  
				  <cfset field = evaluate("SQL.#get.ConditionField#")>						  
						 						  
					  <cfcatch>
					   	<tr><td align="center" bgcolor="FF8080">Your condition field #Get.ConditionField# is NOT valid!</b></td></tr>				
					  </cfcatch>					 	
					  
			  </cftry>		
				 						 
		 </cfif>		 
 	 
	 </cfloop>	
	 
	 <cfif s eq "0">
	 
	 		 <tr><td height="5"></td></tr>
	 		 <tr><td bgcolor="d3d3d3" align="center">&nbsp;<b>No scripts were found.</b></td></tr>				
	 
	 </cfif>
	
	 </table>

	</cfif>

</cfif>

</cfoutput>
