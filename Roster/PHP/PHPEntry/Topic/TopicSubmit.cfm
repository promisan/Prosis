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

<!--- verify if a submission record exists --->
<cfparam name="url.section" default="">
<cfparam name="URL.Topics"  default="">
<cfparam name="URL.Mission" default="">

<cfquery name="Parameter" 
datasource="AppsSelection">
	SELECT *
	FROM Parameter
</cfquery>

<cfquery name="getThisSubmission" 
	datasource="AppsSelection">
		SELECT	*
		FROM	ApplicantSubmission
		WHERE 	ApplicantNo = '#URL.ApplicantNo#'
		AND 	Source = <cfqueryparam value="#URL.Source#" cfsqltype="CF_SQL_CHAR" maxlength="10">
</cfquery>

<cfif getThisSubmission.recordCount gt 0 AND getThisSubmission.ActionStatus neq '1'>

	<cfquery name="Delete" 
			datasource="AppsSelection">
			DELETE FROM ApplicantSubmissionTopic
			WHERE ApplicantNo = '#URL.ApplicantNo#'
			AND Topic IN (SELECT Topic 
						FROM   Ref_Topic 
						WHERE  Source = <cfqueryparam value="#URL.Source#" cfsqltype="CF_SQL_CHAR" maxlength="10">
						AND    Parent = <cfqueryparam value="#URL.Parent#" cfsqltype="CF_SQL_CHAR" maxlength="20">)	
	</cfquery>

</cfif>

<cfquery name="Master" 
	datasource="AppsSelection">
	
	  SELECT *
	  FROM   Ref_Topic	 
	  <cfif url.topics neq "">
	  WHERE TOPIC IN (#preserveSingleQuotes(url.topics)#) 
	  <cfelseif URL.source eq "">
	  <!--- hardcode for Aldana outside portal --->
	  WHERE Topic IN ('MED003','MED003a','MED004','MED102','MED101','MED305')
	  <cfelse>
	  WHERE  Source = '#URL.Source#' 		  
	  </cfif>	  	   	  
</cfquery>

<!--- add background fields level, geo, exp after identifying the assigned serialNo --->

<cfparam name="inputform" default="Form">

<cfloop query="Master">
	
	<cfparam name="#inputform#.value_#Topic#" default="">
    <cfset value     = Evaluate("#inputform#.value_#Topic#")>
	
	<cfif value neq "">	
				
		<cfif ValueClass eq "List">
						
			<cfquery name="Name" 
			datasource="AppsSelection">
			  SELECT *
			  FROM   Ref_TopicList
			  WHERE  Code     = '#topic#'
			  AND    ListCode = '#value#' 
			</cfquery>
			
			<cfif Name.ListExplanation eq "">
				<cfset val = name.listvalue>	
			<cfelse>
			    <cfset val = name.listexplanation>
			</cfif>			
												
			<cfquery name="InsertExperience" 
			datasource="AppsSelection">
				INSERT INTO ApplicantSubmissionTopic 
				         (ApplicantNo,
						 Topic,
						 ListCode,
						 TopicValue,
						 Source,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				VALUES ('#URL.ApplicantNo#', 
				        '#topic#',
				   	    '#trim(value)#',
				      	'#trim(val)#',
						<cfqueryparam value="#URL.Source#" cfsqltype="CF_SQL_CHAR" maxlength="10">,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#')
	    	  </cfquery>
		
		<cfelse>
	 		
			<cfquery name="InsertExperience" 
			datasource="AppsSelection">
			INSERT INTO ApplicantSubmissionTopic 
			         (ApplicantNo,
					 Topic,
					 TopicValue,
					 Source,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			  VALUES ('#URL.ApplicantNo#', 
			          '#topic#',
			      	  '#trim(value)#',
					  '#URL.Source#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
	    	  </cfquery>
			  
		 </cfif>	  
				  
  	</cfif>			
	
</cfloop>	

<cfparam name="url.embed" default="0"> 
	
<cfif url.embed eq "0">
	
	<cfif url.entryscope eq "profile">
					
			<cf_Navigation
				 Alias         = "AppsSelection"
				 TableName     = "ApplicantSubmission"
				 Object        = "Applicant"
				 ObjectId      = "No"
				 Group         = "PHP"
				 Section       = "#URL.Section#"
				 SectionTable  = "Ref_ApplicantSection"
				 Id            = "#URL.ApplicantNo#"
				 Owner         = "#url.owner#"
				 Mission       = "#url.mission#"
				 BackEnable    = "1"
				 HomeEnable    = "1"
				 ResetEnable   = "1"
				 ResetDelete   = "0"	
				 ProcessEnable = "0"
				 NextEnable    = "1"
				 NextSubmit    = "1"
				 Reload        = "1"
				 OpenDirect    = "1"
				 SetNext       = "1"
				 NextMode      = "1"
				 IconWidth 	  = "32"
				 IconHeight	  = "32">			 
				
	<cfelse>
		 
		<cfinclude template="Topic.cfm">
		
	</cfif>
	
</cfif>	
