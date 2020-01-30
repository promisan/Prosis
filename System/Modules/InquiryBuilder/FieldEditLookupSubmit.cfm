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