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

<cfset vDefault = evaluate("Form.#Code#_Default")>
<cfset vContext = evaluate("Form.#Code#_Context")>

<cfquery name="UpdateServiceItem" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_TopicServiceItem
	SET    FieldDefault 	 = '#vDefault#',
		   ShowInContext	 = '#vContext#'
	WHERE  ServiceItem       = '#URL.ID1#'		
	AND    Code			     = '#code#'
</cfquery>

<cfset URL.Code = "">
<cfinclude template="ServiceItemTopic.cfm">	