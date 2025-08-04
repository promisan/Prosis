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

<cfparam name="st" default="1">

<cfif UserReport.TemplateUserQuery neq "">

	 <cftry>
	 	 		
			<CFOBJECT ACTION="CREATE"
				TYPE="JAVA"
				CLASS="coldfusion.server.ServiceFactory"
				NAME="factory">
				
			<CFSET dsService=factory.getDataSourceService()>

			<cfif dsService.verifyDatasource("#UserReport.TemplateUserQuery#")>

				<cfloop index="t" from="#st#" to="10">
						<cfset tbl  = Evaluate("Table" & #t#)>
						<cfif tbl neq "">
						
						 <CF_DropTable dbName="#Userreport.TemplateUserQuery#" 
						               full="1" 
									   tblName="#tbl#" 
									   timeout="10"> 
									   
						</cfif>
						
				</cfloop>
				
			</cfif>
			
			<cfcatch></cfcatch>	
			
	</cftry>		

<cfelse>
		
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
						
							<cfloop index="t" from="#st#" to="10">
							
								<cfset tbl  = Evaluate("Table" & #t#)>
								
								<cfif tbl neq "">
								
									<CF_DropTable dbName="#nm#" full="1" tblName="#tbl#"> 							
									
								</cfif>
								
							</cfloop>
									
						</cfif> 
						
						<cfcatch>
							<!--- Not verified, skip removal  --->
						</cfcatch>	
		
					</cftry>	
					
				</cfif>
					
		</cfloop>	
	
</cfif>	

