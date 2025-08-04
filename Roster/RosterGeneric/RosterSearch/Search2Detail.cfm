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

<!--- identify matching functions --->

<cfset cond = "F.OccupationalGroup = '#url.occ#'">

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT  *
  FROM    Ref_ParameterOwner
  WHERE   Owner = '#URL.Owner#'
</cfquery>

<cfquery name="Search" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearch
		WHERE  SearchId = '#URL.ID#' 
</cfquery>  

<!--- ------------------------------------------------------------------------------ --->
<!--- preselect bucket in case the roster search is driven by a VA that has a bucket --->
<!--- ------------------------------------------------------------------------------ --->

<cfif Search.SearchCategory eq "Vacancy">
	
	<cfquery name="Check" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		  SELECT SelectId 
		  FROM   RosterSearchLine
		  WHERE  SearchId = '#URL.ID#' 
		  AND    SearchClass = 'Edition'
	</cfquery> 
				
	<cfquery name="Preselect" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" password="#SESSION.dbpw#">    
			 SELECT F1.FunctionNo, 
			        F1.OrganizationCode, 
					F1.GradeDeployment, 
					F1.FunctionId
			 FROM   FunctionOrganization F1, FunctionTitle F
			 WHERE  F1.DocumentNo = #Search.SearchCategoryId# 			
			 <cfif Check.recordcount gte "1">
			 AND    F1.SubmissionEdition IN 
				          (SELECT SelectId 
						   FROM RosterSearchLine
						   WHERE SearchId = '#URL.ID#' 
						   AND SearchClass = 'Edition') 
			 </cfif>		   
			 AND F1.FunctionNo = F.FunctionNo 		
	    </cfquery>
	
</cfif>	
			
	<cfset FileNo = round(Rand()*10)>
	
	<cfquery name="Steps" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_StatusCode
		WHERE    Owner = '#URL.Owner#'
		AND      Id = 'FUN'
		AND      ShowRosterSearch = 1
		ORDER BY Status 
	</cfquery>	
	
	<!--- 12/10/2014 : pendi ng Hanno if url.mode = vacancy we check if we have to filter the results by the to the 
	vacancy associated buchkets as defined in the edition of that bucket --->
		
	<cftry>		
	
		<cfset st = "">
		 
		<cfloop query="steps">
		      
		   <cfset st = "#st#,#status#">
		   
		   <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Roster#Status#_#fileno#"> 
		
		   <cfquery name="step" 
		   datasource="AppsSelection" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   SELECT DISTINCT F1.FunctionNo, 
		           F1.OrganizationCode, 
				   F1.GradeDeployment, 
				   COUNT(DISTINCT ApplicantNo) AS Status#Status#
		   INTO    userQuery.dbo.#SESSION.acc#Roster#Status#_#fileno#
		   FROM    ApplicantFunction A, 
		           FunctionOrganization F1 
		   WHERE   A.FunctionId = F1.FunctionId
		   AND     A.Status = '#Status#' 
		
		   <cfif Parameter.RosterSearchBucketVA eq "0">
		   <!--- exclude buckets triggered by a recruitment track --->
		   AND (F1.PostSpecific = 0 or F1.DocumentNo = #Search.SearchCategoryId#)
		   </cfif>
		   <cfif occ neq "">
		    AND    F1.FunctionId IN (SELECT DISTINCT FO.FunctionId 
			                         FROM   FunctionOrganization FO, FunctionTitle F
									 WHERE  FO.FunctionNo = F.FunctionNo
									 AND    F.OccupationalGroup = '#url.occ#') 
													 
		   <cfelseif rosterAccess eq "NONE" and URL.Mode neq "Limited">	
			 <!--- give access to logical buckets for which a person has been 
			       granted access through one of more vacancies ---> 					 
			 AND  F1.FunctionId IN 
			 		(SELECT DISTINCT Bucket.FunctionId
					FROM     RosterAccessAuthorization A INNER JOIN
		        			 FunctionOrganization FO ON A.FunctionId = FO.FunctionId INNER JOIN
		                  	 FunctionOrganization Bucket ON FO.FunctionNo = Bucket.FunctionNo AND FO.OrganizationCode = Bucket.OrganizationCode AND 
		                  	 FO.GradeDeployment = Bucket.GradeDeployment
					WHERE    A.UserAccount = '#SESSION.acc#'
					)					
		   </cfif>
		   AND     F1.SubmissionEdition IN (SELECT SelectId
		                                	FROM   RosterSearchLine
		                                	WHERE  SearchId = #URL.ID#
		                                 	AND    SearchClass = 'Edition')
		   GROUP BY F1.FunctionNo, F1.OrganizationCode, F1.GradeDeployment   
		   </cfquery>
		
		</cfloop>	
				
		<cfquery name="FunctionAll" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT   DISTINCT F1.FunctionNo,
					        F1.GradeDeployment,
							G.Description as GradeDescription,
					        F.FunctionDescription, 
					        R.OrganizationDescription, 
							R.HierarchyOrder, 
							G.Description AS GradeDeployment, 
				            F1.OrganizationCode, 
							<cfloop query="steps">
							   S#Status#.Status#Status#, 
							</cfloop>
							G.ListingOrder,
								(SELECT count(*) 
								 FROM   RosterSearchLine 
							 	 WHERE  SearchId = '#URL.ID#'
								 AND    SearchClass = 'Function'
								 AND    SelectId = F1.FunctionId
								 ) as Selected
								 
				FROM     FunctionOrganization F1 
				         INNER JOIN FunctionTitle F ON F1.FunctionNo = F.FunctionNo 
						 INNER JOIN Ref_Organization R ON F1.OrganizationCode = R.OrganizationCode 
						 INNER JOIN Ref_GradeDeployment G ON F1.GradeDeployment = G.GradeDeployment
						 INNER JOIN Ref_SubmissionEdition E ON F1.SubmissionEdition = E.SubmissionEdition 
						 
					     <cfloop query="steps">
					     LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#Roster#Status#_#fileno# S#Status# 
						      ON S#Status#.FunctionNo = F1.FunctionNo AND S#Status#.OrganizationCode = F1.OrganizationCode AND S#Status#.GradeDeployment = F1.GradeDeployment 
					     </cfloop>
					
			 WHERE   	#PreserveSingleQuotes(cond)#			 							 
			 AND     	F1.SubmissionEdition IN (SELECT SelectId
		                	                	 FROM RosterSearchLine
		                    	            	 WHERE SearchId = #URL.ID#
		                        	         	 AND SearchClass = 'Edition')
												 
			 AND        (F.FunctionRoster = '1' OR F1.ReferenceNo IN ('Direct','direct') OR F1.PostSpecific = 0 OR E.EnableAsRoster = 1)									 
			 
			 
			 <!--- this setting can be adjustment when a roster bucket is to be showned or not --->
			  
			 <cfif Parameter.RosterSearchBucketVA eq "0">
		     <!---      exclude buckets triggered by a supertrack/VA   --->
			 AND 	    (F1.PostSpecific = 0 or F1.DocumentNo = #Search.SearchCategoryId#)
			 </cfif>								 
			 
		     ORDER BY 	G.ListingOrder, 
			          	R.HierarchyOrder, 
					  	<!--- F1.FunctionId, --->
					  	F.FunctionDescription   
						
		</cfquery>
				
		<cfloop query="steps">
		    <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Roster#Status#_#fileno#"> 
		</cfloop>  
		
	<cfcatch>
	
		<cf_alert message="The server is currently busy. Please try again" return="no">
		<cfabort>
	
	</cfcatch> 
	
	</cftry>
	
	<table style="width:98.5%" class="navigation_table">
	
	<TR height="23" class="labelmedium2 fixrow line fixlengthlist">
	    <TD style="padding-left:4px"><cf_tl id="Grade">/<cf_tl id="Functional title"></TD>
		<TD><cf_tl id="Area"></TD>
		<cfloop query="steps">		
			<TD style="width:60px;border-left:1px solid silver;padding-right:3px" align="right">
			<cfoutput><a style="cursor: pointer;" title="#Meaning#">#TextHeader#</a></cfoutput></td>			
		</cfloop>
	    <TD align="center"><cf_tl id="Select"></TD>
	</TR>
	
	<cfset col = 3+steps.recordcount>
	
	<cfif FunctionAll.recordcount eq "0">
	
		<script>
		 document.getElementById("Prios").className = "hide"	 
		</script>			
		<tr><td colspan="<cfoutput>#col#</cfoutput>" height="30" class="labelmedium2" bgcolor="ffffff" align="center"><font color="FF8040"><cf_tl id="No buckets found"></td></tr>
	<cfelse>
	
	<script>
		 document.getElementById("Prios").className = "button10g"	 
	</script>	
	
	</cfif>
	
	<cfoutput query="FunctionAll" group="ListingOrder"> 
	
	<cfoutput group="GradeDeployment"> 
	
	<cfset g = "0">
	
	<tr class="labelmedium2 line fixlengthlist"><td height="35" style="font-size:19px" colspan="#col#">#GradeDescription# <cfif gradedescription neq gradedeployment>[#GradeDeployment#]</cfif></td></tr>
		
	<cfoutput>
		
		<cfif parameter.hideEmptyBucket eq "1">
			<cfset show = 0>
		<cfelse>
			<cfset show = 1>
		</cfif>
		<cfloop index="status" list="#st#" delimiters=",">
		   <cfif Evaluate("Status" & Status) gt "0">
		     <cfset show = "1">
		   </cfif>
		</cfloop>   	 
		
		<cfif show eq "1">
		
			<cfset pre = 0>
			
			<cfif Search.SearchCategory eq "Vacancy">
		
				<cfif Preselect.FunctionNo eq FunctionNo and
				      Preselect.OrganizationCode eq OrganizationCode and
					  Preselect.GradeDeployment eq GradeDeployment>
					  <cfset pre = 1>
	  		    </cfif>
			
			</cfif>  		  
				
		<TR class="labelmedium2 line navigation_row fixlengthlist" bgcolor="<cfif selected eq '1' or pre eq "1">ffffcf</cfif>">
		    <TD style="font-size:15px;padding-left:10px"><a href="javascript:gjp('#FunctionNo#','#GradeDeployment#')" title="Review description">#FunctionDescription#</a></TD>
		    <TD>#OrganizationDescription#</TD>
			<cfloop index="status" list="#st#" delimiters=",">
			<td align="right" style="padding-right:3px;border-left: 1px solid silver; border-right: 1px solid silver;">
			<cfif Evaluate("Status" & Status) eq "">
			0
			<cfelse>
			#Evaluate("Status" & Status)#
			</cfif>			
			</td>
			</cfloop>		
			<td align="center">		
							
			<input type="checkbox" 
			       name="bucket_#currentRow#"  class="radiol" value="1" 
				   onClick="hl(this,this.checked)" <cfif selected eq "1" or pre eq "1">checked</cfif>>
				   
			<input type="hidden" name="function_#currentRow#" value="#FunctionNo#">
			<input type="hidden" name="grade_#currentRow#"    value="#GradeDeployment#">
			<input type="hidden" name="org_#currentRow#"      value="#OrganizationCode#">
			
			</td>
			
		</TR>
		
			<cfset g = "1">
		
		<cfelse>	
		
			<input type="hidden" name="function_#currentRow#" value="#FunctionNo#">
			<input type="hidden" name="grade_#currentRow#"    value="#GradeDeployment#">
			<input type="hidden" name="org_#currentRow#"      value="#OrganizationCode#">
			<input type="hidden" name="bucket_#currentRow#"   value="0">
			
		</cfif>
		
	</CFOUTPUT>
	
	<cfif g eq "0">
		<tr><td colspan="#col#" align="center" bgcolor="FFFFFF" class="labelit"><b><font color="FF0000">No rostered candidates for any function for this level</b></td></tr>
	</cfif>
	
	</cfoutput>
	
	</cfoutput>
	
	<input type="hidden" 
	       name="No" 
		   value="<cfoutput>#FunctionAll.recordcount#</cfoutput>">
	
	</table>
	
	<cfset ajaxonload("doHighlight")>