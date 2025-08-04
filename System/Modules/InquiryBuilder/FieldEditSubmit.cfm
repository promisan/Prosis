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
	      ListingOrder 		    = '#FORM.ListingOrder#',
	      FieldIsKey 		    = '#FORM.FieldIsKey#',
		  FieldNameSort         = '#FORM.FieldNameSort#',
	      FieldIsAccess 	    = '#FORM.FieldIsAccess#',
	      FieldInGrid 		    =  #displayInGrid#,
	      FieldHeaderLabel      = '#FORM.FieldHeaderLabel#',
	      FieldAlignment 	    = '#FORM.FieldAlignment#',
	      FieldWidth 		    = '#FORM.FieldWidth#',
		  FieldRow              = '#FORM.FieldRow#',
	      FieldSort			    = '#FORM.FieldSort#',
		  FieldColumn           = '#FORM.FieldColumn#',
		  FieldColspan          = '#FORM.FieldColspan#',
		  FieldFilterForce      = '#form.FieldFilterForce#',
		  FieldFilterLabel      = '#form.FieldFilterLabel#',
	      FieldOutputFormat     = '#FORM.FieldOutputFormat#',
	      FieldFilterClass      = '#FORM.FieldFilterClass#',
	      FieldFilterClassMode  = '#FORM.FieldFilterClassMode#',
		  FieldFunction         = '#FORM.FieldFunction#', 
		  <cfif FieldFunction neq "">	 	  
		      FieldFunctionField      = '#FORM.FieldFunctionField#',  	   
			  FieldFunctionCondition  = '#FORM.FieldFunctionCondition#', 	  	  
		  <cfelse>
		      FieldFunctionField      = '', 
		      FieldFunctionCondition  = '', 
		  </cfif>
	      FieldEditMode 	    = '#FORM.FieldEditMode#',
	      FieldEditInputType    = '#FORM.FieldEditInputType#',
		  <cfif FORM.FieldEditTemplate neq "">
	      FieldEditTemplate     = '#FORM.FieldEditTemplate#',
		  <cfelse>
		  FieldEditTemplate     = NULL,
		  </cfif>
	      FieldTree             = #displayInTree#
	  
	WHERE  FieldId          = '#FORM.FieldId#'
	AND    SystemFunctionId = '#FORM.FunctionId#'
    AND    FunctionSerialNo = '#FORM.SerialNo#'
	
</cfquery>

<cfoutput>
  <script>  	
	parent.parent.fieldrefresh('#url.systemfunctionid#','#url.functionserialno#');
	parent.parent.ProsisUI.closeWindow('myfield',true)
  </script>
</cfoutput>