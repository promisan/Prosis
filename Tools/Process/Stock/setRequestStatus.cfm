
<!--- verify status of request --->

<cfparam name="Attributes.mission"         default="">
<cfparam name="Attributes.RequestId"       default="00000000-0000-0000-0000-000000000000">
<cfparam name="Attributes.EvaluateHeader"  default="Yes">
<cfparam name="Attributes.Datasource"      default="#attributes.datasource#">

<cfif attributes.mission eq "">

	<cfquery name="get" 
	datasource="#attributes.datasource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT    *
	   FROM      Request
	   WHERE     RequestId = '#attributes.requestid#'  
	</cfquery>

	<cfset mission = get.Mission>

<cfelse>

	<cfset mission = attributes.mission>	

</cfif>

<cfquery name="param" 
datasource="#attributes.datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT    *
   FROM      Materials.dbo.Ref_ParameterMission
   WHERE     Mission = '#mission#'  
</cfquery>


<cfset diff = (100+param.taskorderdifference)/100>   

<cfquery name="getFullProcessed" 
datasource="#attributes.datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	   SELECT    R.RequestId, 
	             R.RequestedQuantity, 
				 
				 (
				 SELECT  isNULL(SUM(T.TaskQuantity),0)
				 FROM    RequestTask T
				 WHERE   T.RequestId = R.RequestId
				 AND     T.RecordStatus IN ('1','3') 				 
				 ) as Tasked,	
				 
				 R.RequestType,
				 R.Status,
				 (
				 SELECT  isNull(SUM(I.TransactionQuantity) * #diff# * -1,0) 
				 FROM    Materials.dbo.ItemTransaction I
				 WHERE   I.RequestId = R.RequestId
				 <!--- transaction is confirmed --->
			     AND     I.ActionStatus = '1' 
				  AND    I.TransactionQuantity < 0
				 ) as Picked,	
				 
				 (
				 SELECT  isNULL(SUM(T.TaskQuantity),0)
				 FROM    Materials.dbo.RequestTask T
				 WHERE   T.RequestId = R.RequestId
				 <!--- transaction is manually closed --->
			     AND     T.RecordStatus = '3' 				 
				 ) as Closed,					 
				 			 
				 (
				 SELECT  isNULL(SUM(I.TransactionQuantity) * #diff#,0)  
				 FROM    Materials.dbo.ItemTransaction I
				 WHERE   I.RequestId = R.RequestId
				 <!--- transaction is confirmed --->
			     AND     I.ActionStatus = '1' 
				 <!--- receipt by other customer --->
				 AND     I.TransactionQuantity > 0
				 ) as Transferred				 
				 
	   FROM      Materials.dbo.Request R 
	   WHERE     R.Mission = '#mission#'	  
	 		  
	   <cfif attributes.requestId neq "00000000-0000-0000-0000-000000000000" and attributes.requestid neq "">
	   AND       R.RequestId = '#attributes.requestId#' 
	   <cfelse>
	   <!--- following was enabled by Armin on 11/15/2014 as it was resetting the status every day--->
	   AND       R.Status != '3'
	   </cfif>	   
</cfquery>   

<cfif getFullProcessed.recordcount eq "0" and attributes.requestId neq "00000000-0000-0000-0000-000000000000" and attributes.requestid neq "">
      
		<cfquery name="resetsetProcessed" 
			datasource="#attributes.datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   UPDATE    Materials.dbo.Request 
			   SET       Status    = '2'
			   WHERE     RequestId = '#attributes.RequestId#' 				  	  
		</cfquery>   
			
<cfelse>	
	
	<cfloop query="getFullProcessed">
	
				
		<cfif requestType eq "Pickticket">
				
			 <cfif (Picked+Closed) gte RequestedQuantity>			 
				<cfset st = "3">				 
			 <cfelse>			 
			 	<cfset st = "2">			 
			 </cfif>	 
									 		
		<cfelse>
		
		<!--- 15/4/2013
		<cfoutput>
		 <cfif (Transferred+Closed) gte RequestedQuantity>	
		</cfoutput>
		--->
				
			<cfif tasked gte "1">
			   <cfset base = Tasked>			   
			<cfelse>
			   <cfset base = RequestedQuantity>
			</cfif>      
			
								
			 <cfif (Transferred+Closed) gte Base>		
			     <!--- completed --->	 
				
				 <cfset st = "3">				 
			 <cfelse>	
			     <!--- in process still --->		 
				 
			 	 <cfset st = "2">			 
			 </cfif>	 
		
		</cfif>
		
		<cfif Status neq st>
		  	
			<cfquery name="setProcessed" 
				datasource="#attributes.datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE    Materials.dbo.Request 
				SET       Status    = '#st#'
				WHERE     RequestId = '#RequestId#' 
			</cfquery>   
		
		</cfif>
			
	</cfloop>

</cfif>

<!--- -------------------------------------- --->
<!--- -------------reset cancelled---------- --->
<!--- -------------------------------------- --->

<cfquery name="getLineStatus" 
	datasource="#attributes.datasource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		UPDATE Request
		SET    Status = '9'
		FROM   Materials.dbo.Request R INNER JOIN  Materials.dbo.RequestHeader H ON R.Mission = H.Mission AND R.Reference = H.Reference
		WHERE    H.ActionStatus = '9'
	    <cfif attributes.requestId neq "">
		AND       R.RequestId    = '#attributes.RequestId#'  
		<cfelse>
		AND       R.Mission      = '#attributes.mission#'
		</cfif>		
		AND     R.Status != '9'
</cfquery>

<!--- -------------------------------------- --->
<!--- close the overall status of the header --->
<!--- -------------------------------------- --->

<cfif attributes.evaluateHeader eq "Yes">
	
	<cfquery name="getLineStatus" 
		datasource="#attributes.datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT    R.Mission, 
			          R.Reference,
					  MIN(R.Status) as Status
			FROM      Materials.dbo.Request R INNER JOIN Materials.dbo.RequestHeader H ON R.Mission = H.Mission AND R.Reference = H.Reference
			WHERE     R.Status      <> '9' 
			AND       H.ActionStatus < '5'
		    <cfif attributes.requestId neq "00000000-0000-0000-0000-000000000000" and attributes.requestid neq "">
			AND       R.RequestId    = '#attributes.RequestId#'  
			<cfelse>
			AND       R.Mission      = '#attributes.mission#'
			</cfif>
			GROUP BY  R.Mission, R.Reference
			HAVING    MIN(R.Status) = '3' 
	</cfquery>
	
	<cfloop query="getLineStatus">
	
			<cfquery name="setRequestStatus" 
				datasource="#attributes.datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE    Materials.dbo.RequestHeader 
					SET       ActionStatus  = '5', ActionStatusDate = getDate()
					WHERE     Mission       = '#Mission#' 
					AND       Reference     = '#reference#' 
			</cfquery>   
	
	</cfloop>	
		
	<!--- added by hannd 6/6/2013 to revert status --- ---> 
	<!--- -------------------------------------------- --->
	<!--- revert requests that are not fully processed --->
	<!--- -------------------------------------------- --->	
	
	<cfquery name="getLineStatus" 
		datasource="#attributes.datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT    R.Mission, 
			          R.Reference,
					  MIN(R.Status) as Status
			FROM      Materials.dbo.Request R INNER JOIN Materials.dbo.RequestHeader H ON R.Mission = H.Mission AND R.Reference = H.Reference
			WHERE     R.Status      <> '9' 
			AND       H.ActionStatus = '5'
		    <cfif attributes.requestId neq "00000000-0000-0000-0000-000000000000" and attributes.requestid neq "">
			AND       R.RequestId    = '#attributes.RequestId#'  
			<cfelse>
			AND       R.Mission      = '#attributes.mission#'
			</cfif>
			GROUP BY  R.Mission, R.Reference
			HAVING    MIN(R.Status) = '2' 
	</cfquery>
	
	<cfloop query="getLineStatus">
	
			<cfquery name="setRequestStatus" 
				datasource="#attributes.datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE    Materials.dbo.RequestHeader 
					SET       ActionStatus  = '3', ActionStatusDate = getDate()
					WHERE     Mission       = '#Mission#' 
					AND       Reference     = '#reference#' 
			</cfquery>   
	
	</cfloop>	

</cfif>
	
