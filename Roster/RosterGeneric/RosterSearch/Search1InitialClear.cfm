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

<cfparam name="URL.Mode"    default="#URL.DocTpe#">
<cfparam name="URL.Inquiry" default="No">

<cfif URL.Inquiry eq "No">
    <cfset st = "#URL.Status#">
<cfelse>
    <cfset st = "0">
</cfif>

<cfquery name="Roster" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	SELECT   F.FunctionDescription, FO.GradeDeployment, R.Owner
	FROM     FunctionOrganization FO INNER JOIN
	         FunctionTitle F ON FO.FunctionNo = F.FunctionNo
			 INNER JOIN
	         Ref_SubmissionEdition R ON FO.SubmissionEdition = R.SubmissionEdition
	WHERE FunctionId = '#url.docno#'	
</cfquery>		
     
 <cfquery name="Missing"
  datasource="AppsSelection"
  username="#SESSION.login#"
  password="#SESSION.dbpw#">
  SELECT *
  FROM  ApplicantFunction F
  WHERE F.FunctionId = '#URL.DocNo#'
	AND   F.Status != '9'
	AND   F.FunctionId NOT IN (SELECT FunctionId 
		                       FROM   ApplicantFunctionAction
							   WHERE  FunctionId = '#URL.DocNo#'
							    AND   Status = '0')  
 </cfquery>
   
 <cfif Missing.recordcount gt "0">
   
	   <cf_RosterActionNo ActionRemarks="Opened application - no action" ActionCode="FUN"> 
	   
	   <cfquery name="PopulateMissing"
		   datasource="AppsSelection"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
			INSERT INTO ApplicantFunctionAction
			(ApplicantNo, FunctionId, RosterActionNo, Status)
			SELECT F.ApplicantNo, '#URL.DocNo#', #RosterActionNo#,'0'
			FROM  ApplicantFunction F
			WHERE F.FunctionId = '#URL.DocNo#'
			AND   F.Status != '9'
			AND   F.FunctionId NOT IN (SELECT FunctionId 
			                           FROM ApplicantFunctionAction
									   WHERE F.FunctionId = '#URL.DocNo#'
									   AND  F.Status = '0') 
	   </cfquery>
     
   </cfif>
 	  
<cfoutput>

<HTML><HEAD>
    <TITLE>#Roster.FunctionDescription# [#Roster.GradeDeployment#]</TITLE>
    <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</HEAD>

</cfoutput>
	
 <cfquery name="Clear" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   DELETE RosterSearch 
   WHERE Status = '0' 
   AND OfficerUserId = '#SESSION.acc#'
   AND Created > GetDate()-1
   AND SearchId NOT IN (SELECT SearchId 
	                    FROM   RosterSearchLine)
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
			 Mode,
			 Owner,
			 RosterStatus,
			 SearchCategory,
			 SearchCategoryId,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	      VALUES ('#LastNo#',
		      'Initial Clearance', 
			  '#URL.Mode#',
			  '#Roster.Owner#',
			  '#st#',
			  'Function',
			  '#url.docno#',
	          '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
	    </cfquery>
		
		<cfquery name="Insert" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        INSERT INTO RosterSearchLine
	         (SearchId,
			 SearchClass,
			 SelectId, SelectDescription,SearchStage)
	        VALUES ('#LastNo#',
		       'FunctionOperator', 
	          'ANY','ANY','2')
	    </cfquery>
		
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
	      VALUES ('#LastNo#',
		       'Function', 
	          '#URL.DocNo#',
			  '#Roster.FunctionDescription#',
			  '2')
	    </cfquery>
	
</cflock>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   
		
<cflocation url="Search4.cfm?mode=#url.mode#&docno=#url.docno#&ID=#LastNo#&Title=#Roster.FunctionDescription# [#Roster.GradeDeployment#]&mid=#mid#" addtoken="No">

	