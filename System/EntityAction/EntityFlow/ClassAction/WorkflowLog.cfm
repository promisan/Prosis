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