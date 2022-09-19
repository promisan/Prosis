
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

<cfquery name="CheckForKey" 
   datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ModuleControlDetailField
		WHERE  SystemFunctionId = '#URL.SystemFunctionId#'		
		AND    FunctionSerialNo = '#URL.FunctionSerialNo#'
		AND    FieldIsKey = 1
</cfquery>

<cftry>

    <cfset sc = replace(Header.QueryScript, "SELECT",  "SELECT TOP 1")> 
	
	<cfoutput>
		<cfsavecontent variable="sc">	
			SELECT *
			FROM (#preservesinglequotes(sc)#) as D
			WHERE 1=0		
		</cfsavecontent>		
		</cfoutput>
	
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
		
	<cfquery name="Entity" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	   SELECT  *
	   FROM    Ref_Entity
	   WHERE   EntityKeyField1 IN ('#CheckForKey.fieldName#') OR EntityKeyField4 IN ('#CheckForKey.fieldName#')
	</cfquery>
			
	 <select name="EntityCode" id="EntityCode" class="regularxl" style="border:0px">
	    <option value="">Not applicable</option>					 
			 <cfoutput query="entity">		
			     <cfif CheckForKey.fieldName neq "">	 
			  	  <option value="#entitycode#" <cfif entitycode eq header.entitycode>selected</cfif>>#entitycode#</option> 
				  </cfif>
			 </cfoutput>									
	 </select>
	 
	
	<cfcatch>
	
	error
				
	</cfcatch>

</cftry>
	
