
<!--- check role --->

<cfparam name="Attributes.Object" default="Organization">
<cfparam name="Attributes.Datasource" default="">
<cfparam name="Attributes.TableName" default="">
<cfparam name="Attributes.TableField" default="">

<cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM    ObjectIntegrityStatus
	WHERE  PrimaryObject = '#Attributes.Object#'
	AND    DataSource   = '#Attributes.DataSource#'
	AND    TableName    = '#Attributes.TableName#'
	AND    TableField   = '#Attributes.TableField#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO ObjectIntegrityStatus
	       (SystemModule,
	       	PrimaryObject,
		    DataSource, 
		    TableName,
			TableField)
	VALUES ('#Attributes.SystemModule#',
			'#Attributes.Object#',
	        '#Attributes.DataSource#',
	        '#Attributes.TableName#',
			'#Attributes.TableField#')
	</cfquery>
		
</cfif>

