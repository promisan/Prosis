<cfparam name="url.scope" 			default="backoffice">
<cfparam name="URL.triggercode" 	default="STAFFM">
<cfparam name="URL.mission" 		default="">

<cfif url.scope eq "portal">
	<cfset url.portal = 1>
</cfif>	

<cfajaximport tags="cfdiv,cfwindow">

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
<cf_fileLibraryscript>
<cf_calendarscript>

<cf_textareascript>

<cfinclude template="../../Application/Employee/Events/EventsScript.cfm">

<cfoutput>

	<script>
	
		function selectEvent(code, bg) {
			$('.clsEventButton').css('background', bg).css('opacity', 1);
			$('.btnEvent_'+code).css('background', bg).css('opacity', 0.7);
			ptoken.navigate('EventBase.cfm?mission=#url.mission#&triggercode=#url.triggercode#&personno=#url.id#&eventcode='+code,'eventBase');
		}	
		
		function selectReason(personno, mission, trigger, event, reason, listcode,ajaxid) {
			$('.clsEventButtonReason').css('background','##EFEFEF');
			$('.btnReason_'+listcode).css('background','##fffdd4');
			eventreason(personno, mission, trigger, event, reason, listcode,ajaxid);
		}	
		
		function eventreason(personno, mission, trigger, event, reason, listcode, ajaxid) {    		    	
	    	_cf_loadingtexthtml='';					
			ProsisUI.createWindow('evdialog', 'Request', '',{x:200,y:200,height:document.body.clientHeight-150,width:540,modal:true,resizable:true,center:true})    								
	    	ptoken.navigate('#SESSION.root#/Staffing/Portal/Events/EventForm.cfm?portal=#url.portal#&personNo='+personno+'&mission='+mission+'&trigger='+trigger+'&event='+event+'&reason='+reason+'&reasonlist='+listcode+'&ajaxid='+ajaxid,'evdialog')		 				
	    }
		
		function eventreasonsubmit(ajaxid) {
		
		   eff = document.getElementById('ActionDateEffective');
		   exp = document.getElementById('ActionDateExpiration');	
		   
		    if (eff.value == '')  {
	     		Ext.Msg.alert('Effective date', 'Please specify an effective Date.');	
    		} else if (exp.value == '') {
			    Ext.Msg.alert('Effective date', 'Please specify an expiration Date.'); 
			} else {						
		   	   ptoken.navigate('#SESSION.root#/Staffing/Portal/Events/EventFormSubmit.cfm?portal=#url.portal#&ajaxid='+ajaxid,ajaxid,'','','POST','eventform')		
			}
			   
		}
		
		function eventworkflowmail(box,row,id) {
			
			ep = document.getElementById(box+row+"Max")
			co = document.getElementById(box+row+"Min")	
			
			if (ep.className == "hide") {
			
				ep.className = "regular"
				co.className = "hide"				
			
			} else {
			
				ep.className = "hide"
				co.className = "regular"
				
				ProsisUI.createWindow(box+row, 'Messages', '',{x:200,y:200,height:document.body.clientHeight-100,width:document.body.clientWidth-200,modal:true,resizable:false,center:true})    					
			    url = "#SESSION.root#/tools/EntityAction/ActionListingViewMail.cfm?objectid="+id;
		        ptoken.navigate(url,box+row)	
				
		    }		
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

<cfquery name="qEvents" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT Code,
		       Description,
			   ActionInstruction
		FROM   Ref_PersonEvent RPE 
		WHERE  Code IN (SELECT EventCode 
		                FROM   Ref_PersonEventTrigger 
						WHERE  EventTrigger = '#url.triggercode#'
						AND    ActionImpact = 'Action')
		<cfif URL.mission neq "">
		AND    Code IN (SELECT PersonEvent 
			            FROM   Ref_PersonEventMission 
						WHERE  Mission  = '#URL.mission#')
		</cfif>		
		<cfif url.portal eq "1">
		AND    EnablePortal = 1
		</cfif>
		ORDER BY ListingOrder	
</cfquery>	

<div class="row" style="min-width:100%; width:100%; padding:4px;">

    <cfif qEvents.recordcount gte "2">
	
	<div class="col-lg-2 col-xs-4 clsEventMenu toggleScroll-y">
		<cfinclude template="EventMenu.cfm">
	</div>	
	
	<div class="col-lg-10 col-xs-8 col-lg-offset-2 col-xs-offset-4" id="eventBase" style="padding-left:20px;">	    
		<cfinclude template="EventBase.cfm">
	</div>
	
	<cfelse>
	    <DIV style="padding-left:35px">
		<cfset url.eventcode = qEvents.Code>
		<cfset url.personno = url.id>
		<cfinclude template="EventBase.cfm">
		</DIV>
		
	</cfif>

</div>