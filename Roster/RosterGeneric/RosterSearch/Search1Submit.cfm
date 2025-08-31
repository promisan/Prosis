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
<cfif URL.Mode eq "Limited">

	<cfquery name="Edition" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT SubmissionEdition
	    FROM Ref_SubmissionEdition R, Ref_ExerciseClass C
		WHERE C.ExcerciseClass = R.ExerciseClass
		AND   C.Roster = 1 
		AND   R.EnableAsRoster = 1
		AND   R.Owner = '#URL.Owner#' 
		AND   (R.DateExpiration >= getDate() 
		          OR R.DateExpiration is NULL 
				  OR R.DateExpiration = '')
	</cfquery>
	
	<cfset val = "">
	<cfloop query="Edition">
	 <cfif val eq "">
	   <cfset val = #SubmissionEdition#>
	 <cfelse>
	   <cfset val = "#val#,#SubmissionEdition#">  
	 </cfif>
	</cfloop>
	
	<cfset Form.SubmissionEdition = #val#>
	
<cfelse>	

	<cfparam name="Form.SubmissionEdition" default="">

</cfif>

<cfif Form.SubmissionEdition eq "">
  
   <script language="JavaScript1.2">
       alert("You have not identified a roster edition.")
	          history.back()
   </script>
   <cfabort>
   
</cfif>

<cfparam name="Form.Description" default="Default Search">
   
<cftransaction>
   
	   <cfquery name="Clear" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE RosterSearch 
	   	  WHERE OfficerUserId = '#SESSION.acc#'
		  AND   Created < GetDate()-1
		  <!--- if search has no results remove it --->
		   AND  SearchId NOT IN (SELECT SearchId 
		                         FROM RosterSearchLine)  
	  </cfquery>
	  	
	  <cflock timeout="5" throwontimeout="Yes" name="SerialNo" type="EXCLUSIVE">	
				 
		  <cfquery name="AssignNo" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE Parameter 
			 SET    SearchNo = SearchNo+1
		     </cfquery>
		
		  <cfquery name="LastNo" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT *
		     FROM Parameter
		   </cfquery>
			 
		   <cfset LastNo = LastNo.SearchNo>
		        
		   <cfquery name="InsertSearch" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO RosterSearch
		         (SearchId,
				 Description,
				 Owner,
				 RosterStatus,
				 Mode,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName) 
		      VALUES ('#LastNo#',
			      '#Form.Description#', 
				  '#URL.Owner#',
				  '#URL.Status#',
				  '#URL.Mode#',
		          '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')  
		    </cfquery>
									
			<cfif URL.DocNo neq "">
			
				<cfquery name="Update" 
			     datasource="AppsSelection" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     UPDATE RosterSearch 
				 SET    SearchCategory    = '#url.mode#', 
				        SearchCategoryId  = '#URL.DocNo#'
				 WHERE  SearchId = '#LastNo#'
			     </cfquery>
			
			</cfif>
			
		</cflock>
			
		<!--- insert edition --->
		
		<cfloop index="Item" 
	        list="#Form.submissionedition#" 
	        delimiters="' ,">
		
			<cfquery name="InsertEx" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO RosterSearchLine
		         (SearchId,
				 SearchClass,
				 SelectId)
		      VALUES ('#LastNo#',
			       'Edition', 
		          '#Item#')
		    </cfquery>
		
		</cfloop>
		
		<cfquery name="Update" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	    	 UPDATE RosterSearchLine
			 SET    SelectDescription = S.EditionDescription
			 FROM   RosterSearchLine INNER JOIN Ref_SubmissionEdition S ON RosterSearchLine.SelectId =  S.SubmissionEdition 
			 WHERE  RosterSearchLine.SearchId = '#LastNo#'
			 AND    RosterSearchLine.SearchClass = 'Edition'
	    </cfquery>
		
</cftransaction>	
	
<cfparam name="Form.OccupationalGroup" default="">	
<cfparam name="url.wparam" default="ALL">	

<cflocation url="Search2.cfm?wparam=#url.wparam#&ID=#LastNo#&Mode=#URL.Mode#&Owner=#URL.Owner#&DocNo=#URL.DocNo#&Status=#URL.Status#&id1=#form.OccupationalGroup#" addtoken="No">
	