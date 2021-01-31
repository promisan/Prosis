<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Stock requests">
	
	<cffunction name="DenyBatch" access="public" displayname="Clear a batch">
					
			<cfargument name = "BatchNo" type="string"  required="true"   default="">	
			<cfargument name="DataSource"      type="string"  required="true" default="appsOrganization">					
			
			<cfquery name="get"
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * FROM Materials.dbo.WarehouseBatch				
				WHERE  BatchNo = '#BatchNo#'
			</cfquery>
						
			<cfquery name="Reset"
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Materials.dbo.Request
				SET    Status = '2'
				WHERE  RequestId IN (SELECT RequestId 
				                     FROM   Materials.dbo.ItemTransaction 
									 WHERE  TransactionBatchNo = '#BatchNo#')
			</cfquery>
			
			<cfquery name="List"
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TransactionId, RequestId
				FROM   Materials.dbo.ItemTransaction
				WHERE  TransactionBatchNo = '#BatchNo#'
				ORDER BY ParentTransactionId DESC
			</cfquery>
			
			<cfloop query="List">	
			
			    <!--- remove any observations driven by this transaction --->
				
				<cfquery name="Delete"
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
					
					DELETE FROM Materials.dbo.AssetItemAction
					WHERE  TransactionId = '#TransactionId#'
					
				</cfquery>
				
				<cfquery name="Delete"
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
					
					DELETE FROM Materials.dbo.AssetItemEvent
					WHERE  TransactionId = '#TransactionId#'
					
				</cfquery>
				
				<!--- we need to make this a component as well --->
				
				<cf_StockTransactDelete alias="#datasource#" transactionId="#TransactionId#">		
				
				<cfif RequestId neq "">
					<cf_setRequestStatus Datasource ="#datasource#" RequestId="#Requestid#">
				</cfif>	
				
			</cfloop>
			
			<!--- we remove the sale if this transaction moved into a sale already --->
			
			<cfif get.BatchClass eq "WhsSale">
			
				<!--- we close the API step as defined in the workflow if it is the next step only --->
				
				<cfquery name="getHeader"
				 datasource="#datasource#" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">			  
					  SELECT    *	
					  FROM      Accounting.dbo.TransactionHeader
					  WHERE     TransactionSourceId = '#get.BatchId#' 
					  AND       TransactionCategory = 'Receivables'
					  AND       RecordStatus = '1'					  
			    </cfquery>					
						
				<cfif getHeader.recordcount eq "1">
				
					<cfquery name="getObject"
					 datasource="#datasource#" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">			  
						  SELECT    *	
						  FROM      Organization.dbo.OrganizationObject
						  WHERE     ObjectKeyValue4 = '#getHeader.TransactionId#' 
						  AND       Operational  = '1'
				    </cfquery>
					
					<cfif getObject.ObjectId neq "">
										
						<!--- we check if an external process needs to be done here on the workflow of the sale --->
					
						<cfinvoke component = "Service.Process.System.Workflow"  
							   method           = "ProcessStep" 
							   datasource       = "#datasource#"
							   Action           = "external"
							   ActionDecision   = "deny"							  
							   ObjectId         = "#getObject.ObjectId#"
							   batchId          = "#get.BatchId#">			
						   
					</cfif>	  
				
				</cfif> 				
				
				<!--- reset a receivable object --->	
			
				<cfquery name="getHeader"
				 datasource="#datasource#" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">			  
					  UPDATE    Accounting.dbo.TransactionHeader
					  SET       ActionStatus        = '9',
					            RecordStatus        = '9', 
								RecordStatusDate    = getDate(), 
								RecordStatusOfficer = '#SESSION.acc#'
					  WHERE     TransactionSourceId = '#get.BatchId#' 
					  AND       TransactionCategory = 'Receivables'					  
			    </cfquery>
				
			<cfelse>			
			
				<cfquery name="Sale"
					datasource="#datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
						
					UPDATE Accounting.dbo.TransactionHeader
					SET    RecordStatus        = '9',  
						   RecordStatusDate    = getDate(), 
						   RecordStatusOfficer = '#SESSION.acc#',
					       ActionStatus        = '9'
					WHERE  TransactionSourceId = '#get.BatchId#'						
				</cfquery>		
			
			</cfif>		   			
						
			<cfquery name="Update"
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Materials.dbo.WarehouseBatch
				SET    ActionStatus           = '9', 
				       ActionOfficerUserId    = '#SESSION.acc#',
				       ActionOfficerLastName  = '#SESSION.last#',
					   ActionOfficerFirstName = '#SESSION.first#',
					   ActionOfficerDate      = getDate(),
					   ActionMemo             = '#ActionMemo#'
				WHERE  BatchNo                = '#BatchNo#'
			</cfquery>
				
			<cftry>
		
				<cfquery name="Clear"
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM UserQuery.dbo.StockBatch_#SESSION.acc#	
					WHERE  BatchNo     = '#BatchNo#'
				</cfquery>
			
				<cfcatch></cfcatch>
		
			</cftry>
		
											
	</cffunction>		
		
	
</cfcomponent>