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
<cfparam name="url.accountdelegate" default="">

<cfoutput>
	
	<cfif URL.accountDelegate neq "">
					  
		<cfquery name="Delegate" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM UserNames 
		WHERE Account = '#url.accountdelegate#'
		</cfquery>
		
		<input type="text" class="regularxl" name="lookup" size="40" maxlength="40" value="#Delegate.FirstName# #Delegate.LastName#">
		
	<cfelse>
	  
	  	<input type="text" class="regularxl" name="lookup" value=""  size="40" maxlength="40" readonly >											  
	  
	</cfif>
	
	
	<input type="hidden" name="lastname">
	<input type="hidden" name="firstname">
	<input type="hidden" name="accountdelegate" value="#url.accountdelegate#" >

	<img src="#SESSION.root#/Images/delete5.gif" alt="Select item master" name="img1" 
			  onMouseOver="document.img1.src='#SESSION.root#/Images/button.jpg'" 
			  onMouseOut="document.img1.src='#SESSION.root#/Images/delete4.gif'"
			  style="cursor: pointer;" alt="" border="0" align="absmiddle" 
			  onClick="accountdelegate.value='';lookup.value=''">

</cfoutput>