
<cfparam name="attributes.schema"    default="dbo">
<cfparam name="attributes.tablename" default="">

<cfoutput>
	<CF_DropTable dbName="#Attributes.DS_TO#"  full="1" tblName="#Attributes.tblName#">
</cfoutput>

<cfquery name="copy" 
	datasource="#Attributes.DS_TO#">
	SELECT     *
	INTO       #Attributes.tblName#
	FROM       #Attributes.FROM#.dbo.#Attributes.tblName#
</cfquery>