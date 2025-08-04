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


<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<!--- verify if record exist --->

<cfquery name="Entitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   PersonMiscellaneous
WHERE    PersonNo   = '#Object.ObjectKeyvalue1#'
AND      CostId     = '#Object.ObjectKeyvalue4#'
</cfquery>

<cfif Entitlement.recordCount eq 1> 
			
	  <cfquery name="EditEntitlement" 
		   datasource="AppsPayroll" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   UPDATE  PersonMiscellaneous
		   SET     DateEffective = #STR#,					  
				   Currency      = '#Form.Currency#',
				   Amount        = '#Form.Amount#'
		   WHERE   PersonNo      = '#Object.ObjectKeyvalue1#'
		   AND     CostId        = '#Object.ObjectKeyvalue4#'
	  </cfquery>
		  
	  <cfquery name="Justification" 
		   datasource="AppsPayroll" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		    SELECT  *
		    FROM    PersonMiscellaneousAction 
			WHERE   PersonNo   = '#Object.ObjectKeyValue1#'
			AND     CostId     = '#Object.ObjectKeyValue4#'
			AND     ActionCode = 'Justification'
	  </cfquery>
	
	  <cfif Justification.recordcount eq "1">
	
		<cfquery name="EditJustification" 
		   datasource="AppsPayroll" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   UPDATE  PersonMiscellaneousAction
			   SET     ActionContent = '#Form.ActionContent#'
			   WHERE   PersonNo      = '#Object.ObjectKeyvalue1#'
			   AND     CostId        = '#Object.ObjectKeyvalue4#'
			   AND     ActionCode    = 'Justification'
		   </cfquery>
	
	  <cfelse>
	
		<cfquery name="InsertJustification" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  INSERT INTO PersonMiscellaneousAction
				         (PersonNo,
						  CostId,
						  ActionCode,
						  ActionContent, 
						  OfficerUserId, 
						  OfficerLastName, 
						  OfficerFirstName)				
			  VALUES ('#Object.ObjectKeyvalue1#',
			          '#Object.ObjectKeyvalue4#',
					  'Justification',
					  '#Form.ActionContent#',
			          '#session.acc#',
					  '#session.last#',
					  '#session.first#')
	     </cfquery>		
	
	  </cfif>
	  
 </cfif>
	
	


