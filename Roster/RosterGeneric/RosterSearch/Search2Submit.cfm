<!--
    Copyright © 2025 Promisan

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
<!--- store search request --->

<cfparam name="Form.OccupationalGroup" default="">
<cfparam name="URL.DocNo"  default="">
<cfparam name="URL.Scope"  default="">

<!---
<cfif Form.OccupationalGroup eq "">

   <script language="JavaScript1.2">
   	   alert("You have not selected an occupational group.")
	   history.back()
   </script>
   <cfabort>

</cfif>
--->

<cfif url.mode eq "ssa" or url.scope eq "roster">

	<cfset exerciseclass = "">
	<cfparam name="getAssociatedBucket.RosterSearchMode" default="9">

<cfelse>
	
	<cfquery name="getAssociatedBucket" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	        SELECT   *
			FROM     FunctionOrganization FO, Ref_SubmissionEdition R
			WHERE    FO.Submissionedition = R.SubmissionEdition
			AND      DocumentNo           = '#URL.DocNo#' 		
	</cfquery> 
	
	<cfset exerciseclass = getAssociatedBucket.exerciseclass>

</cfif>

<cfquery name="Search" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearch
		WHERE  SearchId = '#URL.ID#'
</cfquery>  

<cfparam name="URL.Mode"   default="#Search.Mode#">
<cfparam name="URL.Status" default="#Search.Status#">
<cfparam name="URL.Owner"  default="#Search.Owner#">

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
 	 SELECT  *
	 FROM Ref_ParameterOwner
	 WHERE Owner = '#URL.Owner#'
</cfquery>


<cfquery name="Clear" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
     DELETE FROM   RosterSearchLine
     WHERE  SearchId    = '#URL.ID#' 
     AND    SearchStage = '2'
</cfquery>
 
<!--- insert occgroup --->

<cfif Form.OccupationalGroup neq "">
	
	<cfquery name="InsertOcc" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO RosterSearchLine
	         (SearchId,
			 SearchClass,
			 SelectId,SearchStage)
	      VALUES ('#URL.ID#',
		          'OccGroup', 
	              '#Form.OccupationalGroup#',
				  '2')
	</cfquery>

</cfif>
	
<!--- update from database --->
		
<cfquery name="Update" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     UPDATE RosterSearchLine
		 SET    SelectDescription = S.Description
		 FROM   RosterSearchLine L INNER JOIN OccGroup S ON L.SelectId =  S.OccupationalGroup 
		 WHERE  L.SearchId = '#URL.ID#'
		 AND    L.SearchClass = 'OccGroup' 
  </cfquery>

<!--- insert criteria --->

	<cfquery name="Insert" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        INSERT INTO RosterSearchLine
	         (SearchId,
			 SearchClass,
			 SelectId, SelectDescription,SearchStage)
	        VALUES ('#URL.ID#',
		       'FunctionOperator', 
	          'ANY','ANY','2')
	    </cfquery>
		
		<cfset go = "0">
		
		<cfparam name="Form.No"  default="0">
	
	<cfloop index="rec" from="1" to="#Form.No#">

		<cfset functionno    = evaluate("FORM.function_" & Rec)>
		<cfset org           = evaluate("FORM.org_"      & Rec)>
		<cfset grade         = evaluate("FORM.grade_"    & Rec)>
		
		<cfparam name="Form.Bucket_#Rec#" default="0">
		<cfset bucket        = evaluate("FORM.Bucket_"   & Rec)>
				 
		<cfquery name="Check" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			  SELECT SelectId 
			  FROM   RosterSearchLine
			  WHERE  SearchId    = '#URL.ID#' 
			  AND    SearchClass = 'Edition'
		</cfquery> 
				
		<cfif bucket eq "1">
						
		    <cfset go = "1">		
									  		
			<cfquery name="InsertFun" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 			 
		     INSERT INTO RosterSearchLine

		         (SearchId,
				  SearchClass,
				  SelectId, 
				  SelectDescription, 
				  SearchStage)
				 
				 SELECT DISTINCT '#URL.ID#',
				                 'Function',
								 F1.FunctionId,
								 F.FunctionDescription+' ['+F1.GradeDeployment+']',  
								 '2'
								 						
				 FROM   FunctionOrganization F1 INNER JOIN FunctionTitle F ON F1.FunctionNo = F.FunctionNo
				 
				 WHERE  
				 
				 <cfif getAssociatedBucket.RosterSearchMode eq "0">
					
					1=0 <!--- this will not likely happen --->
					
				<cfelseif getAssociatedBucket.RosterSearchMode eq "1">
				
				<!--- attention this mode should not kick-in the moment you do a global roster search --->
				
					F1.DocumentNo = '#url.DocNo#' 
					<!--- correction made 11/10/2014 --->
					AND    F1.FunctionId NOT IN (SELECT SelectId
					                             FROM   RosterSearchLine 
												 WHERE  SearchId    = '#URL.ID#' 
												 AND    SearchClass = 'Function'
												 AND    SelectId    = F1.FunctionId)
												 
				<cfelseif getAssociatedBucket.RosterSearchMode eq "2" and exerciseclass neq "">
				
					<!--- correction made 11/10/2014 --->
					F1.FunctionId NOT IN (SELECT SelectId
					                             FROM   RosterSearchLine 
												 WHERE  SearchId    = '#URL.ID#' 
												 AND    SearchClass = 'Function'
												 AND    SelectId    = F1.FunctionId)	
					AND    F1.FunctionId IN (SELECT FunctionId
					                         FROM   Functionorganization
											 WHERE  FunctionId = F1.FunctionId
											 AND    SubmissionEdition IN (SELECT SubmissionEdition
											 							  FROM   Ref_SubmissionEdition 
											                              WHERE  ExerciseClass = '#exerciseclass#')
											  )							 							 
				<cfelse>					
					
					F1.FunctionNo       = '#FunctionNo#' 
					AND    F1.OrganizationCode = '#Org#' 
					AND    F1.GradeDeployment  = '#Grade#' 
					AND    F1.FunctionId NOT IN (SELECT SelectId
					                             FROM   RosterSearchLine 
												 WHERE  SearchId    = '#URL.ID#' 
												 AND    SearchClass = 'Function'
												 AND    SelectId    = F1.FunctionId)
					 
					 <cfif Parameter.RosterSearchBucketVA eq "0">
					 AND    F1.PostSpecific = 0 				
					 </cfif>
					 
					 <cfif Check.recordcount gte "1">
					 AND    F1.SubmissionEdition IN 
						          (SELECT SelectId 
								   FROM   RosterSearchLine
								   WHERE  SearchId = '#URL.ID#' 
								   AND    SearchClass = 'Edition')
					 </cfif>	
				 
				  </cfif>				
				 
		    </cfquery>
								
		</cfif>
				
	</cfloop>
	
	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/> 
		
	<cfif Go eq "0">
  
       <cfoutput>
	   <script language="JavaScript1.2">
    	   alert("You did not selected any grade/functions.")
		   window.location = "Search2.cfm?docno=#url.docno#&ID=#URL.ID#&Owner=#URL.Owner#&Mode=#URL.Mode#&Status=#URL.Status#&mid=#mid#"
	   </script>
	   </cfoutput>
	   <cfabort>	   
	</cfif>
		
<cflocation url="Search4.cfm?docno=#url.docno#&ID=#URL.ID#&Owner=#URL.Owner#&Mode=#URL.Mode#&Status=#URL.Status#&mid=#mid#" addtoken="No">
