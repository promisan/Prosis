
<!--- Create a temporal table --->
<cfset FileNo = round(Rand()*1000)>
<cfset Answer2   = "tCollection_#SESSION.acc#_#FileNo#">
<cf_dropTable dbName="AppsQuery" tblName="#Answer2#">
<cfquery name="CreateAnswer" datasource="AppsQuery">
	CREATE TABLE userQuery.dbo.#Answer2# ( Id uniqueidentifier not null)
</cfquery>

<!--- populate the temporal table with the ID of the elements stored in the collection ---> 
<cfsearch name="indexedElements" collection="#lcase(collection.collectionname)#">

<cfloop query="indexedElements">
	<cfif Category eq 'Document'>
		<cfif Custom1 eq 'Document'>  <!--- else is an attachment --->
			<cfquery name="Insert" datasource="AppsQuery">
				INSERT INTO userQuery.dbo.#Answer2# (Id) values ('#Key#')
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="Insert" datasource="AppsQuery">
			INSERT INTO userQuery.dbo.#Answer2# (Id) values ('#Key#')
		</cfquery>
	</cfif>
</cfloop>

<!--- Elements to be removed from the collection --->
<cfquery name="ElementsPurged" datasource="AppsCaseFile">
	SELECT * FROM userQuery.dbo.#Answer2#
	WHERE Id NOT IN (SELECT ElementId from Element)
</cfquery>

<!--- Clean the collection --->
<cfloop query="ElementsPurged">
	<cfindex collection="#lcase(collection.collectionname)#" action="delete" key="#Id#" >
</cfloop>
