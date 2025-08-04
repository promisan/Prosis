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
<cf_textareascript>
<cfajaximport tags="cfform">

<cfoutput>
	
	<script language="JavaScript">

		function show(box,id) {
		
		se = document.getElementById("v"+box)
		
		if (se.className == "regular") {  
		  se.className = "hide" 
		} else {  
		   se.className = "regular"; 
		   url = "#SESSION.root#/vactrack/Application/Announcement/Announcement.cfm?id="+id+"&apply=1"		   
		   ptoken.navigate(url,'v'+box)		  
		}
		}
		
		function withdraw(box,id) {

			se = document.getElementById("c"+box)
		
			if (se.className == "regular") {  
			  se.className = "hide" 
			} else {  
    		  se.className = "regular"; 
		      url = "#SESSION.root#/Roster/PHP/Apply/Withdraw.cfm?id="+id+"&apply=1"
		      ptoken.navigate(url,'c'+box)
		 	}
		}
		
	   function application(id) {
		
		se = document.getElementById("a"+id)
		
		if (se.className == "regular") {  
		  se.className = "hide" 
		} else {  
		   se.className = "regular"; 
		   url = "#SESSION.root#/Roster/PHP/Apply/Apply.cfm?id="+id+"&apply=1"		   
		   ptoken.navigate(url,'a'+id)		  
		}
		}
					
	</script>

</cfoutput>