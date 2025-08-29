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
<cfparam name="Attributes.tablecode"   default="Organization">
<cfparam name="Attributes.mode"        default="edit">
		
<cfparam name="Attributes.Key1"   default="">
<cfparam name="Attributes.Key2"   default="">
<cfparam name="Attributes.Key3"   default="">
<cfparam name="Attributes.Key4"   default="">

<cfparam name="Attributes.Key1Old"   default="">
<cfparam name="Attributes.Key2Old"   default="">
<cfparam name="Attributes.Key3Old"   default="">
<cfparam name="Attributes.Key4Old"   default="">

<!--- generate views --->

<cfquery name="Source"
datasource="#Attributes.DataSource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM      System.dbo.LanguageSource
WHERE     TableCode = '#Attributes.TableCode#'
</cfquery>

<cfoutput query="source">

   	<cfquery name="Fields" 
	datasource="#Attributes.DataSource#"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   C.name, C.userType 
    FROM     SysObjects S, SysColumns C 
	WHERE    S.id = C.id
	AND      S.name = '#TableName#_Language'	
	ORDER BY C.ColId
	</cfquery>
			
	<cfset fld = "">
	
	<cfloop query = "Fields">
			
		<cfif #fld# eq "">
		    <cfset fld="#Name#">
		<cfelse>
		   <cfset fld="#fld#,#Name#"> 	
		</cfif>

	</cfloop>
	
	<cfquery name="Field" 
	datasource="#Attributes.DataSource#"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
    FROM    System.dbo.LanguageSourceField 
	WHERE   TableCode = '#TableName#'	
	</cfquery>
	
	<cfset i = "">
	<cfloop query = "Field">
			
			
		<cfif #i# eq "">
		    <cfset i="#TranslationField#">
		<cfelse>
		   <cfset i="#i#,#TranslationField#"> 	
		</cfif>

	</cfloop>
	   	
    <cfquery name="Merge"
	datasource="#Attributes.DataSource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO  #TableName#_Language
	(#fld#)
	SELECT
	<cfif #Attributes.Key1# neq "">
	'#Attributes.Key1#',
	</cfif>
	<cfif #Attributes.Key2# neq "">
	'#Attributes.Key2#',
	</cfif>
	<cfif #Attributes.Key3# neq "">
	'#Attributes.Key3#',
	</cfif>
	<cfif #Attributes.Key4# neq "">
	'#Attributes.Key4#',
	</cfif>
	LanguageCode,
	#i#,
	'#SESSION.acc#',
	getDate()
	FROM       dbo.#tableName#_Language TL
    WHERE 	
			#KeyFieldName# = '#Attributes.Key1Old#'
			<cfif #Attributes.Key2Old# neq "">
			AND #KeyFieldName2# = '#Attributes.Key2Old#'
			</cfif>
			<cfif #Attributes.Key3Old# neq "">
			AND #KeyFieldName3# = '#Attributes.Key3Old#'
			</cfif>
			<cfif #Attributes.Key4Old# neq "">
			AND #KeyFieldName4# = '#Attributes.Key4Old#'
			</cfif>   
	</cfquery>					  
		
</cfoutput>	  