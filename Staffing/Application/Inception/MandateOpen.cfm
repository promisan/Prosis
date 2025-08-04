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

<cfquery name="EditMandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE  Ref_Mandate
	  SET   MandateStatus = 0, 
	        MandateStatusDate = getDate(), 
			MandateStatusOfficer = '#SESSION.acc#'
	  WHERE Mission = '#url.Mission#'
      AND   MandateNo = '#url.mandateNo#'
</cfquery>

<cfquery name="LogMandateAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_MandateAction
	(Mission, MandateNo, MandateStatus, ActionSource, ActionDate, OfficerUserId, OfficerLastName, OfficerFirstName)
	VALUES
	('#url.Mission#','#url.mandateNo#','0','MANUAL',getdate(),'#SESSION.acc#','#SESSION.last#','#SESSION.first#')	
</cfquery>


<!--- also remove all the employee actions for this mandate --->

<cfquery name="ClearMandateActions" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM EmployeeAction
	WHERE ActionSource = 'Assignment'
	AND   ActionSourceNo IN (SELECT AssignmentNo 
	                         FROM   PersonAssignment
							 WHERE  PositionNo IN (SELECT PositionNo 
							                       FROM   Position 
												   WHERE  Mission = '#url.Mission#'
												    AND   MandateNo = '#url.mandateNo#')
							)					   
</cfquery>

<table cellspacing="0" cellpadding="0" class="formpadding">	
 <tr><td><font color="blue"><b>Draft</font></b>&nbsp;You may review, process and relock this mandate</td></tr>
 <tr><td>
 	 <input class="button10g" type="button" name="process" value="Process" onClick="mandate()">&nbsp;
 </td></tr>
 </table>