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

<!--- check role --->

<cfparam name="Attributes.Code" default="">
<cfparam name="Attributes.ClassEntry" default="1">
<cfparam name="Attributes.Description" default="">
<cfparam name="Attributes.PersonClass" default="">
<cfparam name="Attributes.EntityClassField" default="">
<cfparam name="Attributes.PersonReference" default="">
<cfparam name="Attributes.EntityAcronym" default="">
<cfparam name="Attributes.StandardFlow" default="Yes">
<cfparam name="Attributes.EntityTableName" default="NULL">
<cfparam name="Attributes.EntityKeyField1" default="NULL">
<cfparam name="Attributes.EntityKeyField2" default="NULL">
<cfparam name="Attributes.EntityKeyField3" default="NULL">
<cfparam name="Attributes.EntityKeyField4" default="NULL">
<cfparam name="Attributes.EntityCodeParent" default="">
<cfparam name="Attributes.EntityParameter" default="">
<cfparam name="Attributes.EnableCreate" default="0">
<cfparam name="Attributes.Operational" default="1">
<cfparam name="Attributes.ListingOrder" default="1">
<cfparam name="Attributes.ConditionAlias" default="">
<cfparam name="Attributes.ConditionScript" default="">
<cfparam name="Attributes.TemplateCreate" default="">
<cfparam name="Attributes.TemplateSearch" default="">
<cfparam name="Attributes.TemplateListing" default="">

<cfloop index="fld" from="1" to="4">

	<cfset key = evaluate("Attributes.EntityKeyField"&#fld#)>
	<cfif key neq "NULL">
	    <cfparam name="key#fld#" default="'#key#'">
	<cfelse>	
    	<cfparam name="key#fld#" default="NULL">
	</cfif>

</cfloop>

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_Entity
WHERE   EntityCode = '#Attributes.code#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_Entity
		       (EntityCode, 
			    EntityDescription,
				EntityAcronym,
				EntityTableName,
				EntityClassField,
				EntityKeyField1,
				EntityKeyField2,
				EntityKeyField3,
				EntityKeyField4,
				EntityParameter,
				Role,
				PersonClass,
				PersonReference,
				ListingOrder,
				Operational,
				ConditionAlias,
				ConditionScript,
				EnableCreate,
				TemplateCreate,
				TemplateSearch,
				TemplateListing,
				EntityCodeParent)
		VALUES ('#Attributes.code#',
		        '#Attributes.description#',
				'#Attributes.entityAcronym#',
				'#Attributes.entityTableName#',
				'#Attributes.entityClassField#',
				#preserveSingleQuotes(key1)#,
				#preserveSingleQuotes(key2)#,
				#preserveSingleQuotes(key3)#,
				#preserveSingleQuotes(key4)#,
				'#Attributes.EntityParameter#',
				'#Attributes.role#',
				'#Attributes.PersonClass#',
				'#Attributes.PersonReference#',		
				'#Attributes.ListingOrder#',	
				'#Attributes.Operational#',
				'#Attributes.ConditionAlias#',
				'#Attributes.ConditionScript#',
				'#Attributes.EnableCreate#',
				 <cfif Attributes.templatecreate neq "">
				'#Attributes.TemplateCreate#',<cfelse>NULL,</cfif>			
				 <cfif Attributes.templatesearch neq "">
				'#Attributes.TemplateSearch#',<cfelse>NULL,</cfif>	
				 <cfif Attributes.templatelisting neq "">
				'#Attributes.TemplateListing#'<cfelse>NULL</cfif>,
				 <cfif Attributes.EntityCodeParent neq "">
				'#Attributes.EntityCodeParent#'<cfelse>NULL</cfif>
				)
	</cfquery>
			
<cfelse>

    <!--- check --->
	 
	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Entity
		WHERE  EntityCode = 	'#Attributes.code#'	 
		AND    EntityTableName LIKE ('%#Attributes.EntityTableName#')
	</cfquery> 	 

	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_Entity
       SET EntityDescription = '#Attributes.description#',
	       <cfif check.recordcount eq "0">
	       EntityTableName   = '#Attributes.EntityTableName#',
		   </cfif>
		   EntityClassField  = '#Attributes.entityClassField#',
	       EntityKeyField1   = #preserveSingleQuotes(key1)#,
	       EntityKeyField2   = #preserveSingleQuotes(key2)#,
		   EntityKeyField3   = #preserveSingleQuotes(key3)#,
		   EntityKeyField4   = #preserveSingleQuotes(key4)#,
		   EntityParameter   = '#attributes.EntityParameter#', 
		   <!---
		   Operational       = '#Attributes.Operational#',
		   --->
		   Role              = '#Attributes.Role#',
		   ListingOrder      = '#Attributes.ListingOrder#',
		   <cfif Attributes.PersonClass neq "">
			   PersonClass       = '#Attributes.PersonClass#',
			   PersonReference   = '#Attributes.PersonReference#',
		   </cfif>
		   EnableCreate      = '#Attributes.EnableCreate#',
		   <cfif Attributes.templatecreate neq "">
		   TemplateCreate    = '#Attributes.TemplateCreate#',
		   <cfelse>
		   TemplateCreate    = NULL,
		   </cfif>
		   <cfif Attributes.templatesearch neq "">
		   TemplateSearch    = '#Attributes.TemplateSearch#',
		   <cfelse>TemplateSearch    = NULL,</cfif>
		   TemplateListing   = '#Attributes.TemplateListing#',
		   ConditionAlias    = '#attributes.conditionalias#',
		   ConditionScript   = '#attributes.ConditionScript#',
		    <cfif Attributes.EntityCodeParent neq "">
		   EntityCodeParent    = '#Attributes.EntityCodeParent#'
		   <cfelse>EntityCodeParent    = NULL</cfif>		   
	WHERE EntityCode = 	'#Attributes.code#'	   
	</cfquery>

</cfif>

<cftry>
	
	<cfif Attributes.ClassEntry eq "1" and 
	      Attributes.StandardFlow eq "Yes">
	
		   <cfquery name="InsertClass" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_EntityClass
			       (EntityCode, 
				    EntityClass,
					EntityClassName)
			VALUES ('#Attributes.code#',
			        'Standard',
					'Standard Workflow')
		    </cfquery>
		
	</cfif>	
		
	<cfcatch></cfcatch>	

</cftry>
