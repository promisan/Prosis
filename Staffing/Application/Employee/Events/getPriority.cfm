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
<cfparam name="URL.priority" default="">
<cfparam name="URL.eventid"  default="">

<cfif URL.eventId neq "">

	<cfquery name="CurrentEvent" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   PersonEvent
			 WHERE  EventId = '#URL.eventId#'
	</cfquery>		 

<cfelse>

	<cfquery name="CurrentEvent" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   PersonEvent
			 WHERE  1=0
	</cfquery>	
		
</cfif>	

<cfoutput>

<cfif url.priority eq "true">

   <table style="width:100%">
   <tr><td style="font-size:11px;padding-left:5px"><cf_tl id="Please provide the reason for the high priority request"></td></tr>
   <tr><td><input title="Reason for high priority" value="#CurrentEvent.EventPriorityMemo#" maxlength="80" class="regularxxl" style="background-color:ffffcf;width:99%;border:0px" name="EventPriorityMemo" id="EventPriorityMemo">
   </td></tr></table>
   
   <script>
     document.getElementById('priority1').style.backgroundColor = 'FFB164';
     document.getElementById('priority2').style.backgroundColor = 'FFB164';
   </script>

<cfelse>

   <script>
     document.getElementById('priority1').style.backgroundColor = 'ffffff';
     document.getElementById('priority2').style.backgroundColor = 'ffffff';
   </script>

   <!--- nada --->

</cfif>
</cfoutput>
