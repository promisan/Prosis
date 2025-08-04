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

<!--- deprecated

<cfparam name="Attributes.SystemFunctionId" default="0001">
<cfparam name="Attributes.ActionClass" default="undefined">
<cfparam name="Attributes.ActionType" default="undefined">
<cfparam name="Attributes.ActionReference" default="">
<cfparam name="Attributes.ActionScript" default="">

<cfquery name="Update" 
datasource="AppsSystem"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO UserAction 
    (SessionNo, ActionTimeStamp, UserAccount,
	 UserFirstName, UserLastName, UserGroup, 
     UserIndexNo, SystemFunctionId, ActionClass, ActionType,
	 ActionReference, ActionScript) 
VALUES (
    '#CLIENT.SessionNo#',
    #Now()#,
	'#SESSION.acc#', 
	'#SESSION.first#', 
    '#SESSION.last#', 
	'#CLIENT.section#', 
	'#CLIENT.indexNo#',	
	'#Attributes.SystemFunctionId#', 
    '#Attributes.actionClass#', 
	'#Attributes.actionType#', 
	'#Attributes.actionReference#',
	'#Attributes.actionScript#')
</cfquery> 

--->