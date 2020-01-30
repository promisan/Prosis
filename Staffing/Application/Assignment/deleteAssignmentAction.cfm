
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