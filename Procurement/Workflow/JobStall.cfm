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
<!--- script to stall a job = 8------------------------------- --->
<!--- -------------------------------------------------------- --->

<cftransaction>
	
	<cfquery name="Job" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE  Job
		SET     ActionStatus = '8',
		        ActionDate = getDate(),
				ActionUserId = '#SESSION.acc#'
		WHERE   JobNo = '#Object.ObjectKeyValue1#' 
	</cfquery>
	
	<cfquery name="Lines" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    * 
		FROM      RequisitionLine
		WHERE     RequisitionNo NOT IN (SELECT RequisitionNo 
		                                FROM   PurchaseLine 
										WHERE  ActionStatus < '9')
		AND       JobNo = '#Object.ObjectKeyValue1#' 
	</cfquery>
	
	<cfset st = "9">
		
	<cfloop query="Lines">
	
		<!---  1. update requisition lines --->
		<cfquery name="Update" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE RequisitionLINE
			 SET    ActionStatus    = '#st#' 
			 WHERE  RequisitionNo   = '#RequisitionNo#'
		</cfquery>
								
		<cf_assignId>
						
		<!---  2. enter action --->
		<cfquery name="InsertAction" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO RequisitionLineAction 
					 (RequisitionNo, 
					  ActionId,
					  ActionStatus, 
					  ActionDate,		
					  ActionMemo,						 
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
			 SELECT RequisitionNo, 
			        '#rowguid#',
			        '#st#', 
					getDate(),
					'Cancelled from Job',									
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#'
			 FROM  RequisitionLine
			 WHERE RequisitionNo = '#RequisitionNo#'
		</cfquery>
	
	</cfloop>

</cftransaction>

