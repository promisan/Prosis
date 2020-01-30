

<!--- populate table --->

<cfinclude template="CheckObjectIntegritySet.cfm">

<!--- verify missing --->

<cfquery name="List" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   ObjectIntegrityStatus
</cfquery>

<cfloop query = "List">

	<cf_verifyOperational module="#List.SystemModule#">	 

	<cfif ModuleEnabled eq "1">	  
	
		<!--- null values --->
		<cfquery name="CheckMapped" 
		datasource="#datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT count(*) as Counted 
			FROM #tableName# T
			WHERE #TableField# is NOT NULL
			<cfif PrimaryObject eq "Organization">
			AND #TableField# IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE OrgUnit = T.#TableField#)
			<cfelse>
			AND #TableField# IN (SELECT PersonNo FROM Employee.dbo.Person WHERE PersonNo = T.#TableField#)
			</cfif>		
		</cfquery>
		
		<!--- null values --->
		<cfquery name="CheckNULL" 
		datasource="#datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT count(*) as Counted 
			FROM   #tableName#
			WHERE  #TableField# is NULL
		</cfquery>
		
		<!--- 0 or blank value --->
		<cfquery name="Check0" 
		datasource="#datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT count(*) as Counted 
			FROM   #tableName#
			WHERE  #TableField# = '0' or #TableField# = ''
		</cfquery>	
			
		<!--- missing values --->
		<cfquery name="Missing" 
		datasource="#datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT count(*) as Counted 
			FROM #tableName# T
			WHERE (#TableField# is not NULL and #TableField# <> '0' and #TableField# <> '')
			<cfif PrimaryObject eq "Organization">
			AND #TableField# NOT IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE OrgUnit = T.#TableField#)
			<cfelse>
			AND #TableField# NOT IN (SELECT PersonNo FROM Employee.dbo.Person  WHERE PersonNo = T.#TableField#)
			</cfif>
		</cfquery>
		
		<cfquery name="Clear" 
			datasource="appsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM ObjectIntegrityStatusDetail
				WHERE PrimaryObject = '#PrimaryObject#'
				AND   Datasource = '#Datasource#'
				AND   TableName  = '#tableName#'
				AND   TableField = '#TableField#'		
		</cfquery>
		
		<cfif Missing.recordcount gt "0">
		
			<cfquery name="Insert" 
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO System.dbo.ObjectIntegrityStatusDetail
				(PrimaryObject,Datasource,TableName,TableField,ValueMissing)
				SELECT DISTINCT
				'#PrimaryObject#','#Datasource#','#tableName#','#TableField#',#TableField#
				FROM #tableName#
				WHERE (#TableField# is not NULL and #TableField# <> '0' and #TableField# <> '')
				<cfif PrimaryObject eq "Organization">
				AND #TableField# NOT IN (SELECT OrgUnit FROM Organization.dbo.Organization)
				<cfelse>
				AND #TableField# NOT IN (SELECT PersonNo FROM Employee.dbo.Person)
				</cfif>
			</cfquery>	
		
		</cfif>
		
		<!--- occurence values --->
		<cfquery name="Update" 
		datasource="appsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE ObjectIntegrityStatus
			SET   CountMapped   = '#checkmapped.counted#',
			      CountNULL     = '#checknull.counted#',
			      CountValue0   = '#check0.counted#',
				  CountMissing  = '#missing.counted#',
				  ValidationTimeStamp = getDate()
			WHERE PrimaryObject = '#PrimaryObject#'
			AND   Datasource = '#Datasource#'
			AND   TableName  = '#tableName#'
			AND   TableField = '#TableField#'		
		</cfquery>
	
	</cfif>
	
</cfloop>

<cfquery name="List" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   ObjectIntegrityStatus
</cfquery>

<cfsavecontent variable="mailbody">
	
	<cf_verifyOperational module="#List.SystemModule#">	 

	<cfif ModuleEnabled eq "1">	
	
		<table width="95%" align="center">
		<tr><td>
			<table width="600" cellspacing="0" cellpadding="0" class="formpadding">
			<tr>
			 <td>Module</td>
			 <td>Object</td>
			 <td>Database</td> 
			 <td>Table</td>
			 <td align="right">Mapped</td>
			 <td align="right">NULL</td>
			 <td align="right">0|Blank</td>
			 <td align="right">Not&nbsp;in&nbsp;Source</td>
			</tr> 
			<tr><td colspan="6" bgcolor="silver" height="1"></td></tr>
				<cfoutput query="List">
				<tr>
				 <td>#SystemModule#</td>
				 <td>#PrimaryObject#</td>
				 <td>#Datasource#</td>
				 <td>#tableName#.#TableField#</td>
				 <td align="right"><font color="green">#countMapped#</td>
				 <td align="right">#countNULL#</td>
				 <td align="right">#countValue0#</td>
				 <td align="right"><font color="FF0000">#countMissing#</font></td>
				</tr> 
				</cfoutput>
			</table>
		</td></tr>
		</table>
	
	</cfif>
	
</cfsavecontent>
