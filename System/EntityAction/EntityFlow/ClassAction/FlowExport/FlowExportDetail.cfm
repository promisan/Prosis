
<cfset vSourceDatabase = url.sourceDatabase>
<cfset vDestinationDatabase = url.destinationDatabase>
<cfset vEntityField = "EntityCode">
<cfset vEntity = url.entity>
<cfset vUnderscored = url.underscored>
<cfset vLangs = url.lang>
<cfset vBreakline = url.breakline>

<cfoutput>
	/****************************************************/ #vBreakline#
	/* The following script was automatically generated */ #vBreakline#
	/* to recreate the configuration of #vEntity# on    */ #vBreakline#
	/* a new server.                                    */ #vBreakline#
	/* PLEASE DO CHECK FIRST THAT THE CONFIGURATION IS  */ #vBreakline#
	/* CORRECT, AND THAT YOU DO HAVE A BACKUP OF THE    */ #vBreakline#
	/* PREVIOUS CONFIGURATION, BECAUSE IT IS GOING TO   */ #vBreakline#
	/* BE COMPLETELY OVERWRITTEN.                       */ #vBreakline#
	/****************************************************/ #vBreakline#
	#vBreakline##vBreakline#
</cfoutput>

<cfoutput>
	USE #ucase(vDestinationDatabase)#;
	#vBreakline##vBreakline#

	/**************************************************/ #vBreakline#
	/********** REMOVE PREVIOUS CONFIGURATION *********/ #vBreakline#
	/**************************************************/ #vBreakline#
	#vBreakline##vBreakline#
</cfoutput>


<!---  get tables to remove --->
<cfquery name="getTablesToRemove" 
	datasource="AppsOrganization">
		SELECT  * 
		FROM	#vSourceDatabase#.INFORMATION_SCHEMA.TABLES 
		WHERE   TABLE_TYPE='BASE TABLE'
		AND	   	TABLE_CATALOG = '#vSourceDatabase#'
		AND	   	TABLE_SCHEMA = 'dbo'
		AND	   	TABLE_NAME LIKE 'Ref_Entity%'
		ORDER BY TABLE_NAME DESC
</cfquery>

<!---  loop through tables --->
<cfoutput query="getTablesToRemove">

	<!---  get columns of this table --->
	<cfquery name="getColumnsToRemove" 
		datasource="AppsOrganization">
			SELECT  * 
			FROM	#vSourceDatabase#.INFORMATION_SCHEMA.COLUMNS
			WHERE   TABLE_CATALOG = '#TABLE_CATALOG#'
			AND	   	TABLE_SCHEMA = '#TABLE_SCHEMA#'
			AND	   	TABLE_NAME = '#TABLE_NAME#'
			ORDER BY ORDINAL_POSITION ASC
	</cfquery>

	<cfset vColumnsToRemove = valueList(getColumnsToRemove.COLUMN_NAME)>
	<cfset vColumnsToRemove = replace(vColumnsToRemove,",",", ", "ALL")>

	-- REMOVE #TABLE_NAME# #vBreakline#
	DELETE FROM #TABLE_NAME# #vBreakline#
	WHERE 1=1 #vBreakline#
	<cfif listContains(vColumnsToRemove, vEntityField) neq 0>
		AND #vEntityField# = '#vEntity#' #vBreakline#
	</cfif>
	<cfif listContains(vColumnsToRemove, 'ActionCode') neq 0>
		AND ActionCode IN (SELECT ActionCode FROM Ref_EntityAction WHERE #vEntityField# = '#vEntity#') #vBreakline#
	</cfif>
	<cfif listContains(vColumnsToRemove, 'DocumentId') neq 0>
		AND DocumentId IN (SELECT DocumentId FROM Ref_EntityDocument WHERE #vEntityField# = '#vEntity#') #vBreakline#
	</cfif>
	<cfif listContains(vColumnsToRemove, 'QuestionId') neq 0>
		AND QuestionId IN (SELECT QuestionId FROM Ref_EntityDocumentQuestion WHERE DocumentId IN (SELECT DocumentId FROM Ref_EntityDocument WHERE #vEntityField# = '#vEntity#')) #vBreakline#
	</cfif>
	#vBreakline# #vBreakline#

</cfoutput>

<cfoutput>
	/**************************************************/ #vBreakline#
	/************* INSERT NEW CONFIGURATION ***********/ #vBreakline#
	/**************************************************/ #vBreakline#
	#vBreakline##vBreakline#
</cfoutput>

<!---  get tables --->
<cfquery name="getTables" 
	datasource="AppsOrganization">
		SELECT  * 
		FROM	#vSourceDatabase#.INFORMATION_SCHEMA.TABLES 
		WHERE   TABLE_TYPE='BASE TABLE'
		AND	   	TABLE_CATALOG = '#vSourceDatabase#'
		AND	   	TABLE_SCHEMA = 'dbo'
		AND	   	TABLE_NAME LIKE 'Ref_Entity%'
		ORDER BY TABLE_NAME ASC
</cfquery>

<!---  REGULAR CASES --->
<!---  loop through tables --->
<cfoutput query="getTables">

	<!---  get columns of this table --->
	<cfquery name="getColumns" 
		datasource="AppsOrganization">
			SELECT  * 
			FROM	#vSourceDatabase#.INFORMATION_SCHEMA.COLUMNS
			WHERE   TABLE_CATALOG = '#TABLE_CATALOG#'
			AND	   	TABLE_SCHEMA = '#TABLE_SCHEMA#'
			AND	   	TABLE_NAME = '#TABLE_NAME#'
			ORDER BY ORDINAL_POSITION ASC
	</cfquery>

	<cfset vColumns = valueList(getColumns.COLUMN_NAME)>
	<cfset vColumns = replace(vColumns,",",", ", "ALL")>

	<!---  if the column EntityCode exists --->
	<cfif listContains(vColumns, vEntityField) neq 0>

		<!---  get the data definition for this entityCode --->
		<cfquery name="getData" 
			datasource="AppsOrganization">
				SELECT  * 
				FROM	#TABLE_CATALOG#.#TABLE_SCHEMA#.#TABLE_NAME#
				WHERE 	#vEntityField# = '#vEntity#'
				<!---  if there is a 'Created' column, then order by this field ASC --->
				<cfif listContains(vColumns, 'Created') neq 0>
					ORDER BY Created ASC
				</cfif>
		</cfquery>

		<!---  generate table name once --->
		<cfif getData.recordCount gt 0>
			-- #getTables.TABLE_NAME#
			#vBreakline# #vBreakline#
		</cfif>

		<!---  loop through all the data gotten for this entityCode on this table --->
		<cfloop query="getData">

			<!---  always insert --->
			<cfset vInsert = 1>

			<!--- do not insert if the table is a table language and the language code has NOT been selected as allowed to be generated --->
			<cfif findNoCase("_Language", getTables.TABLE_NAME) neq 0>
				<cfif listContains(vLangs, getData.LanguageCode) eq 0>
					<cfset vInsert = 0>					
				</cfif>
			</cfif>

			<!---  generate the insert statement --->
			<cfif vInsert eq 1>
				INSERT INTO #getTables.TABLE_NAME# ( #vBreakline#
						<!---  get the columns --->
						<cfset vCntColumns = 0>
						<cfloop query="getColumns">
							<!--- insert column only if underscored columns are allowed --->
							<cfset vInsertColumn = 1>
							<cfif vUnderscored eq 0 AND findNoCase("_", COLUMN_NAME) eq 1>
								<cfset vInsertColumn = 0>
							</cfif>

							<cfif vInsertColumn eq 1>
								<cfif vCntColumns neq 0>
									,
								</cfif>
								#COLUMN_NAME# #vBreakline#
								<cfset vCntColumns = vCntColumns + 1>
							</cfif>
						</cfloop>
					) #vBreakline#

				VALUES ( #vBreakline#
						<!---  get the data definition on the same order of the columns --->
						<cfset vCntColumns = 0>
						<cfloop query="getColumns">
							<!--- insert column only if underscored columns are allowed --->
							<cfset vInsertColumn = 1>
							<cfif vUnderscored eq 0 AND findNoCase("_", COLUMN_NAME) eq 1>
								<cfset vInsertColumn = 0>
							</cfif>

							<cfif vInsertColumn eq 1>
								<cfif vCntColumns neq 0>
									,
								</cfif>
								<cfset vThisVal = replace(evaluate('getData.#COLUMN_NAME#'), "'", "''", "ALL")>
								<cfif vThisVal eq '' AND DATA_TYPE eq 'uniqueidentifier'>
									NULL
								<cfelse>
									'#vThisVal#'
								</cfif>
								#vBreakline#
								<cfset vCntColumns = vCntColumns + 1>
							</cfif>
						</cfloop>
					) #vBreakline# #vBreakline#
			</cfif>
		</cfloop>
	</cfif>

</cfoutput>


<!---  SPECIAL CASES --->
<!---  loop through tables once the previous ones are generated --->
<cfoutput query="getTables">

	<!---  get columns of this table --->
	<cfquery name="getColumns" 
		datasource="AppsOrganization">
			SELECT  * 
			FROM	#vSourceDatabase#.INFORMATION_SCHEMA.COLUMNS
			WHERE   TABLE_CATALOG = '#TABLE_CATALOG#'
			AND	   	TABLE_SCHEMA = '#TABLE_SCHEMA#'
			AND	   	TABLE_NAME = '#TABLE_NAME#'
			ORDER BY ORDINAL_POSITION ASC
	</cfquery>

	<cfset vColumns = valueList(getColumns.COLUMN_NAME)>
	<cfset vColumns = replace(vColumns,",",", ", "ALL")>

	<!---  if the column EntityCode does NOT exists (SPECIAL CASES) --->
	<cfif listContains(vColumns, vEntityField) eq 0>

		<!---  get the data definition for EntityAction  --->
		<cfif findNoCase("Ref_EntityAction", getTables.TABLE_NAME) neq 0>
			<cfquery name="getData" 
				datasource="AppsOrganization">
					SELECT  * 
					FROM	#TABLE_CATALOG#.#TABLE_SCHEMA#.#TABLE_NAME#
					WHERE 	ActionCode IN (SELECT ActionCode FROM Ref_EntityAction WHERE #vEntityField# = '#vEntity#')
					<!---  if there is a 'Created' column, then order by this field ASC --->
					<cfif listContains(vColumns, 'Created') neq 0>
						ORDER BY Created ASC
					</cfif>
			</cfquery>
		</cfif>

		<!---  get the data definition for EntityDocument  --->
		<cfif findNoCase("Ref_EntityDocument", getTables.TABLE_NAME) neq 0 AND getTables.TABLE_NAME neq "Ref_EntityDocumentQuestion_Language">
			<cfquery name="getData" 
				datasource="AppsOrganization">
					SELECT  * 
					FROM	#TABLE_CATALOG#.#TABLE_SCHEMA#.#TABLE_NAME#
					WHERE 	DocumentId IN (SELECT DocumentId FROM Ref_EntityDocument WHERE #vEntityField# = '#vEntity#')
					<!---  if there is a 'Created' column, then order by this field ASC --->
					<cfif listContains(vColumns, 'Created') neq 0>
						ORDER BY Created ASC
					</cfif>
			</cfquery>
		</cfif>

		<!---  get the data definition for Ref_EntityDocumentQuestion_Language  --->
		<cfif getTables.TABLE_NAME eq "Ref_EntityDocumentQuestion_Language">
			<cfquery name="getData" 
				datasource="AppsOrganization">
					SELECT  * 
					FROM	#TABLE_CATALOG#.#TABLE_SCHEMA#.#TABLE_NAME#
					WHERE 	QuestionId IN (SELECT QuestionId FROM Ref_EntityDocumentQuestion WHERE DocumentId IN (SELECT DocumentId FROM Ref_EntityDocument WHERE #vEntityField# = '#vEntity#'))
					<!---  if there is a 'Created' column, then order by this field ASC --->
					<cfif listContains(vColumns, 'Created') neq 0>
						ORDER BY Created ASC
					</cfif>
			</cfquery>
		</cfif>

		<!---  generate only for EntityAction OR EntityDocument OR Ref_EntityDocumentQuestion_Language  --->
		<cfif findNoCase("Ref_EntityAction", getTables.TABLE_NAME) neq 0 OR findNoCase("Ref_EntityDocument", getTables.TABLE_NAME) neq 0 OR getTables.TABLE_NAME eq "Ref_EntityDocumentQuestion_Language">
			<!---  generate table name just once --->
			<cfif getData.recordCount gt 0>
				-- #getTables.TABLE_NAME#
				#vBreakline# #vBreakline#
			</cfif>

			<!---  loop through all the data gotten for this entityCode on this table --->
			<cfloop query="getData">

				<!---  always insert --->
				<cfset vInsert = 1>

				<!--- do not insert if the table is a table language and the language code has NOT been selected as allowed to be generated --->
				<cfif findNoCase("_Language", getTables.TABLE_NAME) neq 0>
					<cfif listContains(vLangs, getData.LanguageCode) eq 0>
						<cfset vInsert = 0>					
					</cfif>
				</cfif>

				<!---  generate the insert statement --->
				<cfif vInsert eq 1>
					INSERT INTO #getTables.TABLE_NAME# ( #vBreakline#
							<!---  get the columns --->
							<cfset vCntColumns = 0>
							<cfloop query="getColumns">
								<!--- insert column only if underscored columns are allowed --->
								<cfset vInsertColumn = 1>
								<cfif vUnderscored eq 0 AND findNoCase("_", COLUMN_NAME) eq 1>
									<cfset vInsertColumn = 0>
								</cfif>

								<cfif vInsertColumn eq 1>
									<cfif vCntColumns neq 0>
										,
									</cfif>
									#COLUMN_NAME# #vBreakline#
									<cfset vCntColumns = vCntColumns + 1>
								</cfif>
							</cfloop>
						) #vBreakline#

					VALUES ( #vBreakline#
							<!---  get the data definition on the same order of the columns --->
							<cfset vCntColumns = 0>
							<cfloop query="getColumns">
								<!--- insert column only if underscored columns are allowed --->
								<cfset vInsertColumn = 1>
								<cfif vUnderscored eq 0 AND findNoCase("_", COLUMN_NAME) eq 1>
									<cfset vInsertColumn = 0>
								</cfif>

								<cfif vInsertColumn eq 1>
									<cfif vCntColumns neq 0>
										,
									</cfif>
									<cfset vThisVal = replace(evaluate('getData.#COLUMN_NAME#'), "'", "''", "ALL")>
									<cfif vThisVal eq '' AND DATA_TYPE eq 'uniqueidentifier'>
										NULL
									<cfelse>
										'#vThisVal#'
									</cfif>
									#vBreakline#
									<cfset vCntColumns = vCntColumns + 1>
								</cfif>
							</cfloop>
						) #vBreakline# #vBreakline#
				</cfif>
			</cfloop>
		</cfif> 
	</cfif>


	<!---  if the column EntityCode does NOT exists (SPECIAL CASES) --->
	<cfif listContains(vColumns, vEntityField) eq 0>
		
	</cfif>

</cfoutput>

<cfset ajaxOnLoad("function() { sendToClipboard(); }")>