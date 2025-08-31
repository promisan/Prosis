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
