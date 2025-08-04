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

	<cfoutput>
	
	<tr class="line"><td colspan="2" class="labellarge"><span style="font-size: 24px;margin: 10px 0 6px;display: block;color: 52565B;"><cf_tl id="EMail Signature"></span></td></tr>
		
	<tr><td style="height:40px">
	<input type="checkbox" name="Pref_Signature" value="1" class="radiol" <cfif get.Pref_Signature eq "1">checked</cfif>>
	Automatically include my signature on messages that I compose.</td></tr>	
	
	<tr><td style="height:40px">
	<input type="button" name="Prepare Block" value="Propose content" onclick="_cf_loadingtexthtml='';ptoken.navigate('getSignature.cfm','processblock')" class="button10g"></td></tr>	
		
	<tr><td colspan="2">
	
		<table style="width:520px;height:180px"><tr><td style="border:1px solid silver" id="processblock">
		
		<!--- if no data we generate a draft structure based on the user and his unit so he/she can easily update it --->
	
	   	<cf_textarea height="200"  width="520"  
					color="ffffff"
					toolbar="mini"	
					init="yes"
					resize="false"
					id="signatureblock"					
					name="Pref_SignatureBlock">#Get.Pref_SignatureBlock#</cf_textarea>
					
		</td></tr></table>			
	
	</td></tr>
	
	<tr><td height="1" colspan="2">
		<cf_tl id="Save" var="vSave">
		<input type="button" onclick="updateTextArea();prefsubmit('signature')" name="Save" id="Save" value="#vSave#" class="button10g">			
	</td></tr>
	
	</cfoutput>
	
</table>	

</cfform>

</cf_divscroll>

<cfset ajaxonload("initTextArea")>

<script>
	Prosis.busy('no');	
</script>