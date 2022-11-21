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
