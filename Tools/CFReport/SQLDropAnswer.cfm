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
<cfparam name="st" default="1">

<cfif UserReport.TemplateUserQuery neq "">

    <cftry>
	
			<!--- Get "factory" --->
			<CFOBJECT ACTION="CREATE"
				TYPE="JAVA"
				CLASS="coldfusion.server.ServiceFactory"
				NAME="factory">
				<CFSET dsService=factory.getDataSourceService()>
				
			<cfif dsService.verifyDatasource("#UserReport.TemplateUserQuery#")>

				<cfloop index="t" from="1" to="35">
					 <cfset tbl  = Evaluate("Answer" & #t#)>
					 <cfif tbl neq "">
						 <CF_DropTable dbName="#Userreport.TemplateUserQuery#" tblName="#tbl#"> 
					 </cfif>
					
				</cfloop>
		
				<CF_DropTable dbName="#Userreport.TemplateUserQuery#" tblName="#AnswerOrg#"> 
				<CF_DropTable dbName="#Userreport.TemplateUserQuery#" tblName="#answerOrgAccess#">
				
			</cfif>
			
		<cfcatch>
			
			<!--- Not verified, skip removal  --->
			
		</cfcatch>	
	
	</cftry>	
	
<cfelse>

	 
	<!--- Get "factory" --->
	<CFOBJECT ACTION="CREATE"
		TYPE="JAVA"
		CLASS="coldfusion.server.ServiceFactory"
		NAME="factory">
		<CFSET dsService=factory.getDataSourceService()>
		
		<CFSET dsNames=dsService.getNames()>
		<cfset ArraySort(dsnames, "textnocase")>
		
	<cfloop INDEX="i" FROM="1" TO="#ArrayLen(dsNames)#">
			
			<cfset nm = dsNames[i]>
				
			<cfif findNoCase("appsQuery","#nm#")>	

				<cftry>
				
					<cfif dsService.verifyDatasource("#nm#")>				
						
						<cfloop index="t" from="1" to="35">
						 <cfset tbl  = Evaluate("Answer" & #t#)>
						 <cfif tbl neq "">
							 <CF_DropTable dbName="#nm#" tblName="#tbl#" timeout="6"> 
						 </cfif>
						</cfloop>
						<CF_DropTable dbName="#nm#" tblName="#AnswerOrg#" timeout="6"> 
						<CF_DropTable dbName="#nm#" tblName="#answerOrgAccess#" timeout="6"> 
							
					</cfif> 
					
					<cfcatch>
					
						<!--- Not verified, skip removal  --->
					
					</cfcatch>	
					
				</cftry>	
								
			</cfif>
					
	</cfloop>	
	
</cfif>	



	

	

