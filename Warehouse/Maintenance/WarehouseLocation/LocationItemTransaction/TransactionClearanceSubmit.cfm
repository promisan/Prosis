
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
	   	DELETE	FROM   	ItemWarehouseLocationTransaction
		WHERE	Warehouse = '#url.warehouse#'
		AND		Location = '#url.location#'
		AND		ItemNo = '#url.itemno#'
		AND		UoM = '#url.uom#'		
	</cfquery>
	
	<cfloop query="types">
	
		<cfparam name="Form.EntityClass_#TransactionType#" default="">
		<cfset entcls = evaluate("Form.EntityClass_#TransactionType#")>
		<cfset mail   = evaluate("Form.Notification_#TransactionType#")>
		
		<cfif isDefined('form.TransactionType_#TransactionType#')>
					
			<cfquery name="insert" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			    INSERT INTO ItemWarehouseLocationTransaction (
							Warehouse,
							Location,
							ItemNo,
							UoM,
							TransactionType,							
							Source,			
							Notification,	
							ClearanceMode,		
							EntityClass,						
							Operational,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )
					VALUES (
						'#url.warehouse#',
						'#url.location#',
						'#url.itemno#',
						'#url.uom#',
						'#Evaluate("Form.TransactionType_#TransactionType#")#', 
						'#Evaluate("Form.Source_#TransactionType#")#',
						'#mail#',
						'#Evaluate("Form.ClearanceMode_#TransactionType#")#',
						<cfif (evaluate("Form.ClearanceMode_#TransactionType#") eq "3"  or  evaluate("Form.TransactionType_#TransactionType#") eq "2") and entcls neq "">
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