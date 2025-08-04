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
<cfoutput>

<cfparam name="FORM.Operational" default="0">

<cfif ParameterExists(Form.Update)>


	<cfquery name="Insert" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	
			UPDATE Ref_ModuleControlDetailFieldList
			SET    ListDisplay = '#FORM.ListDisplay#',
				   ListOrder   = '#FORM.ListOrder#',
				   Operational = '#FORM.Operational#'
			WHERE  SystemFunctionId 	= '#FORM.FunctionId#'
				   AND FunctionSerialNo = '#FORM.SerialNo#'
				   AND FieldId		    = '#FORM.FieldId#'
				   AND ListType		    = '#FORM.Type#'
				   AND ListValue			= '#FORM.ListValue#'
	
	</cfquery>


<cfelse>

	<cfquery name="Insert" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		    INSERT INTO Ref_ModuleControlDetailFieldList
					(SystemFunctionId, 
					 FunctionSerialNo, 
					 FieldId, 
					 ListType, 
					 ListValue, 
					 ListDisplay,
					 ListOrder, 
					 Operational,
					 Created)
			VALUES('#Form.FunctionId#',
			 		'#Form.SerialNo#',
					'#Form.FieldId#',
					'#Form.Type#',
					'#Form.ListValue#',
					'#Form.ListDisplay#',
					'#Form.ListOrder#', 
					'#Form.Operational#',
					getdate())
		 
	</cfquery>

</cfif>

<script>
	 window.location = "FieldEditLookup.cfm?FunctionId=#FORM.FunctionId#&SerialNo=#FORM.SerialNo#&FieldId=#FORM.FieldId#&Type=#FORM.Type#" 
</script>	

</cfoutput>