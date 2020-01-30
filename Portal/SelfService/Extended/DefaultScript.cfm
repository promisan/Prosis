<cfoutput>

	<script>
	
		$(document).ready(function() {	
			
			$(window).resize(function() {
	
				if ($(window).width() <= 1630) {
					document.getElementById('panelleft').style.display = 'none';
					document.getElementById('panelright').style.display = 'none';
					$('##panelcenter').css({'left':'0px', 'right': '0px'});
				}
				else {
					document.getElementById('panelleft').style.display = 'block';
					document.getElementById('panelright').style.display = 'block';
					$('##panelcenter').css({'left':'5%', 'right': '5%'});
				}
			});
			
			_cf_loadingtexthtml="<div style='display:none'></div>";
			
			$("##logo,##detailcontent").fadeIn(800);	
			
			var myWidth = 0, myHeight = 0;
			if( typeof( window.innerWidth ) == 'number' ) {
				//Non-IE
				myWidth = window.innerWidth;
				myHeight = window.innerHeight;
			}
			else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
				//IE 6+ in 'standards compliant mode'
				myWidth  = document.documentElement.clientWidth;
				myHeight = document.documentElement.clientHeight;
			}
			else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) )	{
				//IE 4 compatible
				myWidth = document.body.clientWidth;
				myHeight = document.body.clientHeight;
			}
		
		 	if (myHeight<=750) { 
				$('##dcontent').css({'overflow-y' : 'auto'});
		    } else {
	    		$('##dcontent').css({'overflow-y' : 'hidden'});
		    }	 
				  
			if (myWidth<=1630) { 
				 	document.getElementById('panelleft').style.display = 'none';
					document.getElementById('panelright').style.display = 'none';
					$('##panelcenter').css({'left':'0px', 'right': '0px'});
				  }			   
		});	
		
		function xchangePreferences () {
			$('##preferences').slideDown(1000);
		}
		
		function xrequestAccess () {
			$("##requestaccess").slideDown(1000);
		}
		
		function xhelpWizard () {
			$("##helpwizard").slideDown(1000);
		}
		
		function xresetPassword () {
			$("##resetpassword").fadeIn(1500);
		}
		
		function passwordFadeIn () {
			$("##changepassword").fadeIn(1500);
		}
		
		function showAccountRequest () {
			$("##accountrequest").fadeIn(1500);
		}
		
		function languageswitch() {
		  ptoken.navigate('#SESSION.root#/Tools/Language/Switch.cfm?webapp=#url.id#&show=0&ID=' + document.getElementById('LanSwitch').value + '&menu=yes','lanbox')
		}
		
		function selectmission() {
		  ColdFusion.navigate('Extended/SelectMission.cfm?webapp=#url.id#&id=#url.id#&mission='+document.getElementById('mselect').value,'mission')
		}
		
		function mselectmission() {
		  ColdFusion.navigate('Extended/SelectMission.cfm?webapp=#url.id#&id=#url.id#&mission='+document.getElementById('miselect').value,'mmission')
		}	
		
		function Preferences() {
			ColdFusion.navigate('Extended/Preferences.cfm?mode=strict&id=#url.id#','balance');			
		}	
		
		function accountRequest(id) {	    
			ColdFusion.navigate('#SESSION.root#/Portal/SelfService/Extended/Account/AccountRequest.cfm?mode=strict&id='+id,'balance');	
		}
			
		function toggle(id) {
			if (id == 'logo') {
						$('##logo').fadeOut(200);
						$('##itemx').fadeOut(200);
						$('##togglelogo').fadeIn(1500);
						$("##maincontentwrapper").animate( {'top':'50px', 'bottom':'0px'}, {duration: 500});
				}
			else if (id == 'togglelogo') {
						$('##logo').fadeIn(1000);
						$('##itemx').fadeIn(1000);
						$('##togglelogo').fadeOut(500);
						$("##maincontentwrapper").animate( {'top':'125px', 'bottom':'0px'}, {duration: 500});
				}
		}
			  
	</script>

</cfoutput>