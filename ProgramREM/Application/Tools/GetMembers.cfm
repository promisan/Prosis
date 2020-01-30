
<cfquery name="qMember" datasource="AppsProgram">
	SELECT P.IndexNo,P.FullName FROM
	ProgramPeriodOfficer PP,
	employee.dbo.Person P
	WHERE 
	PP.ProgramCode='PC6017'
	AND PP.PersonNo=P.PersonNo
</cfquery>


<cfset myXML = xmlNew("no")>
<cfset myXml.xmlRoot = xmlElemNew(myXml, "Hierarchy")>
<cfloop index="i" from="1" to="#qMember.recordCount#">
	<cfset myXml.xmlRoot.xmlChildren[i] = xmlElemNew(myXml, "Person")>
	<cfset myXml.xmlRoot.xmlChildren[i].xmlAttributes["Title"] = qMember.fullName[i]>
</cfloop>

<cfcontent type="text/xml">
	<cfoutput>#toString(myXml)#</cfoutput>
</cfcontent> 