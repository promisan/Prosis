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
<cfparam name="url.parent" default="">
<cfparam name="url.code"   default="">

<cfquery name="Check"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_Object 
		WHERE  ParentCode = '#url.code#'		
</cfquery>

<cfif Check.recordcount eq "0" or url.code eq "">
	
	<cfquery name="Parent"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
			FROM     #CLIENT.LanPrefix#Ref_Object R, Ref_Resource S
			WHERE    ObjectUsage = '#url.objectusage#'
			AND      R.Resource  = '#url.resource#'    
			AND      R.Resource  = S.Code
			AND      (ParentCode is NULL OR ParentCode = '')
			AND      R.Code     != '#url.code#'		
			ORDER BY S.ListingOrder, R.ListingOrder
	</cfquery>
	
	<select name="ParentCode" class="regularxl">
	   <option value="">None
	   <cfoutput query="Parent">
	   	<option value="#Code#" <cfif code eq url.parent>selected</cfif>>#Code# #Description#</option>
	    </cfoutput>
	</select>

<cfelse>

	<font face="Calibri" size="3" color="808080"><i>Code is a parent</font><input type="hidden" name="ParentCode" value="">

</cfif>