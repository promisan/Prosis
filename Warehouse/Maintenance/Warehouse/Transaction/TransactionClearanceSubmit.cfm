
<cfquery name="types" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM   	Ref_TransactionType
	WHERE   TransactionType NOT IN ('1','7')
</cfquery>

<cftransaction>

	<cfquery name="clear" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   	DELETE
		FROM   	WarehouseTransaction
		WHERE	Warehouse = '#url.warehouse#'		
	</cfquery>
	
	<cfloop query="types">
	
		<cfparam name="Form.EntityClass_#TransactionType#" default="">
		<cfparam name="Form.Operational_#TransactionType#" default="0">
		<cfset entcls = evaluate("Form.EntityClass_#TransactionType#")>
	
		<cfif isDefined('form.TransactionType_#TransactionType#')>
			
			<cfquery name="insert" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO WarehouseTransaction (
							Warehouse,							
							TransactionType,
							ClearanceMode,		
							PreparationMode,				
							EntityClass,						
							Operational,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )
					VALUES (
						'#url.warehouse#',						
						'#Evaluate("Form.TransactionType_#TransactionType#")#',
						'#Evaluate("Form.ClearanceMode_#TransactionType#")#',
						'#Evaluate("Form.PreparationMode_#TransactionType#")#',
						<cfif (evaluate("Form.ClearanceMode_#TransactionType#") eq "3" or evaluate("Form.ClearanceMode_#TransactionType#") eq "2") and entcls neq "">
						'#entcls#',
						<cfelse>						
						'',
						</cfif>
						#Evaluate("Form.Operational_#TransactionType#")#,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
			</cfquery>
		
		</cfif>
	
	</cfloop>

</cftransaction>

<cfinclude template="TransactionClearance.cfm">