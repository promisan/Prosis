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

<cf_compression>

<!--- ---------------------------------------- --->
<!--- template to refresh listing in ajax mode --->
<!--- ---------------------------------------- --->

<cfparam name="url.functionNo" default="0">
<cfparam name="url.col" default="">
<cfparam name="url.row" default="">

<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM #CLIENT.LanPrefix#FunctionTitle
	WHERE FunctionNo= '#URL.FunctionNo#'
</cfquery>

<cfoutput>
	
	<cfswitch expression="#URL.Col#">
	
		<cfcase value="desc">
		
		    <cfif get.recordcount eq "1">
			
				<table cellspacing="0" cellpadding="0">				
					
					    <tr style="height:16px" class="labelmedium"><td><font color="0080C0">
						<a href="javascript:recordedit('#get.FunctionNo#','#url.row#')">#get.FunctionDescription#</a>
						</td></tr>
						<cfif get.FunctionPrefix neq "">
						<tr><td><font color="0080C0">
						<a href="javascript:recordedit('#get.FunctionNo#','#url.row#')">#get.FunctionPrefix#.#get.FunctionKeyWord#.#get.FunctionSuffix#</a>
						</td></tr>
						</cfif>
					
				</table>			
		
			<cfelse>
			
				<font color="FF0000">Title removed</font>
				
			</cfif>
		
		</cfcase>
		
		<cfcase value="code">
		
			#get.FunctionClassification#
			
		</cfcase>
		
		<cfcase value="grde">
		
			<cfquery name="Grade"
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   DISTINCT FG.FunctionNo,FG.GradeDeployment,FP.FunctionNo as Profile
					FROM     FunctionTitleGrade FG LEFT OUTER JOIN FunctionTitleGradeProfile FP 
					    ON   FG.FunctionNo = FP.FunctionNo AND FG.GradeDeployment = FP.GradeDeployment
					WHERE    FG.FunctionNo = '#FunctionNo#'				
					AND      FG.Operational = 1		
					GROUP BY FG.FunctionNo,FG.GradeDeployment,FP.FunctionNo
			</cfquery>
			
			<table width="100%" cellspacing="0" cellpadding="0"><tr class="labelit"><td>
				
				<cfloop query="Grade">
				
				<a title="Maintain job profile" href="javascript:maintain('#FunctionNo#','#GradeDeployment#')">
				#Grade.GradeDeployment#
				</a>
					
				<cfif Profile neq "">
					<img src="#SESSION.root#/Images/attachment.gif"
						  name="img2_#currentrow#"
						  id="img2_#currentrow#"
						  border="0"
						  alt="Profile text was entered"
						  align="absmiddle"
						  style="cursor: pointer;">							 
				</cfif>		 
				<cfif CurrentRow neq Recordcount>, </cfif>
				
				</cfloop>
				</td>	
				</tr>
				</table>
		
		</cfcase>
	
	</cfswitch>

</cfoutput>