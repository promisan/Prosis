
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
			parent.ColdFusion.navigate('BroadCastSend.cfm?BroadcastId=#URL.BroadcastId#&mode=#url.mode#&sourcepath=#URL.sourcepath#','boxsend')			
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
