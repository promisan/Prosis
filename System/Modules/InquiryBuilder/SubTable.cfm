
<cfparam name="URL.SystemFunctionId" default="">

<cfquery name="Header" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ModuleControlDetail
	WHERE  SystemFunctionId = '#URL.SystemFunctionId#'
	AND    FunctionSerialNo = #url.FunctionSerialNo#	
</cfquery>

<cfquery name="CheckForKey" 
   datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ModuleControlDetailField
	WHERE SystemFunctionId = '#URL.SystemFunctionId#'		
	AND   FunctionSerialNo = '#URL.FunctionSerialNo#'
	AND   FieldIsKey = 1
</cfquery>

<cfoutput>
	
	<cfset s = FindNoCase(" FROM", Header.queryScript)>
	
	<cfif FindNoCase("WHERE", Header.queryScript)>	
	   <cfset e = FindNoCase("WHERE ", Header.queryScript)>
	<cfelse>
	   <cfset e = len(Header.queryScript)>
	</cfif>
	
	<!--- show tables that can be part of the delete key --->
		
	<cftry>
	
		<cfset fr = mid(Header.queryScript,  s+4,  e-(s+4))>
		<select name="QueryTable" id="QueryTable" class="regularxl" style="border:0px">
		
			<option value="">Not applicable</option>
		
			<cfif CheckforKey.recordcount eq "1">
					
				<cfloop index="itm" list="#fr#" delimiters=", ">
				<cfif len(itm) gte 5 and not Find("@",itm)>
					<option value="#itm#" <cfif Header.QueryTable eq itm>selected</cfif>>#itm#</option>
				</cfif>
				</cfloop>
		
			</cfif>
			
		</select>
	
	<cfcatch>error</cfcatch>
	
	</cftry>

</cfoutput>
