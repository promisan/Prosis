
<!--- init --->

<cfset fld = Evaluate("Form.ConditionField")>
<cfset id = Evaluate("Form.SystemFunctionId")>

<cfparam name="Form.Deleted" default="">
<cfparam name="Form.Selected" default="">

<cfloop index="Rec" list="#Form.Selected#" delimiters=",">

  <cfif Rec eq "I" or Rec eq "D">
  
   <cfset mode = Rec>
  
  <cfelse>
  
      <cfif Mode eq "I">
	  
	    <cfquery name="Select" 
		    datasource="AppsSystem" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT * FROM UserModuleCondition
			WHERE SystemFunctionId = '#id#' 
			AND   Account = '#SESSION.acc#'
			AND   ConditionField = 'OrgUnit'
			AND   ConditionValue = '#rec#' 
		  </cfquery>
		  
		  <cfif #Select.Recordcount# eq "0">
  		 
			  <cfquery name="Insert" 
			    datasource="AppsSystem" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    INSERT INTO UserModuleCondition
				(SystemFunctionId,Account,ConditionField, ConditionValue)
				VALUES
				('#id#', '#SESSION.acc#','#fld#', '#rec#') 
			  </cfquery>
			  
		  </cfif>	  
				  
	  <cfelse>
	  
		  <cfquery name="Delete" 
		    datasource="AppsSystem" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    DELETE FROM UserModuleCondition
			WHERE SystemFunctionId = '#id#' 
			AND   Account = '#SESSION.acc#'
			AND   ConditionField = 'OrgUnit'
			AND   ConditionValue = '#rec#' 
		  </cfquery>
	  
	  </cfif>
	  
	</cfif>  
  
</cfloop>  

<script>
   window.close()
   opener.location.reload()
</script>
  

  
  
  
  
