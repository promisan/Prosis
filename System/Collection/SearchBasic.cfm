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


<cfquery name = "Collection"  
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
     SELECT   *
     FROM     Collection
     WHERE    CollectionId = '#url.id#'
</cfquery>



<cfoutput>

<cfform method="POST" 
       name="querysearch" 
       onsubmit="return false">
	   
	<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td height="40">
	
			<cfinput type="Text"
			    style="font:18px;height:25" 
				name="searchtext" 
				required="No" 
				size="55" 
				maxlength="100" 
				tabindex="0" 
				class="regular"
				onKeyPress="return submitenter(this,event)">		
			
		</td>
		<td height="20" colspan="1">
	    	<button name="go" id="go" style="width:100;height:25" value="searchgo" class="button10g" onClick="do_query('','','collection','')">Search</button>
		</td>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td>
			<a href="javascript:help('#Collection.SearchEngine#',1)"><font face="Verdana" size="1.5" color="0080C0">How to search ?</a> <br>
			
			<cfif Collection.systemModule eq "Insurance">
			    <cfinclude template="CaseFile/AdvancedSearchScript.cfm">
				<a href="javascript:searchmode('CaseFile/AdvancedSearchView.cfm')"><font face="Verdana" size="1.5" color="0080C0">Advanced search</a>
			</cfif>
	    </td>
		</tr>
		
	</table>
	
</cfform>  

</cfoutput>

		