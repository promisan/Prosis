<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<!--- -------------------------------------- workorder monthly charge process ---------------------------- --->
<!--- ---------------------------------------------------------------------------------------------------- --->

<!--- TO BE USED ONLY FOR MONTHLY or MONTHLY triggered quarterly or yearly CHARGES  

This batch generates monthly receivables postings into the financials module based on the workorder mission/service item which defines the journal

The steps are as follow :
 
0. Clean load of the same month for that mission in the ledger journal 
if the source = WorkOrderSeries, but only transaction if nothing was settled yet.

1. Select mission, workorders that have one or more operational = 1 workorder lines selection
date 15/NN 

2. Define for each 
      workorder (= customer + service)
	  service item unit 
	  ADDED charge type : Personal/Business (15/1/2011)
	  the cumulative billing per month until the current month of that year.

3. Compare with the total booking for that workorder/unit/charge sofar in the defined journal.

4. If different, make an entry (Header / Lines for the difference)

Attention

4a. this means that if a service item unit / charge type was recorded in the past and 
for some reason no longer exists, we do NOT make a correction. 

5. Show the billing transactions for that workorder in the screen
 
---> 

<cfparam name="URL.Mission"        	default="O">
<cfparam name="URL.WorkOrderid"    	default="00000000-0000-0000-0000-000000000000">
<cfparam name="URL.Posting"        	default="1">
<cfparam name="schedulelogid"      	default="">
<cfparam name="scripttimeout"      	default="100">
<cfparam name="URL.serviceItem"    	default="">
<cfparam name="URL.inlineexecution" default="0">

<cfquery name="Template"
datasource="NovaSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Schedule
	WHERE  ScheduleName = 'Monthly Service Posting'
</cfquery>

<cfset scripttimeout = Template.ScriptTimeout>

<cfif schedulelogid eq "">
		
	<cftry>
	
		<cfquery name="Insert"
			datasource="NovaSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO ScheduleLog
				       (ScheduleId, ScheduleRunId)
				VALUES ('#Template.scheduleId#','#rowguid#') 
		</cfquery>
		
		<cfcatch>
		
		</cfcatch>
	
	</cftry>

</cfif>

<!--- start processing services that are enabled for the selected mission --->


<cfquery name    = "getServices"
      datasource = "NovaWorkOrder"
      username   = "#SESSION.login#"
      password   = "#SESSION.dbpw#"
	  timeout    = "#scripttimeout#">	
		SELECT   *
		FROM     ServiceItemMission SM INNER JOIN
		         ServiceItem S ON SM.ServiceItem = S.Code
		WHERE    S.Operational = 1 
		AND      SM.Mission = '#url.mission#'
		AND      SM.Journal IN
		                   (SELECT  Journal
		                    FROM    Accounting.dbo.Journal
		                    WHERE   Mission = '#url.mission#')
							
		<cfif url.serviceItem neq "">
		AND      S.Code = '#URL.serviceItem#'
		</cfif>	
		
</cfquery>



<cfloop query="getServices">
	
	<!--- take the date/month until which data would need to be processed for statistics and financial posting --->

	<cf_ScheduleLogInsert   
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "#Code# #Description#">
			
	START of Process<br>		
	
	<cfset processService = Code> 
	
	<!--- get the first pending period for a service to be processed --->
	
	<cfquery name    = "SelDate"
	      datasource = "NovaWorkOrder"
	      username   = "#SESSION.login#"
	      password   = "#SESSION.dbpw#"
		  timeout    = "#scripttimeout#">	
			  SELECT   TOP 1 * 
			  FROM     ServiceItemMissionPosting
			  WHERE    Mission               = '#URL.Mission#'
			  AND      ServiceItem           = '#ProcessService#'
			  AND      ActionStatus          = 0
			  AND      EnableBatchProcessing = 1 
			  ORDER BY SelectionDateExpiration	 
			  
	</cfquery>	 
	
	<cfif SelDate.recordcount eq "0">
	
		<cf_ScheduleLogInsert   
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "No posting dates found.">
	
	<cfelseif SelDate.SelectionDateExpiration gt now()+300>
	
	    <!--- there is nothing to post yet as we do not future post--->
	
		<cf_ScheduleLogInsert   
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "There is nothing to process/post for this service.">
	
	<cfelse>

		<cfset vDateExpiration = SelDate.SelectionDateExpiration>

		<!--- entire 0 means we hack the sk table---->

		 <cfset entire = 0 >

         <cfif entire eq 1>
         	<cfinclude template="PostFinancialsSetCharges.cfm">
         <cfelse>

			<cfset dateValue = "">
			<CF_DateConvert Value="#dateformat(SelDate.SelectionDateEffective,CLIENT.DateFormatShow)#">
			<cfset SEL = dateValue>

			<cfset dateValue = "">
			<CF_DateConvert Value="#dateformat(SelDate.SelectionDateExpiration,CLIENT.DateFormatShow)#">
			<cfset Selend = dateValue>   

			<cfset tp  = 0>      	

			<cfquery name    = "workorder"
			     datasource = "NovaWorkOrder"
			     timeout="#scripttimeout#"
			     username   = "#SESSION.login#"
			     password   = "#SESSION.dbpw#">
			  
				SELECT  W.*
				FROM    WorkOrder W
				INNER JOIN Customer C ON C.CustomerId = W.CustomerId
				WHERE   W.Mission = '#url.mission#'
				
				AND     W.WorkorderId IN (SELECT WorkOrderId 
				                        FROM   WorkorderLine
										WHERE  DateEffective <= #selend#
									    AND    (DateExpiration >= #selend# or DateExpiration is NULL)
										AND    Operational = 1)		
				
				AND     W.ServiceItem = '#processService#'	
				ORDER BY C.CustomerName DESC, W.WorkOrderId
			</cfquery>		

         </cfif>
		

		 <cfif url.posting eq "1">

		 
		      <cfinclude template="PostFinancialsReceivables.cfm">
			  
			  <cfquery name  = "Log"
			      datasource = "NovaWorkOrder"
			      username   = "#SESSION.login#"
			      password   = "#SESSION.dbpw#"
				  timeout    = "#scripttimeout#">	
					  UPDATE   ServiceItemMissionPosting
					  SET      BatchProcessDate = getDate()
					  WHERE    Mission         = '#URL.Mission#'
					  AND      ServiceItem     = '#ProcessService#'
					  AND      SelectionDateExpiration   = '#vDateExpiration#'		
				</cfquery>	 			  			  

		 </cfif>
		 		
	</cfif>	

</cfloop>

Completed

<cfif url.inlineexecution eq "1" and url.serviceItem neq "">
	<cfoutput>
		<script>
			ColdFusion.navigate('#SESSION.root#/workorder/Maintenance/MissionPosting/ExecuteBatch_MissionPosting.cfm?id1=#url.serviceItem#&id2=#url.mission#&batch=1&bex=1', 'iconBatchContainer_#url.serviceItem#_#url.mission#');
		</script>
	</cfoutput>	
</cfif>