

<cfquery name="Check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ModuleControlDetailField
	WHERE  SystemFunctionId  = '#URL.SystemFunctionId#'		
	AND    FunctionSerialNo  = '#URL.FunctionSerialNo#'
	AND    FieldId = '#URL.FieldId#'
</cfquery>
	
<cfif url.fieldsort eq "1">

	<cfquery name="Detail" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE Ref_ModuleControlDetailField
		SET    FieldSort         = '0'
		WHERE  SystemFunctionId  = '#URL.SystemFunctionId#'		
		AND    FunctionSerialNo  = '#URL.FunctionSerialNo#'
		AND    FieldSort         = '1' 
	</cfquery>

</cfif>	

<cfif url.fieldsort eq "2">

	<cfquery name="Detail" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE Ref_ModuleControlDetailField
		SET    FieldSort         = '0'
		WHERE  SystemFunctionId  = '#URL.SystemFunctionId#'		
		AND    FunctionSerialNo  = '#URL.FunctionSerialNo#'
		AND    FieldSort         = '2' 
	</cfquery>

</cfif>	

<cfif url.fieldIskey eq "1">

	<cfquery name="Detail" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE Ref_ModuleControlDetailField
		SET    FieldIsKey         = '0'
		WHERE  SystemFunctionId = '#URL.SystemFunctionId#'		
		AND    FunctionSerialNo = '#URL.FunctionSerialNo#'
	</cfquery>

</cfif>	

<cfif check.recordcount eq "0">

	<cfquery name="Detail" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    INSERT INTO Ref_ModuleControlDetailField
			(SystemFunctionId, 
			 FunctionSerialNo, 
			 ListingOrder, 
			 FieldIsKey,
			 FieldInGrid,
			 FieldAlignment,
			 FieldAliasQuery, 
			 FieldName, 
			 FieldHeaderLabel, 
			 FieldWidth, 
			 FieldSort,
			 FieldOutputFormat, 
			 FieldTree,
			 FieldFilterClass, 
		     FieldFilterClassMode)
		VALUES
			('#URL.SystemFunctionId#', 
			'#URL.FunctionSerialNo#', 
			'#URL.ListingOrder#', 
			'#URL.FieldIsKey#',
			'#URL.FieldInGrid#',
			'#URL.FieldAlignment#',
			'#URL.FieldQueryAlias#',
			'#URL.FieldName#', 
			'#URL.FieldHeaderLabel#', 
			'#URL.FieldWidth#', 
			'#url.fieldSort#',
			'#URL.FieldOutputFormat#', 
			'#Url.fieldTree#',
			'#URL.FieldFilterClass#', 
		    '#URL.FieldFilterClassMode#')
	</cfquery>

<cfelse>

	<cfquery name="Detail" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE Ref_ModuleControlDetailField
		SET    ListingOrder         = '#URL.ListingOrder#', 
		       FieldInGrid          = '#URL.FieldInGrid#',
			   FieldAliasQuery      = '#URL.FieldQueryAlias#', 
		 	   FieldName            = '#URL.FieldName#', 
			   FieldHeaderLabel     = '#URL.FieldHeaderLabel#', 
			   FieldAlignment       = '#URL.FieldAlignment#',
			   FieldWidth           = '#URL.FieldWidth#', 
			   FieldSort            = '#URL.FieldSort#', 
			   FieldisKey           = '#URL.FieldisKey#',
			   FieldOutputFormat    = '#URL.FieldOutputFormat#', 
			   FieldFilterClass     = '#URL.FieldFilterClass#', 
			   FieldTree            = '#URL.FieldTree#',
	           FieldFilterClassMode = '#URL.FieldFilterClassMode#' 
		WHERE  SystemFunctionId = '#URL.SystemFunctionId#'		
		AND    FunctionSerialNo = '#URL.FunctionSerialNo#'	
		AND    FieldId = '#URL.FieldId#'
		
	</cfquery>

</cfif>

<!--- refreshing other screen boxes --->

<cfoutput>
	<script>
		ptoken.navigate('#SESSION.root#/System/Modules/InquiryBuilder/SubTable.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#','table')
		ptoken.navigate('#SESSION.root#/System/Modules/InquiryBuilder/Annotation.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#','annotation')	
	</script>
</cfoutput>

<cfinclude template="InquiryEditFields.cfm">