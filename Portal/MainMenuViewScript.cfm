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
<cfparam name="Module"          default="">
<cfparam name="CLIENT.personno" default="">
<cfparam name="SESSION.acc"     default="">
<cfparam name="SESSION.isAdministrator" default="">
<cfparam name="CLIENT.indexNo"  default="">

<cfif CGI.HTTPS EQ "on">
	<cfset md = "https://">
<cfelse>	
    <cfset md = "http://">
</cfif>

	<cf_tl id="Sunday"     var="sun">
	<cf_tl id="Monday"     var="mon">
	<cf_tl id="Tuesday"    var="tue">
	<cf_tl id="Wednesday"  var="wed">
	<cf_tl id="Thursday"   var="thu">
	<cf_tl id="Friday"     var="fri">
	<cf_tl id="Saturday"   var="sat">
	
	<cf_tl id="January"    var="jan">
	<cf_tl id="February"   var="feb">
	<cf_tl id="March"      var="mar">
	<cf_tl id="April"      var="apr">
	<cf_tl id="May"        var="may">
	<cf_tl id="June"       var="jun">
	<cf_tl id="July"       var="jul">
	<cf_tl id="August"     var="aug">
	<cf_tl id="September"  var="sep">
	<cf_tl id="October"    var="oct">
	<cf_tl id="November"   var="nov">
	<cf_tl id="December"   var="dec">

<cfinclude template="Logon/ThirdParty/Google/gSigninExists.cfm">
<cfinclude template="Logon/ThirdParty/Google/gScripts.cfm">

<script language="JavaScript">

		//w = width
		//c = after complete function
		function contentviewanimate (w,c) {
			if (w == "full") { var wid = "32px"}
			if (w == "reg") { var wid = "250px"}
			
			if (c != "") {
				$("#contentview").animate( {left: wid, right: "5px", "margin-left": "0%"}, {duration: 500, complete:function cmask() {$('#contentviewmask').fadeIn(300); }});
			}
			else {
				$("#contentview").animate( {left: wid, right: "5px", "margin-left": "0%"}, {duration: 500});
			}
		}
		
		var ajaxerrorhandler = function(errorCode,errorMessage){ 
			<cfif SESSION.isAdministrator neq "">
			try{
				console.log("Error Code: " + errorCode + "Error Message: " + errorMessage);
			}
			catch(e){}
			</cfif>
		}
				
		function dotimeout () {
				ColdFusion.navigate('Widgets/Weather/weather.cfm','dweatherwid','',ajaxerrorhandler);
		}
				
		$(document).ready(function() {				
			

			//Removes the CF loading image and text
			_cf_loadingtexthtml="<div style='display:none'></div>";

			<cfif find ("iPad","#CGI.HTTP_USER_AGENT#")>	
				$('#mainwrapper').css({left: '0px', right: '0px', top: '0px', bottom: '0px', width: '100%', height: '100%','display':'block'});	
			<cfelseif client.compatmode eq "yes">
				$('#mainwrapper').css({'left':'0px','right':'0px'}).fadeIn(900, function shadow () {$('#leftshadow, #rightshadow').fadeIn(500);});					
			<cfelse>
				$('#mainwrapper').fadeIn(900, function shadow() {$('#mainwrapper').addClass('mainwrappershadow');});
			</cfif>

			$('.imgfullscreen').click(function(event) {

				$('#leftpanel').css('display','none');
				$('#leftpanelmaximize').fadeIn(600);
				contentviewanimate ('full','true');
				
				if (!$(this).parent().hasClass('menuselected')) {
					selected($(this).parent().attr('id'));
				}
				
				if (document.getElementById('dtopics').style.marginTop == '0%') { 
					$('#dtopics').animate( {left: '32px', right: '5px', 'margin-left': '0%'}, {duration: 500});
				}
				event.stopPropagation();

			});
						
			
			$('.imgfullscreenmenu, .menuheader').click(function(event) {
	
					$('#leftpanel').css('display','none');
					$('#leftpanelmaximize').fadeIn(600);
					
					if (document.getElementById('contentview').style.marginLeft == '0%') { 
						contentviewanimate ('full','');
					}
					if (document.getElementById('dtopics').style.marginTop == '0%') { 
					
						if (document.getElementById('contentviewmaximize').style.display == 'block') {		
							$('#dtopics').animate( {left: '32px', right: '32px', 'margin-left': '0%'}, {duration: 500});			
						} else {
							$('#dtopics').animate( {left: '32px', right: '5px', 'margin-left': '0%'}, {duration: 500});
						}
					}
			});
						
			$('#leftpanelmaximize').click(function() {
				$('#leftpanelmaximize').css('display', 'none');
				$('#leftpanel').fadeIn(500);				
				if (document.getElementById('contentview').style.marginLeft == '0%') {
					$('#contentview').animate( {left: '250px', right: '5px', 'margin-left': '0%'}, {duration: 500, easing: 'easeOutBack'})
				}				
				if (document.getElementById('dtopics').style.marginTop == '0%') {
					if (document.getElementById('contentviewmaximize').style.display == 'block') {		
						$('#dtopics').animate( {left: '250px', right: '32px'}, {duration: 500, easing: 'easeOutBack'});			
					} else {
						$('#dtopics').animate( {left: '250px', right: '5px'}, {duration: 500, easing: 'easeOutBack'})
					}
				}
			});
						
			$('.menuitem,.qlmenutitle,#contentviewmaximize,#supportme').click(function() {
				if (document.getElementById('leftpanel').style.display == 'none') {
					if (document.getElementById('contentview').style.marginLeft != '0%') {
						contentviewanimate ('full','true');						
					}
				}				
				else if (document.getElementById('contentview').style.marginLeft != '0%') {
					contentviewanimate ('reg','true');
				}
			});

			$('#contentviewtoggle').click(function() {
				$('#contentviewmask').css('display','none');
				$('#contentview').animate( {width: 'auto','margin-left': '100%'}, {duration: 1500, easing: 'easeOutBack'});
				$('#contentviewmaximize').fadeIn(600);
				
				if (document.getElementById('dtopics').style.marginTop == '0%') {
					$('#dtopics').animate( {'margin-top': '0%', 'top': '0px', 'bottom': '0px', 'right': '32px'}, {duration: 500});	
				}
			});	
			
			$('#addfile').click(function() {
				ColdFusion.navigate('widgets/fileshelf/FileUpload.cfm','fileuploaddialog');
				$('#widmodalbg').css('display','block'); 				
				$('#fileuploaddialog').slideDown(500);				
			});			
			
			$('#dtopicstitle').click(function() {
				if (document.getElementById('dtopics').style.marginTop != '0%') {
				
						if (document.getElementById('leftpanel').style.display == 'none') {
							$('#dtopics').animate( {'margin-top': '0%', 'top': '0px', 'bottom': '0px', 'left': '32px'}, {duration: 500, complete:function cmask() {$('#itopicsviewmask').fadeIn(300); }});						
						} else {
							$('#dtopics').animate( {'margin-top': '0%', 'top': '0px', 'bottom': '0px', 'left': '250px'}, {duration: 500, complete:function cmask() {$('#itopicsviewmask').fadeIn(300); }});						
						}						
						if (document.getElementById('contentviewmaximize').style.display == 'block') {
							$('#dtopics').animate( {'margin-top': '0%', 'top': '0px', 'bottom': '0px', 'right': '32px'}, {duration: 500, complete:function cmask() {$('#itopicsviewmask').fadeIn(300); }});						
						}						
						$('#dtopicstitle').css({'top': '15px', 'z-index': '1'});
						$('#toggletopics').attr({'src' : '<cfoutput>#stylePath#</cfoutput>/images/toggle_down.png'});							
						if (document.getElementById('itopics').src == '') {
							$('#itopics').attr({'src' : '<cfoutput>#SESSION.root#</cfoutput>/Portal/Topics/PortalTopics.cfm'});			
						}						
					} else {
						$('#itopicsviewmask').css('display','none');
						$('#dtopics').animate( {'margin-top': '100%'}, {duration: 500, easing: 'easeOutBack'});
						$('#dtopicstitle').css({'top': '', 'bottom':'0px'});
						$('#toggletopics').attr({'src' : '<cfoutput>#stylePath#</cfoutput>/images/toggle_up.png'});
					}
				});
			
			// hover intent is a jQuery plugin currently nested in jQueryEasing File
			var config = {    
				over: usermenufadein, // function = onMouseOver callback (REQUIRED)    
				timeout: 900, // number = milliseconds delay before onMouseOut    
				out: usermenufadeout // function = onMouseOut callback (REQUIRED)    
			};
			$('#usermenu').hoverIntent( config )		
					
			
			// hover intent is a jQuery plugin currently nested in jQueryEasing File
			var xconfig = {    
				over: portalrightfadeout, // function = onMouseOver callback (REQUIRED)    
				timeout: 100, // number = milliseconds delay before onMouseOut    
				out: portalrightfadein, // function = onMouseOut callback (REQUIRED)    
				sensitivity: 3,
				interval: 300
			};
			$('#contentviewtoggle').hoverIntent( xconfig )	
			
			function portalrightfadein () {
				$('#contentview').fadeTo('fast',1.0);
				$('#portalright').fadeTo('fast',1.0);
			}
			
			function portalrightfadeout () {
				$('#portalright').fadeTo('fast',0.4);  
				$('#contentview').fadeTo('fast',0.4);  
			}	

		});			
		
		function widgetclose (d,id) {
			if (confirm("This will remove" +" " + d + " " + "widget from your configuration (you can always add it later).  \n Proceed?")) { 
					$('#'+d).fadeOut(800);
					if (id != '' || id != undefined) {
						ColdFusion.navigate('Widgets/WidgetEdit.cfm?delete=1&id='+id,'ajaxsubmit');
					}
			}
		}

		function filedelete (t) {
				var na = $(t).parent().parent().attr('id');
				if (confirm("This will remove" +" " + na + " " + "file from your configuration (you can always add it later).  \n Proceed?")) { 
					//ajax navigate to refresh file library to show the new file, if any
					ColdFusion.navigate("widgets/FileShelf/FileShelfContent.cfm?delete="+na,"fileshelfcontent");
				}
		}		
		
		function usermenufadeout () {
			$(this).fadeOut(500, function () {$('#toggleusermenu').removeClass('toggleusermenuactive')}); 
		}
			
		function usermenufadein () {
			$(this).fadeIn(200, function () {$('#toggleusermenu').addClass('toggleusermenuactive')});
		}		
			
		function milload (t) {
			if (typeof t === 'undefined') {
				if (document.getElementById('leftpanel').style.display == 'none') {
					if (document.getElementById('contentview').style.marginLeft != '0%') {
						contentviewanimate ('full','true');
					}
				}				
				else if (document.getElementById('contentview').style.marginLeft != '0%') {
					contentviewanimate ('reg','true');
				}
			}		
				
				$('#usermenu').fadeOut(500);
				$('#toggleusermenu').removeClass('toggleusermenuactive');
				$('#contentoptions').html(' ');
				$('.menuitem').each(function () {					
					$(this).removeClass('menuselected');						
      			});
				$('.qlmenutitle').each(function () {
					$(this).removeClass('qlmenutitleactive');
	      		});
			}
			
		function usermenu () {
			if (document.getElementById('usermenu').style.display != 'block') {
				$('#usermenu').fadeIn(1000);
				$('#toggleusermenu').addClass('toggleusermenuactive');
				
				if ($.trim($("#usermenu").text()) == "") {
					ColdFusion.navigate('MainMenuTopMenuUser.cfm?backOfficeStyle=<cfoutput>#backOfficeStyle#</cfoutput>','usermenu');
				}
			}
			else {
				$('#usermenu').fadeOut(500);
				$('#toggleusermenu').removeClass('toggleusermenuactive');
			}
		}		
		
		function togglemenu (a) {				
				$('.mitem').each(function () {
					if ($(this).parent().hasClass('menutitleactive')) {
							
							<cfif backOfficeStyle eq "HTML5">
								<cfset animHeight = "10px">
							<cfelseif backOfficeStyle eq "Standard">
								<cfset animHeight = "20px">
							</cfif>

							$(this).parent().animate( {height: '<cfoutput>#animHeight#</cfoutput>'}, {duration: 600, easing: 'easeOutBack'});
							$(this).parent().removeClass('menutitleactive');
					}
					else {			
						if (this == a) {
							$(a).parent('.menutitle').css('height','auto');
							$(a).parent('.menutitle').addClass('menutitleactive');
						}				
					}
		      	});
		}
		
		function toggleqlmenu (a) {
				$('.qlmenutitle').each(function () {
					if (this != a) {
						$(this).removeClass('qlmenutitleactive');
					}
					else {
						$(a).addClass('qlmenutitleactive');
					}
					
					$('.menuitem').each(function () {					
						$(this).removeClass('menuselected');						
	      			});
					$('#contentoptions').html(' ');
		      	});
		}
		
		function selected (b) {
				$('.menuitem').each(function () {
					if (this.id != b) {
						$(this).removeClass('menuselected');
						}
					else {
						$('#'+b).addClass('menuselected');
						}
						
					$('.qlmenutitle').each(function () {
						$(this).removeClass('qlmenutitleactive');
		      		});
		      	});
		}
		
		function selectMenu(c) {
			$('.menuitem').removeClass('mainmenu-selected');
			$('#'+c).addClass('mainmenu-selected');
		}
				
		function filedialogclose () {
			$('#widmodalbg').css('display','none');
			$('#fileuploaddialog').fadeOut(500);

			<cfoutput>
			//ajax navigate to refresh file library to show the new file, if any
			ColdFusion.navigate('widgets/FileShelf/FileShelfContent.cfm','fileshelfcontent');			
			</cfoutput>
		}
		
		function theme (th) {
		$('#csstheme').attr({href : 'css/'+th+'.css'});		
		ColdFusion.navigate('UserPrefSubmit.cfm?id=Theme&theme='+th,'ajaxsubmit');
		}
		
		function loadrightpanel(p,d) {		
			var z = encodeURIComponent(d);					
			ptoken.navigate("SubmenuExpand.cfm?module='portal'&selection='"+p+"'&modulecontrol="+z,"contentoptions");
			selectMenu(p);
		}
		
		function helpwizard(s,d,id) {
			if (s == 1) {
				$('#step1').css('display','none'); 
				$('#helpwizarddialog').animate( {'left': '300px', 'top': '80px', 'width': '350px', 'height': '250px' }, {duration: 600, complete:function fade() {$('#widmodalbg').css('display','block'); $('#step2').fadeIn(600) }})
			}
			if (s == 2) {
				$('#step2').css('display','none'); 
				$('#helpwizarddialog').animate( {'left': '250px', 'width': '400px', 'height': '300px' }, {duration: 600, complete:function fade() {$('#step3').fadeIn(600); }});
				setTimeout("$('#dtopicstitle').click()",2000);
			}
			if (s == 3) {
				$('#step3').css('display','none'); 
				$('#helpwizarddialog').css({'right': '410px', 'left': '', 'top': '40px', 'height': '230px'});
				$('#dtopicstitle').click(); 
				$('#step4').fadeIn(600);
				setTimeout("$('#toggleusermenu').click()",2000);
			}
			if (s == 4) {
				$('#toggleusermenu').click();
				$('#widmodalbg').css('display','none');
				$('#step4').css('display','none');
				$('#step1').fadeIn(800);	
				$('#helpwizarddialog').removeAttr('style').css('display','none');			
			}
			if (d == 'Delete' && id != '') {
				ColdFusion.navigate('Widgets/HelpWizard/HelpWizardSubmit.cfm?process='+d+'&id='+id,'ajaxsubmit');
			}
			if (d == 'Complete' && id != '') {
				ColdFusion.navigate('Widgets/HelpWizard/HelpWizardSubmit.cfm?process='+d+'&id='+id,'ajaxsubmit');
			}
		}
	
	<cfoutput>
								
		function exit() {
			<cfif vGoogleSigninKey neq "">
				googleLogout(function(){
					window.open("#SESSION.root#/Tools/Control/LogoutExit.cfm?time=#now()#", "_top");
				});
			<cfelse>
				window.open("#SESSION.root#/Tools/Control/LogoutExit.cfm?time=#now()#", "_top");
			</cfif>
		}

		function gohome() {
		   ptoken.open("#SESSION.root#/Portal/MainMenuView.cfm?mde=home&id=main", "_top");
		}				
				
		function review() {
		   ptoken.open("#SESSION.root#/System/EntityAction/EntityView/EntityView.cfm", "_blank")
		}
		
		function php() {
		
			<cfif #CLIENT.PersonNo# neq "">
				ptoken.open("#SESSION.root#/Staffing/Application/Employee/PersonView.cfm?ID=#CLIENT.PersonNo#","myprofile");
			<cfelse>
				alert("Sorry, but your candidate profile can't be located or is not associated to your user account. Consult your administrator")
			</cfif>
		}
		
		function leave() {
			ptoken.location('#SESSION.root#/Attendance/Application/LeaveRequest/EmployeeRequest.cfm?id=#client.personno#','portalright')
		}
		
		function edituser() {
			ptoken.open("Preferences/UserEdit.cfm", "UserDialog", "width=430, height=370, toolbar=no, scrollbars=no, resizable=no");
		}				
		
		function loadformI(name,cond,target,dir,idmenu,idrefer,reload,vir) { 
				   
		   w = #CLIENT.width# - 60;
		   h = #CLIENT.height# - 120;   
		   ih = document.body.offsetHeight-50
		      
		   if (target == "right") { target = "portalright" }
		  
		   if (dir == "") { 
		  	   if (vir == "default") { 
			   loc = name 
			   } else {
			   loc = "#md#://#CGI.HTTP_HOST#/"+vir+"/"+name }
			   
		   } else { 
		      if (vir == "default") { 
			   loc = "#SESSION.root#/"+dir+"/"+name 
			   } else {
			   loc = "#md#://#CGI.HTTP_HOST#/"+vir+"/"+dir+"/"+name
			   }
		   }	   
		   	  
		   if (reload == 1) {
		  
		   if (cond == "")
		        {    ptoken.open(loc+"?idmenu="+idmenu+"&ts="+new Date().getTime()+"&idrefer="+idrefer+"&height="+h, target,"left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes") }
		   else	{    ptoken.open(loc+"?idmenu="+idmenu+"&"+cond+"&ts="+new Date().getTime()+"&idrefer="+idrefer+"&height="+h, target,"left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes") }
		   
		   } else {
		 
		    if (cond == "") {  
			   ptoken.open(loc+"?idmenu="+idmenu+"&idrefer="+idrefer+"&height="+ih, target,"left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes") 
			} else {  
			   ptoken.open(loc+"?idmenu="+idmenu+"&"+cond+"&idrefer="+idrefer+"&height="+ih, target,"left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes") }
		   }   
				
		 } 				 
		 		
		function mycallBack(text) { }			
			var myerrorhandler = function(errorCode,errorMessage){
			alert("[In Error Handler]" + "\n\n" + "Error Code: " + errorCode + "\n\n" + "Error Message: " + errorMessage);
		}	
		
		function submitForm(frm,url) {
			ColdFusion.Ajax.submitForm(frm, url, mycallBack,myerrorhandler);
			history.go()
		}
			
//		function setting() {	
		
//		    ColdFusion.Window.create('setting', 'Settings', '',{x:100,y:100,height:500,width:600,resizable:false,modal:true,center:true})		
//			ColdFusion.Window.show('setting')		
//			ColdFusion.navigate('DashBoardSetting.cfm','setting',mycallBack,myerrorhandler)					
			
//		}
		
		function toggle(opt) {
			
			if (opt == "dashboard") {
			  window.left.location = "Dashboard/DashboardGadget.cfm"			 		  
			} else {			
			  window.left.location = "Dashboard/DashboardFavorite.cfm"					  
			}

		}
		
	<!---QUICK LINKS JS BELOW--->
		
		w = 0
		h = 0
		if (screen) {
		w = #CLIENT.width# - 55
		h = #CLIENT.height# - 120
		}
		  
		function edituser() {
		     ptoken.open("#SESSION.root#/Portal/Preferences/UserEdit.cfm?ID=#SESSION.acc#", "portalright", "width=600, height=600, status=no, toolbar=no, scrollbars=no, resizable=no");
		}
		
		function timesheet() {
		     ptoken.open("#SESSION.root#/Attendance/Application/Timesheet/Index.cfm?ID=#CLIENT.personNo#", "portalright", "width=600, height=600, status=no, toolbar=no, scrollbars=no, resizable=no");
		}
		
		function qa() {
		     ptoken.open("#SESSION.root#/System/Parameter/HelpProject/MenuTopicListing.cfm?id=#module#","right")
		}
		
		function dashboard() {
		     w = #CLIENT.width# - 50;
		     h = #CLIENT.height# - 100;
			 ptoken.open("#SESSION.root#/Portal/Dashboard/Dashboard.cfm?ts="+new Date().getTime(), "_blank", "left=20, top=20, width="+w+", height="+h+", toolbar=no, status=yes, scrollbars=yes, resizable=yes");
		}
		
		function notification() {
		   ptoken.open("#SESSION.root#/Tools/Notification/NotificationView.cfm","portalright") 
	//		$("##portalright").attr({src : "#SESSION.root#/Tools/Notification/NotificationView.cfm?ts="+new Date().getTime()});
		}
		
		function supporttickets() {
		    ptoken.open("#SESSION.root#/Portal/Topics/Support/TicketOpen.cfm?mode=menu","portalright") 
	//		$("##portalright").attr({src : "#SESSION.root#/Portal/Topics/Support/TicketOpen.cfm?mode=menu&ts="+new Date().getTime()});
		}
		
		function broadcast(fun,status) {
		     ptoken.open("#SESSION.root#/Tools/Mail/Broadcast/BroadCastView.cfm?mode=menu","portalright") 
	//		$("##portalright").attr({src : "#SESSION.root#/Tools/Mail/Broadcast/BroadCastView.cfm?mode=menu&ts="+new Date().getTime()});
		}
		
		function leaveRequest() {
		    ptoken.open("#SESSION.root#/Attendance/Application/LeaveRequest/EmployeeRequest.cfm?id=#client.personno#","portalright") 
	//		$("##portalright").attr({src : "#SESSION.root#/Attendance/Application/LeaveRequest/EmployeeRequest.cfm?id=#client.personno#&ts="+new Date().getTime()});
		}
		
		function setpassword() {
		    ptoken.open("#SESSION.root#/System/UserPassword.cfm","portalright") 
		}
		
		function html5portals(header) {
		    ptoken.open("#SESSION.root#/Portal/PortalListing.cfm?header="+header,"portalright") 
		}
		
		function favorite() {
			ptoken.open("#SESSION.root#/System/Modules/Favorite/RecordListing.cfm","portalright") 
		}
		
		function favoritereport() {
		    ptoken.open("#SESSION.root#/Portal/Dashboard/DashboardFavorite.cfm","portalright") 
		}
		
		function report() {
		    ptoken.open("#SESSION.root#/System/Modules/Subscription/RecordListing.cfm","portalright") 
		}
		
		function clearance() {
		    ptoken.open("#SESSION.root#/System/EntityAction/EntityView/MyClearances.cfm","portalright")
		}
				
	function languageswitch(lan) {    
	     ptoken.navigate('#SESSION.root#/Tools/Language/switch.cfm?ID=' + lan + '&menu=yes','ajaxsubmit') 
	}

		
	//-----------------------------------
	//BELOW IS FOR SUBMENU EXPAND OPTIONS
	//-----------------------------------  

	function loadform(dir,name,target,mod,des,sel,cond,option) {  
		    
		   if (mod == "Portal") { target = "portalright" }   
		   if (cond != "") {
		        ptoken. setSrc("#SESSION.root#/"+dir+"/"+name+"?"+cond+"&description=" + des + "&module=" + mod + "&selection=" + sel,"portalright");
		   } else {
		   		ptoken. setSrc("#SESSION.root#/"+dir+"/"+name+"?description=" + des + "&module=" + mod + "&selection=" + sel,"portalright");	
	   }
	 }
	 
	function submenuselected (d) {
		$('.submenuoptions').each(function () {
			if (this != d) {
				$(this).removeClass('submenuoptionsselected');
			}
			else {
				$(d).addClass('submenuoptionsselected');
			}
      	});
	}

	</cfoutput>	
	
	function updateClock ( ) {
		
		  var currentTime = new Date ( );
		
		  var currentHours = currentTime.getHours ( );
		  var currentMinutes = currentTime.getMinutes ( );
		  var currentSeconds = currentTime.getSeconds ( );
		  
		  var currentDay = currentTime.getDay ( );
		  var currentDayName = currentTime.getDate ( );
		  var currentMonth = currentTime.getMonth ( );
		  		
			switch(currentDay)
			{
				<cfoutput>
				case 0: currentDay = '#sun#'; break;
				case 1: currentDay = '#mon#'; break;
				case 2: currentDay = '#tue#'; break;
				case 3: currentDay = '#wed#'; break;
				case 4: currentDay = '#thu#'; break;
				case 5: currentDay = '#fri#'; break;
				case 6: currentDay = '#sat#'; break;
				</cfoutput>
			}
			
			switch(currentMonth)
			{
				<cfoutput>
				case 0: currentMonth  = '#jan#'; break;
				case 1: currentMonth  = '#feb#'; break;
				case 2: currentMonth  = '#mar#'; break;
				case 3: currentMonth  = '#apr#'; break;
				case 4: currentMonth  = '#may#'; break;
				case 5: currentMonth  = '#jun#'; break;
				case 6: currentMonth  = '#jul#'; break;
				case 7: currentMonth  = '#aug#'; break;
				case 8: currentMonth  = '#sep#'; break;
				case 9: currentMonth  = '#oct#'; break;
				case 10: currentMonth = '#nov#'; break;
				case 11: currentMonth = '#dec#'; break;
				</cfoutput>
			}

		  // Pad the minutes and seconds with leading zeros, if required
		  currentMinutes = ( currentMinutes < 10 ? "0" : "" ) + currentMinutes;
		  currentSeconds = ( currentSeconds < 10 ? "0" : "" ) + currentSeconds;
		
		  // Choose either "AM" or "PM" as appropriate
		  var timeOfDay = ( currentHours < 12 ) ? "AM" : "PM";
		
		  // Convert the hours component to 12-hour format if needed
		  currentHours = ( currentHours > 12 ) ? currentHours - 12 : currentHours;
		
		  // Convert an hours component of "0" to "12"
		  currentHours = ( currentHours == 0 ) ? 12 : currentHours;
		
		  // Compose the string for display
		  var currentTimeString = currentHours + ":" + currentMinutes + ":" + currentSeconds;
		  var currentod = timeOfDay ;
		  var currentcalendar = currentDay + " " + currentDayName + " / " + currentMonth;
		
		  // Update the time display
		  try {
		  		document.getElementById("clockinner").firstChild.nodeValue = currentTimeString;
		  		document.getElementById("tod").firstChild.nodeValue = currentod;
		  		document.getElementById("date").firstChild.nodeValue = currentcalendar;
		  }
		  catch(e){}
		}

	</script>