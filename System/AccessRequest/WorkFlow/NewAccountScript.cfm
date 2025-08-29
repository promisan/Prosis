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
<cf_dialogPosition>

<cfoutput>
	
	<script>
		
		function createAccount() {
		   
		   acc       = document.getElementById("account");
		   validate  = document.getElementById("result");
		   lastname  = document.getElementById("lastName");
		   firstname = document.getElementById("firstName");
		   
		   if (acc.value.length == 0) {
				alert('Please enter an account');
				return false;
		   }

			if (validate.value == 0){
				alert('Please enter a valid account');
				return false;
			}
			
			if (lastname.value.length == 0){
				alert('Please enter LastName');
				return false;
			}
			
			if (firstname.value.length == 0){
				alert('Please enter first name');
				return false;
			}
		
		  // document.newAccount.onsubmit() 
			//if( _CF_error_messages.length == 0 ) {
		       	ColdFusion.navigate('#SESSION.root#/System/AccessRequest/Workflow/NewAccountSubmit.cfm?acc='+acc.value+'&requestid=#object.ObjectKeyValue4#','div_submit','','','POST','newAccount')
			 //}  
			 
		 } 
	  
	</script>

</cfoutput>