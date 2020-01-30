
<!--- init --->

<cfset fld = Evaluate("Form.ConditionField")>
<cfset id  = Evaluate("Form.SystemFunctionId")>

<cftransaction>

	<cfquery name="Delete" 
	    datasource="AppsSystem" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    DELETE 
		FROM   UserModuleCondition
		WHERE  SystemFunctionId = '#id#' 
		AND    Account          = '#SESSION.acc#'
		AND    ConditionField  = '#fld#'
	</cfquery>
	
	<cfloop index="Rec" from="1" to="#Form.Number#">
	  
	   <cfparam name="Form.Value_#Rec#" default="">
	   <cfset value = Evaluate("Form.Value_" & #Rec#)>
	   	   	   
	   <cfif value neq "">
	   	   
	      <cftry>
		  		   
			  <cfquery name="Insert" 
			    datasource="AppsSystem" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    INSERT INTO UserModuleCondition
				 (SystemFunctionId,
				  Account,
				  ConditionField, 
				  ConditionValue)
				VALUES
				('#id#', '#SESSION.acc#','#fld#', '#value#')
			  </cfquery>
		 
		  	  <cfcatch></cfcatch>
		  
		  </cftry>
	   
	   </cfif> 
	   
	</cfloop>  

</cftransaction>

<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 
		FROM     Ref_ModuleControl 
		WHERE    SystemFunctionId = '#Form.SystemFunctionId#'
</cfquery>


<cfset url.id = Form.SystemFunctionId>	
<cfinclude template="#Searchresult.FunctionPath#/Topic.cfm">

