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

<!--- validate barcode or decalno --->

<cfparam name="url.box"     default="BarCode_0001_001">
<cfparam name="url.field"   default="AssetBarcode">
<cfparam name="url.value"   default="">
<cfparam name="url.mission" default="">

 <cfquery name="getValue" 
    datasource="appsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT    *
    FROM      AssetItem
	WHERE     #url.field# = '#url.value#'
	AND       Mission = '#url.mission#'		
 </cfquery>
 
 <cfoutput>
 
	 <cfif getValue.recordcount gte "1">
	 
	 	<script>			   
		   document.getElementById('#url.box#').className = "wrong"
		   alert("You entered a #url.field# which already exists.")
		</script>
	 
	 <cfelse>
	 
	 	<script>	
		   document.getElementById('#url.box#').className = "regularxl"
		</script>
	 	
	 </cfif>
 
 </cfoutput>



