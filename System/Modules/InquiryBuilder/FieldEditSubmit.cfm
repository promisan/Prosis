
<cfparam name="FORM.FieldIsKey"    default="0">
<cfparam name="FORM.FieldIsAccess" default="0">
<cfparam name="FORM.FieldEditMode" default="0">
<cfparam name="FORM.ListingOrder"  default="0">
<cfparam name="FORM.FieldFilterClassMode"  default="0">

<!--- 1. Make sure theres is only one field key 
      2. Is key and is Access are mutually exclusive
	  3. Make sure that show in Grid is utually exclusive with show in Tree
	  --->

<cfif FieldIsKey eq "1">
	
	<cfquery name="Field" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		UPDATE Ref_ModuleControlDetailField
		SET    FieldIsKey = 0
		WHERE  SystemFunctionId = '#FORM.FunctionId#'
		AND    FunctionSerialNo = '#FORM.SerialNo#'
		
	</cfquery>
	
</cfif>

<cfif FieldIsAccess eq "1">
	
	<cfquery name="Field" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		UPDATE Ref_ModuleControlDetailField
		SET    FieldIsAccess = 0
		WHERE  SystemFunctionId = '#FORM.FunctionId#'
		AND    FunctionSerialNo = '#FORM.SerialNo#'
		
	</cfquery>
	
</cfif>

<cfset displayInGrid  = 0>
<cfset displayInTree = 0>

<cfif FORM.FieldDisplay eq "1"> <!--- In Grid --->
	<cfset displayInGrid = 1>
<cfelseif FORM.FieldDisplay eq "2"> <!--- In Tree --->
	<cfset displayInTree = 1>
</cfif>
	  
<cfquery name="Field" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
		 
	UPDATE Ref_ModuleControlDetailField
	  SET 
      ListingOrder 		   = '#FORM.ListingOrder#',
      FieldIsKey 		   = '#FORM.FieldIsKey#',
      FieldIsAccess 	   = '#FORM.FieldIsAccess#',
      FieldInGrid 		   =  #displayInGrid#,
      FieldHeaderLabel     = '#FORM.FieldHeaderLabel#',
      FieldAlignment 	   = '#FORM.FieldAlignment#',
      FieldWidth 		   = '#FORM.FieldWidth#',
	  FieldRow             = '#FORM.FieldRow#',
      FieldSort			   = '#FORM.FieldSort#',
	  FieldColspan         = '#FORM.FieldColspan#',
	  FieldFilterForce     = '#form.FieldFilterForce#',
	  FieldFilterLabel     = '#form.FieldFilterLabel#',
      FieldOutputFormat    = '#FORM.FieldOutputFormat#',
      FieldFilterClass     = '#FORM.FieldFilterClass#',
      FieldFilterClassMode = '#FORM.FieldFilterClassMode#',
      FieldEditMode 	   = '#FORM.FieldEditMode#',
      FieldEditInputType   = '#FORM.FieldEditInputType#',
	  <cfif FORM.FieldEditTemplate neq "">
      FieldEditTemplate    = '#FORM.FieldEditTemplate#',
	  <cfelse>
	  FieldEditTemplate    = NULL,
	  </cfif>
      FieldTree = #displayInTree#
	  
	WHERE  FieldId = '#FORM.FieldId#'
	AND    SystemFunctionId = '#FORM.FunctionId#'
    AND    FunctionSerialNo = '#FORM.SerialNo#'
	
</cfquery>

<cfoutput>
  <script>  	
	parent.parent.fieldrefresh('#url.systemfunctionid#','#url.functionserialno#');
	parent.parent.ProsisUI.closeWindow('myfield',true)
  </script>
</cfoutput>