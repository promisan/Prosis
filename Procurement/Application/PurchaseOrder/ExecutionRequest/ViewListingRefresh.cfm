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
<!--- template to refresh listing in ajax mode --->
<!--- ---------------------------------------- --->

<cfparam name="url.requestid" default="">
<cfparam name="url.col" default="">

<cfquery name="Get" 
datasource="AppsPurchase" 
username="#session.login#" 
password="#session.dbpw#">
	SELECT *
	FROM PurchaseExecutionRequest
	WHERE RequestId= '#URL.RequestId#'
</cfquery>

<cfoutput>
	
	<cfswitch expression="#URL.Col#">
	
		<cfcase value="des">
			
			<cfif Get.recordcount eq "0">
			     <font color="FF0000">Removed</font>
			<cfelse>
				   #get.RequestDescription#
			</cfif>	   
					
		</cfcase>
		
		<cfcase value="ref">
		
			<cfif Get.recordcount neq "0">
			#get.Reference#
			</cfif>
			
		</cfcase>
		
		<cfcase value="amt">
		
			<cfif Get.recordcount neq "0">
			#numberformat(get.RequestAmount,"__,__.__")#
			</cfif>
			
		</cfcase>
	
	</cfswitch>

</cfoutput>