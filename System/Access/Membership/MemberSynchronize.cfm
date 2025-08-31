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
<cfparam name="url.reload" default="1">

<cfinvoke component="Service.Access.AccessLog"  
		  method       = "SyncGroup"
		  UserGroup    = "#URL.Role#"
		  Mode         = "Enforce"
		  UserAccount  = ""
		  Role         = "">	 
		  
<!--- still needed don't think so --->
 
<cfif url.reload eq "1">

 	 <script language="JavaScript">
	     ptoken.location('RecordListing.cfm')
	  </script>
	  
<cfelse>	 

	<script>
	Prosis.busy('no') 
	</script>

	done! <cfoutput>#timeformat(now(),"HH:MM:SS")#</cfoutput>
	
</cfif>



