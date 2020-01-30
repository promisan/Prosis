
<!--- workplan view menu --->

<cfoutput>

	<script language="JavaScript">
	
		function schedule(val,mid) {
					
		    if (document.getElementById('menu').value != "schedule") {			
			   document.getElementById('menu').value            = "schedule"; 
			   document.getElementById('listingbox').className  = "hide";
			   document.getElementById('schedulebox').className = "regular";			  
			   expandArea('mybox','right');			   
			}		 
		}	
		
		function medicalcontact(val,mid) {
			document.getElementById('listingbox').className  = "regular";
		    document.getElementById('schedulebox').className = "hide";
			document.getElementById('menu').value            = "listing"; 
			collapseArea('mybox','right');
			$('##mybox_borderCENTER').show();			
			ptoken.navigate('#session.root#/Workorder/Application/Medical/ServiceDetails/WorkPlan/Action/ActionListing.cfm?mission=#url.mission#&date=#URL.date#&systemfunctionid='+mid,'listing')	   
		}
		
		function medicalrequest(val,mid) {				
		    document.getElementById('listingbox').className  = "regular";
		    document.getElementById('schedulebox').className = "hide";
			document.getElementById('menu').value            = "listing"; 
			collapseArea('mybox','right');
			$('##mybox_borderCENTER').show();	
			ptoken.navigate('#session.root#/Workorder/Application/Medical/Complaint/Listing/RequestListing.cfm?mission=#url.mission#&systemfunctionid='+mid,'listing')	   
		}
			
		function medicalaction(val,mid) {
		    document.getElementById('listingbox').className  = "regular";
		    document.getElementById('schedulebox').className = "hide";
			document.getElementById('menu').value            = "listing"; 
			collapseArea('mybox','right');		
			$('##mybox_borderCENTER').show();		
			ptoken.navigate('#session.root#/Workorder/Application/Medical/ServiceDetails/WorkPlan/ScheduleAction/ActionListing.cfm?mission=#url.mission#&systemfunctionid='+mid,'listing')	 
		}
		
		function medicalnotification(val,mid) {
			document.getElementById('listingbox').className  = "regular";
		    document.getElementById('schedulebox').className = "hide";
			document.getElementById('menu').value            = "listing"; 
			collapseArea('mybox','right');
			$('##mybox_borderCENTER').show();	
			ptoken.navigate('#session.root#/Workorder/Application/Medical/ServiceDetails/Notification/ActionListing.cfm?mission=#url.mission#&date=#URL.date#&systemfunctionid='+mid,'listing')	   
		}
		
		function medicalbilling(val,mid) {
			document.getElementById('listingbox').className  = "regular";
		    document.getElementById('schedulebox').className = "hide";
			document.getElementById('menu').value            = "listing"; 
			collapseArea('mybox','right');
			$('##mybox_borderCENTER').show();	
			ptoken.navigate('#session.root#/Workorder/Application/Medical/ServiceDetails/Charges/BillingListing.cfm?mission=#url.mission#&systemfunctionid='+mid,'listing')	    
		}	
		
		function notification(tpe) {
		
			collapseArea('mybox','right');
			$('##mybox_borderCENTER').show();	
		
			Prosis.busy('yes')
			
			if (tpe == 'sms') {
			    ptoken.navigate('#session.root#/Workorder/Application/Medical/ServiceDetails/Notification/SMS/SMSListing.cfm?mission=#url.mission#&date='+se,'mapcontent','','','POST','mapform')
			} else if (tpe == 'tts'){
			   ptoken.navigate('#session.root#/Workorder/Application/Medical/ServiceDetails/Notification/TTS/TTSListing.cfm?mission=#url.mission#&date='+se,'mapcontent','','','POST','mapform')
			}
			else if (tpe == 'smtp' || tpe=='SMTP'){
				se='';
				ptoken.navigate('#session.root#/Workorder/Application/Medical/ServiceDetails/Notification/SMTP/SMTPListing.cfm?mission=ALDANA&date='+se,'listing')
			}	 
		}				
	
	</script>

</cfoutput>