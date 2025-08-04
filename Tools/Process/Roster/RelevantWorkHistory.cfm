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
<cfparam name="Attributes.PersonNo"	      default="">
<cfparam name="Attributes.ApplicantNo"	  default="">
<cfparam name="Attributes.Source"	      default="">


<cfif Attributes.ApplicantNo eq "">

	<cfquery name="getSubmission" 
	     datasource="AppsSelection" 
	  	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT   *
			 FROM     ApplicantSubmission S
			 WHERE    PersonNo  = '#Attributes.PersonNo#'
			 AND      Source	= '#Attributes.Source#' 
	</cfquery>	
	
<cfelse>

	<cfquery name="getSubmission" 
	     datasource="AppsSelection" 
	  	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT   *
			 FROM     ApplicantSubmission S
			 WHERE    ApplicantNo  = '#Attributes.ApplicantNo#'
	</cfquery>	

</cfif>

<cfif getSubmission.recordcount eq 0>

	<cfset Caller.years  = 0>
	<cfset Caller.months = 0>
	
<cfelse>

	<cfquery name="Work" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	       SELECT *
	       FROM   ApplicantBackground B
	       WHERE  ApplicantNo   = '#getSubmission.ApplicantNo#'
		   AND    ExperienceCategory = 'Employment'
		   AND    Status IN ('0','1')
		   ORDER  BY ExperienceStart DESC
	   </cfquery>	
	
	<cfset durT = 0>
	
	<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#BackgroundCount">
	
	<cfquery name="Table" 
	    datasource="AppsQuery" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		CREATE TABLE dbo.[tmp#SESSION.acc#BackgroundCount] ( [MonthNo] [int] NOT NULL ) ON [PRIMARY]
	   </cfquery>	
	
	
	<cfoutput query = "Work">
	
	 	 
	  <cfif ExperienceStart neq "" and (ExperienceEnd gt ExperienceStart or ExperienceEnd eq "")>
	  
	    <cfif ExperienceEnd eq "">
		  <cfset end = now()>		  
		<cfelse>
		  <cfset end = ExperienceEnd>
		</cfif>
	
		<!--- KRW 10/11/06: adding in case days are part of dates: 
		Business rule: 20 days over a whole month counts as extra month
		Less than 20 days remainder counts as one less month --->
		  
		  <cfset dayDiff = Day(end)-Day(ExperienceStart)>
		  <cfif dayDiff gte 20>
		   	<cfset MonthPart = 1>
		  <cfelse>
		 	<cfset MonthPart = 0>		  		
		  </cfif>
		  
	      <cfset st   = year(ExperienceStart)*12>
		  <cfset st   = st+month(ExperienceStart)>
		  
		  <cfset ed   = year(end)*12>
		  <cfset ed   = ed+month(end)>
		  <cfset dur  = (ed-st+MonthPart)>		  
		  <cfset span = (st+dur-1)>
		  
	          <!---  <cfloop index="m" from="#st#" to="#ed#">   --->
	          <!---  KRW 10/11/06: eliminates the adding of 1 extra month per history record --->
		   
		   <cfloop index="m" from="#st#" to="#span#">	
		   		 		  
			  <cfquery name="Insert" 
		       datasource="AppsQuery" 
		       username="#SESSION.login#" 
		       password="#SESSION.dbpw#">
		       INSERT INTO tmp#SESSION.acc#BackgroundCount
			   (MonthNo) VALUES (#m#)  
		      </cfquery>	 
			 		     
		  </cfloop>
		  
	  <cfelse>	 
	   	  <cfset dur = 0> 
	  </cfif>	  
	  
	
	</cfoutput>
	
	<cfquery name="Total" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT count(Distinct MonthNo) as Total 
		  FROM tmp#SESSION.acc#BackgroundCount 
	</cfquery>	 
	
	<cfif Total.recordcount gt 0>
			<cfset vTotal = Total.Total>
			<cfoutput>
				#vTotal#
			</cfoutput>
			<cf_MonthsToYears Months="#vTotal#">
	<cfelse>
	
			<cfset Caller.years  = 0>
			<cfset Caller.months = 0>
	
	</cfif>

</cfif>

