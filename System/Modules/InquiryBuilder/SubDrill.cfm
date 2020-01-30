
<cfparam name="URL.SystemFunctionId" default="">

<cfquery name="Header" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ModuleControlDetail
	WHERE SystemFunctionId = '#URL.SystemFunctionId#'
	AND   FunctionSerialNo = '#url.FunctionSerialNo#'	
</cfquery>


<cftry>

    <cfset sc = replace(Header.QueryScript, "SELECT",  "SELECT TOP 1")> 
	
	<!--- -------------------------- --->
	<!--- preparation of the listing --->
	<!--- -------------------------- --->
	
	<cfset fileNo = "#Header.DetailSerialNo#">						
	<cfinclude template="QueryPreparationVars.cfm">	
	<cfinclude template="QueryValidateReserved.cfm">
			
	<cfquery name="SelectQuery" 
	datasource="#Header.QueryDataSource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	   #preservesinglequotes(sc)# 
	</cfquery>
	
	 <select name="DrillFieldKey" id="DrillFieldKey" style="width:200px" style="font:10px">
		<cfoutput>						 
			 <cfloop index="col" list="#SelectQuery.columnList#" delimiters=",">
			  	  <option value="#col#" <cfif col eq header.drillfieldkey>selected</cfif>>#col#</option> 
			  </cfloop>
		</cfoutput>									
	 </select>
	 
	 &nbsp;<b>Attention:</b> Must be a unique identifier if also used for deletion !

	<cfcatch>
	
	error
				
	</cfcatch>

</cftry>
	
