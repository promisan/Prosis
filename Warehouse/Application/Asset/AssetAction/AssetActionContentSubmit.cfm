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

<cfparam name="URL.AssetId"               default="0">
<cfparam name="URL.AssetActionId"         default="new">
<cfparam name="URL.Code"                  default="">

<cfparam name="Form.ActionDate"           default="">
<cfparam name="Form.ActionMemo"           default="">
<cfparam name="Form.ActionCategoryList"   default="">

<cfset dateValue = "">
<CF_DateConvert Value="#Form.ActionDate#">
<cfset Dte = dateValue>

<cfif URL.assetId neq "">
	
	<cfif URL.AssetActionId neq "new">
	
			<cfquery name="Clear" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    DELETE FROM AssetItemAction
			WHERE  Assetid = '#URL.AssetId#'
			AND    ActionCategory = '#URL.Code#'  
			AND    ActionCategoryList  = '#Form.ActionCategoryList#'  
			AND    ActionDate > getDate()
			AND    ActionStatus <> '9'
		</cfquery>
	
		 <cfquery name="Update" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE AssetItemAction
			  SET    ActionDate          = #dte#,
	 		         ActionMemo          = '#Form.ActionMemo#',
					 ActionCategory      = '#URL.Code#',  
					 ActionCategoryList  = '#Form.ActionCategoryList#'  
			  WHERE  AssetActionId       = '#URL.AssetActionId#'
		</cfquery>
					
	<cfelse>
	
		<cfquery name="Clear" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    DELETE FROM AssetItemAction
			WHERE  Assetid = '#URL.AssetId#'
			AND    ActionCategory = '#URL.Code#'  
			AND    ActionCategoryList  = '#Form.ActionCategoryList#'  
			AND    ActionDate > getDate()-1
			AND    ActionStatus <> '9'
		</cfquery>	   
				
		<cfquery name="Insert" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO AssetItemAction
		         (AssetId, 
				  ActionDate, 
				  ActionMemo,
				  ActionCategory,
				  ActionCategoryList,
			      OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
		      VALUES (
			      '#URL.AssetId#',
				  #dte#,
				  '#Form.actionMemo#',
				  '#URL.Code#',
				  '#Form.ActionCategoryList#', 
			      '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#') 
		</cfquery>
		
			   	
	</cfif>

</cfif>

<cfset url.assetactionid = "">
<cfinclude template="AssetActionContent.cfm">
