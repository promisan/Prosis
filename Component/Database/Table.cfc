<cfcomponent displayname="Table" output="false"  hint="I am the Person Class.">
	<cfproperty name="DS" type="string" default="" />
	<cfproperty name="Table" type="string" default="" />

	<cfset variables.instance = {
	DS = '', Table = '' } />
	
	<cffunction name="init"  access="remote" output="false" returntype="any">
		<cfargument name="dbname" required="true" type="String" default="" />
		<cfargument name="tbname" required="true" type="String" default="" />
				
		<cfset variables.instance.DS = dbname>
		<cfset variables.instance.Table    = tbname>
		
		<cfreturn this />
	</cffunction>
		
	<cffunction name="getStatus"  access="remote" output="false">
		<cfreturn " Status: " & variables.instance.DS  & ", " & variables.instance.Table & " Open" />
	</cffunction>	
	
	<cffunction name="getDependencies" access="public" returntype="query">
			<cfquery name="Get" 
			datasource="#variables.instance.DS#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT
				K_Table = FK.TABLE_NAME,
				FK_Column = CU.COLUMN_NAME,
				PK_Table = PK.TABLE_NAME,
				PK_Column = PT.COLUMN_NAME,
				Constraint_Name = C.CONSTRAINT_NAME
				FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
				INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
				INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
				INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME
				INNER JOIN (
				SELECT i1.TABLE_NAME, i2.COLUMN_NAME
				FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS i1
				INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE i2 ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME
				WHERE i1.CONSTRAINT_TYPE = 'PRIMARY KEY'
				) PT ON PT.TABLE_NAME = PK.TABLE_NAME
				WHERE PK.TABLE_NAME='#variables.instance.Table#'
				ORDER BY
				1,2,3,4
			</cfquery>	
			<cfreturn Get>
	</cffunction>

	<cffunction name="getFKs"  access="remote" returntype="query">
			<cfquery name="Get" 
			datasource="#variables.instance.DS#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT
				K_Table = FK.TABLE_NAME,
				FK_Column = CU.COLUMN_NAME,
				PK_Table = PK.TABLE_NAME,
				PK_Column = PT.COLUMN_NAME,
				Constraint_Name = C.CONSTRAINT_NAME
				FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
				INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
				INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
				INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME
				INNER JOIN (
				SELECT i1.TABLE_NAME, i2.COLUMN_NAME
				FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS i1
				INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE i2 ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME
				WHERE i1.CONSTRAINT_TYPE = 'PRIMARY KEY'
				) PT ON PT.TABLE_NAME = PK.TABLE_NAME
				WHERE FK.TABLE_NAME='#variables.instance.Table#'
				ORDER BY
				1,2,3,4
			</cfquery>	
			<cfreturn Get>
	</cffunction>	
	
</cfcomponent>