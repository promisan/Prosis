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
<cfquery name="Get" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	Ref_Action
		WHERE   Code = '#URL.code#'		
</cfquery>	 	


<cfquery name="ServiceItem" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT 	O.*
	    FROM  ServiceItem O
		WHERE Code IN (
				SELECT 	ServiceItem 
               	FROM 	ServiceItemMission 
			   	WHERE 	<cfif get.Mission eq "">
						Mission             = NULL
						<cfelse>
						Mission             = '#get.mission#'
					    </cfif> 
			   	AND    	Operational = 1
			)
		AND   Operational = 1
</cfquery>

<cfset select = "">

<cfloop query="ServiceItem">
	
	<cfif isDefined("Form.TopicClass_#Code#")>
	
	    <cfparam name="Form.entityClass_#code#" default="">
	
		<cfset vEntityClass = evaluate("Form.entityClass_#code#")>
	
	    <cfif select eq "">
			<cfset select = "'#Code#'">
		<cfelse>
			<cfset select = "#select#,'#Code#'">
	    </cfif>
					
		<cftry>
				
		<cfquery name="Insert" 
		    datasource="AppsWorkOrder" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    INSERT INTO Ref_ActionServiceItem
						(Code,
						ServiceItem,
						<cfif vEntityClass neq "">EntityClass,</cfif>
						OfficerUserId,
					 	OfficerLastName,
					 	OfficerFirstName)
			VALUES 		('#get.Code#',
						'#Code#',
						<cfif vEntityClass neq "">'#vEntityClass#',</cfif>
						'#SESSION.acc#',
				    	'#SESSION.last#',		  
				  	    '#SESSION.first#'
						) 
		</cfquery>		
		
		<cfcatch>
				
		</cfcatch>
		
		</cftry>
		
		<cfset url.customMission     = get.Mission>
		<cfset url.customServiceItem = Code>
		<cfset url.customCode        = get.Code>
		
		<cfinclude template="ActionCustomSubmit.cfm">
	
	</cfif>

</cfloop>


<cfquery name="Clear" 
    datasource="appsWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    DELETE FROM Ref_ActionServiceItemNotification
	WHERE  Action = '#get.Code#'  
	<cfif select neq "">
	AND    ServiceItem NOT IN (#preservesingleQuotes(select)#)	
	</cfif>
</cfquery>


<cfquery name="Clear" 
    datasource="appsWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    DELETE FROM Ref_ActionServiceItem
	WHERE  Code = '#get.Code#'  
	<cfif select neq "">
	AND    ServiceItem NOT IN (#preservesingleQuotes(select)#)	
	</cfif>
</cfquery>