
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



	

	

