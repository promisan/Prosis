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

<!--- we restart the session tracker once we determine that session authent has value 1 --->

<cfparam name="SESSION.authent" default="0">

<cfif SESSION.authent eq "1">

	<script language="JavaScript">	
	  	  
	   try {
	   
	     // we restart the validation interval		
		 sessionvalidatestart()	
		 ProsisUI.closeWindow('relogonbox')    	
		 
		 } catch(e) {}
		 
		 // stop this 2nd layer process
		 sessioninitvalidatestop() 
		 
	</script>	
	
<cfelse>

	<!--- do nothing and wait for the other screens to responds with a authenticated session  --->	
		
</cfif>		

