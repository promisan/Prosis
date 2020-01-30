<cfquery name="qDefault" 
datasource="appsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT LanguageCode 
   FROM Parameter
</cfquery>	

<cfset NAME = Evaluate("FORM.FunctionName_#qDefault.LanguageCode#")>

<cfquery name="qOriginal" 
datasource="appsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT FunctionClass, MenuClass 
	 FROM Ref_ModuleControl
	 WHERE SystemFunctionId='#FORM.ID#'
</cfquery>

<cfquery name="qDestination" 
datasource="appsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  SystemModule, FunctionClass, FunctionName, MenuClass 
	 FROM   Ref_ModuleControl
	 WHERE 	SystemModule  = '#FORM.Module#'  				AND
	 	    FunctionClass = '#qOriginal.FunctionClass#'		AND
	     	FunctionName  = '#NAME#' 						AND
	 	    MenuClass     = '#qOriginal.MenuClass#'
</cfquery>

<cfif qDestination.recordcount eq 0>
	
<!--- WE ONLY DO THE COPYING IF WE KNOW THE ALTERNATE KEY --->  	

<cfquery name="qCheck" 
datasource="appsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  LanguageCode,FunctionName,Mission,Operational 
    FROM    Ref_ModuleControl_Language
	WHERE   SystemFunctionId = '#FORM.ID#'
</cfquery>	

<cf_AssignId>
<cfset newId = rowguid>
    
<cftransaction>

		<cfquery name="qHeader" 
		datasource="appsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_ModuleControl(
			  SystemFunctionId
		      ,SystemModule
		      ,FunctionClass
		      ,FunctionName
		      ,MenuClass
		      ,MenuOrder
		      ,MainMenuItem
		      ,ApplicationServer
		      ,FunctionBackground
		      ,FunctionMemo
		      ,FunctionInfo
		      ,FunctionHost
		      ,FunctionVirtualDir
		      ,FunctionDirectory
		      ,FunctionPath
		      ,FunctionCondition
		      ,FunctionIcon
		      ,FunctionContact
		      ,ScriptName
		      ,ScriptConstant
		      ,ScriptVariable1
		      ,ScriptVariable2
		      ,ScreenWidth
		      ,ScreenHeight
		      ,FunctionTarget
		      ,EnableAnonymous
		      ,AccessDataSource
		      ,AccessRole
		      ,AccessUserGroup
		      ,AccessUser
		      ,EnforceReload
		      ,BrowserSupport
		      ,BrowserDocType
		      ,Operational
		      ,OfficerUserId
		      ,OfficerFirstName
		      ,OfficerLastName
		)
		SELECT 
			  '#newId#'	
		      ,'#Form.Module#'
		      ,FunctionClass
		      ,'#NAME#' 
		      ,MenuClass
		      ,MenuOrder
		      ,MainMenuItem
		      ,ApplicationServer
		      ,FunctionBackground
		      ,FunctionMemo
		      ,FunctionInfo
		      ,FunctionHost
		      ,FunctionVirtualDir
		      ,FunctionDirectory
		      ,FunctionPath
		      ,FunctionCondition
		      ,FunctionIcon
		      ,FunctionContact
		      ,ScriptName
		      ,ScriptConstant
		      ,ScriptVariable1
		      ,ScriptVariable2
		      ,ScreenWidth
		      ,ScreenHeight
		      ,FunctionTarget
		      ,EnableAnonymous
		      ,AccessDataSource
		      ,AccessRole
		      ,AccessUserGroup
		      ,AccessUser
		      ,EnforceReload
		      ,BrowserSupport
		      ,BrowserDocType
		      ,Operational
		      ,'#SESSION.ACC#'
		      ,'#SESSION.First#'
		      ,'#SESSION.Last#'
		FROM Ref_Modulecontrol
		WHERE SystemFunctionId='#FORM.ID#'
		</cfquery>			
		
		<cfquery name="qDetail" 
		datasource="appsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_ModuleControlDetail(
			   SystemFunctionId
		      ,FunctionSerialNo
		      ,FilterShow
		      ,QueryDataSource
		      ,PreparationScript
		      ,QueryScript
		      ,QueryTable
		      ,InsertTemplate
		      ,DrillMode
		      ,DrillFieldKey
		      ,DrillTemplate
		      ,DrillArgument
		      ,EntityCode
		      ,OfficerUserId
		      ,OfficerLastName
		      ,OfficerFirstName
		)
		SELECT '#newId#'
		      ,FunctionSerialNo
		      ,FilterShow
		      ,QueryDataSource
		      ,PreparationScript
		      ,QueryScript
		      ,QueryTable
		      ,InsertTemplate
		      ,DrillMode
		      ,DrillFieldKey
		      ,DrillTemplate
		      ,DrillArgument
		      ,EntityCode
		      ,'#SESSION.ACC#'
		      ,'#SESSION.First#'
		      ,'#SESSION.Last#'
		  FROM Ref_ModuleControlDetail
		  WHERE SystemFunctionId='#FORM.ID#'
		</cfquery>		
		
		<cfquery name="qDetailField" 
		datasource="appsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_ModuleControlDetailField(
			   SystemFunctionId
		       ,FunctionSerialNo
		       ,FieldId
		       ,ListingOrder
		       ,FieldIsKey
		       ,FieldIsAccess
		       ,FieldInGrid
		       ,FieldAliasQuery
		       ,FieldName
		       ,FieldHeaderLabel
		       ,FieldAlignment
		       ,FieldWidth
			   ,FieldRow
			   ,FieldColspan
		       ,FieldSort
		       ,FieldOutputFormat
		       ,FieldFilterForce
		       ,FieldFilterClass
		       ,FieldFilterClassMode		     
		       ,FieldFilterLookupQueryScript
		       ,FieldEditMode
		       ,FieldEditInputType
		       ,FieldEditInputQueryScript
		       ,FieldEditTemplate
		       ,FieldTree )
		SELECT '#newId#'
		      ,FunctionSerialNo
		      ,FieldId
		      ,ListingOrder
		      ,FieldIsKey
		      ,FieldIsAccess
		      ,FieldInGrid
		      ,FieldAliasQuery
		      ,FieldName
		      ,FieldHeaderLabel
		      ,FieldAlignment
		      ,FieldWidth
			  ,FieldRow
			  ,FieldColspan
		      ,FieldSort
		      ,FieldOutputFormat
		      ,FieldFilterForce
		      ,FieldFilterClass
		      ,FieldFilterClassMode		     
		      ,FieldFilterLookupQueryScript
		      ,FieldEditMode
		      ,FieldEditInputType
		      ,FieldEditInputQueryScript
		      ,FieldEditTemplate
		      ,FieldTree
		  FROM Ref_ModuleControlDetailField
		  WHERE SystemFunctionId='#FORM.ID#'
		</cfquery>
		
		<!---- LANGUAGE PORTION --->
		
		<cfloop query="qCheck">
		
		        <cfparam name="FORM.FunctionName_#qCheck.LanguageCode#" default="">
			
				<cfset FN = Evaluate("FORM.FunctionName_#qCheck.LanguageCode#")>
				
				<cfquery name="qILanguage" 
				datasource="appsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
					INSERT INTO Ref_ModuleControl_Language
					           (SystemFunctionId,
					            LanguageCode,
					            Mission,
					            Operational,
					            FunctionName,
					            FunctionMemo,
					            OfficerUserId  )
					SELECT 		'#newid#',
					            '#qCheck.LanguageCode#',
								'#qCheck.Mission#',
								'#qCheck.Operational#',
								'#FN#',
								FunctionMemo,
								'#SESSION.ACC#'
								
					FROM    Ref_ModuleControl_Language
					WHERE   SystemFunctionId  = '#FORM.ID#'
					AND     LanguageCode      = '#qCheck.LanguageCode#'	
				</cfquery>
		</cfloop>

</cftransaction>

<cfoutput>
	<script>
		alert('Inquiry has been copied succesfully.');
		$('##fcopy').hide();
		$('##options').show();
		var url = "#SESSION.ROOT#/System/Modules/Functions/RecordEdit.cfm?ID=#newid#&mission=";
		$('##link').attr("href",url);
		$('##lname').html("<font size='5'></font><b>#NAME#</b>")
	</script> 
</cfoutput>	

<cfelse>

	<cfoutput>
	<script>
		alert('Not possible to copy the listing as there is an existing listing for the module: #FORM.module#, class:#qOriginal.FunctionClass#, name: #NAME# and/or MenuClass:#qOriginal.MenuClass#" ')
	</script>
	</cfoutput>	
	
</cfif>	