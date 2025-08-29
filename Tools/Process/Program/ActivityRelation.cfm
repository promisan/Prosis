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
<cfparam name="Attributes.ProgramCode" default="PC5287">
<cfparam name="Attributes.ActivityId"  default="0">
<cfparam name="Attributes.Mode"        default="Child">

<!--- ATTENTION --->
<!--- Hanno make faster by creating a subset first of Programcode --->

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#ParentActivity">
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#ParentBase">

<cfquery name="Base" 
	 datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT *
		 INTO   userQuery.dbo.#SESSION.acc#ParentBase
	     FROM   ProgramActivityParent
		 WHERE  ProgramCode = '#Attributes.ProgramCode#' 
</cfquery>

<!--- Level 1 determine immediate children of this activity --->

	<cfquery name="Child1" 
	     datasource="AppsQuery" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT ActivityId, 
		        ActivityParent,
				StartAfter,
				StartAfterDays,
				'1' as DepOrder
		 INTO   dbo.#SESSION.acc#ParentActivity
	     FROM   #SESSION.acc#ParentBase
		 WHERE  ActivityParent = '#Attributes.ActivityId#' 
	</cfquery>

	<cfquery name="Child2" 
	     datasource="AppsQuery" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT ActivityId, 
		        ActivityParent
		 FROM   #SESSION.acc#ParentActivity
	</cfquery>
	
	<cfloop query="Child2">
	
	<!--- Level 2 determine the children of the children --->
	
		<cfset parent = ActivityId>
		
		<!--- select the records in which the parent is on its turn dependent
		on another activity --->
		
		<cfquery name="InsertChild" 
		    datasource="AppsQuery" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    INSERT INTO #SESSION.acc#ParentActivity
					 (ActivityId, ActivityParent,StartAfter,StartAfterDays, DepOrder)
		    SELECT ActivityId, '#Attributes.ActivityId#',StartAfter,StartAfterDays,'2'
		    FROM   #SESSION.acc#ParentBase
	        WHERE  ActivityParent = '#parent#' 		
		</cfquery>
				
		<cfquery name="Child3" 
	    datasource="AppsQuery" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT ActivityId, 
			       '#Attributes.ActivityId#'
			FROM   #SESSION.acc#ParentBase
			WHERE  ActivityParent = '#parent#' 		
		</cfquery>
		
		<cfloop query="Child3">
		
			<cfset parent = ActivityId>
			
			<!--- Level 3 determine the children of the children --->
		
			<cfquery name="InsertChild" 
		    datasource="AppsQuery" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    INSERT INTO #SESSION.acc#ParentActivity
						 (ActivityId, ActivityParent,StartAfter,StartAfterDays,DepOrder)
			    SELECT ActivityId, '#Attributes.ActivityId#',StartAfter,StartAfterDays,'3'
			    FROM   #SESSION.acc#ParentBase 
		        WHERE  ActivityParent = '#parent#' 		
			</cfquery>
				
			<cfquery name="Child4" 
		    datasource="AppsQuery" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT ActivityId, 
				       '#Attributes.ActivityId#'
				FROM   #SESSION.acc#ParentBase 
				WHERE  ActivityParent = '#parent#' 		
			</cfquery>
			
			<cfloop query="Child4">
		
				<cfset parent = ActivityId>
				
				<!--- Level 3 determine the children of the children --->
		
				<cfquery name="InsertChild" 
			    datasource="AppsQuery" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				    INSERT INTO #SESSION.acc#ParentActivity
							 (ActivityId, ActivityParent,StartAfter,StartAfterDays,DepOrder)
				    SELECT ActivityId, '#Attributes.ActivityId#',StartAfter,StartAfterDays,'4'
				    FROM   #SESSION.acc#ParentBase 
			        WHERE  ActivityParent = '#parent#' 		
				</cfquery>
				
				<cfquery name="Child5" 
			    datasource="AppsQuery" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
					SELECT ActivityId, 
					       '#Attributes.ActivityId#'
					FROM   #SESSION.acc#ParentBase 
					WHERE  ActivityParent = '#parent#' 		
				</cfquery>
			
				<cfloop query="Child5">
		
					<cfset parent = ActivityId>
					
					<cfquery name="InsertChild" 
			    datasource="AppsQuery" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				    INSERT INTO #SESSION.acc#ParentActivity
							 (ActivityId, ActivityParent,StartAfter,StartAfterDays,DepOrder)
				    SELECT ActivityId, '#Attributes.ActivityId#',StartAfter,StartAfterDays,'5'
				    FROM   #SESSION.acc#ParentBase 
			        WHERE  ActivityParent = '#parent#' 		
				</cfquery>	
				
				</cfloop>
				
			</cfloop>	
		
		</cfloop>
			
    </cfloop>	
	
