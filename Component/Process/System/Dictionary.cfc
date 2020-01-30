<cfcomponent>
	

	
	
	<cffunction name="getDescription" access="remote" returnFormat="plain" output="false">	
		<cfargument name="item"   type="string" required="false" default="">
		
			<cfquery name="qDescription" datasource="AppsSystem">
				SELECT Description,ModuleMemo
				FROM Ref_SystemModule
				WHERE SystemModule = '#ARGUMENTS.item#'
			</cfquery>	


			<cfset str = Wrap(qDescription.ModuleMemo,30)>
			<cfset str = replace(str,chr(13)&chr(10),chr(10),"ALL")>
			<cfset str = replace(str,chr(13),chr(10),"ALL")>
			<cfset str = replace(str,chr(9),"&nbsp;&nbsp;&nbsp;","ALL")>
			<cfset str = replace(str,chr(10),"","ALL")>

			<cfreturn "<h5>#qDescription.Description#</h5>#qDescription.ModuleMemo#">			
	</cffunction>
	
		
</cfcomponent>