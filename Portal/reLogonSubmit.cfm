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
<cfinclude template="Authent.cfm">

<cfif SESSION.authent eq "1">

	<cfset SESSION.isRelogon = "No">
	
	<script language="JavaScript">	
		  
		ProsisUI.closeWindow('relogonbox')    	   									 	  		       
		// document.getElementById('relogonbox').style.display = "none"		
		
		// we try to also close additional information in the screen 
		
		// try {
		// document.getElementById('sessionexpirationbox').style.display = "none"	} catch(e) {}
		// try {
		// document.getElementById('sessionvalid').style.display = "none"	} catch(e) {}		
		// document.getElementById('modalbg').style.display    = "none"
		
		sessionvalidatestart()
		
	</script>
	
	<font color="green">Entry accepted, please wait</font>

<cfelse>

	<!--- check how many times the user enters a wrong password 
	
	<cfset client.count = client.count+1>
	
	<cfif client.count eq "3">
	   
	    <script>
		 	 parent.window.returnValue = 9
			 parent.window.close()
		 </script>
		 
	</cfif>
	
	--->
	
	<font color="FF0000">Invalid account or password</font>
	 
</cfif>
