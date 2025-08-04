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


<!--- check the barcode --->

<cfparam name="url.itemNo"      default="">
<cfparam name="url.UoM"         default="">
<cfparam name="url.Mission"     default="">
<cfparam name="url.ItemBarCode" default="">

<cfif url.ItemBarCode neq "">

	<cfif url.mission eq "">
		
		<cfquery name="get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   ItemUoM
				WHERE  ItemNo      != '#url.ItemNo#'
				AND    UoM         != '#url.UoM#'
				AND    ItemBarCode = '#url.itembarcode#'
		</cfquery>	
			
		<cfif get.recordcount eq "0">
		
			<font color="green"><cf_tl id="OK"></font>
		
		<cfelse>
			
		    <font color="FF0000"><cf_tl id="Exists"></font>
			
		</cfif>
		
	<cfelse>
	
		<cfquery name="get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   ItemUoMMission
				WHERE  ItemNo      != '#url.ItemNo#'
				AND    UoM         != '#url.UoM#'
				AND    Mission      = '#url.mission#'
				AND    ItemBarCode  = '#url.itembarcode#'
		</cfquery>	
			
		<cfif get.recordcount eq "0">
		
			<font color="green"><cf_tl id="OK"></font>
		
		<cfelse>
			
		    <font color="FF0000"><cf_tl id="Exists"></font>
			
		</cfif>
	
	</cfif>

</cfif>

