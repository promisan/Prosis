<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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