
<cfquery name="Clear" 
    datasource="#attributes.alias#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    DELETE FROM   Ref_ActionServiceItem
	WHERE  Code = '#attributes.Code#'  
	AND   Serviceitem IN (SELECT Code FROM ServiceItem WHERE Operational = 1)
</cfquery>

<cfloop index="itm" list="#attributes.values#">

	<cfquery name="Insert" 
	    datasource="#attributes.alias#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    INSERT INTO Ref_ActionServiceItem
		(Code,ServiceItem)
		VALUES ('#attributes.Code#','#itm#')  
	</cfquery>

</cfloop>