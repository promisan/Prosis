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
<cfquery name="GetLastNumber" 
     datasource="AppsPayroll" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT * FROM Parameter
	 </cfquery>
	 
	 <cfset Caller.NoAct = GetLastNumber.ActionNo + 1>
	 
	 <cfquery name="GetLastNumber" 
     datasource="AppsPayroll" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 UPDATE Parameter
	 SET ActionNo = #Caller.NoAct#
	 </cfquery>
	 
	  <cfquery name="InsertActivity" 
     datasource="AppsPayroll" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO EntitlementAction
         (ActionDocumentNo,
		 ActionCode,
		 ActionPersonNo,
		 ActionSource,
		 ActionDescription,
		 Mission,
		 MandateNo,
		 PostType,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,
		 ActionDate)
      VALUES (
          #Caller.NoAct#,
		  '',
		  '#Attributes.Person#',
		  '#Attributes.Action#',
		  '',
		  '',
		  '',
		  '',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  '#DateFormat(Now(),CLIENT.dateSQL)#')
	 </cfquery>
	 