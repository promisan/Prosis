
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
 
	
