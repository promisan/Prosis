
<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission
	WHERE Mission = '#url.mission#'
</cfquery>

<cfquery name="ObjectList" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Object
    WHERE   Procurement = 1	
	<cfif url.mission neq "">
	AND  ObjectUsage = '#Parameter.ObjectUsage#'
	</cfif>
</cfquery>
  	   
<select name="OCode" id="OCode" class="regularxl">
    <cfoutput query="ObjectList">
		 <option value="#Code#" <cfif code eq url.object>selected</cfif>>#Code# #Description#</option>
     </cfoutput>
</select>