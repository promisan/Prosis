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
<cfquery name="Check" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Broadcast
	  WHERE  BroadcastId     = '#URL.BroadcastId#'   
</cfquery>

<cfif Check.recordcount eq "0">
	<script>
	alert("Broadcast was removed. Action aborted")
	parent.ptoken.navigate('BroadCastHistory.cfm?mode=#url.mode#','contentbox2')
	</script>
	<cfabort>
</cfif>

<cfif url.scope eq "Body">
	
	<!--- always save body --->
	<cfquery name="Broadcast" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		  UPDATE Broadcast
		   SET   BroadcastContent   = '#Form.BroadcastContent#', 
		         BroadcastSubject   = '#Form.BroadcastSubject#' 
		  WHERE  BroadcastId          = '#URL.BroadcastId#'  
	</cfquery>
	
	<cfset url.id = url.broadcastid>	
		
	<cfif ParameterExists(Form.Send) or ParameterExists(Form.SendAgain)>
	
	    <cfoutput>
		<script language="JavaScript">
			parent.ptoken.navigate('BroadCastSend.cfm?BroadcastId=#URL.BroadcastId#&mode=#url.mode#&sourcepath=#URL.sourcepath#','boxsend')			
		</script>
		</cfoutput>
		
		<cfinclude template="BroadCastBody.cfm">
		
	<cfelse>
	
		<cfinclude template="BroadCastBody.cfm">
	
	</cfif> 
	
	<cfabort>
	
<cfelse>
	
	<cfparam name = "Form.BroadcastDate" default="#now()#">
	<CF_DateConvert Value="#Form.BroadcastDate#">
	<cfset STR = dateValue>
	
	<cftry>
	
	<cfquery name="Broadcast" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		  UPDATE Broadcast
		  SET    BroadcastFrom      = '#Form.BroadcastFrom#',
			     BroadcastFailTo    = '#Form.BroadcastFailTo#',
			     BroadcastReplyTo   = '#Form.BroadCastReplyTo#',		   
			     BroadCastMailerId  = '#Form.BroadcastMailerId#',
			     BroadCastPriority  = '#Form.BroadcastPriority#',
			     BroadcastBCC       = '#Form.BroadcastBCC#',
			     BroadCastCC        = '#Form.BroadcastCC#',		 
			     <cfif form.schedule eq "0">
			       BroadcastDate    = null,
			     <cfelse>
			   	   BroadcastDate    = #STR#,
			     </cfif>	 
			     <!--- BroadcastSent      = getDate(),  --->
			     BroadcastMemo      = '#Form.BroadcastMemo#' 
		 WHERE   BroadcastId        = '#URL.BroadcastId#'  
	</cfquery>
	
	<cfcatch><font color="FF0000">Error occurred.</font></cfcatch>
	
	</cftry>
	
	<cfset url.id = url.broadcastid>	
	<cfinclude template="BroadCastOption.cfm">

</cfif>
