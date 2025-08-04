<!--
    Copyright © 2025 Promisan

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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Prosis Use Case Report - All</proDes>
	<proCom>This file generates a report containing all use cases</proCom>
</cfsilent>
<!--- End Prosis template framework --->




	
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/print.css</cfoutput>" media="print"> 
</head>
<body>

	
	
<cfoutput>


<cfquery name="QClass" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM Class
		order by ClassId
</cfquery>

<cfloop query="QClass">


<cfset fname=#QClass.ClassName#>
<cfset fname=replace(fname," ","_","ALL")>



<cfdocument format="PDF" 
	pagetype="letter" 
	margintop="1"
	marginright="0.5"
	marginleft="0.5"
	marginbottom = "1" 
	unit = "in" 
	orientation = "landscape"
	bookmark="false"
	filename="pdfs/#fname#.pdf" 
	overwrite="true">

<cfdocumentsection name="#QClass.ClassName#" > 

<div align="center">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr valign="center">
<td align="center"><font size="4"><b>#QClass.ClassName#</b></font> <img src="#SESSION.root#/Images/#QClass.Image#"></td>
</tr>
<tr valign="center">
<td align="center">#QClass.ClassDescription#</td>
</tr>
<tr valign="center">
<td align="center">#QClass.ClassMemo#</td>
</tr>


<cfif #QClass.Concepts# neq "">
<tr valign="left">
<td align="left">
<b>Basic Concepts</b>
<br><br>
#QClass.Concepts#
</td>
</tr>
<tr valign="left">
<td align="left">
<b>Main functions</b>
<br><br>
#QClass.Functionality#</td>
</tr>

</cfif>

<tr valign="center">
<td align="center"><br><HR></td>
</tr>
</table>
</div>

</cfdocumentsection> 


</cfdocument>


<cfquery name="QfType" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   Code,Name
		FROM         Ref_FunctionType
		order by ListingOrder
</cfquery>


<cfloop query="Qftype">

<cfquery name="QClassFunction" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM ClassFunction
		Where ClassId='#QClass.ClassId#'
		and ClassFunctionType='#Qftype.Code#'
		order by created
</cfquery>

<cfif #QClassFunction.recordcount# neq "0">

<cfset #k#=0>


<cfdocument format="PDF" 
	pagetype="letter" 
	margintop="1"
	marginright="0.5"
	marginleft="0.5"
	marginbottom = "1" 
	unit = "in" 
	orientation = "landscape"
	bookmark="true"
	filename="pdfs/#fname#_Details_#Qftype.code#.pdf" 
	overwrite="true">

<cfloop query="QClassFunction">

<cfset #k#=#k#+1>



<cfdocumentsection name="#QClassFunction.FunctionDescription#" >

<table width="100%" border="0" cellspacing="0" cellpadding="0">


<tr>
<td height="25"><b>1. Use Case Name (No. #k#)</b></td>
</tr>

<tr>
<td align="justify">
#QClassFunction.FunctionDescription#
</td>
</tr>

<tr>
<td height="10"><hr></td>
</tr>


<tr>
<td align="justify">
#QClassFunction.FunctionReference#
</td>
</tr>



<cfquery name="ListElement" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT C.*,E.ElementDescription
    FROM ClassFunctionElement C, Ref_ClassElement E
	WHERE C.ClassFunctionId = '#QClassFunction.ClassFunctionId#' and E.ElementClass='UseCase' and
	C.ElementCode=E.ElementCode
	order by E.ListingOrder
</cfquery>
<cfset i=2>
<cfloop query="ListElement">

	<cfif #ListElement.TextContent# neq "">
		<tr>
		<td><br>&nbsp;&nbsp;&nbsp;<br></td>
		</tr>
		
		<tr>
		<td align="justify"><b>#i#. #ListElement.ElementDescription#</b></td>
		</tr>

		<tr>
		<td>#ListElement.TextContent#</td>
		</tr>		
		<cfset #i#=#i#+1>
	</cfif>
</cfloop>



<cfquery name="AttrList" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM ClassFunctionAttribute
	WHERE ClassFunctionId = '#QClassFunction.ClassFunctionId#'
	order by created 
</cfquery>

<cfif #AttrList.recordcount# neq "0">
	<tr>
	<td><br>&nbsp;&nbsp;&nbsp;<br></td>
	</tr>
	<tr>
	<td><b>#i#. Attribute(s)</b></td>
	</tr>
	<tr>
	<td>
	<table width="100%" border="1" cellspacing="0" cellpadding="0">
	<cfloop query="AttrList">
		<tr>
			<td>#trim(AttrList.Attribute)#</td>
			<td>#trim(AttrList.Format)#</td>		
			<td>
				<cfif AttrList.Required eq "0"> 
						"Yes"
				<cfelse>
						"No"
				</cfif>
				
			</td>		
			<td>#trim(AttrList.DefaultValue)#</td>				
			<td>#trim(AttrList.Description)#</td>						
			
		</tr>
		
	</cfloop>
	</table>
	</td>
	</tr>

	<cfset #i#=#i#+1>	
	
	<tr>
	<td><br>&nbsp;&nbsp;&nbsp;<br></td>
	</tr>
	<tr>
	<td><b>#i#. Usage</b></td>
	</tr>	


	<cfset dname="#QClassFunction.ClassFunctionCode#">
		
	<cfinclude template="Usage.cfm">
	
	
	<cfset #i#=#i#+1>	
</cfif>


<cfquery name="FileList" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM ClassFunctionTemplate
	WHERE ClassFunctionId = '#QClassFunction.ClassFunctionId#'
	order by created
</cfquery>


<cfif FileList.recordcount neq "0">
<tr>
<td><br>&nbsp;&nbsp;&nbsp;<br></td>
</tr>
<tr>
<td><b>#i#. Associated Template(s)</b></td>
</tr>



<cfloop query="FileList">
	<tr>
	<td>
			#trim(PathName)#<br>
			#trim(FileName)#<br>
			#trim(TemplateFunction)#<br>&nbsp;&nbsp;&nbsp;<br>
	</td>
	</tr>
</cfloop>
<cfset #i#=#i#+1>
</cfif>



<cfquery name="RoleList" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT CR.Role,R.Description
    FROM ClassFunctionRole CR, Organization.dbo.Ref_AuthorizationRole R
	WHERE ClassFunctionId = '#QClassFunction.ClassFunctionId#'
	and CR.Role=R.Role
</cfquery>

<cfif RoleList.recordcount neq "0">
<tr>
<td><br>&nbsp;&nbsp;&nbsp;<br></td>
</tr>
<tr>
<td><b>#i#. Associated role</b></td>
</tr>



<cfloop query="RoleList">
	<tr>
	<td>
			#trim(RoleList.Role)#&nbsp;&nbsp;&nbsp;- #trim(RoleList.Description)#<br>
	</td>
	</tr>
</cfloop>


</cfif>


</table>


</cfdocumentsection>

</cfloop>

</cfdocument>

</cfif>


</cfloop>




</cfloop>


</cfoutput>


