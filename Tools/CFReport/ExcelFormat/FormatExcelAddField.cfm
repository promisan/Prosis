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
<cfquery name="Parameter" 
	datasource="appsSystem">
	SELECT   *
    FROM     Parameter
</cfquery>


<cfquery name="Site" 
	datasource="AppsInit">
		SELECT * 
		FROM   Parameter
		WHERE  HostName = '#CGI.HTTP_HOST#'
</cfquery>

<cfquery name="Max" 
 datasource="appsSystem">
	 SELECT   max(FieldNameOrder) as FieldNameOrder
	 FROM     UserReportOutput P
	 WHERE    UserAccount = '#SESSION.acc#'
	 AND      OutputId    = '#url.id#'
	 AND      OutputClass = '#url.class#' 
</cfquery>

<!--- insert --->

<cfif URL.Name neq "">

    <cfif URL.class neq "Detail">

		<cfquery name="delete" 
		 datasource="appsSystem">
		 DELETE FROM     UserReportOutput 
		 WHERE    UserAccount = '#SESSION.acc#'
		 AND      OutputId    = '#URL.id#'
		 AND      OutputClass = '#URL.class#' 
		</cfquery>
	
	</cfif>
		
	<cfif URL.name neq "None">

		<cfset mx = Max.FieldNameOrder>
		<cfif mx eq "">
		  <cfset mx = "0">
		</cfif>
		<cfset mx = mx + 1>
		
		<cfif url.format eq "numeric">
		 <cfset for = "Sum">
		<cfelse>
		 <cfset for = "None"> 
		</cfif>
						
	    <cftry>
							
			<cfquery name="Insert" 
			 datasource="appsSystem">
			 INSERT INTO UserReportOutput 
			 (UserAccount, OutputId, OutputClass, FieldName,OutputHeader,FieldNameOrder,GroupFormula,OutputFormat)
			 VALUES
			 ('#SESSION.acc#','#URL.ID#','#URL.class#','#URL.Name#','#URL.Name#','#mx#','#for#','#url.format#')
			</cfquery>
				
			<cfcatch>
						
			<cfquery name="update" 
			 datasource="appsSystem">
			 UPDATE UserReportOutput 
			 SET     OutputShow = 1, OutputFormat = '#url.format#'
			 WHERE    UserAccount = '#SESSION.acc#'
			 AND      OutputId    = '#URL.id#'
			 AND      OutputClass = '#URL.class#' 
			 AND      FieldName   = '#URL.name#'
			</cfquery>		
			
			</cfcatch>
			
		</cftry>
		
		<cfif URL.class neq "Detail">
		
			<cftry>
			
				<cfquery name="Insert" 
				 datasource="appsSystem">
				 INSERT INTO UserReportOutput 
				 (UserAccount, OutputId, OutputClass, FieldName,OutputHeader,FieldNameOrder, GroupFormula,OutputFormat)
				 VALUES
				 ('#SESSION.acc#','#URL.ID#','Detail','#URL.Name#','#URL.Name#','0','#for#','#url.format#')
				</cfquery>
			
			<cfcatch></cfcatch>
			
			</cftry>
		
		</cfif>
		
	<cfelseif URL.class eq "Group1">	
		
		<cfquery name="delete" 
		 datasource="appsSystem">
		 DELETE FROM     UserReportOutput 
		 WHERE    UserAccount = '#SESSION.acc#'
		 AND      OutputId    = '#URL.id#'
		 AND      OutputClass = 'Group2' 
		</cfquery>
	
	</cfif>

<cfelse>
	
	<cfquery name="Output" 
	datasource="appsSystem">
		SELECT   *
	    FROM     Ref_ReportControlOutput
		WHERE    OutputId = '#URL.ID#'
	</cfquery>

	<cfset ds = Output.DataSource>


	<cfif site.applicationserver eq Parameter.databaseServer>		
		  <cfset svr = "">
	<cfelse>
		  	  
		  <cfset svr = "[#Parameter.databaseServer#].">
		  
	</cfif>	

	<cfquery name="Fields" 
	datasource="#ds#">
		SELECT   C.name, C.userType 
	    FROM     SysObjects S, SysColumns C 
		WHERE    S.id = C.id
		AND      S.name = '#URL.table#'	
		AND      C.name NOT IN (SELECT FieldName 
	                        FROM   #svr#System.dbo.UserReportOutput
	                        WHERE  UserAccount = '#SESSION.acc#'
							AND    OutputId = '#URL.id#') 
		ORDER BY C.ColId 

	</cfquery>
		
	<cfset mx = Max.FieldNameOrder>
	<cfif mx eq "">
	     <cfset mx = "0">
	</cfif>
	
	<cfloop query="Fields">
	
		<cfset mx = mx + 1>
		
		<cfif userType eq "8">
		   <cfset format = "Numeric">
		<cfelseif userType eq "12">
		    <cfset format = "Date">
		<cfelseif userType eq "0">
		    <cfset format = "Date">	
		<cfelseif findNoCase("date",name)>	
			<cfset format = "Date">
		<cfelse>
		    <cfset format = "Default">
		</cfif>	
		
		<cfif format eq "numeric">
		 <cfset for = "Sum">
		<cfelse>
		 <cfset for = "None"> 
		</cfif>
		
		<cftry>

		<cfquery name="Insert" 
		 datasource="appsSystem">
		 INSERT INTO UserReportOutput 
		 (UserAccount, OutputId, OutputClass,FieldName,OutputHeader,FieldNameOrder,GroupFormula,OutputFormat)
		 VALUES
		 ('#SESSION.acc#','#URL.ID#','#url.class#','#Name#','#Name#','#mx#','#for#','#format#')
		</cfquery>
		
		<cfcatch></cfcatch>
			
			</cftry>

	</cfloop>

	<cfquery name="Insert" 
		 datasource="appsSystem">
		 	UPDATE 	#svr#System.dbo.UserReportOutput
			SET 	OutputShow = '1'
			WHERE  	UserAccount = '#SESSION.acc#'
			AND    	OutputId = '#URL.id#'
	</cfquery>

</cfif>

<!--- open screen again --->

<cfinclude template="FormatExcelDetail.cfm">


