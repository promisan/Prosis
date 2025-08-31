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
<cfparam name="url.EntityCode"  default="">
<cfparam name="url.EntityClass" default="">

<cfoutput>

<cfquery name="RemoveLog" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_EntityClassActionLog
	WHERE EntityCode = '#URL.EntityCode#' 
	AND EntityClass = '#URL.EntityClass#'
	</cfquery>

<cfquery name="InsertLog" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_EntityClassActionLog
	(EntityCode, EntityClass, ActionCode, ActionParent, ActionGoToYes, ActionGoToNO)
	Select EntityCode, EntityClass, ActionCode, ActionParent, ActionGoToYes, ActionGoToNO
		FROM Ref_EntityClassAction
		WHERE EntityCode = '#URL.EntityCode#' 
		AND EntityClass = '#URL.EntityClass#'
	</cfquery>
	
<cfquery name="CheckLog" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * FROM Ref_EntityClassActionLog
	  	WHERE  EntityCode   = '#url.entityCode#' 
	    AND    EntityClass  = '#url.entityClass#' 
	</cfquery>	

<cf_UIToolTip tooltip="Last Log: #CheckLog.Created#">
<cfif CheckLog.RecordCount neq "0">
<input type="button" name="Restore" id="RestoreButton" value="Restore" class="button10g" onClick="javascript:restore()">&nbsp; 
</cfif>
</cf_UIToolTip>
	
</cfoutput>		

</body>