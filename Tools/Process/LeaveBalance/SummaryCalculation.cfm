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
<cfparam name="attributes.personNo" default="999">
<cfparam name="attributes.date"     default="111">
<cfparam name="pers"  default="#attributes.personNo#">
<cfparam name="dte"   default="#attributes.date#">

<!-- reset summary --->

<cfquery name="Action" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT   DISTINCT ActionParent
		FROM     Ref_WorkAction
</cfquery>

<cfquery name="getDate" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT   *
		FROM    PersonWork
		WHERE	PersonNo        = '#pers#' 
		AND     CalendarDate    = #dte#    		
</cfquery>

<!--- check of the orgunit is enabled for workschedule --->


<cfif getDate.recordcount eq "0">

	<cfset workschema = "0">

<cfelse>
	
	<cfquery name="Organization" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT   *
			FROM    Organization.dbo.Organization
			WHERE	OrgUnit        = '#getDate.OrgUnit#' 		
	</cfquery>
	
	<cfif organization.workschema eq "0">
	
		<!--- this unit does not work with timesheduling --->
				
		<cfquery name="hasWorkschedule" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		         SELECT  TOP 1 *
		         FROM    PersonWorkSchedule
		         WHERE   PersonNo      = '#pers#'					 
				 AND     DateEffective  <= #dte#								
	    </cfquery>		
		
		<cfif hasWorkSchedule.recordcount eq "0">				
			<cfset workschema = "0">
		<cfelse>				
			<cfset workschema = "1">
		</cfif>	
		
	<cfelse>
	
		<cfquery name="hasPersonalSchedule" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			     SELECT  *
			     FROM    PersonWorkDetail
			     WHERE   PersonNo            = '#pers#'
				 AND     TransactionType     = '2'
				 AND     MONTH(CalendarDate) = #month(dte)#								
	    </cfquery>
		
		<cfquery name="hasWorkschedule" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		         SELECT  TOP 1 *
		         FROM    PersonWorkSchedule
		         WHERE   PersonNo        = '#pers#'					 
				 AND     DateEffective  <= #dte#								
	    </cfquery>		
			
		<!--- we check if the person has personal schema, in that case if not work is schedule
			we don't want to wipe out the class data --->
	
		<cfif hasPersonalSchedule.recordcount gte "1">						
			<cfset workschema = "1">
		<cfelse>			
			<cfset workschema = "0">
		</cfif>	
	</cfif>
	
</cfif>	

	
<cfquery name="reset" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		DELETE  PersonWorkClass		
		WHERE	PersonNo        = '#pers#' 
		AND     CalendarDate    = #dte#    
		AND     TransactionType = '1' 
		<cfif workschema eq "0">
		AND     TimeClass IN (SELECT TimeClass
		                      FROM   Ref_TimeClass 
							  WHERE  TimeParent = 'Work')
		</cfif>						  
</cfquery>
	
<!--- set summary from the details --->

<cfquery name="Sum" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  
		SELECT   R.ActionParent as TimeClass, 
		         P.ActionCode,
		         SUM(HourSlotMinutes) AS Total
		FROM     PersonWorkDetail P INNER JOIN
                 Ref_WorkAction R ON P.ActionClass = R.ActionClass
		WHERE    PersonNo        = '#pers#'
		AND      CalendarDate    = #dte#
		AND      TransactionType = '1'
		<cfif workschema eq "0">		
		AND      P.ActionClass IN (SELECT ActionClass
		                         FROM   Ref_WorkAction R INNER JOIN Ref_TimeClass C ON R.ActionParent = C.TimeClass
							     WHERE  TimeParent = 'Work')
		</cfif>			
		GROUP BY R.ActionParent,P.ActionCode							
		
</cfquery>

<!--- we can combine this --->

<cfloop query="sum">

	<cftry>
	
	<cfquery name="insert" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	  		   
   		   INSERT INTO	PersonWorkClass
    		      (PersonNo, 	    		  
    			   CalendarDate, 
				   TransactionType,
				   TimeClass,	
				   ActionCode,	
				   TimeMinutes) 
       	   VALUES ('#Pers#',		            
				    #dte#,
				   '1',
				   '#timeclass#',		
				   '#ActionCode#',							  
				   '#total#')							  
    </cfquery>	
	
	<cfcatch></cfcatch>			
	
	</cftry>
			
</cfloop>		


