
<!--- utility that copies over to a new contract --->

<cfparam name="Attributes.From" default="{00000000-0000-0000-0000-000000000000}">
<cfparam name="Attributes.To" default="{00000000-0000-0000-0000-000000000001}">

<!--- tasks --->

<cfquery name="Task" 
 datasource="AppsEPAS" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	DELETE FROM ContractActivity
	WHERE    ContractId = '#Attributes.to#'
</cfquery>

<cfset flds = "ActivityId,
			     ActivityOrder, 
				 ActivityDescription, 
				 ActivityCompletionDate, 
				 ActivityIdParent, 
				 PriorityCode, 
				 RecordStatus, 
				 Reference, 
				 OfficerUserId, 
				 OfficerLastName, 
			     OfficerFirstName">

<cfquery name="Task" 
 datasource="AppsEPAS" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	INSERT INTO ContractActivity
	(ContractId, #flds#)
	SELECT   '#Attributes.To#', 
	         #flds#
	FROM     ContractActivity
	WHERE    ContractId = '#Attributes.from#'
</cfquery>

<!--- taskoutput --->

<cfset flds = "ActivityId, 
			   OutputClass, 
			   OutputDescription, 
			   RecordStatus, 
			   OfficerUserId, 
			   OfficerLastName, 
			   OfficerFirstName">

<cfquery name="Output" 
 datasource="AppsEPAS" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	INSERT INTO ContractActivityOutput
	(ContractId, #flds#)
	SELECT   '#Attributes.To#', 
	         #flds#
	FROM     ContractActivityOutput
	WHERE    ContractId = '#Attributes.from#'
</cfquery>

<!--- behavior --->

<cfquery name="Task" 
 datasource="AppsEPAS" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	DELETE FROM ContractBehavior
	WHERE    ContractId = '#Attributes.to#'
</cfquery>

<cfset flds = "BehaviorCode, 
               BehaviorDescription, 
			   PriorityCode, 
			   OfficerUserId, 
			   OfficerLastName, 
			   OfficerFirstName">

<cfquery name="Output" 
 datasource="AppsEPAS" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	INSERT INTO ContractBehavior
	(ContractId, #flds#)
	SELECT    '#Attributes.To#', #flds#
	FROM      ContractBehavior
	WHERE     ContractId = '#Attributes.from#'
</cfquery>

<cfquery name="Update" 
 datasource="AppsEPAS" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	UPDATE ContractSection
	SET    ProcessStatus    = 1, 
	       ProcessDate      = getDate(),
	       OfficerUserId    = '#SESSION.acc#',
		   OfficerLastName  = '#SESSION.last#',
		   OfficerFirstName = '#SESSION.first#'
	WHERE  Contractid       = '#Attributes.To#'
	AND    ProcessStatus    = '0'
    AND    ContractSection IN ('P01','P02','P03','P04') 
</cfquery>