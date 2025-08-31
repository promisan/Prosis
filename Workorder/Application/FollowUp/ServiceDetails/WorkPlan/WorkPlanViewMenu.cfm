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
				ptoken.navigate('#session.root#/Workorder/Application/Medical/ServiceDetails/Notification/SMTP/SMTPListing.cfm?mission=A&date='+se,'listing')
			}	 
		}				
	
	</script>

</cfoutput>