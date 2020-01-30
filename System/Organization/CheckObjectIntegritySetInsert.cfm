
<!--- check role --->

<cfparam name="Attributes.PrimaryObject" default="">
<cfparam name="Attributes.DataSource" default="">
<cfparam name="Attributes.TableName" default="">
<cfparam name="Attributes.TableField" default="0">
<cfparam name="Attributes.SystemModule" default="">

<cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM    ObjectIntegrityStatus
	WHERE   Datasource = '#Attributes.DataSource#'
	AND     TableName  = '#attributes.TableName#'
	AND     TableField = '#attributes.TableField#'  
	AND     SystemModule = '#Attributes.SystemModule#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO ObjectIntegrityStatus
		       (PrimaryObject,
			    DataSource,
				TableName,
				TableField,
				SystemModule)
		VALUES ('#Attributes.PrimaryObject#',
		        '#Attributes.DataSource#',
				'#attributes.TableName#',
				'#attributes.TableField#',
				'#Attributes.SystemModule#')	     
	</cfquery>
	
</cfif>
