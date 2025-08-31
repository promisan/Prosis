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
<cfquery name="getRequest"
   datasource="AppsMaterials"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
	    SELECT  BatchNo
	    FROM    CustomerRequest 
	    WHERE   RequestNo       = '#url.RequestNo#'			  
</cfquery>

<!--- check if request still exists or if request has been turned into a sale already --->

<cfif getRequest.recordcount eq "0" 
     or getRequest.BatchNo neq "">
    <cfoutput>
    <table width="100%">
        <tr valign="top">
            <td width="20%"></td>
            <td colspan="2" style="font-family: Calibri; color: 808080; font-size:23px">
                <cf_tl id="Request is no longer available or has been posted already">
            </td>
            <td width="20%"></td>
        </tr>      
        </table>
    </cfoutput>
    <cfabort>
</cfif>