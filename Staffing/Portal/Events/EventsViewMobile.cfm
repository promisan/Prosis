<cfparam name="url.scope" 			default="backoffice">
<cfparam name="URL.triggercode" 	default="STAFFM">
<cfparam name="URL.mission" 		default="">

<cfif url.scope eq "portal">
	<cfset url.portal = 1>
</cfif>	

<cf_screentop label="Events and Actions"
    	height="100%" 
		scroll="yes" 
		html="No" 
		menuaccess="context" 
		actionobject="Person"
		actionobjectkeyvalue1="#url.id#"
		jQuery="Yes"
		bootstrap="Yes">
			
<cf_actionListingScript>
<cf_dialogPosition>
<cf_filelibraryscript>
<cf_calendarscript>

<cfinclude template="../../Application/Employee/Events/EventsScript.cfm">

<cfoutput>
	<script>
	
		function selectEvent(code, bg) {
			$('.clsEventButton').css('background', bg).css('opacity', 1);
			$('.btnEvent_'+code).css('background', bg).css('opacity', 0.7);
			ptoken.navigate('EventBase.cfm?mission=#url.mission#&triggercode=#url.triggercode#&personno=#url.id#&eventcode='+code,'eventBase');
		}	
		
		function selectReason(personno, mission, trigger, event, code) {
			$('.clsEventButtonReason').css('background','##EFEFEF');
			$('.btnReason_'+code).css('background','##fffdd4');
			eventportaladd(personno, 1, mission, trigger, event, code);
		}	
	
	</script>
</cfoutput>

<style>
	.x-border-box, .x-border-box * {
    	box-sizing: border-box!important;
    }
	
	.clsEventButtonReason {
		border-radius:10px; 
		padding:5px; 
		text-align:center;
		cursor:pointer;
		font-size:150%;
		background:#EFEFEF;
		border:1px solid #EFEFEF;
		margin-bottom:8px;
		padding-top:10px;
		overflow:hidden;
	}
	
	.clsEventButton {
		border-radius:10px; 
		padding:10px; 
		margin-bottom:10px; 
		text-align:center;
		cursor:pointer;
		font-size:150%;
	}
	
	.clsInstruction {
		font-size: 14px;
		padding-bottom:15px;
		padding-left:20px;
	}
	
	.clsEventMenu {
		border-right:1px solid #C0C0C0;
		border-bottom:0px; 
		height:100%;
		margin-bottom:0px;
		font-size:150%;
		position:fixed; 
		top:0; 
		overflow-y:auto; 
		padding-top:10px;
	}

</style>

<cfparam name="url.id"     default="">

<cfif url.id eq "">

	<cfquery name="qPersonEvent"
		datasource="AppsEmployee"		 
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT * 
		FROM   PersonEvent
		WHERE  EventId = '#URL.eventId#'
	</cfquery>	

	<cfset URL.Id = qPersonEvent.PersonNo>

</cfif>

<table height="100%" width="99%" align="center" border="0">		

	<tr>
		<td valign="top" style="padding-left:10px;padding-right:10px;height:100%">
			<cf_securediv id="eventdetail" bind="url:EventSelfservice.cfm?scope=#url.scope#&mission=#url.mission#&triggercode=#url.triggercode#&personno=#url.id#&portal=1" style="height:100%;padding:20px;">
		</td>
	</tr> 
     	
</table>	
