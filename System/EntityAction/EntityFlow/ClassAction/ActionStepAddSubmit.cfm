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
<cfparam name="Form.Selected" default="''">
		
<cfquery name="Insert" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_EntityClassAction
		(EntityCode, EntityClass, ActionCode, ActionDescription, ActionType, OfficerUserid,
		OfficerLastName, OfficerFirstName, Created)
SELECT 	'#URL.EntityCode#',
        '#URL.EntityClass#', 
		ActionCode, 
		ActionDescription, 
		ActionType,
		'#SESSION.acc#', 
		'#SESSION.last#', 
		'#SESSION.first#', 
		getDate()
FROM    Ref_EntityAction
WHERE   ActionCode IN (#preserveSingleQuotes(Form.Selected)#)
</cfquery>

<script language="JavaScript">
   // parent.parent.ColdFusion.Window.destroy('mystep',true)
   parent.parent.Prosis.busy('yes')
   parent.parent.right.history.go()
   //   parent.window.returnValue="1"
  </script> 
  
  <cfinclude template="ActionStepAdd.cfm"> 
 
	
