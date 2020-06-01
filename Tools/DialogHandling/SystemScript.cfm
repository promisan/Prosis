
<!--- -------------------------------------------- --->
<!--- security scripts for context related opening --->
<!--- -------------------------------------------- --->

<CFParam name="Attributes.force"  default="0">

<!--- -------------------------------------------- --->
<!--- ---------- global help slider support------- --->
<!--- -------------------------------------------- --->

<cfparam name="Attributes.Position" 		default="top">
<cfparam name="Attributes.Size" 			default="auto">
<cfparam name="Attributes.MaxSize" 			default="50%">
<cfparam name="Attributes.Time" 			default="350">
<cfparam name="Attributes.TextColor" 		default="##FFFFFF">
<cfparam name="Attributes.BackgroundColor" 	default="rgba(0,0,0,0.7)">
<cfparam name="Attributes.InitCollapsed"	default="1">
<cfparam name="Attributes.Template"			default="">

<cfset vPosition = UCASE(Attributes.Position)>
<cfset vHelpClass = "prosisHelpContainer#vPosition#">

<cfoutput>

	<style>
	
		.prosisHelpContainerDefaultColor {
			background-color:#Attributes.BackgroundColor#;
		}
		
		.prosisHelpContainerWhite {
			background-color:##FFFFFF;
		}
	
		.prosisHelpContainer {
			color:#Attributes.TextColor#;
			padding:0.5%;
			margin:0;
			overflow:auto;
			
			<cfif Attributes.InitCollapsed eq 1>
			display:none;
			</cfif>
		}
		
		.prosisHelpUndock {
			position:absolute;
			z-index:99999;
		}
		
		.prosisHelpDock {
			position:absolute;
			z-index:99999;
			max-height:250px !important;
		}
		
		.prosisHelpContainerTOP {
			top:0;left:0;
			height:#Attributes.Size#;
			max-height:#Attributes.MaxSize#;
			width:99%;
			min-width:800px; /* to avoid the breakline */
		}
		
		.prosisHelpContainerBOTTOM {
			bottom:0;left:0;
			height:#Attributes.Size#;
			max-height:#Attributes.MaxSize#;
			width:99%;
		}
		
		.prosisHelpContainerLEFT {
			top:0;left:0;
			width:#Attributes.Size#;
			max-width:#Attributes.MaxSize#;
			height:99%;
		}
		
		.prosisHelpContainerRIGHT {
			top:0;right:0;
			width:#Attributes.Size#;
			max-width:#Attributes.MaxSize#;
			height:99%;
		}
		
		.prosisHelpCenter {
			text-align:center; 
			padding-top:10px;
		}
		
		.prosisHelpLabel {
			color:##000000;
		}
		
		.prosisHelpPin {
			height:18px; 
			width:18px;
		}
		
		.prosisHelpOptionsContainer {
			margin:0;
			width:50px;
			min-height:50px;
			text-align:center;
			float:left;
			background-color:##F4F4F4;
		}
		
		.prosisHelpOptions {
		
		}
		
		##prosisHelpPresenter {
			margin:0;
			float:left;
			max-width:92%;
		}
		
	</style>

</cfoutput>
<!--- -------------------------------------- --->

<!--- a link to a cfc for assigning a number --->

<cfquery name="param" 
	datasource="AppsInit">
	SELECT  * 
	FROM    Parameter
	WHERE   HostName           = '#CGI.http_host#'				
</cfquery>		
	
<cfif param.URLProtectionMode eq "0" or attributes.force eq "1">	
	<!--- code to bypass the token method and revert to regular openings --->
		
	<script language="JavaScript">
	
		function Security(){}

		function doWindowOpen(p1,p2,p3,p4) {
				if (p3 && p4) {
					window.open(p1, p2, p3, p4);
				}
				else if (p3) {
					window.open(p1, p2, p3);
					}
					else {
					window.open(p1, p2);
					}			
		
		}
		
		function doWindowArguments(p1,p2,p3,p4)	{
			var win;
			if (p3 && p4)
				win = dialogArguments.window.open(p1, p2, p3, p4);	
			else if (p3)
				win = dialogArguments.window.open(p1, p2, p3);	
			else 
				win = dialogArguments.window.open(p1, p2);	
				
				
			return win;
			
		}
		
		Security.prototype.open = function(p1,p2,p3,p4)	{

			if (window.dialogArguments) {
				try{	
						var win = doWindowArguments(p1,p2,p3,p4);
						win.opener = window;
				}
				catch(ex){
					doWindowOpen(p1,p2,p3,p4);
				}	
			} else  {
				doWindowOpen(p1,p2,p3,p4)	
			}
			
		}	
		
		Security.prototype.location = function(p1,p2) {
		  if (p2) {				
			switch (p2) {
				case 'parent.right': 
						parent.right.location = p1;										
						parent.right.focus();											
						break;
				case 'parent.left':
						parent.left.location = p1;										
						parent.left.focus();											
						break;											
				case 'parent.window':
						parent.window.location = p1;										
						parent.window.focus();											
						break;	
				case 'window.contentframe':
						window.contentframe.location = p1;										
						window.contentframe.focus();											
						break;					
				case 'portalright':
						window.portalright.location = p1;										
						window.portalright.focus();											
						break;
												
			} 
			
			} else {	

				window.location = p1;				
				window.focus();							
			}			
		
		}
		
		Security.prototype.navigate = function(p1,p2,p3,p4,p5,p6) {
			//ColdFusion.navigate(p1, p2, p3, p4, p5, p6);
			if (typeof (p3) != 'function') {
				ColdFusion.navigate(p1, p2, function () {
					if ($.trim(p3) != '' && $.trim(p3).toLowerCase() != 'null') {
						window[p3]();
					}
				}, p4, p5, p6);
			}
			else
			{
				ColdFusion.navigate(p1, p2,p3, p4, p5, p6);
			}
		}

		Security.prototype.submit = function(p1,p2,p3) {
			document.getElementById(p3).action = p1;
			document.getElementById(p3).submit();
		}

		Security.prototype.setSrc = function(p1,p2) {
			$('#'+p2).attr('src',p1);
		}
		
		Security.prototype.submitForm = function(p1,p2,p3,p4,p5,p6) {
			ColdFusion.navigate(p1, p2, function() { 
				if ($.trim(p3) != '' && $.trim(p3).toLowerCase() != 'null') { 
					window[p3](); 
				} 
			}, p4, p5, p6);
		}		
				
		var ptoken = new Security;
			
	</script>	

<cfelse>	
		
	<cfajaxproxy cfc="service.process.system.security" jsclassname="systemsecurity">

	<script language="JavaScript">	

		var ptoken = new systemsecurity();
				
		ptoken.setCallbackHandler(setHandler); 
		ptoken.setErrorHandler(errorHandler); 	
			
		///Wrapper call back
				
		function setHandler(resp) {
 
			var aresponse = resp.split("~");		
												
			switch (aresponse[0]) {		
			
				case 'open'	:				    
				    
					if (window.dialogArguments) {
						try 		{
							var win = dialogArguments.window.open(aresponse[1], aresponse[2], aresponse[3], aresponse[4]);							
							win.opener = window;								
						} 
						catch (ex) 	{window.open(aresponse[1], aresponse[2], aresponse[3], aresponse[4]); }
					} else {
					   
						window.open(aresponse[1], aresponse[2], aresponse[3], aresponse[4]);
					}	
				    break;
					
				case 'location':
				    if (aresponse[2] != "") {		
						
						switch (aresponse[2]) {
							case 'parent.right': 
									parent.right.location = aresponse[1];										
									parent.right.focus();											
									break;
							case 'parent.left':
									parent.left.location = aresponse[1];										
									parent.left.focus();											
									break;											
							case 'parent.window':
									parent.window.location = aresponse[1];										
									parent.window.focus();											
									break;	
							case 'window.contentframe':
									window.contentframe.location = aresponse[1];										
									window.contentframe.focus();											
									break;	
							case 'portalright':
									window.portalright.location = aresponse[1];																				
									window.portalright.focus();											
									break;													
						} 
										
					} else {		
										   						
						window.location = aresponse[1];				
						window.focus();							
					}
					
					break;					
									
				case 'navigate':
								   
					if ($.trim(aresponse[3]) != '' && $.trim(aresponse[3]).toLowerCase() != 'null')	{
						ColdFusion.navigate(aresponse[1], aresponse[2], function() { 
							if ($.trim(aresponse[3]) != '' && $.trim(aresponse[3]).toLowerCase() != 'null') { 
								window[aresponse[3]](); 
						} 
						}, aresponse[4], aresponse[5], aresponse[6]);				
					}
					else
						ColdFusion.navigate(aresponse[1], aresponse[2],'', aresponse[4], aresponse[5], aresponse[6]);	
		
					break;	

				case 'submit':
					document.getElementById(aresponse[3]).action = aresponse[1];
					document.getElementById(aresponse[3]).submit();						
					break;	
					
				case 'setSrc':
					$('#'+aresponse[2]).attr('src',aresponse[1]);
					break;
					
				case 'submitForm':
															    					
					if ($.trim(aresponse[5]) != '' && $.trim(aresponse[4]).toLowerCase() != 'null')	{						   
						ColdFusion.Ajax.submitForm(aresponse[1], aresponse[2], aresponse[3], aresponse[4], aresponse[5], aresponse[6]);				
					}
					else
						ColdFusion.Ajax.submitForm(aresponse[1], aresponse[2]);	
				
					break;
								
			}		
			
		}
		
		// Error handler for the asynchronous functions 
		function errorHandler(statusCode,statusMsg) {
		     alert(statusCode+': '+statusMsg)
		}

	</script>
	
	
</cfif>	


<script language="JavaScript">

	//******************************************************************************************************************
	//Check JQuery version
	function checkAndReloadJQueryVersion() {
		if (!!window.jQuery) {
			var vJQVersion = $.fn.jquery.split('.');
			if (parseInt(vJQVersion[0]) > 1 || (parseInt(vJQVersion[0]) == 1 && parseInt(vJQVersion[1]) >= 7)) {
				//console.log('all good with jQuery');
			}else {
				//reload jquery 1.9
				console.log('reload');
				jQuery.ajax({
				    async:false,
				    type:'GET',
				    url:'<cfoutput>#session.root#/Scripts/jQuery/jquery.js?ts=#getTickCount()#</cfoutput>',
				    data:null,
				    success:function() {},
				    dataType:'script',
				    error: function(xhr, textStatus, errorThrown) {
				        console.log(errorThrown);
				    }
				});
			}
		}
	}
	checkAndReloadJQueryVersion();
	//******************************************************************************************************************
	
	// Script for field length
	
	function ismaxlength(obj) {	

	var mlength=obj.getAttribute? parseInt(obj.getAttribute("totlength")) : ""						
	if (obj.getAttribute && obj.value.length>mlength) {	
	    obj.value=obj.value.substring(0,mlength) 
		alert("You exceeded the "+mlength+" allowed charactors in this field.")}		
	}
	
	function navEnterNext() {	   
		if(window.event) {			   		    		   
		    if (event.keyCode==13) {this.event.keyCode=9; return this.event.keyCode}								
		} else {				    
		    if (event.which==13)   {this.event.which=9;   return this.event.which}					
		}		
	}
	
	function workflowobjectopen(val) {
	   	ptoken.open("<cfoutput>#SESSION.root#</cfoutput>/ActionView.cfm?id="+val,val);				
	
	}
	
	// Script for global support ticket
	
	function supportticket(mid,module,mis) {			   		
		ptoken.open("<cfoutput>#SESSION.root#</cfoutput>/System/Modification/DocumentEntry.cfm?systemfunctionid="+mid+"&systemmodule="+module+"&observationclass=inquiry&context=status&mission="+mis, "supportticket");				
	}	
	
	function amendmentticket(mid,module,mis) {			   		
		ptoken.open("<cfoutput>#SESSION.root#</cfoutput>/System/Modification/DocumentEntry.cfm?systemfunctionid="+mid+"&systemmodule="+module+"&observationclass=amendment&context=status&mission="+mis, "supportticket");
	}	
	
	function supportticketedit(id) {		   	   			
		ptoken.open("<cfoutput>#SESSION.root#</cfoutput>/System/Modification/DocumentView.cfm?drillid="+id, id);				
	}	
	
	function supportconfig(mid) {		       		
		ptoken.open("<cfoutput>#SESSION.root#</cfoutput>/System/Modules/Functions/RecordEdit.cfm?id="+mid+"&context=window", "supportconfig", "left=40, top=40, width=1100,height=905, status=yes, scrollbars=no, resizable=no");				
	}	
		
	// Script for global validation	
	function processvalidation(actionid,destination) {		
	    ptoken.open("<cfoutput>#SESSION.root#</cfoutput>/Component/Validation/windowValidation.cfm?validationactionid="+actionid+"&destination="+destination,"val"+destination)
	}	
			
	function validationsubmit() {	   
		document.getElementById('validationrefresh').click()		
		window.close()			
	}
	
	// Script for global language
		
	function tl_edit(cls,id,box) {						
		window.open("<cfoutput>#SESSION.root#</cfoutput>/tools/language/TL_edit.cfm?box="+box+"&cls="+cls+"&clsid="+id,"_blank", "width=430, height=400, status=yes, toolbar=no, scrollbars=no, resizable=no");		   			
	}	
	
	// Script for help slider support 
	<cfoutput>
	
		function setProsisHelpTop() {
			var vTop = 0;
			
			if ($('##screentopbox').length > 0) {
				if ($('##screentopbox').is(':visible')) {
					vTop = $('##screentopbox').height();
				}
			}
			
			$('.prosisHelpContainerTOP').css('top', vTop);
		}
	
		function setProsisHelpOptionsHeight() {
			var vHeight = $('##prosisHelpPresenter').height();
			$('.prosisHelpOptionsContainer').css('height', vHeight);
		}
		
		function toggleProsisHelp() {
			if ($('##cbProsisHelpPin').is(':checked') && $('.#vHelpClass#').is(':visible')) {
				//Nothing
			} else {
				if ('#vPosition#' == 'TOP' || '#vPosition#' == 'BOTTOM') {
					$('.#vHelpClass#').animate({height:'toggle'},#Attributes.Time#, function(){
						setProsisHelpOptionsHeight();
					});
				}
				if ('#vPosition#' == 'LEFT' || '#vPosition#' == 'RIGHT') {
					$('.#vHelpClass#').animate({width:'toggle'},#Attributes.Time#);
				}
			}
		}
		
		function showProsisHelp() {
			if (!$('.#vHelpClass#').is(':visible')) {
				$('.#vHelpClass#').css('display','none');
				toggleProsisHelp();
			}
		}
		
		function hideProsisHelp() {
			if ($('.#vHelpClass#').is(':visible')) {
				$('.#vHelpClass#').css('display','block');
				toggleProsisHelp();
			}
		}
		
		function setProsisHelp(template,callback) {
			window.__prosisHelpCallbackFunction = function() {
				setProsisHelpOptionsHeight();
				if (!!callback) {
					callback();
				}
			}
			setProsisHelpTop();
			_cf_loadingtexthtml = '';
			ptoken.navigate(template,'prosisHelpPresenter','__prosisHelpCallbackFunction',null,null,null);
		}
		
		function setTextProsisHelp(text, callback){
			$('##prosisHelpPresenter').html(text);
			if (!!callback) {
				callback();
			}
			setProsisHelpTop();
			setProsisHelpOptionsHeight();
		}
		
		function enableProsisHelpCloseOnOutClick(){
			$('body').off('click');
			$('body').on('click',function(){
	 			hideProsisHelp();
 			});
		}
		
		function disableProsisHelpCloseOnOutClick(){
			$('body').off('click');
		}
		
		function pinUnpinProsisHelp(val) {
			if (!val) {
				enableProsisHelpCloseOnOutClick();
				$('.prosisHelpContainer').removeClass('prosisHelpDock').addClass('prosisHelpUndock');
				$('.prosisHelpContainer').removeClass('prosisHelpContainerWhite').addClass('prosisHelpContainerDefaultColor');
			}else{
				disableProsisHelpCloseOnOutClick();
				$('.prosisHelpContainer').removeClass('prosisHelpUndock').addClass('prosisHelpDock');
				$('.prosisHelpContainer').removeClass('prosisHelpContainerDefaultColor').addClass('prosisHelpContainerWhite');
			}
		}
		
		if (window.jQuery) {		
			$(window).on('load',function(){
				enableProsisHelpCloseOnOutClick();
			});
		}
		
	</cfoutput>
	
	// Script for print option
	 
	function printDiv(divName) {
		try {
			var oIframe = document.getElementById('printFrame');				
			var printContents = document.getElementById(divName).innerHTML;						
       		var oDoc = (oIframe.contentWindow || oIframe.contentDocument);								
   			if (oDoc.document) 
			    oDoc = oDoc.document;
				oDoc.write("<ht"+"ml><he"+"ad><ti"+"tle>title</tit"+"le>");				
				oDoc.write("<li"+"nk href='<cfoutput>#SESSION.root##client.style#</cfoutput>' rel='stylesheet' type='text/css' /></he"+"ad><bo"+"dy onl"+"oad='this.focus(); this.print();'>");				
				oDoc.write(printContents + "</bo"+"dy></ht"+"ml>");	   
				oDoc.close();			
			}
		catch (e){alert('Print wrapper cannot be found\nPlease consult your Focal Point');}
		}
	
	function doPrint() {
		//Do the actual Print Job
		document.getElementById('printingprogress').style.display = 'none';
		var printFrame = document.getElementById('printFrame');
		printFrame.contentWindow.focus();
		printFrame.contentWindow.print();
		try {document.body.removeChild(document.getElementById('printFrame'))} catch(e){};
		}

	function printcallbackhandler(){
		//Acertain loading status, browser dependent
		//for a guaranteed approach we insert html at the bottom of the template and do a js search. '</print>'
		if (navigator.appName == 'Microsoft Internet Explorer') { 
			 if(document.getElementById('printFrame').readyState != "complete"){setTimeout('printcallbackhandler()', 1000);}
			 else if (window.printFrame.document.body.innerHTML == "") {setTimeout('printcallbackhandler()', 1000);}
			 else if (window.printFrame.document.body.lastChild == null) {setTimeout('printcallbackhandler()', 500);}
			 else {setTimeout('doPrint()', 2000);}
		} else {
			try
			  { if (window.printFrame.document.body.lastChild == null) {setTimeout('printcallbackhandler()', 500);}	
			  //Print content must have at least 1 table with this approach
			  	else if(window.printFrame.document.body.innerHTML.search('</table>') == "-1"){setTimeout('printcallbackhandler()', 500);}			
				else {setTimeout('doPrint()', 1000);}
			  }
			catch(err) 
			  { setTimeout('printcallbackhandler()', 500);}		
		}
	}
	
	function doTheIframe(templateName, width, height) {
		_cf_loadingtexthtml="<div style='display:none'></div>";
		ColdFusion.navigate('<cfoutput>#SESSION.root#</cfoutput>/Tools/Print/PrintProgress.cfm','printprogressstatus');
		_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";	
			//Create iframe in Browser DOM and populate	
			ifrm = document.createElement("iframe");
			ifrm.setAttribute("name", "printFrame");
			ifrm.setAttribute("id", "printFrame");
			ifrm.setAttribute("src", templateName);
			ifrm.style.width = width;
			ifrm.style.height = height;
				try {document.body.removeChild(document.getElementById('printFrame'))} catch(e){};
			document.body.appendChild(ifrm);
			printcallbackhandler();
		}
		
	// End cf_print JS Functions
		
	// checks the refresh connection status from the refresh object Connection.cfc 
		   
	function connectioncontroller(object,scopeid) {	  
		if (document.getElementById('connection_controller_box')) {				
			ColdFusion.navigate('<cfoutput>#SESSION.root#</cfoutput>/Component/Connection/Connection.cfc?method=performcheck&object='+object+'&scopeid='+scopeid,'connection_controller_box')	 		 													
		}
	 }			
	
	// to be removed, this is the batres button which was deprecated 
		
	// Start cf_button JS Functions
	function hlbg(left,center,right,mode)   {	
		document.getElementById(left).className = mode+'buttonhlleft';
		document.getElementById(center).className = mode+'buttonhlcenter';
		document.getElementById(right).className = mode+'buttonhlright';			
		}	

	function regbg(left,center,right,mode)   {		
		document.getElementById(left).className = mode+'buttonleft';
		document.getElementById(center).className = mode+'buttoncenter';
		document.getElementById(right).className = mode+'buttonright';		
		}

	function downbg(left,center,right,mode)   {		
		document.getElementById(left).className = mode+'buttondownleft';
		document.getElementById(center).className = mode+'buttondowncenter';
		document.getElementById(right).className = mode+'buttondownright';			
		}
		
	// End cf_button JS Functions	
	
</script>

