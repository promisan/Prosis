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
<cfquery name="RevertNew" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE PersonAssignment 
SET    AssignmentStatus = '8'
WHERE  AssignmentNo IN 
          (SELECT ActionSourceNo 
           FROM   EmployeeActionSource 
           WHERE  ActionDocumentNo IN (SELECT ActionDocumentNo 
                                       FROM   EmployeeAction 
                                       WHERE  ActionSourceNo = '#url.assigmentNo#'
                                       AND    ActionSource = 'Assignment')
	       AND    ActionSource = 'Assignment'
           AND  ActionStatus = '0')
</cfquery>		  

<cfquery name="RevertOld" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE PersonAssignment 
SET    AssignmentStatus = '1'
WHERE  AssignmentNo IN 
          (SELECT ActionSourceNo 
           FROM   EmployeeActionSource 
           WHERE  ActionDocumentNo IN (SELECT ActionDocumentNo 
                                       FROM   EmployeeAction 
                                       WHERE  ActionSourceNo = '#url.assigmentNo#'
                                       AND    ActionSource = 'Assignment')
	  AND    ActionSource = 'Assignment' 
          AND    ActionStatus = '9' )
</cfquery>

<cfquery name="RevertOld" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
     DELETE EmployeeAction 
     WHERE  ActionSourceNo = '#url.assigmentNo#' 
	 AND    ActionSource = 'Assignment'
</cfquery>

<script>
	window.close()
	parent.opener.history.go();
</script>