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
<cfoutput>

<script>

function validateinsurance(frm,job,ven) {
	
	document.getElementById(frm).onsubmit()
		
	if( _CF_error_messages.length == 0 ) {	          
		ColdFusion.navigate('#SESSION.root#/procurement/application/quote/Insurance/InsuranceSubmit.cfm?jobno='+job+'&orgunit='+ven,'detail','','','POST',frm)
	 }   
	 
	 }

</script>

</cfoutput>