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
<cfparam name="URL.Id" default="">
<cfparam name="URL.ItemNo" default="">

<cfif URL.id eq "">

	<cfset URL.Id = URL.ItemNo> 
	
	<cfquery name="Item" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT *
				FROM   Item
				WHERE  ItemNo      = '#URL.ItemNo#'
	</cfquery>	
	
</cfif>	

<cfoutput>

<cfquery name="Image" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   ItemImage
		WHERE  ItemNo      = '#URL.Id#'
</cfquery>		

<cfif Image.recordcount neq 0>		
       <tr>
       <div style="height:92px;margin-left: 5px;border-bottom: 1px solid ##efefef;">
           <div style="float: left;">
              <a href="#session.rootDocument#/#Image.ImagePath#"
	             class='lightview'
               	 data-lightview-group='Items'
	             data-lightview-title="#Image.ItemNo#<br>(#Item.ItemNoExternal#)"
	             data-lightview-caption="#Item.ItemDescription#<br>#Item.Mission#"
                 data-lightview-options="skin: 'mac'">
               <img style="max-width: 120px;height:auto;border: 1px solid ##efefef;" src="#session.rootDocument#/#Image.ImagePath#" width="800" height="600">
            </a>
            </div>		
       </div>
       </tr>
</cfif>

</cfoutput>        