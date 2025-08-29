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
<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM UserNames 
	WHERE Account = '#SESSION.acc#'
</cfquery>

<cf_divscroll>

<cfform onsubmit="return false" method="POST" name="formsetting">

<table width="97%" class="formpadding" align="center">

	<tr><td height="4"></td></tr>
    <tr class="line"><td colspan="2" class="labellarge"><span style="font-size: 24px;margin: 10px 0 6px;display: block;color: #52565B;"><cf_tl id="Signature"></span></td></tr>
			
	<cfoutput>	
	<tr><td colspan="2">
	
	   <iframe src="../Signature/Signature.cfm?account=#SESSION.acc#"
        width="100%"
		style="height:500px"
        frameborder="0">
	   </iframe>
	   
	</td></tr>
		
	</cfoutput>
	
</table>	

</cfform>

</cf_divscroll>

<script>
	Prosis.busy('no');	
</script>