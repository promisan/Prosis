<cftransaction>
		
		<cf_assignid>
		<cfset rId = rowguid>	
			

		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.RequestDate#">
		<cfset DRD = dateValue>

		<cfquery name="qDomain" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT ServiceDomain,ServiceDomainClass
			  FROM Ref_RequestWorkflow
			  WHERE RequestType = '#FORM.RequestType#'
			  AND RequestAction = '#FORM.RequestAction#'
		</cfquery>

		
		<cfquery name="qUpdate" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Request
			SET 
				ServiceDomain      = '#qDomain.ServiceDomain#',
				ServiceDomainClass = '#qDomain.ServiceDomainClass#',
				RequestDate		   = #DRD#,
		        RequestType        = '#FORM.RequestType#',
		        RequestAction      = '#FORM.RequestAction#',
		        Memo               = '#FORM.memo#'
		    WHERE 
		    	RequestId          = '#URL.RequestId#'
		</cfquery>				


		<cfquery name="qUpdateLine" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE RequestLine
			SET    ServiceItem        = '#FORM.ServiceItem#',	
				   Remarks            = '#FORM.memo#'
		    WHERE  RequestId          = '#URL.RequestId#' 
	    	AND    RequestLine    = '1'
		</cfquery>				

		<cfquery name="GetTopics" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT   *
		  	FROM     Ref_Topic
		  	WHERE Operational = 1   
		  	AND   TopicClass = 'Request'  
		  	ORDER BY ListingOrder
		</cfquery>		
		
		<cfquery name="qDeleteTopic" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			DELETE RequestTopic
	        WHERE RequestId ='#URL.RequestId#' 
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
					<cfset vListCode  = '#value#'>
					<cfset vListValue = ''>
				<cfelse>
					<cfset vListCode  = ''>
					<cfset vListValue = '#value#'>
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
			           ('#URL.RequestId#'
			           ,'#GetTopics.Code#'
			           <cfif vListCode neq "">
			           		,'#vListCode#'
			           		,NULL
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

<cfoutput>
<script>
	closeComplaint('#URL.owner#','#URL.Id#')
</script>
</cfoutput>