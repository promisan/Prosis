<cftransaction>

		<cfquery name="qCheck"
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  * 
			FROM    Customer
			WHERE   PersonNo='#URL.ID#'
		</cfquery>		
							
		<cfquery name="ServiceItem" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   ServiceItem
			WHERE  Code  = '#Form.ServiceItem#'			
		</cfquery>
		
		<cfquery name="qDomain" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT ServiceDomain, ServiceDomainClass, EntityClass
			  FROM   Ref_RequestWorkflow
			  WHERE  RequestType    = '#FORM.RequestType#'
			  AND    ServiceDomain  = '#ServiceItem.ServiceDomain#'
			  AND    RequestAction  = '#FORM.RequestAction#'
		</cfquery>

		<cfif qCheck.recordcount eq 0>
		
			<!---- We need to create the customer ---->
			<cf_assignid>
			<cfquery name="qApplicant"
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Applicant.dbo.Applicant
				WHERE  PersonNo='#URL.ID#'
			</cfquery>				
			
			<cfif qApplicant.recordcount neq 0>
				
				<cfset vName="">
				<cfif qApplicant.FirstName neq "">
					<cfset vName = "#vName# #qApplicant.FirstName#">
				</cfif>	

				<cfif qApplicant.MiddleName neq "">
					<cfset vName = "#vName# #qApplicant.MiddleName#">
				</cfif>	

				<cfif qApplicant.LastName neq "">
					<cfset vName = "#vName# #qApplicant.LastName#">
				</cfif>

				<cfif qApplicant.LastName2 neq "">
					<cfset vName = "#vName# #qApplicant.LastName2#">
				</cfif>

			</cfif>
			
			<cfset cId = rowguid>
			
			<cfquery name="qInsert"
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Customer(CustomerId,Mission,PersonNo,CustomerName,OfficerUserId,OfficerLastName,OfficerFirstName)
				VALUES ('#cId#','#URL.Mission#','#URL.ID#','#vName#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
			</cfquery>						
				
		<cfelse>
		
			<cfset cId = qCheck.CustomerId>
			
			<cfquery name="qApplicant"
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Applicant.dbo.Applicant
				WHERE  PersonNo='#URL.ID#'
			</cfquery>				
						
		</cfif>			
		
		<cf_assignid>
		<cfset rId = rowguid>	
			
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.RequestDate#">
		<cfset DRD = dateValue>

		<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
		   
		    <cfquery name="Parameter" 
		    datasource="AppsWorkorder" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		        SELECT *
		        FROM   Ref_ParameterMission
		     WHERE  Mission = '#url.Mission#' 
		    </cfquery>
		    
		    <cfif Parameter.recordcount eq "0" or Parameter.RequisitionPrefix eq "">
		       
		     <cf_alert message="Invalid Reference">
		     <cfabort>
		    
		    </cfif>
		     
		    <cfset No = Parameter.RequisitionSerialNo+1>
		    <cfif No lt 10000>
		         <cfset No = 10000+No>
		    </cfif>
		     
		    <cfquery name="Update" 
		    datasource="AppsWorkOrder" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		        UPDATE Ref_ParameterMission
		     	SET    RequisitionSerialNo = '#No#'
		     	WHERE  Mission = '#url.Mission#' 
		    </cfquery>
		    
		    <cfset rfs = "#Parameter.RequisitionPrefix#-#No#">
		   
		</cflock>  
		
		<cfquery name="qInsert" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Request
		           (RequestId
		           ,RequestPackageId
		           ,ServiceDomain
		           ,ServiceDomainClass
		           ,RequestDate
		           ,Mission
		           ,Reference
		           ,OrgUnit
		           ,CustomerId
		           ,DomainReference
		           ,DateEffective
		           ,DateExpiration
		           ,PersonNo
		           ,PersonNoUser
		           ,RequestType
		           ,RequestAction
		           ,FundingId
		           ,Memo
		           ,eMailAddress
		           ,ActionStatus
		           ,EntityClass
		           ,OfficerUserId
		           ,OfficerLastName
		           ,OfficerFirstName)
		     VALUES
		           ('#rId#'
		           ,NULL
		           ,'#qDomain.ServiceDomain#'
		           ,'#qDomain.ServiceDomainClass#'
		           ,#DRD#
		           ,'#URL.Mission#'
		           ,'#rfs#'
		           ,0
		           ,'#cId#'
		           ,'Initial'
		           ,NULL
		           ,NULL
		           ,'#URL.ID#'
		           ,NULL
		           ,'#FORM.RequestType#'
		           ,'#FORM.RequestAction#'
		           ,NULL
		           ,'#FORM.memo#'
		           ,'#qApplicant.EmailAddress#'
		           ,1
		           ,'#qDomain.EntityClass#'
				   ,'#SESSION.acc#'
				   ,'#SESSION.last#'
				   ,'#SESSION.first#')
		</cfquery>	

		<cfquery name="qInsertLine" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO RequestLine
			           (RequestId
			           ,RequestLine
			           ,ServiceItem
			           ,ServiceItemUnit
			           ,Reference
			           ,DateEffective
			           ,DateExpiration
			           ,PersonNo
			           ,Charged
			           ,FundingId
			           ,CostId
			           ,Quantity
			           ,Currency
			           ,Rate
			           ,Remarks
			           ,OfficerUserId
			           ,OfficerLastName
			           ,OfficerFirstName)
			     VALUES
			           ('#rId#'
			           ,1
			           ,'#FORM.ServiceItem#'
			           ,NULL
			           ,'Portal'
			           ,#DRD#
			           ,#DRD#
			           ,'#URL.ID#'
			           ,1
			           ,NULL
			           ,NULL
			           ,1
			           ,'#Application.BaseCurrency#'
			           ,0
			           ,'#FORM.memo#'
					   ,'#SESSION.acc#'
					   ,'#SESSION.last#'
					   ,'#SESSION.first#')
	   </cfquery>

	<cfquery name="GetTopics" 
	  datasource="AppsWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT    *
	  	FROM      Ref_Topic
	  	WHERE     Operational = 1   
	  	AND       TopicClass = 'Request'  
	  	ORDER BY  ListingOrder
	</cfquery>
		
	<cfquery name="qDeleteTopic" 
	  datasource="AppsWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		DELETE  RequestTopic WHERE RequestId ='#rId#' 
    </cfquery>	
	
	<cfloop query="GetTopics">
		
		<cfparam name="TOPIC_#GetTopics.Code#" default="">
			
		<cfset value = Evaluate("TOPIC_#GetTopics.Code#")>
			
		<cfif value neq "">

			 <cfquery name="qCheck" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				  SELECT *
				  FROM   Ref_TopicList
				  WHERE  Code     = '#GetTopics.Code#'		
				  AND    ListCode = '#value#' 		
			</cfquery>	

			<cfif qCheck.recordcount neq 0>
				<cfset vListCode  = value>
				<cfset vListValue = qCheck.ListValue>
			<cfelse>
				<cfset vListCode  = ''>
				<cfset vListValue = value>
			</cfif>

			<cfquery name="qInsertTopic" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				INSERT INTO RequestTopic
		           (RequestId
		           ,Topic
		           ,ListCode
		           ,TopicValue
		           ,OfficerUserId
		           ,OfficerLastName
		           ,OfficerFirstName)
		     	VALUES
		           ('#rId#'
		           ,'#GetTopics.Code#'
		           <cfif vListCode neq "">
		           		,'#vListCode#'
		           		,'#vListValue#'
		           <cfelse>
		           		,NULL
		           		,'#vListValue#'
		           </cfif>	
				   ,'#SESSION.acc#'
				   ,'#SESSION.last#'
				   ,'#SESSION.first#')
		    </cfquery>

		</cfif>			
		
	</cfloop>			
		
</cftransaction>


<cfquery name="RequestType" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Request
	WHERE  Code  = '#Form.RequestType#'			
</cfquery>

<cfquery name="Customer" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT * 
			FROM   Customer		
			WHERE  CustomerId = '#cId#'	
</cfquery>
 
<cfset wflink = "WorkOrder/Application/Medical/Complaint/Workflow/DocumentForm.cfm?requestid=#rid#">
								
<cf_ActionListing 
	EntityCode       = "WrkRequest"
	EntityClass      = "#qDomain.EntityClass#"
	EntityGroup      = "#ServiceItem.ServiceDomain#"
	EntityStatus     = ""
	Mission          = "#url.mission#"
	PersonEMail      = "#qApplicant.EmailAddress#"
	ObjectReference  = "#rfs#"
	ObjectReference2 = "#RequestType.description#: #customer.CustomerName#"						
	ObjectKey4       = "#rid#"
	AjaxId           = "#rid#"
	ObjectURL        = "#wflink#"
	Reset            = "Yes"
	Show             = "no"
	ToolBar          = "No">


<cfoutput>
<script>
	closeComplaint('#URL.owner#','#URL.Id#')
</script>
</cfoutput>