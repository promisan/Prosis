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

<cfparam name="form.#url.field#" default="">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="ffffff" class="formpadding">

<tr><td style="padding:4px;height:100%" class="labelit">

<cfoutput>
	<textarea bgcolor="ffffff" 
	      style="border:1px dotted silver;width:100%;height:100%;font-size:13px;padding:3px;border-radius:5px;" 
		  class="regular" id="memo_#url.field#"
		  name="memo_#url.field#">#evaluate("form.#url.field#")#</textarea>
</cfoutput>

</td></tr>

<tr><td height="28" align="center" class="labelit">

<cfoutput>

<input style="height:24;width:200" 
	type="button" 
	class="button10s" 
	value="Save and close" 
	onclick="ColdFusion.Window.hide('dialogmemo');document.getElementById('#url.field#').value=document.getElementById('memo_#url.field#').value;">

</cfoutput>

</td></tr>

<tr><td height="4"></td></tr>

</table>